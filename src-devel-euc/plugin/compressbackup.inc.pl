######################################################################
# compressbackup.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: compressbackup.inc.pl,v 1.156 2012/01/31 10:11:58 papu Exp $
#
# "PyukiWiki" version 0.2.0-p1 $$
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

sub plugin_compressbackup_action {
	my @convertdirs=(
		"$::backup_dir",
	);


	%::auth=&authadminpassword(submit);
	return('msg'=>"\t$::resource{compressbackup_plugin_title}",'body'=>$auth{html})
		if($auth{authed} eq 0);

	if($::form{confirm} eq '') {
		$body=<<EOM;
<form action="$::script" method="POST">
$auth{html}
<input type="hidden" name="cmd" value="compressbackup" />
$::resource{compressbackup_pluin_convert}<br />
<input type="submit" name="confirm" value="$::resource{compressbackup_pluin_convert_yes}" />
</form>
EOM
		return('msg'=>"\t$::resource{compressbackup_plugin_title}"
			  ,'body'=>"$body");
	}

	# compress backup
	&open_backup;
	foreach my $page (sort keys %::database) {
		my $backuptext=$::backupbase{$page};
		if($backuptext ne '') {
			$::backupbase{$page}=$backuptext;
		}
	}
	&close_backup;
	return('msg'=>"\t$::resource{compressbackup_plugin_title}"
		  ,'body'=>"$::resource{compressbackup_pluin_converted}<hr />$body");
}

1;
__END__

=head1 NAME

compressbackup.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=compressbackup

=head1 DESCRIPTION

Compress Backup Directory

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/compressbackup

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Admin/compressbackup/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/compressbackup.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/compressbackup.inc.pl?view=log>

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
