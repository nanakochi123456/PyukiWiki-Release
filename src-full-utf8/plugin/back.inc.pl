######################################################################
# back.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: back.inc.pl,v 1.308 2012/03/01 10:39:25 papu Exp $
#
# "PyukiWiki" version 0.2.0-p2 $$
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
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################
$back::allowpagelink=0
	if(!defined($back::allowpagelink));
$back::allowjavascript=1
	if(!defined($back::allowjavascript));
$back::blacket=1
	if(!defined($back::blacket));
######################################################################
use strict;
$::back::count;
sub plugin_back_convert {
	my($str,$align,$hr,$link)=split(/,/,shift);
	my $body;
	$str=$::resource{backbutton} if($str eq '');
	$align="center" if($align eq '');
	if($hr+0 eq 0) {
		$hr="";
	} else {
		$hr=qq(<hr class="full_hr" />\n);
	}
	if($back::allowpagelink eq 0) {
		$link="";
	} elsif($link!~/$::isurl/) {
		$link = &make_cookedurl(&encode($link));
	}
	if($link eq "") {
		if($back::allowjavascript eq 1) {
			$::back::count+=0;
			$::back::count++;
			$body=<<EOM;
<span id="back_$::back::count"></span>
<script type="text/javascript"><!--
if(history.length!=0){d.getElementById("back_$::back::count").innerHTML='$hr<div align="$align">@{[$back::blacket eq 1 ? '[' : '']}<a href="javascript:history.go(-1)" title="$str">$str</a>@{[$back::blacket eq 1 ? ']' : '']}</div>';}
//--></script>
<noscript>
$hr
<div align="$align">
@{[$back::blacket eq 1 ? '[' : '']}<a href="$ENV{HTTP_REFERER}" title="$str">$str</a>@{[$back::blacket eq 1 ? ']' : '']}
</div>
</noscript>
EOM
		} elsif($ENV{HTTP_REFERER} ne '') {
			$body=<<EOM;
$hr
<div align="$align">
@{[$back::blacket eq 1 ? '[' : '']}<a href="$ENV{HTTP_REFERER}" title="$str">$str</a>@{[$back::blacket eq 1 ? ']' : '']}
</div>
EOM
		} else {
			$body=" ";
		}
	} else {
		$body=<<EOM;
$hr
<div align="$align">
<a href="$link" title="$str">$str</a>
</div>
EOM
	}
	return $body;
}
1;
__END__
