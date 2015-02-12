/*/////////////////////////////////////////////////////////////////////
# linktrack.inc.js - This is PyukiWiki, yet another Wiki clone.
# $Id: linktrack.inc.js,v 1.340 2012/03/01 10:39:20 papu Exp $
#
# "PyukiWiki" version 0.2.0-p2 $$
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
/////////////////////////////////////////////////////////////////////*/

function Ck(link,tg) {
	var amp="&amp;", cmd="?cmd=ck" + amp, lk=cmd + link, ret;
	if(tg == 'r') {
		lk=cmd + "r=y" + amp + link;
		d.location=lk;
		return true;
	} else if(tg != '') {
		ou(lk,tg);
	} else {
		d.location=lk;
	}
	return false;
}
