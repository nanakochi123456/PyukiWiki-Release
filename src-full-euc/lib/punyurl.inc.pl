######################################################################
# punyurl.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: punyurl.inc.pl,v 1.76 2011/01/25 03:11:15 papu Exp $
#
# "PyukiWiki" version 0.1.8-p2 $$
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
# To use this plugin, rename to 'punyurl.inc.cgi'
# require perl version >= 5.8.1
######################################################################

use 5.8.1;
use strict;
use IDNA::Punycode;

sub plugin_punyurl_init {

$::isurl=q{(\b(?:https?|ftp|news)://(?:(?:[-_.!~*'()a-zA-Z0-9;:&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*@)?(?:(?:(?:[a-zA-Z0-9](?:[-_a-zA-Z0-9]*[a-zA-Z0-9])?|[-_0-9a-zA-Z\xa1-\xfe](?:[-_0-9a-zA-Z\xa1-\xfe]*[-_0-9a-zA-Z\xa1-\xfe])?)\.)*[a-zA-Z](?:[-a-zA-Z0-9]*[a-zA-Z0-9])?\.?|[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)(?::[0-9]*)?(?:/(?:[-_.!~*'a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*(?:;(?:[-_.!~*'a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)*(?:/(?:[-_.!~*'a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*(?:;(?:[-_.!~*'a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)*)*)?(?:\?(?:[-_.!~*'a-zA-Z0-9;/?:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)?(?:\x23(?:[-_.!~*'a-zA-Z0-9;/?:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)?)};

$::isurl_puny=q{[\x81-\xfe]};

	&init_inline_regex;

	return('init'=>1,
		   'func'=>'make_link_url',
		   'make_link_url'=>\&make_link_url,
		   'value'=>'isurl,isurl_puny',
		   '$::isurl'=>\$::isurl,
		   '$::isurl_puny'=>\$::isurl_puny
		);
}

sub make_link_url {
	my($class,$chunk,$escapedchunk,$img,$target)=@_;
	$target="_blank" if($target eq '');
	if($img ne '') {
		$class.=($class eq '' ? 'img' : '');
		return &make_link_target(&make_link_puny($chunk),$class,$target,"")
			. &make_link_image($img,$escapedchunk) . qq(</a>);
	}
	if($escapedchunk=~/^<img/) {
		return &make_link_target(&make_link_puny($chunk),$class,$target,$chunk)
			. qq($escapedchunk</a>);
	}
	return &make_link_target(&make_link_puny($chunk),$class,$target,$escapedchunk)
			. qq($escapedchunk</a>);
}

sub make_link_puny {
	my($url)=@_;
	if($url=~/$::isurl_puny/o) {
		$url=~/(https?|ftp):\/\/([^:\/\#]+)(.*)/;
		my $schme=$1;
		my $host=$2;
		my $last=$3;
		my $_host="";
		foreach my $str(split(/\./,$host)) {
			if($str=~/$::isurl_puny/o) {
				$str=&code_convert(\$str, 'utf8', 'euc');
				idn_prefix('xn--');
				utf8::decode($str);
				$str=IDNA::Punycode::encode_punycode("$str") . '.';
				utf8::encode($str);
				$str=~s/\-{3,9}/--/g;
				$_host.=$str;
			} else {
				$_host.="$str.";
			}
		}
		$_host=~s/\.$//g;
		$url="$schme://$_host$last";
	}
	return &make_link_urlhref($url);
}

1;
__DATA__
sub plugin_punyurl_setup {
	return(
	'ja'=>'多言語ドメインをpunycodeに変換する',
	'en'=>'View punycode of multibyte domain name',
	'override'=>'make_link_url',
	'url'=>'http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/punyurl/'
	);
__END__

