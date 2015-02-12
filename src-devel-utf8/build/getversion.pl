#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id: getversion.pl,v 1.249 2012/01/31 10:12:01 papu Exp $

open(R,"lib/wiki.cgi");
foreach(<R>) {
	if(/^\$\:\:version/) {
		eval  $_ ;
	}
}
close(R);
print "$::version";

