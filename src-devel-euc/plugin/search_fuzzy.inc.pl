######################################################################
# search_fuzzy.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: search_fuzzy.inc.pl,v 1.81 2010/12/14 22:20:00 papu Exp $
#
# "PyukiWiki" version 0.1.8 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2010 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2010 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=Shift-JIS 1TAB=4Spaces
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
		} else {	# AND 検索
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
	#	$body .= "$counter / $total <br />\n";
	}
	$body.=&plugin_search_form(2,$word);
	return ('msg'=>"\t$::resource{searchpage}", 'body'=>$body);
}
1;
__END__

=head1 NAME

search_fuzzy.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=search

=head1 DESCRIPTION

Search on the page.

This is submodule of search.inc.pl

=head1 SETTING

=head2 pyukiwiki.ini.cgi

=over 4

=item $::use_FuzzySearch

0:Usually, search, 1:Japanese ambiguous reference is used.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/search

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/search/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/search.inc.pl?view=log>

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/search_fuzzy.inc.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2010 by Nanami.

Copyright (C) 2005-2010 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
