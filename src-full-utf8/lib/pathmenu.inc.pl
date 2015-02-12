######################################################################
# pathmenu.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: pathmenu.inc.pl,v 1.32 2012/03/01 10:39:24 papu Exp $
#
# "PyukiWiki" version 0.2.0-p2 $$
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
# This is extented plugin.
# To use this plugin, rename to 'pathmenu.inc.cgi'
######################################################################
use strict;
sub plugin_pathmenu_init {
	if(&exist_plugin("topicpath") ne 0) {
		my $mypage=$::form{mypage};
		my @path_array = split($topicpath::SEPARATOR,$mypage);
		my $c=0;
		my @paths=();
		my $pathtop;
		foreach my $pagename(@path_array) {
			if($c eq 0) {
				$pathtop=$pagename;
			} else {
				$pathtop .= $topicpath::SEPARATOR . $pagename;
			}
			push(@paths, $pathtop);
			$c++;
		}
		foreach my $pagename(@paths) {
			$::MenuBar		=&chkbars($pagename, $::MenuBar);
			$::SideBar		=&chkbars($pagename, $::SideBar);
			$::TitleHeader	=&chkbars($pagename, $::TitleHeader);
			$::Header		=&chkbars($pagename, $::Header);
			$::Footer		=&chkbars($pagename, $::Footer);
			$::BodyHeader	=&chkbars($pagename, $::BodyHeader);
			$::BodyFooter	=&chkbars($pagename, $::BodyFooter);
			$::SkinFooter	=&chkbars($pagename, $::SkinFooter);
		}
		return('init'=>1);
	}
	return('init'=>0);
}
sub chkbars {
	my($pg,$menu)=@_;
	if($::database{"$pg$topicpath::SEPARATOR$menu"} ne '') {
		return "$pg$topicpath::SEPARATOR$menu";
	}
	return $menu;
}
1;
__DATA__
sub plugin_pathmenu_setup {
	return(
	'ja'=>'階層下にMenuBar等を作る',
	'en'=>'Create a hierarchy under MenuBar etc. system page.',
	'override'=>'none',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/pathmenu/'
	);
__END__
