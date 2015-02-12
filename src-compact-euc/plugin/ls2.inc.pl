######################################################################
# ls2.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: ls2.inc.pl,v 1.477 2012/03/01 10:39:21 papu Exp $
#
# "PyukiWiki" version 0.2.0-p2 $$
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
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# v0.2.0 2012/02/15 �Ƴ��ؤ�ɽ�����ǽ�����MenuBar���ɽ���ǽ���
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
#-noprefix:�Ƴ��ؤ�ɽ�����ʤ�
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
	my $noprefix = 0;
	if (@args > 0) {
		$prefix = shift(@args);
		foreach my $arg (@args) {
			if (lc $arg eq "title") {
				$title = 1;
			} elsif (lc $arg eq "reverse") {
				$reverse = 1;
			} elsif (lc $arg eq "noprefix") {
				$noprefix = 1;
			}
		}
	}
	$prefix = $::form{mypage} . "/" if ($prefix eq '');
	foreach my $page (sort keys %::database) {
		if ($page =~ /^$prefix/ && &is_readable($page) && $page!~/$::non_list/) {
			if($noprefix eq 1) {
				my $cutedpage=$page;
				$cutedpage=~s@^$prefix/@@g;
				push(@pages, "$page\t$cutedpage")
			} else {
				push(@pages, "$page\t$page")
			}
		}
	}
	@pages = reverse(@pages) if ($reverse);
	foreach (@pages) {
		my ($page, $cutedpage)=split(/\t/,$_);
		$body .= <<"EOD";
<li><a id ="list_1" href="@{[&make_cookedurl(&encode($page))]}" title="$page">$cutedpage</a></li>
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
<ul class="list1">$body</ul>
EOD
	}
	return "<strong>'$prefix'</strong> $::resource{ls2_plugin_notpage}<br />\n";
}
1;
__END__
