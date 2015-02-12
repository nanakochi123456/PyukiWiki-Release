######################################################################
# stationary_explugin.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: stationary_explugin.inc.pl,v 1.67 2012/03/01 10:39:27 papu Exp $
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
######################################################################
# This is extented plugin sample
# To use this plugin, rename to 'stationary_explugin.inc.cgi'
######################################################################
use strict;
#
# init
#
sub plugin_stationary_init {
	my $http_header="X-PyukiWiki-Stationary:test";
	return(
		'init'=>1,
		'http_header'=>$http_header
		, 'func'=>'convtime', 'convtime'=>\&convtime
	);
}
sub convtime {
	if ($::enable_convtime != 0) {
		return sprintf("PyukiWiki $::version stationary_explugin<br />Powered by Perl $] HTML convert time to %.3f sec.%s",
			((times)[0] - $::_conv_start), $::gzip_header ne '' ? " Compressed" : "");
	}
}
1;
__END__
