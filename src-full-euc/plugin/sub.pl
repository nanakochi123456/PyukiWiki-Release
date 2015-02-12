######################################################################
# sub.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: sub.pl,v 1.81 2011/02/22 20:59:12 papu Exp $
#
# "PyukiWiki" version 0.1.8-p3 $$
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

package sub;

sub plugin_inline {
	my ($escaped_argument) = @_;
	my ($string) = split(/,/, $escaped_argument);
	return qq(<sub>$string</sub>);
}

sub plugin_usage {
	return {
		name => 'sub',
		version => '1.0',
		author => 'Nekyo <nekyo (at) yamaneko (dot) club (dot) ne (dot) jp>',
		syntax => '&sub(string)',
		description => 'Make sub.',
		example => '&sub(string)',
	};
}

1;
__END__

