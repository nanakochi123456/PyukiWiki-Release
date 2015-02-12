# yuicompressor scriopt
# $Id: compressfile.pl,v 1.228 2011/12/31 13:06:09 papu Exp $

#!/usr/bin/perl

$mode=$ARGV[0];
$output=$ARGV[1];
$input=$ARGV[2];
$nohead=$ARGV[3];
$compress{js}="yuicompressor --type js --charset utf8 -o";
$compress{css}="yuicompressor --type css --charset utf8 -o";
$convert{utf8}="perl ./build/Jcode-convert.pl utf8";
$convert{euc}="perl ./build/Jcode-convert.pl euc";

if($ARGV[3] eq '') {
	$top="/* \@\@PYUKIWIKIVERSION\@\@ */\n/* \$Id\$ */\n\n";
#	$top="/* \@charset \"Shift_JIS\"; */\n/* If use japanese font, use @charset */\n"
#		. $top
#		if($mode eq "css");
}
&shell("$convert{utf8} $input $input.tmp");
&shell("$compress{$mode} $input.tmp2 $input.tmp");
&shell("$convert{euc} $input.tmp2 $input.tmp");

open(R,"$input.tmp");
open(W,">$output");
print W $top;
foreach(<R>) {
	print W $_;
}
close(W);
close(R);
unlink("$input.tmp");
unlink("$input.tmp2");

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
