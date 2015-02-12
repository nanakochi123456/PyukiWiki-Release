######################################################################
# vote.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: vote.inc.pl,v 1.78 2010/12/29 06:21:06 papu Exp $
#
# "PyukiWiki" version 0.1.8-p1 $$
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
# 2004/12/06 v0.2 �Զ�罤����
######################################################################

use strict;

sub plugin_vote_action
{
	my $lines = $::database{$::form{mypage}};
	my @lines = split(/\r?\n/, $lines);

	my $vote_no = 0;
	my $title = '';
	my $body = '';
	my $postdata = '';
	my @args = ();
	my $cnt = 0;
	my $write = 0;
	my $vote_str = '';

	foreach (@lines) {
		if (/^#vote\(([^\)]*)\)s*$/) {
			if (++$vote_no != $::form{vote_no}) {
				$postdata .= $_ . "\n";
				next;
			}
			@args = split(/,/, $1);
			$vote_str = '';
			foreach my $arg (@args) {
				$cnt = 0;
				if ($arg =~ /^(.+)\[(\d+)\]$/) {
					$arg = $1;
					$cnt = $2;
				}
				my $e_arg = &encode($arg);
				my $vote_e_arg = "vote_" . $e_arg;

				if ($::form{$vote_e_arg} && ($::form{$vote_e_arg} eq $::resource{vote_plugin_votes})) {
					$cnt++;
				}
				if ($vote_str ne '') {
					$vote_str .= ',';
				}
				$vote_str .= $arg . '[' . $cnt . ']';
			}
			$vote_str = '#vote(' . $vote_str . ")\n";
			$postdata .= $vote_str;
			$write = 1;
		} else {
			$postdata .= $_ . "\n";
		}
	}
	if ($write) {
		$::form{mymsg} = $postdata;
		$::form{mytouch} = 'on';
		&do_write("FrozenWrite");
	} else {
		$::form{cmd} = 'read';
		&do_read;
	}
	&close_db;
	exit;
}

my $vote_no = 0;

sub plugin_vote_convert
{
	$vote_no++;
	my @args = split(/,/, shift);
	return '' if (@args == 0);

	my $escapedmypage = &escape($::form{mypage});
	my $conflictchecker = &get_info($::form{mypage}, $::info_ConflictChecker);

	my $body = <<"EOD";
<form action="$::script" method="post">
 <div class="ie5">
 <table cellspacing="0" cellpadding="2" class="style_table" summary="vote">
  <tr>
   <td align="left" class="vote_label" style="padding-left:1em;padding-right:1em"><strong>$::resource{vote_plugin_choice}</strong>
    <input type="hidden" name="vote_no" value="$vote_no" />
    <input type="hidden" name="cmd" value="vote" />
    <input type="hidden" name="mypage" value="$escapedmypage" />
    <input type="hidden" name="myConflictChecker" value="$conflictchecker" />
    <input type="hidden" name="mytouch" value="on" />
   </td>
   <td align="center" class="vote_label"><strong>$::resource{vote_plugin_votes}</strong></td>
  </tr>
EOD

	my $tdcnt = 0;
	my $cnt = 0;
	my ($link, $e_arg, $cls);
	foreach (@args) {
		$cnt = 0;

		if (/^(.+)\[(\d+)\]$/) {
			$link = $1;
			$cnt = $2;
		} else {
			$link = $_;
		}
		$e_arg = &encode($link);
		$cls = ($tdcnt++ % 2)  ? 'vote_td1' : 'vote_td2';
		$body .= <<"EOD";
  <tr>
   <td align="left" class="$cls" style="padding-left:1em;padding-right:1em;">$link</td>
   <td align="right" class="$cls">$cnt&nbsp;&nbsp;
    <input type="submit" name="vote_$e_arg" value="$::resource{vote_plugin_votes}" class="submit" />
   </td>
  </tr>
EOD
	}

	$body .= <<"EOD";
 </table>
 </div>
</form>
EOD
	return $body;
}
1;
__END__

=head1 NAME

vote.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #vote(choice1,choice2,choice3[votes],[[WikiName][votes],...)

=head1 DESCRIPTION

The form with which the choice and the vote button were located in a line is displayed.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/vote

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/vote/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/vote.inc.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nekyo

L<http://nekyo.qp.land.to/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2004-2010 by Nekyo.

Copyright (C) 2005-2010 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
