######################################################################
# diff.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: diff.inc.pl,v 1.78 2010/12/14 22:20:00 papu Exp $
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
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# v0.2 BugFix $diffbase -> $::diffbase Tnx! Mr.Yashigani-modoki.
# v0.1 Proto
######################################################################

$diff::nostring=qq(<span style="font-size: 70%;">[CR]</span>);

sub plugin_diff_action {
	if (not &is_editable($::form{mypage})) {
		&do_read;
		&close_db;
		exit;
	}
	&open_diff;
	my $title = $::form{mypage};
	$_ = &htmlspecialchars($::diffbase{$::form{mypage}});
	&close_diff;
	my $body = qq(<h3>$::resource{diff_plugin_msg}</h3>);
	$body .= qq($::resource{diff_plugin_notice});
	$body .= qq(<pre class="diff">);
	foreach (split(/\n/, $_)) {
		if (/^\+(.*)/) {
			$body .= qq(<b class="diff_added">$1@{[$1 eq '' ? "$diff::nostring" : '']}</b>\n);
		} elsif (/^\-(.*)/) {
			$body .= qq(<s class="diff_removed">$1@{[$1 eq '' ? "$diff::nostring" : '']}</s>\n);
		} elsif (/^\=(.*)/) {
			$body .= qq(<span class="diff_same">$1</span>\n);
		} else {
			$body .= qq|??? $_\n|;
		}
	}
	$body .= qq(</pre>);
	$body .= qq(<hr>);


	$body=~s/$::ismail/$::resource{diff_disable_email}/g
		if($diff_disable_email eq 1);
	return ('msg' => "$title\t$::resource{diff_plugin_title}", 'body' => $body, 'ispage'=>1);
}
1;
__END__

