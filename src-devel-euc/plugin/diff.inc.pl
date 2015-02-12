######################################################################
# diff.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: diff.inc.pl,v 1.423 2012/01/31 10:11:58 papu Exp $
#
# "PyukiWiki" version 0.2.0-p1 $$
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
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# v0.2.0 add delete action and no diff of no print
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
	if($::form{action} eq "delete") {
		%::auth=&authadminpassword(submit);
		my $title=$::resource{diff_plugin_delete_title};
		$title=~s/\$1/$::form{mypage}/g;
		return('msg'=>"\t$title",'body'=>$auth{html})
			if($auth{authed} eq 0);
		if($::form{cancel} ne '') {
			print &http_header(
				"Status: 302",
				"Location: $::basehref?cmd=diff&amp;mypage=@{[&encode($::form{mypage})]}",
				$::HTTP_HEADER
				);
			close(STDOUT);
			&exec_explugin_last;
			exit;
		}
		if($::form{ok} eq '') {
			my $delete = $::resource{diff_plugin_delete};
			$delete=~s/\$1/$::form{mypage}/g;
			my $confirmmsg=$::resource{diff_plugin_delete_confirm};
			$confirmmsg=~s/\$1/$::form{mypage}/g;

			my $body=<<EOM;
<h3>$delete</h3>
<form action="$::script" method="POST">
$auth{html}
<input type="hidden" name="cmd" value="diff" />
<input type="hidden" name="action" value="delete" />
<input type="hidden" name="mypage" value="$::form{mypage}" />
$confirmmsg<br />
<input type="submit" name="ok" value="$::resource{diff_plugin_delete_confirm_ok}" />
<input type="submit" name="cancel" value="$::resource{diff_plugin_delete_confirm_cancel}" />
</form>
EOM
			return('msg'=>"\t$title",'body'=>$body);
		}
		&open_diff;
		delete $::diffbase{$::form{mypage}};
		&close_diff;
		my $body=<<EOM;
<strong>$::resource{diff_plugin_deleted}</strong>
<hr />
<a href="$script?@{[&encode($::form{mypage})]}">$::resource{diff_plugin_return}</a>
EOM
		$body=~s/\$1/$::form{mypage}/g;
		return('msg'=>"\t$title",'body'=>$body);
	} else {
		&open_diff;
		my $title = $::form{mypage};
		my $diffmsg=$::diffbase{$::form{mypage}};
		if($diffmsg eq '') {
			&close_diff;
			my $body = qq(<h3>$::resource{diff_plugin_msg}</h3>);
			$body.=qq(<strong>$::resource{diff_plugin_nodiff}</strong>);
			$body=~s/\$1/$::form{mypage}/g;
			my $goto = $::resource{diff_plugin_goto};
			$goto=~s/\$1/$::form{mypage}/g;
			$body .= qq(<hr />\n<a href="$script?@{[&encode($::form{mypage})]}">$goto</a>);
			return ('msg' => "$title\t$::resource{diff_plugin_title}", 'body' => $body, 'ispage'=>1);
		}
		$_ = &htmlspecialchars($diffmsg);
		&close_diff;
		my $body = qq(<h3>$::resource{diff_plugin_msg}</h3>);
		$body .= qq(<ul>);
		$body .= qq($::resource{diff_plugin_notice});
		my $goto = $::resource{diff_plugin_goto};
		$goto=~s/\$1/$::form{mypage}/g;
		$body .= qq(<li><a href="$script?@{[&encode($::form{mypage})]}">$goto</a></li>);
		my $delete = $::resource{diff_plugin_delete};
		$delete=~s/\$1/$::form{mypage}/g;
		$body .= qq(<li><a href="$script?cmd=diff&amp;action=delete&amp;mypage=@{[&encode($::form{mypage})]}">$delete</a></li>);
		$body .= qq(</ul><hr />);
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
		$body .= qq(<hr />);

		# add v0.1.8
		$body=~s/$::ismail/$::resource{diff_plugin_disable_email}/g
			if($diff_disable_email eq 1);
		return ('msg' => "$title\t$::resource{diff_plugin_title}", 'body' => $body, 'ispage'=>1);
	}
}
1;
__END__

=head1 NAME

diff.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=diff&mypage=pagename

=head1 DESCRIPTION

Display of difference of page and last backup state.

The page name must be encoded.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/diff

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/diff/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/diff.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/diff.inc.pl?view=log>

=item YukiWiki

Using Yuki::DiffText

L<http://www.hyuki.com/yukiwiki/>

=item CPAN Algorithm::Diff

L<http://search.cpan.org/dist/Algorithm-Diff/>

=back

=head1 AUTHOR

=over 4

=item Nekyo

L<http://nekyo.qp.land.to/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sfjp.jp/>

=back

=head1 LICENSE

Copyright (C) 2004-2012 by Nekyo.

Copyright (C) 2005-2012 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
