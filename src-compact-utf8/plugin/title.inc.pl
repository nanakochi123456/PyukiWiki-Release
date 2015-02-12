######################################################################
# title.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: title.inc.pl,v 1.171 2011/12/31 13:06:14 papu Exp $
#
# "PyukiWiki" version 0.2.0 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2012 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2012 PyukiWiki Developers Team
# http://pyukiwiki.sfjp.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sfjp.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################
# v0.2.0 First Release
#
#*Usage
# #title(title tag string)
######################################################################
sub plugin_title_convert {
	my ($title) = shift;
	return if(!&is_frozen($::form{mypage}));
	$::IN_TITLE=&htmlspecialchars($title);
	return ' ';
}
1;
__END__
