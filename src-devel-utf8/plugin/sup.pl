######################################################################
# sup.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: sup.pl,v 1.171 2011/12/31 13:06:14 papu Exp $
#
# "PyukiWiki" version 0.2.0 $$
# Author: Nekyo
# Copyright (C) 2004-2012 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2012 PyukiWiki Developers Team
# http://pyukiwiki.sfjp.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sfjp.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################

use strict;

package sup;

sub plugin_inline {
	my ($escaped_argument) = @_;
	my ($string) = split(/,/, $escaped_argument);
	return qq(<sup>$string</sup>);
}

sub plugin_usage {
	return {
		name => 'sup',
		version => '1.0',
		author => 'Nekyo',
		syntax => '&sup(string)',
		description => 'Make sub.',
		example => '&sup(string)',
	};
}

1;
__END__
=head1 NAME

sup.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &sup(strings);
 2&sup(2);=4

=head1 DESCRIPTION

Character display at upper.

This plugin is compatible with YukiWiki.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/sup

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/sup/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/sup.pl?view=log>

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

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
