######################################################################
# HTTP.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: HTTP.pm,v 1.333 2012/03/18 11:23:56 papu Exp $
#
# "Nana::HTTP" ver 0.7 $$
# Author: Nanami
# http://nanakochi.daiba.cx/
# Copyright (C) 2004-2012 Nekyo
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2012 PyukiWiki Developers Team
# http://pyukiwiki.sfjp.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sfjp.jp/
# License: GPL3 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################
package	Nana::HTTP;
use 5.005;
use strict;
use strict;
use Socket 1.3;
use Fcntl;
use Errno qw(EAGAIN);
use HTTP::Lite;
use vars qw($VERSION);
$VERSION = '0.7';
# 0:付属エンジン(HTTP::Lite) 1:LWPが存在すればLWP、なければ付属エンジン
$Nana::HTTP::useLWP=0;
# ユーザーエージェント
$Nana::HTTP::UserAgent="$::package/$::version \@\@";
# タイムアウト
$Nana::HTTP::timeout=2;
######################################################################
my $timeoutflag=0;
sub new {
	my ($class, %hash) = @_;
	my $self = {
		plugin => $hash{plugin},
		module => $hash{module},
		ua => $hash{ua},
		header => $hash{header},
		user => $hash{user},
		pass => $hash{pass},
	};
	$$self{lwp_ok}=0;
	if($Nana::HTTP::useLWP eq 1) {
		if(&load_module("LWP::UserAgent") && &load_module("HTTP::HEADERS")) {
			$$self{lwp_ua}=LWP::UserAgent->new;
			$$self{_ua} = &makeua($$self{lwp_ua}->_agent,%hash),
			$$self{_header} = "User-Agent: " . $$self{_ua} . $$self{header};
			$$self{lwp_ua}->agent($$self{_ua});
			$$self{lwp_ua}->timeout($Nana::HTTP::timeout);
			if($::proxy_host ne '') {
				foreach("http", "https", "ftp") {
					$$self{lwp_ua}->proxy($_,"http://$::proxy_host:$::proxy_port/")
				}
			}
			$$self{lwp_ok}=1;
		}
	}
	if($$self{lwp_ok} ne 1) {
		$$self{lwp_ok}=0;
		$$self{_ua} = &makeua("",%hash),
		$$self{_header} = "User-Agent: " . $$self{_ua} . $$self{header};
	}
	return bless $self, $class;
}
sub load_module {
	my $funcp = $::functions{"load_module"};
	return &$funcp(@_);
}
sub head {
	my($self, $uri)=@_;
	if($$self{lwp_ok} eq 1) {
		my $req;
		if($$self{user} . $$self{pass} ne '') {
			my $header=HTTP::Headers->new;
			$header->authorization_basic($$self{user},$$self{pass});
			$req=HTTP::Request->new(HEAD => $uri, $header);
		} else {
			$req=HTTP::Request->new(HEAD => $uri);
		}
		my $res=$$self{lwp_ua}->request($req);
		if($res->is_success) {
			return(0,$res->content);
		} else {
			return(1,$res->status_line);
		}
	}
	return &httpcl($uri,"HEAD", $$self{_header});
}
sub get {
	my($self, $uri)=@_;
	if($$self{lwp_ok} eq 1) {
		my $req;
		if($$self{user} . $$self{pass} ne '') {
			my $header=HTTP::Headers->new;
			$header->authorization_basic($$self{user},$$self{pass});
			$req=HTTP::Request->new(GET => $uri, $header);
		} else {
			$req=HTTP::Request->new(GET => $uri);
		}
		my $res=$$self{lwp_ua}->request($req);
		if($res->is_success) {
			return(0,$res->content);
		} else {
			return(1,$res->status_line);
		}
	}
	return &httpcl($uri,"GET", $$self{_header});
}
sub post {
	my($self, $uri, $postdata)=@_;
	if($$self{lwp_ok} eq 1) {
		my $header;
		my $req;
		if($$self{user} . $$self{pass} ne '') {
			$header=HTTP::Headers->new;
			$header->authorization_basic($$self{user},$$self{pass});
		}
		$req=HTTP::Request->new(POST => $uri, $header);
		$req->content_type('application/x-www-form-urlencoded');
		$req->content($postdata);
		my $res=$$self{lwp_ua}->request($req);
		if($res->is_success) {
			return(0,$res->content);
		} else {
			return(1,$res->status_line);
		}
	}
	return &httpcl($uri,"POST", $$self{_header}, $postdata);
}
sub makeua {
	my($add,%self)=@_;
	my $ua;
	my $mods;
	if($self{ua} eq '') {
		$ua=$Nana::HTTP::UserAgent;
		if($self{plugin} ne '') {
			$mods=" Plugin $self{plugin};";
		} elsif($self{module} ne '') {
			$mods=" Module $self{module};";
		}
		$ua=~s/\@\@/$mods@{[$add ne '' ? " $add" : '']}/g;
	} else {
		$ua=$self{ua};
	}
	return "$::package/$::version ($::basehref $ua)";
}
sub httpcl {
	my($url,$method,$header,$postdata)=@_;
	my $stat;
	my $body;
	eval {
		local $SIG{ALRM}=sub { die "timeout" };
		alarm($Nana::HTTP::timeout);
		my $http=new HTTP::Lite;
		$method="GET" if($method eq '');
		$http->method($method);
		$http->http11_mode(1);
		foreach(split(/\n/,$header)) {
			my($hn,$hv)=split(/:\s/,$_);
			$http->add_req_header($hn,$hv) if($_=~/:/);
		}
		if($::proxy_host ne '' && $::proxy_port > 0) {
			$http->proxy("http://$::proxy_host:$::proxy_port");
		}
		if($postdata ne '') {
			$http->prepare_post($postdata);
		}
		my $req=$http->request($url);
		if($req eq 200) {
			$stat=0;
			$body=$http->body();
		} else {
			$stat=1;
			$body="Error $req";
		}
		alarm 0;
	};
	alarm 0;
	if($@) {
		if($@=~/timeout/) {
			return(1,"Timeout $url");
		}
	}
	return($stat,$body);
}
1;
__END__
