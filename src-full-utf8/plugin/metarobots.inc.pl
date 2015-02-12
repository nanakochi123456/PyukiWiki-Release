######################################################################
# metarobots.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: metarobots.inc.pl,v 1.337 2012/03/18 11:23:57 papu Exp $
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
# v0.2.0-p2 Bugfix
# v0.2.0 First Release
#
#*Usage
# #metarobots(keywords,[keywords]...)
# #metarobots(disable)
######################################################################
sub plugin_metarobots_convert {
	my ($arg)=@_;
	return if(!&is_frozen($::form{mypage}));
	return ' ' if($arg eq '');
	my @meta_keyword;
	my $keyword;
	my $noarchiveflg=0;
	my $disableflg=0;
	foreach my $word (split(/,/,"$::meta_keyword,@{[&htmlspecialchars($arg)]}")) {
		if($word eq "noarchive") {
			$noarchiveflg=1;
			next;
		}
		if($word eq "disable" || $word eq "noindex") {
			$disableflg=1;
			next;
		}
		my $flg=0;
		if($arg ne "") {
			foreach my $tmp (@meta_keyword) {
				if($tmp eq $word) {
					$flg=1;
					last;
				}
			}
			push(@meta_keyword, $word)
				if($flg eq 0);
		}
	}
	foreach(@meta_keyword) {
		$keyword.="$_,";
	}
	$keyword=~s/\,$//g;
	if($disableflg eq 1) {
		$::IN_META_ROBOTS=<<EOM;
<meta name="robots" content="NOINDEX,NOFOLLOW,NOARCHIVE" />
<meta name="googlebot" content="NOINDEX,NOFOLLOW,NOARCHIVE" />
EOM
	} elsif($noarchiveflg eq 1) {
		$::IN_META_ROBOTS=<<EOM;
<meta name="robots" content="INDEX,FOLLOW,NOARCHIVE" />
<meta name="googlebot" content="INDEX,FOLLOW,NOARCHIVE" />
<meta name="keywords" content="$keyword" />
EOM
	} else {
		$::IN_META_ROBOTS=<<EOM;
<meta name="robots" content="INDEX,FOLLOW" />
<meta name="googlebot" content="INDEX,FOLLOW,ARCHIVE" />
<meta name="keywords" content="$keyword" />
EOM
	}
	return ' ';
}
1;
__END__
