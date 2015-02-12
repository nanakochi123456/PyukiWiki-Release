######################################################################
# list.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: list.inc.pl,v 1.82 2011/01/25 03:11:15 papu Exp $
#
# "PyukiWiki" version 0.1.8-p2 $$
# Author: Nekyo
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
# v0.2 non_list
# v0.1
######################################################################

sub plugin_list_action {
	my $navi = qq(<div id="body"><div id="top" style="text-align:center">);
	my $body = qq(</div>);
	my $prev = '';
	my $char = '';
	my $idx = 1;

	foreach my $page (sort keys %::database) {
		next if ($page =~ $::non_list);
		next unless(&is_readable($page));
		$char = substr($page, 0, 1);
		if (!($char =~ /[a-zA-Z0-9]/)) {
			$char = $::resource{list_plugin_otherchara};
		}
		if ($prev ne $char) {
			if ($prev ne '') {
				$navi .= " |\n";
				$body .= "  </ul>\n </li>\n</ul>\n";
			}
			$prev = $char;
			$navi .= qq(<a id="top_$idx" href="?cmd=list#head_$idx"><strong>$prev</strong></a>);
			$body .= <<"EOD";
<ul>
 <li><a id="head_$idx" href="?cmd=list#top_$idx"><strong>$prev</strong></a>
  <ul>
EOD
			$idx++;
		}
		$body .= qq(<li><a href="@{[&make_cookedurl(&encode($page))]}">@{[&escape($page)]}</a>@{[&escape(&get_subjectline($page))]}</li>\n);
	}
	$body .= qq(</li></ul>);

	return ('msg' => "\t$::resource{list_plugin_title}", 'body' => $navi . $body);
}
1;
__END__

=head1 NAME

list.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=list

=head1 DESCRIPTION

Display all page list.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/list

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/list/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/list.inc.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nekyo

L<http://nekyo.qp.land.to/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2004-2011 by Nekyo.

Copyright (C) 2005-2011 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
