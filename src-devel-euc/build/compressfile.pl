# yuicompressor scriopt
# $Id$

#!/usr/bin/perl

$mode=$ARGV[0];
$output=$ARGV[1];
$input=$ARGV[2];

$compress{js}="yuicompressor --type js --charset utf8 -o";
$compress{css}="yuicompressor --type css --charset utf8 -o";
$convert{utf8}="./build/Jcode-convert.pl utf8";
$convert{euc}="./build/Jcode-convert.pl euc";

$top="/* \@\@PYUKIWIKIVERSION\@\@ */\n/* \$Id\$ */\n\n";
$top="/* \@charset \"Shift_JIS\"; */\n/* If use japanese font, use @charset */\n"
	. $top
	if($mode eq "css");

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
