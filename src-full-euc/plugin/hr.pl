######################################################################
# hr.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: hr.pl,v 1.54 2010/12/29 06:21:06 papu Exp $
#
# "PyukiWiki" version 0.1.8-p1 $$
# Author: Nekyo
# Copyright (C) 2004-2010 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2010 PyukiWiki Developers Team
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
package hr;

sub plugin_block {
	return &plugin_inline;
}

sub plugin_inline {
	return '<hr class="short_line" />';
}

sub plugin_usage {
	return {
		name => 'hr',
		version => '1.0',
		author => 'Nanami <nanami (at) daiba (dot) cx>',
		syntax => '#hr',
		description => '',
		example => '#hr',
	};
}

1;
__END__

