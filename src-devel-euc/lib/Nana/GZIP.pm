######################################################################
# GZIP.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: GZIP.pm,v 1.73 2011/12/31 13:06:10 papu Exp $
#
# "Nana::GZIP" version 0.1 $$
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
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
#
# use Nana::GZIP;
# $compressdata=Nana::GZIP::compress($originaldata);
# $extractdata=Nana::GZIP::uncompress($originaldata);
# see
# http://suika.fam.cx/~wakaba/wiki/sw/n/Perl%E3%81%A7%E3%81%AEgzip%E3%81%AE%E5%9C%A7%E7%B8%AE%E3%83%BB%E5%B1%95%E9%96%8B

package Nana::GZIP;
$VERSION="0.1";
use strict;

use Compress::Zlib;

# compress															# debug
sub gzipcompress($) {
	my($data)=shift;
	return Compress::Zlib::memGzip($data);
}

# uncompress														# debug
sub gzipuncompress($) {
	## Taken from Namazu <http://www.namazu.org/>, filter/gzip.pl	# debug
	my ($data)=shift;
	my ($s)=$data;
	my $flags = unpack('C', substr($s, 3, 1));
	$s = substr($s, 10);
	$s = substr($s, 2)  if ($flags & 0x04);
	$s =~ s/^[^\0]*\0// if ($flags & 0x08);
	$s =~ s/^[^\0]*\0// if ($flags & 0x10);
	$s = substr($s, 2)  if ($flags & 0x02);

	my $zl = Compress::Zlib::inflateInit
		(-WindowBits => - Compress::Zlib::MAX_WBITS());
	my ($inf, $stat) = $zl->inflate ($s);
	if ($stat == Compress::Zlib::Z_OK()
		|| $stat == Compress::Zlib::Z_STREAM_END()) {
		return $inf;
	} else {
		return 'Bad compressed data';
	}
}
1;
