######################################################################
# showrss.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: showrss.inc.pl,v 1.336 2012/03/18 11:23:57 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
# Author: Nekyo http://nekyo.qp.land.to/
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
use strict;
use Nana::Cache;
use Nana::HTTP;
sub plugin_showrss_inline
{
	return &plugin_showrss_convert(shift);
}
sub plugin_showrss_convert {
	my ($rssuri,$tmplname,$usecache,$dateflag,$discflag,$domain) = split(/,/, shift);
	return if($rssuri eq '');
	my $expire = $usecache * 3600;
	my $cachefile = &dbmname($rssuri);
	my $stream="";
	my $result;
	my $body = "";
	my $cache=new Nana::Cache (
		ext=>"showrss",
		files=>100,
		dir=>$::cache_dir,
		size=>100000,
		use=>($usecache eq '0' ? 0 : 1),
		expire=>($expire+0 <= 0 ? 3600 : $expire),
	);
	my $buf=$cache->read($cachefile,1);
	if($rssuri!~/$::isurl/) {
		return &makebody($buf,$tmplname,$dateflag,$discflag,$domain);
	}
	if($cache->read($cachefile) ne '') {
		return &makebody($buf,$tmplname,$dateflag,$discflag,$domain);
	}
	my $pid;
	if($buf ne '') {
		$cache->write($cachefile,$buf);
		$pid=fork;
	}
	$result=0;
	unless(defined $pid) {
		($result,$stream)=&plugin_showrss_sub($rssuri);
		$cache->write($cachefile,$stream) if($result eq 0);
		if($result ne 0) {
			return qq(#showrss: $stream : $rssuri);
		}
		return &makebody($stream,$tmplname,$dateflag,$discflag,$domain);
	} else {
		if($pid) {
			local $SIG{ALRM} = sub { die "time out" };
			eval {
				alerm(1);
				wait;
				alerm(0);
			};
			if ($@ =~ /time out/) {
				return &makebody($buf,$tmplname,$dateflag,$discflag,$domain);
			} else {
				return &makebody($cache->read($cachefile,1),$tmplname,$dateflag,$discflag,$domain);
			}
		} else {
			close(STDOUT);
			($result,$stream)=&plugin_showrss_sub($rssuri);
			$cache->write($cachefile,$stream) if($result eq 0);
			exit;
		}
	}
}
sub makebody {
	my($stream,$tmplname,$dateflag,$discflag,$domain)=@_;
	my $body;
	my %xml = &xmlParser($stream);
	my @title = split(/\n/,
		($xml{'rdf:RDF/item/title'} ne ""
		? $xml{'rdf:RDF/item/title'} : $xml{'rss/channel/item/title'}
		)
	);
	my @date = split(/\n/,
		($xml{'rdf:RDF/item/dc:date'} ne ""
		? $xml{'rdf:RDF/item/dc:date'} : $xml{'rss/channel/dc:date'}
		)
	);
	my @link = split(/\n/,
		($xml{'rdf:RDF/item/link'} ne ""
		? $xml{'rdf:RDF/item/link'} : $xml{'rss/channel/item/link'}
		)
	);
	my @desc;
	if($discflag eq 1) {
		@desc = split(/\n/,
			($xml{'rdf:RDF/item/description'} ne ""
			? $xml{'rdf:RDF/item/description'}
			: $xml{'rss/channel/item/description'}
			)
		);
	}
	my ($footer, $ll, $lr);
	if (lc $tmplname eq "menubar") {
		$body .=<<"EOD";
<div class="small">
<ul class="recent_list">
EOD
		$ll = "<li>";
		$lr = "</li>\n";
		$footer = "</ul>\n</div>\n";
	} elsif (lc $tmplname eq "recent") {
		$body .=<<"EOD";
<div class="small">
<string>$date[0]</strong>
<ul class="recent_list">
EOD
		$ll = "<li>";
		$lr = "</li>\n";
		$footer = "</ul>\n</div>\n";
	} elsif (lc $tmplname eq "body") {
		$body .=<<"EOD";
<div>
<ul class="recent_list">
EOD
		$ll = "<li>";
		$lr = "</li>\n";
		$footer = "</ul>\n</div>\n";
	} else {
		$ll = $footer = "";
		$lr = "<br />\n";
	}
	my $count = 0;
	my $dt;
	foreach (@title) {
		if($dateflag >= 2) {
			my $tm=$date[$count];
			if($tm ne '') {
				$tm=~/^(\d{4})\-(\d{1,2})\-(\d{1,2})T(\d{1,2})\:(\d{1,2})\:(\d{1,2})(?:\+)(\d{1,2})\:(\d{1,2})/;
				$tm=eval {Time::Local::timegm($6,$5,$4,$3,$2-1,$1-1900)-$7*3600-$8*60; };
				$dt=&date($::date_format . ($dateflag eq 3 ? " $::time_format" : ""),$tm) . " ";
				$dt=&date($::date_format . ($dateflag eq 3 ? " $::time_format" : ""),$tm) . " ";
			} else {
				$dt='';
			}
		}
		if($discflag) {
			$domain=$ENV{HTTP_HOST} if($domain eq '');
			if($link[$count]=~/https?\:\/\/$domain\//) {
				$body .=<<"EOD";
$ll@{[&make_link_url("ext",$link[$count],$dt . $title[$count],"","_self")]}<br />$desc[$count]$lr
EOD
			} else {
				$body .=<<"EOD";
$ll@{[&make_link_url("ext",$link[$count],$dt . $title[$count],"","_blank")]}<br />$desc[$count]$lr
EOD
			}
		} else {
			if($link[$count]=~/https?\:\/\/$domain\//) {
				$body .=<<"EOD";
$ll@{[&make_link_url("ext",$link[$count],$dt . $title[$count],"","_self")]}$lr
EOD
			} else {
				$body .=<<"EOD";
$ll@{[&make_link_url("ext",$link[$count],$dt . $title[$count],"","_blank")]}$lr
EOD
			}
		}
		$count++;
	}
	$body .= $footer;
	return $body;
}
sub plugin_showrss_sub {
	my($rssuri)=@_;
	my $code = 'utf8';
	my ($result, $stream);
	my $http=new Nana::HTTP('plugin'=>"showrss");
	($result, $stream) = $http->get($rssuri);
	$stream=~s/[\xd\xa]//g;
	return($result, $stream) if ($result != 0); # $stream is errorcode.
	if($stream=~/encoding="[Ee][Uu][Cc]/) {
		$code="euc";
	} elsif($stream=~/encoding="[Ss][Hh][Ii][Ff][Tt]/) {
		$code="sjis";
	} else {
		$code="utf8";
	}
	$stream = &replace(&code_convert(\$stream,$::defaultcode, $code));
	return ($result,$stream);
}
sub replace {
	my ($xmlStream) = @_;
	$xmlStream =~ s/<\?(.*)\?>//g;
	$xmlStream =~ s/<rdf:RDF(.*?)>/<rdf:RDF>/g;
	$xmlStream =~ s/<rss(.*?)>/<rss>/g;
	$xmlStream =~ s/<channel(.*?)>/<channel>/g;
	$xmlStream =~ s/<item(.*?)>/<item>/g;
	$xmlStream =~ s/<content:encoded>(.*?)<\/content:encoded>//g;
	$xmlStream =~ s/\ *\/>/\/>/g;
	$xmlStream =~ s/<([^<>\ ]*)\ ([^<>]*)\/>/<$1>$2<\/$1>/g;
	$xmlStream =~ s/<([^<>\/]*)\/>/<$1><\/$1>/g;
	$xmlStream =~ s/<!\[CDATA\[(.+)\]\]>/$1/g;
	return $xmlStream;
}
sub xmlParser {
	my ($stream) = @_;
	my ($i, $ch, $name, @node, $val, $key, %xml);
	my $flg = 0;
	$stream=~s/<br><\/br>/\r/g;
	foreach $i (0..length $stream) {
		$ch = substr($stream, $i, 1);
		if ($ch eq '<') {
			$flg = 1;
			undef $name;
			foreach (@node) {
				$name .= "$_/";
			}
			chop $name;
			$val =~ s/<//g;
			$val =~ s/>//g;
			$val =~ s/\r/<br \/>/g;
			$xml{$name} .= "$val\n";
			undef $val;
		}
		if ($flg) {
			$key .= $ch;
		} else {
			$val .= $ch;
		}
		if ($ch eq '>') {
			$flg = 0;
			if ($key =~ /\//) {
				pop @node;
			} else {
				$key =~ s/<//g;
				$key =~ s/>//g;
				push @node, $key;
			}
			undef $key;
		}
	}
	return %xml;
}
1;
