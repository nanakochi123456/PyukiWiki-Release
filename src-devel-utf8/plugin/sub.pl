######################################################################
# sub.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: sub.pl,v 1.336 2012/03/18 11:23:57 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
# Author: Nekyo http://nekyo.qp.land.to/
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

use strict;

package sub;

sub plugin_inline {
	my ($escaped_argument) = @_;
	my ($string) = split(/,/, $escaped_argument);
	return qq(<sub>$string</sub>);
}

sub plugin_usage {
	return {
		name => 'sub',
		version => '1.0',
		author => 'Nekyo <nekyo (at) yamaneko (dot) club (dot) ne (dot) jp>',
		syntax => '&sub(string)',
		description => 'Make sub.',
		example => '&sub(string)',
	};
}

1;
__END__

=head1 NAME

sub.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &sub(strings);
 011101010101&sub(2);=0x755

=head1 DESCRIPTION

Character display at bottom.

This plugin is compatible with YukiWiki.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/sub

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/sub/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/sub.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/sub.inc.pl?view=log>

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
