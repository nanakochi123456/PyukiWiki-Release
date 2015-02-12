######################################################################
# admin.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: admin.inc.pl,v 1.40 2010/12/29 06:21:06 papu Exp $
#
# "PyukiWiki" version 0.1.8-p1 $$
# Author: Nanami http://nanakochi.daiba.cx/
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

$admin::ignore_plugin=q{^edit|^admin\.|^newpage|^attach};

sub plugin_admin_action {
	my $body;
	%::auth=&authadminpassword(submit);
	return('msg'=>"\t$::resource{adminbutton}",'body'=>$auth{html})
		if($auth{authed} eq 0);

	my @adminlist=();
	my @dir=();
	opendir(DIR,"$::plugin_dir");
	while(my $dir=readdir(DIR)) {
		push(@dir,$dir);
	}
	closedir(DIR);
	@dir=sort @dir;
	foreach my $dir(@dir) {
		if($dir=~/(.*?)\.inc\.pl$/ && $dir!~/($admin::ignore_plugin)/) {
			my $flag=0;
			my $res="";
			open(R, "$::plugin_dir/$dir");
			foreach my $line(<R>) {
				$flag++ if($line=~/^sub.*\_action/);
				$flag++ if($line=~/\&authadminpassword/);
				if($flag eq 2) {
					$dir=~s/\.inc\.pl$//g;
					push(@adminlist,$dir);
					last;
				}
			close(R);
			}
		}
	}

	foreach my $plugin(@adminlist) {
		open(R, "$::plugin_dir/$plugin.inc.pl");
		my $res=$plugin;
		foreach my $line(<R>) {
			if($line=~/resource:(.+)/) {
				$res=$1;
			}
		}
		close(R);
		my $path="$::res_dir/$res.$::lang.txt";
		%::resource = &read_resource($path,%::resource) if(-r $path);
		$msg="$plugin";
		$msg.=" - " . $::resource{$plugin . "_plugin_title"}
			if($::resource{$plugin . "_plugin_title"} ne '');
		$body.=<<EOM;
<div align="center">
<form action="$::script" method="POST">
<input type="hidden" name="cmd" value="$plugin" />
$auth{html}
<input type="submit" value="$msg" />
</form>
</div>
EOM
	}
	return ('msg'=>"\t$::resource{adminbutton}", 'body'=>$body);
}
1;
__END__

=head1 NAME

admin.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=admin

=head1 DESCRIPTION

The menu which supports execution of management plugin.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/admin

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Admin/admin/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/admin.inc.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2010 by Nanami.

Copyright (C) 2005-2010 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
