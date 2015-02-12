######################################################################
# img.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: img.inc.pl,v 1.76 2010/12/14 22:20:00 papu Exp $
#
# "PyukiWiki" version 0.1.8 $$
# Author: Nekyo
# Copyright (C) 2004-2010 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2010 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=Shift-JIS 1TAB=4Spaces
######################################################################
# 画像を表示する。
# :書式|
#  #img(画像のURI[[,書式],altコメント])
# 書式：r,right(右寄せ) or l,left(左寄せ) or module(index.cgi からの呼び出し)
# or それ以外(クリア)~
# Pyukiwiki Classic v0.1.6b よりこの関数を 
# lib/wiki.cgi の img 変換でも呼び出すよう修正。(必須)
######################################################################

sub plugin_img_convert {
	my ($uri, $align, $alt) = split(/,/, shift);
	$uri   = &trim($uri);
	$align = &trim($align);
	$alt   = &trim($alt);
	my $module = 0;
	my $res = '';

	if ($align =~ /^(r|right)/i) {
		$align = 'right';
	} elsif ($align =~ /^(l|left)/i) {
		$align = 'left';
	} elsif ($align =~ /^module$/i) {
		$module = 1;
	} else {
		return '<div style="clear:both"></div>';
	}
		if ($uri =~ /\.(gif|png|jpe?g)$/i) {
			if ($module == 1) {

				$res .= "<a href=\"$uri\"><img src=\"$uri\" /></a>\n";
			} else {
				$res .= "<div style=\"float:$align; padding:.5em 1.5em .5em 1.5em;\"><img src=\"$uri\"";
				$res .= " alt=\"$alt\"" if ($alt ne '');
				$res .= " /></div>\n";
			}
		}
	return $res;
}
1;
__END__

