######################################################################
# source.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: source.inc.pl,v 1.24 2010/12/14 22:20:00 papu Exp $
#
# "PyukiWiki" version 0.1.8 $$
# Author: Nekyo
# Copyright (C) 2004-2010 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2010 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
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

=head1 NAME

source.inc.pl - PyukiWiki Plugin

=head1 AUTHOR

=over 4

=item Nekyo

L<http://nekyo.qp.land.to/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2004-2010 by Nekyo.

Copyright (C) 2005-2010 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut