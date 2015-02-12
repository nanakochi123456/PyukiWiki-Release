######################################################################
# antispamwiki.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: antispamwiki.inc.pl,v 1.45 2011/05/03 20:43:28 papu Exp $
#
# "PyukiWiki" version 0.1.8-rc6 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2010 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2010 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'antispamwiki.inc.cgi'
######################################################################
#
# Wikiスパミング防止
#
# JavaScriptとcookieを用いた簡易的なスパミング防止です。
# 前回閲覧時刻をcookieに記録します。
# 以下の条件で強制的にFrontPageに飛ばします
# ・前回閲覧時刻から有効期限を越えた時
# ・$::form{mymsg} が存在する、または POSTメソッド時、
#   有効期限を越えた時またはcookie不設定の場合
#
# 使い方：
#   ・antispamwiki.inc.plをantispamwiki.inc.cgiにリネームするだけで使えます
#
######################################################################

# 有効期限（１時間）
$AntiSpamWiki::expire=1*60*60
	if(!defined($AntiSpamWiki::expire));

%::antispamwiki_cookie;
$::antispamwiki_cookie="PyukiWikiAntiSpamWiki_"
				. length($::basepath);

# Initlize

sub plugin_antispamwiki_init {
	my $stat=0;
	%::antispamwiki_cookie=();
	%::antispamwiki_cookie=&getcookie($::antispamwiki_cookie,%::antispamwiki_cookie);
	my $time=time;
	if($::antispamwiki_cookie{time} eq '') {
		$stat=1;
	} elsif($::antispamwiki_cookie{time}+0+$AntiSpamWiki::expire < $time) {
		$stat=-1;
	}
	if($stat+0 ne 0) {
		if($::form{mymsg} ne '' || $ENV{REQUEST_METHOD}=~/[Pp][Oo][Ss][Tt]/) {
			$::form{cmd}="read";
			$::form{mypage}=$::FrontPage;
		}
	}
	my $js=qq(<script type="text/javascript">@{[!$::is_xhtml ? "<!--\n" : '']}document.cookie="$::antispamwiki_cookie=time%3a$time; path=$::basepath";@{[!$::is_xhtml ? '//-->' : '']}</script>\n);
	return('init'=>1, 'header'=>$js);
}
1;
__DATA__
sub plugin_antispamwiki_setup {
	return(
	'ja'=>'Wikiスパミング防止',
	'en'=>'Anti Spam for WikiPlugin',
	'override'=>'',
	'url'=>'http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/antispamwiki/'
	);
}
__END__

=head1 NAME

antispamwiki.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Wiki spamming prevention plugin

=head1 DESCRIPTION

Wiki spamming is prevented in simple using cookie.

=head1 USAGE

rename to antispamwiki.inc.cgi

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/antispamwiki

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/antispam/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/antispamwiki.inc.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2010 by Nanami.

Copyright (C) 2005-2010 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
