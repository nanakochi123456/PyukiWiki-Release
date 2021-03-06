######################################################################
# navi.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: navi.inc.pl,v 1.336 2012/03/18 11:23:57 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
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
# Based on PukiWiki 1.4.6 navi.inc.php,v 1.22 2005/04/02 06:33:39 henoheno
#
#*Usage
# #navi(パターン[,prefixのタイトル][,reverse])
######################################################################
$navi::head_link=1
	if(!defined($navi::head_link));
######################################################################
sub plugin_navi_convert {
	my ($args) = @_;
	my @args = split(/,/, $args);
	my $prefix = '';
	my @args = split(/,/, shift);
	my $reverse = 0;
	my (@pages, $txt, @txt, $tocnum);
	my $body = '';
	my $prefixtitle;
	if (@args > 0) {
		$prefix = shift(@args);
		foreach my $arg (@args) {
			if (lc $arg eq "reverse") {
				$reverse = 1;
			} else {
				$prefixtitle=$arg;
			}
		}
	}
	if($prefix eq '') {
		$prefix = $::form{mypage};
		$prefix =~ s/\/.*?$//g;
	}
	foreach my $page (sort keys %::database) {
		push(@pages, $page) if ($page =~ /^$prefix\/|^$prefix$/ && &is_readable($page) && $page!~/$::non_list/);
	}
	@pages = reverse(@pages) if ($reverse);
	my ($pageprev,$pagenow,$pagenext,$pagepush);
	foreach my $page(@pages) {
		if($pagenow ne '') {
			$pagenext=$page;
			last;
		} elsif($page eq $::form{mypage}) {
			$pagenow=$page;
		}
		$pageprev=$pagepush;
		$pagepush=$page;
	}
	if($navi::head_link eq 1 && $::IN_HEAD!~/<link/) {
		$::IN_HEAD.=qq(<link rel="up" href="@{[&make_cookedurl(&encode($prefix))]}" title="$prefix" />\n);
		$::IN_HEAD.=qq(<link rel="prev" href="@{[&make_cookedurl(&encode($pageprev))]}" title="$pageprev" />\n)
			if($pageprev ne '');
		$::IN_HEAD.=qq(<link rel="next" href="@{[&make_cookedurl(&encode($pagenext))]}" title="$pagenext" />\n)
			if($pagenext ne '');
	}
	$body.=qq(<ul class="navi">\n);
	$body.=qq(<li class="navi_left">@{[&make_link_wikipage($pageprev,$::resource{prevbutton})]}</li>\n)
		if($pageprev ne '');
	$body.=qq(<li class="navi_right">@{[&make_link_wikipage($pagenext,$::resource{nextbutton})]}</li>)
		if($pagenext ne '');
	$body.=qq(<li class="navi_none">@{[&make_link_wikipage($prefix,$prefixtitle eq '' ? $prefix : $prefixtitle)]}</li>\n</ul>\n<hr class="full_hr" />);
}
1;
__END__
