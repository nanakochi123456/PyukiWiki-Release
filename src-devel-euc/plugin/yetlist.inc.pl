######################################################################
# yetlist.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: yetlist.inc.pl,v 1.460 2012/03/18 11:23:51 papu Exp $
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
# This is compatiblity PukiWiki plugin, but cording was original.
######################################################################

use strict;

sub plugin_yetlist_action {
	my %yet=();
	my $yetcount=0;
	my $yetlist_regex="($::bracket_name)";
	$yetlist_regex.="|($::wiki_name)" if($::nowikiname ne 1);

	foreach my $page (sort keys %::database) {
		next if ($page =~ $::non_list);
		next unless(&is_readable($page));
		my $data=$::database{$page};
		foreach my $chunk($data=~/$yetlist_regex/) {
			next if($chunk eq '');
			my ($chunk1,$chunk2);
			my $ret=&make_link($chunk);
			next if($ret!~/cmd=edit\&/);
			$chunk=&unarmor_name($chunk);
			($chunk1,$chunk2) = split(/[:>]/,$chunk);
			$chunk=$chunk2 eq '' ? $chunk1 : $chunk2;
			# local wiki page							# comment
			if(&is_exist_page($chunk) || $chunk eq '') {
				next;
			}
			$yet{$chunk}.="$page\t"
				if($yet{$chunk}!~/^$page\t|\t$page\t/);
			$yetcount++;
		}
	}
	if($yetcount eq 0) {
		return('msg'=>"\t$::resource{yetlist_plugin_title}"
			, 'body'=>"$::resource{yetlist_plugin_nopage}");
	}
	my $body="<ul>\n";
	foreach my $chunk (sort keys %yet) {
		$body.=<<EOM;
<li><a href="$::script?cmd=edit&amp;mypage=@{[&encode($chunk)]}">@{[&escape($chunk)]}</a>
<em>(
EOM
		foreach my $page(sort split(/\t/,$yet{$chunk})) {
			$body.=<<EOM;
<a href="@{[&make_cookedurl(&encode($page))]}">@{[&escape($page)]}</a>
EOM
		}
		$body.=<<EOM;
)</em></li>
EOM
	}
	return('msg'=>"\t$::resource{yetlist_plugin_title}"
		, 'body'=>$body);
}

1;
__END__

=head1 NAME

yetlist.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=yetlist

=head1 DESCRIPTION

The page which is not made yet is indicated by list.

The page which is not made yet is a page which is specified by WikiName or BracketName and is not made from the existing page yet.

=back

=head1 WARNING

A large amount of key words not to make the parameter name of a name and similar WikiName of the guest described in the comment a page easily on an actual operation side are caught though very Wiki in the point that someone excluding me might write the page.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/yetlist

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/yetlist/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/yetlist.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/yetlist.inc.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sfjp.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2012 by Nanami.

Copyright (C) 2005-2012 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
