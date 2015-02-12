######################################################################
# title.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: title.inc.pl,v 1.325 2012/01/31 10:11:58 papu Exp $
#
# "PyukiWiki" version 0.2.0-p1 $$
# Author: Nanami http://nanakochi.daiba.cx/
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
# Return:LF Code=EUC-JP 1TAB=4Spaces
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
