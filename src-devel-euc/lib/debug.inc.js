/*/////////////////////////////////////////////////////////////////////
# debug.inc.js - This is PyukiWiki, yet another Wiki clone.
# $Id: debug.inc.js,v 1.202 2011/12/31 13:06:09 papu Exp $
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

function Display(id,mode){
	if(d.all || d.getElementById){	//IE4, NN6 or later
		if(d.all){
			obj = d.all(id).style;
		}else if(d.getElementById){
			obj = d.getElementById(id).style;
		}
		if(mode == "view") {
			obj.display = "block";
		} else if(mode == "none") {
			obj.display = "none";
		} else if(obj.display == "block"){
			obj.display = "none";		//hidden
		}else if(obj.display == "none"){
			obj.display = "block";		//view
		}
	}
}
