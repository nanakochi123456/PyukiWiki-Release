#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id: Jcode-convert.pl,v 1.336 2012/01/31 10:11:53 papu Exp $

use Jcode;

$code=$ARGV[0];
$src=$ARGV[2];
$dest=$ARGV[1];

if(open(R,$src)) {
	foreach(<R>) {
		$buf.="$_";
	}
	close(R);
	&Jcode::convert($buf, $code);
	if(open(W,">$dest")) {
		print W $buf;
		close(W);
	} else {
		die "$dest can't write";
	}
} else {
	die "$src can't read";
}
