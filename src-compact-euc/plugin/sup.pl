######################################################################
# sup.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: sup.pl,v 1.76 2010/12/14 22:20:00 papu Exp $
#
# "PyukiWiki" version 0.1.8 $$
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

package sup;

sub plugin_inline {
	my ($escaped_argument) = @_;
	my ($string) = split(/,/, $escaped_argument);
	return qq(<sup>$string</sup>);
}

sub plugin_usage {
	return {
		name => 'sup',
		version => '1.0',
		author => 'Nekyo',
		syntax => '&sup(string)',
		description => 'Make sub.',
		example => '&sup(string)',
	};
}

1;
__END__
