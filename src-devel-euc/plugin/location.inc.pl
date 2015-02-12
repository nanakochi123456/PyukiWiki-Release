######################################################################
# location.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: location.inc.pl,v 1.258 2011/12/31 13:06:10 papu Exp $
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
######################################################################
# v0.1.9 2011/02/23 新規作成
#
# *Usage
# #location(http:〜 or wikiページ名)
#
# 安全の為、凍結されているページでしか実行されません。
######################################################################

use strict;

$::location::move_time=3
	if(!defined($::location::move_time));

sub plugin_location_convert {
	my $url=shift;

	return if(!&is_frozen($::form{mypage}));

	if(&is_exist_page($url)) {
		my $tmp=&make_cookedurl($url);
		$url="$::basehref$tmp";
	}
	$::IN_HEAD.=<<EOM;
<meta http-equiv="Refresh" content="$::location::move_time;url=$url" />
EOM
	my $body=$::resource{location_plugin_message};
	$body=~s/\@\@URL\@\@/$url/g;

	return $body;
}

1;
__END__
=head1 NAME

locatioin.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #location(url or wiki page)

=head1 DESCRIPTION

This plugin is location of page.

=head1 USAGE

 #location(url or wiki page)

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/location

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/location/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/location.inc.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sfjp.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2012 by Nanami.

Copyright (C) 2005-2012 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
