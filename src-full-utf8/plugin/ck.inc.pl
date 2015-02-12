######################################################################
# ck.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: ck.inc.pl,v 1.255 2012/01/31 10:12:03 papu Exp $
#
# "PyukiWiki" version 0.2.0-p1 $$
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
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################
# for linktrack.inc.cgi, logs.ini.cgi
######################################################################
use strict;
require "plugin/counter.inc.pl";
sub plugin_ck_action {
	my $lk=$::form{l};
	my $r=$::form{r};
	my $p=$::form{p};
	my $test=$lk;
	$test=~s/[0-9A-Z]?//g;
	if($test eq '') {
		my $url=&undbmname($lk);
		if($r eq "y") {
			print &http_header("Status: 204\n\n");
		} else {
			print &http_header("Status: 302","Location: $url\n\n");
		}
		&plugin_counter_do("link\_$url","w");
		if($::_exec_plugined{logs}>1) {
			my $cmd="ck";
			my $page=&code_convert(\$::form{p}, $::defaultcode);
			my $link=&undbmname($::form{l});
			$page="$page<>$link";
			my $filename=&date("Y-m-d");
			&getremotehost;
			my $user=$::authadmin_cookie_user_name;
			my $logtxt=<<EOM;
$ENV{REMOTE_HOST} $ENV{REMOTE_ADDR}\t@{[&date($logs::date_format)]} @{[&date($logs::time_format)]}\t$user\t$ENV{REQUEST_METHOD}\t$cmd\t$::lang\t$page\t$ENV{HTTP_USER_AGENT}\t$ENV{HTTP_REFERER}
EOM
			&plugin_logs_add($filename, $logtxt);
		}
		exit;
	}
	print <<EOM;
Content-type: text/plain
Forbidden
EOM
exit;
}
1;
__END__
