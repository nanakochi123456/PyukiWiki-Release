######################################################################
# xframe.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: xframe.inc.pl,v 1.23 2012/01/31 10:11:55 papu Exp $
#
# "PyukiWiki" version 0.2.0-p1 $$
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
# �ե졼�಼��ɽ������ʤ��褦�ˤ���ץ饰����
# http://www.jpcert.or.jp/ed/2009/ed090001.pdf
#
######################################################################
#
# DENY:¾��Web�ڡ�����frame��ޤ���iframe��Ǥ�ɽ������ݤ��롣
# SAMEORIGIN:Top-level-browsing-context�����פ������Τߡ�¾��Web�ڡ���
#            ���frame����iframe��Ǥ�ɽ������Ĥ��롣
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
	'ja'=>'�ե졼�಼��ɽ������ʤ��褦�ˤ���ץ饰����',
	'en'=>'Disable view page on apper on the bottom frame',
	'override'=>'none',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/xframe/'
	);
}
__END__
