######################################################################
# time.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: time.inc.pl,v 1.489 2012/03/18 11:23:51 papu Exp $
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
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
use strict;
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
