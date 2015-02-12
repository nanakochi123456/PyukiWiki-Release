######################################################################
# date.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: date.inc.pl,v 1.77 2011/05/04 07:26:50 papu Exp $
#
# "PyukiWiki" version 0.1.9 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2011 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2011 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################

use strict;
use Time::Local;

sub plugin_date_convert {
	return &plugin_date_inline(@_);
}

sub plugin_date_inline {
	my ($format,$date) = split(/,/, shift);
	my ($y,$m,$d);

	$format=&htmlspecialchars($format);
	$date=&htmlspecialchars($date);

	if($format eq '') {
		return &date($::date_format);
	}
	$date=time if($date eq '');

	if($date=~/-/) {
		($y,$m,$d)=split(/\-/,$date);
		$date=Time::Local::timelocal(0,0,0,$d,$m-1,$y-1900);
	} elsif($date=~/\//) {
		($y,$m,$d)=split(/\//,$date);
		$date=Time::Local::timelocal(0,0,0,$d,$m-1,$y-1900);
	}
	return &date($format,$date);
}

1;
__END__

