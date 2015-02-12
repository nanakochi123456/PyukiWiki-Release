######################################################################
# debug.inc.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: debug.inc.pl,v 1.508 2012/03/18 11:23:50 papu Exp $
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
# Return:LF Code=Shift-JIS 1TAB=4Spaces
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'debug.inc.cgi'
# WARNING!: Internet Explorer or FireFox Only...TT
# Can't use xhtml11 mode
######################################################################

$::mode_debug=1;

sub plugin_debug_init {
	my $head=<<EOM;
<script type="text/javascript"><!--
function Display(b,a){if(d.all||d.getElementById){if(d.all){obj=d.all(b).style}else{if(d.getElementById){obj=d.getElementById(b).style}}if(a=="view"){obj.display="block"}else{if(a=="none"){obj.display="none"}else{if(obj.display=="block"){obj.display="none"}else{if(obj.display=="none"){obj.display="block"}}}}}};
//--></script>
EOM

	# 管理者認証なし
	&exec_explugin_sub("authadmin_cookie");
	if($::_exec_plugined{"authadmin_cookie"} < 2) {
		return(
#			'http_header'=>"X-PyukiWiki-Version: $::version Debug (No auth)",
			'header'=>$head,
			'init'=>1,
			'func'=>'_db',
			'_db'=>\&_db,
		);
	}

	# cookie認証通らない場合無効
	if($::authadmin_cookie_user_name ne $::authadmin_cookie_admin_name{admin}) {
		return(
			'http_header'=>"X-PyukiWiki-Version: $::version",
			'init'=>0,
		);
	}

	# 管理者認証あり
	return(
#		'http_header'=>"X-PyukiWiki-Version: $::version Debug (Authed)",
		'header'=>$head,
		'init'=>1,
		'func'=>'_db',
		'_db'=>\&_db,
	);
}

sub _db {
	my ($pagebody)=@_;
	my $envs;
	my $forms;
	my $body;
	my $jsclose;

	# cookie認証通らない場合無効
	if($::authadmin_cookie_user_name ne $::authadmin_cookie_admin_name{admin}) {
		return $pagebody;
	}

	foreach(keys %ENV) {
		$envs.="$_=$ENV{$_}\n";
	}
	foreach(keys %::form) {
		$forms.="$_=$::form{$_}\n";
	}
	push(@DB,"debug");
	push(@DB,"form");
	push(@DB,"http");
	push(@DB,"env");

	$DB{debug_msg}="Debug Messages(\$::debug)";
	$DB{debug_arg}=$::debug;
	$DB{form_msg}="Form Data";
	$DB{form_arg}=$forms;
	$DB{http_msg}="HTTP Header";
	$DB{http_arg}=$::HTTP_HEADER;
	$DB{env_msg}="Environment variable";
	$DB{env_arg}=$envs;

	$body=<<EOM;
<table width="100%"><form>
<tr><th class="style_th">
EOM
	foreach my $db1(@DB) {
		$jsclose.="Display('$db1','none');";
	}
	foreach my $db1(@DB) {
		$body.=<<EOM;
[<a href="javascript:$jsclose Display('$db1','view');">$DB{$db1 . '_msg'}</a>]
EOM
	}
	$body.=<<EOM;
[<a href="javascript:$jsclose">X</a>]</th></tr>
EOM
	foreach my $db1(@DB) {
		$body.=<<EOM;
<tr><td class="style_td" style="display: none;" id="$db1" align="center"><textarea cols="100" rows="5">@{[&htmlspecialchars($DB{$db1 . '_arg'},1)]}</textarea></td></tr>
EOM
	}
	$body.=<<EOM;
</form></table>
EOM

	$pagebody=~s!<div id="navigator">!$body<div id="navigator">!g;
	return $pagebody;
}

1;
__DATA__
sub plugin_debug_setup {
	return(
	'en'=>'PyukiWiki Debug Plugin',
	'override'=>'_db',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/debug/'
	);
__END__

=head1 NAME

debug.inc.pl - PyukiWiki Developpers Plugin

=head1 SYNOPSIS

Instant debugger for PyukiWiki

=head1 DESCRIPTION

value $::debug, the received form data, Cookie (un-mounting), a HTTP header, and a server environment variable are displayed on the page upper part.

=head1 USAGE

rename to debug.inc.cgi

=head1 OVERRIDE

_db function was overrided.

=head1 WARNING

Now, only Internet Explorer is supported.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/debug

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/debug/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/debug.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/lib/debug.inc.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sfjp.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2012 by Nanami.

Copyright (C) 2005-2012 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
