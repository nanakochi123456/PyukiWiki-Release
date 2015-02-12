######################################################################
# powerusage.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: powerusage.inc.pl,v 1.24 2012/01/31 10:11:58 papu Exp $
#
# "powerusage" version 1.0 $$
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
# Return:LF Code=Shift-JIS 1TAB=4Spaces
######################################################################
# ‚Å‚«A‚ ‚Ü‚è‚æ‚­‚È‚¢‚Å‚·B—Ü
######################################################################

$PLUGIN="powerusage";
$VERSION="1.0";

# base from http://denkiyohou.daiba.cx/

my $powerusage_url="http://denkiyohou.daiba.cx/?allcompany";
my $powerusage_menubar_url="http://denkiyohou.daiba.cx/?gadget_body";

use Nana::HTTP;
use Jcode;
sub plugin_powerusage_convert {
	my($mode)=@_;
	my $http=new Nana::HTTP('plugin'=>"powerusage");
	my $result, $stream;
	if($mode ne "menubar") {
		($result, $stream) = $http->get($powerusage_url);
	} else {
	}
	my $body=' ';
	my $out;
	if($mode eq "menubar") {
		&getbasehref;
		$out=<<EOM;
<iframe src="$basehref/$::script?cmd=powerusage" height="270" width="128" border="0"  marginheight="0" marginwidth="0" framespacing="0" frameborder="0" noresize="noresize" scrolling="no"></iframe>
EOM
	} elsif($result eq 0) {
		$body=Jcode->new($stream)->utf8;
		my $crlfcnt=0;
		foreach(split(/\n/,$body)) {
			$out.="$_";
			if($crlfcnt eq 0) {
				$crlfcnt=1;
			} else {
				$crlfcnt=0;
				$out.="<br />";
			}
		}
	}
	return $out;
}

sub plugin_powerusage_action {
	my $baseurl = "http://denkiyohou.daiba.cx/";
	my $file=$::form{f};
	my $url;
	my $mine="text/html";
	if($file eq "gadget_css") {
		$url=$baseurl . "?gadget_css2";
		$mine="text/css";
	} elsif($file eq "gadget_js") {
		$url=$baseurl . "?gadget_js";
		$mine="application/javascript";
	} elsif($file ne '') {
		$url=$baseurl . "?" .  $file;
		$mine="text/plain";
	} else {
		print &http_header("Content-type: text/html\nCache-Control: max-age=0\nExpires: Mon, 26, Jul 1997 05:00:00 GMT");
		print <<EOM;
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="$::lang">
<head>
<meta http-equiv="Content-Language" content="$::lang">
<meta http-equiv="Content-Type" content="text/html; charset=$::charset">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<title>powerusage</title>
<link rel="stylesheet" type="text/css" href="$::script?cmd=powerusage&amp;f=gadget_css" />
<script type="text/javascript" src="$::script?cmd=powerusage&amp;f=gadget_js"></script>
</head>
<body onload="init()">
<span id="body"></span>
</body>
</html>
EOM
		exit;
	}

	my $http=new Nana::HTTP('plugin'=>"powerusage");
	my ($result, $stream) = $http->get($url);

	if($result eq 0) {
		print &http_header("Content-type: $mine\nCache-Control: max-age=0\nExpires: Mon, 26, Jul 1997 05:00:00 GMT");
		if($file eq "gadget_js") {
			&getbasehref;
			$stream=~s/http\:\/\/denkiyohou\.daiba\.cx\//$basehref/g;
			$stream=~s/\?gadget\_/\?cmd=\powerusage\&amp\;f\=gadget_/g;
		}
		$stream=~s/<!--(.+?)-->//g;
		$stream=~s/ border="0"//g;
		print $stream;
	} else {
		print &http_header("Content-type: text/plain");
#		print "Cant get '$url'\n";
	}
	exit;
}

1;
