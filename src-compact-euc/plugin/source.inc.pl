######################################################################
# source.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: source.inc.pl,v 1.369 2012/01/31 10:11:58 papu Exp $
#
# "PyukiWiki" version 0.2.0-p1 $$
# Author: Nekyo http://nekyo.qp.land.to/
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
# Usage:?cmd=source&page=pagename
######################################################################
use strict;
sub plugin_source_action {
	return if ($::form{'page'} eq '');
	my $page = $::form{'page'};
	print "Content-Type: text/plain\r\n\r\n";
	print $::database{$page};
	&close_db;
	exit(0);
}
1;
__END__
