######################################################################
# adminedit.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: adminedit.inc.pl,v 1.336 2012/03/18 11:23:57 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
# Author: Nekyo http://nekyo.qp.land.to/
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
use strict;
sub plugin_adminedit_action {
	if (1 == &exist_plugin('edit')) {
		my ($page) = &unarmor_name(&armor_name($::form{mypage}));
		my $body;
		if (not &is_editable($page)) {
			$body .= qq(<p><strong>$::resource{edit_plugin_cantchange}</strong></p>);
		} else {
			$body .= qq(<p><strong>$::resource{adminedit_plugin_passwordneeded}</strong></p>);
			my $pagemsg;
			if ($::form{mypart} =~ /^\d+$/ and $::form{mypart}) {
				my $mymsg = (&read_by_part($page))[$::form{mypart} - 1];
				$pagemsg = \$mymsg;
			} else {
				$pagemsg = \$::database{$page};
			}
			$body .= &plugin_edit_editform($$pagemsg,
				&get_info($page, $::info_ConflictChecker), admin=>1);
		}
		return ('msg'=>"$page\t$::resource{adminedit_plugin_title}", 'body'=>$body, 'ispage'=>1);
	}
	return "";
}
1;
__END__
