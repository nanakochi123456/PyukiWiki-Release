######################################################################
# google_analytics.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: google_analytics.inc.pl,v 1.336 2012/03/18 11:23:55 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
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
# This is extented plugin.
# To use this plugin, rename to 'google_analytics.inc.cgi'
######################################################################
#
# google-analytics.com サービスによる、サイトトラッキングシステム
#
# http://google-analytics.com/
#
# 使い方：
#   ・google_analytics.inc.plをgoogle_analytics.inc.cgiにリネーム
#   ・info/setup.cgi に登録したアカウント (UA- で始まるもの) を
#     $GOOGLEANALTYCS::ACCOUNT 変数にセットする。
#   ・ 複数のサブドメインがある場合は、
#     $GOOGLEANALTYCS::MULTISUB に 「.example.com」の形式で記載する。
#   ・複数のトップレベルドメインがある場合、
#     $GOOGLEANALTYCS::MULTITOP=1 をセットする。
#
# 注意：
#   ・合計で１ヶ月500万ビューを超えると課金が発生します。
#
######################################################################
# UA- で始まるアカウントを設定する。
$GOOGLEANALTYCS::ACCOUNT=""
	if($GOOGLEANALTYCS::ACCOUNT eq '');
#
# 複数のサブドメインがある １つのドメインがある場合そのドメインを指定する。
# example : [.example.com]
$GOOGLEANALTYCS::MULTISUB=""
	if($GOOGLEANALTYCS::MULTISUB eq "");
#
# 複数のトップレベルドメインがある場合１
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
	'ja'=>'サイトトラッキングシステム for google-analytics.com',
	'en'=>'Site Tracking System for google-analytics.com',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/google_analytics/'
	);
}
__END__
