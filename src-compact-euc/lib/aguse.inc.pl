######################################################################
# aguse.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: aguse.inc.pl,v 1.285 2012/01/31 10:11:55 papu Exp $
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
# To use this plugin, rename to 'aguse.inc.cgi'
######################################################################
#
# aguse.jp �����ӥ��ˤ�롢�����Υ����å������ƥ�
#
# for Japanese Service
#
# http://www.aguse.jp/
#
# �Ȥ�����
#   ��aguse.inc.pl��aguse.inc.cgi�˥�͡��ह������ǻȤ��ޤ�
#
######################################################################
# ���������������å�������� true �ˤ��롣
$AGUSE::INNER="false"
	if($AGUSE::INNER eq "false" || $AGUSE::INNER eq "true");
#
# ��󥯤˥ޥ������������褻���Ȥ��Υ�󥯤ο�
# 0 �ʤ� 1 �ԥ� 2 ���꡼�� 3 �֥롼 4 ����
$AGUSE::LINKCOLOR="1"
	if($AGUSE::LINKCOLOR eq "");
#
# ��󥯤˥ޥ������������褻�Ƥ���ݥåץ��åפ���ޤǤλ���
# (600��9999ms)
$AGUSE::POPUPTIME="3000"
	if($AGUSE::POPUPTIME+0<600 || $AGUSE::POPUPTIME+0 > 9999);
######################################################################
sub plugin_aguse_init {
	my $header=<<EOM;
<link rel="stylesheet" href="http://www.aguse.jp/bp/aguse_popup_tool.css" type="text/css" /><script type="text/javascript" src="http://www.aguse.jp/bp/aguse_popup_tool.js#inner=$AGUSE::INNER&amp;color=$AGUSE::LINKCOLOR&amp;wait=$AGUSE::POPUPTIME&amp;" charset="UTF-8" ></script>
EOM
	return ('init'=>1, 'header'=>$header);
}
1;
__DATA__
sub plugin_aguse_setup {
	return(
	'ja'=>'���������å� for aguse.jp',
	'en'=>'Link check for aguse.jp (for japanese)',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/aguse/'
	);
}
__END__
