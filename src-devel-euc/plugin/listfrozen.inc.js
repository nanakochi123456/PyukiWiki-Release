/*/////////////////////////////////////////////////////////////////////
# listfrozen.inc.js - This is PyukiWiki, yet another Wiki clone.
# $Id: listfrozen.inc.js,v 1.213 2012/01/31 10:11:58 papu Exp $
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
/////////////////////////////////////////////////////////////////////*/

function allcheckbox(v) {
	f=d.getElementById("sel");
	len=f.elements.length;
	for(i=0;i<len;i++) {
		if(f.elements[i].type == "checkbox") {
			if(v == 1) {
				if(!f.elements[i].checked) {
					f.elements[i].click();
				}
			} else {
				if(f.elements[i].checked) {
					f.elements[i].click();
				}
			}
		}
	}
}
