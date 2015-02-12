#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id: getversion.pl,v 1.300 2012/03/01 10:39:24 papu Exp $

open(R,"lib/wiki.cgi");
foreach(<R>) {
	if(/^\$\:\:version/) {
		eval  $_ ;
	}
}
close(R);
print "$::version";

