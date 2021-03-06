# release file perl script for pyukiwiki
# $Id: text.pl,v 1.490 2012/03/18 11:23:49 papu Exp $

use Jcode;

sub textinit {
	($fn,$pyukiversion,$mode,$TYPE,$CHARSET)=@_;
	($sec, $min, $hour, $mday, $mon, $year,
		$wday, $yday, $isdst) = localtime;
	$year+=1900;

#############################################################
# ヘッダ

$text{YEAR}=$year;
if($TYPE=~/compact/) {
$text{BASEHEAD1}=<<EOM;
\@\@FILENAME\@\@ - \$Id\$
EOM
} else {
$text{BASEHEAD1}=<<EOM;
\@\@FILENAME\@\@ - This is PyukiWiki, yet another Wiki clone.
# \$Id\$
EOM
}

if($TYPE=~/compact/) {
$text{BASEHEAD2}=<<EOM;
Copyright(C) 2005-$year PyukiWiki Developers Team/2004-$year Nekyo
# \@\@PYUKI_URL\@\@  \@\@NEKYO_URL\@\@
# @\@CRLF\@\@ \@\@CODE\@\@ 4Spaces GPL3 and/or Artistic License
EOM
$text{BASEHEAD4}=<<EOM;
Copyright(C)2000-$year - Laurent Destailleur - <eldy (at) users (dot) sourceforge (dot) net>
# \@\@AWSTATS_URL\@\@
# Copyright(C) 2005-$year PyukiWiki Developers Team/2004-$year Nekyo
# \@\@PYUKI_URL\@\@  \@\@NEKYO_URL\@\@
# @\@CRLF\@\@ \@\@CODE\@\@ 4Spaces GPL3 and/or Artistic License
EOM
} else {
$text{BASEHEAD2}=<<EOM;
Copyright (C) 2004-$year Nekyo
# \@\@NEKYO_URL\@\@
# Copyright (C) 2005-$year PyukiWiki Developers Team
# \@\@PYUKI_URL\@\@
# Based on YukiWiki \@\@YUKIWIKI_URL\@\@
# Powerd by PukiWiki \@\@PUKIWIKI_URL\@\@
# License: GPL3 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:\@\@CRLF\@\@ Code=\@\@CODE\@\@ 1TAB=4Spaces
EOM
$text{BASEHEAD4}=<<EOM;
Copyright (C) 2000-$year - Laurent Destailleur - <eldy (at) users (dot) sourceforge (dot) net>
# \@\@AWSTATS_URL\@\@
# Copyright (C) 2004-$year Nekyo
# \@\@NEKYO_URL\@\@
# Copyright (C) 2005-$year PyukiWiki Developers Team
# \@\@PYUKI_URL\@\@
# Based on YukiWiki \@\@YUKIWIKI_URL\@\@
# Powerd by PukiWiki \@\@PUKIWIKI_URL\@\@
# License: GPL3 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:\@\@CRLF\@\@ Code=\@\@CODE\@\@ 1TAB=4Spaces
EOM
}

$text{HEADER1}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# $text{BASEHEAD2}
EOM

if($TYPE=~/compact/) {

$text{HEADER2_NEKYO}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@NEKYO\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@NANAMI\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_YUKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@YUKI\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_JUNICHI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@JUNICHI\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_YASHIGANIMODOKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@YASHIGANIMODOKI\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER3_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@MODULEVERSION\@\@
# Author: \@\@NANAMI\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER3_YUKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@MODULEVERSION\@\@
# Author: \@\@YUKI\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER4_AWS}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@NANAMI\@\@
# $text{BASEHEAD4}
EOM

} else {

$text{HEADER2_NEKYO}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@NEKYO\@\@ \@\@NEKYO_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@NANAMI\@\@ \@\@NANAMI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_YUKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@YUKI\@\@ \@\@YUKI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_JUNICHI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@JUNICHI\@\@ \@\@JUNICHI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_YASHIGANIMODOKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@YASHIGANIMODOKI\@\@
#         \@\@YASHIGANIMODOKI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER3_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@MODULEVERSION\@\@
# Author: \@\@NANAMI\@\@
# \@\@NANAMI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER3_YUKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@MODULEVERSION\@\@
# Author: \@\@YUKI\@\@
# \@\@YUKI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER4_AWS}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author: \@\@NANAMI\@\@ \@\@NANAMI_URL\@\@
# $text{BASEHEAD4}
EOM

}

$text{HEADERPLUGIN_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PLUGINVERSION\@\@
# Author: \@\@NANAMI\@\@ \@\@NANAMI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADEREXPLUGIN_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PLUGINVERSION\@\@
# Author: \@\@NANAMI\@\@ \@\@NANAMI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADERPLUGIN_SYNTAXHIGHLIGHTER_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PLUGINVERSION\@\@
#
# SyntaxHighlighter
# http://alexgorbatchev.com/SyntaxHighlighter
#
# SyntaxHighlighter is donationware. If you are using it, please donate.
# http://alexgorbatchev.com/SyntaxHighlighter/donate.html
#
# Version 3.0.83 (July 02 2010)
# Copyright (C) 2004-2010 Alex Gorbatchev.
#
# Author: \@\@NANAMI\@\@ \@\@NANAMI_URL\@\@
# Copyright (C) 2004-$year Nekyo
# \@\@NEKYO_URL\@\@
# Copyright (C) 2005-$year PyukiWiki Developers Team
# \@\@PYUKI_URL\@\@
# Based on YukiWiki \@\@YUKIWIKI_URL\@\@
# Powerd by PukiWiki \@\@PUKIWIKI_URL\@\@
# License: GPL3 and MIT  each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:\@\@CRLF\@\@ Code=\@\@CODE\@\@ 1TAB=4Spaces
EOM

#############################################################
# podのライセンス

$text{LICENSE_BASE}=<<EOM;
Copyright (C) 2005-$year by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.
EOM

$text{LICENSE}=<<EOM;
Copyright (C) 2004-$year by \@\@NEKYO\@\@.

\@\@LICENSE_BASE\@\@
EOM

$text{LICENSE_NEKYO}=$text{LICENSE};

$text{LICENSE_NANAMI}=<<EOM;
Copyright (C) 2005-$year by \@\@NANAMI\@\@.

\@\@LICENSE_BASE\@\@
EOM

$text{LICENSE_JUNICHI}=<<EOM;
Copyright (C) 2005-$year by \@\@JUNICHI\@\@.

\@\@LICENSE_BASE\@\@
EOM

$text{LICENSE_YASHIGANIMODOKI}=<<EOM;
Copyright (C) 2004-$year by \@\@YASHIGANIMODOKI\@\@.

\@\@LICENSE_BASE\@\@
EOM

$text{LICENSE_YUKI}=<<EOM;
Copyright (C) 2002-$year by \@\@YUKI\@\@.

\@\@LICENSE_BASE\@\@
EOM

#############################################################
# podのAUTHOR
$text{AUTHOR_PYUKI}=<<EOM;
=item PyukiWiki Developers Team

L<\@\@PYUKI_URL\@\@>
EOM

$text{AUTHOR_NEKYO}=<<EOM;
=item \@\@NEKYO\@\@

L<\@\@NEKYO_URL\@\@>
EOM

$text{AUTHOR_YUKI}=<<EOM;
=item \@\@YUKI\@\@

L<\@\@YUKI_URL\@\@>
EOM

$text{AUTHOR_JUNICHI}=<<EOM;
=item \@\@JUNICHI\@\@

L<\@\@JUNICHI_URL\@\@>
EOM

$text{AUTHOR_NANAMI}=<<EOM;
=item \@\@NANAMI\@\@

L<\@\@NANAMI_URL\@\@> etc...
EOM

$text{AUTHOR_YASHIGANIMODOKI}=<<EOM;
=item \@\@YASHIGANIMODOKI\@\@

L<\@\@YASHIGANIMODOKI_URL\@\@>
EOM


#############################################################
# AUHTOR LIST

$text{YUKI}='Hiroshi Yuki';
$text{YUKI_URL}='http://www.hyuki.com/';

$text{NEKYO}='Nekyo';
$text{NEKYO_URL}='http://nekyo.qp.land.to/';

$text{JUNICHI}='Junichi';
$text{JUNICHI_URL}='http://www.re-birth.com/';

if($fn=~/\.ja/) {
	$text{NANAMI}='ななみ';
	$text{YASHIGANIMODOKI}='やしがにもどき';
} else {
	$text{NANAMI}='Nanami';
	$text{YASHIGANIMODOKI}='YashiganiModoki';
}
$text{NANAMI_URL}='http://nanakochi.daiba.cx/';
$text{NANAMI_MAIL}='<nanami (at) daiba (dot) cx>';

$text{YASHIGANIMODOKI_URL}='http://hpcgi1.nifty.com/it2f/wikinger/pyukiwiki.cgi';
$text{SOURCEFORGE_JP_DOMAIN}="sfjp.jp";
$text{SOURCEFORGE_NET_DOMAIN}="sf.net";
$text{PYUKI_URL}="http://pyukiwiki.$text{SOURCEFORGE_JP_DOMAIN}/";
$text{YUKIWIKI_URL}="http://www.hyuki.com/yukiwiki/";
$text{PUKIWIKI_URL}="http://pukiwiki.$text{SOURCEFORGE_JP_DOMAIN}/";
$text{PUKIWIKIDEV_URL}="http://pukiwiki.$text{SOURCEFORGE_JP_DOMAIN}/";

$text{AWSTATS_URL}="http://awstats.$text{SOURCEFORGE_NET_DOMAIN}/";

$text{BASEURL}="http://pyukiwiki.$text{SOURCEFORGE_JP_DOMAIN}";
$text{CVSURL}="http://$text{SOURCEFORGE_JP_DOMAIN}/cvs/view/pyukiwiki";

$text{RECENTDATE}=&date("Y-m-d (D)");

$text{GPLJP_URL}="http://sfjp.jp/projects/opensource/wiki/GPLv3_Info";
$text{GPL_URL}="http://www.gnu.org/licenses/gpl.html";
$text{ARTISTICJP_URL}="http://www.opensource.jp/artistic/ja/Artistic-ja.html";
$text{ARTISTIC_URL}="http://www.perl.com/language/misc/Artistic.html";

#############################################################
#	($fn,$pyukiversion,$mode)=@_;

	$text{FILENAME}=$fn;
	$text{FILENAME}=~s/.*\///g;
	$text{CRLF}=$mode eq 'lf' ? 'LF' : 'CRLF';
	$text{PYUKIWIKIVERSION}=qq("PyukiWiki" ver $pyukiversion \$\$);
	$text{PYUKIVER}=qq($pyukiversion);
	$VERSION="";
	$pkg="";
	$PLUGIN="";
	$EXPLUGIN="";
	$chkbuf="";
	open(R,"$fn");
	foreach(<R>) {
		$chkbuf.=$_;
		if(/^\$VERSION/) {
			eval  $_ ;
		} elsif(/^package\s?(.*?);/) {
			$pkg=$1;
		} elsif(/^\$PLUGIN/) {
			eval $_;
		} elsif(/^\$EXPLUGIN/) {
			eval $_;
		}
	}
	close(R);
	if($CHARSET eq 'utf8') {
		$text{CODE}="UTF-8";
	} elsif($chkbuf=~/\$charset\: (.+)\$/) {
		$text{CODE}=$1;
	} else {
		($code)=Jcode::getcode($chkbuf);
		if($code eq 'sjis') {
			$text{CODE}="Shift-JIS";
		} elsif($code eq 'utf8') {
			$text{CODE}="UTF-8";
		} else {
			$text{CODE}="EUC-JP";
		}
	}
	if($VERSION ne '' && $PLUGIN ne '') {
		$text{PLUGINVERSION}=qq("$PLUGIN" ver $VERSION \$\$);
	} elsif($VERSION ne '' && $EXPLUGIN ne '') {
		$text{PLUGINVERSION}=qq("$EXPLUGIN" ver $VERSION \$\$);
	} elsif($VERSION ne '' && $pkg ne '') {
		$text{MODULEVERSION}=qq("$pkg" ver $VERSION \$\$);
	} else {
		$text{MODULEVERSION}=$text{PYUKIWIKIVERSION};
	}
	foreach (keys %text) {
		if($text{CODE} eq "Shift-JIS") {
			&Jcode::convert($text{$_}, "sjis","euc");
		} elsif($text{CODE} eq "UTF-8") {
			&Jcode::convert($text{$_}, "utf8","euc");
		}
		$text{$_}=~s/\n$//g;
	}
}


sub date {
	my ($format, $tm, $gmtime) = @_;
	my %weekday;
	my $weekday_lang;
	my $ampm_lang;
	my %ampm;

	# yday:0-365 $isdst Summertime:1/not:0
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
		$gmtime ne '' && @_ > 2
			? ($tm+0 > 0 ? gmtime($tm) : gmtime(time))
			: ($tm+0 > 0 ? localtime($tm) : localtime(time));

	$year += 1900;
	my $hr12=$hour=>12 ? $hour-12:$hour;

	# am / pm strings
	$ampm{en}=$hour>11 ? 'pm' : 'am';
	$ampm{ja}=$hour>11 ? '午後' : '午前';

	# weekday strings
	$weekday{en} = ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')[$wday];
	$weekday{en}{length}=3;
	$weekday{ja} = ('日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日')[$wday];
	$weekday{ja}{length}=2;

	$weekday_lang=$weekday{$::lang} eq '' ? 'en' : $::lang;
	$ampm_lang=$ampm{$::lang} eq '' ? 'en' : $::lang;

	# RFC 822 (only this)
	if($format=~/r/) {
		return &date("D, j M Y H:i:s O",$tm,$gmtime);
	}
	# gmtime & インターネット時間
	if($format=~/[OZB]/) {
		my $gmt=&gettz;
		$format =~ s/O/sprintf("%+03d:00", $gmt)/ge;	# GMT Time
		$format =~ s/Z/sprintf("%d", $gmt*3600)/ge;		# GMT Time secs...
		my $swatch=(($tm-$gmt+90000)/86400*1000)%1000;	# GMT +1:00にして、１日を1000beatにする
														# 日本時間の場合、AM08:00=000
		$format =~ s/B/sprintf("%03d", int($swatch))/ge;# internet time
	}

	# UNIX time
	$format=~s/U/sprintf("%u",$tm)/ge;	# unix time

	$format=~s/lL/\x2\x13/g;	# lL:escape 日-土
	$format=~s/DL/\x2\x14/g;	# DL:escape 日曜日-土曜日
	$format=~s/l/\x2\x11/g;		# l:escape Sunday-Saturday
	$format=~s/D/\x2\x12/g;		# D:escape Sun-Sat
	$format=~s/aL/\x1\x13/g;	# aL:escape 午前 or 午後
	$format=~s/AL/\x1\x14/g;	# AL:escape ↑の大文字
	$format=~s/a/\x1\x11/g;		# a:escape am pm
	$format=~s/A/\x1\x12/g;		# A:escape AM PM
	$format=~s/M/\x3\x11/g;		# M:escape Jan-Dec
	$format=~s/F/\x3\x12/g;		# F:escape January-December

	# うるう年、この月の日数
	if($format=~/[Lt]/) {
		my $uru=($year % 4 == 0 and ($year % 400 == 0 or $year % 100 != 0)) ? 1 : 0;
		$format=~s/L/$uru/ge;
		$format=~s/t/(31, $uru ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)[$mon]/ge;
	}

	# year
	$format =~ s/Y/$year/ge;	# Y:4char ex)1999 or 2003
	$year = $year % 100;
	$year = "0" . $year if ($year < 10);
	$format =~ s/y/$year/ge;	# y:2char ex)99 or 03

	# month
	my $month = ('January','February','March','April','May','June','July','August','September','October','November','December')[$mon];
	$mon++;									# mon is 0 to 11 add 1
	$format =~ s/n/$mon/ge;					# n:1-12
	$mon = "0" . $mon if ($mon < 10);
	$format =~ s/m/$mon/ge;					# m:01-12


	# day
	$format =~ s/j/$mday/ge;				# j:1-31
	$mday = "0" . $mday if ($mday < 10);
	$format =~ s/d/$mday/ge;				# d:01-31

	# hour
	$format =~ s/g/$hr12/ge;				# g:1-12
	$format =~ s/G/$hour/ge;				# G:0-23
	$hr12 = "0" . $hr12 if ($hr12 < 10);
	$hour = "0" . $hour if ($hour < 10);
	$format =~ s/h/$hr12/ge;				# h:01-12
	$format =~ s/H/$hour/ge;				# H:00-23

	# minutes
	$format =~ s/k/$min/ge;					# k:0-59
	$min = "0" . $min if ($min < 10);
	$format =~ s/i/$min/ge;					# i:00-59

	# second
	$format =~ s/S/$sec/ge;					# S:0-59
	$sec = "0" . $sec if ($sec < 10);
	$format =~ s/s/$sec/ge;					# s:00-59

	$format =~ s/w/$wday/ge;				# w:0(Sunday)-6(Saturday)


	$format =~ s/I/$isdst/ge;	# I(Upper i):1 Summertime/0:Not

	$format =~ s/\x1\x11/$ampm{en}/ge;			# a:am or pm
	$format =~ s/\x1\x12/uc $ampm{en}/ge;		# A:AM or PM
	$format =~ s/\x1\x13/$ampm{$ampm_lang}/ge;	# A:午前 or 午後
	$format =~ s/\x1\x14/uc $ampm{$ampm_lang}/ge;# ↑の大文字

	$format =~ s/\x2\x11/$weekday{en}/ge;		# l(lower L):Sunday-Saturday
	$format =~ s/\x2\x12/substr($weekday{en},0,$weekday{en}{length})/ge;	# D:Mon-Sun
	$format =~ s/\x2\x13/substr($weekday{$weekday_lang},0,$weekday{$weekday_lang}{length})/ge;	# D:Mon-Sun
	$format =~ s/\x2\x14/$weekday{$weekday_lang}/ge;

	$format =~ s/\x3\x11/substr($month,0,3)/ge;	# M:Jan-Dec
	$format =~ s/\x3\x12/$month/ge;				# F:January-December

	$format =~ s/z/$yday/ge;	# z:days/year 0-366
	return $format;
}

1;
