######################################################################
# help.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: help.inc.pl,v 1.40 2011/01/25 03:11:15 papu Exp $
#
# "PyukiWiki" version 0.1.8-p2 $$
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
# Return:LF Code=Shift-JIS 1TAB=4Spaces
######################################################################

sub plugin_help_action {
	$::form{mypage}=$::resource{help};
	if(!&is_readable($::form{mypage})) {
		&print_error($::resource{auth_readfobidden});
	}

	&plugin_help_skinex($::form{mypage}, &text_to_html($::database{$::form{mypage}}, mypage=>$::form{mypage}), 2, @_);
	&close_db;
	exit;
}

sub plugin_help_skinex {
	my ($page, $body, $is_page, $pageplugin) = @_;
	my $bodyclass = "normal";
	my $editable = 0;
	my $admineditable = 0;
	$pageplugin+=0;
	$::pageplugin+=0;

	if (&is_frozen($::form{refer}) && &is_exist_page($::form{refer})) {
		$admineditable = 1;
		$bodyclass = "frozen";
	} elsif (&is_editable($::form{refer}) && &is_exist_page($::form{refer})) {
		$admineditable = 1;
		$editable = 1;
	}
	&makenavigator($page,$is_page,$editable,$admineditable);

	$::IN_HEAD=&meta_robots($::form{cmd},$page,$body) . $::IN_HEAD;
	$::HTTP_HEADER=&http_header("Content-type: text/html; charset=$::charset", $::HTTP_HEADER);
	require $::skin_file;
	my $body=&skin($page, $body, $is_page, $bodyclass, $editable, $admineditable, $::basehref);
	$body=&_db($body);

	if($::lang eq 'ja' && $::defaultcode ne $::kanjicode) {
		$body=&code_convert(\$body,   $::kanjicode);
	}
	&content_output($::HTTP_HEADER, $body);
}

1;
__END__

