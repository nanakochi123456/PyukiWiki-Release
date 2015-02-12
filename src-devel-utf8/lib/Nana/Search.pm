######################################################################
# Search.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: Search.pm,v 1.172 2011/12/31 13:06:14 papu Exp $
#
# "Nana::Search" version 0.5 $$
# Author: Nanami
# http://nanakochi.daiba.cx/
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
# Return:LF Code=UTF-8 1TAB=4Spaces
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
$VERSION = '0.5';

$Nana::Search::EUCPRE = qr{(?<!\x8F)};
$Nana::Search::EUCPOST = qr{
	(?=
	(?:[\xA1-\xFE][\xA1-\xFE])* # JIS X 0208 が 0文字以上続いて	# comment
	(?:[\x00-\x7F\x8E\x8F]|\z)  # ASCII, SS2, SS3 または終端	# comment
	)
}x;

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
		return 1 if($search =~ /$Nana::Search::EUCPRE\Q$keyword\E$Nana::Search::EUCPOST/i);
		return 0;
	}
}

sub Z2H_UTF8 {
	my ($parm)=@_;
	my $funcp = $::functions{"code_convert"};

	$parm .= '';
	$parm = &$funcp(\$parm, 'euc', 'utf8');
	return &Z2H($parm);
}

sub Z2H {
	my ($parm)=@_;

	$parm=~s/$Nana::Search::EUCPRE\xa1(\xaa|\xc9|\xf4|\xf0|\xf3|\xf5|\xc7|\xca|\xcb|\xf6|\xdc|\xa4|\xdd|\xa5|\xbf|\xa7|\xa2)$Nana::Search::EUCPOST//g;
	$parm=~s/$Nana::Search::EUCPRE\xa1(\xa8|\xe3|\xe1|\xe4|\xa9|\xf7|\xce|\xef|\xcf|\xb0|\xb2|\xc6|\xd0|\xc3|\xd1|\xd1|\xa3)$Nana::Search::EUCPOST//g;
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

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut