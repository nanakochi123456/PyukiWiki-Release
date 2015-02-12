######################################################################
# urlhack.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: urlhack.inc.pl,v 1.255 2012/01/31 10:12:02 papu Exp $
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
$urlhack::fake_extention="/"		# only "/"
	if(!defined($urlhack::fake_extention));
#
# use puny url 0:16進エンコード 1:punyエンコード 2:UTF8エンコード
$urlhack::use_puny=1
	if(!defined($urlhack::use_puny));
#
# not convert Alphabet or Number ( or dot and slash) page
$urlhack::noconvert_marks=2	# 0:NO / 1:Alpha&Number / 2:AlphaNumber and mark
	if(!defined($urlhack::noconvert_marks));
#
# force url hack (non extention .cgi)
$urlhack::force_exec=0			# PATH_INFOを使わない場合で、拡張子CGIでない場合、1を設定
	if(!defined($urlhack::force_exec));
#
######################################################################

use strict;

# Initlize														# comment

sub plugin_urlhack_init {
	&exec_explugin_sub("lang");
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

	# cmd=read以外は使用しない									# comment
	unless($::form{cmd} eq '' || $::form{cmd} eq 'read') {
		return 0;
	}

	# 拡張子偽装している場合、それを削除						# comment
	if($urlhack::fake_extention ne '') {
		my $regex=$urlhack::fake_extention;
		$regex=~s/([\.\/])/'\\x' . unpack('H2', $1)/eg;
		$req=~s/$regex$//g;
	}
	# アルファベット数字のみで、変換不要の場合 FrontPage 等		# comment
	if(&is_exist_page($req)) {
		$::form{cmd}='read';
		$::form{mypage}=$req;
		return 0;
	}

	# 前後の不要なスラッシュを削除								# comment
	$req=~s!^/!!g;
	$req=~s!/$!!g;

	# 拡張子偽装している場合、それを削除						# comment
	if($urlhack::fake_extention ne '') {
		my $regex=$urlhack::fake_extention;
		$regex=~s/([\.\/])/'\\x' . unpack('H2', $1)/eg;
		$req=~s/$regex$//g;
	}
	# アルファベット数字のみで、変換不要の場合 FrontPage 等		# comment
	if(&is_exist_page($req)) {
		$::form{cmd}='read';
		$::form{mypage}=$req;
		return 0;
	}
	$req=&plugin_urlhack_decode($req);
	# URIが空の時の処理											# comment
	if($req eq '') {
		# 通常のエンコードの場合の処理							# comment
		$req=&decode($ENV{QUERY_STRING});
		if(&is_exist_page($req)) {
			$::form{cmd}='read';
			$::form{mypage}=$req;
			return 0;
		# cmd=read&mypage=xxx の場合							# comment
		} elsif(&is_exist_page($::form{mypage})) {
			$::form{cmd}='read';
			return 0;
		}
		# でなければ、FrontPage									# comment
		$::form{cmd}='read';
		$::form{mypage}=$::FrontPage;
		return 0;
	# REDIRECT_URIから取得したページが存在した場合				# comment
	} elsif(&is_exist_page($req)) {
		$::form{cmd}='read';
		$::form{mypage}=$req;
		return 1;
	}
	return 0;
}

sub plugin_urlhack_init_notfound {
	# nphスクリプトか拡張子.cgiでない場合、使用しない			# comment
	if($urlhack::force_exec eq 0) {
		unless($ENV{SCRIPT_NAME}=~/nph-/ || $ENV{REQUEST_URI}=~/\.cgi/) {
			$::debug.="Not used urlhack.inc.cgi\n";
			return 0;
		}
	}
	my $req;

	# エラー404以外は使用しない									# comment
	if($::form{cmd} eq 'servererror') {
		if($ENV{REDIRECT_STATUS} eq 404) {
			$req=$ENV{REDIRECT_URL};
		} else {
			return 0;
		}
	}

	# 404で返されたREDIRECT_URLがない、cmd=read以外は使用しない	# comment
	if($req ne '' || $::form{cmd} eq '' || $::form{cmd} eq 'read') {
		$req=$ENV{REQUEST_URI};
		$req="$req/" if($urlhack::force_exec eq 1 && ($ENV{REQUEST_URI}!~/\.cgi$/ || $ENV{REQUEST_URI}=~/\/$/));
	} else {
		return 0;
	}

	# ?以降は無視する											# comment
	$req=~s/\?.*//g;

	# dot(.)とslash(/)が有効の場合								# comment
	if($urlhack::noconvert_marks eq 2) {
		my $uri;
		# 自URIを取得し、削除する
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
					# slashのみ正規表現にかけるためエスケープ	# comment
		$uri=~s!/!\x08!g;
		$req=~s!/!\x08!g;
		$req=~s!^$uri!!g;
						# 戻す								# comment
		$req=~s!\x08!/!g;
	} else {
		$req=~s/.*\///g;
		$req=~s/^\///g;
	}
	# 前後の不要なスラッシュを削除								# comment
	$req=~s!^/!!g;
	$req=~s!/$!!g;

	# 拡張子偽装している場合、それを削除						# comment
	if($urlhack::fake_extention ne '') {
		my $regex=$urlhack::fake_extention;
		$regex=~s/([\.\/])/'\\x' . unpack('H2', $1)/eg;
		$req=~s/$regex$//g;
	}
	# アルファベット数字のみで、変換不要の場合 FrontPage 等		# comment
	$req=~s/%([A-Fa-f0-9][A-Fa-f0-9])/chr(hex($1))/eg;
	if(&is_exist_page($req)) {
		$::form{cmd}='read';
		$::form{mypage}=$req;
		return 0;
	}
	$req=&plugin_urlhack_decode($req);

	# URIが空の時の処理											# comment
	if($req eq '') {
		# 通常のエンコードの場合の処理							# comment
		$req=&decode($ENV{QUERY_STRING});
		if(&is_exist_page($req)) {
			$::form{cmd}='read';
			$::form{mypage}=$req;
			return 0;
		# cmd=read&mypage=xxx の場合							# comment
		} elsif(&is_exist_page($::form{mypage})) {
			$::form{cmd}='read';
			return 0;
		}
		# でなければ、FrontPage									# comment
		$::form{cmd}='read';
		$::form{mypage}=$::FrontPage;
		return 0;
	# REDIRECT_URIから取得したページが存在した場合				# comment
	} elsif(&is_exist_page($req)) {
		$::form{cmd}='read';
		$::form{mypage}=$req;
		return 1;
	# でなければ、404 Not foundで返す							# comment
	} else {
		$::form{cmd}='servererror';
		$ENV{REDIRECT_STATUS}=404;
		$ENV{REDIRECT_URL}=$ENV{REQUEST_URI};
		$ENV{REDIRECT_REQUEST_METHOD}="GET";
		return 0;
	}
}

# hack wiki.cgi of make_cookedurl								# comment

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
#		$str=~s!%20!+!g;	# comment
		$str=~s!%2d!-!g;
		$str=~s!%2[Ff]!/!g;
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

=head1 NAME

urlhack.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

The measure against SEO (Serach Engine Optimize), remove URL of '?' to hit to a search engine

=head1 DESCRIPTION

In robot type search engines, (eg. Google, Yahoo), it coming to be hard to carry out the crawl of the page which is a script clearly. Therefore, the result of the search engine of a site may carry out a rank down.

Therefore, it is remove URL of '?' and the method of making a robot recognizing PyukiWiki not as a dynamic page but as a static page is offered.

=head1 USAGE

=head2 Enable plugin

Rename to urlhack.inc.cgi

=head2 Using PATH_INFO

By the default, since PATH_INFO is used, use use can be carried out as it is.

Also in a not corresponding server, this operates lightly.

http://example.com/ etc. does not support URL which makes a CGI name omit as a TOP page.


When the actual condition is http://example.com/index.cgi, please rename B<index.cgi> to B<wiki> and following description recommend you add to .htaccess following description.

 <FilesMatch "^wiki$">
    ForceType application/x-httpd-cgi
 </FilesMatch>

Let http://example.com/wiki be a TOP page by carrying out like this.

=head2 Using 404 Not found error from redirect server error

Although this can respond to many servers and omitted URL, there is a problem that a error log remains in a server whenever it is accessed.

However, the server which the nph script does not support cannot use it.

=over 4

=item index.cgi etc...

In order to make it operate as a nph script, it renames to nph-index.cgi etc.

=item urlhack.inc.cgi

change from B<$urlhack::use_path_info=1;> to B<$urlhack::use_path_info=0;>

=item .htaccess

 DirectoryIndex B<nph-index.cgi> index.cgi wiki.cgi pyukiwiki.cgi index.html

 RewriteEngine on
 RewriteBase /

 RewriteCond %{REQUEST_URI} !^/(attach|cache|image|skin)
 RewriteRule ^\?(.*)$ ./index.cgi?$1 [L]
 RewriteCond %{REQUEST_URI} !^/(attach|cache|image|skin)
 RewriteRule ^(.+)/$ ./index.cgi/$1 [L]
 RewriteCond %{REQUEST_URI} !^/(attach|cache|image|skin)
 RewriteRule ^$ ./index.cgi [L]

 ErrorDocument 400 /nph-index.cgi?cmd=servererror
 ErrorDocument 401 /nph-index.cgi?cmd=servererror
 ErrorDocument 402 /nph-index.cgi?cmd=servererror
 ErrorDocument 403 /nph-index.cgi?cmd=servererror
 ErrorDocument 404 /nph-index.cgi?cmd=servererror
 ErrorDocument 500 /nph-index.cgi?cmd=servererror

=head1 SETTING

=over 4

=item $urlhack::use_path_info

When using a PATH_INFO environment variable, it is set 1, using 404 Not found of error it is set 0.

=item $urlhack::fake_extention

Sorry. this option is '/' only ;;

 $urlhack::fake_extention='/';
 http://example.com/FrontPage/
 http://example.com/PyukiWiki/Download/
 http://example.com/a5d8a5eba5d7/

=item $urlhack::use_puny

 0:Hex encode
 1:Puny encode

=item $urlhack::noconvert_marks

In the case of the page name which consists of only specified characters, it does not encode.

 0: Unconditional encoding is carried out.
 1: Only the page which consists of only a number and the alphabet does not encode.
 2: Only the page which consists of a number, the alphabet, dot (.), and slash (/) does not encode.

=back

=head1 OVERRIDE

make_cookedurl was overrided.


=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/urlhack

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/urlhack/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/urlhack.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/lib/urlhack.inc.pl?view=log>

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
