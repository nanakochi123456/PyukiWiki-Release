#!/usr/bin/perl
######################################################################
# v.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: v.cgi,v 1.5 2012/01/31 10:12:00 papu Exp $
#
# "playvideo" version 2.1 $$
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
# 2011/10/07 change: 複数のサイトに動画が分散していても対応できるようにした。
#                    ただし、wmvだけはPyukiWikiと同じサイトに設置しなければ
#                    いけませんが、mp4やflvも別サイトに設置することが
#                    できるようになった。
#                    このバージョンにするには、deletecache をする必要があり、
#                    かつ、FLV、MP4ファイルを消去した場合、もう一度 deletecache
#                    をする必要があります。
#                    無圧縮zip以外にも、生のWMVファイルをダウンロードできる
#                    ようにした。（デフォルトは無圧縮zip）
# 2011/10/05 change: HEADリクエストを用いて、WMV以外の拡張子の動画を
#                    PyukiWikiが設置してあるサーバー以外に設定できるように
#                    した。また、IE 9 において、video.jsを無効化した。
# 2011/10/02 change: HTML5プレイヤーに対応、その為、HTML5ブラウザーでなく
#                    Flashで再生する場合に、別途MP4ファイルが必要になる。
#                    その時の変換フォーマットは、FlowPlayerが認識するように
#                    MPEG4 AVC/H.264形式で変換しなければならない。
#                    旧来のFlashでの再生もサポートしていますが、IE10の
#                    デスクトップ版以外でサポートされなくなるため、互換性の為に
#                    準備だけはしてあります。
#                    IE9の不具合で、IE9においては、HTML5プレイヤーは使用
#                    できないようになっています。
# 2011/09/11 change: デフォルトのスキンを読み込めるようにした。
#                    FireFoxでキー操作により動画のリロードするのを阻止した。
#                    設定してある漢字コードで出力できるようにした。
# 2011/06/12 change: flv動画にも対応した。ただし、wmvも必要です。
# 2011/05/26 change: wmvにタグが付けられている場合、zipファイルのダウンロード
#                    ファイル名をその名前に指定できるようにした。
# 2011/05/26 change: info/setup.cgiに対応した
# 2011/03/14 change: Content-disposition: attachment; filename="$file.wvx"
#                    を出力すると問題がある可能性があるため、出力を
#                    抑制した。
# 2011/03/01 change: 拡張子をwvxに変更した。
#                    Content-Type: video/x-ms-wvx を出力した。
#                    Content-disposition: attachment; filename="$file.wvx"
#                    を出力した。
# 2010/12/10 change: ニコニコ動画に対応した
# 2010/11/13 change: 無圧縮zipでダウンロードできるようにした。
#                    大量の動画があるときキャッシュから取得するように
#                    した。ただし、有効期限は１時間です。
# 2010/10/27 change: MSIE とOpera以外はWindwos Mediaプレイヤー
#                    再生時に_blank(実質別タブ）になるようにした。
#                    Safariでは本当に別窓になります。
# 2010/10/24 change: use sub make_link_target
######################################################################

$PLUGIN="playvideo";
$VERSION="2.1";

BEGIN {
	push @INC, 'lib';
	unshift @INC, 'lib';
}

use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);

#$::defaultcode="utf8";

%::functions = (
	"load_module" => \&load_module,
);

require "pyukiwiki.ini.cgi";
require $::setup_file if (-r $::setup_file);	# for feature
require "plugin/counter.inc.pl";
require "plugin/playvideo.inc.pl";
$::counter_ext = '.count';
$::info_dir="./info";
use Nana::Cache;
use Nana::HTTP;
use Image::ExifTool;

#use LWP::UserAgent;

$::zip_cmds=$::playvideo_plugin_zipcmds;
$::zip_opts=$::playvideo_plugin_zipflags;
$::zip_tmp=$::playvideo_plugin_ziptmp;

# from http://html5-css3.jp/useful/css3-html5.html

@HTML5_VIDEO_TARGETS_MP4=(
#	"Safari Version 4",	# 対応しているはずだが・・・
	"MSIE 9",	# IE9でも再生できるが、video.jsのバグの可能性があります。
);

@HTML5_VIDEO_TARGETS_OGV=(
	"Fire[Ff]ox 4",
	"Opera Version 11",
	"Chrome 1",	# chrome をwebmにしたのは、次期他のコーディックをサポート終了する可能性があるため。
);

@HTML5_VIDEO_TARGETS_WEBM=(
	"Chrome 1",	# chrome をwebmにしたのは、次期他のコーディックをサポート終了する可能性があるため。
#	"Safari Version 4",	# 対応しているはずだが・・・
	"MSIE 9",	# 以下、googleによるサポート
	"Fire[Ff]ox 4",
	"Opera Version 11",
);

$v_css=qq(*,img,body,td,div{background-color:#000;color:#fff;margin:0;padding:0});
$v_html5_js=qq(window.focus();flowplayer("player","$basehref$::skin_url/flowplayer-3.2.7.swf",{clip:{url:"$flvpath",autoPlay:true,autoBuffering:true,scaling:"fit"},canvas:{backgroundColor:"#000000",backgroundGradient:"none"},plugins:{controls:{height:24,play:true,stop:true,volume:true,mute:true,time:true,fullscreen:true,volumeSliderColor:"#000000",tooltipColor:"#5F747C",progressColor:"#112233",bufferColor:"#445566",buttonColor:"#5F747C",sliderColor:"#000000",backgroundGradient:"high",durationColor:"#ffffff",backgroundColor:"#222222",progressGradient:"medium",borderRadius:"0",buttonOverColor:"#728B94",bufferGradient:"none",timeBgColor:"#555555",sliderGradient:"none",volumeSliderGradient:"none",tooltipTextColor:"#ffffff",timeColor:"#01DAFF"}}}););
$v_flash_js=qq(window.focus();VideoJS.setupAllWhenReady();VideoJS.DOMReady(function(){var a=VideoJS.setup("playvideo");var b=VideoJS.setup("All");a.play()});VideoJS.setupAllWhenReady({controlsBelow:false,controlsHiding:true,defaultVolume:0.85,flashVersion:9,linksHiding:true}););

&main;

sub main {
	$query=new CGI;

	foreach my $i (0x00 .. 0xFF) {
		$::_urlescape{chr($i)} = sprintf('%%%02x', $i);
		$::_dbmname_encode{chr($i)} = sprintf('%02X', $i);
	}

	$ENV{PATH_INFO}=~s/^\///g;
	$file=$ENV{PATH_INFO};
	$file=~s/\..*//g;
	$ext=$ENV{PATH_INFO};
	$ext=~s/.*\.//g;

	$videopath=$::playvideo_plugin_videopath;
	$videourl=$::playvideo_plugin_videourl;

	my $exifTool = new Image::ExifTool;
	my $info = $exifTool->ImageInfo("$videopath/$file.$wmv");

	$title=&code_convert(\$$info{Title}, 'sjis');
	$author=&code_convert(\$$info{Author}, 'sjis');
	$copyright=&code_convert(\$$info{Copyright}, 'sjis');

	if($ext eq "asx" || $ext eq "wmx" || $ext eq "wvx") {
		&plugin_counter_do("playvideo_$file","w");
		print <<EOM;
Content-Type: video/x-ms-wvx; charset=Shift_JIS

<asx version="3.0">
<entry>
<title>$$info{Title}</title>
<author>$$info{Author}</author>
<copyright>$$info{Copyright}</copyright>
<ref href="$videourl/$file.$wmv" />
</entry>
</asx>
EOM
	} elsif($ext eq "zip" && $::playvideo_plugin_usedownload eq 1) {
		&plugin_counter_do("playvideo_$file","w");
		foreach $cmd (split(/\n/,$::zip_cmds)) {
			if (-x $cmd) {
				$fname="$zip_tmp/$file.$wmv-$ENV{REMOTE_ADDR}.zip";
				# 簡易ロック
				do {
					sleep 1;
				} if (-r $fname);

				chdir($videopath);
				if(open(PIPE,"$cmd $zip_opts $fname $file.$wmv |")) {
					@TMP=<PIPE>;
					close(PIPE);
					$size = -s $fname;
					if(open(R, $fname)) {
						my $downloadfile="$file.zip";
						if($::playvideo_plugin_downloadfilename_inwmv) {
							my $in_author;

							if($::playvideo_plugin_downloadfilename_inwmv_withauthor) {
								$in_author=" ($author)" if($author ne '');
							}
							if($title ne '') {
								$downloadfile="$title$in_author.zip";
							}
						}
						$::defaultcode='sjis';
						($charset,$downloadfile)=&dlfileconvert($downloadfile);
						print $query->header(
							-type=>"application/zip; charset=$charset",
							-Content_disposition=>"attachment; $downloadfile",
							-Content_length=>$size,
							-expires=>"now",
							-P3P=>""
						);

						binmode	R;
						binmode STDOUT;
						print <R>;
						close(R);
						unlink($fname);
						exit;
					} else {
						unlink($fname);
						&err("Can't create zip file. sorry.");
						exit;
					}
				} else {
					unlink($fname);
					&err("Can't create pipe. sorry.");#
					exit;
				}
				exit;
			}
		}
		&err("Not found zip command.");
		exit;
	} elsif($ext eq "dl" && $::playvideo_plugin_usedownload eq 1) {
		$size = -s "$videopath/$file.$wmv";
		my $downloadfile="$file.$wmv";
		if($::playvideo_plugin_downloadfilename_inwmv) {
			my $in_author;

			if($::playvideo_plugin_downloadfilename_inwmv_withauthor) {
				$in_author=" ($author)" if($author ne '');
			}
			if($title ne '') {
				$downloadfile="$title$in_author.$wmv";
			}
		}

		($charset,$downloadfile)=&dlfileconvert($downloadfile);
		print $query->header(
			-type=>"application/zip; charset=$charset",
			-Content_disposition=>"attachment; $downloadfile",
			-Content_length=>$size,
			-expires=>"now",
			-P3P=>""
		);

		if(open(R, "$videopath/$file.$wmv")) {
			binmode	R;
			binmode STDOUT;
			print <R>;
			close(R);
			exit;
		} else {
			&err("Can't open download file. sorry.");
			exit;
		}
	} elsif($ext eq $flv || $ext eq $vhtml) {
			if(lc $::charset eq 'utf-8') {
				$::kanjicode='utf8';
			} else {
				$::charset=(
					$::kanjicode eq 'euc' ? 'EUC-JP' :
					$::kanjicode eq 'utf8' ? 'UTF-8' :
					$::kanjicode eq 'sjis' ? 'Shift-JIS' :
					$::kanjicode eq 'jis' ? 'iso-2022-jp' : '')
			}
		}

		&getbasehref if($::skin_url!~/^https?\:\/\//);
		&skin_init;
		if(-r "$::explugin_dir/setting.inc.cgi") {
			require "$::explugin_dir/setting.inc.cgi";
			my %ret=&plugin_setting_init;
		}
		&plugin_counter_do("playvideo_$file","w");
		$title=&code_convert(\$$info{Title}, $::defaultcode);
		$author=&code_convert(\$$info{Author}, $::defaultcode);
		$copyright=&code_convert(\$$info{Copyright}, $::defaultcode);
		$title=$file if($title eq '');
		$width=$$info{ImageWidth} . "px";
		$height=$$info{ImageHeight} . "px";
		my $iecompatible;
		if(-r "$::explugin_dir/iecompatiblehack.inc.cgi") {
			require "$::explugin_dir/iecompatiblehack.inc.cgi";
			my %ret=&plugin_iecompatiblehack_init;
			if($ret{'http_header'} ne '') {
				$iecompatible=$ret{'http_header'};
				$iecompatible=~s/\n//g;
				$iecompatible="\n$iecompatible";
			}
		}
		$csscharset=qq( charset="$::charset");


		$flvpath=&checkurl($file,$flv,$videopath,$videourl,%::playvideo_plugin_videourl);
		$flvpath=&checkurl($file,$mp4,$videopath,$videourl,%::playvideo_plugin_videourl)
			if($flvpath eq '');

		if($ext eq $vhtml) {
			$html5videotag=&html5video($file,$videopath,$videourl,%::playvideo_plugin_videourl);
			if($html5videotag ne "") {
				$body=<<EOM;
Content-Type: text/html; charset=$::charset$iecompatible

<!DOCTYPE html>
<html lang="$::lang">
<head>
<link rel="stylesheet" href="$basehref$::skin_url/$::skin{default_css}" type="text/css" media="screen"$csscharset />
<link rel="stylesheet" href="$basehref$::skin_url/$::skin{print_css}" type="text/css" media="print"$csscharset />
<link rel="stylesheet" href="$basehref$::skin_url/video-js.css" type="text/css" media="screen" title="Video JS"$csscharset />
<title>$title</title>
<style type="text/css"><!--
$v_css
//--></style>
<title>$title</title>
<script src="$basehref$::skin_url/video.js" type="text/javascript"$csscharset></script>
<script type="text/javascript"><!--
$v_html5_js
//--></script>
</head>
<body oncontextmenu="return false">
<div class="video-js-box" id="player">
<video id="playvideo" class="video-js" width="$$info{ImageWidth}" height="$$info{ImageHeight}" controls="controls" preload="auto" autoplay="autoplay">
$html5videotag
</video>
</div>
EOM
			} else {
				$body.=<<EOM;
Content-Type: text/html; charset=$::charset$iecompatible

<!DOCTYPE html>
<html lang="$::lang">
<head>
<link rel="stylesheet" href="$basehref$::skin_url/$::skin{default_css}" type="text/css" media="screen"$csscharset />
<link rel="stylesheet" href="$basehref$::skin_url/$::skin{print_css}" type="text/css" media="print"$csscharset />
<link rel="stylesheet" href="$basehref$::skin_url/video-js.css" type="text/css" media="screen" title="Video JS"$csscharset />
<title>$title</title>
<style type="text/css"><!--
$v_css
//--></style>
<title>$title</title>
<script type="text/javascript" src="$basehref$::skin_url/flowplayer-3.2.6.min.js"></script>
</head>
<body oncontextmenu="return false">
<div style="width:$width;height:$height" id="player"></div>
<script><!--
$v_flash_js
//--></script>
</div>
EOM
			}
		} else {
			$body.=<<EOM
Content-Type: text/html; charset=$::charset$iecompatible

<?xml version="1.0" encoding="$::charset" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="$::lang">
<head>
<link rel="stylesheet" href="$basehref$::skin_url/$::skin{default_css}" type="text/css" media="screen"$csscharset />
<link rel="stylesheet" href="$basehref$::skin_url/$::skin{print_css}" type="text/css" media="print"$csscharset />
<title>$title</title>
<script type="text/javascript" src="$basehref$::skin_url/flowplayer-3.2.6.min.js"></script>
<style type="text/css"><!--
$v_css
//--></style>
<title>$title</title>
</head>
<body oncontextmenu="return false">
<div id="page">
<div style="width:$width;height:$height" id="player"></div>
<script type="text/javascript"><!--
$v_flash_js
//--></script>
EOM
		}
		if($author ne '' && $copyright ne '') {
			$body.=<<EOM;
<table width="100%"><tr><td>作成者：$author&nbsp;著作権：$copyright</td>
<td align="right"><form action="#"><input type="button" value="閉じる" onclick="self.close();"></form></td></tr></table>
EOM
		} elsif($author ne '' && $copyright eq '') {
			$body.=<<EOM;
<table width="100%"><tr><td>作成者：$author</td>
<td align="right"><form action="#"><input type="button" value="閉じる" onclick="self.close();"></form></td></tr></table>
EOM
		} elsif($author eq '' && $copyright ne '') {
			$body.=<<EOM;
<table width="100%"><tr><td>著作権：$copyright</td>
<td align="right"><form action="#"><input type="button" value="閉じる" onclick="self.close();"></form></td></tr></table>
EOM
		} else {
			$body.=<<EOM;
<p align="right"><form action="#"><input type="button" value="閉じる" onclick="self.close();"></form></p>
EOM
		}
		$body.=<<EOM;
</div></body></html>
EOM

		print &code_convert(\$body, $::kanjicode);

	} elsif($ext=~/^sm(\d+)/) {
		&plugin_counter_do("playvideo_$file","w");
		print <<EOM;
Location: http://www.nicovideo.jp/watch/$ext

EOM
	} else {
		&plugin_counter_do("playvideo_$file","w");
		print <<EOM;
Location: http://www.youtube.com/watch?v=$ext

EOM
	}
}

sub dlfileconvert {
	my ($downloadfile)=shift;
	$::defaultcode='sjis';

	if($downloadfile=~/[\x81-\xfe]/) {
		if($ENV{HTTP_USER_AGENT} =~/Chrome/) {
			$downloadfile=&code_convert(\$downloadfile,"utf8");
			$downloadfile=qq(filename="$downloadfile");
			$downloadfile=~s/%2e/\./g;
			$charset="utf-8";
		} elsif($ENV{HTTP_USER_AGENT}=~/MSIE/) {
			$downloadfile=qq{filename="} . &code_convert(\$downloadfile,"sjis") . qq{"};
			$charset="Shift-JIS";
		} else {
			$downloadfile=&code_convert(\$downloadfile,"utf8");
			$downloadfile=qq(filename="$downloadfile");
			$charset="utf-8";
		}
	} else {
		$downloadfile=qq(filename="$downloadfile");
		$charset="utf-8";
	}
	return ($charset,$downloadfile);
}

sub html5video {
	my($file,$path,$videourl,%videourls)=@_;

	my $agent=$ENV{HTTP_USER_AGENT};
	my $tag="";
	my $url;

	if(($url=&checkurl($file,$mp4,$path,$videourl,%videourls)) ne '') {
		foreach(@HTML5_VIDEO_TARGETS_MP4) {
			my($arg1,$arg2,$arg3)=split(/ /,$_);
			if($arg3 eq "") {
				if($agent=~/$arg1[\s|\/](\d+)\./) {
					if($1 >= $arg2) {
						$tag.=<<EOM;
<source src="$url" type="video/mp4" />
EOM
					}
				}
			} elsif($agent=~/$arg1/) {
				if($agent=~/$arg2[\s|\/](\d+)\./) {
					if($1 >= $arg3) {
						$tag.=<<EOM;
<source src="$url" type="video/mp4" />
EOM
					}
				}
			}
		}
	}

	if(($url=&checkurl($file,$ogv,$path,$videourl,%videourls)) ne '') {
		foreach(@HTML5_VIDEO_TARGETS_OGV) {
			my($arg1,$arg2,$arg3)=split(/ /,$_);
			if($arg3 eq "") {
				if($agent=~/$arg1[\s|\/](\d+)\./) {
					if($1 >= $arg2) {
						$tag.=<<EOM;
<source src="$url" type='video/ogg; codecs="theora, vorbis"' />
EOM
					}
				}
			} elsif($agent=~/$arg1/) {
				if($agent=~/$arg2[\s|\/](\d+)\./) {
					if($1 >= $arg3) {
						$tag.=<<EOM;
<source src="$url" type='video/ogg; codecs="theora, vorbis"' />
EOM
					}
				}
			}
		}
	}

	if(($url=&checkurl($file,$webm,$path,$videourl,%videourls)) ne '') {
		foreach(@HTML5_VIDEO_TARGETS_WEBM) {
			my($arg1,$arg2,$arg3)=split(/ /,$_);
			if($arg3 eq "") {
				if($agent=~/$arg1[\s|\/](\d+)\./) {
					if($1 >= $arg2) {
						$tag.=<<EOM;
<source src="$url" type='video/webm; codecs="vp8, vorbis"' />
EOM
					}
				}
			} elsif($agent=~/$arg1/) {
				if($agent=~/$arg2[\s|\/](\d+)\./) {
					if($1 >= $arg3) {
						$tag.=<<EOM;
<source src="$url" type='video/webm; codecs="vp8, vorbis"' />
EOM
					}
				}
			}
		}
	}

	return $tag;
}

sub is_exist_page {
	return 1;
}

sub encode {
	my ($encoded) = @_;
	$encoded =~ s/(\W)/$::_urlescape{$1}/g;
	return $encoded;
}

sub dbmname {
	my ($name) = @_;
	$name =~ s/(.)/$::_dbmname_encode{$1}/g;
	return $name;
}

my $_tz='';
sub gettz {
	if($_tz eq '') {
		$_tz=(localtime(time))[2]+(localtime(time))[3]*24+(localtime(time))[4]*24
			+(localtime(time))[5]*24-(gmtime(time))[2]-(gmtime(time))[3]*24
			-(gmtime(time))[4]*24-(gmtime(time))[5]*24;
	}
	return $_tz;
}

sub code_convert {
	my ($contentref, $kanjicode, $icode) = @_;
	if($$contentref ne '') {
		if ($::lang eq 'ja') {
			if($::code_method{ja} eq 'jcode.pl') {
				die "Unsupport jcode.pl";
			} else {
				&load_module("Jcode");
				$$contentref .= '';
				$$contentref=~s/\xef\xbd\x9e/\xe3\x80\x9c/g;
				&Jcode::convert($contentref, $kanjicode, $icode);
				$$contentref=~s/\xe3\x80\x9c/\xef\xbd\x9e/g;
			}
		}
	}
	return $$contentref;
}

sub err {
	($msg)=@_;
	print <<EOM;
Content-type: text/plain

$msg
EOM
}

sub getbasehref {
	return if($::basehref ne '');
	$::basehost = "$ENV{'HTTP_HOST'}";

	if (($ENV{'https'} =~ /on/i) || ($ENV{'SERVER_PORT'} eq '443')) {
		$::basehost = 'https://' . $::basehost;
	} else {
		$::basehost = 'http://' . $::basehost;
		# Special Thanks to gyo
		$::basehost .= ":$ENV{'SERVER_PORT'}"
			if ($ENV{'SERVER_PORT'} ne '80' && $::basehost !~ /:\d/);
	}

	my $uri=$ENV{REQUEST_URI};
	$uri=~s/v\.cgi.*//g;
	$::basehref=$::basehost . $uri;
	$::basepath=$uri;
	$::basepath=~s/\/[^\/]*$//g;
	$::basepath="/" if($::basepath eq '');
	$::script=$uri if($::script eq '');
}

sub skin_init {
	$::skin_file="$::skin_dir/" . &skin_check("$::skin_name.skin%s.cgi",".$::lang","");
	$::skin{default_css}=&skin_check("$::skin_name.default%s.css",".$::lang","");
	$::skin{print_css}=&skin_check("$::skin_name.print%s.css",".$::lang","");
	$::skin{common_js}=&skin_check("common%s.js",".$::kanjicode.$::lang",".$::lang");
}

sub skin_check {
	my($file)=@_;
	foreach(@_) {
		my $f=sprintf($file,$_);
		return $f if(-f "$::skin_dir/$f");
	}
	die sprintf("$file not found","");
	exit;
}

sub exec_explugin_sub {
	my($explugin)=@_;
	foreach(@::loaded_explugin) {
		return if($explugin eq $_);
	}
	if (&exist_explugin($explugin) eq 1) {
		my $action = "\&plugin_" . $explugin . "_init";
		push(@::loaded_explugin,$explugin);
		my %ret = eval $action;
		$::_exec_plugined{$explugin} = 2 if($ret{init});
		$::HTTP_HEADER.="$ret{http_header}\n";
		$::IN_HEAD.=$ret{header};
		$::IN_BODY.=$ret{bodytag};

		$explugin_last.="$ret{last_func},";
		if (($ret{msg} ne '') && ($ret{body} ne '')) {
			$exec = 0;
			&skinex($ret{msg}, $ret{body});
			exit;
		}
	}
}

sub exist_explugin {
	my ($explugin) = @_;

	if (!$_exec_plugined{$explugin}) {
		my $path = "$::explugin_dir/$explugin" . '.inc.cgi';
		if (-e $path) {
			require $path;
			$::debug.=$@;
			$_exec_plugined{$1} = 1;
			return 1;
		}
		return 0;
	}
	return $_exex_plugined{$explugin};
}

sub getcookie {
	my($cookieID,%buf)=@_;
	my @pairs;
	my $pair;
	my $cname;
	my $value;
	my %DUMMY;

	@pairs = split(/;/,&decode($ENV{'HTTP_COOKIE'}));
	foreach $pair (@pairs) {
		($cname,$value) = split(/=/,$pair,2);
		$cname =~ s/ //g;
		$DUMMY{$cname} = $value;
	}
	@pairs = split(/,/,$DUMMY{$cookieID});
	foreach $pair (@pairs) {
		($cname,$value) = split(/:/,$pair,2);
		$buf{$cname} = $value;
	}
	return %buf;
}

sub decode {
	my ($s) = @_;
	$s =~ tr/+/ /;
	$s =~ s/%([A-Fa-f0-9][A-Fa-f0-9])/chr(hex($1))/eg;
	return $s;
}

sub load_module{
	my $mod = shift;
	return $mod if $::_module_loaded{$mod}++;
	eval qq( require $mod; );
	$mod=undef if($@);
	return $mod;
}

sub escapeoff {};

__END__
=head1 NAME

playvideo.inc.pl - PyukiWiki External Plugin

=head1 SYNOPSIS

Playvideo Plugin

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/ad/

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Nanami/ad/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/v.cgi?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/v.cgi?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/playvideo.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/playvideo.inc.pl?view=log>

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
