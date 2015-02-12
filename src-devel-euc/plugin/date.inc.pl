######################################################################
# date.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: date.inc.pl,v 1.74 2011/05/03 20:43:28 papu Exp $
#
# "PyukiWiki" version 0.1.9 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2011 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2011 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################

use strict;
use Time::Local;

sub plugin_date_convert {
	return &plugin_date_inline(@_);
}

sub plugin_date_inline {
	my ($format,$date) = split(/,/, shift);
	my ($y,$m,$d);

	$format=&htmlspecialchars($format);
	$date=&htmlspecialchars($date);

	if($format eq '') {
		return &date($::date_format);
	}
	$date=time if($date eq '');

	if($date=~/-/) {
		($y,$m,$d)=split(/\-/,$date);
		$date=Time::Local::timelocal(0,0,0,$d,$m-1,$y-1900);
	} elsif($date=~/\//) {
		($y,$m,$d)=split(/\//,$date);
		$date=Time::Local::timelocal(0,0,0,$d,$m-1,$y-1900);
	}
	return &date($format,$date);
}

1;
__END__

=head1 NAME

date.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &date;
 &date();
 &date(date_format, [yyyy/mm/dd]);

=head1 DESCRIPTION

Display the present or specified date in a specification format.

If it specifies like "&date;" without specifying '()', it will be automatically changed into the date at the time of writing, and will not perform as plugin.

When other, the present date or the specified date is displayed.

=head1 USAGE

=over 4

=item date_format

date_format is an internal function.   The form character string of date can be specified.

'(' and ')' cannot be used for date_format.

Please look at the following detailed samples.

=item yyyy/mm/dd

Specification date. It becomes a date on the day at the time of an abbreviation.

=back

=head1 SAMPLES

Date format samples

=over 4

=item &date(Y-n-j[D],2006/1/1)

2006-1-1[Sun]

=item &date(y/m/J,2006/1/1)

06/01/01

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/date

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/date/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/date.inc.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2011 by Nanami.

Copyright (C) 2005-2011 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
