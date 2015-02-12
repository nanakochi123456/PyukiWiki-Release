######################################################################
# br.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: br.pl,v 1.83 2011/01/25 03:11:15 papu Exp $
#
# "PyukiWiki" version 0.1.8-p2 $$
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
package br;

sub plugin_block {
	return &plugin_inline;
}

sub plugin_inline {
	return qq(<br />);
}

sub plugin_usage {
	return {
		name => 'br',
		version => '1.0',
		author => 'Nekyo <nekyo (at) yamaneko (dot) club (dot) ne (dot) jp>',
		syntax => '&br',
		description => 'line break.',
		example => '&br',
	};
}

1;
__END__

