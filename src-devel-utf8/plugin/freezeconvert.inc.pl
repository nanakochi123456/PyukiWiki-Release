######################################################################
# freezeconvert.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: freezeconvert.inc.pl,v 1.336 2012/03/18 11:23:57 papu Exp $
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
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################

%::infobase;

sub plugin_freezeconvert_action {
	my $body;
	my $upperlist;
	my %pageinfo;
	%::auth=&authadminpassword(submit);
	return('msg'=>"\t$::resource{freezeconvert_plugin_title}",'body'=>$auth{html})
		if($auth{authed} eq 0);

	my $freeze_execed_file="$::info_dir/.freezeconverted";
	if($::form{submit} eq '') {
		if(-r $freeze_execed_file) {
			return('msg'=>"\t$::resource{freezeconvert_plugin_title}"
				  ,'body'=>$::resource{freezeconvert_plugin_execed});
		}
		my $body=<<EOM;
<form action="$::script" method="POST">
$auth{html}
<input type="hidden" name="cmd" value="freezeconvert" />
<input type="submit" name="submit" value="$::resource{freezeconvert_plugin_btn_submit}" />
</form>
EOM
		return('msg'=>"\t$::resource{freezeconvert_plugin_title}"
			  ,'body'=>$body);
	}

	&open_info_db;
	my @pages;
	my %freeze;
	foreach my $page (sort keys %::infobase) {
		my $freeze=(&old_get_info($page, $info_IsFrozen)) ? 1 : 0;
		&set_info($page,$info_IsFrozen,$freeze);
		&delete_isfrozen($page);
		push(@pages,$page);
		$freeze{$page}=$freeze;
	}
	&close_info_db;

	open(W, ">$freeze_execed_file") || die;
	close(W);

	my $body=<<EOM;
<h2>$::resource{freezeconvert_plugin_execmsg}</h2>
<table border="1">
EOM
	foreach(@pages) {
		$body.=<<EOM;
<tr><td>$_</td><td>@{[$freeze{$_} eq 1 ?  $::resource{freezeconvert_plugin_freeze} : $::resource{freezeconvert_plugin_nofreeze}]}</td></tr>
EOM
	}
	$body.="</table>\n";
	return('msg'=>"\t$::resource{freezeconvert_plugin_title}",'body'=>$body);}

sub old_get_info {
	my ($page, $key) = @_;
	my %info = map { split(/=/, $_, 2) } split(/\n/, $infobase{$page});
	return $info{$key};
}

sub delete_isfrozen {
	my ($page)=@_;
	my %info = map { split(/=/, $_, 2) } split(/\n/, $infobase{$page});
	my %info = map { split(/=/, $_, 2) } split(/\n/, $infobase{$page});
	delete $info{$info_IsFrozen};
	my $s = '';
	for (keys %info) {
		if($_ ne $info_IsFrozen) {
			$s .= "$_=$info{$_}\n";
		}
	}
	$infobase{$page} = $s;
}
1;
__END__

=head1 NAME

freezeconvert.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=freezeconvert

=head1 DESCRIPTION

Freeze wiki converter to PukiWiki Compatible.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/freezeconvert

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Admin/freezeconvert/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/freezeconvert.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/freezeconvert.inc.pl?view=log>

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
