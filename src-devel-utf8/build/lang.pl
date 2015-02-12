# release file perl script for pyukiwiki
# $Id: lang.pl,v 1.327 2012/03/18 11:23:55 papu Exp $

$lang=$ARGV[0];
$src=$ARGV[1];
$dest=$src;
$dest=~s/lang/$lang/g;
#$dest=~s/\.src$//g;

if(open(R,$src)) {
	if(open(W,">$dest")) {
		foreach(<R>) {
			chomp;
			if(/\s*?#\s*?lang_/) {
				if(/\s*?#\s*?lang_$lang$/) {
					s/\s*?#\s*?lang_$lang$//g;
					print W "$_\n";
				}
			} else {
				print W "$_\n";
			}
		}
		close(W);
	} else {
		print STDERR "$dest can't write\n";
		exit(1);
	}
	close(R);
} else {
	print STDERR "$src can't read\n";
	exit(1);
}
exit(0);

