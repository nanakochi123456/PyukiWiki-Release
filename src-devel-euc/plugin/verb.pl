######################################################################
# verb.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: verb.pl,v 1.77 2010/12/29 06:21:06 papu Exp $
#
# "PyukiWiki" version 0.1.8-p1 $$
# Author: Hiroshi Yuki http://www.hyuki.com/
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

use strict;

package verb;

sub plugin_inline {
	my ($escaped_argument) = @_;
	return qq(<span class="verb">$escaped_argument</span>);
}

sub plugin_usage {
	return {
		name => 'verb',
		version => '1.0',
		author => 'Hiroshi Yuki http://www.hyuki.com/',
		syntax => '&verb(as-is string)',
		description => 'Inline verbatim (hard).',
		example => '&verb(ThisIsNotWikiName)',
	};
}

1;
__END__
=head1 NAME

verb.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &verb(text...);

=head1 DESCRIPTION

Disregards the format rule of PyukiWiki

It is for compatibility with YukiWiki.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/verb

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/verb/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/verb.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Hiroshi Yuki

L<http://www.hyuki.com/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2002-2010 by Hiroshi Yuki.

Copyright (C) 2005-2010 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
