######################################################################
# setlinebreak.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: setlinebreak.inc.pl,v 1.37 2011/01/25 03:11:15 papu Exp $
#
# "PyukiWiki" version 0.1.8-p2 $$
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

sub plugin_setlinebreak_convert {
	my($mode)=split(/,/, shift);
	if($mode eq '') {
		$::lfmode=$::lfmode eq 0 ? 1 : 0;
	} elsif(lc $mode eq 'default') {
		$::lfmode=$::line_break;
	} elsif($mode=~/^(1|[Oo][Nn])/) {
		$::lfmode=1;
	} else {
		$::lfmode=0;
	}
	return ' ';
}

1;
__END__

