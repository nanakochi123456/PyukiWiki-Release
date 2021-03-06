#
# $Id: NoXS.pm,v 1.491 2012/03/18 11:23:51 papu Exp $
# Id: NoXS.pm,v 2.0 2005/05/16 19:08:02 dankogai Exp
# "Jcode.pm" version 2.7 $$
#
package Jcode::Unicode::NoXS;
use strict;
use vars qw($RCSID $VERSION);
$RCSID = q$Id: NoXS.pm,v 1.491 2012/03/18 11:23:51 papu Exp $;
$VERSION = do { my @r = (q$Revision: 1.491 $ =~ /\d+/g); sprintf "%d."."%02d" x $#r, @r };
use Carp;
use Jcode::Constants qw(:all);
use Jcode::Unicode::Constants;
use vars qw(*_E2U *_U2E $PEDANTIC);
$PEDANTIC = 0;
# Quick and dirty import
*_E2U = *Jcode::Unicode::Constants::_E2U;
*_U2E = *Jcode::Unicode::Constants::_U2E;
sub _init_u2e{
    unless ($PEDANTIC){
	$_U2E{"\xff\x3c"} = "\xa1\xc0"; # ��
    }else{
	delete $_U2E{"\xff\x3c"};
	$_U2E{"\x00\x5c"} = "\xa1\xc0";     #\
	$_U2E{"\x00\x7e"} = "\x8f\xa2\xb7"; # ~
    }
}
sub _init_e2u{
    unless (%_E2U){
	%_E2U =
	    reverse %_U2E;
    }
    unless ($PEDANTIC){
	$_E2U{"\xa1\xc0"} = "\xff\x3c"; # ��
    }else{
	delete $_E2U{"\xa1\xc0"};
	$_E2U{"\xa1\xc0"} = "\x00\x5c";     #\
	$_E2U{"\x8f\xa2\xb7"} = "\x00\x7e"; # ~
    }
}
# Yuck! but this is necessary because this module is 'require'd
# instead of being 'use'd (No package export done) subs below
# belong to Jcode, not Jcode::Unicode
sub Jcode::ucs2_euc{
    my $thingy = shift;
    my $r_str = ref $thingy ? $thingy : \$thingy;
    _init_u2e();
    $$r_str =~ s(
		 ([\x00-\xff][\x00-\xff])
		 )
    {
	exists $_U2E{$1} ? $_U2E{$1} : $CHARCODE{UNDEF_JIS};
    }geox;
    $$r_str;
}
sub Jcode::euc_ucs2{
    my $thingy = shift;
    my $r_str = ref $thingy ? $thingy : \$thingy;
    _init_e2u();
    # 3 bytes
    $$r_str =~ s(
		 ($RE{EUC_0212}|$RE{EUC_C}|$RE{EUC_KANA}|[\x00-\xff])
		 )
    {
	exists $_E2U{$1} ? $_E2U{$1} : $CHARCODE{UNDEF_UNICODE};
    }geox;
    $$r_str;
}
sub Jcode::euc_utf8{
    my $thingy = shift;
    my $r_str = ref $thingy ? $thingy : \$thingy;
    &Jcode::euc_ucs2($r_str);
    &Jcode::ucs2_utf8($r_str);
}
sub Jcode::utf8_euc{
    my $thingy = shift;
    my $r_str = ref $thingy ? $thingy : \$thingy;
    &Jcode::utf8_ucs2($r_str);
    &Jcode::ucs2_euc($r_str);
}
sub Jcode::ucs2_utf8{
    my $thingy = shift;
    my $r_str = ref $thingy ? $thingy : \$thingy;
    my $result;
    for my $uc (unpack("n*", $$r_str)) {
        if ($uc < 0x80) {
            # 1 byte representation
            $result .= chr($uc);
        } elsif ($uc < 0x800) {
            # 2 byte representation
            $result .= chr(0xC0 | ($uc >> 6)) .
                chr(0x80 | ($uc & 0x3F));
        } else {
            # 3 byte representation
            $result .= chr(0xE0 | ($uc >> 12)) .
                chr(0x80 | (($uc >> 6) & 0x3F)) .
                    chr(0x80 | ($uc & 0x3F));
        }
    }
    $$r_str = $result;
}
sub Jcode::utf8_ucs2{
    my $thingy = shift;
    my $r_str = ref $thingy ? $thingy : \$thingy;
    my $result;
    $$r_str =~ s/^[\200-\277]+//o;  # can't start with 10xxxxxx
    $$r_str =~
	s[
	  ($RE{ASCII} | $RE{UTF8})
	  ]{
	      my $str = $1;
	      if (length($str) == 1){
		  pack("n", unpack("C", $str));
	      }elsif(length($str) == 2){
		  my ($c1,$c2) = unpack("C2", $str);
		  pack("n", (($c1 & 0x1F)<<6)|($c2 & 0x3F));
	      }else{
		  my ($c1,$c2,$c3) = unpack("C3", $str);
		  pack("n",
		       (($c1 & 0x0F)<<12)|(($c2 & 0x3F)<<6)|($c3 & 0x3F));
	      }
	  }egox;
    $$r_str;
}
1;
__END__
