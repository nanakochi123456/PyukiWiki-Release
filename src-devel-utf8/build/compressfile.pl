#!/usr/bin/perl
# yuicompressor script
# $Id: compressfile.pl,v 1.251 2012/01/31 10:12:01 papu Exp $

$mode=$ARGV[0];
$output=$ARGV[1];
$input=$ARGV[2];
$nohead=$ARGV[3];
print "compress $input -> $output\n";
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
&shell("$compress{$mode} $input.tmp2 $input.tmp");
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
