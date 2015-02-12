######################################################################
# color.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: color.pl,v 1.90 2011/05/04 07:26:50 papu Exp $
#
# "PyukiWiki" version 0.1.9 $$
# Author: Nekyo
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
package color;

sub plugin_inline {
	my @args = split(/,/, shift);
	my $bgcolor = '';
	my ($color, $bgcolor, $body);

	if (@args == 3) {
		$color = $args[0];
		$bgcolor = $args[1];
		$body = $args[2];
		if ($body eq '') {
			$body = $bgcolor;
			$bgcolor = '';
		}
	} elsif (@args == 2) {
		$color = $args[0];
		$body = $args[1];
	} else {
		return '';
	}
	if ($color eq '' or $body eq '') {
		return '';
	}
	if ($bgcolor ne '') {
		$color .= ';background-color:'.$bgcolor;
	}
	return "<span style=\"color:$color\">$body</span>";
}
1;
__END__

