######################################################################
# color.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: color.pl,v 1.337 2012/03/18 11:23:57 papu Exp $
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
# Usage: &color(color,bgcolor) { body };
# Usage: &color(color) { body };
# Usage: &color(,bgcolor) { body };
# v0.2.0-p3 : 背景色のみの設定をできるようにした。
######################################################################

use strict;
package color;

sub plugin_inline {
	my @args = split(/,/, shift);
	my ($color, $bgcolor, $body);

	if (@args == 3) {
		$color = $args[0];
		$bgcolor = $args[1];
		$body = $args[2];
		if ($body eq '') {
			$body = $bgcolor;
			$bgcolor = '';
		}
	} elsif (@args == 2) {
		$color = $args[0];
		$body = $args[1];
	} else {
		return '';
	}
	if ($color eq '' && $bgcolor eq '' || $body eq '') {
		return '';
	}
	my $style;
	$style="color:$color" if($color ne '');
	$style="background-color:$bgcolor" if($bgcolor ne '');

	return "<span style=\"$style\">$body</span>";
}

1;
__END__

=head1 NAME

color.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &color(color, [background-color]){text};
 &color(red){Sample Text};
 &color(#ff0000,#000000){Sample Text};
 &color(,white){Sample Text};

=head1 DESCRIPTION

The character color and background color of a text are specified.

This plugin is compatible with YukiWiki.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/color

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/color/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/color.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/color.pl?view=log>

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
