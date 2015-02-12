######################################################################
# br.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: br.pl,v 1.83 2011/01/25 03:11:15 papu Exp $
#
# "PyukiWiki" version 0.1.8-p2 $$
# Author: Nekyo
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

use strict;
package br;

sub plugin_block {
	return &plugin_inline;
}

sub plugin_inline {
	return qq(<br />);
}

sub plugin_usage {
	return {
		name => 'br',
		version => '1.0',
		author => 'Nekyo <nekyo (at) yamaneko (dot) club (dot) ne (dot) jp>',
		syntax => '&br',
		description => 'line break.',
		example => '&br',
	};
}

1;
__END__

=head1 NAME

br.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &br;
 line&br;break

=head1 DESCRIPTION

A new line is started in the specified position.

This plugin is compatible with YukiWiki.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/br

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/br/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/br.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nekyo

L<http://nekyo.qp.land.to/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2004-2011 by Nekyo.

Copyright (C) 2005-2011 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
