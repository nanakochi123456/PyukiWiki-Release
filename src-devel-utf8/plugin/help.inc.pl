######################################################################
# help.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: help.inc.pl,v 1.308 2012/03/01 10:39:25 papu Exp $
#
# "PyukiWiki" version 0.2.0-p2 $$
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
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################

sub plugin_help_action {
	$::form{mypage}=$::resource{help};
	if(!&is_readable($::form{mypage})) {
		&print_error($::resource{auth_readfobidden});
	}
	# 2005.11.2 pochi: 部分編集を可能に				# comment
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

	$::IN_HEAD.=&meta_robots($::form{cmd},$page,$body);
	my $output_mime = $::htmlmode eq "xhtml11"
		&& $ENV{'HTTP_ACCEPT'}=~ m!application/xhtml\+xml!
		&& &is_no_xhtml(1) eq 0
		? 'application/xhtml+xml' : 'text/html';
	$::HTTP_HEADER=&http_header("Content-type: $output_mime; charset=$::charset", $::HTTP_HEADER);
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

=head1 NAME

help.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=help [& refer=refer page]

=head1 DESCRIPTION

Display help page

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/help

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/help/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/help.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/help.inc.pl?view=log>

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
