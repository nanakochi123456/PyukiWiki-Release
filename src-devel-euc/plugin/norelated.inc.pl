######################################################################
# norelated.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: norelated.inc.pl,v 1.76 2010/12/14 22:20:00 papu Exp $
#
# "PyukiWiki" version 0.1.8 $$
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
# This is dummy plugin for PukiWiki compatibility
######################################################################

sub plugin_norelated_convert {
	return ' ';
}

1;
__END__

=head1 NAME

norelated.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #norelated

=head1 DESCRIPTION

It is dummy plug-in for compatibility with PukiWiki. It may be used in the future.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/norelated

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/norelated/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/norelated.inc.pl?view=log>

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
