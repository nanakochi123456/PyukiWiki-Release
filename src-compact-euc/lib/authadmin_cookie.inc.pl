######################################################################
# authadmin_cookie.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: authadmin_cookie.inc.pl,v 1.83 2011/02/22 20:59:12 papu Exp $
#
# "PyukiWiki" version 0.1.8-p3 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2011 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2011 PyukiWiki Developers Team
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
