######################################################################
# link.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: link.pl,v 1.505 2012/03/18 11:23:51 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
# Author: Hiroshi Yuki http://www.hyuki.com/
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
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
use strict;
package link;
sub plugin_inline {
	my ($escaped_argument) = @_;
	my ($caption, $url,$target) = split(/,/, $escaped_argument);
	if ($url =~ /^(mailto|http|https|ftp):/) {
		return &make_link_url("link",$url,$caption,@{[$::use_autoimg && $caption=~/\.$::image_extention$/o ? $caption : ""]},$target);
#		return qq(<a href="$url">$caption</a>);
	} elsif($url=~/(?:[Mm][Aa][Ii][Ll][Tt][Oo]:($::ismail))|($::ismail)/) {
		return &make_link_mail($url,@{[$::use_autoimg && $caption=~/\.$::image_extention$/o ? &make_link_image($caption,"Mail") : $caption]});
	} else {
		return qq(&link($escaped_argument));
	}
}
sub plugin_usage {
	return {
		name => 'link',
		version => '1.1',
		author => 'Hiroshi Yuki http://www.hyuki.com/',
		syntax => '&link(caption,url)',
		description => 'Create link with given caption..',
		example => "Please visit &link(Hiroshi Yuki,http://www.hyuki.com/).",
	};
}
sub make_link_url {
	my $funcp = $::functions{"make_link_url"};
	return &$funcp(@_);
}
sub make_link_mail {
	my $funcp = $::functions{"make_link_mail"};
	return &$funcp(@_);
}
sub make_link_image {
	my $funcp = $::functions{"make_link_image"};
	return &$funcp(@_);
}
1;
__END__
