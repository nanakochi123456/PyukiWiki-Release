#!/usr/bin/perl

$mode=$ARGV[0];
$output=$ARGV[1];
$input=$ARGV[2];

$compress{js}="yuicompressor --type js --charset euc-up -o";
$compress{css}="yuicompressor --type css --charset euc-up -o";

$top="// \@\@PYUKIWIKIVERSION\@\@\n// \$Id\$\n\n";
$top="// \@charset \"Shift_JIS\";\n// If use japanese font, use @charset\n"
	. $top
	if($mode eq "css");

&shell("$compress{$mode} tmp $input");

open(R,"tmp");
open(W,">$output");
print W $top;
foreach(<R>) {
	print W $_;
}
close(W);
close(R);
unlink("tmp");

sub shell {
	my($shell)=@_;
	my $buf;
	open(PIPE,"$shell|");
	foreach(<PIPE>) {
		chomp;
		$buf.=$_;
	}
	close(PIPE);
	$buf;
}
