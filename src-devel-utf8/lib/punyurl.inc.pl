######################################################################
# punyurl.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: punyurl.inc.pl,v 1.338 2012/03/18 11:23:55 papu Exp $
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
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'punyurl.inc.cgi'
# require perl version >= 5.8.1
######################################################################

use 5.8.1;
use strict;
use IDNA::Punycode;

sub plugin_punyurl_init {

# add 0.2.0 FileSchme

if($::useFileScheme eq 1) {
	$::isurl=q{(\b(?:(?:(?:https?|ftp|news)://)|(?:file:[/\x5c][/\x5c]))(?:(?:[-_.!~*'()a-zA-Z0-9;:&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*@)?(?:(?:(?:[a-zA-Z0-9](?:[-_a-zA-Z0-9]*[a-zA-Z0-9])?|[-_0-9a-zA-Z\x80-\xfd](?:[-_0-9a-zA-Z\x80-\xfd]*[-_0-9a-zA-Z\x80-\xfd])?)\.)*[a-zA-Z](?:[-a-zA-Z0-9]*[a-zA-Z0-9])?\.?|[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)(?::[0-9]*)?(?:/(?:[-_.!~*'a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*(?:;(?:[-_.!~*'a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)*(?:/(?:[-_.!~*'a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*(?:;(?:[-_.!~*'a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)*)*)?(?:\?(?:[-_.!~*'a-zA-Z0-9;/?:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)?(?:\x23(?:[-_.!~*'a-zA-Z0-9;/?:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)?)};
} else {
	$::isurl=q{(\b(?:https?|ftp|news)://(?:(?:[-_.!~*'()a-zA-Z0-9;:&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*@)?(?:(?:(?:[a-zA-Z0-9](?:[-_a-zA-Z0-9]*[a-zA-Z0-9])?|[-_0-9a-zA-Z\x80-\xfd](?:[-_0-9a-zA-Z\x80-\xfd]*[-_0-9a-zA-Z\x80-\xfd])?)\.)*[a-zA-Z](?:[-a-zA-Z0-9]*[a-zA-Z0-9])?\.?|[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)(?::[0-9]*)?(?:/(?:[-_.!~*'a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*(?:;(?:[-_.!~*'a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)*(?:/(?:[-_.!~*'a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*(?:;(?:[-_.!~*'a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)*)*)?(?:\?(?:[-_.!~*'a-zA-Z0-9;/?:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)?(?:\x23(?:[-_.!~*'a-zA-Z0-9;/?:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)?)};
}

$::isurl_puny=q{[\x80-\xfd]};



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
	my($class,$chunk,$escapedchunk,$img,$target,$alt)=@_;
	$target="_blank" if($target eq '');
	if($img ne '') {
		$class.=($class eq '' ? 'img' : '');
		return &make_link_target(&make_link_puny($chunk),$class,$target,"")
			. &make_link_image($img,$escapedchunk) . qq(</a>);
	}
	if($escapedchunk=~/^<img/) {
		return &make_link_target(&make_link_puny($chunk),$class,$target,@{[$alt eq '' ? $chunk : $alt]})
			. qq($escapedchunk</a>);
	}
	return &make_link_target(&make_link_puny($chunk),$class,$target,$escapedchunk)
			. qq($escapedchunk</a>);
}

sub make_link_puny {
	my($url)=@_;

	if($url=~/$::isurl_puny/o) {
		$url=~/(https?|ftp|news):\/\/([^:\/\#]+)(.*)/;
		my $schme=$1;
		my $host=$2;
		my $last=$3;
		my $_host="";
		if($host=~/$::isurl_puny/o) {
			foreach my $str(split(/\./,$host)) {
				if($str=~/$::isurl_puny/o) {
					$str=&code_convert(\$str, 'utf8', $::defaultcode);
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
		} else {
			return &make_link_urlhref($url);
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
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/punyurl/'
	);
__END__

=head1 NAME

punyurl.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

URL with domain names other than the ASCII character is changed into punycode URL.

=head1 DESCRIPTION

URL with domain names other than the ASCII characters, such as a multilingual character, is changed into punycode URL.

http://日本語.jp/ -> http://xn--wgv71a119e.jp/

=head1 WARNING

Require Perl version is '5.8.1'.

This version supported only japanese domain.

=head1 USAGE

rename to punyurl.inc.cgi

=head1 OVERRIDE

make_link_url function was overrided.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/punyurl

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/punyurl/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/punyurl.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/lib/punyurl.inc.pl?view=log>

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
