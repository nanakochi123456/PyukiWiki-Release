######################################################################
# ruby.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: ruby.inc.pl,v 1.80 2011/01/25 03:11:15 papu Exp $
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

sub plugin_ruby_inline {
	@arg = split(/,/, shift);
	my $ruby = $arg[0];
	my $body = $arg[1];

	if ($ruby eq '' or $body eq '') {
		return '';
	}
	my $s_ruby = &escape($ruby);
	return "<ruby><rb>$body</rb><rp>(</rp><rt>$s_ruby</rt><rp>)</rp></ruby>";
}
1;
__END__
