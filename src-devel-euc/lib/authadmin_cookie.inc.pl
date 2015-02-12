######################################################################
# authadmin_cookie.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: authadmin_cookie.inc.pl,v 1.88 2011/05/03 20:43:28 papu Exp $
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
# To use this plugin, rename to 'authadmin_cookie.inc.cgi'
######################################################################
#
# 凍結パスワードの一時cookie保存
#
# 保存しないcookieとして、ブラウザのセッションが有効な間だけ
# 凍結パスワードを保存します。いいかえれば、ブラウザを閉じるまで
# パスワードを保存します。
#
######################################################################

# Initlize

sub plugin_authadmin_cookie_init {
	# force init lang.inc.cgi
	&exec_explugin_sub("lang");

	my %passwdcookie;
	%passwdcookie=&getcookie("PyukiWikiAdminPass",%passwdcookie);
	if(&valid_password($passwdcookie{"admin"},"admin")) {
		if($::navi{"admin_url"} eq '') {
			push(@::addnavi,"admin:help");
			$::navi{"admin_url"}="$::script?cmd=admin";
			$::navi{"admin_name"}=$::resource{"adminbutton"};
			$::navi{"admin_type"}="plugin";
		}
	}
	return ('header'=>$header,'init'=>1
		, 'func'=>'authadminpassword', 'authadminpassword'=>\&authadminpassword);
}

sub authadminpassword {
	# usage
	# ($ret,$html)=&authadminpassword($mode,$title,$type)
	# $modeの値
	# page:パスワード入力専用ページを出す
	# input:パスワードの入力欄だけを出す
	# $titleの値
	# 表示するべきタイトル
	# $typeの値
	# 空欄：凍結パスワード
	# admin：管理パスワード
	# attach：添付パスワード
	# return値
	# submitの場合
	# (authed=>0 or 1 ,html=>string)=authadminpassword
	# authed : 0 : 認証されていない
	# authed : 1 : 認証されている
	# html       : 表示すべきHTML
	my($mode,$title,$type)=@_;
	my $body;
	my $auth=0;
	$type=($type eq "attach" ? "attach" : $type eq "frozen" ? "frozen" : "admin");
	my %passwdcookie;
	%passwdcookie=&getcookie("PyukiWikiAdminPass",%passwdcookie);
	if($::form{mypassword} eq '' && (
			   &valid_password($passwdcookie{$type},$type)
			|| &valid_password($passwdcookie{"admin"},"admin")
			|| &valid_password($passwdcookie{"attach"},"admin")
			|| &valid_password($passwdcookie{"frozen"},"admin")
			)) {
		$::form{mypassword}=$passwdcookie{$type};
		$auth=1;
	} elsif(&valid_password($::form{mypassword},$type)
		 || &valid_password($::form{mypassword},"admin")) {
		$passwdcookie{$type}=$::form{mypassword};
		if(&valid_password($::form{mypassword},$type)
			 && &valid_password($::form{mypassword},"admin")) {
			$passwdcookie{admin}=$::form{mypassword};
		}
		&setcookie("PyukiWikiAdminPass",0,%passwdcookie);
		$auth=1;
	}

	if($mode=~/submit|page|form/) {
		$title=$::resource{admin_passwd_prompt_title} if($title eq '');
		if(!$auth) {
			$body=<<EOM;
<h2>$title</h2>
@{[$ENV{REQUEST_METHOD} eq 'GET' && $::form{mypassword} eq '' ? '' : qq(<div class="error">$::resource{admin_passwd_prompt_error}</div>\n)]}
<form action="$::script" method="post" id="adminpasswordform" name="adminpasswordform">
$::resource{admin_passwd_prompt_msg}<input type="password" name="mypassword" size="10">
<input type="submit" value="$::resource{admin_passwd_button}">
EOM
			foreach my $forms(keys %::form) {
				$body.=qq(<input type="hidden" name="$forms" value="$::form{$forms}">\n);
			}
			$body.="</form>\n";
			return('authed'=>0,'html'=>$body);
		} else {
			$body.=qq(<input type="hidden" name="mypassword" value="$::form{mypassword}">\n);
			return('authed'=>1,'html'=>$body);
		}
	} else {
		if(!$auth) {
			$body.=<<EOM;
@{[$ENV{REQUEST_METHOD} eq 'GET' && $::form{mypassword} eq '' ? '' : qq(<div class="error">$::resource{admin_passwd_prompt_error}</div>)]}
EOM
			$body.=qq(@{[$title ne '' ? $title : $::resource{admin_passwd_prompt_msg}]}<input type="password" name="mypassword" value="$::form{mypassword}" size="10">\n);
			return('authed'=>0,'html'=>$body);
		} else {
			$body.=qq(<input type="hidden" name="mypassword" value="$::form{mypassword}">\n);
			return('authed'=>1,'html'=>$body);
		}
	}
}

1;
__DATA__
sub plugin_authadmin_cookie_setup {
	return(
	'en'=>'Frozen password saved on temporary cookie',
	'jp'=>'凍結パスワードを一時クッキーに保存する',
	'override'=>'authadminpassword',
	'url'=>'http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/authadmin_cookie/'
	);
__END__
=head1 NAME

authadmin_cookie.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Frozen password saved on temporary cookie

=head1 USAGE

rename to authadmin_cookie.inc.cgi

=head1 OVERRIDE

authadminpassword function was overrided.

=BUGS

This plugin is evaluation version. In 1.0, the mounting method is be changed.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/authadmin_cookie

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/authadmin_cookie/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/authadmin_cookie.inc.pl?view=log>

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
