######################################################################
# verb.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: verb.pl,v 1.336 2012/03/18 11:23:57 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
# Author: Hiroshi Yuki http://www.hyuki.com/
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
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################
use strict;
package verb;
sub plugin_inline {
	my ($escaped_argument) = @_;
	return qq(<span class="verb">$escaped_argument</span>);
}
sub plugin_usage {
	return {
		name => 'verb',
		version => '1.0',
		author => 'Hiroshi Yuki http://www.hyuki.com/',
		syntax => '&verb(as-is string)',
		description => 'Inline verbatim (hard).',
		example => '&verb(ThisIsNotWikiName)',
	};
}
1;
__END__
