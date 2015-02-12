######################################################################
# setupeditor.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: setupeditor.inc.pl,v 1.414 2012/03/18 11:23:51 papu Exp $
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

sub plugin_setupeditor_action {
	my $body;
	my $upperlist;
	my %pageinfo;
	%::auth=&authadminpassword(submit);
	return('msg'=>"\t$::resource{setupeditor_plugin_title}",'body'=>$auth{html})
		if($auth{authed} eq 0);

	my $setup;
	my $org;
	my $backup;
	my $setuppath="$::info_dir/setup.ini.cgi";
	my $backuppath="$::info_dir/setup.ini.bak.cgi";
	my $orgpath="$::data_home/pyukiwiki.ini.cgi";
	my $status;
	my $adminmailbody;
	if($::form{exec} ne '') {
		unlink($backuppath);
		rename($setuppath,$backuppath);
		if($::form{mymsg} eq '') {
			$status="<strong>$::resource{setupeditor_plugin_deleted}</strong><hr />";
			&send_mail_to_admin($username,"SetupDel","");
		} else {
			open(W,">$setuppath") || &print_error("$setuppath can't write");
			foreach(split(/\n/,$::form{mymsg})) {
				s/\x0D\x0A|\x0D|\x0A/\x0A/g;
				print W $_;
			}
			close(W);
			$status="<strong>$::resource{setupeditor_plugin_edited}</strong><hr />";

			$adminmailbody=$::form{mymsg};
			$adminmailbody=~s/\x0D\x0A|\x0D|\x0A/\x0A/g;
			&send_mail_to_admin($username,"SetupEdit",$adminmailbody);
		}
	}

	if(open(R,"$setuppath")) {
		foreach(<R>) {
			s/\x0D\x0A|\x0D|\x0A/\x0A/g;
			$setup.=$_;
		}
		close(R);
	}
	if(open(R,"$backuppath")) {
		foreach(<R>) {
			s/\x0D\x0A|\x0D|\x0A/\x0A/g;
			$backup.=$_;
		}
		close(R);
	}
	if(open(R,"$orgpath")) {
		foreach(<R>) {
			s/\x0D\x0A|\x0D|\x0A/\x0A/g;
			$org.=$_;
		}
		close(R);
	} else {
		&print_error("$orgpath can't read");
	}
	$body.=<<EOM;
$status
<form action="$::script" method="post" name="edit">
<input type="hidden" name="cmd" value="setupeditor" />
$auth{html}
<h2>$::resource{setupeditor_plugin_edit}</h2>
<textarea cols="$::cols" rows="$::rows" name="mymsg">@{[&htmlspecialchars($setup)]}</textarea>
<br />
<input type="submit" name="exec" value="$::resource{setupeditor_plugin_submit}" />
</form>
<hr />
<h2>$::resource{setupeditor_plugin_backup}</h2>
<textarea cols="$::cols" rows="$::rows" name="backup">@{[&htmlspecialchars($backup)]}</textarea>
<hr />
<h2>$::resource{setupeditor_plugin_org}</h2>
<textarea cols="$::cols" rows="$::rows" name="original">@{[&htmlspecialchars($org)]}</textarea>
EOM
	return('msg'=>"\t$::resource{setupeditor_plugin_title}",'body'=>$body);
}
1;
__END__

=head1 NAME

setupeditor.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=setupeditor

=head1 DESCRIPTION

info/setup.ini.cgi Editor.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/setupeditor

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Admin/setupeditor/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/setupeditor.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/setupeditor.inc.pl?view=log>

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
