######################################################################
# contents.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: contents.inc.pl,v 1.51 2006/03/17 14:00:10 papu Exp $
#
# "PyukiWiki" version 0.1.6 $$
# Author: Nekyo
# Copyright (C) 2004-2006 by Nekyo.
# http://nekyo.hp.infoseek.co.jp/
# Copyright (C) 2005-2006 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# v0.1.6 2006/01/07 *****�ޤ��б�������¾����
# v0.0.2 2005/01/20 base �ˤ���������б�
# v0.0.1 �ץ�ȥ�����
######################################################################

use strict;

sub plugin_contents_convert {
	my ($txt) = $::database{$::form{mypage}};
	my (@txt) = split(/\r?\n/, $txt);
	return plugin_contents_main("",@txt);
}

sub plugin_contents_main {
	my $baseurl=shift;
	my @txt=@_;
	my $tocnum = 0;
	my (@tocsaved, @tocresult);
	my $title;
	my $nametag = &pageanchorname($::form{mypage});

	foreach (@txt) {
		chomp;
		if (/^(\*{1,5})(.+)/) {
			&back_push('ul', length($1), \@tocsaved, \@tocresult);
			$title = &inline($2);
			$title =~ s/<[^>]+>//g;
			if($baseurl eq '') {
				push(@tocresult, qq(<li><a href=")
					 . &make_cookedurl(&encode($::pushedpage eq '' ? $::form{mypage} : $::pushedpage))
					. qq(#$nametag$tocnum">$title</a></li>\n));
			} else {
				push(@tocresult, qq(<li><a href=")
					 . $baseurl
					. qq(#$nametag$tocnum">$title</a></li>\n));
			}
			$tocnum++;
		}
	}
	push(@tocresult, splice(@tocsaved));
	my $body = <<EOD;
<div class="contents">
<a id="contents_1"></a>
EOD
	$body .= join("\n", @tocresult) . "</div>\n";
	return $body;
}
1;
__END__

