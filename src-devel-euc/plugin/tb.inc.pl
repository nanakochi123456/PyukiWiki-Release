######################################################################
# tb.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: tb.inc.pl,v 1.30 2012/03/18 11:23:51 papu Exp $
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
#
# トラックバックプラグイン
#
######################################################################

use strict;
require "$::plugin_dir/contents.inc.pl";

$tb::date_long_format= "Y-m-d(lL) H:i:s"
	if(!defined($tb::date_long_format));

$tb::waitpost=3*60
	if(!defined($tb::waitpost));

sub plugin_tb_action {
	my $path="$::res_dir/trackback.$::lang.txt";
	%::resource = &read_resource($path,%::resource) if(-r $path);

	if($ENV{REQUEST_METHOD} eq "GET") {
		if($::form{__mode} eq "view") {
			my %ret=&plugin_tb_get_view;
			return('msg'=>$ret{msg}, 'body'=>$ret{body});
		} elsif($::form{__mode} eq "rss") {
		} else {
			return('msg'=>$::resource{trackback_plugin_title}, 'body'=>$::resource{trackback_plugin_parmerr});
		}
	} elsif($ENV{REQUEST_METHOD} eq "POST") {
		my %ret=&plugin_tb_post;
		return('msg'=>$ret{msg}, 'body'=>$ret{body});
	}
}

sub plugin_tb_get_view {
	return('msg'=>"\t$::resource{trackback_plugin_title}",'body'=>$::resource{trackback_plugin_notload})
		if ($trackback::directory eq '');

	&dbopen($trackback::directory,\%::trackbackbase);
	my @pagelist;
	my %trackbacks;
	if($::form{tb_id} ne '') {
		my $tbpage=&tb_id2page($::form{tb_id});
		$trackback::md5pagename=$::form{tb_id};
		if(&chkpage($tbpage) eq 0) {
			my $tmp=$::trackbackbase{$tbpage};
			if($tmp ne '') {
				return('msg'=>"\t$::resource{trackback_plugin_title}",'body'=>$::resource{trackbackplugin_notcompatible})
					if($tmp!~/,/);
			}
			my $title=$::resource{trackbackplugin_pagelist};
			$title=~s/\$PAGE/\[\[$tbpage\]\]/g;
			my $wiki=<<EOM;
*$title
----
EOM
			$wiki.=&plugin_tb_add($::trackbackbase{$tbpage},$tbpage,'+',1);
			my $html="\n" . &text_to_html($wiki);
			$html.=&plugin_tb_displaylink;
			return('msg'=>"\t$::resource{trackback_plugin_title}",'body'=>$html);
		} else {
			return('msg'=>"\t$::resource{trackback_plugin_title}",'body'=>$::resource{trackback_plugin_cantdisplay} . " ");
		}
	} else {
		foreach my $tbpage (keys %::trackbackbase) {
			my $tmp=$::trackbackbase{$tbpage};
			if($tmp ne '') {
				return('msg'=>"\t$::resource{trackback_plugin_title}",'body'=>$::resource{trackbackplugin_notcompatible})
					if($tmp!~/,/);
				push(@pagelist,$tbpage);
				$trackbacks{$tbpage}=$tmp;
			}
		}
		my $wikitop=<<EOM;
*$::resource{trackbackplugin_allpagelist}
----
EOM
		my $wiki;
		@pagelist=sort @pagelist;
		foreach my $page(@pagelist) {
			next if(&chkpage($page) eq 1);

			$wiki.=<<EOM;
**[[$page>$page]]
EOM
			$wiki.=&plugin_tb_add($::trackbackbase{$page},$page,'+',1);
			$wiki.="----\n";
		}
		$wiki=~s/\-\-\-\-\n$//g;
		my $query=&htmlspecialchars($ENV{QUERY_STRING});
		my $html=&text_to_html("$wikitop\ntrackbackdummycontents\n----\n$wiki");
		my $contents=&plugin_contents_main("?$query", split(/\n/, "$wikitop\n$wiki"));
		$html=~s/trackbackdummycontents/$contents/g;
		return('msg'=>"\t$::resource{trackback_plugin_title}",'body'=>$html);
	}
}

sub plugin_tb_add {
	my($tb,$page,$ch,$flg,$maxcount)=@_;
	my $wiki;

	return "" if(&chkpage($::pushedpage eq "" ? $page : $page) eq 1);

	my @tb=reverse split(/\n/,$tb);
	if($tb eq '' && $flg eq 1) {
		my $title=$::resource{trackbackplugin_nodata};
		$title=~s/\$PAGE/\[\[$page\]\]/g;
		return $title;
	}
	my $count=0;
	foreach my $line(@tb) {
		last if($maxcount+0 ne 0 && $count++ >= $maxcount+0);
		my($time,$url,$title,$except,$blog_name,$remote_host)=split(/,/,$line);
		my $dt=&date($tb::date_long_format, $time);
		$except=~s/^\s+$//g;
		$wiki.=<<EOM;
$ch\[[$title>$url]]@{[$blog_name ne '' ? " $blog_name" : ""]} &new{$dt};@{[$except ne '' ? "&br;" : ""]}
EOM
		$wiki.="$except\n" if($except ne '');
	}
	return $wiki;
}

sub plugin_tb_post {
	my $tb_url=$::form{url};
	&load_module("Nana::HTTP");
	&plugin_tb_post_xml("notbid") if($::form{tb_id} eq '');
	&plugin_tb_post_xml("nourl") if($::form{url}!~/$::isurl/);
	&plugin_tb_post_xml("nourl") if($::form{url}!~/^https?/);

	my $http=new Nana::HTTP('plugin'=>"tb");
	my ($result, $stream) = $http->get($tb_url);
	&plugin_tb_post_xml("timeout") if($result ne 0);

	$stream=~s/[\xd\xa]//g;
	my $tmp=&htmlspecialchars("$::form{title}\f$::form{except}\f$::form{blog_name}");
	$tmp=~s/\,/\&x2c;/g;
	$tmp=&code_convert(\$tmp, $::defaultcode);
	my $chk=$tmp . &code_convert(\$stream, $::defaultcode);
	my $stat=&spam_filter($chk, 1, 0, 0, 1);
	&plugin_tb_post_xml($stat)	if($stat ne "");
	&plugin_tb_post_xml("nohtml") if($stream!~/<[Tt][Ii][Tt][Ll][Ee]/);
	&plugin_tb_post_xml("nohtml") if($stream!~/<[Hh][Tt][Mm][Ll]/);

	my($tb_title, $tb_except, $tb_blog_name, $tb_http_body)=split(/\f/,$tmp);
	if($tb_title eq '') {
		my $title=$tb_http_body;
		if($title=~/[Tt][Ii][Tt][Ll][Ee]/) {
			$title=~s/<\/[Tt][Ii][Tt][Ll][Ee]>.*//g;
			$title=~s/.*<[Tt][Ii][Tt][Ll][Ee](.+?)>//g;
			$title=~s/.*<[Tt][Ii][Tt][Ll][Ee]>//g;
			$tb_title=$title;
		}
	}
	&plugin_tb_post_xml("notitle") if($tb_title eq '');

	&dbopen($trackback::directory,\%::trackbackbase);

	foreach my $tbpage(keys %::trackbackbase) {
		$::form{url}=~ m!(https?:)?(//)?([^:/]*)?(:([	0-9]+)?)?(/.*)?!;
		my $host=$3;
		my $tb = $::trackbackbase{$tbpage};
		foreach my $line(split(/\n/,$tb)) {
			my($time,$url,$title,$except,$blog_name,$remote_host)=split(/,/,$line);
			$url=~ m!(https?:)?(//)?([^:/]*)?(:([	0-9]+)?)?(/.*)?!;
			my $_host=$3;
			&plugin_tb_post_xml("wait")
				if(time < $time + $tb::waitpost && $host eq $_host);
		}
	}
	my $tbpage=&tb_id2page($::form{tb_id});
	if($tbpage=~/SandBox|$::resource{help}|$::resource{rulepage}|$::MenuBar|$::non_list/
		|| $::meta_keyword eq "" || lc $::meta_keyword eq "disable"
		|| &is_readable($tbpage) eq 0) {
		&plugin_tb_post_xml("ignorepage");
	}

	my $tb = $::trackbackbase{$tbpage};
	foreach my $line(split(/\n/,$tb)) {
		my($time,$url,$title,$except,$blog_name,$remote_host)=split(/,/,$line);
		my $_url=$url;
		my $_tb_url=$tb_url;
		&plugin_tb_post_xml("exist") if($_url eq $_tb_url);

		$_url="$url/";
		&plugin_tb_post_xml("exist") if($_url eq $_tb_url);

		$_url="$url";
		$_tb_url="$tb_url/";
		&plugin_tb_post_xml("exist") if($_url eq $_tb_url);

		$_url=$url;
		$_url=~s/\/$//g;
		$_tb_url=$tb_url;
		&plugin_tb_post_xml("exist") if($_url eq $_tb_url);

		$_url=$url;
		$_tb_url="$tb_url";
		$_tb_url=~s/\/$//g;
		&plugin_tb_post_xml("exist") if($_url eq $_tb_url);
	}
	my $mailbody=<<EOM;
$tb_url
$tb_title
$tb_except
$tb_blog_name
EOM
	&send_mail_to_admin($tbpage, "Trackback", $mailbody);

	my $tb_time=time;
	$tb.=<<EOM;
$tb_time,$tb_url,$tb_title,$tb_except,$tb_blog_name,$ENV{REMOTE_ADDR}
EOM
	$::trackbackbase{$tbpage}=$tb;
	&plugin_tb_post_xml("ok");
}

sub plugin_tb_post_xml {
	my ($stat)=@_;
	my $xml;
	my %tb_err=(
		"notbid"=>"No trackback ID",
		"timeout"=>"Timeout",
		"notitle"=>"Not found html title",
		"exist"=>"Exist trackback",
		"wait"=>"Waiting",
		"nourl"=>"Not URL",
		"spam"=>"Forbidden",
		"Over http"=>"Forbidden",
		"Over Mail"=>"Forbidden",
		"No Japanese"=>"Forbidden",
		"nohtml"=>"No html",
		"ignorepage"=>"Forbidden",
	);
	if($stat eq "ok") {
		$xml=<<EOM;
<?xml version="1.0" encoding="UTF-8" ?>
<response><error>0</error></response>
EOM
	} else {
		$xml=<<EOM;
<?xml version="1.0" encoding="iso-8859-1" ?>
<response>
<error>1</error>
<message>$tb_err{$stat}</message>
</response>
EOM
	}
	print &http_header(
		"Content-type: text/xml; charset=$::charset");
	print $xml;
	exit;
}

sub plugin_tb_convert {
	my ($args)=@_;
	my @arg=split(/,/,$args);
	my $html;

	my $flg=0;
	foreach(@logs::allowcmd) {
		$flg=1 if($_ eq $::form{cmd});
	}
	return ' ' if($flg eq 0);
	$html.=&plugin_tb_displaylink;
	my $showflg=0;
	my $displayflg=0;
	foreach(@arg) {
		$showflg=1 if($_=~/show/);
		$displayflg=1 if($_=~/all/);
	}
	$html.=&plugin_tb_displaytrackback($displayflg) if($showflg eq 1);
	return $html . ' ';
}

sub plugin_tb_displaylink {
	my $langflg=$::_exec_plugined{lang} eq 2 ? "&amp;lang=$::lang" : "";
	my $url="$::basehref?cmd=tb&amp;tb_id=$trackback::md5pagename$langflg";
	my $linkstr;
	return "" if(&chkpage($::pushedpage eq '' ? $::form{mypage} : $::pushedpage));

	if($ENV{HTTP_USER_AGENT} =~ /MSIE/) {
		$linkstr=$::resource{trackback_plugin_link_MSIE};
	} else {
		$linkstr=$::resource{trackback_plugin_link};
	}
	$linkstr=~s/\$URL/$url/g;
	return "$linkstr";
}

sub plugin_tb_displaytrackback {
	my($flg)=@_;
	&dbopen($trackback::directory,\%::trackbackbase);
	my $myp=$::pushedpage eq '' ? $::form{mypage} : $::pushedpage;
	return "" if(&chkpage($myp));

	my $trackbacks=&text_to_html(&plugin_tb_add($::trackbackbase{$myp}, $myp, '-',$flg,10));
	my $html=$::resource{trackback_plugin_linklist};
	$html=~s/\$LINK/$trackbacks/g;
	&dbclose(\%::trackbackbase);
	return $html;
}

sub plugin_time_convert {
	return &plugin_time_inline(@_);
}

sub plugin_time_inline {
	my ($format,$time) = split(/,/, shift);
	my ($h,$m,$s);

	$format=&htmlspecialchars($format);
	$time=&htmlspecialchars($time);

	if($format eq '') {
		return &date($::time_format);
	}
	$time=time if($time eq '');

	if($time=~/\:/) {
		my($sec, $min, $hour, $mday, $mon, $year,$wday, $yday, $isdst) = localtime;
		($h,$m,$s)=split(/\:/,$time);
		$time=Time::Local::timelocal($s,$m,$h,$mday,$mon,$year);
	}
	return &date($format,$time);
}

1;
__END__
=head1 NAME

tb.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=tb&tb_id=(trackback id page) [ & __mode=(view|rss)] [ & lang=(language)]
 #tb
 #tb(show)
 #tb(all)
 #tb(showall)

=head1 DESCRIPTION

Trackback process.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/tb

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/tb/>

=item PyukiWiki/Plugin/Explugin/trackback

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Explugin/trackback/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/tb.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/tb.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/trackback.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/lib/trackback.inc.pl?view=log>

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sfjp.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2012 by Nanami.

Copyright (C) 2005-2012 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
