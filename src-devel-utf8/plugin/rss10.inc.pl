######################################################################
# rss10.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: rss10.inc.pl,v 1.171 2011/12/31 13:06:14 papu Exp $
#
# "PyukiWiki" version 0.2.0 $$
# Author: Nekyo
# Copyright (C) 2004-2012 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2012 PyukiWiki Developers Team
# http://pyukiwiki.sfjp.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sfjp.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################
# v0.1.7 2006/05/19 RSSタイトルが化けるのを修正
# v0.1.6 2006/01/07 include Yuki::RSS, 半角スペースのページに対応
# v0.0.2 2005/03/11 Add dc:date
######################################################################

use Yuki::RSS;

sub plugin_rss10_action {
	# 言語別の設定										# comment
	if($::_exec_plugined{lang} > 1) {
		$::modifier_rss_title=$::modifier_rss_title{$::lang} if($::modifier_rss_title{$::lang} ne '');
		$::modifier_rss_link=$::modifier_rss_link{$::lang} ne '' ? $::modifier_rss_link{$::lang}: $::modifier_rss_link ne '' ? $::modifier_rss_link : $::basehref;
		$::modifier_rss_description=$::modifier_rss_description{$::lang} if($::modifier_rss_description{$::lang} ne '');
	} else {
		$::modifier_rss_link=$::modifier_rss_link ne '' ? $::modifier_rss_link : $::basehref;
	}

	my $rss = new Yuki::RSS(
		version => '1.0',
		encoding => $::charset,
	);
	$rss->channel(
		title => $::modifier_rss_title
				. ($::_exec_plugined{lang} > 1 ? "(" . (split(/,/,$::langlist{$::lang}))[0] . ")" : ""),
		link  => $::modifier_rss_link,
		description => $::modifier_rss_description,
	);
	my $recentchanges = $::database{$::RecentChanges};
	my $count = 0;
	foreach (split(/\n/, $recentchanges)) {
		last if ($count >= $::rss_lines);
		# v0.1.6
		/^\- (\d\d\d\d\-\d\d\-\d\d) \(...\) (\d\d:\d\d:\d\d) (.*?)\ \ \-/;    # data format.
		my $title = &unarmor_name($3);
		my $escaped_title = &escape($title);
		my $link = $modifier_rss_link . '?' . &encode($title);
		my $description;
		if($::rss_description_line <= 1) {
			$description = $escaped_title . &escape(&get_subjectline($title));
		} else {
			my $tmp=&get_subjectline($title,$::rss_description_line);
			$tmp=~s/\n/<br \/>\n/g;
			$description = qq(<![CDATA[) .$tmp . qq(]]>);
		}
		$gmt = ((localtime(time))[2] + (localtime(time))[3] * 24)
			- ((gmtime(time))[2] + (gmtime(time))[3] * 24);
		my $date = $1 . "T" . $2 . sprintf("+%02d:00", $gmt);

		if(&is_readable($title) && $title!~/$::non_list/) {
			$rss->add_item(
				title => $escaped_title,
				link  => $link,
				description => $description,
				dc_date => $date
			);
			$count++;
		}
	}
	# print RSS information (as XML).						# comment
	my $body=$rss->as_string;
	if($::lang eq 'ja' && $::defaultcode ne $::kanjicode) {
		$body=&code_convert(\$body,   $::kanjicode);
	}
	&gzip_init;
	if($::gzip_header ne '') {
		print &http_header(
			"Content-type: text/xml; charset=$::charset", $::gzip_header);
	} else {
		print &http_header(
			"Content-type: text/xml; charset=$::charset");
	}
	&compress_output($body);
	&close_db;
	exit;
}
1;
__END__
=head1 NAME

rss10.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=rss10[&lang=lang]

=head1 DESCRIPTION

Output RSS (RDF Site Summary) 1.0 from RecentChanges

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/rss10

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/rss10/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/rss10.inc.pl?view=log>

=item YukiWiki

using Yuki::RSS.

L<http://www.hyuki.com/yukiwiki/>

=back

=head1 AUTHOR

=item Nekyo

L<http://nekyo.qp.land.to/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sfjp.jp/>

=head1 LICENSE

Copyright (C) 2004-2012 by Nekyo.

Copyright (C) 2005-2012 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut