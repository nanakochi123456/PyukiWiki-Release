######################################################################
# slashpage.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: slashpage.inc.pl,v 1.503 2012/03/18 11:23:50 papu Exp $
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
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'slashpage.inc.cgi'
######################################################################
use strict;
sub plugin_slashpage_init {
	&exec_explugin_sub("lang");
	@::PLUGIN_SLASHPAGE_STACK=();
	foreach my $pages (keys %::database) {
		push(@::PLUGIN_SLASHPAGE_STACK,$pages) if($pages=~/\//);
	}
	@::PLUGIN_SLASHPAGE_STACK=sort @::PLUGIN_SLASHPAGE_STACK;
	my $req=$ENV{QUERY_STRING};
	if($req ne '' && $::form{mypage} eq $::FrontPage && ($::form{cmd} eq '' || $::form{cmd} eq 'read')) {
		if (&is_exist_page($req)) {
			$::form{mypage}=$req;
		} else {
			foreach my $pagetemp (@::PLUGIN_SLASHPAGE_STACK) {
				my $pagetemp2=$pagetemp;
				$pagetemp2=~s/.*\///g;
				if($pagetemp2 eq $req) {
					$::form{mypage}=$pagetemp;
					last;
				}
			}
		}
	}
	return('init'=>1,'func'=>'make_link_wikipage', 'make_link_wikipage'=>\&make_link_wikipage);
}
sub make_link_wikipage {
	my($chunk1,$escapedchunk)=@_;
	my($chunk,$anchor)=$chunk1=~/^([^#]+)#?(.*)/;
	my $cookedchunk  = &encode($chunk);
	my $cookedurl=&make_cookedurl($cookedchunk);
	if (&is_exist_page($chunk)) {
		if($anchor eq '') {
			return qq(<a title="$chunk" href="$cookedurl">$escapedchunk</a>);
		} else {
			return qq(<a title="$chunk" href="$cookedurl#$anchor">$escapedchunk</a>);
		}
	}
	foreach my $pagetemp (@::PLUGIN_SLASHPAGE_STACK) {
		my $pagetemp2=$pagetemp;
		$pagetemp2=~s/.*\///g;
		if($pagetemp2 eq $chunk) {
			$cookedchunk  = &encode($pagetemp);
			$cookedurl=&make_cookedurl($pagetemp);
			if($anchor eq '') {
				return qq(<a title="$pagetemp" href="$cookedurl">$escapedchunk</a>);
			} else {
				return qq(<a title="$1" href="$cookedurl#$anchor">$escapedchunk</a>);
			}
		}
	}
	if (&is_editable($chunk)) {
		if ($::editchar eq 'this') {
			return qq(<a title="$::resource{editthispage}" class="editlink" href="$::script?cmd=edit&amp;mypage=$cookedchunk">$escapedchunk</a>);
		} elsif ($::editchar) {
			return qq($escapedchunk<a title="$::resource{editthispage}" class="editlink" href="$::script?cmd=edit&amp;mypage=$cookedchunk">$::editchar</a>);
		}
	}
	return $escapedchunk;
}
1;
__DATA__
sub plugin_slashpage_setup {
	return(
	'ja'=>'階層下のページ名を容易にリンクする',
	'en'=>'Link of the page name under a class easily',
	'use_req'=>'',
	'use_opt'=>'',
	'use_cmd'=>'',
	'override'=>'make_link_wikipage',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/slashpage/'
	);
__END__
