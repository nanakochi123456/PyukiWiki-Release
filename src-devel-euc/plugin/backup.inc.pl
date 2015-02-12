######################################################################
# backup.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: backup.inc.pl,v 1.415 2012/03/18 11:23:51 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
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
# v0.2.0 First Release
######################################################################

$backup::nostring=qq(<span style="font-size: 70%;">[CR]</span>);

sub plugin_backup_action {
	if($::form{mypage} eq "") {
		my $navi = qq(<div id="body"><div id="top" style="text-align:center">);
		my $body = qq(</div>);
		my $prev = '';
		my $char = '';
		my $idx = 1;

		&open_backup;
		foreach my $page (sort keys %::backupbase) {
			next if ($page =~ $::non_list);
			next unless(&is_readable($page));
			$char = substr($page, 0, 1);
			if (!($char =~ /[a-zA-Z0-9]/)) {
				$char = $::resource{backup_plugin_otherchara};
			}
			if ($prev ne $char) {
				if ($prev ne '') {
					$navi .= " |\n";
					$body .= "  </ul>\n </li>\n</ul>\n";
				}
				$prev = $char;
				$navi .= qq(<a id="top_$idx" href="?cmd=backup#head_$idx"><strong>$prev</strong></a>);
				$body .= <<"EOD";
	<ul>
	 <li><a id="head_$idx" href="?cmd=backup#top_$idx"><strong>$prev</strong></a>
	  <ul>
EOD
				$idx++;
			}
			my $backupmsg=$::backupbase{$page};
			my %backups;
			my $count=0;
			foreach(split(/\n/,$backupmsg)) {
				if(/^>>>>>>>>>>\s(\d+)/) {
					$count++;
					$backups{$count}{time}=&date($::backup_format,$1);
					next;
				}
			}

			$body .= qq(<li><a href="$::script?cmd=backup&amp;mypage=@{[&encode($page)]}">@{[&escape($page)]}</a> - $backups{$count}{time}</li>\n);
		}
		$body .= qq(</li></ul>);
		&close_backup;
		$body=$::resource{backup_plugin_list_notfound}
			if($count eq 0);

		return ('msg' => "\t$::resource{backup_plugin_list_title}", 'body' => $body, 'ispage'=>1);

	}
	if($::form{action} eq "delete") {
		%::auth=&authadminpassword(submit);
		my $title=$::resource{backup_plugin_delete_title};
		$title=~s/\$1/$::form{mypage}/g;
		return('msg'=>"\t$title",'body'=>$auth{html})
			if($auth{authed} eq 0);
		if($::form{cancel} ne '') {
			print &http_header(
				"Status: 302",
				"Location: $::basehref?cmd=backup&amp;mypage=@{[&encode($::form{mypage})]}",
				$::HTTP_HEADER
				);
			close(STDOUT);
			&exec_explugin_last;
			exit;
		}
		if($::form{ok} eq '') {
			my $delete = $::resource{backup_plugin_delete};
			$delete=~s/\$1/$::form{mypage}/g;
			my $confirmmsg=$::resource{backup_plugin_delete_confirm};
			$confirmmsg=~s/\$1/$::form{mypage}/g;

			my $body=<<EOM;
<h3>$delete</h3>
<form action="$::script" method="POST">
$auth{html}
<input type="hidden" name="cmd" value="backup" />
<input type="hidden" name="action" value="delete" />
<input type="hidden" name="mypage" value="$::form{mypage}" />
$confirmmsg<br />
<input type="submit" name="ok" value="$::resource{backup_plugin_delete_confirm_ok}" />
<input type="submit" name="cancel" value="$::resource{backup_plugin_delete_confirm_cancel}" />
</form>
EOM
			return('msg'=>"\t$title",'body'=>$body);
		}
		&open_backup;
		delete $::backupbase{$::form{mypage}};
		&close_backup;
		my $body=<<EOM;
<strong>$::resource{backup_plugin_deleted}</strong>
<hr />
<a href="$::script?@{[&encode($::form{mypage})]}">$::resource{backup_plugin_return}</a>
EOM
		$body=~s/\$1/$::form{mypage}/g;
		return('msg'=>"\t$title",'body'=>$body);
	} else {
		&open_backup;
		my $title = $::form{mypage};
		my $backupmsg=$::backupbase{$::form{mypage}};
		&close_backup;
		if($backupmsg eq '') {
			&close_backup;
			my $body = qq(<h3>$::resource{backup_plugin_msg}</h3>);
			$body.=qq($::resource{backup_plugin_nobackup});
			$body=~s/\$1/<a href=\"@{[&make_cookedurl(&encode($::form{mypage}))]}\">$::form{mypage}<\/a>/g;
			$body.=qq(<hr /><a href="$::script?cmd=backup">$::resource{backup_plugin_list_title}</a>);
			return ('msg' => "$title\t$::resource{backup_plugin_title}", 'body' => $body, 'ispage'=>1);
		}
		my %backups;
		my $count=0;
		foreach(split(/\n/,$backupmsg)) {
			if(/^>>>>>>>>>>\s(\d+)(.*)/) {
				$count++;
				$backups{$count}{time}=&date($::backup_format,$1);
				$backups{$count}{info}=substr($2,1);
				next;
			}
			$backups{$count}{data}.=&htmlspecialchars("$_\n");
		}
		my $body = qq(<h3>$::resource{backup_plugin_msg}</h3>);
		if($::form{action} eq "source") {
			my $age=$::form{age};
			my $titlemsg=$::resource{backup_plugin_source_title};
			$titlemsg=~s/\$1/$age/g;
			$body.=qq(<ul>);
			my $tmp=$::resource{backup_plugin_return_top};
			$tmp=~s/\$1/$::form{mypage}/g;
			$body.=qq(<li><a href="$script?cmd=backup&amp;mypage=@{[&encode($::form{mypage})]}">$tmp</a></li>\n);
			$body.=qq(<li><a href="$script?cmd=backup&amp;mypage=@{[&encode($::form{mypage})]}&amp;age=$age&amp;action=diff">$::resource{backup_plugin_diff_link}</a></li>\n);
			$body.=qq(<li><a href="$script?cmd=backup&amp;mypage=@{[&encode($::form{mypage})]}&amp;age=$age&amp;action=nowdiff">$::resource{backup_plugin_nowdiff_link}</a></li>\n);
			$body.=&plugin_backup_goto($::form{mypage});
			$body.=qq(</ul><hr />\n);
			$body.=qq(<em>$age ($backups{$age}{time})</em>\n);
			$body.=qq(<pre>$backups{$age}{data}</pre>\n);
			$body=~s/$::ismail/$::resource{backup_plugin_disable_email}/g
				if($::backup_disable_email eq 1);

			return ('msg' => "$title\t$titlemsg", 'body' => $body, 'ispage'=>1);
		} elsif($::form{action} eq "diff") {
			my $age=$::form{age};
			my $titlemsg=$::resource{backup_plugin_diff_title};
			$titlemsg=~s/\$1/$age/g;
			$body.=qq(<ul>);
			my $tmp=$::resource{backup_plugin_return_top};
			$tmp=~s/\$1/$::form{mypage}/g;
			$body.=qq(<li><a href="$script?cmd=backup&amp;mypage=@{[&encode($::form{mypage})]}">$tmp</a></li>\n);
			$body.=qq(<li><a href="$script?cmd=backup&amp;mypage=@{[&encode($::form{mypage})]}&amp;age=$age&amp;action=nowdiff">$::resource{backup_plugin_nowdiff_link}</a></li>\n);
			$body.=qq(<li><a href="$script?cmd=backup&amp;mypage=@{[&encode($::form{mypage})]}&amp;age=$age&amp;action=source">$::resource{backup_plugin_source_link}</a></li>\n);
			$body.=&plugin_backup_goto($::form{mypage});
			$body.=qq(</ul><hr />\n);
			$body.=qq($::resource{backup_plugin_diff_notice}\n);
			my $ageold=$age-1;
			$diff=&plugin_backup_makediff($backups{$age}{data},$backups{$ageold}{data});
$::debug.="diff $age @{[$age-1]}\n";
			$body.=qq(<pre>$diff</pre>\n);
			return ('msg' => "$title\t$titlemsg", 'body' => $body, 'ispage'=>1);
		} elsif($::form{action} eq "nowdiff") {
			my $age=$::form{age};
			my $titlemsg=$::resource{backup_plugin_nowdiff_title};
			$titlemsg=~s/\$1/$age/g;
			$body.=qq(<ul>);
			my $tmp=$::resource{backup_plugin_return_top};
			$tmp=~s/\$1/$::form{mypage}/g;

			$body.=qq(<li><a href="$script?cmd=backup&amp;mypage=@{[&encode($::form{mypage})]}">$tmp</a></li>\n);
			$body.=qq(<li><a href="$script?cmd=backup&amp;mypage=@{[&encode($::form{mypage})]}&amp;age=$age&amp;action=diff">$::resource{backup_plugin_diff_link}</a></li>\n);
			$body.=qq(<li><a href="$script?cmd=backup&amp;mypage=@{[&encode($::form{mypage})]}&amp;age=$age&amp;action=source">$::resource{backup_plugin_source_link}</a></li>\n);

			$body.=&plugin_backup_goto($::form{mypage});
			$body.=qq(</ul><hr />\n);
			$body.=qq($::resource{backup_plugin_diff_notice}\n);
			$diff=&plugin_backup_makediff($::database{$::form{mypage}},$backups{$age}{data});
			$body.=qq(<pre>$diff</pre>\n);
			return ('msg' => "$title\t$titlemsg", 'body' => $body, 'ispage'=>1);
		} elsif($::form{action} eq "recent") {
			%::auth=&authadminpassword(submit);
			return('msg'=>"\t$title",'body'=>$auth{html})
				if($auth{authed} eq 0);
		}
		my $recentmode=$::form{action} eq "recent" && $auth{authed} eq 1 ? 1 : 0;

		$body .= qq(<ul><li><a href="$script?cmd=backup">$::resource{backup_plugin_list_title}</a></li>);
		$body .= qq(<ul>);
		my $recent = $::resource{backup_plugin_recent_title};
		$recent=~s/\$1/$::form{mypage}/g;
		my $delete = $::resource{backup_plugin_delete};
		$delete=~s/\$1/$::form{mypage}/g;
		$body.= qq(<li><a href="$script?cmd=backup&amp;action=recent&amp;mypage=@{[&encode($::form{mypage})]}">$recent</a></li>)
			if($recentmode eq 0);
		$body.= qq(<li><a href="$script?cmd=backup&amp;action=delete&amp;mypage=@{[&encode($::form{mypage})]}">$delete</a></li>);
		$body.=&plugin_backup_goto($::form{mypage});
		for(my $i=1; $i<=$count; $i++) {
			$body.=qq(<li>$i. ($backups{$i}{time}) [ );
			$body.=qq(<a href="$script?cmd=backup&amp;mypage=@{[&encode($::form{mypage})]}&amp;age=$i&amp;action=diff">$::resource{backup_plugin_diff_link}</a> | );
			$body.=qq(<a href="$script?cmd=backup&amp;mypage=@{[&encode($::form{mypage})]}&amp;age=$i&amp;action=nowdiff">$::resource{backup_plugin_nowdiff_link}</a> | );
			$body.=qq(<a href="$script?cmd=backup&amp;mypage=@{[&encode($::form{mypage})]}&amp;age=$i&amp;action=source">$::resource{backup_plugin_source_link}</a> ]);
			$body.=qq(<br />$backups{$i}{info}) if($recentmode eq 1);
			$body.=qq(</li>);
		}
		$body .= qq(</ul></ul>);
		return ('msg' => "$title\t$::resource{backup_plugin_title}", 'body' => $body, 'ispage'=>1);
	}
}

sub plugin_backup_goto {
	my ($page)=shift;
	my $goto = $::resource{backup_plugin_goto};
	my $body;
	$goto=~s/\$1/@{[&escape($page)]}/g;
	return qq(<li><a href="@{[&make_cookedurl(&encode($::form{mypage}))]}">$goto</a></li>\n);
}

sub plugin_backup_makediff {
	my($msg2,$msg1)=@_;
	my @msg1 = split(/\n/, $msg1);
	my @msg2 = split(/\n/, $msg2);
	&load_module("Yuki::DiffText");
	my $diff=Yuki::DiffText::difftext(\@msg1, \@msg2);
	my $body;
	foreach (split(/\n/, $diff)) {
		if (/^\+(.*)/) {
			$body .= qq(<b class="diff_added">$1@{[$1 eq '' ? "$backup::nostring" : '']}</b>\n);
		} elsif (/^\-(.*)/) {
			$body .= qq(<s class="diff_removed">$1@{[$1 eq '' ? "$backup::nostring" : '']}</s>\n);
		} elsif (/^\=(.*)/) {
			$body .= qq(<span class="diff_same">$1</span>\n);
		} else {
			$body .= qq|??? $_\n|;
		}
	}
	$body=~s/$::ismail/$::resource{backup_plugin_disable_email}/g
		if($::diff_disable_email eq 1);

	return $body;
}
1;
__END__

=head1 NAME

backup.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=backup&mypage=pagename

 ?cmd=backup

=head1 DESCRIPTION

Display of Histories of page backups.

The page name must be encoded.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/backup

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/backup/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/backup.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/backup.inc.pl?view=log>

=item YukiWiki

Using Yuki::DiffText

L<http://www.hyuki.com/yukiwiki/>

=item CPAN Algorithm::Diff

L<http://search.cpan.org/dist/Algorithm-diff/>

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

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
