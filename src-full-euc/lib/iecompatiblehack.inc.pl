######################################################################
# iecompatiblehack.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: iecompatiblehack.inc.pl,v 1.347 2012/01/31 10:11:55 papu Exp $
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
# This is extented plugin.
# To use this plugin, rename to 'iecompatiblehack.inc.cgi'
######################################################################
#
# IEの互換表示ボタンをなくすプラグイン
#
######################################################################
# Initlize
sub plugin_iecompatiblehack_init {
	my $agent=$ENV{HTTP_USER_AGENT};
	my $header;
	if($ENV{HTTP_USER_AGENT}=~/MSIE (\d+).(\d+)/) {
		if($1 > 6) {
			$header=<<EOM;
X-UA-Compatible: IE=$1
EOM
		}
	}
	return ('http_header'=>$header, 'init'=>1, 'func'=>'');
}
1;
__DATA__
sub plugin_iecompatiblehack_setup {
	return(
	'ja'=>'IEの互換表示ボタンを強制的になくすプラグイン',
	'en'=>'For Internet Explorer, disable compatible button',
	'override'=>'none',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/iecompatiblehack/'
	);
}
__END__
