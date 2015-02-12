######################################################################
# twitter.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: twitter.inc.pl,v 1.4 2011/05/04 07:26:50 papu Exp $
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
# can't use Nana::HTTP's inline module, please install LWP::UserAgent
# (now twitter or IE9 bug)
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

use Nana::HTTP;

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
<div class="twitstatus_badge_container" id="twitstat_badge\_$::plugin_twitter_count"></div>
<script type="text/javascript" src="$::skin_url/twitter.js"></script>
<script type="text/javascript"><!--
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
	my $http=new Nana::HTTP('plugin'=>"showrss");
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
