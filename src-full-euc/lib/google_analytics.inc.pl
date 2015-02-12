######################################################################
# google_analytics.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: google_analytics.inc.pl,v 1.188 2011/12/31 13:06:09 papu Exp $
#
# "PyukiWiki" version 0.2.0 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2012 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2012 PyukiWiki Developers Team
# http://pyukiwiki.sfjp.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sfjp.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'google_analytics.inc.cgi'
######################################################################
#
# google-analytics.com �����ӥ��ˤ�롢�����ȥȥ�å��󥰥����ƥ�
#
# http://google-analytics.com/
#
# �Ȥ�����
#   ��google_analytics.inc.pl��google_analytics.inc.cgi�˥�͡���
#   ��info/setup.cgi ����Ͽ������������� (UA- �ǻϤޤ���) ��
#     $GOOGLEANALTYCS::ACCOUNT �ѿ��˥��åȤ��롣
#   �� ʣ���Υ��֥ɥᥤ�󤬤�����ϡ�
#     $GOOGLEANALTYCS::MULTISUB �� ��.example.com�פη����ǵ��ܤ��롣
#   ��ʣ���Υȥåץ�٥�ɥᥤ�󤬤����硢
#     $GOOGLEANALTYCS::MULTITOP=1 �򥻥åȤ��롣
#
# ���ա�
#   ����פǣ�����500���ӥ塼��Ķ����Ȳݶ⤬ȯ�����ޤ���
#
######################################################################
# UA- �ǻϤޤ륢������Ȥ����ꤹ�롣
$GOOGLEANALTYCS::ACCOUNT=""
	if($GOOGLEANALTYCS::ACCOUNT eq '');
#
# ʣ���Υ��֥ɥᥤ�󤬤��� ���ĤΥɥᥤ�󤬤����礽�Υɥᥤ�����ꤹ�롣
# example : [.example.com]
$GOOGLEANALTYCS::MULTISUB=""
	if($GOOGLEANALTYCS::MULTISUB eq "");
#
# ʣ���Υȥåץ�٥�ɥᥤ�󤬤����磱
$GOOGLEANALTYCS::MULTITOP=0
	if($GOOGLEANALTYCS::MULTITOP ne 0);
######################################################################
sub plugin_google_analytics_init {
	if($::form{cmd} eq "" || $::form{cmd} eq "read") {
		if($GOOGLEANALTYCS::ACCOUNT ne '') {
			my $header=<<EOM;
<script type="text/javascript"><!--
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', '$GOOGLEANALTYCS::ACCOUNT']);@{[$GOOGLEANALTYCS::MULTISUB ne '' ? "  _gaq.push(['_setDomainName', '$GOOGLEANALTYCS::MULTISUB']);\n" : ""]}@{[$GOOGLEANALTYCS::MULTITOP ne 0 ? "  _gaq.push(['_setDomainName', 'none']);\n  _gaq.push(['_setAllowLinker', true]);\n" : ""]}
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
//--></script>
EOM
			return ('init'=>1, 'header'=>$header);
		}
	}
	return ('init'=>0);
}
1;
__DATA__
sub plugin_google_analytics_setup {
	return(
	'ja'=>'�����ȥȥ�å��󥰥����ƥ� for google-analytics.com',
	'en'=>'Site Tracking System for google-analytics.com',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/google_analytics/'
	);
}
__END__