#!/usr/bin/perl
#!/usr/local/bin/perl --
#!c:/perl/bin/perl.exe
#!c:\perl\bin\perl.exe
######################################################################
# index.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: index.cgi,v 1.91 2011/05/03 20:43:28 papu Exp $
#
# "PyukiWiki" version 0.1.9 $$
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

# Libraries.
use strict;

##############################
# You MUST modify following initial file.
$::ini_file = 'pyukiwiki.ini.cgi';

##############################
# optional
#$::setup_file='';

# if you can use lib is ../lib then swap this comment

BEGIN {
	push @INC, 'lib';
	push @INC, 'lib/CGI';
	$::_conv_start = (times)[0];
}











use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);


require 'lib/wiki.cgi';

__END__


