######################################################################
# lookup.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: lookup.inc.pl,v 1.342 2011/12/31 13:06:10 papu Exp $
#
# "PyukiWiki" version 0.2.0 $$
# Author: Nekyo
# Copyright (C) 2004-2012 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2012 PyukiWiki Developers Team
# http://pyukiwiki.sfjp.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sfjp.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
use strict;
sub plugin_lookup_convert {
	my @args = split(/,/, shift);
#	if (@args < 2) { return ''; }
	my $iwn = &htmlspecialchars(&trim($args[0]));
	my $btn = &htmlspecialchars(&trim($args[1]));
	$btn="LookUp" if($btn eq '');
	my $default = '';
	if (@args > 2) {
		$default = &htmlspecialchars(trim($args[2]));
	}
	my $s_page = &htmlspecialchars($::form{mypage});
	my $popup_allow=$::setting_cookie{popup} ne '' ? $::setting_cookie{popup}
					: $::use_popup ? 1 : 0;
	my $ret;
	if($::is_xhtml) {
		$ret=<<EOD;
 <div>
  <form action="$::script" method="post"@{[$popup_allow eq 1 ? qq( onsubmit="this.target='_blank'") : '']}>
EOD
	} else {
		$ret=<<EOD;
 <div>
  <form action="$::script" method="post"@{[$popup_allow eq 1 ? ' target="_blank"' : '']}>
EOD
	}
	$ret.=<<EOD;
  <input type="hidden" name="cmd" value="lookup" />
  <input type="hidden" name="inter" value="$iwn" />
  $iwn:
  <input type="text" name="page" size="30" value="$default" />
  <input type="submit" value="$btn" />
  </form>
 </div>
EOD
	return $ret;
}
sub plugin_lookup_action {
	my $text = &decode($::form{page});
	$::form{inter}=~tr/A-Z/a-z/;
	my ($code, $uri) = %{$::interwiki2{$::form{inter}}};
	if ($uri) {
		if ($uri =~ /\$1/) {
			$uri =~ s/\$1/&interwiki_convert($code, $text)/e;
		} else {
			$uri .= &interwiki_convert($code, $text);
		}
	} else {
		$uri = $::interwiki{$::form{inter}};
		if ($uri) {
			$uri =~ s/\b(utf8|euc|sjis|ykwk|yw|asis)\(\$1\)/&interwiki_convert($1, $text)/e;
		}
	}
	if ($uri) {
		$uri=~s|&amp;|&|g;
		$uri=~s|&amp;|&|g;
		print &http_header("Status: 302","Location: $uri\n\n");
		exit;
	}
	return "";
}
1;
__END__
