######################################################################
# location.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: location.inc.pl,v 1.9 2011/05/04 07:26:50 papu Exp $
#
# "PyukiWiki" version 0.1.9 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2011 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2011 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# v0.1.9 2011/02/23 新規作成
#
#*Usage
# #location(http:〜 or wikiページ名)
#
# 安全の為、凍結されているページでしか実行されません。
######################################################################

use strict;

$::location::move_time=5
	if(!defined($::location::move_time));

sub plugin_location_convert {
	my $url=shift;

	return if(!&is_frozen($::form{mypage}));

	if(&is_exist_page($url)) {
		my $tmp=&make_cookedurl($url);
		$url="$::basehref$tmp";
	}
	$::IN_HEAD=<<EOM;
<meta http-equiv="Refresh" content="$::location::move_time;url=$url" />
EOM
	my $body=$::resource{location_plugin_message};
	$body=~s/\@\@URL\@\@/$url/g;

	return $body;
}

1;
__END__
