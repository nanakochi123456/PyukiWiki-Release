######################################################################
# MD5.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: MD5.pm,v 1.43 2012/03/18 11:23:51 papu Exp $
#
# "Nana::MD5" ver 0.1 $$
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

package	Nana::MD5;
use 5.005;
use strict;
use vars qw($VERSION);
use integer;
use Exporter;
use vars qw($VERSION @ISA @EXPORTER @EXPORT_OK);

@EXPORT_OK = qw(md5 md5_hex md5_base64);

@ISA = 'Exporter';
$VERSION = '0.1';

$MD5::Method="";

my $funcp = $::functions{"load_module"};
if(&$funcp("Digest::MD5")) {
	$MD5::Method="Digest::MD5";
} elsif(&$funcp("Digest::Perl::MD5")) {
	$MD5::Method="Digest::Perl::MD5";
}

sub md5 {
	if($MD5::Method eq "Digest::MD5") {
		return Digest::MD5::md5(@_);
	} elsif($MD5::Method eq "Digest::Perl::MD5") {
		return Digest::Perl::MD5::md5(@_);
	}
	die;
}

sub md5_hex {
	if($MD5::Method eq "Digest::MD5") {
		return Digest::MD5::md5_hex(@_);
	} elsif($MD5::Method eq "Digest::Perl::MD5") {
		return Digest::Perl::MD5::md5_hex(@_);
	}
	die;
}

sub md5_base64 {
	if($MD5::Method eq "Digest::MD5") {
		return Digest::MD5::md5_base64(@_);
	} elsif($MD5::Method eq "Digest::Perl::MD5") {
		return Digest::Perl::MD5::md5_base64(@_);
	}
	die;
}

1;
__END__
