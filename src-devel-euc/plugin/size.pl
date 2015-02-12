######################################################################
# size.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: size.pl,v 1.81 2011/02/22 20:59:12 papu Exp $
#
# "PyukiWiki" version 0.1.8-p3 $$
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
package size;

sub plugin_inline {
	my ($size, $body) = split(/,/, shift);
	if ($size eq '' or $body eq '') {
		return "";
	}
	return "<span style=\"font-size:" . $size . "px;display:inline-block;line-height:130%;text-indent:0px\">$body</span>";
}
1;
__END__

=head1 NAME

size.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &size(20){Display Size 20px};

=head1 DESCRIPTION

Specify size of a character.

This plugin is compatible with YukiWiki.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/size

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/size/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/size.pl?view=log>

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
