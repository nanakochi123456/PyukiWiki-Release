######################################################################
# ls2.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: ls2.inc.pl,v 1.92 2011/05/04 07:26:50 papu Exp $
#
# "PyukiWiki" version 0.1.9 $$
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
# v0.1.6 2006/01/07 *****�ޤ��б����롢����¾����
# v0.1   2005/04/01 encode �Х� Fix Tnx:Junichi����
# v0.0   2004/11/01 �ʰ��� title,reverse �б�������¾�����б�
# based on ls2.inc.php by arino
#
#*�ץ饰���� ls2
#�۲��Υڡ����θ��Ф�(*,**,***)�ΰ�����ɽ������
#
#*Usage
# #ls2(�ѥ�����[,�ѥ�᡼��])
#
#*�ѥ�᡼��
#-�ѥ�����(�ǽ�˻���) ��ά����Ȥ��⥫��ޤ�ɬ��
#-title:���Ф��ΰ�����ɽ������
#-include:���󥯥롼�ɤ��Ƥ���ڡ����θ��Ф���Ƶ�Ū����󤹤�
#-link:action�ץ饰�����ƤӽФ���󥯤�ɽ��
#-reverse:�ڡ������¤ӽ��ȿž�����߽�ˤ���
#-compact:
######################################################################

use strict;

sub plugin_ls2_convert
{
	my $prefix = '';
	my @args = split(/,/, shift);
	my $title = 0;
	my $reverse = 0;
	my (@pages, $txt, @txt, $tocnum);
	my $body = '';

	if (@args > 0) {
		$prefix = shift(@args);
		foreach my $arg (@args) {
			if (lc $arg eq "title") {
				$title = 1;
			} elsif (lc $arg eq "reverse") {
				$reverse = 1;
			}
		}
	}
	$prefix = $::form{mypage} . "/" if ($prefix eq '');

	foreach my $page (sort keys %::database) {
		push(@pages, $page) if ($page =~ /^$prefix/ && &is_readable($page) && $page!~/$::non_list/);
	}
	@pages = reverse(@pages) if ($reverse);
	foreach my $page (@pages) {
		$body .= <<"EOD";
<li><a id ="list_1" href="@{[&make_cookedurl(&encode($page))]}" title="$page">$page</a></li>
EOD
		if ($title) {
			$txt = $::database{$page};
			@txt = split(/\r?\n/, $txt);
			$tocnum = 0;
			my (@tocsaved, @tocresult);
			foreach (@txt) {
				chomp;
				if (/^(\*{1,5})(.+)/) {
					&back_push('ul', length($1), \@tocsaved, \@tocresult);
					push(@tocresult, qq( <li><a href="@{[&make_cookedurl(&encode($page))]}#@{[&pageanchorname($page)]}$tocnum">@{[&escape($2)]}</a></li>\n));	
					$tocnum++;
				}
			}
			push(@tocresult, splice(@tocsaved));
			$body .= join("\n", @tocresult);
		}
	}
	if ($body ne '') {
		return << "EOD";
<ul class="list1" style="padding-left:16px;margin-left:16px">$body</ul>
EOD
	}
	return "<strong>'$prefix'</strong> $::resource{ls2_plugin_notpage}<br />\n";
}

1;
__END__
=head1 NAME

ls2.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #ls2(pattern,[title],[include],[link],[reverse])

=head1 DESCRIPTION

The page name which starts by the specified pattern is indicated by list.
When abbreviation, the present page serves as a starting point.

=head1 USAGE

 #ls2(pattern, [title],[include],[link],[reverse])

=over 4

=item pattern

The common portion of the page name to display is specified as a pattern.
When abbreviation, "installed page name/".

=item title

Display title contained in a page (*, **, ***)

=item include

The titles of the included page are enumerated recursively.

=item link

Display the link which calls action plugin.

=item reverse

Display order reversed.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/ls2

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/ls2/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/ls2.inc.pl?view=log>

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
