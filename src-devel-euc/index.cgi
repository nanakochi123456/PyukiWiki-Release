#!/usr/bin/perl
#!/usr/local/bin/perl --
#!c:/perl/bin/perl.exe
#!c:\perl\bin\perl.exe
#!c:\perl64\bin\perl.exe
######################################################################
# index.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: index.cgi,v 1.508 2012/03/18 11:23:49 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
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
# You MUST modify following initial file.
BEGIN {
	$::ini_file = "pyukiwiki.ini.cgi";
######################################################################
	$::_conv_start = (times)[0];

	$::ini_file = "pyukiwiki.ini.cgi" if($::ini_file eq "");
	require $::ini_file;
	require $::setup_file if (-r $::setup_file);

	push @INC, "$::sys_dir";
	push @INC, "$::sys_dir/CGI";
}

######################################################################
# If Windows NT Server, use sample it
#BEGIN {
#	chdir("C:/inetpub/cgi-bin/pyuki");
#	push @INC, "C:/inetpub/cgi-bin/pyuki/lib/";
#	push @INC, "C:/inetpub/cgi-bin/pyuki/lib/CGI";
#	push @INC, "C:/inetpub/cgi-bin/pyuki/";
#	$::_conv_start = (times)[0];
#}

require "$::sys_dir/wiki.cgi";

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

L<http://pyukiwiki.sfjp.jp/>

=back

=head1 LICENSE

Copyright (C) 2004-2012 by Nekyo.

Copyright (C) 2005-2012 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

=cut
