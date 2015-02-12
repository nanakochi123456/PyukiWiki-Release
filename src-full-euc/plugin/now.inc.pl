######################################################################
# now.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: now.inc.pl,v 1.315 2011/12/31 13:06:11 papu Exp $
#
# "PyukiWiki" version 0.2.0 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2012 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2012 PyukiWiki Developers Team
# http://pyukiwiki.sfjp.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sfjp.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
use strict;
sub plugin_now_convert {
	return &plugin_now_inline(@_);
}
sub plugin_now_inline {
	my ($format,$now) = split(/,/, shift);
	my ($y,$m,$d);
	my ($h,$m,$s);
	$format=&htmlspecialchars($format);
	$now=&htmlspecialchars($now);
	if($format eq '') {
		return &date($::now_format);
	}
	$now=time if($now eq '');
	if($now=~/ /) {
		my($date,$time)=split(/ /,$now);
		if($date=~/-/) {
			($y,$m,$d)=split(/\-/,$date);
		} elsif($now=~/\//) {
			($y,$m,$d)=split(/\//,$now);
		}
		if($time=~/\:/) {
			($h,$m,$s)=split(/\:/,$time);
		}
		$now=Time::Local::timelocal($s,$m,$h,$m-1,$y-1900);
	} else {
		$now=time;
	}
	return &date($format,$now);
}
1;
__END__
