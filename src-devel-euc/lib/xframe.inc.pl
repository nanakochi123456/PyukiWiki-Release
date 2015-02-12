######################################################################
# xframe.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: xframe.inc.pl,v 1.76 2012/03/01 10:39:20 papu Exp $
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
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'xframe.inc.cgi'
######################################################################
#
# フレーム下に表示されないようにするプラグイン
# http://www.jpcert.or.jp/ed/2009/ed090001.pdf
#
######################################################################
#
# DENY:他のWebページのframe上またはiframe上での表示を拒否する。
# SAMEORIGIN:Top-level-browsing-contextが一致した時のみ、他のWebページ
#            上のframe又はiframe上での表示を許可する。

$XFRAME::MODE="DENY"
#$XFRAME::MODE="SAMEORIGIN"
	if(!defined($XFRAME::MODE));


# Initlize

sub plugin_xframe_init {
	my $agent=$ENV{HTTP_USER_AGENT};
	my $header;
	$header=<<EOM;
X-FRAME-OPTIONS: $XFRAME::MODE
EOM
	return ('http_header'=>$header, 'init'=>1, 'func'=>'');
}

1;
__DATA__
sub plugin_xframe_setup {
	return(
	'ja'=>'フレーム下に表示されないようにするプラグイン',
	'en'=>'Disable view page on apper on the bottom frame',
	'override'=>'none',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/xframe/'
	);
}
__END__
=head1 NAME

xframe.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Disable view page on apper on the bottom frame

=head1 USAGE

rename to xframe.inc.cgi

=head1 SETTING

Write to info/setting.ini.cgi

$XFRAME::MODE="DENY" or $XFRAME::MODE="SAMEORIGIN"

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/xframe

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/xframe/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/xframe.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/lib/xframe.inc.pl?view=log>

=item Refernce

L<http://www.jpcert.or.jp/ed/2009/ed090001.pdf>

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
