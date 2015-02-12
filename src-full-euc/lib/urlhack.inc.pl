######################################################################
# urlhack.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: urlhack.inc.pl,v 1.491 2012/03/01 10:39:20 papu Exp $
#
# "PyukiWiki" version 0.2.0-p2 $$
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
# This is extented plugin.
# To use this plugin, rename to 'urlhack.inc.cgi'
######################################################################
#
# SEO対策用URLハックプラグイン
#
######################################################################
# PATH_INFO を使う（0の場合File not foundを補足する)
$urlhack::use_path_info=1
	if(!defined($urlhack::use_path_info));
#
# fake extension 拡張子偽装
$urlhack::fake_extention="/"
	if(!defined($urlhack::fake_extention));
#
# use puny url 0:16進エンコード 1:punyエンコード 2:UTF8エンコード 3:短縮URL
$urlhack::use_puny=1
	if(!defined($urlhack::use_puny));
#
# not convert Alphabet or Number ( or dot and slash) page
$urlhack::noconvert_marks=2
	if(!defined($urlhack::noconvert_marks));
#
# force url hack (non extention .cgi)
$urlhack::force_exec=0
	if(!defined($urlhack::force_exec));
# 短縮URLのDB（言語考慮不要）
$urlhack::shortdb="./wikidb"
	if(!defined($urlhack::shortdb));
###################
# sample of shorted wiki url
## PATH_INFO を使う（0の場合File not foundを補足する)
#$urlhack::use_path_info=0;
##
## fake extension 拡張子偽装
#$urlhack::fake_extention="";
##
## use puny url 0:16進エンコード 1:punyエンコード 2:UTF8エンコード 3:短縮URL
#$urlhack::use_puny=3;
##
## not convert Alphabet or Number ( or dot and slash) page
#$urlhack::noconvert_marks=0; # 0:NO / 1:Alpha&Number / 2:AlphaNumber and mark
##
## force url hack (non extention .cgi)
#$urlhack::force_exec=1;
#
## 短縮URLのDB（言語考慮不要）
#$urlhack::shortdb="./wikidb";
#
######################################################################
use strict;
use Nana::MD5;
my %urldb;
sub plugin_urlhack_init {
	&exec_explugin_sub("lang");
	if($urlhack::use_puny eq 3) {
		my $err=&writechk($urlhack::shortdb);
		&print_error($err)  if($err ne '');
		&dbopen($urlhack::shortdb,\%urldb);
	}
	unless($::form{mypage} eq '' || $::form{mypage} eq $::FrontPage) {
		return('init'=>0
			,'func'=>'make_cookedurl',
			, 'make_cookedurl'=>\&make_cookedurl);
	}
	if($urlhack::use_path_info eq 0) {
		return('init'=>&plugin_urlhack_init_notfound
			,'func'=>'make_cookedurl',
			, 'make_cookedurl'=>\&make_cookedurl);
	} else {
		return('init'=>&plugin_urlhack_init_path_info
			,'func'=>'make_cookedurl',
			, 'make_cookedurl'=>\&make_cookedurl);
	}
}
sub plugin_urlhack_init_path_info {
	my $req=$ENV{PATH_INFO};
	unless($::form{cmd} eq '' || $::form{cmd} eq 'read') {
		return 0;
	}
	if($urlhack::fake_extention ne '') {
		my $regex=$urlhack::fake_extention;
		$regex=~s/([\.\/])/'\\x' . unpack('H2', $1)/eg;
		$req=~s/$regex$//g;
	}
	if($urlhack::use_puny ne 3) {
		if(&is_exist_page($req)) {
			$::form{cmd}='read';
			$::form{mypage}=$req;
			return 0;
		}
	}
	$req=~s!^/!!g;
	$req=~s!/$!!g;
	if($urlhack::fake_extention ne '') {
		my $regex=$urlhack::fake_extention;
		$regex=~s/([\.\/])/'\\x' . unpack('H2', $1)/eg;
		$req=~s/$regex$//g;
	}
	if($urlhack::use_puny ne 3) {
		if(&is_exist_page($req)) {
			$::form{cmd}='read';
			$::form{mypage}=$req;
			return 0;
		}
	}
	$req=&plugin_urlhack_decode($req);
	if($req eq '') {
		$req=&decode($ENV{QUERY_STRING});
		if(&is_exist_page($req)) {
			$::form{cmd}='read';
			$::form{mypage}=$req;
			return 0;
		} elsif(&is_exist_page($::form{mypage})) {
			$::form{cmd}='read';
			return 0;
		}
		$::form{cmd}='read';
		$::form{mypage}=$::FrontPage;
		return 0;
	} elsif(&is_exist_page($req)) {
		$::form{cmd}='read';
		$::form{mypage}=$req;
		return 1;
	}
	return 0;
}
sub plugin_urlhack_init_notfound {
	if($urlhack::force_exec eq 0) {
		unless($ENV{SCRIPT_NAME}=~/nph-/ || $ENV{REQUEST_URI}=~/\.cgi/) {
			$::debug.="Not used urlhack.inc.cgi\n";
			return 0;
		}
	}
	my $req;
	if($::form{cmd} eq 'servererror') {
		if($ENV{REDIRECT_STATUS} eq 404) {
			$req=$ENV{REDIRECT_URL};
		} else {
			return 0;
		}
	}
	if($req ne '' || $::form{cmd} eq '' || $::form{cmd} eq 'read') {
		$req=$ENV{REQUEST_URI};
		$req="$req/" if($urlhack::force_exec eq 1 && ($ENV{REQUEST_URI}!~/\.cgi$/ || $ENV{REQUEST_URI}=~/\/$/));
	} else {
		return 0;
	}
	$req=~s/\?.*//g;
	if($urlhack::noconvert_marks eq 2 || 1) {
		my $uri;
		if($req ne '') {
			if($req eq $ENV{SCRIPT_NAME}) {
				$uri= $ENV{'SCRIPT_NAME'};
			} else {
				for(my $i=0; $i<length($ENV{SCRIPT_NAME}); $i++) {
					if(substr($ENV{SCRIPT_NAME},$i,1)
						eq substr($req,$i,1)) {
						$uri.=substr($ENV{SCRIPT_NAME},$i,1);
					} else {
						last;
					}
				}
			}
		} else {
			$uri .= $ENV{'SCRIPT_NAME'};
		}
		$uri=~s!/!\x08!g;
		$req=~s!/!\x08!g;
		$req=~s!^$uri!!g;
		$req=~s!\x08!/!g;
	} else {
		$req=~s/.*\///g;
		$req=~s/^\///g;
	}
	$req=~s!^/!!g;
	$req=~s!/$!!g;
	if($urlhack::fake_extention ne '') {
		my $regex=$urlhack::fake_extention;
		$regex=~s/([\.\/])/'\\x' . unpack('H2', $1)/eg;
		$req=~s/$regex$//g;
	}
	if($urlhack::use_puny ne 3) {
		$req=~s/%([A-Fa-f0-9][A-Fa-f0-9])/chr(hex($1))/eg;
		if(&is_exist_page($req)) {
			$::form{cmd}='read';
			$::form{mypage}=$req;
			return 0;
		}
	}
	$req=&plugin_urlhack_decode($req);
	if($req eq '') {
		$req=&decode($ENV{QUERY_STRING});
		if(&is_exist_page($req)) {
			$::form{cmd}='read';
			$::form{mypage}=$req;
			return 0;
		} elsif(&is_exist_page($::form{mypage})) {
			$::form{cmd}='read';
			return 0;
		}
		$::form{cmd}='read';
		$::form{mypage}=$::FrontPage;
		return 0;
	} elsif(&is_exist_page($req)) {
		$::form{cmd}='read';
		$::form{mypage}=$req;
		return 1;
	} else {
#		$::form{cmd}='servererror';
#		$ENV{REDIRECT_STATUS}=404;
#		$ENV{REDIRECT_URL}=$ENV{REQUEST_URI};
#		$ENV{REDIRECT_REQUEST_METHOD}="GET";
#		return 0;
	}
}
sub make_cookedurl {
	my($cookedchunk)=@_;
	if($urlhack::force_exec eq 0 && $urlhack::use_path_info eq 0) {
		unless($ENV{SCRIPT_NAME}=~/nph-/ || $ENV{REQUEST_URI}=~/\.cgi/) {
			return("$::script?$cookedchunk");
		}
	}
	$cookedchunk=&decode($cookedchunk);
	my $orgchunk=$cookedchunk;
	if($urlhack::noconvert_marks+0 eq 0) {
		$cookedchunk=&plugin_urlhack_encode($cookedchunk);
	} elsif($cookedchunk=~/(\W)/ && $urlhack::noconvert_marks+0 eq 1) {
		$cookedchunk=&plugin_urlhack_encode($cookedchunk);
	} elsif($cookedchunk=~/([^0-9A-Za-z\.\/])/) {
		$cookedchunk=&plugin_urlhack_encode($cookedchunk);
	}
	my $script=$::script;
	$script=~s/\/$//g;
	if($cookedchunk eq '' || $orgchunk eq $::FrontPage) {
		return "$script/";
	} else {
		return "$script/$cookedchunk$urlhack::fake_extention";
	}
}
sub plugin_urlhack_decode {
	my($str)=@_;
	if($str=~/xn\-/) {
		&plugin_urlhack_usepuny;
		$str=~s/\_/\//g;
		$str=IDNA::Punycode::decode_punycode($str);
		$str=&code_convert(\$str, $::defaultcode, 'utf8');
		if($urlhack::use_puny ne 1) {
			&getbasehref;
			$::IN_HEAD.=<<EOM;
<link rel="canonical" href="$::basehref@{[&plugin_urlhack_encode($str,$urlhack::use_puny)]}" />
EOM
		}
	} elsif(&urldb_decode($str) ne '') {
		$str=&urldb_decode($str);
		if($urlhack::use_puny ne 3) {
			&getbasehref;
			$::IN_HEAD.=<<EOM;
<link rel="canonical" href="$::basehref@{[&plugin_urlhack_encode($str,$urlhack::use_puny)]}" />
EOM
		}
	} elsif($str=~/^[0-9A-Fa-f]+/) {
		$str=~s/([A-Fa-f0-9][A-Fa-f0-9])/pack("C", hex($1))/eg;
		if($urlhack::use_puny ne 0) {
			&getbasehref;
			$::IN_HEAD.=<<EOM;
<link rel="canonical" href="$::basehref@{[&plugin_urlhack_encode($str,$urlhack::use_puny)]}" />
EOM
		}
	} else {
		my $tmp=&decode($str);
		$str=&code_convert(\$tmp, $::defaultcode, 'utf8');
		if($urlhack::use_puny ne 2) {
			&getbasehref;
			$::IN_HEAD.=<<EOM;
<link rel="canonical" href="$::basehref@{[&plugin_urlhack_encode($str,$urlhack::use_puny)]}" />
EOM
		}
}
	$str=~s/\+/\ /g;
	$str=~s/\!2b/\+/g;
	return $str;
}
sub plugin_urlhack_encode {
	my($str, $enc)=@_;
	$enc=$enc eq '' ? $urlhack::use_puny : $enc;
	if($enc eq 0) {
		$str=~ s/(.)/unpack('H2', $1)/eg;
	} elsif($enc eq 2) {
		$str=&encode(&code_convert(\$str, 'utf8', $::defaultcode));
		$str=~s!%2d!-!g;
		$str=~s!%2[Ff]!/!g;
	} elsif($enc eq 3) {
		$str=&urldb_encode($str);
	} else {
		&plugin_urlhack_usepuny;
		$str=~s/\+/!2b/g;
		$str=~s/\ /+/g;
		my $org=$str;
		$str=&code_convert(\$str, 'utf8', $::defaultcode);
		utf8::decode($str);
		$str=IDNA::Punycode::encode_punycode($str);
		$str=~s/\-{3,9}/--/g;
		$str=~s/\//\_/g if($str ne $org);
		utf8::encode($str);
		$str=~s!%2d!-!g;
	}
	return $str;
}
sub urldb_decode {
	my($str)=shift;
	&dbopen($urlhack::shortdb,\%urldb);
	my $str=$urldb{"p$::lang" . $str};
	return $str;
}
sub urldb_encode {
	my($str)=shift;
	my $try=62;
	my $chk=$urldb{"c$::lang" . $str};
	if($chk ne '') {
		return $chk;
	}
	my $count=$urldb{"sys-count"}+0;
	my $keylen;
	my $tmp=1;
	for(my $i=1; $i<=30; $i++) {
		$keylen=$i;
		$tmp=$tmp * $try;
			last if($count < $tmp);
	}
	my $c=0;
	my $hashedurl;
	my $cmpedurl;
	do {
		$hashedurl=Nana::MD5::md5($c . time . $c . $str);
		$c++;
		$cmpedurl=substr(&trip($hashedurl),0, $keylen);
		if($urldb{"p$::lang" . $cmpedurl} eq '') {
			$urldb{"c$::lang" . $str}=$cmpedurl;
			$urldb{"p$::lang" . $cmpedurl}=$str;
			$urldb{"sys-count"}=($count+1);
			$str=$cmpedurl;
			return $str;
		}
	} while($c<1000);
	return $str;
}
sub trip {
	my ($tripkey)=shift;
	$tripkey = substr($tripkey,1);
	my $salt = substr($tripkey.'H.',1,2);
	$salt =~ s/[^\.-z]/\./go;
	$salt =~ tr/:;<=>?@[\\]^_`/ABCDEFGabcdef/;
	my $trip = crypt($tripkey,$salt);
	$trip =~ tr/\/:;<=>?@[\\]^_`./ABCDEFGHabcdefgh/;
	return $trip;
}
sub plugin_urlhack_usepuny {
	if($::puny_loaded+0 ne 1) {
		if($] < 5.008001) {
			die "Perl v5.8.1 required this is $]";
		}
		$::puny_loaded=1;
		require "$::explugin_dir/IDNA/Punycode.pm";
	}
	IDNA::Punycode::idn_prefix('xn--');
}
1;
__DATA__
	return(
	'ja'=>'SEO対策用URLハック',
	'en'=>'The measure against SEO',
	'override'=>'make_cookedurl',
	'setting_ja'=>
		'$::urlhack_use_path_info=メソッド:1=PATH_INFO,0=Not Found エラー/' .
		'$::urlhack_fake_extention=偽の拡張子の設定:=なし,.html,/=ディレクトリに見せる/' .
		'$::urlhack_noconvert_marks=エンコードしない文字:0=すべてエンコード,1=アルファベットと数字のみのページのみ,2=アルファベットと数字、ドット、スラッシュ',
	'setting_en'=>
		'$::urlhack_use_path_info=Method:1=PATH_INFO,0=Not Found Error/' .
		'$::urlhack_fake_extention=Fake extention:=none,.html,/' .
		'$::urlhack_noconvert_marks=Not convert charactors:0=All encode,1=Alphabet and number of page name,2=Alphabet and number and dot and slash',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/urlhack/'
	);
__END__
