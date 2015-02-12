/*/////////////////////////////////////////////////////////////////////
# listfrozen.inc.js - This is PyukiWiki, yet another Wiki clone.
# $Id: listfrozen.inc.js,v 1.295 2012/03/18 11:23:51 papu Exp $
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

function allcheckbox(v) {
	var	f=d.getElementById("sel"),
		len=f.elements.length;

	for(i=0;i<len;i++) {
		l=f.elements[i];
		if(l.type == "checkbox") {
			if(v == 1) {
				if(!l.checked) {
					l.click();
				}
			} else {
				if(l.checked) {
					l.click();
				}
			}
		}
	}
}
