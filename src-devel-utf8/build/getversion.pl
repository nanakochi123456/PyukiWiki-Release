#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id: getversion.pl,v 1.169 2011/12/31 13:06:13 papu Exp $

open(R,"lib/wiki.cgi");
foreach(<R>) {
	if(/^\$\:\:version/) {
		eval  $_ ;
	}
}
close(R);
print "$::version";

