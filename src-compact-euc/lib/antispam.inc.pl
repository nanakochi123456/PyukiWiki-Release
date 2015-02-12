######################################################################
# antispam.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: antispam.inc.pl,v 1.344 2011/12/31 13:06:09 papu Exp $
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
# To use this plugin, rename to 'antispam.inc.cgi'
######################################################################
#
# メールアドレス自動収集防止
#
# 使い方：
#   ・antispam.inc.plをantispam.inc.cgiにリネームするだけで使えます
#
######################################################################
sub plugin_antispam_init {
	$::AntiSpam_Count=0;
	$::AntiSpam="enable";
	$::functions{make_link_mail}=\&make_link_mail;
	return ('init'=>1
		, 'func'=>'make_link_mail', 'make_link_mail'=>\&make_link_mail);
}
sub make_link_mail {
	my($chunk,$escapedchunk)=@_;
	my $adr=$chunk;
	$::IN_HEAD.=&maketoken if($::Token eq '');
	$adr=~s/^[Mm][Aa][Ii][Ll][Tt][Oo]://g;
	my $mailtoadr="mailto:$adr";
	return qq(<a href="$mailtoadr" class="mail">$escapedchunk</a>) if($::Token eq '');
	my $chunk1=&Enc_UntiSpam("mailto:$adr");
	$::AntiSpam_Count++;
	my $id="antispammail$::AntiSpam_Count";
	if($adr eq $escapedchunk || $mailtoadr eq $escapedchunk) {
		$escapedchunk=&Enc_UntiSpam("$escapedchunk");
		$::AntiSpam_Count++;
		return qq(<span class="mail" id="$id" onclick="addec_link('$chunk1\')" onkeypress="void(0);"><script type="text/javascript"><!--\naddec_text('$escapedchunk','$id');\n//--></script></span>);
	} else {
		return qq(<span class="mail" id="$id" onclick="addec_link('$chunk1\','$id')" onkeypress="void(0);">$escapedchunk</span>);
	}
}
sub Enc_UntiSpam {
	my($ad) = @_;
	return &password_encode($ad,$::Token);
}
1;
__DATA__
sub plugin_antispam_setup {
	return(
	'ja'=>'迷惑メール防止',
	'en'=>'Anti Spam Plugin',
	'override'=>'make_link_mail',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/antispam/'
	);
}
__END__
