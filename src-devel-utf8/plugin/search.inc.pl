######################################################################
# search.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: search.inc.pl,v 1.339 2012/03/18 11:23:57 papu Exp $
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
# 0.2.0-p2 PukiWiki互換の引数にした。
#          バグ修正、GETメソッドにした
######################################################################

sub plugin_search_convert {
	my($mode)=@_;
	$mode=($mode=~/([Ss][Ee][Ll][Ee][Cc][Tt])/ ? 1 : 0)+$mode;
	return &plugin_search_form($mode);
}

sub plugin_search_action {
	#v0.1.6
	if($::use_FuzzySearch eq 1 && $::lang eq 'ja'
		&& -r "$::plugin_dir/search_fuzzy.inc.pl") {
		require "$::plugin_dir/search_fuzzy.inc.pl";
		return(&plugin_fuzzy_search);
	}

	my $body = "";
	my $word=&escape(&code_convert(\$::form{word}, $::defaultcode));
	$word=&escape(&code_convert(\$::form{mymsg}, $::defaultcode))
		if($word eq '');
	my $body = "";
	my $word=&escape(&code_convert(\$::form{word}, $::defaultcode));
	$word=&escape(&code_convert(\$::form{mymsg}, $::defaultcode))
		if($word eq '');
	if ($word) {
		my $spc;
		if ($word) {
			if($::lang eq "ja") {
				if($::defaultcode eq 'utf8') {
					$spc="\xe3\x80\x80";
				} else {
					$spc="\xa1\xa1";
				}
			}
		}
		if($spc ne "") {
			foreach(" ", $spc) {
				$wd=~s/$_/\t/g;
			}
		}
		$wd=~s/(\t+)/\t/g;
		my @words=split(/\t/,$word);
		my $total = 0;
		if ($::form{type} eq 'OR') {
			$total = 0;
			foreach my $wd (@words) {
				next if($wd eq '');
				foreach my $page (sort keys %::database) {
					next if(
						$page eq $::RecentChanges
						|| $page=~/$non_list/
						|| !&is_readable($page));
					if ($::database{$page} =~ /\Q$wd\E/i or $page =~ /\Q$wd\E/i) {
						$found{$page} = 1;
					}
					$total++;
				}
			}
		} else {	# AND 検索								# comment
			foreach my $page (sort keys %::database) {
				next if(
					$page eq $::RecentChanges
					|| $page=~/$non_list/
					|| !&is_readable($page));
				my $exist = 1;
				foreach my $wd (@words) {
					next if($wd eq '');
					if (!($::database{$page} =~ /\Q$wd\E/i or $page =~ /\Q$wd\E/i)) {
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
			if($::use_Highlight eq 1) {
				$body .= qq(<li><a href ="$::script?cmd=read&amp;mypage=@{[&encode($page)]}&amp;word=@{[&encode($word)]}">@{[&htmlspecialchars($page)]}</a>@{[&htmlspecialchars(&get_subjectline($page))]}</li>);
			} else {
				$body .= qq(<li><a href ="$::script?@{[&encode($page)]}">@{[&escape($page)]}</a>@{[&escape(&get_subjectline($page))]}</li>);
			}
			$counter++;
		}
		$body .= ($counter == 0) ? $::resource{notfound} : qq|</ul>|;
	#	$body .= "$counter / $total <br />\n";
	}
	$body.=&plugin_search_form(2,$word);
	return ('msg'=>"\t$::resource{searchpage}", 'body'=>$body);
}

sub plugin_search_form {
	my($mode,$word)=@_;
	my $body;
	if($mode eq 1) {
		$body= <<"EOD";
<form action="$::script" method="get">
<div>
<input type="hidden" name="cmd" value="search" />
<input type="hidden" name="refer" value="$::form{refer}" />
<input type="text" name="word" value="$word" size="20" />
<select name="type">
<option value="AND">$::resource{searchand}</option>
<option value="OR"@{[$::form{type} eq 'OR' ? " selected" : ""]}>$::resource{searchor}</option>
</select>
<input type="submit" value="$::resource{searchbutton}" />
</div>
</form>
EOD
	} elsif($mode eq 2) {
		$body= <<"EOD";
<form action="$::script" method="get">
<div>
<input type="hidden" name="cmd" value="search" />
<input type="hidden" name="refer" value="$::form{refer}" />
<input type="text" name="word" value="$word" size="20" />
<input type="radio" name="type" value="AND" @{[ ($::form{type} ne 'OR' ? qq( checked="checked") : qq()) ]} />$::resource{searchand}
<input type="radio" name="type" value="OR" @{[ ($::form{type} eq 'OR' ? qq( checked="checked") : qq()) ]}/>$::resource{searchor}
<input type="submit" value="$::resource{searchbutton}" />
</div>
</form>
EOD
	} else {
		$body= <<"EOD";
<form action="$::script" method="get">
<div>
<input type="hidden" name="cmd" value="search" />
<input type="hidden" name="refer" value="$::form{refer}" />
<input type="text" name="word" value="$word" size="20" />
<input type="hidden" name="type" value="AND" />
<input type="submit" value="$::resource{searchbutton}" />
</div>
</form>
EOD
	}
	return $body;
}

1;
__END__
=head1 NAME

search.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=search
 #search (0 1 or 2)

=head1 DESCRIPTION

Search on the page.

=head1 USAGE

 ?cmd=search[&word=string][&type=OR|AND]

=over 4

=item word

The character string to search is specified.

=item type

OR search is performed at specification of 'OR'. (It is AND search at the time of an abbreviation)

=back

 #search(0 1 or 2)

Display Search form

=over 4

=item 0

Not display AND, OR selection

=item 1

Display AND, OR selection of select box

=item 2

Display AND, OR selection of radio button

=back

=head1 SETTING

=head2 pyukiwiki.ini.cgi

=over 4

=item $::use_FuzzySearch

0:Usually, search, 1:Japanese ambiguous reference is used.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/search

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/search/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/search.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/search.inc.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nekyo

L<http://nekyo.qp.land.to/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sfjp.jp/>

=back

=head1 LICENSE

Copyright (C) 2004-2012 by Nekyo.

Copyright (C) 2005-2012 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
