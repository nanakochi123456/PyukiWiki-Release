######################################################################
# urlhack.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: urlhack.inc.pl,v 1.94 2010/12/14 22:20:00 papu Exp $
#
# "PyukiWiki" version 0.1.8 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2010 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2010 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'urlhack.inc.cgi'
######################################################################
#
# SEO�к���URL�ϥå��ץ饰����
#
######################################################################

# PATH_INFO ��Ȥ���0�ξ��File not found����­����)
$urlhack::use_path_info=1
	if(!defined($urlhack::use_path_info));

# fake extension ��ĥ�ҵ���
$urlhack::fake_extention="/"	# "/" ".html" or null
	if(!defined($urlhack::fake_extention));

# use puny url 0:16�ʥ��󥳡��� 1:puny���󥳡���
$urlhack::use_puny=1
	if(!defined($urlhack::use_puny));

# not convert Alphabet or Number ( or dot and slash) page
$urlhack::noconvert_marks=2	# 0:NO / 1:Alpha&Number / 2:AlphaNumber and mark
	if(!defined($urlhack::noconvert_marks));

# force url hack (non extention .cgi)
$urlhack::force_exec=0			# PATH_INFO��Ȥ�ʤ����ǡ���ĥ��CGI�Ǥʤ���硢1������
	if(!defined($urlhack::force_exec));

use strict;

# Initlize

sub plugin_urlhack_init {
	&exec_explugin_sub("lang");
	$::debug.="urlhack.inc.cgi:Load\n";				# debug
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

	# cmd=read�ʳ��ϻ��Ѥ��ʤ�									# debug
	unless($::form{cmd} eq '' || $::form{cmd} eq 'read') {
		return 0;
	}

	# ��ĥ�ҵ������Ƥ����硢�������						# debug
	if($urlhack::fake_extention ne '') {
		my $regex=$urlhack::fake_extention;
		$regex=~s/([\.\/])/'\\x' . unpack('H2', $1)/eg;
		$req=~s/$regex$//g;
	}
	# ����ե��٥åȿ����Τߤǡ��Ѵ����פξ�� FrontPage ��		# debug
	if(&is_exist_page($req)) {
		$::form{cmd}='read';
		$::form{mypage}=$req;
		return 0;
	}

	# ��������פʥ���å������								# debug
	$req=~s!^/!!g;
	$req=~s!/$!!g;

	# ��ĥ�ҵ������Ƥ����硢�������						# debug
	if($urlhack::fake_extention ne '') {
		my $regex=$urlhack::fake_extention;
		$regex=~s/([\.\/])/'\\x' . unpack('H2', $1)/eg;
		$req=~s/$regex$//g;
	}
	# ����ե��٥åȿ����Τߤǡ��Ѵ����פξ�� FrontPage ��		# debug
	if(&is_exist_page($req)) {
		$::form{cmd}='read';
		$::form{mypage}=$req;
		return 0;
	}
	$req=&plugin_urlhack_decode($req);
	# URI�����λ��ν���											# debug
	if($req eq '') {
		# �̾�Υ��󥳡��ɤξ��ν���							# debug
		$req=&decode($ENV{QUERY_STRING});
		if(&is_exist_page($req)) {
			$::form{cmd}='read';
			$::form{mypage}=$req;
			return 0;
		# cmd=read&mypage=xxx �ξ��							# debug
		} elsif(&is_exist_page($::form{mypage})) {
			$::form{cmd}='read';
			return 0;
		}
		# �Ǥʤ���С�FrontPage									# debug
		$::form{cmd}='read';
		$::form{mypage}=$::FrontPage;
		return 0;
	# REDIRECT_URI������������ڡ�����¸�ߤ������				# debug
	} elsif(&is_exist_page($req)) {
		$::form{cmd}='read';
		$::form{mypage}=$req;
		return 1;
	}
	return 0;
}

sub plugin_urlhack_init_notfound {
	# nph������ץȤ���ĥ��.cgi�Ǥʤ���硢���Ѥ��ʤ�			# debug
	if($urlhack::force_exec eq 0) {
		unless($ENV{SCRIPT_NAME}=~/nph-/ || $ENV{REQUEST_URI}=~/\.cgi/) {
			$::debug.="Not used urlhack.inc.cgi\n";
			return 0;
		}
	}
	my $req;

	# ���顼404�ʳ��ϻ��Ѥ��ʤ�									# debug
	if($::form{cmd} eq 'servererror') {
		if($ENV{REDIRECT_STATUS} eq 404) {
			$req=$ENV{REDIRECT_URL};
		} else {
			return 0;
		}
	}

	# 404���֤��줿REDIRECT_URL���ʤ���cmd=read�ʳ��ϻ��Ѥ��ʤ�	# debug
	if($req ne '' || $::form{cmd} eq '' || $::form{cmd} eq 'read') {
		$req=$ENV{REQUEST_URI};
		$req="$req/" if($urlhack::force_exec eq 1 && ($ENV{REQUEST_URI}!~/\.cgi$/ || $ENV{REQUEST_URI}=~/\/$/));
	} else {
		return 0;
	}

	# ?�ʹߤ�̵�뤹��											# debug
	$req=~s/\?.*//g;

	# dot(.)��slash(/)��ͭ���ξ��								# debug
	if($urlhack::noconvert_marks eq 2) {
		my $uri;
		# ��URI����������������
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
					# slash�Τ�����ɽ���ˤ����뤿�ᥨ��������	# debug
		$uri=~s!/!\x08!g;
		$req=~s!/!\x08!g;
		$req=~s!^$uri!!g;
						# �᤹								# debug
		$req=~s!\x08!/!g;
	} else {
		$req=~s/.*\///g;
		$req=~s/^\///g;
	}
	# ��������פʥ���å������								# debug
	$req=~s!^/!!g;
	$req=~s!/$!!g;

	# ��ĥ�ҵ������Ƥ����硢�������						# debug
	if($urlhack::fake_extention ne '') {
		my $regex=$urlhack::fake_extention;
		$regex=~s/([\.\/])/'\\x' . unpack('H2', $1)/eg;
		$req=~s/$regex$//g;
	}
	# ����ե��٥åȿ����Τߤǡ��Ѵ����פξ�� FrontPage ��		# debug
	$req=~s/%([A-Fa-f0-9][A-Fa-f0-9])/chr(hex($1))/eg;
	if(&is_exist_page($req)) {
		$::form{cmd}='read';
		$::form{mypage}=$req;
		return 0;
	}
	$req=&plugin_urlhack_decode($req);

	# URI�����λ��ν���											# debug
	if($req eq '') {
		# �̾�Υ��󥳡��ɤξ��ν���							# debug
		$req=&decode($ENV{QUERY_STRING});
		if(&is_exist_page($req)) {
			$::form{cmd}='read';
			$::form{mypage}=$req;
			return 0;
		# cmd=read&mypage=xxx �ξ��							# debug
		} elsif(&is_exist_page($::form{mypage})) {
			$::form{cmd}='read';
			return 0;
		}
		# �Ǥʤ���С�FrontPage									# debug
		$::form{cmd}='read';
		$::form{mypage}=$::FrontPage;
		return 0;
	# REDIRECT_URI������������ڡ�����¸�ߤ������				# debug
	} elsif(&is_exist_page($req)) {
		$::form{cmd}='read';
		$::form{mypage}=$req;
		return 1;
	# �Ǥʤ���С�404 Not found���֤�							# debug
	} else {
		$::form{cmd}='servererror';
		$ENV{REDIRECT_STATUS}=404;
		$ENV{REDIRECT_URL}=$ENV{REQUEST_URI};
		$ENV{REDIRECT_REQUEST_METHOD}="GET";
		return 0;
	}
}

# hack wiki.cgi of make_cookedurl								# debug

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
		$str=&code_convert(\$str, 'euc', 'utf8');
	} else {
		$str=~s/([A-Fa-f0-9][A-Fa-f0-9])/pack("C", hex($1))/eg;
	}
	$str=~s/\+/\ /g;
	$str=~s/\!2b/\+/g;
	return $str;
}

sub plugin_urlhack_encode {
	my($str)=@_;
	if($urlhack::use_puny eq 0) {
		$str=~ s/(.)/unpack('H2', $1)/eg;
	} else {
		&plugin_urlhack_usepuny;
		$str=~s/\+/!2b/g;
		$str=~s/\ /+/g;
		my $org=$str;
		$str=&code_convert(\$str, 'utf8', 'euc');
		utf8::decode($str);
		$str=IDNA::Punycode::encode_punycode($str);
		$str=~s/\-{3,9}/--/g;
		$str=~s/\//\_/g if($str ne $org);
		utf8::encode($str);
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
	'ja'=>'SEO�к���URL�ϥå�',
	'en'=>'The measure against SEO',
	'override'=>'make_cookedurl',
	'setting_ja'=>
		'$::urlhack_use_path_info=�᥽�å�:1=PATH_INFO,0=Not Found ���顼/' .
		'$::urlhack_fake_extention=���γ�ĥ�Ҥ�����:=�ʤ�,.html,/=�ǥ��쥯�ȥ�˸�����/' .
		'$::urlhack_noconvert_marks=���󥳡��ɤ��ʤ�ʸ��:0=���٤ƥ��󥳡���,1=����ե��٥åȤȿ����ΤߤΥڡ����Τ�,2=����ե��٥åȤȿ������ɥåȡ�����å���',
	'setting_en'=>
		'$::urlhack_use_path_info=Method:1=PATH_INFO,0=Not Found Error/' .
		'$::urlhack_fake_extention=Fake extention:=none,.html,/' .
		'$::urlhack_noconvert_marks=Not convert charactors:0=All encode,1=Alphabet and number of page name,2=Alphabet and number and dot and slash',
	'url'=>'http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/urlhack/'
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

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/urlhack/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/urlhack.inc.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2010 by Nanami.

Copyright (C) 2005-2010 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
