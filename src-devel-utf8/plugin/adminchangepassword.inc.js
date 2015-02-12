/*/////////////////////////////////////////////////////////////////////
# adminchangepassword.inc.js - This is PyukiWiki, yet another Wiki clone.
# $Id: adminchangepassword.inc.js,v 1.309 2012/03/01 10:39:25 papu Exp $
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
# Return:LF Code=UTF-8 1TAB=4Spaces
/////////////////////////////////////////////////////////////////////*/

function ViewPassForm(id,mode){
	var	obj,
		block="block",
		none="none";

	if(d.all || d.getElementById){	//IE4, NN6 or later
		if(d.all){
			obj = d.all(id).style;
		}else if(d.getElementById){
			obj = d.getElementById(id).style;
		}
		if(mode == "view") {
			obj.display = block;
		} else if(mode == none) {
			obj.display = none;
		} else if(obj.display == block){
			obj.display = none;		//hidden
		}else if(obj.display == none){
			obj.display = block;		//view
		}
	}
}
