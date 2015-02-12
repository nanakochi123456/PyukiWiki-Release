######################################################################
# iecompatiblehack.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: iecompatiblehack.inc.pl,v 1.8 2011/01/25 03:11:15 papu Exp $
#
# "PyukiWiki" version 0.1.8-p2 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2011 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2011 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'iecompatiblehack.inc.cgi'
######################################################################
#
# IEの互換表示ボタンをなくすプラグイン
#
######################################################################


# Initlize

sub plugin_iecompatiblehack_init {
	my $agent=$ENV{HTTP_USER_AGENT};
	my $header;
	if($ENV{HTTP_USER_AGENT}=~/MSIE (\d).(\d)/) {
		if($1 > 6) {
			$header=<<EOM;
X-UA-Compatible: IE=$1
EOM
		}
	}
	return ('http_header'=>$header, 'init'=>1, 'func'=>'');
}

1;
__DATA__
sub plugin_iecompatiblehack_setup {
	return(
	'ja'=>'IEの互換表示ボタンを強制的になくすプラグイン',
	'en'=>'For Internet Explorer, disable compatible button',
	'override'=>'none',
	'url'=>'http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/iecompatiblehack/'
	);
}
__END__
=head1 NAME

iecompatiblehack.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

For Internet Explorer, disable compatible button

=head1 USAGE

rename to iecompatiblehack.inc.cgi

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/iecompatiblehack

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/iecompatiblehack/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/iecompatiblehack.inc.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2011 by Nanami.

Copyright (C) 2005-2011 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
