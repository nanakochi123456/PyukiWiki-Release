/*/////////////////////////////////////////////////////////////////////
# linktrack.inc.js - This is PyukiWiki, yet another Wiki clone.
# $Id: linktrack.inc.js,v 1.369 2012/03/18 11:23:50 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
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

// lk=this.href
// tg=b=_blank, r=right click

function Ck(lk,tg) {
	var	m, l
		a="&amp;", c="?cmd=ck" + a,
		p="p=", k="l=", u;

	m=hs('$::form{mypage}');
	l=hs(lk);

	u=c + p + m + a + k + l;

	if(tg == 'r') {
		u=c+ "r=y" + a + p + m + a + k + l;
		d.location=u;
	} else if(tg != "") {
		ou(u, tg);
	} else {
		d.location=u;
	}
	return false;
}

function hs(str) {
	var ret="";
	for(var i=0; i < str.length; i++) {
		var chr=str.charCodeAt(i).toString(16).toUpperCase();
		ret=ret + chr;
	}
	return ret;
}
