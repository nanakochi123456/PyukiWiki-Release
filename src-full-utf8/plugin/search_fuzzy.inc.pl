######################################################################
# search_fuzzy.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: search_fuzzy.inc.pl,v 1.171 2011/12/31 13:06:14 papu Exp $
#
# "PyukiWiki" version 0.2.0 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2012 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2012 PyukiWiki Developers Team
# http://pyukiwiki.sfjp.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sfjp.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################
# あいまいサーチ用プラグイン、直接呼出しはできません。
# pyukiwiki.ini.cgi に
# $::use_FuzzySearch=1;
# を記述
######################################################################
use Nana::Search;
sub plugin_fuzzy_search {
	my $body = "";
	my $word=&escape(&code_convert(\$::form{mymsg}, $::defaultcode));
	if ($word) {
		@words = split(/\s+/, $word);
		my $total = 0;
		if ($::form{type} eq 'OR') {
			foreach my $wd (@words) {
				$total = 0;
				foreach my $page (sort keys %::database) {
					next if(
						$page eq $::RecentChanges
						|| $page=~/$non_list/
						|| !&is_readable($page));
					if (Nana::Search::Search($::database{$page}, $wd) or Nana::Search::Search($page, $wd)) {
						$found{$page} = 1;
					}
					$total++;
				}
			}
		} else {
			foreach my $page (sort keys %::database) {
				next if(
					$page eq $::RecentChanges
					|| $page=~/$non_list/
					|| !&is_readable($page));
				my $exist = 1;
				foreach my $wd (@words) {
					if (!(Nana::Search::Search($::database{$page}, $wd) eq 1 or Nana::Search::Search($page, $wd) eq 1)) {
						$exist = 0;
					}
				}
				if ($exist) {
					$found{$page} = 1;
				}
				$total++;
			}
		}
		my $counter = 0;
		foreach my $page (sort keys %found) {
			$body .= qq|<ul>| if ($counter == 0);
			$body .= qq(<li><a href ="$::script?@{[&htmlspecialchars(&encode($page))]}">@{[&htmlspecialchars($page)]}</a>@{[&htmlspecialchars(&get_subjectline($page))]}</li>);
			$counter++;
		}
		$body .= ($counter == 0) ? $::resource{notfound} : qq|</ul>|;
	}
	$body.=&plugin_search_form(2,$word);
	return ('msg'=>"\t$::resource{searchpage}", 'body'=>$body);
}
1;
__END__
