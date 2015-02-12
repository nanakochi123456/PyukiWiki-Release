######################################################################
# Search.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: Search.pm,v 1.475 2012/03/01 10:39:20 papu Exp $
#
# "Nana::Search" version 0.6 $$
# Author: Nanami
# http://nanakochi.daiba.cx/
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
# 日本語あいまい検索をするためのモジュールです。内部コードEUC、UTF8用
######################################################################

package	Nana::Search;
use 5.8.1;
use strict;
use vars qw($VERSION @EXPORT_OK @ISA @EXPORT);
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw();
@EXPORT_OK = qw();
$VERSION = '0.6';

$Nana::Search::EUCPRE = qr{(?^:(?<!\x8F))};
$Nana::Search::EUCPOST = qr{(?^x:(?=(?:[\xA1-\xFE][\xA1-\xFE])*(?:[\x00-\x7F\x8E\x8F]|\z)))};
$Nana::Search::TAGOUTSIDE = qr{(?^:((?:\G|>)[^<]*?))};

sub Search {
	my($text,$wd)=@_;
	my $search;
	my $keyword;

	if($::defaultcode eq "utf8") {
		$search=&Z2H_UTF8($text);
		if($::_SEARCH{$wd} eq '') {
			$keyword=&Z2H_UTF8($wd);
			$::_SEARCH{$wd}=$keyword;
		} else {
			$keyword=$::_SEARCH{$wd};
		}
		return 0 if($keyword eq '');
		return 1 if($search =~ /$Nana::Search::EUCPRE\Q$keyword\E$Nana::Search::EUCPOST/i);
		return 0;
	} else {
		$search=&Z2H($text);
		if($::_SEARCH{$wd} eq '') {
			$keyword=&Z2H($wd);
			$::_SEARCH{$wd}=$keyword;
		} else {
			$keyword=$::_SEARCH{$wd};
		}
		return 0 if($keyword eq '');
#		return 1 if($search =~ /$Nana::Search::EUCPRE$keyword$Nana::Search::EUCPOST/i);
		return 1 if($search =~ /$Nana::Search::EUCPRE\Q$keyword\E$Nana::Search::EUCPOST/i);
		return 0;
	}
}

sub SearchRe {
	my($text,$wd, $to1, $to2)=@_;
	my $search;
	my $keyword;
	my $tmp1;
	my $tmp2;
	if($::defaultcode eq "utf8") {
		$search=&UTF8($text);
		$tmp1=&UTF8($to1);
		$tmp2=&UTF8($to2);
		$keyword=&Z2H2_UTF8($wd);

		$search=~s/$Nana::Search::TAGOUTSIDE($keyword)/$1$tmp1$2$tmp2/g;
#		$search=~s/((?:\G|>)[^<]*?)($keyword)/$1$tmp1$2$tmp2/g;
#		$search=~s/(?:^|(?<=>))([^<]*)/(my $tmp = $1) =~ s!($keyword)!$tmp1$1$tmp2!g; $tmp/egs;
		return &EUC($search);
	} else {
		$search=$text;
		$tmp1=$to1;
		$tmp2=$to2;
		$keyword=&Z2H2($wd);

		$search=~s/$Nana::Search::TAGOUTSIDE($keyword)/$1$tmp1$2$tmp2/g;
#		$search=~s/((?:\G|>)[^<]*?)($keyword)/$1$tmp1$2$tmp2/g;
#		$search=~s/(?:^|(?<=>))([^<]*)/(my $tmp = $1) =~ s!$Nana::Search::EUCPRE($keyword)$Nana::Search::EUCPOST!$tmp1$1$tmp2!g; $tmp/egs;
		return $search;
	}
}

sub Z2H_UTF8 {
	my ($parm)=@_;
	return &Z2H(&UTF8($parm));
}

sub Z2H2_UTF8 {
	my ($parm)=@_;
	return &Z2H2(&UTF8($parm));
}

sub UTF8 {
	my ($parm)=@_;
	my $funcp = $::functions{"code_convert"};
	$parm .= '';
	$parm = &$funcp(\$parm, 'euc', 'utf8');
	return $parm;
}

sub EUC {
	my ($parm)=@_;
	my $funcp = $::functions{"code_convert"};
	$parm .= '';
	$parm = &$funcp(\$parm, 'utf8', 'euc');
	return $parm;
}

sub Z2H2 {
	my ($parm)=@_;
	my @tbl=(
		"\xa1|\xa2","\xa3|\xa4|\xf0","\xa5|\xa6|\xf1","\xa7|\xa8|\xf1","\xa9|\xaa",
		"\xab|\xac|\xf5|\xf6","\xad|\xae","\xaf|\xb0","\xb1|\xb2|\xf5|\xf6","\xb3|\xb4",
		"\xb5|\xb6","\xb7|\xb8","\xb9|\xba","\xbb|\xbc","\xbd|\xbe",
		"\xbf|\xc0","\xc1|\xc2","(\xc3|\xc4|\xc5)?","\xc6|\xc7","\xc8|\xc9",
		"\xcf|\xd0|\xd1","\xd2|\xd3|\xd4","\xd5|\xd6|\xd7","\xd8|\xd9|\xda","\xdb|\xdc|\xdd",
		"(\xe3|\xe4)?","(\xe5|\xe6)?","(\xe7|\xe8)?",
		"\xee|\xef"
	);
	# 全角記号
	$parm=~s/$Nana::Search::EUCPRE
		\xa1(\xaa|\xc9|\xf4|\xf0|\xf3|\xf5|\xc7|\xca|\xcb|\xf6
			|\xdc|\xa4|\xdd|\xa5|\xbf|\xa7|\xa2
			|\xa8|\xe3|\xe1|\xe4|\xa9|\xf7|\xce|\xef|\xcf|\xb0
			|\xb2|\xc6|\xd0|\xc3|\xd1|\xd1|\xa3)$Nana::Search::EUCPOST
		/\.\./g;
	# 半角記号
	$parm=~s/[\x21-\x2f|\x3a-\x40|\x5b-\x60|\x7b-\x7f]/\(.+?)/g;
	$parm=~s/$Nana::Search::EUCPRE\xa5\xa4$Nana::Search::EUCPOST/\r/g;
	foreach(@tbl) {
		$parm=~s/(\xa4|\xa5)($_)/(\xa4\|\xa5)($_)/g;
	}
	$parm=~s/\r/\xa5\xa4/g;
	$parm=~s/$Nana::Search::EUCPRE(\xa3)(.)$Nana::Search::EUCPOST/"(\xa3" . $2 . "|" . pack('C',unpack('C',$2)-128) . ")"/eg;
	$parm=~s/([A-Z])/"(" . $1 . "|" . pack('C',unpack('C', $1)+32) . ")"/eg;
	$parm=~s/([a-z])/"(" . $1 . "|" . pack('C',unpack('C', $1)-32) . ")"/eg;

	return $parm;
}

sub Z2H {
	my ($parm)=@_;

	$parm=~s/$Nana::Search::EUCPRE\xa1(\xaa|\xc9|\xf4|\xf0|\xf3|\xf5|\xc7|\xca|\xcb|\xf6|\xdc|\xa4|\xdd|\xa5|\xbf|\xa7|\xa2)$Nana::Search::EUCPOST//g;
	$parm=~s/$Nana::Search::EUCPRE\xa1(\xa8|\xe3|\xe1|\xe4|\xa9|\xf7|\xce|\xef|\xcf|\xb0|\xb2|\xc6|\xd0|\xc3|\xd1|\xd1|\xa3)$Nana::Search::EUCPOST//g;
	$parm=~s/$Nana::Search::EUCPRE
		\xa1(\xaa|\xc9|\xf4|\xf0|\xf3|\xf5|\xc7|\xca|\xcb|\xf6
			|\xdc|\xa4|\xdd|\xa5|\xbf|\xa7|\xa2
			|\xa8|\xe3|\xe1|\xe4|\xa9|\xf7|\xce|\xef|\xcf|\xb0
			|\xb2|\xc6|\xd0|\xc3|\xd1|\xd1|\xa3)$Nana::Search::EUCPOST
		//g;
	$parm=~s/[\x21-\x2f|\x3a-\x40|\x5b-\x60|\x7b-\x7f]//g;
	$parm=~s/$Nana::Search::EUCPRE\xa5\xa4$Nana::Search::EUCPOST/\r/g;
	$parm=~s/$Nana::Search::EUCPRE\xa4([\xa1-\xfe])$Nana::Search::EUCPOST/\xa5$1/g;
	$parm=~s/\r/\xa5\xa4/g;
	$parm=~s/$Nana::Search::EUCPRE\xa5(\xa1|\xa3|\xa5|\xa7|\xa9|\xc3)$Nana::Search::EUCPOST/"\xa5" . pack('C',unpack('C',$1)+1)/eg;
	$parm=~s/\xa5\xf0/\xa5\xa4/g;
	$parm=~s/\xa5\xf1/\xa5\xa8/g;
	$parm=~s/$Nana::Search::EUCPRE(\xa3)(.)$Nana::Search::EUCPOST/pack('C',unpack('C',$2)-128)/eg;
	$parm=~tr/A-Z/a-z/;
	return $parm;
}

1;
__END__

=head1 NAME

Nana::Search - Japanese fuzzy search module

=head1 SYNOPSIS

 use Nana::Search qw(Search);
 Search(text, search_words);

Internal charactor set is Japanese of EUC or UTF8 only

=head1 SAMPLES

 "FrontPage" hits keyword...
  FRoNTpAGe , ＦＲＯＮＴｐａｇｅ
 "うぃき" hits keyword...
 ういき ウイキ ウィキ うゐき etc...
 "あたしネカマなのなの。だから、告白しないでね" hits keyword...
 ナノダカラ あたしねかま ダカラ告白

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
