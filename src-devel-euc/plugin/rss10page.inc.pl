######################################################################
# rss10page.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: rss10page.inc.pl,v 1.458 2012/03/18 11:23:51 papu Exp $
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
# Return:LF Code=Shift-JIS 1TAB=4Spaces
######################################################################

# descriptionの行数を指定
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

	# 言語別の設定											# comment
	if($::_exec_plugined{lang} > 1) {
		$::modifier_rss_link=$::modifier_rss_link{$::lang} ne '' ? $::modifier_rss_link{$::lang}: $::modifier_rss_link ne '' ? $::modifier_rss_link : $::basehref;
	} else {
		$::modifier_rss_link=$::modifier_rss_link ne '' ? $::modifier_rss_link : $::basehref;
	}

	my $data=$::database{$page};

	# モードを取得											# comment
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
	# 内容を取得												# comment
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
#	if($lines) {											# comment
#		&plugin_rss10page_additem($rss,$escaped_title,$link	,$description,$date);		# comment
#	}														# comment

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
#	if($link!~/#/) {									# comment
#		my $tmp=$date;									# comment
#		$tmp=~s/\+.*//g;								# comment
#		$tmp=~s/[+:\-T]//g;								# comment
#		my $tmp2=$tmp;									# comment
#		for(my $i=0; ;$i++) {							# comment
#			if($rss10page_dates{$tmp2} eq '') {			# comment
#				$rss10page_dates{$tmp2}="1";			# comment
#				last;									# comment
#			}											# comment
#			$tmp2="$tmp$i";								# comment
#		}												# comment
#		$link="$link#$tmp2";							# comment
#	}													# comment
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

	# print RSS information (as XML).
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
=head1 NAME

rss10page.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=rss10page&page=pagename[&lang=lang]
 #rss10page(- or *)

=head1 DESCRIPTION

Output RSS (RDF Site Summary) 1.0 from it's page

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/rss10page

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/rss10page/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/rss10page.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/rss10page.inc.pl?view=log>

=item YukiWiki

Using Yuki::RSS

L<http://www.hyuki.com/yukiwiki/>

=back

=head1 AUTHOR

=over 4

=item Nekyo

L<http://nekyo.qp.land.to/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sfjp.jp/>

=back

=head1 LICENSE

Copyright (C) 2004-2012 by Nekyo.

Copyright (C) 2005-2012 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
