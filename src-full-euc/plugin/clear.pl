######################################################################
# clear.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: clear.pl,v 1.50 2006/03/17 14:00:10 papu Exp $
#
# "PyukiWiki" version 0.1.6 $$
# Author: Nanami http://lineage.netgamers.jp/
# Copyright (C) 2004-2006 by Nekyo.
# http://nekyo.hp.infoseek.co.jp/
# Copyright (C) 2005-2006 PyukiWiki Developers Team
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
package clear;

sub plugin_inline {
	return '<div class="clear"></div>';
}
1;

__END__
