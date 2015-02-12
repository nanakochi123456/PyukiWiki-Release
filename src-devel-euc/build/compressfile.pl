#!/usr/bin/perl
# yuicompressor script
# $Id: compressfile.pl,v 1.390 2012/03/18 11:23:49 papu Exp $

$mode=$ARGV[0];
$output=$ARGV[1];
$input=$ARGV[2];
$nohead=$ARGV[3];
print "compress $input -> $output\n";
$compress{js}="yuicompressor --type js --charset utf8 -o";
$compress{js21}="yuicompressor --type js --charset utf8 -o";
$compress{js22}="php ./build/example-file.php ";
$compress{css}="yuicompressor --type css --charset utf8 -o";
$convert{utf8}="perl ./build/Jcode-convert.pl utf8";
$convert{euc}="perl ./build/Jcode-convert.pl euc";

if($ARGV[3] eq '') {
	$top="/* \@\@PYUKIWIKIVERSION\@\@\n";
	$top.=" * \$Id\$\n";

	$top.=<<EOM
 *
 * SyntaxHighlighter3.0.83 (July 02 2010)
 * Copyright (C) 2004-2010 Alex Gorbatchev.
 * Dual licensed under the MIT and GPL licenses.
EOM
		if($output=~/syntaxhighlighter/);

	$top.=<<EOM
 *
 * Video.js - HTML5 Video Player
 * Version 3.0.7
 * This file is part of Video.js. Copyright 2011 Zencoder, Inc.
 * LGPL v3 LICENSE INFO
EOM
		if($output=~/video.js/);

	$top.=<<EOM
 *
 * Copyright 2009 Brandon Leonardo & Ryan McGrath
 * Released under an MIT style license
EOM
		if($output=~/twitter.js/);

	$top.=<<EOM
 *
 * jQuery JavaScript Library v1.7.1
 * Copyright 2011, John Resig
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * Includes Sizzle.js
 * Copyright 2011, The Dojo Foundation
 * Released under the MIT, BSD, and GPL Licenses.
EOM
		if($output=~/jquery.js/);

	$top.=<<EOM
 *
 * jqModal - Minimalist Modaling with jQuery
 * Copyright (c) 2007,2008 Brice Burgess
 * Dual licensed under the MIT and GPL licenses:
 *
 * Farbtastic Color Picker 1.2
 * (c)2008 Steven Wittens
 * License GPL2
EOM
		if($output=~/instag.js/ || $output=~/instag.css/);

	$top.=<<EOM
 *
 * flowplayer.js 3.2.6. The Flowplayer API
 * Copyright 2009-2011 Flowplayer Oy
 * License GPL3
EOM
		if($output=~/flowplayer/);

	$top.=" */\n\n";

#	$top="/* \@charset \"Shift_JIS\"; */\n/* If use japanese font, use @charset */\n"
#		. $top
#		if($mode eq "css");
}
open(R,"$input");
open(W,">$input.commentcut");
my $buf;
foreach(<R>) {
	$buf.= $_;
}
for(my $i=0; $i<=1; $i++) {
	$buf=~s/\/\*(.|\n)+?\*\///g;
}
for(my $i=0; $i<=1; $i++) {
$buf=~s/^\/\/(.+)\n/\n/g;
$buf=~s/\n\/\/(.+)\n/\n/g;
}
print W $buf;
close(W);
close(R);

&shell("$convert{utf8} $input.tmp $input.commentcut");
if($mode eq "js2") {
	&shell("$compress{js21} $input.tmp21 $input.tmp");
	&shell("$compress{js22} $input.tmp21 $input.tmp2");
} else {
	&shell("$compress{$mode} $input.tmp2 $input.tmp");
}
&shell("$convert{euc} $input.tmp $input.tmp2");

open(R,"$input.tmp");
open(W,">$output");
print W $top;
foreach(<R>) {
	print W $_;
}
close(W);
close(R);
unlink("$input.commentcut");
unlink("$input.tmp");
unlink("$input.tmp2");
unlink("$input.tmp21");

sub shell {
	my($shell)=@_;
	my $buf;
	print "$shell\n";
	open(PIPE,"$shell|");
	foreach(<PIPE>) {
		chomp;
		$buf.=$_;
	}
	close(PIPE);
	$buf;
}
