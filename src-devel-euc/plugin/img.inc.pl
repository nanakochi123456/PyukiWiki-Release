######################################################################
# img.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: img.inc.pl,v 1.86 2011/05/03 20:43:28 papu Exp $
#
# "PyukiWiki" version 0.1.9 $$
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
# Return:LF Code=Shift-JIS 1TAB=4Spaces
######################################################################
# �摜��\������B
# :����|
#  #img(�摜��URI[[,����],alt�R�����g])
# �����Fr,right(�E��) or l,left(����) or module(index.cgi ����̌Ăяo��)
# or ����ȊO(�N���A)~
# Pyukiwiki Classic v0.1.6b ��肱�̊֐��� 
# lib/wiki.cgi �� img �ϊ��ł��Ăяo���悤�C���B(�K�{)
######################################################################

sub plugin_img_convert {
	my ($uri, $align, $alt) = split(/,/, shift);
	$uri   = &trim($uri);
	$align = &trim($align);
	$alt   = &trim($alt);
	my $module = 0;
	my $res = '';

	if ($align =~ /^(r|right)/i) {
		$align = 'right';
	} elsif ($align =~ /^(l|left)/i) {
		$align = 'left';
	} elsif ($align =~ /^module$/i) {
		$module = 1;
	} else {
		return '<div style="clear:both"></div>';
	}
#	if ($uri =~ /^(https?|ftp):/) {
		if ($uri =~ /\.(gif|png|jpe?g)$/i) {
			if ($module == 1) {
				# �K�v�ł���΁A���̕������g������B
				$res .= "<a href=\"$uri\"><img src=\"$uri\" /></a>\n";
			} else {
				$res .= "<div style=\"float:$align; padding:.5em 1.5em .5em 1.5em;\"><img src=\"$uri\"";
				$res .= " alt=\"$alt\"" if ($alt ne '');
				$res .= " /></div>\n";
			}
		}
#	}
	return $res;
}
1;
__END__

=head1 NAME

img.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #img(http://example.com/image.png)
 #img(http://example.com/image.jpg,right)
 #img(http://example.com/image.gif,l,AlternateText)
 #img(,c)

=head1 DESCRIPTION

Display Image File

=head1 USAGE

 #img(image_url,[alt],[l|left],[r|right],c)

=over 4

=item image_url

URL of a picture is specified.

=item left | l

Align to Left

=item right | r

Align to Right

=item c

Disable a surroundings lump of a text

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/img

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/img/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/img.inc.pl?view=log>

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
