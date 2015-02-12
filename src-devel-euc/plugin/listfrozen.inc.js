/*/////////////////////////////////////////////////////////////////////
# listfrozen.inc.js - This is PyukiWiki, yet another Wiki clone.
# $Id: listfrozen.inc.js,v 1.130 2011/12/31 13:06:10 papu Exp $
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
