#!/usr/bin/perl
#!/usr/local/bin/perl --
#!c:/perl/bin/perl.exe
#!c:\perl\bin\perl.exe
#!c:\perl64\bin\perl.exe
######################################################################
# index.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: index.cgi,v 1.426 2012/01/31 10:11:51 papu Exp $
#
# "PyukiWiki" version 0.2.0-p1 $$
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
use strict;
##############################
# You MUST modify following initial file.
$::ini_file = 'pyukiwiki.ini.cgi';
##############################
# optional
#$::setup_file='';
BEGIN {
	push @INC, 'lib';
	push @INC, 'lib/CGI';
	$::_conv_start = (times)[0];
}
require 'lib/wiki.cgi';
__END__
