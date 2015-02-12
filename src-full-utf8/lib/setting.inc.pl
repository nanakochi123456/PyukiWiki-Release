######################################################################
# setting.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: setting.inc.pl,v 1.255 2012/01/31 10:12:02 papu Exp $
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
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'setting.inc.cgi'
######################################################################
%::setting_cookie;
$::setting_cookie="PWS_"
				. &dbmname($::basepath);
%::name_cookie;
$::name_cookie="PWU_"
				. &dbmname($::basepath);
sub plugin_setting_init {
	&exec_explugin_sub("lang");
	&exec_explugin_sub("urlhack");
	if($::navi{"setting_url"} eq '') {
		push(@::addnavi,"setting:help");
		$::navi{"setting_url"}="$::script?cmd=setting&amp;mypage=@{[&encode($::form{mypage} ne '' ? $::form{mypage} : $::form{refer})]}";
		$::navi{"setting_name"}=$::resource{"settingbutton"};
		$::navi{"setting_type"}="plugin";
	}
	%::setting_cookie=();
	%::setting_cookie=&getcookie($::setting_cookie,%::setting_cookie);
	%::name_cookie=&getcookie($::name_cookie,%::name_cookie);
	if($::setting_cookie{savename} eq 0) {
		if($::name_cookie{myname} ne '') {
			$::name_cookie{myname}="";
			&setcookie($::name_cookie, -1, %::name_cookie);
		}
	}
	&plugin_setting_setting;
	return ('init'=>1);
}
sub plugin_setting_savename {
	my($name)=@_;
	$::name_cookie{myname}=$name;
	&setcookie($::name_cookie, 1, %::name_cookie);
}
sub plugin_setting_setting {
	if($::setting_cookie{style} ne '') {
		my $style=$::setting_cookie{style};
		if($style!~/\//) {
			$::skin_name=$style;
			&skin_init;
		}
	}
	if($::setting_cookie{fontsize}+0 > 0) {
		$::IN_HEAD.=<<EOM
<style type="text/css"><!--
#body{font-size:@{[$::setting_cookie{fontsize} eq 1 ? '120' : '90']}%;}
//--></style>
EOM
	}
	my $escapeoff=0;
	if($::use_escapeoff > 0) {
		if(defined($::setting_cookie{escapeoff})) {
			$escapeoff=$::setting_cookie{escapeoff}+0;
		} else {
			$escapeoff=$::use_escapeoff+0;
		}
		&escapeoff if($escapeoff > 0);
		$::escapeoff_exec = 1;
	}
}
1;
__DATA__
sub plugin_setting_setup {
	return(
	'ja'=>'cookieに対してWikiの表示設定をする',
	'en'=>'Setup of Wiki is carried out to cookie.',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Admin/setting/'
	);
__END__
