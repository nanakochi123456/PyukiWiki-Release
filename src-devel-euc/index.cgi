#!/usr/bin/perl
#!/usr/local/bin/perl --
#!c:/perl/bin/perl.exe
#!c:\perl\bin\perl.exe
######################################################################
# index.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: index.cgi,v 1.85 2011/01/25 03:11:15 papu Exp $
#
# "PyukiWiki" version 0.1.8-p2 $$
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

	# If Windows NT Server, use sample it
	#BEGIN {
	#	chdir('C:/inetpub/cgi-bin/pyuki');
	#	push @INC, 'C:/inetpub/cgi-bin/pyuki/lib/';
	#	push @INC, 'C:/inetpub/cgi-bin/pyuki/lib/CGI';
	#	push @INC, 'C:/inetpub/cgi-bin/pyuki/';
	#	$::_conv_start = (times)[0];
	#}


use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);


require 'lib/wiki.cgi';

__END__

=head1 NAME

index.cgi - This is PyukiWiki Wrapper

=head1 DESCRIPTION

This file is a wrapper program for starting wiki.

=head1 AUTHOR

=over 4

=item Nekyo

L<http://nekyo.qp.land.to/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2004-2011 by Nekyo.

Copyright (C) 2005-2011 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

=cut
