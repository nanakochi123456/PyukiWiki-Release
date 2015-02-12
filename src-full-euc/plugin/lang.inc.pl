######################################################################
# lang.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: lang.inc.pl,v 1.52 2011/05/03 20:43:28 papu Exp $
#
# "PyukiWiki" version 0.1.9 $$
# Author: Nanami http://nanakochi.daiba.cx/
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
# 言語cookie設定用プラグイン
# ExPlugin lang.inc.cgi、$::write_location=1を有効にする必要があります
######################################################################

sub plugin_lang_action {
	my $body;
	return if($::lang_cookie eq '' || $::write_location eq 0);
# 0.1.9 fix
	return if($::useExPlugin eq 1 && $::_exec_plugined{lang} ne 2);

	my @http_headers=();
	push(@http_headers, "Status: 302");
	if($::form{refer} ne '') {
		push(@http_headers, "Location: $::basehref?@{[&encode($::form{refer})]}");
	} else {
		push(@http_headers, "Location: $::basehref?@{[&encode($::FrontPage)]}");
	}
	$::lang_cookie{lang}=$::form{lang};
	$::lang_cookie{lang}='' if($::langlist{$::form{lang}} eq '');
	&setcookie($::lang_cookie, 1, %::lang_cookie);
	print &http_header(
		@http_headers,
		$::HTTP_HEADER
		);
	close(STDOUT);
	exit;
}

1;
__END__

