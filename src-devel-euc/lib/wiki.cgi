######################################################################
# wiki.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: wiki.cgi,v 1.528 2011/12/31 13:06:09 papu Exp $
#
# "PyukiWiki" version 0.2.0 $$
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
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
$|=1;	# debug
##############################									# comment

# Setting Database Type
use Nana::YukiWikiDB;
use Nana::YukiWikiDB_GZIP;										#nocompact
$::modifier_dbtype = 'Nana::YukiWikiDB';

##############################

use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);								# debug

use Time::Local;

# Check if the server can use 'AnyDBM_File' or not.				# comment
# eval 'use AnyDBM_File';										# comment
# my $error_AnyDBM_File = $@;									# comment

##############################									# comment
# 2005.10.27 pochi: ��ư��󥯵�ǽ���ĥ ('?' | 'this' | '')	# comment
$::editchar = '?';

##############################									# comment
$::subject_delimiter = ' - ';
$::use_autoimg = 1;	# automatically convert image URL into <img> tag.# comment
$::use_exists = 0;	# If you can use 'exists' method for your DB.	# comment

##############################									# comment
$::package = 'PyukiWiki';
$::version = '0.2.0';

	# 2005.12.19 pochi: mod_perl�Ǽ¹Բ�ǽ��			# comment
	# �����Х�ؿ������								# comment
%::functions = (
	"dbmname" => \&dbmname,
	"undbmname" => \&undbmname,
	"htmlspecialchars" => \&htmlspecialchars,
	"javascriptspecialchars" => \&javascriptspecialchars,
	"encode" => \&encode,
	"make_link" => \&make_link,
	"authadminpassword" => \&authadminpassword,
	"code_convert" => \&code_convert,
	"http_header" => \&http_header,
	"load_module" => \&load_module,
	"make_link_url" => \&make_link_url,
	"make_link_mail" => \&make_link_mail,
	"make_link_image" => \&make_link_image,
	"getremotehost" => \&getremotehost,
	"date" => \&date,									# nocompact
	"dbopen" => \&dbopen,								# nocompact
	"dbopen_gz" => \&dbopen_gz,							# nocompact
	"dbclose" => \&dbopen,								# nocompact
	"decode" => \&decode,								# nocompact
	"encode" => \&encode,								# nocompact
);

%::values=();

# �����󥿤γ�ĥ��										# comment

$::counter_ext = '.count';
my $lastmod;			# v0.0.9

%::database;			# database						# comment
%::infobase;			# infobase						# comment
%::diffbase;			# diffbase						# comment
%::backupbase;			# backupbase#nocompact			# comment
%::interwiki;			# interwiki						# comment
$::pageplugin=0;		# is page editing plugin flag	# comment

%::_plugined;			# 1:Pyuki/2:Yuki/0:None			# comment
%::_exec_plugined;		# 2:Inited/1:Loaded/0:None		# comment
%::_exec_plugined_func;	# override functions			# comment
%::_exec_plugined_value;# override values				# comment
%::_module_loaded;		# perl module					# comment
%::_resource_loaded;	# module						# comment

@::navi=();				# default navigator link array	# comment
@::addnavi=();			# adding navigator link array	# comment
%::navi=();				# navigator link				# comment
%::dtd;					# dtd define					# comment

%::_urlescape;			# for &encode					# comment
%::_dbmname_encode;		# for &dbmname					# comment
%::_dbmname_decode;		# for &undbmname				# comment

%::_date_ampm;			# for &date						# comment
%::_date_ampm_locale;
%::_date_weekday;
%::_date_weekdaylength;
%::_date_weekday_locale;
%::_date_weekdaylength_locale;

$::HTTP_HEADER;			# http header							# comment
$::IN_HEAD;				# adding <head>~</head> from plugin		# comment
$::IN_BODY;				# adding <body> tag from plugin			# comment
$::IN_TITLE;			# adding <title> tag from plugin		# comment
$::IN_META_ROBOTS;		# robots control						# comment

$::Token='';

$::is_xhtml;			# XHTML Flag							# comment
$gzip_header;			# gzip commpression header				# comment
$explugin_last;			# Ex Plugin Last Exec Module			# comment
@::loaded_explugin;		# Loaded Ex Plugin						# comment

# 2006.1.30 pochi: ���ԥ⡼�ɤ�����								# comment
$::lfmode;
$::escapeoff_exec;		# Disable ESC key for IE				# comment

@::notes = ();

	# ini�ե������ɤ߹���										# comment
$::ini_file = 'pyukiwiki.ini.cgi' if($::ini_file eq '');
require $::ini_file;
require $::setup_file if (-r $::setup_file);

	# ������ե�����ν����									# comment
&skin_init;

##############################									# comment
	# WikiName													# comment
#$::wiki_name = '\b([A-Z][a-z]+([A-Z][a-z]+)+)\b';				# comment
$::wiki_name = '\b([A-Z][a-z]+[A-Z][a-z]+)\b';

	# [[BracketName]]											# comment
#my $bracket_name = '\[\[([^\]]+?)\]\]';						# comment
$::bracket_name ='\[\[((?!\[)[^\]]+?)\]\]';

	# InterWiki���												# comment
$::interwiki_definition = '\[((?!\[)\S+?)\ (\S+?)\](?!\])';	# ? \[\[(\S+) +(\S+)\]\]
$::interwiki_definition2 = '\[((?!\[)\S+?)\ (\S+?)\](?!\])\ (utf8|euc|sjis|yw|asis|raw|moin)';

	# InterWiki�Υ��											# comment
$::interwiki_name1 = '([^:]+):([^:].*)';
$::interwiki_name2 = '([^:]+):([^:#].*?)(#.*)?';

	# URL������ɽ��												# comment
if($::useFileScheme eq 1) {
	$::isurl=q(s?(?:(?:(?:https?|ftp|news)://)|(?:file:[/\x5c][/\x5c]))(?:[-\x5c_.!~*'a-zA-Z0-9;/?:@&=+$,%#]+));
} else {
	$::isurl=qq(s?(?:https?|ftp|news)://[-_.!~*'a-zA-Z0-9;/?:@&=+$,%#]+);
}

	# �᡼�륢�ɥ쥹������ɽ��									# comment
$::ismail=q((?:[^(\040)<>@,;:&#"'.\\\[\]\000-\037\x80-\xff](?:[^(\040)<>@,;:&#".\\\[\]\000-\037\x80-\xff])*(?![^(\040)<>@,;:&#".\\\[\]\000-\037\x80-\xff])|["'][^\\\x80-\xff\n\015"]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015"]*)*["'])(?:\.(?:[^(\040)<>@,;:&#"'.\\\[\]\000-\037\x80-\xff](?:[^(\040)<>@,;:&#".\\\[\]\000-\037\x80-\xff])*(?![^(\040)<>@,;:&#".\\\[\]\000-\037\x80-\xff])|["'][^\\\x80-\xff\n\015"]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015"]*)*["']))*\.?@(?:[^(\040)<>@,;:&#"'.\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:&#"'.\\\[\]\000-\037\x80-\xff])|\[(?:[^\\\x80-\xff\n\015\[\]]|\\[^\x80-\xff])*\])(?:\.(?:[^(\040)<>@,;:&#"'.\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:&#"'.\\\[\]\000-\037\x80-\xff])|\[(?:[^\\\x80-\xff\n\015\[\]]|\\[^\x80-\xff])*\])));

	# ����ȥ��Ѥ� dot ��¸�ߤ��ʤ��ɥᥤ����					# comment
$::ismail.=$::IntraMailAddr eq 0 ? '+' : '*';

	# ������ĥ�Ҥ�����ɽ��										# comment
$::image_extention=qq(([Gg][Ii][Ff]|[Pp][Nn][Gg]|[Jj][Pp](?:[Ee])?[Gg]));

##############################									# comment
	# �֥�å����ץ饰����										# comment
$::embed_plugin = '^\#([^\(]+)(\((.*)\))?';
$::embedded_name = '(\#.+?)';
	# ����饤�󷿥ץ饰����									# comment
#	$::embed_inline = '(&amp;[^;&]+;|&amp;[^)]+\))';			# comment
	$::embedded_inline='&amp;(?:([^(;{]+)(?:[()\s?]*?)\s?\{\s?([^&}]*?)\s?\}|([^(;{]+)|([^(;{]+)\s?\(\s?([^)]*?)\s?\)|([^(;{]+)\s?\(\s?([^)]*?)\s?\)\s?\{\s?([^&}]*?)\s?\});';
	$::embedded_inline='&amp;(?:([^(;{]+)(?:[()\s?]*?)\s?\{\s?([^&}]*?)\s?\}|([^(;{]+)|([^(;{]+)\s?\(\s?([^)]*?)\s?\)|([^(;{]+)\s?\(\s?([^)]*?)\s?\)\s?\{\s?([^&}]*?)\s?\});';													# comment

##############################									# comment
	# InfoBas�ι���̾											# comment
$::info_ConflictChecker = 'ConflictChecker';
$::info_LastModified = 'LastModified';
$::info_CreateTime='CreateTime';
$::info_LastModifiedTime='LastModifiedTime';
$::info_UpdateTime='UpdateTime';
$::info_IsFrozen = 'IsFrozen';
$::info_AdminPassword = 'AdminPassword';
##############################									# comment

	# ����ڡ���̾												# comment
%::fixedpage = (
	$::AdminPage => 'admin',
	$::ErrorPage => '',
	$::RecentChanges => 'recent',
	$::IndexPage => 'list',
	$::SearchPage => 'search',
	$::CreatePage => 'newpage',
);

	# �Խ��Բĥץ饰����										# comment
%::fixedplugin = (
	'newpage' => 1,
	'search' => 1,
	'list' => 1,
);

	# HTML���������פΥơ��֥�									# comment
%::_htmlspecial = (
	'&' => '&amp;',
	'<' => '&lt;',
	'>' => '&gt;',
	'"' => '&quot;',
);

	# HTML���󥨥������פΥơ��֥�								# comment
%::_unescape = (
	'amp'  => '&',
	'lt'   => '<',
	'gt'   => '>',
	'quot' => '"',
);

	# ��ʸ���Υơ��֥�											# comment
%::_facemark = (
	' :)'		=> 'smile',
	' (^^)'		=> 'smile',
	' :D'		=> 'bigsmile',
	' (^-^)'	=> 'bigsmile',
	' :p'		=> 'huh',
	' :d'		=> 'huh',
	' XD'		=> 'oh',
	' X('		=> 'oh',
	' ;)'		=> 'oh',
	' (;'		=> 'wink',
	' (^_-)'	=> 'wink',
	' ;('		=> 'sad',
	' :('		=> 'sad',
	' (--;)'	=> 'sad',
	' (^^;)'	=> 'worried',
	'&heart;'	=> 'heart',
	'&bigsmile;'=> 'bigsmile',
	'&huh;'		=> 'huh',
	'&oh;'		=> 'oh',
	'&sad;'		=> 'sad',
	'&smile;'	=> 'smile',
	'&wink;'	=> 'wink',
	'&worried;' => 'worried',
);

	# ��ʸ��������ɽ��											# comment
$::_facemark=q{\ \(--\;\)|\ \(\;|\ \(\^-\^\)|\ \(\^\^\)|\ \(\^\^\;\)|\ \(\^_-\)|\ \:\(|\ \:\)|\ \:D|\ \:d|\ \:p|\ \;\(|\ \;\)|\ X\(|\ XD|\&heart\;};
$::_facemark.=q{|\&bigsmile\;|\&huh\;|\&oh\;|\&sad\;|\&smile\;|\&wink\;|\&worried\;} if($::usePukiWikiStyle eq 1);

	# SGML�δ�ʸ���Υ��������ץ����ɤμ��λ��Ȥ�����ɽ��		# comment
$::_sgmlescape=q{amp|nbsp|iexcl|cent|pound|curren|yen|brvbar|sect|uml|copy|ordf|laquo|not|shy|reg|macr|deg|plusmn|sup2|sup3|acute|micro|para|middot|cedil|sup1|ordm|raquo|frac14|frac12|frac34|iquest|Agrave|Aacute|Acirc|Atilde|Auml|Aring|AElig|Ccedil|Egrave|Eacute|Ecirc|Euml|Igrave|Iacute|Icirc|Iuml|ETH|Ntilde|Ograve|Oacute|Ocirc|Otilde|Oumltimes|Oslash|Ugrave|Uacute|Ucirc|Uuml|Yacute|THORN|szlig|agrave|aacute|acirc|atilde|auml|aring|aelig|ccedil|egrave|eacute|ecirc|euml|igrave|iacute|icirc|iuml|eth|ntilde|ograve|oacute|ocirc|otilde|ouml|divide|oslash|ugrave|uacute|ucirc|uuml|yacute|thorn|yuml|euro|dagger|Dagger|bull|trade|permil|lsquo|rsquo|sbquo|ldquo|rdquo|bdquo|mdash|ndash|smile|bigsmile|huh|oh|wink|sad|worried|heart};

	# �������ޥ��												# comment
my %command_do = (
	read => \&do_read,
	write => \&do_write,
);

&main;
exit(0);
##############################									# comment

=head1 NAME

wiki.cgi - This is PyukiWiki, yet another Wiki clone.

=head1 DESCRIPTION

PyukiWiki is yet another Wiki clone. Based on YukiWiki

PyukiWiki can treat Japanese WikiNames (enclosed with [[ and ]]).
PyukiWiki provides 'InterWiki' feature, RDF Site Summary (RSS),
and some embedded commands (such as [[# comment]] to add comments).

=head1 SEE ALSO

=over 4

=item PyukiWiki/Dev/Specification/wiki.cgi

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Dev/Specification/wiki.cgi/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/wiki.cgi?view=log>

=back

=head1 AUTHOR

=over 4

=item Nekyo

L<http://nekyo.qp.land.to/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sfjp.jp/>

=back

=head1 LICENSE

Copyright (C) 2004-2012 by Nekyo.

Copyright (C) 2005-2012 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

=lang ja

=head1 FUNCTIONS

=head2 main

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

�Բ�

=item ����

PyukiWiki�ν�����򤹤롣

=back

=cut

sub main {
	&writablecheck;
	&getbasehref;
	&init_lang;
	&init_dtd;
	&init_global;

	# CGI.pm�ν����										# comment
	$qCGI=new CGI;

	# ����꥽�������ɤ߹���								# comment
	%::resource = &read_resource("$::res_dir/resource.$::lang.txt");

	# ����ʸ����ν����									# comment
	&dateinit;

	# �ѿ������											# comment
	$::HTTP_HEADER = '';
	$::IN_HEAD = '';
	if($::P3P ne '') {
		$::HTTP_HEADER.=qq(P3P: CP="$::P3P"\n);
	}

	# &check_modifiers;										# comment
	&open_db;				# DB�򳫤�						# comment
	&init_form;				# �ե�����ν����				# comment
	&init_InterWikiName;	# interwiki�ν����				# comment
	&init_inline_regex;		# ����饤������ɽ���ν����	# comment

	# Ex�ץ饰����(*.inc.cgi)�ε�ư							# comment
	&exec_explugin if($::useExPlugin > 0);

	# gzip���̽����										# comment
	&gzip_init;

	# �������ޥ��(cmd=read, cmd=write)�ε�ư				# comment
	my $ret=1;
	if ($command_do{$::form{cmd}}) {
		$ret=&{$command_do{$::form{cmd}}};
	}
	# ���������ץ饰����(?cmd=)�ε�ư						# comment
	if($ret eq 1) {
		if (&exec_plugin == 1) {
			$::form{mypage} = $::FrontPage if (!$::form{mypage});
			$::pageplugin=1;
			&do_read;
		}
	}
	# DB���Ĥ���											# comment
	&close_db;
}

=lang ja

=head1 FUNCTIONS

=head2 writablecheck

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

�Բ�

=item ����

�񤭹��߲�ǽ�������å�����ؿ�

=back

=cut

sub writablecheck {
	my $err;
	$err.=&writechk($::data_dir);
	$err.=&writechk($::diff_dir);
	$err.=&writechk($::cache_dir);
	$err.=&writechk($::counter_dir);
	$err.=&writechk($::backup_dir);#nocompact
	$err.=&writechk($::upload_dir);
	if($err ne '') {
		&print_error($err);
	}
}

=lang ja

=head1 FUNCTIONS

=head2 writechk

=over 4

=item ������

�ǥ��쥯�ȥ�

=item ����

���顼��å�����

=item �����С��饤��

�Բ�

=item ����

�񤭹��߲�ǽ�������å�����ᥤ��δؿ�

=back

=cut

sub writechk {
	my($dir)=shift;
	return "Directory is not found or not writable ($dir)<br />\n"
		if(!-w $dir);
	return '';
}

=lang ja

=head2 gzip_init

=over 4

=item ������

�ʤ�

=item ����

$::gzip_header

=item �����С��饤��

�Բ�

=item ����

gzip����ɸ��⥸�塼��

=back

=cut

sub gzip_init {
	my $gzip_exec=1;
	# force init setting.inc.cgi
	&exec_explugin_sub("setting")  if($::useExPlugin > 0);
	$::gzip_header='';
	if($::setting_cookie{gzip} ne '') {
		$gzip_exec=0 if($::setting_cookie{gzip}+0 eq 0);
	}

	my $gzip_command='gzip';
	if($gzip_exec eq 1) {
		# auto search too slow...
		if($::gzip_path eq 'nouse') {
			$::gzip_path='';
		} elsif($::gzip_path eq '') {
			my $forceflag="";
			my $fastflag="";
			foreach(split(/:/,$ENV{PATH})) {
				if(-x "$_/$gzip_command") {
					$::gzip_path="$_/$gzip_command" ;
					if(open(PIPE,"$::gzip_path --help 2>&1|")) {
						foreach(<PIPE>) {
							$forceflag="--force" if(/(\-\-force)/);
							$fastflag="--fast" if(/(\-\-fast)/);
						}
						close(PIPE);
					}
				}
			}
			if($::gzip_path ne '') {
				$gzip_path="$::gzip_path $fastflag $forceflag";
				$::debug.="auto detect gzip path : \"$gzip_path\"\n";	# debug
			} elsif(&load_module("Compress::Zlib")) {
				$::gzip_path="zlib";
				$::debug.="auto detect Compress::Zlib";	# debug
			}
		}

		my $test=$::gzip_path;
		$test=~s/ //g;
		if ($test ne '') {
			if(($ENV{'HTTP_ACCEPT_ENCODING'}=~/gzip/)) {
				if($ENV{'HTTP_ACCEPT_ENCODING'}=~/x-gzip/) {
					$::gzip_header="Content-Encoding: x-gzip\n";
				} else {
					$::gzip_header="Content-Encoding: gzip\n";
				}
			$::HTTP_HEADER.="$::gzip_header";
			}
		}
	}
}

=lang ja

=head2 init_global

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

�Բ�

=item ����

speedy_cgi�Ǽ¹Բ�ǽ�ˤ��뤿��ν������

������������speedy_cgi�Ǥ�ư��ϥ��ݡ��Ȥ���Ƥ��ʤ���

=back

=cut

	# 2005.10.27 pochi: speedy_cgi�Ǽ¹Բ�ǽ��				# comment

sub init_global {
	&close_db;
	%::form = ();
	%::database = ();
	%::infobase = ();
	%::diffbase = ();
	%::interwiki = ();
	%::_resource_loaded = ();
	$lastmod = "";
	%::_plugined = ();
	$::pageplugin=0;
	%::_exec_plugined=();
	%::_exec_plugined_func=();
	%::_exec_plugined_value=();
	%::_module_loaded=();
	# 0��255�Υơ��֥�����
	# 0��255�Υơ��֥�����
	foreach my $i (0x00 .. 0xFF) {
		$::_urlescape{chr($i)} = sprintf('%%%02x', $i);
		$::_dbmname_encode{chr($i)} = sprintf('%02X', $i);
		$::_dbmname_decode{sprintf('%02X', $i)} = chr($i);
	}
}

=lang ja

=head2 init_lang

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

����ν�����򤹤롣

=back

=cut

sub init_lang {
	if ($::lang eq 'ja') {
		$::defaultcode='euc';	# do not change
		if(lc $::charset eq 'utf-8') {
			$::kanjicode='utf8';
		} else {
			$::charset=(
				$::kanjicode eq 'euc' ? 'EUC-JP' :
				$::kanjicode eq 'utf8' ? 'UTF-8' :
				$::kanjicode eq 'sjis' ? 'Shift-JIS' :
				$::kanjicode eq 'jis' ? 'iso-2022-jp' : '')
		}
	# ������ν���								# comment
	} elsif ($::lang eq 'zh') {	# cn is not allow, use zh	# comment
		$::defaultcode='gb2312';
		$::charset = 'gb2312' if(lc $::charset ne 'utf-8');
	# ���Ѹ���ν���								# comment
	} elsif ($::lang eq 'zh-tw') {
		$::defaultcode='big5';
		$::charset = 'big5' if(lc $::charset ne 'utf-8');
	# �ڹ����ν���								# comment
	} elsif ($::lang eq 'ko' || $::lang eq 'kr') {
		$::defaultcode='euc-kr';
		$::charset = 'euc-kr' if(lc $::charset ne 'utf-8');
	# ����¾										# comment
	} else {
		$::defaultcode='iso-8859-1';
		$::charset = 'iso-8859-1' if(lc $::charset ne 'utf-8');
	}
	# $::modifierlink��¸�ߤ��ʤ��������URL������			# comment
	$::modifierlink=$::basehref if($::modifierlink eq '');
}

=lang ja

=head2 init_dtd

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

DTD�ν�����򤹤롣

=back

=cut

sub init_dtd {
	# DTD�ν����										# comment
	%::dtd = (
		"html4"=>qq(<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">\n<html lang="$::lang">\n<head>\n<meta http-equiv="Content-Language" content="$::lang" />\n<meta http-equiv="Content-Type" content="text/html; charset=$::charset" />\n<meta http-equiv="Content-Style-Type" content="text/css" />\n<meta http-equiv="Content-Script-Type" content="text/javascript" />),
		"xhtml11"=>qq(<?xml version="1.0" encoding="$::charset" ?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="$::lang">\n<head>),
		"xhtml10"=>qq(<?xml version="1.0" encoding="$::charset" ?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml" lang="$::lang" xml:lang="$::lang">\n<head>\n<meta http-equiv="Content-Language" content="$::lang" />\n<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=$::charset" />),
		"xhtml10t"=>qq(<?xml version="1.0" encoding="$::charset" ?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml" lang="$::lang" xml:lang="$::lang">\n<head>\n<meta http-equiv="Content-Language" content="$::lang" />\n<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=$::charset" />),
		"xhtmlbasic10"=>qq(<?xml version="1.0" encoding="$::charset" ?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.0//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic10.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="$::lang">\n<head>\n<meta http-equiv="Content-Language" content="$::lang" />\n<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=$::charset" />),
	);

	$::dtd=$::dtd{$::htmlmode};
	$::dtd=$::dtd{html4} if($::dtd eq '') || &is_no_xhtml(0);
	$::dtd.=qq(\n<meta name="generator" content="PyukiWiki $::version" />\n);

	# XHTML�Ǥ��뤫�Υե饰������							# comment
	$::is_xhtml=$::dtd=~/xhtml/;
}

=lang ja

=head2 is_no_xhtml

=over 4

=item ������

HTTP�إå��Ǥ���У���DTD�Ǥ����0

=item ����

XHTML���б��֥饦���Ǥϣ����֤�

��������ʤ��Ȼפ���֥饦�����Ǥϣ����֤���

=item �����С��饤��

��

=item ����

XHTML���б��֥饦����Ƚ�ꤹ�롣

=back

=cut

sub is_no_xhtml {
	my ($mode)=shift;

	# HTTP�إå�����ǧ�����뤫							# comment
	if($mode eq 1) {
		if($ENV{HTTP_USER_AGENT}=~/Opera\/(\d+)\.(\d+)/) {
			return 0 if($1 > 8);
		}
		if($ENV{HTTP_USER_AGENT}=~/MSIE (\d+).(\d+)/) {
			return 0 if($1 >= 9);
		}
		if($ENV{HTTP_USER_AGENT}=~/Fire[Ff]ox\/(\d+)\./) {
			return 0 if($1 >= 3);
		}
		if($ENV{HTTP_USER_AGENT}=~/Chrome\/(\d+)\./) {
			return 0 if($1 >= 10);
		}
		if($ENV{HTTP_USER_AGENT}=~/Version\/(\d+).+Safari/) {
			return 0 if($1 > 4);
		}
		# Netscape and �����֥饦��						# comment
		if($ENV{HTTP_USER_AGENT}=~/Mozilla\/(\d+)\./ || $ENV{HTTP_USER_AGENT}=~/Netscape/) {
			return 1;
		}
		# robots (�ʰ�)									# comment
		if($ENV{HTTP_USER_AGENT}=~/[Bb]ot|Slurp|Yeti|ScSpider|ask/) {
			return 1; # �����ơ�text/html�إå��������	# comment
		}
		return 1;
	}

	# XHTML�����Τ�ǧ�����뤫							# comment
	if($ENV{HTTP_USER_AGENT}=~/Opera\/(\d+)\.(\d+)/) {
		return 0 if($1 > 6);
	}
	if($ENV{HTTP_USER_AGENT}=~/MSIE (\d+.\d+)/) {
		return 0 if($1 >= 4);
	}
	if($ENV{HTTP_USER_AGENT}=~/Fire[Ff]ox\/(\d+)\./) {
		return 0 if($1 >= 3);
	}
	if($ENV{HTTP_USER_AGENT}=~/Chrome\/(\d+)\./) {
		return 0 if($1 >= 1);
	}
	if($ENV{HTTP_USER_AGENT}=~/Version\/(\d+).+Safari/) {
		return 0 if($1 > 3);
	}
	# Netscape and �����֥饦��
	if($ENV{HTTP_USER_AGENT}=~/Mozilla\/(\d+)\./ || $ENV{HTTP_USER_AGENT}=~/Netscape/) {
		return 1;
	}
	# robots (�ʰ�)										# comment
	if($ENV{HTTP_USER_AGENT}=~/[Bb]ot|Slurp|Yeti|ScSpider|ask/) {
		return 0;
	}
	return 1;
}


=lang ja

=head2 exec_plugin

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

�Բ�

=item ����

Plugin���ɤ߹��ߡ�������򤹤롣

=back

=cut

sub exec_plugin {
	my $exec = 1;
	if ($::form{cmd}) {
		if (&exist_plugin($::form{cmd}) == 1) {
			my $action = "\&plugin_" . $::form{cmd} . "_action";
			my %ret = eval $action;
			$::debug.=$@;
			if (($ret{msg} ne '') && ($ret{body} ne '')) {
				$::HTTP_HEADER.=$ret{http_header};
				$::IN_HEAD.=$ret{header};
				$::IN_BODY.=$ret{bodytag};
				$exec = 0;
				$::allview = 0 if($ret{notviewmenu} eq 1);
				$::pageplugin=1 if($ret{ispage} eq 1);
				&skinex($ret{msg}, $ret{body});
			}
		}
	}
	return $exec;
}

=lang ja

=head2 exec_explugin

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

�Բ�

=item ����

ExPlugin���ɤ߹��ߡ�������򤹤롣

=back

=cut

sub exec_explugin {
	# /lib/*.inc.cgi�򸡺��������٤Ƽ¹�				# comment
	opendir(DIR,"$::explugin_dir");
	while(my $dir=readdir(DIR)) {
		if($dir=~/(.*?)\.inc\.cgi$/) {
			next if($1 eq 'gzip'); # gzip.inc.cgi �ѻߤ�ȼ��	# comment
			my $explugin=$1;
			&exec_explugin_sub($explugin);
		}
	}
}

=lang ja

=head2 exec_explugin_sub

=over 4

=item ������

explugin̾��

=item ����

�ʤ�

=item �����С��饤��

�Բ�

=item ����

ExPlugin���ɤ߹��ߡ�������򤹤롢exec_explugin�ؿ��Υ��ִؿ�

=back

=cut

sub exec_explugin_sub {
	my($explugin)=@_;
	foreach(@::loaded_explugin) {
		return if($explugin eq $_);
	}
	if (&exist_explugin($explugin) eq 1) {
		# init�᥽�åɤμ¹�							# comment
		$::debug.="Load Explugin $explugin\n";			# debug
		my $action = "\&plugin_" . $explugin . "_init";
		push(@::loaded_explugin,$explugin);
		my %ret = eval $action;
		$::debug.=$@;
		$::_exec_plugined{$explugin} = 2 if($ret{init}); #execed	# comment
		# ��ʣ�ؿ��θ���								# comment
		foreach(split(/,/,$ret{func})) {
			if($_exec_plugined_func{$_} ne '' ) {
				&skinex("\t\t$ErrorPage","$::resource{dupexplugin}<ul><li>$_exec_plugined_func{$_}<li>$explugin</li></ul>");
				exit;
			}
			$_exec_plugined_func{$_}=$explugin;
			$::functions=$ret{$_};
		}
		# ��ʣ��񤭴ؿ��θ���							# comment
		foreach(split(/,/,$ret{value})) {
			if($_exec_plugined_value{$_} ne '' ) {
				&skinex("\t\t$ErrorPage","$::resource{dupexplugin}<ul><li>$_exec_plugined_value{$_}<li>$explugin</li></ul>");
				exit;
			}
			$_exec_plugined_value{$_}=$explugin;
			$::values=$ret{$_};
		}
		# �إå�������									# comment
		$::HTTP_HEADER.="$ret{http_header}\n";
		$::IN_HEAD.=$ret{header};
		$::IN_BODY.=$ret{bodytag};

		# ��λ���ؿ�������								# comment
		$explugin_last.="$ret{last_func},";
		# msg, body �������ɽ�����ƽ�λ�ʥ��顼�����ѡ�	# comment
		if (($ret{msg} ne '') && ($ret{body} ne '')) {
			$exec = 0;
			&skinex($ret{msg}, $ret{body});
			exit;
		}
	}
}

=lang ja

=head2 skin_init

=over 4

=item ������

�ʤ�

=item ����

$::skin_file,
$::skin{default_css},
$::skin{print_css},
$::skin{common_js},

=item �����С��饤��

�Բ�

=item ����

������ե������¸�ߤ�����å�����skin.cgi�ؤν���ͤ򥻥åȤ��롣

=back

=cut

sub skin_init {
	$::skin_file="$::skin_dir/" . &skin_check("$::skin_name.skin%s.cgi",".$::lang","");
	$::skin{default_css}=&skin_check("$::skin_name.default%s.css",".$::lang","");
	$::skin{print_css}=&skin_check("$::skin_name.print%s.css",".$::lang","");
	$::skin{common_js}=&skin_check("common%s.js",".$::kanjicode.$::lang",".$::lang");
}

=lang ja

=head2 skin_check

=over 4

=item ������

&skin_check(filename of sprintf format, lists...);

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�������ɬ�פʥե����뤬¸�ߤ��뤫�����å����롣

=back

=cut

sub skin_check {
	my($file)=@_;
	foreach(@_) {
		my $f=sprintf($file,$_);
		return $f if(-f "$::skin_dir/$f");
	}
	die sprintf("$file not found","");
	exit;
}

=lang ja

=head2 init_inline_regex

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

����饤��ǥ�󥯤��뤿�������ɽ�����������롣

=back

=cut

sub init_inline_regex {
	$::inline_regex =qq(($bracket_name)|($embedded_inline));
	$::inline_regex.=qq(|($::isurl))				# Direct URL	# comment
		if($::autourllink eq 1);
	$::inline_regex.=qq(|(mailto:$ismail)|($ismail))# Mail			# comment
		if($::automaillink eq 1);
	$::inline_regex.=qq(|($wiki_name)) # LocalLinkLikeThis (WikiName) # comment
		if($::nowikiname ne 1);
}

=lang ja

=head2 skinex

=over 4

=item ������

&skinex(�ڡ���̾, ����(HTML), �ڡ����Ǥ��뤫�Υե饰, �ڡ������Υץ饰����Ǥ��뤫�Υե饰);

=item ����

stdout��HTML�����

=item �����С��饤��

��

=item ����

���ꤷ���ڡ����ޤ������Ƥ������������Ϥ��롣

=back

=cut

sub skinex {
	my ($pagename, $body, $is_page, $pageplugin) = @_;
	my $bodyclass = "normal";
	my $editable = 0;
	my $admineditable = 0;
	my ($page,$msg)=split(/\t/,$pagename);
	$pageplugin+=0;
	$::pageplugin+=0;

#	if (&is_frozen($page) and ($::form{cmd} =~ /^(read|write)$/ || $pageplugin+$::pageplugin > 0)) { # comment
	if($::form{refer} eq '' && &is_frozen($page) || &is_exist_page($::form{refer}) && &is_frozen($::form{refer})) {
		$admineditable = 1;
		$bodyclass = "frozen";
#	} elsif (&is_editable($page) and ($::form{cmd} =~ /^(read|write)$/ || $pageplugin+$::pageplugin>0)) { # comment
	} elsif($::form{refer} eq '' && &is_editable($page) || &is_exist_page($::form{refer}) && &is_editable($::form{refer})) {

		$admineditable = 1;
		$editable = 1;
		if(!&is_exist_page($page) && $is_page) {
			$page=$pagename=$::FrontPage;
			if($::form{mypreview_cancel} ne '') {
				if(&is_exist_page($::form{refer}) && $::form{refer} ne '') {
					$page=$pagename=$::form{refer};
				}
			}
			$body=&text_to_html($::database{$pagename});
			$is_page=1;
			$admineditable=1;
			$editable=&is_frozen($pagename) ? 1 : 0;
		}
	}
	&makenavigator($::form{mypage} ne $page ? $::form{mypage} : $page,$is_page,$editable,$admineditable);

	# last_modified��HTML����								# comment
	if ($::last_modified != 0) {	# v0.0.9
		$lastmod = &date($::lastmod_format, (stat($::data_dir . "/" . &dbmname($::form{mypage}) . ".txt"))[9]);
	}


	if($::IN_META_ROBOTS eq '') {
		$::IN_HEAD.=&meta_robots($::form{cmd},$pagename,$body);
	} else {
		$::IN_HEAD.=$::IN_META_ROBOTS;
	}

	my $output_mime = $::htmlmode eq "xhtml11"
		&& $ENV{'HTTP_ACCEPT'}=~ m!application/xhtml\+xml!
		&& &is_no_xhtml(1) eq 0
		? 'application/xhtml+xml' : 'text/html';

	$::HTTP_HEADER=&http_header("Content-type: $output_mime; charset=$::charset", $::HTTP_HEADER);

	require $::skin_file;
	$::IN_HEAD.=<<EOM if($::rss_lines>0 && $::IN_HEAD!~/rss\+xml/);
<link rel="alternate" type="application/rss+xml" title="RSS" href="?cmd=rss10@{[$_exec_plugined{lang} > 1 ? "&amp;lang=$::lang" : ""]}" />
EOM
	my $body=&skin($pagename, $body, $is_page, $bodyclass, $editable, $admineditable, $::basehref,$lastmod);
	$body=&_db($body);

	if($::lang eq 'ja' && $::defaultcode ne $::kanjicode) {
		$body=&code_convert(\$body, $::kanjicode);
	}
	&escapeoff if($::use_escapeoff > 0 && $::escapeoff_exec ne 1);
	&content_output($::HTTP_HEADER, $body);
}

=lang ja

=head2 topicpath

=over 4

=item ������

�ʤ�

=item ����

���ʸ����

=item �����С��饤��

��

=item ����

�����ȥ��URL,�ޤ���topicpath��ɽ�����롣

�ץ饰���� topicpath.inc.pl�������硢��ư�ɤ߹��ߤ򤹤롣

=back

=cut

sub topicpath {
	my ($title)=@_;
	$title=$::form{mypage} if($title eq '');
	my $buf;
	if($::useTopicPath eq 1 && &exist_plugin("topicpath") ne 0) {
		$buf=&plugin_topicpath_inline("1,$title") if(&is_exist_page($title));
	}
	if($buf eq '') {
		my $cookedurl=$::basehref . '?' . &encode($title);
		return qq(<a href="$cookedurl">$cookedurl</a>);
	}
	return $buf;
}

=lang ja

=head2 makenavigator

=over 4

=item ������

&makenavigator(�ڡ���̾, �ڡ����Ǥ��뤫�Υե饰, �Խ���ǽ�ե饰, �������Խ���ǽ�ե饰);

=item ����

@::navi

=item �����С��饤��

��

=item ����

�ʥӥ�������ʸ���󡢥���衢�����ե�������������롣

=back

=cut

sub makenavigator {
	my($pagename,$is_page,$editable,$admineditable)=@_;

	my($page,$message,$errmessage)=split(/\t/,$pagename);
	my $cookedpage = &encode($page);

	# ��󥯤�����											# comment
	my $refer=&encode($::form{refer} eq '' ? $::form{mypage} : $::form{refer});
	my $mypage=&encode($::form{refer} eq '' ? $page : $::form{refer});

	&makenavigator_sub1("newpage","refer",$mypage);
	if($::form{refer} eq '' || &is_exist_page($::form{refer})) {
		&makenavigator_sub1("edit","mypage",$mypage)
			if($editable);
		if($admineditable) {
			&makenavigator_sub1("adminedit","mypage",$mypage);
			&makenavigator_sub1("diff","mypage",$mypage);
			if($::useBackUp eq 1) {#nocompact
				&makenavigator_sub1("backup","mypage",$mypage);#nocompact
			}#nocompact
			&makenavigator_sub1("attach","mypage",$mypage) if($::file_uploads > 0);
			&makenavigator_sub1("rename","refer",$mypage);
		}
	}
	&makenavigator_sub1("sitemap","refer",$refer)
		if($::use_Sitemap eq 1 && -f "$::plugin_dir/sitemap.inc.pl");
	&makenavigator_sub1("list","refer",$refer);
	&makenavigator_sub1("search","refer",$refer);
	&makenavigator_sub1("recent","refer",$refer);

	&makenavigator_sub2("top",$::FrontPage);
	&makenavigator_sub2("reload",$::form{refer} eq '' ? $page : $::form{refer});
	if($::use_HelpPlugin eq 0) {
		&makenavigator_sub2("help",$::resource{help});
	} else {
		$::resource{helpbutton}=$::resource{help};
		&makenavigator_sub1("help","refer",$refer);
	}
	&makenavigator_sub3("rss10");
#	&makenavigator_sub3("rss20");							# comment

	# ��󥯤��¤ӽ������									# comment
	my @naviindex;
	my $backupnavi="";#compact
	my $backupnavi="backup" if($::useBackUp);#nocompact
	if($::naviindex eq 0) {
		@naviindex=(#compact
			"reload","","newpage","edit","adminedit","diff","attach","",#compact
			"top","list","sitemap","search","recent","help",#compact
			"rss10","rss20","atom","opml");#compact
		@naviindex=(#nocompact
			"reload","","newpage","edit","adminedit","diff",$backupnavi,"attach","",#nocompact
			"top","list","sitemap","search","recent","help",#nocompact
			"rss10","rss20","atom","opml");#nocompact

	} else {

		@naviindex=(#compact
			"top","","edit","adminedit","diff","attach","reload","",#compact
			"newpage","list","sitemap","search","recent","help",#compact
			"rss10","rss20","atom","opml");#compact
		if($::useBackUp) {#nocompact
			@naviindex=(#nocompact
				"top","","edit","adminedit","diff",$backupnavi,"attach","reload","",#nocompact
				"newpage","list","sitemap","search","recent","help",#nocompact
				"rss10","rss20","atom","opml");#nocompact
		} else {#nocompact
			@naviindex=(#nocompact
				"top","","edit","adminedit","diff",$backupnavi,"attach","reload","",#nocompact
				"newpage","list","sitemap","search","recent","help",#nocompact
				"rss10","rss20","atom","opml");#nocompact
		}#nocompact
	}

	# �ɲå�󥯤�����										# comment
	foreach(@naviindex) {
		foreach my $addnavi(@::addnavi) {
			my($index,$before,$next)=split(/:/,$addnavi);
			push(@::navi,$index) if($_ eq $before && $before ne '');
		}
		push(@::navi,$_) if($::navi{"$_\_url"} ne '' || $_ eq '');
		foreach my $addnavi(@::addnavi) {
			my($index,$before,$next)=split(/:/,$addnavi);
			push(@::navi,$index) if($_ eq $next && $next ne '');
		}
	}
	# �إ�פ���Ѥ��ʤ����								# comment
	my @navitemp;
	if($::no_HelpLink eq 1) {
		foreach (@::navi) {
			push(@navitemp,$_)
				if($_ ne "help");
		}
		@::navi=@navitemp;
	}
}

sub makenavigator_sub1 {
	my($t,$r,$p)=@_;
	if($t ne '') {
		if($::navi{$t."_url"} eq '') {
			$::navi{$t."_title"}=$::resource{$t."thispage"};
			$::navi{$t."_title"}=$::resource{$t."button"}
				if($::navi{$t."_title"} eq '');
			$::navi{$t."_url"}="$::script?cmd=$t&amp;$r=$p";
			$::navi{$t."_name"}=$::resource{$t."button"}
				if($t!~/rename/);
			$::navi{$t."_type"}="edit";
		}
	}
}

sub makenavigator_sub2 {
	my($t,$p)=@_;
	if(    $t eq "top"
		|| $t eq "help" && &is_exist_page($p)
		|| &is_exist_page($p) && (&is_exist_page($::form{refer}) || $::form{refer} eq '')) {
		if($::navi{$t."_url"} eq '') {
			$::navi{$t."_url"}=&make_cookedurl(&encode(@{[
				&is_exist_page($p) ? $p :
				&is_exist_page($::form{refer}) ? $::form{refer} :
				$::FrontPage]}));
			$::navi{$t."_name"}=$::resource{$t};
			$::navi{$t."_type"}="page";
		}
	}
}

sub makenavigator_sub3 {
	my($t)=@_;
	if(-f "$::plugin_dir/$t.inc.pl") {
		if($::navi{$t."_url"} eq '') {
			$::navi{"$t\_url"}="$::script?cmd=$t"
				. ($_exec_plugined{lang} > 1 ? "&amp;lang=$::lang" : "");
			$::navi{"$t\_title"}=$::resource{$t . "button"};
			if(open(R,"$::image_dir/$t.png")) {
				my $data;
				binmode(R);
				read(R, $data, 24);
				close(R);
				$::navi{"$t\_width"}  = unpack("N", substr($data, 16, 20));
				$::navi{"$t\_height"} = unpack("N", substr($data, 20, 24));
			}
			$::navi{$t."_type"}="rsslink";
		}
	}
}

=lang ja

=head2 meta_robots

=over 4

=item ������

&meta_robots(cmdname,�ڡ���̾,�ڡ�����HTML);

=item ����

META������HTML

=item �����С��饤��

��

=item ����

��ܥåȷ��������󥸥�ؤκ�Ŭ���򤹤롣

=back

=cut

sub meta_robots {
	my($cmd,$pagename,$body)=@_;
	my $robots;
	my $keyword;
	if($cmd=~/edit|admin|diff|attach|backup/
		|| $::form{mypage} eq '' && $cmd!~/list|sitemap|recent/
		|| $::form{mypage}=~/SandBox|$::resource{help}|$::resource{rulepage}|$::MenuBar|$::non_list/
		|| &is_readable($::form{mypage}) eq 0) {
		$robots.=<<EOD;
<meta name="robots" content="NOINDEX,NOFOLLOW,NOARCHIVE" />
<meta name="googlebot" content="NOINDEX,NOFOLLOW,NOARCHIVE" />
EOD
	} else {
		$robots.=<<EOD;
<meta name="robots" content="INDEX,FOLLOW" />
<meta name="googlebot" content="INDEX,FOLLOW,ARCHIVE" />
<meta name="keywords" content="$::meta_keyword" />
EOD
	}
	return $robots;
}

=lang ja

=head2 convtime

=over 4

=item ������

�ʤ�

=item ����

ʸ����

=item �����С��饤��

��

=item ����

PyukiWiki��HTML�Ѵ��ˤ����ä�CPU���֤��֤���

=back

=cut

sub convtime {
	if ($::enable_convtime != 0) {
		return sprintf("Powered by Perl $] HTML convert time to %.3f sec.%s",
			((times)[0] - $::_conv_start), $::gzip_header ne '' ? " Compressed" : "");
	}
}

=lang ja

=head2 content_output

=over 4

=item ������

&content_output(http_header, body of HTML);

=item ����

ɸ�����

=item �����С��饤��

��

=item ����

CGI����Τ��٤Ƥν��Ϥ򤹤롣

=back

=cut

sub content_output {
	my ($http_header,$body)=@_;
	print $http_header;

	# XHTML �Ǥʤ���硢HTML���Ѵ�����							# comment
	# XHTML�ξ��ϡ�JavaScript�Υ����ȥ����Ȥ��ѹ����롣		# comment
	# �ڤӡ�pre��������Ƭ���Ԥ������롣(for IE�ʳ�)			# comment
	if($::is_xhtml) {
		$body=~s/(<\!\-\-)/\n\/\/<\!\[CDATA\[/g;
		$body=~s/(\/\/\-\->)/\/\/\]\]>/g;
		$body=~s/<pre>\n/<pre>/g;
	} else {
		$body=~s/\ \/>/>/g
	}
	# <p>������<div>����������									# comment
	$body=~s/<div>([\s\t\r\n]+)?<\/div>//g;
	$body=~s/<p>\n<\/p>(<p>\n<\/p>)?/<p>\n<\/p>/g;

	# ʣ�����Ԥκ��
	$body=~s/>\n(\n+)?</>\n</g;
	&compress_output($body . &exec_explugin_last);
}

=lang ja

=head2 compress_output

=over 4

=item ������

&compress_output(HTML or XML etc...);

=item ����

ɸ�����

=item �����С��饤��

��

=item ����

���̽��Ϥ�ͭ���ʻ��ϡ����̽��Ϥ򤹤롣

=back

=cut

sub compress_output {
	my($data)=shift;

	if ($::gzip_header ne '') {
		if($::gzip_path eq "zlib") {
			binmode(STDOUT);
			my $compress_data=Compress::Zlib::memGzip ($data);
			print $compress_data;
		} else {
			binmode(STDOUT);
			open(STDOUT,"| $::gzip_path");
			print $data;
		}
	} else {
		print $data;
	}
	close(STDOUT);
}

	# not delete for d e b u g
sub _db {
	my($arg)=@_;
	return($arg);
}

=lang ja

=head2 http_header

=over 4

=item ������

���Ϥ���http�إå��������

=item ����

http�إå�ʸ����

=item �����С��饤��

��

=item ����

http�إå��ν�����򤹤롣

=back

=cut

sub http_header {
	my $http_header;
	my $nph_http_header;
	my $nph_http_header_first;

	foreach(@_) {
		$http_header.="$_\n";
	}
	$http_header=~s/\r//g;
	while($http_header=~/\n\n/) {
		$http_header=~s/\n\n/"\n"/ge;
	}
	$http_header=~s/\n$//g;
	$http_header.="\n";

	# nph������ץȤξ�硢�إå���ƹ��ۤ���			# comment

	if($ENV{SCRIPT_NAME}=~/nph\-/) {
		my $cachecontrol=1;
		$ENV{SERVER_PROTOCOL}="HTTP/1.1" if($ENV{SERVER_PROTOCOL} eq '');
		$nph_http_header_first="$ENV{SERVER_PROTOCOL} 200 OK";
		foreach(split(/\n/,$http_header)) {
			if(/^Status/) {
				s/Status:\s*//g;
				$nph_http_header_first="$ENV{SERVER_PROTOCOL} $_";
				if($_ eq 401) {
					$nph_http_header_first=~s/\n//g;
					$nph_http_header_first.=" Authorization Required\n";
				}
			} elsif(/^Last-Modified|^Cache|^Expire/) {
				$cachecontrol=0;
				$nph_http_header.="$_\n";
			} else {
				$nph_http_header.="$_\n";
			}
		}
		$http_header=$nph_http_header_first . "\n" . $nph_http_header;
		if($cachecontrol eq 1) {
		#	$http_header.="Cache-Control: max-age=0\n";
			$http_header.=sprintf(
				"Expires: %s GMT\n"
				, &date("D, j M Y G:i:S",0,"gmtime"));
			$http_header.=sprintf(
				"Date: %s GMT\n"
				, &date("D, j M Y G:i:S",0,"gmtime"));
		}
		$http_header=~s/\n\n/\n/g;
	}

	# ���ԥ����ɤ� CRLF�ˤ���					# comment
	$http_header=~s/\x0D\x0A|\x0D|\x0A/\x0D\x0A/g;
	return "$http_header\x0D\x0A";
}

=lang ja

=head2 getbasehref

=over 4

=item ������

�ʤ�

=item ����

$::basehref, $::basepath, $::script

=item �����С��饤��

��

=item ����

���Ȥʤ�URL��������롣����ä� $::basehref�ڤ� $::basepath�����ꤵ��Ƥ������
���⤷�ʤ���

=back

=cut

sub getbasehref {
	# Thanks moriyoshi koizumi.
	return if($::basehref ne '');
	$::basehost = "$ENV{'HTTP_HOST'}";

	# SSL�ξ��									# comment
	if (($ENV{'https'} =~ /on/i) || ($ENV{'SERVER_PORT'} eq '443')) {
		$::basehost = 'https://' . $::basehost;
	# http�ξ��								# comment
	} else {
		$::basehost = 'http://' . $::basehost;
		# Special Thanks to gyo					# comment
		$::basehost .= ":$ENV{'SERVER_PORT'}"
			if ($ENV{'SERVER_PORT'} ne '80' && $::basehost !~ /:\d/);
	}

	# URL������									# comment
	my $uri;
	my $req=$ENV{REQUEST_URI};
	$req=~s/\?.*//g;
	if($req ne '') {
		if($req eq $ENV{SCRIPT_NAME}) {
			$uri= $ENV{'SCRIPT_NAME'};
		} else {
			for(my $i=0; $i<length($ENV{SCRIPT_NAME}); $i++) {
				if(substr($ENV{SCRIPT_NAME},$i,1) eq substr($req,$i,1)) {
					$uri.=substr($ENV{SCRIPT_NAME},$i,1);
				} else {
					last;
				}
			}
		}
	} else {
		$uri .= $ENV{'SCRIPT_NAME'};
	}
	$::basehref=$::basehost . $uri;
	$::basepath=$uri;
	$::basepath=~s/\/[^\/]*$//g;
	$::basepath="/" if($::basepath eq '');
	$::script=$uri if($::script eq '');
}

=lang ja

=head2 do_read

=over 4

=item ������

title - �ڡ���̾ (�ѹ�������Τ�)

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�ڡ������ɤ߹��ߡ����Ϥ��롣

=back

=cut

sub do_read {
	my($title)=@_;
	$title=$::form{mypage} if($title eq '');
	# ����ڡ�������ץ饰����ε�ư				# comment
	foreach(keys %::fixedpage) {
		if($::fixedpage{$_} ne '' && $_ eq $::form{mypage}) {
			my $refer=&encode($::form{mypage});
			$::form{refer}=$refer;
			$::form{cmd}=$::fixedpage{$_};
			$ENV{QUERY_STING}="cmd=$::form{cmd}$amp;refer=$refer";
			$::form{mypage}='';
			return 0 if(&exec_plugin eq 1);
		}
	}
	# �ɤ߹���ǧ��									# comment
	if(!&is_readable($::form{mypage})) {
		&print_error($::resource{auth_readfobidden});
	}
	# 2005.11.2 pochi: ��ʬ�Խ����ǽ��				# comment
	&skinex($title, &text_to_html($::database{$::form{mypage}}, mypage=>$::form{mypage}), 1, @_);
	return 0;
}


=head2 snapshot

=over 4

=item ����

$::deny_log = 1 �ܺٽ��Ϥ�pyukiwiki.ini.cgi�����ꤷ��$::deny_log�˽��Ϥ��롣

$::filter_flg = 1 ���ѥ�ե��륿�������ꤷ���Ȥ���$::black_log�˽��Ϥ��롣

=item ������

&snapshot(�����Ϥ���ͳ�Υ�å�����);

=item ����

�ʤ�

=item �����С��饤��

�Բ�

=item ����

���ѥ�ե��륿�� &spam_filter �ˤ����ƤΥ��󥰤򤹤롣 add by Nekyo

=back

=cut

sub snapshot {
	my $title = shift;
	my $fp;

	if ($::deny_log) {
		&getremotehost;
		open $fp, ">>$::deny_log";
		print $fp "<<" . $title . ' ' . date("Y-m-d H:i:s") . ">>\n";
		print $fp "HTTP_USER_AGENT:"      . $::ENV{'HTTP_USER_AGENT'}      . "\n";
		print $fp "HTTP_REFERER:"         . $::ENV{'HTTP_REFERER'}         . "\n";
		print $fp "REMOTE_ADDR:"          . $::ENV{'REMOTE_ADDR'}          . "\n";
		print $fp "REMOTE_HOST:"          . $::ENV{'REMOTE_HOST'}          . "\n";
		print $fp "REMOTE_IDENT:"         . $::ENV{'REMOTE_IDENT'}         . "\n";
		print $fp "HTTP_ACCEPT_LANGUAGE:" . $::ENV{'HTTP_ACCEPT_LANGUAGE'} . "\n";
		print $fp "HTTP_ACCEPT:"          . $::ENV{'HTTP_ACCEPT'}          . "\n";
		print $fp "HTTP_HOST:"            . $::ENV{'HTTP_HOST'}            . "\n";
		print $fp "\n";
		close $fp;
	}
	if ($::filter_flg == 1) {
		open($fp, "$::black_log");
		while (<$fp>) {
			tr/\r\n//d;
			s/\./\\\./g;
			if ($_ ne '' && $::ENV{'REMOTE_ADDR'} =~ /$_/i) {
				close($fp);
				return 0;
			}
		}
		close($fp);
		open($fp, ">>$::black_log");
		print $fp $::ENV{'REMOTE_ADDR'} . "\n";  # ��⡼��	# comment
		close $fp;
	}
}

=lang ja

=head2 spam_filter

=over 4

=item ������

&spam_filter(�ʤ� ʸ�������, ��٥�);

��٥�

0�ޤ��ϻ���ʤ��ξ��Over Http�ΤߤΥ����å��򤹤롣

1�ξ�����ܸ�����å��򤹤�

2�ξ��Over Http�����ܸ�����å��Τߤ򤹤롣

=item ����

�ʤ�

=item �����С��饤��

�Բ�

=item ����

�Ǽ��ġ����������Υ��ѥ�ե��륿��  add by Nekyo

=back

=cut

sub spam_filter {
	my ($chk_str, $level) = @_;
	return if ($::filter_flg != 1);	# �ե��륿�����դʤ鲿�⤷�ʤ��� # comment
	return if ($chk_str eq '');		# ʸ����̵����в��⤷�ʤ���	 # comment
	# v 0.2.0 fix													 # comment

	my $chk_jp_regex=$::chk_jp_hiragana ? '[��-��-��]' : '[\x8E\xA1-\xFE]';
	# ��٥� 2�������Over Http�����å���Ԥ���						# comment
	if (($level ne  1) && ($::chk_uri_count > 0) && (($chk_str =~ s/https?:\/\///g) > $::chk_uri_count)) {
		&snapshot('Over http');
	# ��٥뤬 1 �λ��Τ� ���ܸ�����å���Ԥ���					# comment
	# changed by nanami and v 0.2.0 fix
	} elsif (($level >= 1) && ($::chk_jp_only == 1) && ($chk_str !~ /$chk_jp_regex/)) {
		&snapshot('No Japanese');
	} else {
		return;
	}
	&skinex($::form{mypage}, &message($::resource{auth_writefobidden}), 0);
	&close_db;
	exit;
}

=lang ja

=head2 do_write

=over 4

=item ������

&do_write(�ʤ� �ޤ��� FrozenWrite ��ʸ����, �񤭹��߸�ɽ������ڡ���);

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�ڡ�����񤭹��ߤ��롣

=back

=cut

sub do_write {
	my($FrozenWrite, $viewpage)=@_;
	if (not &is_editable($::form{mypage})) {
		&skinex($::form{mypage}, &message($::resource{cantchange}), 0);
		return 0;
	}

	# �񤭹��߶ػߥ�����ɤ��ޤޤ�Ƥ�����				# comment
	foreach(split(/\n/,$::disablewords)) {
		s/\./\\\./g;
		s/\//\\\//g;
		if($::form{mymsg}=~/$_/) {
			&send_mail_to_admin($::form{mypage}, "Deny", $::form{mymsg});
			&skinex($::form{mypage}, &message($::resource{auth_writefobidden}), 0);
			return 0;
		}
	}

	# ���ڡ����Υץ饰���󤫤�ν񤭹��ߵ���				# comment
	if($FrozenWrite eq 'FrozenWrite') {
		if($::writefrozenplugin eq 1) {
			$::form{myfrozen} = &get_info($::form{mypage}, $info_IsFrozen);
		} elsif(&get_info($::form{mypage}, $info_IsFrozen)) {
			$::form{myfrozen}=1;
			if (&frozen_reject()) {
				$::form{cmd}=$::form{refercmd};
				$::form{mypreview} = "";
				&print_error($::resource{auth_writefobidden});
				return 1;
			}
		}
	} else {
		if (&frozen_reject) {
			$::form{cmd}=$::form{refercmd};
			$::form{mypreview} = "";
			return 1;
		}
	}

	return 0 if (&conflict($::form{mypage}, $::form{mymsg}));

	# 2005.11.2 pochi: ��ʬ�Խ����ǽ��					# comment
	if ($::form{mypart} =~ /^\d+$/o and $::form{mypart}) {
		$::form{mymsg} =~ s/\x0D\x0A|\x0D|\x0A/\n/og;
		$::form{mymsg} .= "\n" unless ($::form{mymsg} =~ /\n$/o);
		my @parts = &read_by_part($::form{mypage});
		$parts[$::form{mypart} - 1] = $::form{mymsg};
		$::form{mymsg} = join('', @parts);
	}

	# �����ִ�											# comment
	$::form{mymsg} =~ s/\&t;/\t/g;
	$::form{mymsg} =~ s/\&date;/&date($::date_format)/gex;
	$::form{mymsg} =~ s/\&time;/&date($::time_format)/gex;
	$::form{mymsg} =~ s/\&new;/\&new\{@{[&get_now]}\};/gx
		if(-r "$plugin_dir/new.inc.pl");
	if($::usePukiWikiStyle eq 1) {
		$::form{mymsg} =~ s/\&now;/&date($::now_format)/gex;
		$::form{mymsg} =~ s/\&_(date|time|now);/\&$1\(\);/g;
		$::form{mymsg} =~ s/\&fpage;/$::form{mypage}/g;
		my $tmp=$::form{mypage};
		$tmp=~s/.*\///g;
		$::form{mymsg} =~ s/&page;/$tmp/g;
	}
	$::form{mymsg}=~s/\x0D\x0A|\x0D|\x0A/\n/g;

	# ���ѥ�ե��륿��									# comment
	&spam_filter($::form{mymsg}, 0) if ($::chk_wiki_uri_count eq 1);
	&spam_filter($::form{mymsg}, 1) if ($::chk_write_jp_only eq 1);

	# Making diff										# comment
	&open_diff;
	my @msg1 = split(/\n/, $::database{$::form{mypage}});
	my @msg2 = split(/\n/, $::form{mymsg});
	&load_module("Yuki::DiffText");
	$::diffbase{$::form{mypage}} = Yuki::DiffText::difftext(\@msg1, \@msg2);
	&close_diff;

	# Making backup#nocompact							# comment
	if($::useBackUp eq 1) {#nocompact
		&getremotehost;
		my $backuptime=">>>>>>>>>> " . time . " $ENV{REMOTE_ADDR} $ENV{REMOTE_HOST}\n";#nocompact
		&open_backup;#nocompact
		my $backuptext=$::backupbase{$::form{mypage}};#nocompact
		$backuptext.=$backuptime . $::database{$::form{mypage}} . "\n";#nocompact
		$backupbase{$::form{mypage}}=$backuptext#nocompact
			if($::database{$::form{mypage}} ne '');#nocompact
		&close_backup;#nocompact
	}#nocompact

	# �񤭹���ư��										# comment
	if ($::form{mymsg}) {
		if(exists $::database{$::form{mypage}}) {
			$::database{$::form{mypage}} = $::form{mymsg};
			&send_mail_to_admin($::form{mypage}, "Modify");
		} else {
			$::database{$::form{mypage}} = $::form{mymsg};
			&send_mail_to_admin($::form{mypage}, "New");
		}
		&open_info_db;
		&set_info($::form{mypage}, $::info_ConflictChecker, '' . localtime);
		&set_info($::form{mypage}, $::info_UpdateTime, time);
		if(&get_info($::form{mypage}, $::info_CreateTime)+0 eq 0) {
			&set_info($::form{mypage}, $::info_CreateTime, time);
		}
		if(defined($::form{mytouchjs})) {
			if($::form{mytouchjs} eq "on") {
				&set_info($::form{mypage}, $info_LastModified, '' . localtime);
				&set_info($::form{mypage}, $::info_LastModifiedTime, time);
			&update_recent_changes;
			}
		} elsif($::form{mytouch} eq "on") {
			&set_info($::form{mypage}, $info_LastModified, '' . localtime);
			&set_info($::form{mypage}, $::info_LastModifiedTime, time);
			&update_recent_changes;
		}

		&set_info($::form{mypage}, $info_IsFrozen, 0 + $::form{myfrozen});
		&close_info_db;

		if($::setting_cookie{savename}+0>0 && $::form{myname} ne '') {
			&plugin_setting_savename($::form{myname});
		}
		# �㤦�ڡ�����ɽ��������						# comment
		my $pushmypage=$::form{mypage};
		if($viewpage ne '') {
			$::form{mypage}=$viewpage
				if(&is_exist_page($viewpage));
		}
		# Location��ư									# comment
		if($::write_location eq 1) {
			print &http_header(
				"Status: 302",
				"Location: $::basehref?@{[&encode($::form{mypage})]}",
				$::HTTP_HEADER
				);
			close(STDOUT);
			&exec_explugin_last;
			&close_db;
			exit;
		# �ڡ���ɽ��									# comment
		} else {
			&do_read();
		}
		$::form{mypage}=$pushmypage;
	# ���ư��											# comment
	} else {
		&open_info_db;
		&send_mail_to_admin($::form{mypage}, "Delete");
		delete $::database{$::form{mypage}};
		delete $infobase{$::form{mypage}};
		&update_recent_changes
			if($::form{mytouchjs} eq "on"
			  || ($::form{mytouch} eq "on" && !defined($::form{mytouchjs})));
		&close_info_db;
		&close_db;
		&skinex($::form{mypage}, &message($::resource{deleted}), 0);
	}
	return 0;
}

=lang ja

=head2 read_by_part

=over 4

=item ������

&read_by_part(�ڡ���̾);

=item ����

�ѡ��Ȥ��ȤΥڡ������Ƥ�����

=item �����С��饤��

��

=item ����

��ʬ�Խ��Τ���ˡ��ڤ�Ф������ڡ������Ƥ��֤���

=back

=cut

	# 2005.11.2 pochi: ��ʬ�Խ����ǽ��					# comment
sub read_by_part {
	my ($page) = @_;
	return unless &is_exist_page($page);
	my @lines = map { $_."\n" }
			split(/\x0D\x0A|\x0D|\x0A/o, $::database{$page});
	my @parts = ('');
	foreach my $line (@lines) {
		if ($line =~ /^(\*{1,5})(.+)/) {
			push(@parts, $line);
		} else {
			$parts[$#parts] .= $line;
		}
	}
	return @parts;
}

=lang ja

=head2 print_error

=over 4

=item ������

&print_error(���顼��å�����);

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

���顼��å���������Ϥ��롣

=back

=cut
sub print_error {
	my ($msg) = @_;
	&skinex("\t\t$ErrorPage", qq(<p><strong class="error">$msg</strong></p>), 0);
	close(STDOUT);
	exit(0);
}

=lang ja

=head2 print_content

=over 4

=item ������

&print_content(wikiʸ��, �ڡ���̾);

=item ����

HTML

=item �����С��饤��

��

=item ����

wikiʸ�Ϥ�HTML���Ѵ����롣(�������ѡ�

=back

=cut

sub print_content {
	my ($rawcontent,$nowpagename) = @_;
	$::form{basepage}=$nowpagename eq '' ? $::form{mypage} : $nowpagename;
	return &text_to_html($rawcontent);
}

=lang ja

=head2 make_title

=over 4

=item ������

&make_title(�ڡ���̾, ��å�����);

=item ����

(�����ȥ�ʸ��, �����ȥ륿��)

=item �����С��饤��

��

=item ����

�����ȥ����������

=back

=cut

sub maketitle {
	my($page, $message)=@_;
	my $title;
	my $title_tag;
	my $escapedpage = &htmlspecialchars($page);

	if($::wiki_title ne '') {
		$title="$::wiki_title";
	}

	if($page eq '') {
		if($title eq '') {
			$title_tag="$message";
		} else {
			$title_tag="$message - $title";
		}
	} else {
		if($::IN_TITLE eq '') {
			if($title eq '') {
				$title_tag="$escapedpage";
			} else {
				$title_tag="$escapedpage - $title";
			}
		} else {
			$title_tag=$::IN_TITLE;
		}
	}
	return($title, $title_tag);
}

=lang ja

=head2 text_to_html

=over 4

=item ������

&text_to_html(wikiʸ��,%���ץ����);

=item ����

HTML

=item �����С��饤��

��

=item ����

wikiʸ�Ϥ�HTML���Ѵ����롣

=back

=cut

sub text_to_html {
	# 2005.10.31 pochi: ���ץ���������ǽ��				# comment
	my ($txt, %option) = @_;
	my (@txt) = split(/\r?\n/, $txt);
	my $verbatim;
	my $tocnum = 0;
	my (@saved, @result);
	my $prevline;
	my @col_style;
	unshift(@saved, "</p>");
	push(@result, "<p>");

	# 2006.1.30 pochi: ���ԥ⡼�ɤ�����						# comment
	$::lfmode=$::line_break;

	# 2005.10.31 pochi: ��ʬ�Խ����ǽ��					# comment
	my $editpart = "";
	if($::partedit > 0) {
		if ($option{mypage}) {
			my ($title, $edit, $button);
			if (&is_frozen($option{mypage})) {
				$title = "admineditthispart";
				$edit = "adminedit";
				$button = "admineditbutton";
			} else {
				$title = "editthispart";
				$edit = "edit";
				$button = "editbutton";
			}
			my $enc_mypage = &encode($option{mypage});
			$enc_mypage =~ s/%/%%/og;
			if($::partedit eq 2 || $edit eq 'edit') {
				$editpart = qq(<div class="partinfo"><a class="partedit" title="$::resource{$title}" href="$::script?cmd=$edit&amp;mypage=$enc_mypage&amp;mypart=%d">@{[$::toolbar eq 2 ? qq(<img src="$::image_url/partedit.png" height="16" width="16" alt="$::resource{$button}" />) : $::resource{$button}]}</a></div>);
			}
		}
	}

#	my $saved_ul_level=0;
#	my $saved_ol_level=0;

	my $backline;	# ʣ�����б���							# comment
	my $backcmd;
	my $nest;
	my $lines=$#txt;
	foreach (@txt) {
		$lines--;
		next if($_ eq '#freeze');
		@col_style=() if(!/^(\,|\|)/);
		chomp;

		# backline
		if($backline ne '') {
			$_=$backline . $_;
			$backline="";
		}
		# verbatim.
		if ($verbatim->{func}) {
			if (/^\Q$verbatim->{done}\E$/) {
				undef $verbatim;
				push(@result, splice(@saved));
			} else {
				push(@result, $verbatim->{func}->($_));
			}
			next;
		}
		# non-verbatim follows.
		push(@result, shift(@saved)) if (@saved and $saved[0] eq '</pre>' and /^[^ \t]/);
		my $escapedscheme=$_;
		# v0.1.6 url or mail scheme escape to [BS] or [TAB]	# comment
		if($escapedscheme=~/($::isurl|mailto:$ismail)/) {
			my $url1=$1;
			my $url2=$url1;
			$url2=~s!:!\x08!g;
			$url2=~s!/!\x07!g;
			$escapedscheme=~s!\Q$url1!$url2!g;
		}

		# ʣ�����б�����									# comment
		if($::usePukiWikiStyle eq 1) {
			if(/^:(.*)[|:]+$/) {
				if($lines>0) {
					$backline=$_;
					next;
				}
			} elsif(/^(:|>{1,3}|-{1,3}|\+{1,3})(.+)~$/) {
				if($lines>0) {
					$backline="$1$2\x06";
					next;
				}
			}
		}

		# * ** *** **** *****								# comment
		if (/^(\*{1,5})(.+)/) {
			my $hn = "h" . (length($1) + 1);	# $hn = 'h2'-'h6'
			my $hedding = ($tocnum != 0)
				? qq(<div class="jumpmenu"><a href="@{[&htmlspecialchars($::form{cmd} ne 'read' ? "?$ENV{QUERY_STRING}" : &make_cookedurl($::pushedpage eq '' ? $::form{mypage} : $::pushedpage))]}#navigator">&uarr;</a></div>\n)
				: '';
			push(@result, splice(@saved),
				$hedding . qq(<$hn id="@{[&pageanchorname($::form{mypage})]}$tocnum">) . &inline($2) . qq(</$hn>)
			);
			# 2005.10.31 pochi: ��ʬ�Խ����ǽ��			# comment
			push(@result, sprintf($editpart, $tocnum + 2)) if($editpart);
			$tocnum++;
		# verbatim											# comment
		} elsif (/^{{{/) {	# OpenWiki like. Thanks wadldw.
			$verbatim = { func => \&inline, done => '}}}', class => 'verbatim-soft' };
			&back_push('pre', 1, \@saved, \@result, " class='$verbatim->{class}'");
		} elsif (/^(-{2,3})\($/) {
			if ($& eq '--(') {
				$verbatim = { func => \&inline, done => '--)', class => 'verbatim-soft' };
			} else {
				$verbatim = { func => \&escape, done => '---)', class => 'verbatim-hard' };
			}
			&back_push('pre', 1, \@saved, \@result, " class='$verbatim->{class}'");
		# hr												# comment
		} elsif (/^----/) {
			push(@result, splice(@saved), '<hr />');
		# - -- ---											# comment
		} elsif (/^(-{1,3})(.+)/) {
			my $class = "";
			my $level = length($1);
			if ($::form{mypage} ne $::MenuBar) {
				$class = " class=\"list" . length($1) . "\" style=\"padding-left:16px;margin-left:16px;\"";
			}
			&back_push('ul', length($1), \@saved, \@result, $class);
			push(@result, '<li>' . &inline($2) . '</li>');
		# + ++ +++											# comment
		} elsif (/^(\+{1,3})(.+)/) {
			my $class = "";
			if ($::form{mypage} ne $::MenuBar) {
#				$class = " class=\"list" . length($1) . "\" style=\"padding-left:16px;margin-left:16px;\"";
				$class = " class=\"plist" . length($1) . "\"";
			}
			&back_push('ol', length($1), \@saved, \@result, $class);
			push(@result, '<li>' . &inline($2) . '</li>');
		# : ... : ... / : ... | ...						# comment
		} elsif (/^:/) {
			$escapedscheme=~/^(:{1,3})(.+)/;
			my $chunk=$2;
			my $class = "";
			if ($::form{mypage} ne $::MenuBar) {
				$class=qq( class="list) . length($1) . qq(");
			}
			# thanks making testdata tenk*
			$chunk=~s/\[\[([^:\]]+?):((?!\[)[^\]]+?)\]\]/[[$1\x08$2]]/g
				while($chunk=~/\[\[([^:\]]+?):((?!\[)[^\]]+?)\]\]/);
			if ($chunk=~/^([^\|]+):(.+)\|(.*)/) {
				&back_push('dl', 1, \@saved, \@result, $class);
				push(@result, '<dt>' . &inline($1) . '</dt>', '<dd>' . &inline("$2|$3") . '</dd>');
			} elsif ($chunk=~/^([^\|]+)\|(.*)/) {
				&back_push('dl', 1, \@saved, \@result, $class);
				push(@result, '<dt>' . &inline($1) . '</dt>', '<dd>' . &inline($2) . '</dd>');
			} elsif ($chunk=~/^([^:]+):(.+)/) {
				&back_push('dl', 1, \@saved, \@result, $class);
				push(@result, '<dt>' . &inline($1) . '</dt>', '<dd>' . &inline($2) . '</dd>');
			} else {
				&back_push('dl', 1, \@saved, \@result, $class);
				push(@result, '<dt>' . &inline($chunk) . '</dt>', '<dd></dd>');
			}
		# > >> >>> >>>> >>>>>							# comment
		} elsif (/^(>{1,5})(.+)/) {
			&back_push('blockquote', length($1), \@saved, \@result);
			push(@result, qq(<p class="quotation">))
				if($::usePukiWikiStyle eq 1);
			push(@result, &inline($2));
			push(@result, qq(</p>\n))
				if($::usePukiWikiStyle eq 1);
		# null											# comment
		} elsif (/^$/) {								# comment
			push(@result, splice(@saved));
			unshift(@saved, "</p>");
			push(@result, "<p>");
		# pre											# comment
		# 2005.11.16 pochi: �����Ѥ��ΰ�ι�Ƭ�������	# comment
		} elsif (/^\s(.*)$/o) {
			&back_push('pre', 1, \@saved, \@result);
			push(@result, &htmlspecialchars($1,1)); # Not &inline, but &escape # comment
		# table											# comment
		} elsif (/^([\,|\|])(.*?)[\x0D\x0A]*$/) {
			&back_push('table', 1, \@saved, \@result,
				' class="style_table" cellspacing="1" border="0"',
				'<div class="ie5">', '</div>');
#######										# comment
# This part is taken from Mr. Ohzaki's Perl Memo and Makio Tsukamoto's WalWiki.	# comment
			my $delm = "\\$1";
			my $tmp = ($1 eq ',') ? "$2$1" : "$2";
			my @value = map {/^"(.*)"$/ ? scalar($_ = $2, s/""/"/g, $_) : $_}
				($tmp =~ /("[^"]*(?:""[^"]*)*"|[^$delm]*)$delm/g);
			my @align = map {(s/^\s+//) ? ((s/\s+$//) ? ' align="center"' : ' align="right"') : ''} @value;
			my @colspan = map {$_ eq '==' ? 0 : 1} @value;
			my $pukicolspan=1;
			my $thflag='td';

			for (my $i = 0; $i < @value; $i++) {
				if ($colspan[$i]) {
					if($::usePukiWikiStyle eq 1) {
						# <th>
						if($value[$i]=~/^\~/) {
							$value[$i]=~s/^\~//g;
							$thflag='th';
						} elsif($value[$i] eq '~') {
							$value[$i]="";
							# reserved rowspan
						}
						# right colspan
						if($value[$i] eq '>') {
							$value[$i]='';
							$pukicolspan++;
							next;
						}
					}
					while ($i + $colspan[$i] < @value and  $value[$i + $colspan[$i]] eq '==') {
						$colspan[$i]++;
					}
					$colspan[$i] = ($colspan[$i] > 1) ? sprintf(' colspan="%d"', $colspan[$i]) : '';
					if($pukicolspan > 1 && $::usePukiWikiStyle eq 1) {
						$colspan[$i] = sprintf(' colspan="%d"', $pukicolspan);
						$pukicolspan=1;
					}
					if($::usePukiWikiStyle eq 1) {
						$value[$i]=~ s!(LEFT|CENTER|RIGHT)\:!\ftext-align:$1;\t!g;
						$value[$i]=~ s!BGCOLOR\((.*?)\)\:(.*)!\fbackground-color:$1;\t$2!g;
						$value[$i]=~ s!COLOR\((.*?)\)\:(.*)!\fcolor:$1;\t$2!g;
						$value[$i]=~ s!SIZE\((.*?)\)\:(.*)!\ffont-size:$1px;\t$2!g;
						if($value[$i]=~/\f/) {
							$value_style[$i]=$value[$i];
							$value_style[$i]=~s!\t\f!!g;
							$value_style[$i]=~s!\t(.*)$!!g;
							$value_style[$i]=~s!\f!!g;
							$value[$i]=~s/\f(.*?)\t//g;
						}
						if($tmp=~/(\,|\|)c$/) {
							$col_style[$i]=$value_style[$i];
						} else {
							$value[$i] = sprintf('<%s%s%s class="style_%s" style="%s%s">%s</%s>', $thflag,$align[$i], $colspan[$i], $thflag,$col_style[$i],$value_style[$i],&inline($value[$i]),$thflag);
#%> for Hidemaru											# comment
							$value_style[$i]="";
						}
					} else {
						$value[$i] = sprintf('<td%s%s class="style_td">%s</td>', $align[$i], $colspan[$i], &inline($value[$i]));
					}
				} else {
					$value[$i] = '';
				}
			}
			if($::usePukiWikiStyle eq 0) {
				push(@result, join('', '<tr>', @value, '</tr>'));
			} elsif($tmp=~/(\,|\|)h$/) {
				push(@result, join('', '<thead><tr>',@value,'</tr></thead>'));
			} elsif($tmp=~/(\,|\|)f$/) {
				push(@result, join('', '<tfoot><tr>',@value,'</tr></tfoot>'));
			} elsif($tmp!~/(\,|\|)c$/) {
				push(@result, join('', '<tr>', @value, '</tr>'));
			}
		# ====											# comment
		} elsif (/^====/) {
			if ($::form{show} ne 'all') {
				push(@result, splice(@saved), "<a href=\"$::script?cmd=read&amp;mypage="
					. &encode($::form{mypage}) . "&show=all\">$::resource{continue_msg}</a>");
				last;
			}
		# 2006.1.30 pochi: ���ԥ⡼�ɤ�����				# comment
		} elsif (/^\&\*lfmode\((\d+)\);$/o) {
			$::lfmode = $1;
			$_="";
			next;
		# �֥�å��ץ饰����							# comment
		} elsif (/^$embedded_name$/o) {
			s/^$embedded_name$/&embedded_to_html($1)/gexo;
			&back_push('div', 1, \@saved, \@result);
			push(@result,$_);
		} else {
			# 2006.1.30 pochi: ���ԥ⡼�ɤ�����			# comment
#			&back_push('p', 1, \@saved, \@result);		# comment
			push(@result, &inline($_, ("lfmode" => $::lfmode)));
		}
	}
	push(@result, splice(@saved));
	# 2005.10.31 pochi: ��ʬ�Խ����ǽ��				# comment
	if ($editpart && $::partfirstblock eq 1) {
		unshift(@result, sprintf($editpart, 1));
	}
	my $body=join("\n",@result);
	$body=~s/edit\&mypage/edit\&amp;mypage/g;
	return $body;
}

=lang ja

=head2 pageanchorname

=over 4

=item ������

�ڡ���̾

=item ����

���󥫡�̾(��ʸ����

=item �����С��饤��

��

=item ����

�ڡ���̾���Ф��륢�󥫡�̾����Ϥ��롣

=back

=cut

sub pageanchorname {
	my ($page)=@_;
	return 'm' if($page eq $::MenuBar && $::MenuBar ne '');
	return 'r' if($page eq $::RightBar && $::RightBar ne '');
	return 'h' if($page eq $::Header && $::Header ne '');
	return 'f' if($page eq $::Footer && $::Footer ne '');
	return 's' if($page eq $::SkinFooter && $::SkinFooter ne '');
	return 'i';
}

=lang ja

=head2 back_push

=over 4

=item ������

&backpush($tag, $level, $savedref, $resultref, $attr, $with_open, $with_close);

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

HTML��push���롣

=back

=cut

sub back_push {
	my ($tag, $level, $savedref, $resultref, $attr, $before_open, $after_close,$after_open,$before_close) = @_;
	while (@$savedref > $level) {
		push(@$resultref, shift(@$savedref));
	}
	if ($savedref->[0] ne "$before_close</$tag>$after_close") {
		push(@$resultref, splice(@$savedref));
	}
	while (@$savedref < $level) {
		unshift(@$savedref, "$before_close</$tag>$after_close");
		push(@$resultref, "$before_open<$tag$attr>$after_open");
	}
}

=lang ja

=head2 inline

=over 4

=item ������

&inline(����饤���wikiʸ��,%option);

=item ����

HTML

=item �����С��饤��

��

=item ����

����饤���wikiʸ�Ϥ�HTML���Ѵ����롣

=back

=cut

$::_inline_attr="";

sub inline {
	#2006.1.30 pochi: ���ץ���������ǽ��
	my ($line, %option) = @_;
	$line =~ tr|\x08|:|;				# escaped scheme v0.1.6	# comment
	$line =~ tr|\x07|/|;				# escaped scheme v0.1.6	# comment
	$line =~ s|^//.*||g;				# Comment				# comment
										# Comment # debug		# comment
	$line =~ s|\s//\s\#.*$||g;
	$line = &htmlspecialchars($line);

#	$line=~s!$::_inline!<$::_inline{$1}>$2</$::_inline{$1}>!go;	# comment

	$line =~ s|'''(.+?)'''|<em>$1</em>|g;			# Italic		# comment
	$line =~ s|''(.+?)''|<strong>$1</strong>|g;		# Bold			# comment
	$line =~ s|%%%(.+?)%%%|<ins>$1</ins>|g;			# Insert Line	# comment
	$line =~ s|%%(.+?)%%|<del>$1</del>|g;			# Delete Line	# comment
	$line =~ s|\^\^(.+?)\^\^|<sup>$1</sup>|g;		# sup			# comment
	$line =~ s|__(.+?)__|<sub>$1</sub>|g;			# sub			# comment

	$line =~ s|(\d\d\d\d-\d\d-\d\d \(\w\w\w\) \d\d:\d\d:\d\d)|<span class="date">$1</span>|g;	# Date	# comment

	if($::usePukiWikiStyle eq 1) {
		if($line=~/~$/) {
			if($line=~/^(LEFT|CENTER|RIGHT|RED|BLUE|GREEN):/) {
				$::_inline_attr=$1;
				$line=~s/^$::_inline_attr://g;
			}
		} else {
			$::_inline_attr="";
		}
		if($::_inline_attr ne '') {
			$line="$::_inline_attr:$line";
		}
	}
	#2006.1.30 pochi: ���ԥ⡼�ɤ�����				# comment
	if ($option{"lfmode"}) {
		if ($line !~ /^$embedded_name$/o) {
			if (!($line =~ s/\\$//o)) {
				$line .= "<br />";
			}
		}
	} else {
		$line =~ s|~$|<br />|g;
		$line =~ s|\x06|<br />|g;			# escaped scheme v0.1.6	# comment
	}

	$line =~ s!^(LEFT|CENTER|RIGHT):(.*)$!<div style="text-align:$1">$2</div>!g;
	$line =~ s!^(RED|BLUE|GREEN):(.*)$!<font color="$1">$2</font>!g;# Tnx hash. # comment

	if($::usePukiWikiStyle eq 1) {
		$line =~ s!BGCOLOR\((.*?)\)\s*\{\s*(.*)\s*\}!<span style="background-color:$1">$2</span>!g;
		$line =~ s!COLOR\((.*?)\)\s*\{\s*(.*)\}!<span style="color:$1">$2</span>!g;
		$line =~ s!SIZE\((.*?)\)\s*\{\s*(.*)\s*\}!<span style="font-size:$1px">$2</span>!g;
	}

	$line =~ s!&amp;version;!$::version!g;
	$line =~ s!($::inline_regex)!&make_link($1)!geo;
	$line =~ s!($embedded_inline)!&embedded_inline($1)!geo
		if($::usePukiWikiStyle eq 1);	# 2�ͥ��Ȥޤǵ���			# comment

	$line =~ s|\(\((.*)\)\)|&note($1)|gex;
	$line =~ s|\(\((.*)\)\)||gex;

	$line =~ s|\[\#(.*)\]|<a class="anchor_super" id="$1" href="#$1" title="$1">$::_symbol_anchor</a>|g;
	# ��ʸ��													# comment
	if ($::usefacemark == 1) {
		$line=~s!($::_facemark)!<img src="$::image_url/face/$::_facemark{$1}.png" alt="@{[htmlspecialchars($1,1)]}" />!go;
	}
	return $line;
}

=lang ja

=head2 note

=over 4

=item ������

&note(���Υ���饤��wikiʸ��);

=item ����

���ؤΥ��HTML

=item �����С��饤��

��

=item ����

��������¸�������ؤΥ��󥫡���󥯤��������롣

=back

=cut

sub note {
	my ($msg) = @_;
	push(@::notes, $msg);
	# thanks to Ayase
	return "<a @{[$::is_xhtml ? 'id' : 'name']}=\"notetext_" . @::notes . "\" "
		. "href=\"" . &make_cookedurl(&encode($::form{mypage})) . "#notefoot_" . @::notes . "\" class=\"note_super\">*"
		. @::notes . "</a>";
}

=lang ja

=head2 make_link

=over 4

=item ������

&make_link(��Ф��줿�����);

=item ����

����󥯤����Ѵ����줿HTML

=item �����С��饤��

��

=item ����

��󥯤��������롣

=back

=cut

sub make_link {
	my $chunk = shift;
	my $res;
	my $orgchunk=$chunk;
	my $target = qq( target="_blank");

#	# bug fix 0.1.8											# comment
#	if ($chunk =~ /^(https?|ftp):/) {						# comment
# fix 0.2.0													# comment
	if ($chunk =~ /^$::isurl/ && $chunk =~ /\.$::image_extention$/o) {
		if (&exist_plugin('img') == 1) {
			$res = &plugin_img_convert("$chunk,module");
			return $res if ($res ne '');
		}
#		return qq(<a href="$chunk"$target>$chunk</a>);		# comment

# ���ס� v0.2.0												# comment
#	} elsif ($chunk =~ /^$interwiki_definition2$/) {		# comment
##	if ($chunk =~ /^$interwiki_definition2$/) {				# comment
#		my $value = <<EOM;									# comment
#<span class="InterWiki">@{[&make_link_target($1, $2, $target)]}</span>	# comment
#EOM														# comment
#		return $value;										# comment

	# ����饤��ץ饰����									# comment
	} elsif ($chunk =~ /^$embedded_inline/o) {
		if($::usePukiWikiStyle eq 1) {
			return &embedded_inline($chunk,2);
		} else {
			return &embedded_inline($chunk);
		}
	}
	my $escapedchunk=&unarmor_name($chunk);
	$chunk=&unescape($escapedchunk);
	# url													# comment
	if ($chunk =~ /^$::isurl$/o) {
		my $tmp=&make_link_urlhref($chunk);
		if ($use_autoimg and $chunk =~ /\.$::image_extention$/o) {
			return &make_link_url("url",$tmp,$tmp,$tmp);
		} else {
			return &make_link_url("url",$tmp,$tmp);
		}
	}
	# [[intername:wiki#anchor]]								# comment
	if ($chunk!~/>/ && $chunk =~ /^$interwiki_name2$/o && $chunk!~/$::isurl|$ismail/o) {
		my $chunk1=&make_link_interwiki($1,$2,$3,$escapedchunk);
		return $chunk1 if($chunk1 ne '');
	# [[intername:wiki]]									# comment
	} elsif ($chunk!~/>/ && $chunk =~ /^$interwiki_name1$/o && $chunk!~/$::isurl|$ismail/o) {
		$escapedchunk=&make_link_interwiki($1,$2,$escapedchunk);
		return $chunk1 if($chunk1 ne '');
	}
 	if($chunk!~/>/ && $chunk=~/$ismail/o) {
		# mailto:mail@address								# comment
	 	if($chunk=~/([Mm][Aa][Ii][Ll][Tt][Oo]):$::ismail/o) {
			$chunk=~s/[Mm][Aa][Ii][Ll][Tt][Oo]://g;
			return &make_link_mail($chunk,$escapedchunk);
		}
		# [[mail@address]]									# comment
	 	if($chunk=~/^$::ismail$/o) {
			return &make_link_mail($chunk,$escapedchunk);
		}
	}
	# [[name>alias]]										# comment
	if($chunk=~/^([^>]+)>(.+)$/) {
		$escapedchunk=$1;
		my $chunk2=&htmlspecialchars($2);
		#[[http://some/image.(gif|png|jpe?g)>???]]			# comment
		if ($use_autoimg && $escapedchunk=~/$::isurl/o && $escapedchunk =~ /\.$::image_extention$/o) {
			my $chunkurl;
			my $alt;
			# v0.2.0 image alt plus							# comment
			if($chunk2=~/^(.+)\,(.+)$/) {
				$chunkurl=$1;
				$alt=$2;
				$escapedchunk=&make_link_image(&htmlspecialchars($escapedchunk),&htmlspecialchars($alt));
				$chank2=$chankurl;
			} else {
				$escapedchunk=&make_link_image(&htmlspecialchars($escapedchunk));
			}
			# v0.2.0 image alt plus							# comment
			if($alt ne '') {
				return &make_link_url("link",$chunkurl,$escapedchunk,'','',$alt);
			}
		} else {
			$escapedchunk=&htmlspecialchars($escapedchunk);
		}
		# v0.1.7 http & mailto swap							# comment
		# [[name>http://url/]]								# comment
		if($chunk2=~/$::isurl/o) {
			return &make_link_url("link",$chunk2,$escapedchunk);
		# [[name>mailto:mail@address]] or [[name>mail@address]]	# comment
		} elsif($chunk2=~/$ismail/o) {
		 	if($chunk2=~/([Mm][Aa][Ii][Ll][Tt][Oo]):$ismail/o) {
				$chunk2=~s/[Mm][Aa][Ii][Ll][Tt][Oo]://g;
			}
			return &make_link_mail($chunk2,$escapedchunk);
		# [[name>intername:wiki#anchor]]					# comment
		} elsif($chunk2=~/^$interwiki_name2$/o) {
			my $chunk1=&make_link_interwiki($1,$2,$3,$escapedchunk);
			return $chunk1 if($escapedchunk ne '');
		# [[name>intername:wiki]]							# comment
		} elsif($chunk2=~/^$interwiki_name1$/o) {
			my $chunk1=&make_link_interwiki($1,$2,$escapedchunk);
			return $chunk1 if($escapedchunk ne '');
		} elsif($chunk=~/^$::isurl/o) {
			if ($use_autoimg and $escapedchunk =~ /\.$::image_extention$/o) {
				return &make_link_url("image",$chunk,$chunk,$escapedchunk);
			} else {
				return &make_link_url("url",$chunk,$chunk);
			}
		}
	}
	# [[name:alias]]										# comment
	if($chunk=~/^(.+?):(.+)$/ && $chunk!~/^file/) {
		$escapedchunk=$1;
		my $chunk2=$2;
		if ($use_autoimg && $escapedchunk=~/$::isurl/o && $escapedchunk =~ /\.$::image_extention$/o) {
			my $chunkurl;
			my $alt;
			# v0.2.0 image alt plus, separater is [,]				# comment
			if($chunk2=~/^(.+)\,(.+)$/) {
				$chunkurl=$1;
				$alt=$2;
				$escapedchunk=&make_link_image(&htmlspecialchars($escapedchunk),&htmlspecialchars($alt));
				$chank2=$chankurl;
			} else {
				$escapedchunk=&make_link_image(&htmlspecialchars($escapedchunk));
			}
		# v0.2.0 image alt plus										# comment
			if($alt ne '') {
				return &make_link_url("link",$chunkurl,$escapedchunk,'','',$alt);
			}
		} else {
			$escapedchunk=&htmlspecialchars($escapedchunk);
		}
		# [[name>mailto:mail@address]] or [[name>mail@address]]	# comment
		if($chunk2=~/$ismail/o) {
		 	if($chunk2=~/([Mm][Aa][Ii][Ll][Tt][Oo]):$ismail/o) {
				$chunk2=~s/[Mm][Aa][Ii][Ll][Tt][Oo]://g;
			}
			return &make_link_mail($chunk2,$escapedchunk);
		# [[name>http://url/]]								# comment
		} elsif($chunk2=~/$::isurl/o) {
			return &make_link_url("link",$chunk2,$escapedchunk);
		# [[name>intername:wiki#anchor]]					# comment
		} elsif($chunk2=~/^$interwiki_name2$/o) {
			my $chunk1=&make_link_interwiki($1,$2,$3,$escapedchunk);
			return $chunk1 if($escapedchunk ne '');
		# [[name>intername:wiki]]							# comment
		} elsif($chunk2=~/^$interwiki_name1$/o) {
			my $chunk1=&make_link_interwiki($1,$2,$escapedchunk);
			return $chunk1 if($escapedchunk ne '');
		} elsif($chunk=~/^$::isurl/o) {
			if ($use_autoimg and $escapedchunk =~ /\.$::image_extention$/o) {
				return &make_link_url("image",$chunk,$chunk,$escapedchunk);
			} else {
				return &make_link_url("url",$chunk,$chunk);
			}
		}
	}

	# [[name>alias]] -> [[name:alias]]						# comment
	if($chunk=~/^(.+?)>(.+?)$/) {
		$chunk=$2;
		$escapedchunk = &htmlspecialchars($1);
	} elsif($chunk=~/^(.+?):(.+?)$/) {
		$chunk=$2;
		$escapedchunk = &htmlspecialchars($1);
	}

	# local wiki page										# comment
	return &make_link_wikipage(get_fullname($chunk, $::form{mypage}),$escapedchunk);
}

=lang ja

=head2 make_link_wikipage

=over 4

=item ������

&make_link_wikipage(�����, ɽ��ʸ����);

=item ����

HTML

=item �����С��饤��

��

=item ����

wiki�ڡ����ؤΥ�󥯤��������롣

=back

=cut

sub make_link_wikipage {
	my($chunk1,$escapedchunk)=@_;
	my($chunk,$anchor)=$chunk1=~/^([^#]+)#?(.*)/;
	my $cookedchunk  = &encode($chunk);
	my $cookedurl=&make_cookedurl($cookedchunk);

	if (&is_exist_page($chunk)) {
		if($anchor eq '') {
			return qq(<a title="$chunk" href="$cookedurl">$escapedchunk</a>);
		} else {
			return qq(<a title="$chunk" href="$cookedurl#$anchor">$escapedchunk</a>);
		}
	} elsif (&is_editable($chunk)) {
		# 2005.10.27 pochi: ��ư��󥯵�ǽ���ĥ			# comment
		if ($::editchar eq 'this') {
			return qq(<a title="$::resource{editthispage}" class="editlink" href="$::script?cmd=edit&amp;mypage=$cookedchunk">$escapedchunk</a>);
		} elsif ($::editchar) {
			# original
			return qq($escapedchunk<a title="$::resource{editthispage}" class="editlink" href="$::script?cmd=edit&amp;mypage=$cookedchunk">$::editchar</a>);
		}
	}
	return $escapedchunk;
}

=lang ja

=head2 make_link_interwiki

=over 4

=item ������

&make_link_interwiki($intername, $keyword, $anchor,$escapedchunk);

=item ����

���HTML

=item �����С��饤��

��

=item ����

InterWiki�Υ�󥯤��������롣

=back

=cut

sub make_link_interwiki {
	my ($intername, $keyword, $anchor,$escapedchunk) = @_;
	if($escapedchunk eq '') {
		$escapedchunk=$anchor;
		$anchor="";
	}
	$intername=~tr/A-Z/a-z/;
	if(exists $::interwiki2{$intername}) {
		my ($code, $url) = %{$::interwiki2{$intername}};
		if($url=~/\$1/) {
			$url =~ s/\$1/&interwiki_convert($code, $keyword)/e;
		} else {
			$url.=&interwiki_convert($code, $keyword);
		}
		$url = &htmlspecialchars($url.$anchor);
		return &make_link_url("interwiki",$url,$escapedchunk);
	} else {
		my $remoteurl = $::interwiki{$intername};
		if ($remoteurl) {
			$remoteurl =~
			 s/\b(utf8|euc|sjis|ykwk|asis)\(\$1\)/&interwiki_convert($1, $localname)/e;
			return &make_link_url("interwiki",$remoteurl,$escapedchunk);
		}
	}
}

=lang ja

=head2 make_cookedurl

=over 4

=item ������

&make_cookedurl(URL���������פ��줿�����);

=item ����

�����URL

=item �����С��饤��

��

=item ����

wiki�ڡ����ؤΥ�������Ϥ��롣

=back

=cut

sub make_cookedurl {
	my($cookedchunk)=@_;
	return "$::script" . "?" . "$cookedchunk";
}

=lang ja

=head2 make_link_mail

=over 4

=item ������

&make_link_mail(�����, ɽ��ʸ����);

=item ����

���󥫡�̾(��ʸ����

=item �����С��饤��

��

=item ����

�᡼�륢�ɥ쥹�Υ�󥯤򤹤롣

=back

=cut

sub make_link_mail {
	my($chunk,$escapedchunk)=@_;

	my $adr=$chunk;
	$adr=~s/^[Mm][Aa][Ii][Ll][Tt][Oo]://g;
	return qq(<a href="mailto:$adr" class="mail">$escapedchunk</a>);
}

=lang ja

=head2 make_link_url

=over 4

=item ������

&make_link_url(���饹, �����, ɽ��ʸ����, ����, �������å�, img����ɽ��ʸ����);

=item ����

���HTML

=item �����С��饤��

��

=item ����

URL���󥯤��롣

=back

=cut

sub make_link_url {
	my($class,$chunk,$escapedchunk,$img,$target,$alt)=@_;
	my $chunk2=&make_link_urlhref($chunk);
	$target="_blank" if($target eq '');
	if($img ne '') {
		$class.=($class eq '' ? 'img' : '');
		return &make_link_target($chunk2,$class,$target,"")
			. &make_link_image($img,$escapedchunk) . qq(</a>);
	}
	if($escapedchunk=~/^<img/) {
		return &make_link_target($chunk2,$class,$target,@{[$alt eq '' ? $chunk : $alt]})
			. qq($escapedchunk</a>);
	}
	return &make_link_target($chunk2,$class,$target,$escapedchunk)
			. qq($escapedchunk</a>);
}

=lang ja

=head2 make_link_target

=over 4

=item ������

&make_link_target(�����, ���饹, �������å�, �����ȥ�ʸ���� [, �ݥåץ��åפ��뤫�ɤ����Υե饰]);

=item ����

���HTML

=item �����С��饤��

��

=item ����

�������åȤ����URL���󥯤��롣

=back

=cut

sub make_link_target {
	my($url,$class,$target,$escapedchunk,$flag)=@_;
	$flag=$::use_popup if($flag eq '');
	$class=&htmlspecialchars($class);
	$target=&htmlspecialchars($target);
	$escapedchunk=&htmlspecialchars($escapedchunk);
	my $popup_allow=$::setting_cookie{popup} ne '' ? $::setting_cookie{popup}
					: $flag+0 ? 1 : 0;
	my $target=$popup_allow != 0 ? $target : '';
	$target='' if($flag eq 2 && $url=~/ttp\:\/\/$ENV{HTTP_HOST}/);
	if($target ne '' && $flag eq 3) {
		my $tmp=$::basehref;
		$tmp=~s/\/.*//g;
		$target='' if($url=~/\Q$tmp/);
	}
	if($target eq '') {
		return qq(<a href="$url" @{[$class eq '' ? '' : qq(class="$class")]} title="$escapedchunk">);
	} elsif($::is_xhtml) {
		return qq(<a href="$url" @{[$class eq '' ? '' : qq(class="$class")]} title="$escapedchunk" onclick="return openURI('$url','$target');">);
	} else {
		return qq(<a href="$url" @{[$class eq '' ? '' : qq(class="$class")]} target="$target" title="$escapedchunk">);
	}
}

=lang ja

=head2 make_link_urlhref

=over 4

=item ������

&make_link_urlhref(URL);

=item ����

URLʸ����

=item �����С��饤��

��

=item ����

URLʸ������������롣

=back

=cut

sub make_link_urlhref {
	my($url)=@_;
	return &htmlspecialchars(
		&unescape(
			&unescape($url)
		)
	);
}

=lang ja

=head2 make_link_image

=over 4

=item ������

&make_link_image(������URL, ����);

=item ����

HTML

=item �����С��饤��

��

=item ����

������HTML����Ϥ��롣

=back

=cut

sub make_link_image {
	my($img,$alt)=@_;
	$alt=&htmlspecialchars($alt);
	$img=&htmlspecialchars($img);
	$alt=$img if($alt eq '');
	return qq(<img src="@{[&make_link_urlhref($img)]}" alt="$alt" />);
}

=lang ja

=head2 get_fullname

=over 4

=item ������

&get_fullname(�ڡ���̾, ���ȸ��ڡ���̾);

=item ����

���󥫡�̾(��ʸ����

=item �����С��饤��

��

=item ����

�������ڡ���̾���֤���

=back

=cut

sub get_fullname {
	my ($name, $refer) = @_;

	return $refer if ($name eq '');
	if ($name eq '/') {
		$name = substr($name,1);
		return ($name eq '') ? $::FrontPage : $name;
	}
	return $refer if ($name eq './');
	if (substr($name,0,2) eq './') {
		return ($1) ? $refer . '/' . $1 : $refer;
	}
	if (substr($name,0,3) eq '../') {
		my @arrn = split('/', $name);
		my @arrp = split('/', $refer);

		while (@arrn > 0 and $arrn[0] eq '..') {
			shift(@arrn);
			pop(@arrp);
		}
		$name = @arrp ? join('/',(@arrp,@arrn)) :
			(@arrn ? "$::FrontPage/".join('/',@arrn) : $::FrontPage);
	}
	return $name;
}

=lang ja

=head2 message

=over 4

=item ������

&message(ɽ��ʸ����);

=item ����

HTML

=item �����С��饤��

��

=item ����

��å���������Ϥ��롣

=back

=cut

sub message {
	my ($msg) = @_;
	return qq(<p><strong>$msg</strong></p>);
}

=lang ja

=head2 init_form

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�ե�������������롣

=back

=cut

sub init_form {
	if ($qCGI->param()) {
		foreach my $var ($qCGI->param()) {
			$::form{$var} = $qCGI->param($var);
		}
	} else {
		$ENV{QUERY_STRING} = $::FrontPage;
	}

	# Thanks Mr.koizumi. v0.1.4							# comment
	my $query = $ENV{QUERY_STRING};
	if ($query =~ /&/) {
		my @querys = split(/&/, $query);
		foreach (@querys) {
			$_ = &decode($_);
			$::form{$1} = $2 if (/([^=]*)=(.*)$/);
		}
	} else {
		$query = &decode($query);
	}

	if (&is_exist_page($query)) {
		$::form{cmd} = 'read';
		$::form{mypage} = $query;
	}
	# mypreview_edit        -> do_edit, with preview.			# comment
	# mypreview_adminedit   -> do_adminedit, with preview.		# comment
	# mypreview_write       -> do_write, without preview.		# comment

	# mypreviewjs_edit        -> do_edit, with preview.			# comment
	# mypreviewjs_adminedit   -> do_adminedit, with preview.	# comment
	# mypreviewjs_write       -> do_write, without preview.		# comment

	foreach (keys %::form) {
		if (/^mypreview_(.*)$/ || /^mypreviewjs_(.*)$/) {
			if($::form{$_} ne '') {
				$::form{cmd} = $1;
				$::form{mypreview} = 1;
			}
		}
	}

	$::form{mymsg} = &code_convert(\$::form{mymsg},   $::defaultcode,$::kanjicode) if($::form{mymsg});
	$::form{myname} = &code_convert(\$::form{myname}, $::defaultcode,$::kanjicode) if($::form{myname});
	$::form{mypage} = &code_convert(\$::form{mypage}, $::defaultcode) if($::form{mypage});
	$::form{page} = &code_convert(\$::form{page}, $::defaultcode) if($::form{page});
	$::form{refer} = &code_convert(\$::form{refer}, $::defaultcode) if($::form{refer});
	$::form{under} = &code_convert(\$::form{under}, $::defaultcode) if($::form{under});
	$::form{template} = &code_convert(\$::form{template}, $::defaultcode) if($::form{template});
}

=lang ja

=head2 getcookie

=over 4

=item ������

&getcookie($cookie�μ���ID, %cookie����);

=item ����

%cookie����

=item �����С��饤��

��

=item ����

cookie��������롣

=back

=cut

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

=lang ja

=head2 setcookie

=over 4

=item ������

&setcookie($cookie�μ���ID,ͭ������,%cookie����);

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

cookie�����ꤹ�뤿���HTTP�إå����򥻥åȤ��롣

ͭ�����¤ˤϡ��ʲ��ο��ͤΤ�����Ǥ��롣

�� 1��$::cookie_expire��ͭ���ˤ��롣

�� 0�����å����Τ���¸���롣

��-1��cookie��õ�롣

=back

=cut

sub setcookie {
	my($cookieID,$expire,%buf)=@_;
	my $date;
	my $data;
	if($expire+0 > 0) {
		$date=&date("D, j-M-Y H:i:s",time+&gettz*3600+$::cookie_expire);
	} elsif($expire+0 < 0) {
		$date=&date("D, j-M-Y H:i:s",1);
	}
	$buf{cookietime}=time;
	while(($name,$value)=each(%buf)) {
		$data.="$name:$value," if($name ne '');
	}
	$data=~s/,$//g;
	$data=&encode($data);
	$::HTTP_HEADER.=qq(Set-Cookie: $cookieID=$data;);
	$::HTTP_HEADER.=qq( path=$::basepath;);
	$::HTTP_HEADER.=" expires=$date GMT" if($expire ne 0);
	$::HTTP_HEADER.="\n";
}

=lang ja

=head2 update_recent_changes

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

RecentChanges�ڡ����򹹿����롣

=back

=cut


sub update_recent_changes {
	my $update = "- @{[&get_now]} @{[&armor_name($::form{mypage})]} @{[&get_subjectline($::form{mypage})]}";
	my @oldupdates = split(/\r?\n/, $::database{$::RecentChanges});
	my @updates;
	foreach (@oldupdates) {
		/^\- \d\d\d\d\-\d\d\-\d\d \(...\) \d\d:\d\d:\d\d (.*?)\ \ \-/;	# date format.
		my $name = &unarmor_name($1);
		if (&is_exist_page($name) and ($name ne $::form{mypage})) {
			push(@updates, $_);
		}
	}
	unshift(@updates, $update) if (&is_exist_page($::form{mypage}));
	splice(@updates, $::maxrecent + 1);
	$::database{$::RecentChanges} = join("\n", @updates);
}

=lang ja

=head2 get_subjectline

=over 4

=item ������

&get_subjectline(�ڡ���̾,�Կ�,%���ץ����);

=item ����

Plainʸ����

=item �����С��饤��

��

=item ����

�ڡ����Σ�������Ԥ�������롣���Ƥˤ�äƤϣ����ܡ������ܤˤʤ뤳�Ȥ����롣

=back

=cut

sub get_subjectline {
	my ($page, $lines,%option) = @_;
	$lines=1 if($lines+0 < 1);
	my $line;
	if (not &is_editable($page)) {
		return "";
	}
	# Delimiter check.								# comment
	my $delim = $subject_delimiter;
	$delim = $option{delimiter} if (defined($option{delimiter}));
	# Get the subject of the page.
	my $subject = $::database{$page};
	my $i=1;
	foreach (split(/\n/,$subject)) {
		s/\(\((.*)\)\)//gex;			# thanks to Ayase
		my $tmp=&text_to_html($_);
		$tmp=~s/[\xd\xa]//g;
		$tmp=~s/<.*?>//g;
		$tmp=&trim($tmp);
		next if($tmp eq '');
		$line.=$i eq 1 ? $tmp : "\n$tmp";
		last if($line ne '' && $i++ >= $lines);
	}
	if($lines > 1) {
		return $line;
	}
	$line =~ s/\r?\n.*//s;
	return "$delim$line";
}

=lang ja

=head2 send_mail_to_admin

=over 4

=item ������

&send_mail_to_admin(�ڡ���̾,$mode);

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�����Ը�����wiki�ι������Ƥ�᡼�뤹�롣

=back

=cut

sub send_mail_to_admin {
	my($page, $mode, $data)=@_;
	&load_module("Nana::Mail");
	Nana::Mail::toadmin($mode, $page, $data);
}

=lang ja

=head2 open_db

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�ǡ����١����򳫤���

=back

=cut

sub open_db {
	&dbopen($::data_dir,\%::database);
}


=lang ja

=head2 open_info_db

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

info�ǡ����١����򳫤���

=back

=cut

sub open_info_db {
	&dbopen($::info_dir,\%::infobase);
}

=lang ja

=head2 dbopen

=over 4

=item ������

&dbopen(dir, \%db);

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�ǡ����١����򳫤���

=back

=cut

sub dbopen {
	my($dir,$db)=@_;
	if ($modifier_dbtype eq 'dbmopen') {
		dbmopen(%$db, $dir, 0666) or &print_error("(dbmopen) $dir");
	} elsif($modifier_dbtype eq 'AnyDBM_File') {
		tie(%$db, "AnyDBM_File", $dir, O_RDWR|O_CREAT, 0666) or &print_error("(tie AnyDBM_File) $dir");
	} else {	# Nana::YukiWikiDB	# comment
		tie(%$db, "$modifier_dbtype", $dir) or &print_error("(tie $modifier_dbtype) $dir");
	}
	return %db;
}

=lang ja

=head2 dbopen

=over 4

=item ������

&dbopen_gz(dir, \%db);

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

gzip���̥ǡ����١����򳫤���

=back

=cut

sub dbopen_gz {#nocompact
	my($dir,$db)=@_;#nocompact
	if ($modifier_dbtype eq 'dbmopen') {#nocompact
		dbmopen(%$db, $dir, 0666) or &print_error("(dbmopen) $dir");#nocompact
	} elsif($modifier_dbtype eq 'AnyDBM_File') {#nocompact
		tie(%$db, "AnyDBM_File", $dir, O_RDWR|O_CREAT, 0666) or &print_error("(tie AnyDBM_File) $dir");#nocompact
	} else {	# Nana::YukiWikiDB_GZIP	# comment#nocompact
		tie(%$db, "Nana::YukiWikiDB_GZIP", $dir) or &print_error("(tie Nana::YukiWikiDB_GZIP) $dir");#nocompact
	}#nocompact
	return %db;#nocompact
}#nocompact

=lang ja

=head2 close_db

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�ǡ����١������Ĥ���

=back

=cut

sub close_db {
	&dbclose(\%::database);
}

=lang ja

=head2 close_info_db

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

info�ǡ����١������Ĥ���

=back

=cut

sub close_info_db {
	&dbclose(\%::infobase);
}

=lang ja

=head2 dbclose

=over 4

=item ������

&dbclose(\%db);

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�ǡ����١����򳫤���

=back

=cut

sub dbclose {
	my($db)=@_;
	if ($modifier_dbtype eq 'dbmopen') {
		dbmclose(%$db);
	} else {
		untie(%$db);
	}
}

=lang ja

=head2 opendiff

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

diff�ǡ����١����򳫤���

=back

=cut

sub open_diff {
	&dbopen($::diff_dir,\%::diffbase);
}

=lang ja

=head2 close_diff

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

diff�ǡ����١������Ĥ��롣

=back

=cut

sub close_diff {
	&dbclose(\%::diffbase);
}

=lang ja

=head2 openbackup

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

backup�ǡ����١����򳫤���

=back

=cut

sub open_backup {#nocompact
	&dbopen_gz($::backup_dir,\%::backupbase);#nocompact
}#nocompact

=lang ja

=head2 close_backup

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

backup�ǡ����١������Ĥ��롣

=back

=cut

sub close_backup {#nocompact
	&dbclose(\%::backupbase);#nocompact
}#nocompact

=lang ja

=head2 is_readable

=over 4

=item ������

&is_readable(�ڡ���̾);

=item ����

�ڡ��������ġ��Բĥե饰

=item �����С��饤��

��

=item ����

�ڡ����α����ġ��Բĥե饰���֤���

=back

=cut

sub is_readable {
	my($page)=@_;
	return 0 if($page eq $::RecentChanges);	# do not delete	# comment
	return 1;
}

=lang ja

=head2 is_editable

=over 4

=item ������

&is_editable(�ڡ���̾);

=item ����

�Խ��ġ��Բĥե饰

=item �����С��饤��

��

=item ����

�ڡ����ο����������Խ��ġ��Բĥե饰���֤���

=back

=cut

sub is_editable {
	my ($page) = @_;
	return 0 if($fixedpage{$page} || $fixedplugin{$::form{cmd}});
	return 0 if(
		$page=~/([\xa\xd\f\t\[\]])|(\.{1,3}\/)|^\s|\s$|^\#|^\/|\/$|^$|^$interwiki_name1$|^$::ismail$/o);
	return 0 if (not &is_readable($page));
	return 1;
}

=lang ja

=head2 armor_name

=over 4

=item ������

&armor_name(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

�ʲ���ʸ�����Ѵ���Ԥʤ���

��WikiName��WikiName

��WikiName�ǤϤʤ����Ρ�WikiName�ǤϤʤ��ϡ�

=back

=cut

sub armor_name {
	my ($name) = @_;
	return ($name =~ /^$wiki_name$/o) ? $name : "[[$name]]";
}

=lang ja

=head2 unarmor_name

=over 4

=item ������

&armor_name(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

�ʲ���ʸ�����Ѵ���Ԥʤ���

��WikiName��WikiName

���Ρ�WikiName�ǤϤʤ��ϡϢ�WikiName�ǤϤʤ�

=back

=cut

sub unarmor_name {
	my ($name) = @_;
	return ($name =~ /^$bracket_name$/o) ? $1 : $name;
}

=lang ja

=head2 is_bracket_name

=over 4

=item ������

&is_bracket_name(ʸ����);

=item ����

�֥饱�åȤǤ��뤫�Υե饰

=item �����С��饤��

��

=item ����

�֥饱�åȤǤ��뤫�Υե饰���֤���

=back

=cut

sub is_bracket_name {
	my ($name) = @_;
	return ($name =~ /^$bracket_name$/o) ? 1 : 0;
}

=lang ja

=head2 dbmname

=over 4

=item ������

&dbmname(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

ʸ�����DB�Ѥ�HEX�Ѵ����롣

=back

=cut

sub dbmname {
	my ($name) = @_;
#	$name =~ s/(.)/uc unpack('H2', $1)/eg;				# comment
	$name =~ s/(.)/$::_dbmname_encode{$1}/g;
	return $name;
}

=lang ja

=head2 undbmname

=over 4

=item ������

&undbmname(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

DB�Ѥ�HEX�Ѵ����줿ʸ������᤹

=back

=cut

sub undbmname {
	my ($name) = @_;
#	$name =~ s/(.)/uc unpack('H2', $1)/eg;					# comment
	$name =~ s/([0-9A-F][0-9A-F])/$::_dbmname_decode{$1}/g;
	return $name;
}

=lang ja

=head2 decode

=over 4

=item ������

&decode(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

URL���󥳡��ɤ��줿ʸ�����ǥ����ɤ��롣

=back

=cut

sub decode {
	my ($s) = @_;
	$s =~ tr/+/ /;
#	$s =~ s/%([A-Fa-f0-9][A-Fa-f0-9])/pack("C", hex($1))/eg;	# better ? # debug	# comment
	$s =~ s/%([A-Fa-f0-9][A-Fa-f0-9])/chr(hex($1))/eg;
	return $s;
}

=lang ja

=head2 encode

=over 4

=item ������

&encode(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

URL���󥳡��ɤ򤹤롣

=back

=cut

sub encode {
	my ($encoded) = @_;
#	$encoded =~ s/(\W)/'%' . unpack('H2', $1)/eg;		# comment
	$encoded =~ s/(\W)/$::_urlescape{$1}/g;
	return $encoded;
}

=lang ja

=head2 read_resource

=over 4

=item ������

&read_resource(�ե�����̾, %�꥽��������);

=item ����

%�꥽��������

=item �����С��饤��

��

=item ����

�꥽�����ե�������ɤ߹���

=back

=cut

sub read_resource {
	my ($file,%buf) = @_;
	return %buf if $::_resource_loaded{$file}++;
	open(FILE, $file) or &print_error("(resource:$file)");
	while (<FILE>) {
		s/[\r\n]//g;
		next if /^#/;
		s/\\n/\n/g;
		my ($key, $value) = split(/=/, $_, 2);
#		�꥽������EUC�Ǥ��뤳�Ȥ��Ѥ���						# comment
#		$buf{$key} = &code_convert(\$value, $::defaultcode);	# comment
		$buf{$key}=$value;
		$buf{$key}=$::resource_patch{$key} if(defined($::resource_patch{$key}));
	}
	close(FILE);
	return %buf;
}

=lang ja

=head2 conflict

=over 4

=item ������

&conflict(�ڡ���̾, ��ʸ��);

=item ����

0:���ͤʤ� 1:����

=item �����С��饤��

��

=item ����

�ڡ��������ξ��ͤ򸡺����롣

=back

=cut

sub conflict {
	my ($page, $rawmsg) = @_;
	if ($::form{myConflictChecker} eq &get_info($page, $::info_ConflictChecker)) {
		return 0;
	}
	open(FILE, "$::res_dir/conflict.$::lang.txt") or &print_error("(conflict)");
	#v0.1.6 add comment
	my $content;
	foreach(<FILE>) {
		$content.=$_ if(! /^#/);
	}
#	�꥽������EUC�Ǥ��뤳�Ȥ��Ѥ���						# comment
#	$content=&code_convert(\$content, $::defaultcode);		# comment
	close(FILE);

	my $body = &text_to_html($content);
	if (&exist_plugin('edit') == 1) {
		$body .= &plugin_edit_editform($rawmsg, $::form{myConflictChecker}, frozen=>0, conflict=>1);
	}

	&skinex($page, $body, 0);
	return 1;
}

=lang ja

=head2 get_now

=over 4

=item ������

�ʤ�

=item ����

ʸ����

=item �����С��饤��

��

=item ����

����������������롣

=back

=cut

sub get_now {
	my (@week) = qw(Sun Mon Tue Wed Thu Fri Sat);
	my ($sec, $min, $hour, $day, $mon, $year, $weekday) = localtime(time);
	$weekday = $week[$weekday];
	return sprintf("%d-%02d-%02d ($weekday) %02d:%02d:%02d",
		$year + 1900, $mon + 1, $day, $hour, $min, $sec);
}

=lang ja

=head2 init_InterWikiName

=over 4

=item ������

�ʤ�

=item ����

%::interwiki, %::interwiki2

=item �����С��饤��

��

=item ����

InterWiki�ν�����򤹤롣

�񼰤ϰʲ��ΤȤ���

[[YukiWiki http://www.hyuki.com/yukiwiki/wiki.cgi?euc($1)]]

[http://www.hyuki.com/yukiwiki/wiki.cgi?$1 YukiWiki] euc

=back

=cut

sub init_InterWikiName {
	my $content = $::database{$InterWikiName};
	while ($content =~ /$interwiki_definition/g) {
		my ($name, $url) = ($1, $2);
		#v0.1.6												# comment
		$name=~tr/A-Z/a-z/;
		$::interwiki{$name} = $url;
	}
	while ($content =~ /$interwiki_definition2/g) {
		#v0.1.6												# comment
		my ($url,$name,$code)=($1,$2,$3);
		$name=~tr/A-Z/a-z/;
		$::interwiki2{$name}{$code} = $url;
	}
}

=lang ja

=head2 interwiki_convert

=over 4

=item ������

&interwiki_convert($type, $localname);


=item ����

�Ѵ����ʸ����

=item �����С��饤��

��

=item ����

InterWiki��URL�ؤ��Ѵ��򤹤롣

=back

=cut

sub interwiki_convert {
	my ($type, $localname) = @_;
	if ($type eq 'sjis' or $type eq 'euc' or $type eq 'utf8') {
		$localname=&code_convert(\$localname, $type, $::defaultcode)
			if($localname=~/[\xa1-\xfe]/);
		return &encode($localname);
	} elsif (($type eq 'ykwk') || ($type eq 'yw')) {
		# for YukiWiki1
		if ($localname =~ /^$wiki_name$/) {
			return $localname;
		} else {
			$localname=&code_convert(\$localname, 'sjis', $::defaultcode)
				if($localname=~/[\xa1-\xfe]/);
			return &encode("[[" . $localname . "]]");
		}
#	} elsif (($type eq 'asis') || ($type eq 'raw')) {		# comment
#		return $localname;									# comment
	} else {
		return $localname;
	}
}

=lang ja

=head2 get_info

=over 4

=item ������

&get_info(�ڡ���̾, ����);


=item ����

��������ʸ����

=item �����С��饤��

��

=item ����

InfoBase��������������롣

=back

=cut

sub get_info {
	my ($page, $key) = @_;
	if ($key eq $info_IsFrozen) {
		return ($::database{$page} =~ /\n?#freeze\r?\n/) ? 1 : 0;
	}
	my %info = map { split(/=/, $_, 2) } split(/\n/, $infobase{$page});
	&close_info_db;
	return $info{$key};
}

# old get_info									# comment
#sub get_info {									# comment
#	my ($page, $key) = @_;						# comment
#	my %info = map { split(/=/, $_, 2) } split(/\n/, $infobase{$page});	# comment
#	return $info{$key};							# comment
#}												# comment

=lang ja

=head2 set_info

=over 4

=item ������

&set_info(�ڡ���̾, ����, ����);


=item ����

�ʤ�

=item �����С��饤��

��

=item ����

InfoBase�˾�������ꤹ�롣

=back

=cut

sub set_info {
	my ($page, $key, $value) = @_;
	if ($key eq $info_IsFrozen) {	# ���							# comment
		# ���Ѥ�													# comment
		if ($::database{$page} =~ /\n?#freeze\r?\n/) {
			if ($value == 0) {	# �����							# comment
				$::database{$page} =~ s/\n?#freeze\r?\n//g;
			}
		} elsif ($value == 1) {	# ���								# comment
			$::database{$page} = "#freeze\n" . $::database{$page}
				if($::database{$page} !~ /\n?#freeze\r?\n/);;
		}
		return;
	}
	my %info = map { split(/=/, $_, 2) } split(/\n/, $infobase{$page});
	$info{$key} = $value;
	my $s = '';
	for (keys %info) {
		$s .= "$_=$info{$_}\n";
	}
	$infobase{$page} = $s;
}

# old set_info													# comment
#sub set_info {													# comment
#	my ($page, $key, $value) = @_;								# comment
#	my %info = map { split(/=/, $_, 2) } split(/\n/, $infobase{$page});	# comment
#	$info{$key} = $value;										# comment
#	my $s = '';													# comment
#	for (keys %info) {											# comment
#		$s .= "$_=$info{$_}\n";									# comment
#	}															# comment
#	$infobase{$page} = $s;										# comment
#}																# comment

=lang ja

=head2 frozen_reject

=over 4

=item ������

($::form{mypage});

=item ����

0:��뤵��Ƥ��ʤ����ޤ���ǧ�ںѤ� 1:��뤵��Ƥ��롣

=item �����С��饤��

��

=item ����

����ǧ�ڤ�Ԥʤ���

=back

=cut

sub frozen_reject {
	my ($isfrozen) = &get_info($::form{mypage}, $info_IsFrozen);
	my ($willbefrozen) = $::form{myfrozen};
	my %auth;
	if (not $isfrozen and not $willbefrozen) {
		# You need no check.
		return 0;
	} else {
		%auth=&authadminpassword(form,"","frozen");
		return ($auth{authed} eq 0 ? 1 : 0);
	}
	return 0;
}

=lang ja

=head2 is_frozen

=over 4

=item ������

&is_frozen(�ڡ���̾);

=item ����

0:��뤵��Ƥ��ʤ� 1:��뤵��Ƥ��롣

=item �����С��饤��

��

=item ����

���ꤷ���ڡ�������뤵��Ƥ��뤫�����å����롣

=back

=cut

sub is_frozen {
	my ($page) = @_;
	if($::newpage_auth eq 1) {
		return 1 if(!&is_exist_page($page));
	}
	return &get_info($page, $info_IsFrozen);
}

=lang ja

=head2 exist_plugin

=over 4

=item ������

&exist_plugin(�ץ饰����̾);

=item ����

0:�ʤ� 1:PyukiWiki 2:YukiWiki

=item �����С��饤��

��

=item ����

�ץ饰������ɤ߹���

=back

=cut

sub exist_plugin {
	my ($plugin) = @_;

	if (!$_plugined{$plugin}) {
		my $path = "$::plugin_dir/$plugin" . '.inc.pl';
		if (-e $path) {
			require $path;
			$::debug.=$@;
			$_plugined{$1} = 1;	# Pyuki
			#v0.1.6										# comment
			$path="$::res_dir/$plugin.$::lang.txt";
			%::resource = &read_resource($path,%::resource) if(-r $path);
			return 1;
		} else {
			$path = "$::plugin_dir/$plugin" . '.pl';
			if (-e $path) {
				require $path;
				$::debug.=$@;
				$_plugined{$1} = 2;	# Yuki
				return 2;
			}
		}
		return 0;
	}
	return $_plugined{$plugin};
}

=lang ja

=head2 exist_explugin

=over 4

=item ������

&exist_explugin(�ץ饰����̾);

=item ����

0:�ʤ� 1:�ɤ߹��ߺѤ�

=item �����С��饤��

�Բ�

=item ����

��ĥ�ץ饰������ɤ߹���

=back

=cut

sub exist_explugin {
	my ($explugin) = @_;

	if (!$_exec_plugined{$explugin}) {
		my $path = "$::explugin_dir/$explugin" . '.inc.cgi';
		if (-e $path) {
			require $path;
			$::debug.=$@;
			$_exec_plugined{$1} = 1;	# Loaded		# comment
			$path="$::res_dir/$explugin.$::lang.txt";
			%::resource = &read_resource($path,%::resource) if(-r $path);
			return 1;
		}
		return 0;
	}
	return $_exec_plugined{$explugin};
}

=lang ja

=head2 exec_explugin_last

=over 4

=item ������

&exec_explugin_last;

=item ����

0:�ʤ� 1:�ɤ߹��ߺѤ�

=item �����С��饤��

�Բ�

=item ����

��ĥ�ץ饰�����κǽ������򤹤롣

=back

=cut

sub exec_explugin_last {
	if($::useExPlugin > 0) {
		foreach(split(/,/,$explugin_last)) {
			next if ($_ eq '');
			my $action = $_;
#			print "debug Exec $_<br />\n" if ($::mode_debug eq 1);	# comment
			eval $action;
		}
	}
}

=lang ja

=head2 embedded_to_html

=over 4

=item ������

&embedded_to_html(ʸ����);

=item ����

ʸ����

=item �����С��饤��

��

=item ����

�֥�å����ץ饰�����¹Ԥ��롣

=back

=cut

sub embedded_to_html {
	my $embedded = shift;

	if ($embedded =~ /$embed_plugin/) {
		my $exist = &exist_plugin($1);
		my $action = '';
		if ($exist == 1) {
			$action = "\&plugin_" . $1 . "_convert('$3')";
		} elsif ($exist == 2) {
			$action = "\&$1::plugin_block('$3');";
		}
		if ($action ne '') {
			$_ = eval $action;
			$::debug.=$@;
			return ($_) ? $_ : &htmlspecialchars($embedded);
		}
	}
	return $embedded;
}

=lang ja

=head2 embedded_inline

=over 4

=item ������

&embedded_inline(ʸ����);

=item ����

ʸ����

=item �����С��饤��

��

=item ����

����饤�󷿥ץ饰�����¹Ԥ��롣

=back

=cut

sub embedded_inline {
	my ($embedded,$opt)=@_;
	my($cmd,$arg);
	if($embedded=~/$::embedded_inline/g) {
		if($1 ne '') {
			$cmd=$1;
			$arg=$2;
		} elsif($3 ne '') {
			$cmd=$3;
		} elsif($4 ne '') {
			$cmd=$4;
			$arg=$5;
		} elsif($6 ne '') {
			$cmd=$6;
			$arg="$7,$8";
		}
		my $exist = &exist_plugin($cmd);
		my $action = '';
		if ($exist == 1) {
			$action = "\&plugin_" . $cmd . "_inline('$arg')";
		} elsif ($exist == 2) {
			$action = "\&" . $cmd . "::plugin_inline('$arg');";
		}
		if ($action ne '') {
			$_ = eval $action;
			$::debug.=$@;
			return $_ if ($_);
		}
	}
	# buf fix v0.2.0									# comment
	return $embedded;
#	return $embedded if($opt eq 2);						# comment
#	return &unescape($embedded);						# comment
}

=lang ja

=head2 load_module

=over 4

=item ������

&load_module(�⥸�塼��̾);

=item ����

�⥸�塼��̾

=item �����С��饤��

��

=item ����

Perl�⥸�塼����ɤ߹���

=back

=cut

sub load_module{
	my $mod = shift;
	return $mod if $::_module_loaded{$mod}++;
	eval qq( require $mod; );
	unless($@) {						# debug
		$::debug.="$mod Loaded\n"		# debug
	} else {							# debug
		$::debug.="$mod Load failed\n"	# debug
	}									# debug
	$mod=undef if($@);
	return $mod;
}

=lang ja

=head2 code_convert

=over 4

=item ������

&code_convert(ʸ����, [euc|sjis|utf8|jis��] [,���ϥ�����]);

=item ����

ʸ����

=item �����С��饤��

��

=item ����

����饯���������ɤ��Ѵ����롣

=back

=cut

sub code_convert {
	my ($contentref, $kanjicode, $icode) = @_;
	if($$contentref ne '') {
		if ($::lang eq 'ja') {
			if($::code_method{ja} eq 'jcode.pl') {
				die "Unsupport jcode.pl";
			} else {
				&load_module("Jcode");
				$$contentref .= '';
				# add v 0.2.0								# comment
				$$contentref=~s/\xef\xbd\x9e/\xe3\x80\x9c/g;# �� # comment
				&Jcode::convert($contentref, $kanjicode, $icode);
				# add v 0.2.0								# comment
				$$contentref=~s/\xe3\x80\x9c/\xef\xbd\x9e/g;# �� # comment
			}
		}
	}
	return $$contentref;
}

=lang ja

=head2 is_exist_page

=over 4

=item ������

&is_exist_page(�ڡ���̾);

=item ����

�ڡ�����¸�ߤ����翿

=item �����С��饤��

��

=item ����

�ڡ�����¸�ߤ��뤫�����å�����

=back

=cut

sub is_exist_page {
	my ($name) = @_;
	return 0 if($name eq '');
	foreach(keys %::fixedpage) {
		if($::fixedpage{$_} ne '' && $_ eq $name) {
			return 1;
		}
	}
	return ($use_exists) ? exists($::database{$name}) : $::database{$name};
}

=lang ja

=head2 trim

=over 4

=item ������

&trim(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

ʸ����������(Ⱦ��)����������

=back

=cut

sub trim {
	my ($s) = @_;
	$s =~ s/^\s*(\S+)\s*$/$1/o; # trim		# comment
	return $s;
}

=lang ja

=head2 escape

=over 4

=item ����

&escape(ʸ����);

=item ����

�������줿ʸ����

=item �����С��饤��

��

=item ����

HTML�����򥨥������פ��롣

=back

=cut

sub escape {
	return &htmlspecialchars(shift);
}

=lang ja

=head2 unescape

=over 4

=item ������

&unescape(ʸ����);

=item ����

�������줿ʸ����

=item �����С��饤��

��

=item ����

���������פ��줿HTML�������᤹��

=back

=cut

sub unescape {
	my $s=shift;
	$s=~s/\&(amp|lt|gt|quot);/$::_unescape{$1}/g;
	return $s;
}

=lang ja

=head2 htmlspecialchars

=over 4

=item ������

&htmlspecialchars(ʸ����,[SGML���֤��ᤵ�ʤ����1]);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

HTMLʸ����򥨥������פ��롣

=back

=cut

sub htmlspecialchars {
	my($s,$flg)=@_;
	return $s if($s!~/([<>"&])/);

	$s=~s/([<>"&])/$::_htmlspecial{$1}/g;
	return $s if($flg eq 1);
	# ��ʸ����SGML���λ��Ȥ��᤹						# comment
	$s=~s/&amp;($::_sgmlescape);/&$1;/g;
	# 10�ʡ�16�ʼ��ֻ��Ȥ��᤹							# comment
	$s=~s/&amp;#([0-9A-Fa-fXx]+)?;/&#$1;/g;
	return $s;
}

=lang ja

=head2 javascriptspecialchars

=over 4

=item ������

&javaspecialchars(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

JavaScriptʸ���������˼¹ԤǤ���褦�˥��������פ��롣

=back

=cut

sub javascriptspecialchars {
	my($s)=@_;
	$s=&htmlspecialchars($s);
	$s=~s|'|&apos;|g;
	return $s;
}

=lang ja

=head2 valid_password

=over 4

=item ������

&valid_password(���Ϥ��줿�ѥ����,admin|frozen|attach,�Ź沽���줿�ѥ����,�ȡ�����);

=item ����

�ѥ���ɤ����פ��Ƥ�����1�����פ��Ƥ��ʤ����0

=item �����С��饤��

��

=item ����

�����ԥѥ����ǧ�ڤ򤹤롣

=back

=cut
	# 2005.10.27 pochi: ź���ѥѥ���ɤ�����			# comment
	# ���Ѵ����ѥ�����б�							# comment
	# $::adminpass / $::adminpass{attach} ....			# comment
sub valid_password {
	my ($givenpassword,$type,$enc,$token) = @_;

	$givenpassword=&password_decode($givenpassword,$enc,$token);
	my($pass,$salt);
	if($::adminpass{$type} eq '') {
		($pass,$salt)=split(/ /,$::adminpass);
		$salt="AA" if($salt eq '');
		return (crypt($givenpassword, $salt) eq $pass) ? 1 : 0;
	}
	($pass,$salt)=split(/ /,$::adminpass{$type});
	$salt="AA" if($salt eq '');
	return 1 if(crypt($givenpassword, $salt) eq $pass);

	($pass,$salt)=split(/ /,$::adminpass);
	$salt="AA" if($salt eq '');
	return (crypt($givenpassword, $salt) eq $pass) ? 1 : 0;
}

=lang ja

=head2 password_decode

=over 4

=item ������

&password_decode([���ѥ����], ���󥳡��ɤ��줿�ѥ����, �ȡ�����);

=item ����

���Υѥ����

=item �����С��饤��

��

=item ����

�ѥ���ɤ�ǥ����ɤ��롣

=back

=cut

# pure code of http://ninja.index.ne.jp/~toshi/soft/untispam.shtml	# comment

sub password_decode {
	my($passwd,$enc,$token)=@_;
	my $dec;

	if($passwd eq '' && $enc ne '' && $token ne '' && &iscryptpass) {

		for(my $i=0; $i<length($enc); $i+=4) {
			my $dif=index($token,substr($enc,$i,1)) * length($token) + index($token,substr($enc,$i+1,1));
			my $c=index($token,substr($enc,$i+2,1));
			my $d=$c * length($token) + index($token,substr($enc,$i+3,1)) - $dif;
			$dec=$dec . chr($d);
		}
		return $dec;
	}
	return $passwd;
}

=lang ja

=head2 password_encode

=over 4

=item ������

&password_encode(���󥳡��ɤ��줿�ѥ����, �ȡ�����);

=item ����

���Υѥ����

=item �����С��饤��

��

=item ����

�ѥ���ɤ�Ź沽���롣

=back

=cut

# reverse code of http://ninja.index.ne.jp/~toshi/soft/untispam.shtml	# comment

sub password_encode {
	my($str, $token) = @_;
	my($i, $dd, $res, $dif );
	my $enc_list = $token;
	for( $i = 0 ; $i < length( $str ) ; $i ++ ) {
		$dif = (int(rand(127))+$i)%127;
		$res .= substr($enc_list,$dif/0x10,1).substr($enc_list,$dif%0x10,1);
		$dd = ord(substr($str,$i,1))+$dif;
		$res .= substr($enc_list,$dd/0x10,1).substr($enc_list,$dd%0x10,1);
	}
	return( $res );
}

=lang ja

=head2 passwordform

=over 4

=item ������

&passwordform(���Ϥ����ѥ����, [hidden], [�ե�����̾]);

=item ����

HTML

=item �����С��饤��

��

=item ����

�ѥ���ɥե��������Ϥ��롣

=back

=cut

sub passwordform {
	my($default,$mode,$formname,$enc,$token)=@_;
	$formname="mypassword" if($formname eq '');

	if(&iscryptpass) {
		if($enc eq '') {
			$cryptpassform=<<EOM;
<input type="hidden" name="$formname\_enc" id="$formname\_enc" value="" /><input type="hidden" id="$formname\_token" name="$formname\_token" value="$::Token" />
EOM
		} else {
			my $newpass=&password_encode(&password_decode('',$enc,$token), $::Token);
			$cryptpassform=<<EOM;
<input type="hidden" name="$formname\_enc" id="$formname\_enc" value="$newpass" /><input type="hidden" name="$formname\_token" id="$formname\_token" value="$::Token" />
EOM
		}
	}

	if($mode eq 'hidden') {
		return qq(<input type="hidden" name="$formname" id="$formname" value="$default" />$cryptpassform);
	} elsif($default eq '') {
		return qq(<input type="password" name="$formname" id="$formname" value="" size="10" />$cryptpassform);
	} else {
		return qq(<input type="password" name="$formname" id="$formname" value="$default" size="10" />$cryptpassform);
	}
}

=lang ja

=head2 authadminpassword

=over 4

=item ������

&authadminpassword(form|input, �����ȥ�, attach|frozen|admin);

=item ����

%ret{authed}, %ret{html}, %ret{crypt}

=item �����С��饤��

��

=item ����

�����ԥѥ��������ǧ�ڤ򤷡�ɬ�פǤ���Хѥ���ɥե������HTML����Ϥ򤹤롣

=back

=cut

sub authadminpassword {
	my($mode,$title,$type)=@_;
	my $body;

	$type=($type eq "attach" ? "attach" : $type eq "frozen" ? "frozen" : "admin");
	if($mode=~/submit|page|form/) {
		$title=$::resource{admin_passwd_prompt_title} if($title eq '');
		if(!&valid_password($::form{"mypassword_$type"},$type,$::form{"mypassword_$type\_enc"},$::form{"mypassword_$type\_token"})) {
			$body=<<EOM;
<h2>$title</h2>
@{[$ENV{REQUEST_METHOD} eq 'GET' && $::form{mypassword} eq '' ? '' : qq(<div class="error">$::resource{admin_passwd_prompt_error}</div>\n)]}
<form action="$::script" method="post" id="adminpasswordform" name="adminpasswordform">
$::resource{admin_passwd_prompt_msg}@{[&passwordform('','',"mypassword_$type")]}
EOM
			if(&iscryptpass) {
				$body.=<<EOM;
<span id="submitbutton"></span>
<script type="text/javascript"><!--
	getid("submitbutton").innerHTML='<input type="button" value="$::resource{admin_passwd_button}" onclick="fsubmit(\\'adminpasswordform\\',\\'$type\\');" onkeypress="fsubmit(\\'adminpasswordform\\',\\'$type\\',event);" />';
//--></script>
<noscript><input type="submit" value="$::resource{admin_passwd_button}" /></noscript>
EOM
			} else {
				$body.=<<EOM;
<input type="submit" value="$::resource{admin_passwd_button}" />
EOM
			}
			foreach my $forms(keys %::form) {
				$body.=qq(<input type="hidden" name="$forms" value="$::form{$forms}" />\n)
					if($forms!~/^mypassword/);
			}
			$body.="</form>\n";
			return('authed'=>0,'html'=>$body, 'crypt'=>&iscryptpass);
		} else {
			$body.=qq(@{[&passwordform($::form{"mypassword\_$type"},"hidden","mypassword\_$type",$::form{"mypassword\_$type\_enc"},$::form{"mypassword\_$type\_token"})]}\n);
			return('authed'=>1,'html'=>$body, 'crypt'=>&iscryptpass);
		}
	} else {
		if(!&valid_password($::form{"mypassword_$type"},$type,$::form{"mypassword_$type\_enc"},$::form{"mypassword_$type\_token"})) {
			$body.=<<EOM;
@{[$ENV{REQUEST_METHOD} eq 'GET' && $::form{mypassword} eq '' ? '' : qq(<div class="error">$::resource{admin_passwd_prompt_error}</div>)]}
EOM
			$body.=qq(@{[$title ne '' ? $title : $::resource{admin_passwd_prompt_msg}]}@{[&passwordform('','',"mypassword_$type")]}\n);
			return('authed'=>0,'html'=>$body, 'crypt'=>&iscryptpass);
		} else {
			$body.=qq(@{[&passwordform($::form{"mypassword\_$type"},"hidden","mypassword\_$type",$::form{"mypassword\_$type\_enc"},$::form{"mypassword\_$type\_token"})]}\n);
			return('authed'=>1,'html'=>$body, 'crypt'=>&iscryptpass);
		}
	}
}

=lang ja

=head2 iscryptpass

=over 4

=item ������

�ʤ�

=item ����

��ǽ�Ǥ���С�1 ���֤���

�ޤ���$::Token �˥ȡ�������֤���

=item �����С��饤��

��

=item ����

�ʰװŹ沽����ǽ�Ǥ���У����֤���

=back

=cut

sub iscryptpass {
	if($::Use_CryptPass) {
		if($::Token eq '') {
			$IN_HEAD.=&maketoken;
			$::IN_HEAD.=qq(<script type="text/javascript" src="$::skin_url/passwd.js"></script>\n);
		}
		return 1;
	}
	return 0;
}

=lang ja

=head2 maketoken

=over 4

=item ������

�ʤ�

=item ����

�ȡ�����

=item �����С��饤��

��

=item ����

�ʰװŹ沽�ڤӥ�������ѥ�᡼���ѤΥȡ��������Ϥ��롣

=back

=cut

sub maketoken {
	my $header;
	if($::Token eq '') {
		my (@token) = ('0'..'9', 'A'..'Z', 'a'..'z');
		$::Token="";
		my $add=0;
		for(my $i=0; $i<16;) {
			my $token;
			$token=$token[(time + $add++ + $i + int(rand(62))) % 62];
				 # 62 is scalar(@token)								# comment
			if($::Token!~/$token/) {
				$::Token.=$token;
				$i++;
			}
		}
	}
	$header=qq(<script type="text/javascript"><!--\nvar cs = "$::Token";\n//--></script>\n);
	return $header;
}

=lang ja

=head2 gettz

=over 4

=item ������

�ʤ�

=item ����

GMT�Ȥκ��λ���

=item �����С��饤��

��

=item ����

GMT�Ȥκ������(hour)���֤���

=back

=cut

sub gettz {
	if($::TZ eq '') {
		my $now=time();
		$::TZ=(timegm(localtime($now))-timegm(gmtime($now)))/3600;
	}
	return $::TZ;
}

=lang ja

=head2 getwday

=over 4

=item ������

&getwday($year,$mon,$mday);

=item ����

�����ֹ�

=item �����С��饤��

��

=item ����

���������������

=back

=cut

sub getwday {
	my($year, $mon, $mday) = @_;

	if ($mon == 1 or $mon == 2) {
		$year--;
		$mon += 12;
	}
	return int($year + int($year / 4) - int($year / 100) + int($year / 400)
		+ int((13 * $mon + 8) / 5) + $mday) % 7;
}

=lang ja

=head2 lastday

=over 4

=item ������

&lastday($year,$mon);

=item ����

����ǯ��κǽ���

=item �����С��饤��

��

=item ����

����ǯ��κǽ�������롣

=back

=cut

sub lastday {
	my($year,$mon)=@_;
	return  (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)[$mon - 1]
		+ ($mon == 2 and $year % 4 == 0 and
		($year % 400 == 0 or $year % 100 != 0));
}

=lang ja

=head2 fopen

=over 4

=item ����

&fopen(filename or URL, mode);

=item ����

�ե�����ϥ�ɥ�

=item �����С��饤��

��

=item ����

�ե�����ޤ���URL�򥪡��ץ󤹤�PHP�ߴ��ؿ�

=back

=cut

sub fopen {
	my ($fname, $fmode) = @_;
	my $_fname;
	my $fp;

	# HTTP: ���ä���								# comment
	if ($fname =~ /^http:\/\//) {
		$fname =~ m!(http:)?(//)?([^:/]*)?(:([	0-9]+)?)?(/.*)?!;
		my $host = ($3 ne "") ? $3 : "localhost";
		my $port = ($5 ne "") ? $5 : 80;
		my $path = ($6 ne "") ? $6 : "/";
		if ($::proxy_host) {
			$host = $::proxy_host;
			$port = $::proxy_port;
			$path = $fname;
		}
		my ($sockaddr, $ip);
		$fp = new FileHandle;
		if ($host =~ /^(\d+).(\d+).(\d+).(\d+)$/) {
			$ip = pack('C4', split(/\./, $host));
		} else {
			#HOST̾��IP��ľ��						# comment
			$ip = inet_aton($host) || return 0;	# Host Not Found.
		}
		$sockaddr = pack_sockaddr_in($port, $ip) || return 0; # Can't Create Socket address.	# comment
		socket($fp, PF_INET, SOCK_STREAM, 0) || return 0;	# Socket Error.
		connect($fp, $sockaddr) || return 0;	# Can't connect Server.
		autoflush $fp(1);
		print $fp "GET $path HTTP/1.1\r\nHost: $host\r\n\r\n";
		return $fp;
	} else {
		$fmode = lc($fmode);

		if ($fmode eq 'w') {
			$_fname = ">$fname";
		} elsif ($fmode eq 'w+') {
			$_fname = "+>$fname";
		} elsif ($fmode eq 'a') {
			$_fname = ">>$fname";
		} elsif ($fmode eq 'r') {
			$_fname = $fname;
		} else {
			return 0;
		}
		if (open($fp, $_fname)) {
			return $fp;
		}
	}
	return 0;
}

=lang ja

=head2 escapeoff

=over 4

=item ����

&escapeoff;

=item ����

$::IN_HEAD

=item �����С��饤��

��

=item ����

IE�ˤ����ơ���������ä�Ⱦ�ѡ����ѥ����ȴְ㤨�ơ�ESC�����ǲ����Ƥ��ޤ��Τ��˻ߤ��롣

�ᥤ���JavaScript�ϡ�skin/common?.js �˵��Ҥ���Ƥ��ޤ���

=back

=cut

sub escapeoff {
	if($ENV{HTTP_USER_AGENT}=~/MSIE/ && $ENV{HTTP_USER_AGENT}!~/Opera/) {
		$::IN_HEAD.=<<EOM
<script type="text/javascript"><!--
d.onkeydown=escpress;
//--></script>
EOM
	}
}

=lang ja

=head2 getremotehost

=over 4

=item ����

&getremotehost;

=item ����

$ENV{REMOTE_HOST}

=item �����С��饤��

��

=item ����

��⡼�ȥۥ��Ȥ���Ϥ��롣

=back

=cut

sub getremotehost {
	# from http://www.alib.jp/perl/resolv.html#nocompact	# comment
	# and  http://www2u.biglobe.ne.jp/MAS/perl/waza/dns.html#nocompact	# comment
	if($ENV{REMOTE_HOST} eq '' || $ENV{REMOTE_ADDR} eq $ENV{REMOTE_HOST}) {#nocompact
		my $addr=$ENV{REMOTE_ADDR};#nocompact
		my $ipv4addr;#nocompact
		my $ipv6addr;#nocompact
		if($addr=~/^(?:::(?:f{4}:)?)?((?:0*(?:2[0-4]\d|25[0-5]|[01]?\d\d|\d)\.){3}0*(?:2[0-4]\d|25[0-5]|[01]?\d\d|\d)|(?:\d+))$/) {#nocompact
			$ipv4addr=$1;#nocompact
			$ENV{REMOTE_ADDR}="$ipv4addr";#nocompact
		} elsif($addr=~/:/) {#nocompact
			$ipv6addr=$addr;#nocompact
			$ENV{REMOTE_ADDR}="$ipv6addr";#nocompact
		} else {#nocompact
			$ipv4addr=$addr;#nocompact
			$ENV{REMOTE_ADDR}="$ipv4addr";#nocompact
		}#nocompact
		if($ipv4addr ne '') {#nocompact
			my $host#nocompact
			 = gethostbyaddr(pack("C4", split(/\./, $ENV{REMOTE_ADDR})), 2);#nocompact
			if($host eq '') {#nocompact
				$host=$ENV{REMOTE_ADDR};#nocompact
			}#nocompact
			$ENV{REMOTE_HOST}=$host;#nocompact
		} elsif($ipv6addr ne '') {#nocompact
			if(&load_module("Net::DNS")) {#nocompact
				# IPV6���ɥ쥹��Ÿ�����롣#nocompact	# comment
				my @address;#nocompact
				if ($ipv6addr =~ /::/) {#nocompact
			        my ($adr_a, $adr_b) = split /::/, $ipv6addr;#nocompact
			        my @adr_a = split /:/, $adr_a;#nocompact
			        my @adr_b = split /:/, $adr_b;#nocompact
   					for (scalar @adr_a .. 7 - scalar @adr_b) {#nocompact
						push @adr_a, 0#nocompact
					}#nocompact
					@address = (@adr_a, @adr_b);#nocompact
				} else {#nocompact
					@address = split /:/, $original;#nocompact
				}#nocompact
				$ipv6addr =  (join ":", @address);#nocompact
#nocompact
				# IPV6���ɥ쥹���褹��#nocompact	# comment
				my $resolver = new Net::DNS::Resolver;#nocompact
			    my $ans = $resolver->query($ipv6addr, 'PTR', 'IN');#nocompact
				if($ans) {#nocompact
			        foreach my $rr ($ans->answer) {#nocompact
			                next if $rr->type ne "PTR";#nocompact
			                $ENV{REMOTE_HOST}=$rr->ptrdname;#nocompact
			        }#nocompact
				} else {#nocompact
					$ENV{REMOTE_HOST}="$ipv6addr";#nocompact
				}#nocompact
			} else {#nocompact
				$ENV{REMOTE_HOST}="$ipv6addr";#nocompact
			}#nocompact
		}#nocompact
	}#nocompact
	if($ENV{REMOTE_HOST} eq '') {#compact
		my $host#compact
		 = gethostbyaddr(pack("C4", split(/\./, $ENV{REMOTE_ADDR})), 2);#compact
		if($host eq '') {#compact
			$host=$ENV{REMOTE_ADDR};#compact
		}#compact
		$ENV{REMOTE_HOST}=$host;#compact
	}#compact
}

=lang ja

=head2 dateinit

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

����������ʸ��������ʸ�����������롣

=back

=cut

sub dateinit {
	my $i=0;
	foreach(split(/,/,$::resource{"date_ampm_en"})) {
		$::_date_ampm[$i++]=$_;
	}
	$i=0;
	foreach(split(/,/,$::resource{"date_ampm_".$::lang})) {
		$::_date_ampm_locale[$i++]=$_;
	}
	$i=0;
	foreach(split(/,/,$::resource{"date_weekday_en"})) {
		$::_date_weekday[$i++]=$_;
	}
	$i=0;
	foreach(split(/,/,$::resource{"date_weekday_".$::lang})) {
		$::_date_weekday_locale[$i++]=$_;
	}
	$i=0;
	foreach(split(/,/,$::resource{"date_weekday_en_short"})) {
		$::_date_weekday_short[$i++]=$_;
	}
	$i=0;
	foreach(split(/,/,$::resource{"date_weekday_".$::lang."_short"})) {
		$::_date_weekday_locale_short[$i++]=$_;
	}
}

=lang ja

=head2 date

=over 4

=item ������

&date(format [,unixtime] [,"gmtime"]);

=item ����

�Ѵ����줿����ʸ����

=item �����С��饤��

��

=item ����

���դ�����������ꤷ��PHP�񼰤��Ѵ����롣

=back

=cut

sub date {
	my ($format, $tm, $gmtime) = @_;
	my %weekday;
	my %ampm;

	# yday:0-365 $isdst Summertime:1/not:0
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
		$gmtime ne '' && @_ > 2
			? ($tm+0 > 0 ? gmtime($tm) : gmtime(time))
			: ($tm+0 > 0 ? localtime($tm) : localtime(time));

	$year += 1900;
	my $hr12=$hour=>12 ? $hour-12:$hour;

	# am / pm strings										# comment
	$ampm{en}=$::_date_ampm[$hour>11 ? 1 : 0];
	$ampm{$::lang}=$::_date_ampm_locale[$hour>11 ? 1 : 0];

	# weekday strings										# comment
	$weekday{en}=$::_date_weekday[$wday];
	$weekday{en_short}=$::_date_weekday_short[$wday];
	$weekday{$::lang}=$::_date_weekday_locale[$wday];
	$weekday{$::lang."_short"}=$::_date_weekday_locale_short[$wday];

	# RFC 822 (only this)									# comment
	if($format=~/r/) {
		return &date("D, j M Y H:i:s O",$tm,$gmtime);
	}
	# gmtime & ���󥿡��ͥåȻ���							# comment
	if($format=~/[OZB]/) {
		my $gmt=&gettz;
		$format =~ s/O/sprintf("%+03d:00", $gmt)/ge;	# GMT Time	# comment
		$format =~ s/Z/sprintf("%d", $gmt*3600)/ge;		# GMT Time secs...	# comment
		my $swatch=(($tm-$gmt+90000)/86400*1000)%1000;	# GMT +1:00�ˤ��ơ�������1000beat�ˤ���	# comment
														# ���ܻ��֤ξ�硢AM08:00=000	# comment
		$format =~ s/B/sprintf("%03d", int($swatch))/ge;# internet time	# comment
	}

	# UNIX time
	$format=~s/U/sprintf("%u",$tm)/ge;	# unix time

	$format=~s/lL/\x2\x13/g;	# lL:escape ��-��			# comment
	$format=~s/DL/\x2\x14/g;	# DL:escape ������-������	# comment
	$format=~s/D/\x2\x12/g;		# D:escape Sun-Sat			# comment
	$format=~s/aL/\x1\x13/g;	# aL:escape ���� or ���	# comment
	$format=~s/AL/\x1\x14/g;	# AL:escape ������ʸ��		# comment
	$format=~s/l/\x2\x11/g;		# l:escape Sunday-Saturday	# comment
	$format=~s/a/\x1\x11/g;		# a:escape am pm			# comment
	$format=~s/A/\x1\x12/g;		# A:escape AM PM			# comment
	$format=~s/M/\x3\x11/g;		# M:escape Jan-Dec			# comment
	$format=~s/F/\x3\x12/g;		# F:escape January-December	# comment

	# ���뤦ǯ�����η������								# comment
	if($format=~/[Lt]/) {
		my $uru=($year % 4 == 0 and ($year % 400 == 0 or $year % 100 != 0)) ? 1 : 0;
		$format=~s/L/$uru/ge;
		$format=~s/t/(31, $uru ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)[$mon]/ge;
	}

	# year													# comment
	$format =~ s/Y/$year/ge;	# Y:4char ex)1999 or 2003	# comment
	$year = $year % 100;
	$year = "0" . $year if ($year < 10);
	$format =~ s/y/$year/ge;	# y:2char ex)99 or 03		# comment

	# month													# comment
	my $month = ('January','February','March','April','May','June','July','August','September','October','November','December')[$mon];
	$mon++;									# mon is 0 to 11 add 1	# comment
	$format =~ s/n/$mon/ge;					# n:1-12				# comment
	$mon = "0" . $mon if ($mon < 10);
	$format =~ s/m/$mon/ge;					# m:01-12				# comment

	# day													# comment
	$format =~ s/j/$mday/ge;				# j:1-31		# comment
	$mday = "0" . $mday if ($mday < 10);
	$format =~ s/d/$mday/ge;				# d:01-31		# comment

	# hour													# comment
	$format =~ s/g/$hr12/ge;				# g:1-12		# comment
	$format =~ s/G/$hour/ge;				# G:0-23		# comment
	$hr12 = "0" . $hr12 if ($hr12 < 10);
	$hour = "0" . $hour if ($hour < 10);
	$format =~ s/h/$hr12/ge;				# h:01-12		# comment
	$format =~ s/H/$hour/ge;				# H:00-23		# comment

	# minutes												# comment
	$format =~ s/k/$min/ge;					# k:0-59		# comment
	$min = "0" . $min if ($min < 10);
	$format =~ s/i/$min/ge;					# i:00-59		# comment

	# second												# comment
	$format =~ s/S/$sec/ge;					# S:0-59		# comment
	$sec = "0" . $sec if ($sec < 10);
	$format =~ s/s/$sec/ge;					# s:00-59		# comment

	$format =~ s/w/$wday/ge;				# w:0(Sunday)-6(Saturday)	# comment

	$format =~ s/I/$isdst/ge;	# I(Upper i):1 Summertime/0:Not	# comment

	$format =~ s/\x1\x11/$ampm{en}/ge;			# a:am or pm		# comment
	$format =~ s/\x1\x12/uc $ampm{en}/ge;		# A:AM or PM		# comment
	$format =~ s/\x1\x13/$ampm{$::lang}/ge;		# A:���� or ���	# comment
	$format =~ s/\x1\x14/uc $ampm{$::lang}/ge;	# ������ʸ��		# comment

	$format =~ s/\x2\x11/$weekday{en}/ge;		# l(lower L):Sunday-Saturday	# comment
	$format =~ s/\x2\x12/$weekday{en_short}/ge;	# D:Mon-Sun	# comment
	$format =~ s/\x2\x13/$weekday{"$::lang" . "_short"}/ge;	# D:Mon-Sun	# comment
	$format =~ s/\x2\x14/$weekday{$::lang}/ge;

	$format =~ s/\x3\x11/substr($month,0,3)/ge;	# M:Jan-Dec				# comment
	$format =~ s/\x3\x12/$month/ge;				# F:January-December	# comment

	$format =~ s/z/$yday/ge;	# z:days/year 0-366					# comment
	return $format;

	# moved date format document to plugin/date.inc.pl or date.inc.pl.ja.pod	# comment
}

1;
__END__
