######################################################################
# twitter.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: twitter.inc.pl,v 1.417 2012/03/18 11:23:51 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2012 Nekyo
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2012 PyukiWiki Developers Team
# http://pyukiwiki.sfjp.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sfjp.jp/
# License: GPL3 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# usage: #twitter(username or #hashtag[, header name)
# visit http://twitstat.us/
# thanks to #jishin_power project
# can't use Nana::HTTP's inline module, please install LWP::UserAgent
# (now twitter or IE9 bug)
######################################################################

$twitter::title="twitter of $1"
	if(!defined($twitter::title));

$twitter::max=7
	if(!defined($twitter::max));

$twitter::border_color="#434343"
	if(!defined($twitter::border_color));

$twitter::header_background="#434343"
	if(!defined($twitter::header_background));

$twitter::header_font_color="#ffffff"
	if(!defined($twitter::header_font_color));

$twitter::content_background_color="#e1e1e1"
	if(!defined($twitter::content_background_color));

$twitter::content_font_color="#333333"
	if(!defined($twitter::content_font_color));

$twitter::link_color="#307ace"
	if(!defined($twitter::link_color));

$twitter::width="600"
	if(!defined($twitter::width));

######################################################################

use Nana::HTTP;

$::plugin_twitter_count=0;

sub plugin_twitter_convert {
	my $arg=shift;
	my ($keywords,$title)=split(/,/,$arg);
	if($title eq '') {
		$title=$twitter::title;
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
<div class="twitstatus_badge_container" id="twitstat_badge\_$::plugin_twitter_count"></div>
<script type="text/javascript" src="$::skin_url/twitter.js"></script>
<script type="text/javascript"><!--
twitstat.badge.init({
	badge_container: "twitstat_badge_$::plugin_twitter_count",
	title: "$title",
	keywords: "$keywords",
	max: $twitter::max,
	border_color: "$twitter::border_color",
	header_background: "$twitter::header_background",
	header_font_color: "$twitter::header_font_color",
	content_background_color: "$twitter::content_background_color",
	content_font_color: "$twitter::content_font_color",
	link_color: "$twitter::link_color",
	width: $twitter::width,
	popup: $popup_allow
});
//--></script>
</div>
EOM
}

sub plugin_twitter_action {
	my $env;
	foreach(keys %::form) {
		if($_ eq "rpp" || $_ eq "callback" || $_ eq "q" || $_ eq "near" || $_ eq "within" || $_ eq "units" || $_ eq "since_id") {
			if($_ eq "q") {
				$env.="$_=@{[&encode($::form{$_})]}&";
			} else {
				$env.="$_=$::form{$_}&";
			}
		}
	}
	$env=~s/\&$//g;
	my $http=new Nana::HTTP('plugin'=>"twitter");
	my $searchurl="http://search.twitter.com/search.json";

	my $uri="$searchurl?$env";
	my ($result, $stream) = $http->get($uri);
	if($result eq 0) {
		print &http_header("Content-type: application/json");
		print $stream;
	} else {
		print &http_header("Content-type: text/plain");
		print "Cant get '$uri'\n";
	}
	exit;
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

install LWP::UserAgent (not recomanded)

#twitter(username or #hashtag[, headername]

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/twitter

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/twitter/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/twitter.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/twitter.inc.pl?view=log>

=item twitstat.us

L<http://twitstat.us/>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sfjp.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2012 by Nanami.

Copyright (C) 2005-2012 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
