######################################################################
# rss10page.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: rss10page.inc.pl,v 1.377 2012/01/31 18:43:44 papu Exp $
#
# "PyukiWiki" version 0.2.0-p1 $$
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
# Return:LF Code=Shift-JIS 1TAB=4Spaces
######################################################################
# description‚Ìs”‚ðŽw’è
$rss10page::description_line=5
	if(!defined($rss10page::description_line));
######################################################################
use Yuki::RSS;
use Nana::Cache;
use Time::Local;
sub plugin_rss10page_convert {
	my ($mode) = split(/,/, shift);
	my $cache=new Nana::Cache (
		ext=>"showrss",
		files=>1000,
		dir=>$::cache_dir,
		size=>200000,
		use=>1,
		expire=>3600,
	);
	my $file=&dbmname($::form{mypage});
	if(lc $mode eq 'delete') {
		$cache->delete($file);
		return ' ';
	}
	my $buf=&plugin_rss10page_makerss($::form{mypage});
	$buf=~s/[\xd\xa]//g;
	$buf =~ s/<!\[CDATA\[(.+)\]\]>/$1/g;
	$cache->write($file,&replace($buf));
	$::IN_HEAD.=<<EOM if($::rss_lines>0);
<link rel="alternate" type="application/rss+xml" title="RSS" href="?cmd=rss10page&amp;mypage=@{[&encode($::form{mypage})]}@{[$_exec_plugined{lang} > 1 ? "&amp;lang=$::lang" : ""]}" />
EOM
	return ' ';
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
	return $xmlStream;
}
sub plugin_rss10page_makerss {
	my($page)=@_;
	if($::_exec_plugined{lang} > 1) {
		$::modifier_rss_link=$::modifier_rss_link{$::lang} ne '' ? $::modifier_rss_link{$::lang}: $::modifier_rss_link ne '' ? $::modifier_rss_link : $::basehref;
	} else {
		$::modifier_rss_link=$::modifier_rss_link ne '' ? $::modifier_rss_link : $::basehref;
	}
	my $data=$::database{$page};
	my $option;
	foreach (split(/\n/, $data)) {
		if(/$::embed_plugin/) {
			if($1 eq 'rss10page') {
				$option=$3;
				last;
			}
		}
	}
	if($option!~/[-*]/) {
		&print_error("rss10page:not setting selection target<br />Usage : #rss10page([-*] or delete);");
	}
	$option=~s/(.)/'\\x' . unpack('H2', $1)/eg;
	my $count = 0;
	my $lines=0;
	my $gmt;
	my $date;
	my $defaultlink=$::modifier_rss_link . '?' . &encode($page);
	my $link;
	my $escaped_title;
	my $rss = new Yuki::RSS(
		version => '1.0',
		encoding => $::charset,
	);
	$rss->channel(
		title => "$::modifier_rss_title - $page",
		link  => $link,
		description => &get_subjectline($page)
	);
	foreach my $line(split(/\n/, $data)) {
		last if ($count > $::rss_lines + 1);
		if($line=~/^$option\s*(\d\d\d\d\-\d\d\-\d\d)\(.+\) (\d\d:\d\d:\d\d)\s*\[\[(.*)\]\]/) {
			if($lines) {
				&plugin_rss10page_additem($rss,$escaped_title,$link,$description,$date);
				$description='';
			}
#			$gmt = ((localtime(time))[2] + (localtime(time))[3] * 24)
#				- ((gmtime(time))[2] + (gmtime(time))[3] * 24);
			$gmt=&gettz;
			$date = $1 . "T" . $2 . sprintf("+%02d:00", $gmt);
			my $tmp=&make_link($3);
			$escaped_title=$tmp;
			$escaped_title=~s/<.*?>//g;
			$escaped_title=~s/~$//g;
			$link=$tmp;
			$link=~s/.*href="(.+?)".*/$1/g;
			$link=~s/^\///g;
			$link="$basehref$link" if($link!~/$::isurl/);
			$count++;
			$lines=1;
		} elsif($line=~/^$option\s*(\d\d\d\d\-\d\d\-\d\d)\(.+\) (\d\d:\d\d:\d\d)\s*(.*)/) {
			if($lines) {
				&plugin_rss10page_additem($rss,$escaped_title,$link,$description,$date);
				$description='';
			}
			$link=$defaultlink;
#			$gmt = ((localtime(time))[2] + (localtime(time))[3] * 24)
#				- ((gmtime(time))[2] + (gmtime(time))[3] * 24);
			$gmt=&gettz;
			$date = $1 . "T" . $2 . sprintf("+%02d:00", $gmt);
			$escaped_title=$3;
			$escaped_title=~s/~$//g;
			$count++;
			$lines=1;
		} elsif($line=~/^[ \*\-: |]/) {
			&plugin_rss10page_additem($rss,$escaped_title,$link,$description,$date)
				if($lines);
			$lines=0;
			$count++;
			$description='';
		} elsif($lines) {
			my $tmp=&text_to_html($line);
			$tmp=~s/[\xd\xa]//g;
			$tmp=~s/<.*?>//g;
			$tmp=&trim($tmp);
			next if($tmp eq '');
			$description.=$lines eq 1 ? $tmp : "\n$tmp";
			if($description ne '' && $lines++ >= $::rss_lines) {
				$lines=0;
				&plugin_rss10page_additem($rss,$escaped_title,$link,$description,$date);
				$count++;
				$description='';
			}
		}
	}
	my $body=$rss->as_string;
	return $body;
}
%::rss10page_dates;
sub plugin_rss10page_additem {
	my($rss,$escaped_title,$link,$description,$date)=@_;
	if($escaped_title eq '') {
		$escaped_title=$description;
		$escaped_title=~s/\n.*//g;
		$escaped_title=~s/<br \/>//g;
	}
	$escaped_title=&trim($escaped_title);
	$description=~s/\n/<br \/>\n/g;
	$description= qq(<![CDATA[) .$description . qq(]]>)
		if($description=~/\n/);
	$rss->add_item(
		title => $escaped_title,
		link  => $link,
		description => $description,
		dc_date => $date
	);
}
sub plugin_rss10page_action {
	if(!&is_exist_page($::form{mypage})) {
		&print_error("Page not found : " . $::form{mypage});
	}
	my $body=&plugin_rss10page_makerss($::form{mypage});
	if($::lang eq 'ja' && $::defaultcode ne $::kanjicode) {
		$body=&code_convert(\$body,   $::kanjicode);
	}
	&gzip_init;
	if($::gzip_header ne '') {
		print &http_header(
			"Content-type: text/xml; charset=$::charset", $::gzip_header);
	} else {
		print &http_header(
			"Content-type: text/xml; charset=$::charset");
	}
	&compress_output($body);
	&close_db;
	exit;
}
1;
__END__
