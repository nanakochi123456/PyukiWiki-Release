######################################################################
# ipv6check.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: ipv6check.inc.pl,v 1.206 2011/12/31 13:06:10 papu Exp $
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
use strict;
sub plugin_ipv6check_inline {
	return &plugin_ipv6check_convert(shift);
}
sub plugin_ipv6check_convert {
	my($ipv6page,$ipv4page)=split(/,/,shift);
	my $ipmode="v4";
	my $addr=$ENV{REMOTE_ADDR};
	if($addr=~/^(?:::(?:f{4}:)?)?((?:0*(?:2[0-4]\d|25[0-5]|[01]?\d\d|\d)\.){3}0*(?:2[0-4]\d|25[0-5]|[01]?\d\d|\d)|(?:\d+))$/) {
		$ipmode="v4";
	} elsif($addr=~/:/) {
		$ipmode="v6";
	} else {
		$ipmode="v4";
	}
	if($ipmode eq 'v6') {
		return &text_to_html($::database{$ipv6page}) . " ";
	} else {
		return &text_to_html($::database{$ipv4page}) . " ";
	}
}
1;
__END__
