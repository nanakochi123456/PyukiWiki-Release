######################################################################
# antispamwiki.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: antispamwiki.inc.pl,v 1.380 2012/01/31 10:11:55 papu Exp $
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
# To use this plugin, rename to 'antispamwiki.inc.cgi'
######################################################################
#
# Wiki���ѥߥ��ɻ�
#
# JavaScript��cookie���Ѥ����ʰ�Ū�ʥ��ѥߥ��ɻߤǤ���
# ������������cookie�˵�Ͽ���ޤ���
# �ʲ��ξ��Ƕ���Ū��FrontPage�����Ф��ޤ�
# ������������狼��ͭ�����¤�ۤ�����
# ��$::form{mymsg} ��¸�ߤ��롢�ޤ��� POST�᥽�åɻ���
#   ͭ�����¤�ۤ������ޤ���cookie������ξ��
#
# �Ȥ�����
#   ��antispamwiki.inc.pl��antispamwiki.inc.cgi�˥�͡��ह������ǻȤ��ޤ�
#
######################################################################
# ͭ�����¡ʣ����֡�
$AntiSpamWiki::expire=1*60*60
	if(!defined($AntiSpamWiki::expire));
#
# ��û�񤭹��߻��֡ʣ��á�
$AntiSpamWiki::mintime=5
	if(!defined($AntiSpamWiki::mintime));
#
%::antispamwiki_cookie;
$::antispamwiki_cookie="PAW_"
				. &dbmname($::basepath);
$::antispamwiki_cookie_name="t";
$::antispamwiki_cookie_expire=60*60*60;
######################################################################
sub plugin_antispamwiki_init {
#	return('init'=>0)
	my $stat=0;
	%::antispamwiki_cookie=();
	%::antispamwiki_cookie=&getcookie($::antispamwiki_cookie,%::antispamwiki_cookie);
	my $time=time;
	if($::antispamwiki_cookie{$::antispamwiki_cookie_name} eq '') {
		$stat=1;
	} elsif($::antispamwiki_cookie{$::antispamwiki_cookie_name}+0+$AntiSpamWiki::expire < $time) {
		$stat=-1;
	} elsif($time-$::antispamwiki_cookie{$::antispamwiki_cookie_name}+0 < $AntiSpamWiki::mintime) {
		$stat=-1;
	}
$::debug.="now:$time, cookie:$::antispamwiki_cookie{$::antispamwiki_cookie_name}\n";
	if($stat+0 ne 0) {
		if($::form{mymsg} ne '' ||$::form{msg} ne '') {
			$::form{cmd}="read";
			$::form{mypage}=$::FrontPage;
		}
	}
	$::antispamwiki_cookie{$::antispamwiki_cookie_name}=$time;
	&setcookie($::antispamwiki_cookie,$::antispamwiki_cookie_expire,%::antispamwiki_cookie);
#	my $js=qq(<script type="text/javascript"><!--\nd.cookie="$::antispamwiki_cookie=$::antispamwiki_cookie_name%3a$time; path=$::basepath";\n//--></script>\n);
	return('init'=>1);
#	return('init'=>1, 'header'=>$js);
}
1;
__DATA__
sub plugin_antispamwiki_setup {
	return(
	'ja'=>'Wiki���ѥߥ��ɻ�',
	'en'=>'Anti Spam for WikiPlugin',
	'override'=>'',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/antispamwiki/'
	);
}
__END__
