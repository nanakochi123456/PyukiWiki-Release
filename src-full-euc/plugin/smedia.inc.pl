######################################################################
# smedia.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: smedia.inc.pl,v 1.202 2012/03/01 10:39:21 papu Exp $
#
# "PyukiWiki" version 0.2.0-p2 $$
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
#
# ソーシャルメディアへリンクするプラグイン
#
######################################################################
sub plugin_smedia_init {
# デフォルトのソーシャルメディア
# lawson はデフォルトでは入っていません。
if(!defined($smedia::default)) {
	$smedia::default="twitter,facebook_like,google+,googlebookmark,browser";
	$smedia::default="twitter,facebook_like,google+,gree,,hatenabookmark,yahoobookmark,googlebookmark,livedoor,browser"
		if($::lang eq 'ja');
	$smedia::default="twitter,facebook_like,google+,mixicheck,gree,,hatenabookmark,yahoobookmark,googlebookmark,livedoor,browser"
		if($smedia::mixi{"data-key"} ne '');
}
# Twitter
# https://twitter.com/about/resources/buttons#tweet
$smedia::twitter{"data-via"}=""
	if(!defined($smedia::twitter{"data-via"}));
$smedia::twitter{"data-text"}=""
	if(!defined($smedia::twitter{"data-text"}));
$smedia::twitter{"data-related"}=""
	if(!defined($smedia::twitter{"data-related"}));
$smedia::twitter{"data-hashtags"}=""
	if(!defined($smedia::twitter{"data-hashtags"}));
$smedia::twitter{"data-url"}="";
$smedia::twitter{"data-lang"}=$::lang;
$smedia::twitter_html=<<EOM;
<a href="https://twitter.com/share" class="twitter-share-button" #data-url# #data-text# #data-via# #data-related# #data-hashtags# #data-lang#>$::resource{smedia_plugin_tweet}</a>
<script type="text/javascript"><!--
!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(d,"script","twitter-wjs");
//--></script>
EOM
# FaceBook
# http://developers.facebook.com/docs/reference/plugins/like/
$smedia::facebook{"data-href"}="";
$smedia::facebook_base_html=<<EOM;
<script type="text/javascript"><!--
(function(d,s,id){
var js,fjs=d.getElementsByTagName(s)[0];
if(d.getElementById(id)) return;
js=d.createElement(s);js.id=id;
js.src="//connect.facebook.net/@{[$::lang eq "ja" ? "ja_JP" : "en-US" ]}/all.js#xfbml=1";
fjs.parentNode.insertBefore(js,fjs);
}(d,'script','facebook-jssdk'));
//--></script>
EOM
$smedia::facebook_base_html_added=0;
$smedia::facebook_like_html=<<EOM;
<div class="fb-like" #data-href# data-send="false" data-layout="button_count" data-width="100" data-show-faces="true"></div>
EOM
$smedia::facebook_recommend_html=<<EOM;
<div class="fb-like" #data-href# data-send="false" data-layout="button_count" data-width="100" data-show-faces="true" data-action="recommend"></div>
EOM
# google+
# http://www.google.com/intl/ja/webmasters/+1/button/index.html
$smedia::googlep_html=<<EOM;
<g:plusone></g:plusone>
<script type="text/javascript"><!--
w.___gcfg = {lang: '$::lang'};(function(){var po=d.createElement('script');po.type='text/javascript';po.async=true;po.src='https://apis.google.com/js/plusone.js';var s=d.getElementsByTagName('script')[0];s.parentNode.insertBefore(po,s);})();
//--></script>
EOM
# はてなブックマーク
# http://b.hatena.ne.jp/guide/bbutton
$smedia::hatena{"url"}="";
$smedia::hatena{"title"}="";
$smedia::hatenabookmark_html=<<EOM;
<a href="http://b.hatena.ne.jp/entry/#url#" class="hatena-bookmark-button" data-hatena-bookmark-title="#title#" data-hatena-bookmark-layout="standard"><img src="http://b.st-hatena.com/images/entry-button/button-only.gif" width="20" height="20" style="border: none;" /></a><script type="text/javascript" src="http://b.st-hatena.com/js/bookmark_button.js" charset="utf-8" async="async"></script>
EOM
# mixiチェック
# https://mixi.jp/guide_developer.pl
# http://developer.mixi.co.jp/
# https://sap.mixi.jp/home.pl
#$smedia::mixi{"data-key"}="";
$smedia::mixi{"data-href"}="";
$smedia::mixi_html=<<EOM;
<div data-plugins-type="mixi-favorite" data-service-key="#data-key#" data-size="medium" data-href="#data-href#" data-show-faces="false" data-show-count="true" data-show-comment="true" data-width=""></div><script type="text/javascript">(function(d) {var s = d.createElement('script'); s.type = 'text/javascript'; s.async = true;s.src = '//static.mixi.jp/js/plugins.js#lang=ja';d.getElementsByTagName('head')[0].appendChild(s);})(d);</script>
EOM
# Yahooブックマーク
$smedia::yahoo_html=<<EOM;
<a href="javascript:void(0);" onclick="w.open('http://bookmarks.yahoo.co.jp/bookmarklet/showpopup?t='+encodeURIComponent(d.title)+'&amp;u='+encodeURIComponent(location.href)+'&amp;ei=UTF-8','_blank','width=550,height=480,left=100,top=50,scrollbars=1,resizable=1',0);"><img src="http://i.yimg.jp/images/ybm/blogparts/addmy_btn.gif" width="125" height="17" alt="$::resource{smedia_plugin_yahoobookmark}" style="border:none;"></a>
EOM
# googleブックマーク
$smedia::googleb_html=<<EOM;
<a style='background-color:#dddddd;border:2px groove black;padding:5px;padding-top:0px;padding-bottom:2px;color:black;font-family:sans-serif; text-decoration:none; font-size:10pt;margin-top:5px' href='javascript:void(0);' onclick='(function(){var c=encodeURIComponent,a=w.open("http://www.google.com/bookmarks/mark?op=edit&output=popup&bkmk="+c(d.location)+"&title="+c(d.title),"bkmk_popup","left="+((w.screenX||w.screenLeft)+10)+",top="+((w.screenY||w.screenTop)+10)+",height=420px,width=550px,resizable=1,alwaysRaised=1");w.setTimeout(function(){a.focus()},300)})();'>$::resource{smedia_plugin_googlebookmark}</a>
EOM
# livedoor clip!
$smedia::livedoor_html=<<EOM;
<div id="bmicon"><span><a href="javascript:void(0);" onclick="ou('http://clip.livedoor.com/clip/add?link='+encodeURIComponent(location.href)+'&title='+encodeURIComponent(d.title),'_target');"><img src="http://clip.livedoor.com/img/icon/bm_clip.gif" width="47" height="24" alt="clip!" title="clip!"></a></span></div>
EOM
# gree
$smedia::gree{"type"}="0";
$smedia::gree{"height"}="20";
$smedia::gree{"url"}="";
$smedia::gree_html=<<EOM;
<iframe src="http://share.gree.jp/share?url=#url#&amp;type=#type#&amp;height=#height#" scrolling="no" frameborder="0" marginwidth="0" marginheight="0" style="border:none; overflow:hidden; width:100px; height:#height#px;" allowTransparency="true"></iframe>
EOM
# ローソンガジェット
# http://www.lawson.co.jp/campaign/static/gadget/
$smedia::lawson_html=<<EOM;
<div id="lawsonGadget11_02" colortype="1" did="1da694feff6a9da06a24d990bb818e8e"></div><script type="text/javascript" charset="UTF-8" src="http://gadget.lawson.jp/js/type02.js"></script>
EOM
# ローカルブックマーク
$smedia::browser{"url"}="";
$smedia::asuhbrowser{"title"}="";
$smedia::browserbookmark_html=<<EOM;
<span id="bookmark#id#"></span>
<script type="text/javascript"><!--
wtbookmark("#id#");
//--></script>
EOM
$smedia::borwserbookmark_js=<<EOM;
<script type="text/javascript"><!--
function BrowserBookMark(){u=decodeURIComponent('#url#');t=decodeURIComponent('#title#');if(d.all){w.external.AddFavorite(u,t);}else if(navigator.userAgent.indexOf("Firefox")!=-1){w.sidebar.addPanel(t,u,'');}else{w.alert('$::resource{smedia_plugin_ignorebookmark}');}}
function wtbookmark(i){if(d.all||navigator.userAgent.indexOf("Firefox")!=-1)d.getElementById("bookmark"+i).innerHTML='<a style="background-color:#dddddd;border:2px groove black;padding:5px;padding-top:0px;padding-bottom:2px;color:black;font-family:sans-serif; text-decoration:none; font-size:10pt;margin-top:5px" href="javascript:void(0);" onclick="BrowserBookMark();">$::resource{smedia_plugin_bookmark}</a>';}
//--></script>
EOM
}
######################################################################
use strict;
my $plugin_smedia_id=0;
sub plugin_smedia_htmlout {
	my($mode)=shift;
	if($mode eq "twitter") {
		my $html=$smedia::twitter_html;
		foreach my $key(sort keys %smedia::twitter) {
			$html=~s!\#$key\#!@{[$smedia::twitter{$key} eq '' ? '' : qq($key="$smedia::twitter{$key}")]}!g;
		}
		return $html;
	} elsif($mode eq "facebook_like") {
		my $html;
		if($smedia::facebook_base_html_added eq 0) {
			$::IN_HEAD.=$smedia::facebook_base_html;
			$smedia::facebook_base_html_added=1;
		}
		$html.=$smedia::facebook_like_html;
		foreach my $key(sort keys %smedia::facebook) {
			$html=~s!\#$key\#!@{[$smedia::facebook{$key} eq '' ? '' : qq($key="$smedia::facebook{$key}")]}!g;
		}
		return $html;
	} elsif($mode eq "facebook_recommend") {
		my $html;
		if($smedia::facebook_base_html_added eq 0) {
			$::IN_HEAD.=$smedia::facebook_base_html;
			$smedia::facebook_base_html_added=1;
		}
		$html.=$smedia::facebook_recommend_html;
		foreach my $key(sort keys %smedia::facebook) {
			$html=~s!\#$key\#!@{[$smedia::facebook{$key} eq '' ? '' : qq($key="$smedia::facebook{$key}")]}!g;
		}
		return $html;
	} elsif($mode eq "google+") {
		my $html=$smedia::googlep_html;
		return $html;
	} elsif($mode eq "hatenabookmark") {
		my $html=$smedia::hatenabookmark_html;
		foreach my $key(sort keys %smedia::hatena) {
			$html=~s!\#$key\#!$smedia::hatena{$key}!g;
		}
		return $html;
	} elsif($mode eq "mixicheck") {
		my $html=$smedia::mixi_html;
		foreach my $key(sort keys %smedia::mixi) {
			$html=~s!\#$key\#!$smedia::mixi{$key}!g;
		}
		return $html;
	} elsif($mode eq "gree") {
		my $html=$smedia::gree_html;
		foreach my $key(sort keys %smedia::gree) {
			$html=~s!\#$key\#!$smedia::gree{$key}!g;
		}
		return $html;
	} elsif($mode eq "yahoobookmark") {
		my $html=$smedia::yahoo_html;
		return $html;
	} elsif($mode eq "googlebookmark") {
		my $html=$smedia::googleb_html;
		return $html;
	} elsif($mode eq "livedoor") {
		my $html=$smedia::livedoor_html;
		return $html;
	} elsif($mode eq "lawson") {
		my $html=$smedia::lawson_html;
		return $html;
	} elsif($mode eq "browser") {
		my $html=$smedia::browserbookmark_html;
		my $tmp=$smedia::borwserbookmark_js;
		foreach my $key(sort keys %smedia::browser) {
			$tmp=~s!\#$key\#!$smedia::browser{$key}!g;
		}
		$html=~s!\#id\#!$plugin_smedia_id!g;
		$::IN_HEAD.=$tmp if($plugin_smedia_id eq 0);
		$plugin_smedia_id++;
		return $html;
	}
	return "";
}
sub plugin_smedia_convert {
	return &plugin_smedia_inline(@_);
}
sub plugin_smedia_inline {
	my $argv = shift;
	my @argv=split(/,/,$argv);
	&plugin_smedia_init;
	return ' ' if($::htmlmode eq "xhtml11");
	return ' '
		if($::form{cmd}=~/edit|admin/);
	my $bar=0;
	foreach(@argv) {
		s/"//g;
		if($_ eq "menubar" || $_ eq "sidebar") {
			$bar=1;
			next;
		}
	}
	my $title=$::IN_TITLE ? $::IN_TITLE : $bar eq 1 ? $::pushedpage : $::form{mypage};
	$title.=" - $::wiki_title" if($::wiki_title ne '');
#	my $url=&make_cookedurl(&encode($bar eq 1 ? $::pushedpage : $::form{mypage}));
	my $url=&make_cookedurl($bar eq 1 ? $::pushedpage : $::form{mypage});
	&getbasehref;
	my $base=$::basehref;
	$base=~s/\/$//;
	$smedia::twitter{"data-url"}="$base$url";
	$smedia::twitter{"data-text"}=$title;
	$smedia::hatena{"url"}="$base$url";
	$smedia::hatena{"title"}=$title;
	$smedia::mixi{"data-href"}="$base$url";
	$smedia::gree{"url"}=&encode("$base$url");
	$smedia::browser{"url"}=&encode("$base$url");
	$smedia::browser{"title"}=&encode(&code_convert(\$title, 'utf8', $::defaultcode));
	foreach(@argv) {
		my($l,$r)=split(/=/,$_);
		if($l=~/^twitter\-(.+)/) {
			my $v=$1;
			if($v=~/data-via|data-text|data-related|data-hashtags|data-lang|data-url/) {
				$smedia::twitter{$v}=$r;
			}
		} elsif($l=~/^facebook\-(.+)/) {
			my $v=$1;
			if($v=~/data-href/) {
				$smedia::facebook{$v}=$r;
			}
		} elsif($l=~/^hatena\-(.+)/) {
			my $v=$1;
			if($v=~/href/) {
				$smedia::hatena{"url"}=$r;
			} elsif($v=~/title/) {
				$smedia::hatena{"title"}=$r;
			}
		}
	}
	my $out;
	if($bar eq 0) {
		$out=qq(<div align="right"><table><tr>);
		foreach(split(/,/,$smedia::default)) {
			if($_ eq '') {
				$out.="</tr></table><table><tr>";
			} else {
				$out.=qq(<td>);
				$out.=&plugin_smedia_htmlout($_);
				$out.=qq(</td>);
			}
		}
		$out.="</tr></table></div>\n";
		return $out;
	} else {
		$out=qq(<table>);
		foreach(split(/,/,$smedia::default)) {
			$out.=qq(<tr><td>);
			$out.=&plugin_smedia_htmlout($_);
			$out.=qq(</td></tr>);
		}
		$out.="</table>\n";
		return $out;
	}
}
1;
__END__
