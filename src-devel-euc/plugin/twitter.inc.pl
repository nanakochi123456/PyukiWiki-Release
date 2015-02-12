######################################################################
# twitter.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: twitter.inc.pl,v 1.1 2011/05/03 20:43:28 papu Exp $
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
# usage: #twitter(username or #hashtag[, header name)
# visit http://twitstat.us/
# thanks to #jishin_power project
######################################################################

$plugin_twitter_title="twitter of $1";
$plugin_twitter_max=7;
$plugin_twitter_border_color="#434343";
$plugin_twitter_header_background="#434343";
$plugin_twitter_header_font_color="#ffffff";
$plugin_twitter_content_background_color="#e1e1e1";
$plugin_twitter_content_font_color="#333333";
$plugin_twitter_link_color="#307ace";
$plugin_twitter_width="600";

#--------------

$::plugin_twitter_count=0;

sub plugin_twitter_convert {
	my $arg=shift;
	my ($keywords,$title)=split(/,/,$arg);
	if($title eq '') {
		$title=$plugin_twitter_title;
		$title=~s/\$1/$keywords/g;
	}

	my $flag=$::use_popup if($flag eq '');
	my $popup_allow=$::setting_cookie{popup} ne '' ? $::setting_cookie{popup}
					: $flag+0 ? 1 : 0;
	if($::plugin_twitter_count ne 0) {
		return <<EOM;
<div class="error">Can't insert more twitter plugin of this page</div>
EOM
	}
	$::plugin_twitter_count++;
	return <<EOM;
<div id="twitter">
<div class="twitstatus_badge_container" id="twitstat_badge_$::plugin_twitter_count"></div>
<script type="text/javascript" src="$::skin_url/twitter.js"></script>
<script type="text/javascript"> 
twitstat.badge.init({
	badge_container: "twitstat_badge_$::plugin_twitter_count",
	title: "$title",
	keywords: "$keywords",
	max: $plugin_twitter_max,
	border_color: "$plugin_twitter_border_color",
	header_background: "$plugin_twitter_header_background",
	header_font_color: "$plugin_twitter_header_font_color",
	content_background_color: "$plugin_twitter_content_background_color",
	content_font_color: "$plugin_twitter_content_font_color",
	link_color: "$plugin_twitter_link_color",
	width: $plugin_twitter_width,
	popup: $popup_allow
});
</script>
</div>
EOM
}

1;
__END__
=head1 NAME

twitter.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=twitter

=head1 DESCRIPTION

Display twitter username of twite of twitter of #hashtag


=head1 USAGE

#twitter(username or #hashtag[, headername]

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/twitter

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/twitter/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/twitter.inc.pl?view=log>

=item twitstat.us

L<http://twitstat.us/>

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
