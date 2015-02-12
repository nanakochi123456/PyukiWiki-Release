######################################################################
# linktrack.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: linktrack.inc.pl,v 1.255 2012/01/31 10:12:02 papu Exp $
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
# To use this plugin, rename to 'linktrack.inc.cgi'
######################################################################
#
# リンクトラッキングカウンター
#
######################################################################
# この変数に自分のURL（http://等を除く) を入れれば、
# その分のカウンターを弾く
#
$linktrack::ignoredomain = $ENV{HTTP_HOST}
	if($linktrack::ignoredomain eq '');
######################################################################
sub plugin_linktrack_init {
	my $header=<<EOM;
<script type="text/javascript"><!--
function Ck(c,f){var b="&amp;",e="?cmd=ck"+b,g=e+c,a;if(f=="r"){g=e+"r=y"+b+c;d.location=g;return true}else{if(f!=""){openURI(g,f)}else{d.location=g}}return false};
//--></script>
EOM
	return ('init'=>1 ,  'header'=>$header
		, 'func'=>'make_link_target', 'make_link_target'=>\&make_link_target);
}
$::linktrack_link_id=0;
sub make_link_target {
	my($url,$class,$target,$escapedchunk,$flag)=@_;
	$flag=$::use_popup if($flag eq '');
	$class=&htmlspecialchars($class);
	$target=&htmlspecialchars($target);
	$escapedchunk=&htmlspecialchars($escapedchunk);
	my $popup_allow=$::setting_cookie{popup} ne '' ? $::setting_cookie{popup}
					: $flag+0 ? 1 : 0;
	my $target=$popup_allow != 0 ? $target : '';
	$target='' if($flag eq 2 && $url=~/ttp\:\/\/$ENV{HTTP_HOST}/);
	if($target ne '' && $flag eq 3) {
		my $tmp=$::basehref;
		$tmp=~s/\/.*//g;
		$target='' if($url=~/\Q$tmp/);
	}
	my $mydomain=0;
	foreach(split(/,/,$linktrack::ignoredomain)) {
		if($url=~/\/\/$_/) {
			$mydomain=1;
		}
	}
	my $escapedurl;
	if($mydomain eq 0) {
#		$escapedurl="?cmd=ck&amp;p=" . &escape($::form{mypage}) . "&amp;lk=" . &dbmname(&unescape($url));
		my $mp=&dbmname(&unescape($::form{mypage}));
		$escapedurl="p=" . $mp . "&amp;l=" . &dbmname(&unescape($url));
		$::linktrack_link_id++;
		if($target eq '') {
			return qq(<a href="$url" @{[$class eq '' ? '' : qq(class="$class")]} title="$escapedchunk" onclick="return Ck('$escapedurl','');" oncontextmenu="return Ck('$escapedurl','r');">);
		} elsif($::is_xhtml) {
			return qq(<a href="$url" @{[$class eq '' ? '' : qq(class="$class")]} title="$escapedchunk" onclick="return Ck('$escapedurl','$target');" oncontextmenu="return Ck('$escapedurl','r');">);
		} else {
			return qq(<a href="$url" @{[$class eq '' ? '' : qq(class="$class")]} title="$escapedchunk" onclick="return Ck('$escapedurl','$target');" oncontextmenu="return Ck('$escapedurl','r');">);
		}
	} else {
		if($target eq '') {
			return qq(<a href="$url" @{[$class eq '' ? '' : qq(class="$class")]} title="$escapedchunk">);
		} elsif($::is_xhtml) {
			return qq(<a href="$url" @{[$class eq '' ? '' : qq(class="$class")]} title="$escapedchunk" onclick="return openURI('$url','$target');">);
		} else {
			return qq(<a href="$url" @{[$class eq '' ? '' : qq(class="$class")]} target="$target" title="$escapedchunk">);
		}
	}
}
1;
__DATA__
sub plugin_linktrack_setup {
	return(
	'en'=>'Out link to tracking counter.',
	'jp'=>'外部リンクへのカウンターを取る',
	'override'=>'make_link_target',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/linktrack/'
	);
__END__
