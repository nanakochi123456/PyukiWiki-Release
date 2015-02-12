######################################################################
# freeze.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: freeze.inc.pl,v 1.81 2011/02/22 20:59:12 papu Exp $
#
# "PyukiWiki" version 0.1.8-p3 $$
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
# This is dummy plugin for PukiWiki compatibility
######################################################################

sub plugin_freeze_convert {
	return ' ';
}

1;
__END__

=head1 NAME

freeze.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #freeze

=head1 DESCRIPTION

It is dummy plug-in for compatibility with PukiWiki. It may be used in the future.

=head1 SEE ALSO

=over 4

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/freeze/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/freeze.inc.pl?view=log>

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
