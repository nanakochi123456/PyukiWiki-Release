#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id: getversion.pl,v 1.327 2012/03/18 11:23:55 papu Exp $

open(R,"lib/wiki.cgi");
foreach(<R>) {
	if(/^\$\:\:version/) {
		eval  $_ ;
	}
}
close(R);
print "$::version";

