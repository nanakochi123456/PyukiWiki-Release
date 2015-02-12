######################################################################
# pagenavi.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: pagenavi.inc.pl,v 1.87 2011/05/03 20:43:28 papu Exp $
#
# "PyukiWiki" version 0.1.9 $$
# Author: Nanami http://nanakochi.daiba.cx/
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

sub plugin_pagenavi_convert {
	my ($args) = @_;
	my @args = split(/,/, $args);
	my $tmp;
	my $body;

	foreach(@args) {
		if(/\//) {
			$tmp="";
			my @pages=split(/\//,$_);
			foreach(@pages) {
				my($name,$alias)=split(/>/,$_);
				$alias=$name if($alias eq '');
				$tmp.=$alias;
				$body.=qq([[$name>$tmp]]/);
				$tmp.='/';
			}
			$body=~s/\/$//g;
		} else {
			$body.=$_;
		}
	}

	$body=&text_to_html($body);
	return $body;
}

1;
__END__

