######################################################################
# ping.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: ping.inc.pl,v 1.29 2012/03/18 11:23:50 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
# Author: Nanami http://nanakochi.daiba.cx/
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
# Return:LF Code=Shift-JIS 1TAB=4Spaces
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'ping.inc.cgi'
######################################################################
$ping::titleformat="__mypage__ - __wikititle__";
if(!defined($ping::serverlist)) {
$ping::serverlist=<<EOM;
http://api.my.yahoo.co.jp/RPC2
http://blogsearch.google.co.jp/ping/RPC2
http://rpc.reader.livedoor.com/ping
http://blog.goo.ne.jp/XMLRPC
http://ping.fc2.com
http://ping.rss.drecom.jp/
http://ping.dendou.jp/
http://ping.freeblogranking.com/xmlrpc/
EOM
$ping::serverlist.=<<EOM if($::rss_lines > 0);
http://api.my.yahoo.co.jp/rss/ping?u=__RSSURIENC__
EOM
}
#$ping::wait=1;
$ping::wait=30*60
	if(!defined($ping::wait));
$ping::timeout=5
	if(!defined($ping::timeout));
#TE: deflate,gzip;q=0.3
#Connection: TE, close
#Host: __HOSTNAME__
#User-Agent: PyukiWiki
$ping::pagesave;
%ping::sentserver;
use strict;
my $lastmod_org;
sub plugin_ping_init {
	&exec_explugin_sub("lang");
	&exec_explugin_sub("urlhack");
	&exec_explugin_sub("autometarobot");
	$lastmod_org = $::database{"__update__" . $::form{mypage}}
		if(&is_exist_page($::form{mypage}));
	return ('init'=>1
		, 'func'=>'do_write', 'do_write'=>\&do_write
		, 'last_func'=>'&send_ping_main;');
}
sub send_ping_rpc {
	my($rpcurl,$name,$url,$rssurl)=@_;
	$rpcurl=~s/\/$//g;
	return if($ping::sentserver{$rpcurl} ne '');
	$ping::sentserver{$rpcurl}=$rpcurl;
	&load_module("XMLRPC::Lite");
	&load_module("Nana::HTTP");
	my $result;
	eval {
		local $SIG{ALRM}=sub { die "timeout" };
		alarm($ping::timeout);
		my $tmp = eval {
			XMLRPC::Lite
				->proxy($rpcurl)
				->call(
					'weblogUpdates.ping', $name, $url
					, $url, $rssurl
				)
				->result;
		};
		if ($@) {
			$result=$@;
		} else {
			$result=$tmp->{message};
		}
		$result=~s/<.*//g;
		$result=~s/\n.*//g;
		alarm 0;
	};
	alarm 0;
	if($@) {
		if($@=~/timeout/) {
			return(1,"Timeout");
		}
	}
	my $test=lc $result;
	if($test=~/thank/ && $test=~/ping/
		|| $test=~/successfully/ && $test=~/refresh/ && $test=~/requested/) {
		return (0,$result);
	}
	return (1,$result);
}
sub send_ping_main {
	my($page)=$ping::pagesave;
	return if($page eq '');
	close(STDOUT);
	close(STDERR);
	my $results;
	my $pid=fork;
	if($pid) {
	} else {
		foreach my $server(split(/\n/,$ping::serverlist)) {
			my %val;
			next if($server!~/$::isurl/);
			$val{RSSURI}="$::basehref?cmd=rss10@{[$::_exec_plugined{lang} > 1 ? '&amp;lang=$::lang' : '']}";
			$val{RSSURIENC}=&encode($val{RSSURI});
			$server=&replace($server,%val);
			$val{mypage}=$page;
			$val{wikititle}=$::wiki_title;
			my $title=&replace($ping::titleformat,%val);
			$val{TITLE}=&code_convert(\$title,'utf8',$::defaultcode);
#			$val{TITLE}=$title;
			$val{URL}=$::bxasehref;
			my($stat,$result)=&send_ping_rpc($server, $val{TITLE}, $val{URL}, $val{RSSURI});
			if($stat eq 0) {
				$results.="Sent $server\n";
			} else {
				$results.="Error $server\n($result)\n";
			}
		}
		&load_module("Nana::Mail");
		my $mailtitle;
		$mailtitle=&code_convert(\$ping::pagesave,'jis',$::defaultcode);
		Nana::Mail::toadmin("ping", $mailtitle, "Ping sent results\n$results");
	}
}
sub send_ping {
	my($page)=@_;
	return if(!&is_exist_page($page));
	my $lastmod = $::database{"__update__" . $page};
	if(time < $lastmod_org + $ping::wait) {
		my $msg=<<EOM;
Ping waiting @{[&date($::lastmod_format, $lastmod + $ping::wait)]}
EOM
		&load_module("Nana::Mail");
		Nana::Mail::toadmin("ping", $page, $msg);
		return;
	}
	if(&load_module("XMLRPC::Lite")) {
		$ping::pagesave=$page;
	} else {
		&load_module("Nana::Mail");
		Nana::Mail::toadmin("ping", $page, "Can't send ping. please install XMLRPC::Lite (in SOAP::Lite)");
	}
}
sub replace {
	my ($str,%ref)=@_;
	foreach my $key(keys %ref) {
		$str=~s/\_\_$key\_\_/$ref{$key}/g;
	}
	return $str;
}
sub do_write_after {
	my($page, $mode)=@_;
	if($page ne '' && $mode ne "Delete") {
		if($::form{mypage}=~/$::resource{help}|$::resource{rulepage}|$::RecentChanges|$::MenuBar|$::SideBar|$::TitleHeader|$::Header|$::Footer$::BodyHeader$::BodyFooter|$::SkinFooter|$::SandBox|$::InterWikiName|$::InterWikiSandBox|$::non_list/
			|| $::meta_keyword eq "" || lc $::meta_keyword eq "disable"
			|| &is_readable($::form{mypage}) eq 0) {
			return;
		}
		&send_ping($page);
	}
}
1;
__DATA__
sub plugin_ping_setup {
	return(
	'en'=>'Send ping.',
	'jp'=>'ping‚ð‘—M‚·‚é,
	'override'=>'do_write',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/ping/'
	);
__END__
