######################################################################
# norelated.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: norelated.inc.pl,v 1.336 2012/03/18 11:23:57 papu Exp $
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

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/norelated/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/norelated.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/norelated.inc.pl?view=log>

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
