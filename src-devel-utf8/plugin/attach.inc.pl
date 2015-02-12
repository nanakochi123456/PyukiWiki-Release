######################################################################
# attach.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: attach.inc.pl,v 1.339 2012/03/18 11:23:57 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
# Author: Nekyo http://nekyo.qp.land.to/
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
# 2012/01/11: md5_file関数で、メモリの確保の方法を変更
#             容量の表示を関数化した。
# 2011/08/30: Operaでも文字化けするのを修正
# 2011/08/03: 添付ファイルのアップロード、及び、削除を
#             管理者にメール通知するようにしました。
#             また、$::non_listに記載されているページのファイルを
#             表示しない $::attach_nonlist 変数を追加した。
# 2011/06/19: 一部ファイルは、$::AttachFileCheck=0 にしないと
# 　　　　　　アップロードできなくなるようにしました。
# 2011/05/27: ウィルス対策ソフトのそこそこの普及により一部拡張子を
#             有効化
# 2010/11/17: カウンター対応
# 2010/10/24: 一部修正
######################################################################

#use strict;
use CGI qw(:standard);
use Nana::MD5 qw(md5_hex);
use File::MMagic;

# add 0.1.8											# comment
require "plugin/counter.inc.pl";

@magic_files=(
	"$::explugin_dir/File/magic.txt",
	"$::explugin_dir/File/magic_compact.txt",
	"/etc/magic",
	"/usr/etc/magic",
	"/usr/share/etc/magic",
	"/usr/share/misc/magic",
);

	# 正規表現の拡張子 => "(mime-type)|(fileコマンドの返答候補リスト)|..."	# comment
my %mime = (
	# archive files												# comment
	'\.(zip|nar|jar)'	=> "application/x-zip|ZIP",
	'\.(lzh|lha)'		=> "application/x-lha|LHa",
	'\.(tgz|gz)'		=> "application/x-gzip|gzip compressed data",
	'\.(bz|tbz|bz2)'	=> "application/x-bzip2|bzip2 compressed data",
	'\.(txz|xz)'		=> "application/octet-stream|xz compressed data",
	'\.tar'				=> "application/x-tar|tar archive",
	'\.cab'				=> "application/octet-stream|Cabinet",
	'\.rar'				=> "application/octet-stream|RAR",
	'\.7z'				=> "application/octet-stream|7z",
#	'\.bin'				=> "application/octet-stream|data",
	'\.hqx'				=> "application/mac-binhex40|BinHex",
	'\.sit'				=> "application/x-stuffit|StuffIt",

	# Microsoft Office Files									# comment
	'\.(do[ct])'		=> "application/msword|Word|Office",
	'\.(ppt|pps|pot)'	=> "application/mspowerpoint|Office",
	'\.(xls|csv)'		=> "application/vnd.ms-excel|Excel|Office",
	'\.mpp'				=> "application/vnd.ms-project|Office", # project # comment
	# 以下は正式なmime-typeではありません						# comment
	'\.(md[baentwz])'	=> "application/vnd.ms-access|G3", # access	# comment
	'\.(vs[dstw])'		=> "application/vnd.ms-visio|Office", # visio	# comment
	'\.pub'				=> "application/vnd.ms-publisher|Office", # publisher	# comment
	'\.one'				=> "application/vnd.ms-onenote|data", # one note	# comment

	# Open Office Files											# comment
	'\.odb'				=> "application/vnd.sun.xml.base|Zip",	# base	# comment
	'\.(o[dt]s)|(s[tx]c)'=>"application/vnd.sun.xml.calc|Zip",	# calc	# comment
	'\.(o[dt]g)|(s[tx]d)'=>"application/vnd.sun.xml.draw|Zip",	# draw	# comment
	'\.(o[dt]p)|(s[tx]i)'=>"application/vnd.sun.xml.impress|Zip",	# impress	# comment
	'\.(odf)(sxm)'		=> "application/vnd.sun.xml.math|Zip",	# math (not supoprt .mml)	# comment
	'\.(o[dt]t)|(s[tx]w)'=>"application/vnd.sun.xml.writer|Zip",	# writer	# comment

	# Application Files											# comment
	'\.pdf'				=> "application/pdf|PDF document",
	'\.swf'				=> "application/x-shockwave-flash|Flash",
	'\.iso'				=> "application/octet-stream|ISO",

	# Sound Files												# comment
	'\.(midi?|kar|rmi)'	=> "audio/midi|audio/unknown|MIDI",
	'\.(mp[23]|mpga)'	=> "audio/mpeg|MP3|MPEG|audio|voice",
	'\.(wav|wma)'		=> "audio/x-wav|PCM|ITU|GSM|MPEG|audio|voice",
	'\.(aif[fc]?)'		=> "audio/x-aiff|AIFF|audio|voice|patch",
	'\.ram?'			=> "audio/x-pn-realaudio|Real",
	'\.ogg'				=> "application/ogg|Ogg",
	'\.(au|snd)'		=> "audio/basic|audio",

	# Phone sound files											# comment
#	'\.mld'				=> "text/plain|data", #DoCoMo (text/plainが奨励されている)		# comment
	'\.mmf'				=> "application/vnd.smaf|SMAF", #SoftBank(not iphone)/au	# comment

	# Image Files												# comment
	'\.bmp'				=> "image/bmp|bitmap",
	'\.gif'				=> "image/gif|GIF",
	'\.jpe?g'			=> "image/jpeg|JPEG",
	'\.png'				=> "image/png|PNG",
	'\.tiff?'			=> "image/tiff|TIFF",

	# Video Files												# comment
	'\.mpe?g'			=> "video/mpeg|MPEG|Microsoft|ASF|AVI|Div|video",
	'\.(avi|asf|wmv)'	=> "video/x-msvideo|Microsoft|ASF",
	'\.rmm?'			=> "application/vnd.rn-realmedia|Real|Video",
	'\.(qt|mov)'		=> "video/quicktime|Apple|QuickTime|Video",
	'\.mp4'				=> "video/mp4|MP4|Video",
	'\.ogv'				=> "video/ogv|Ogg|Vorbis|Video",
	'\.webm'			=> "video/webm|webm|Video",
	'\.flv'				=> "video/x-flv|Flash|Video",

	# Document Files											# comment
	'\.txt'				=> "text/plain|text",
	'\.([ch]p?p?)'		=> "text/plain|text",			# C/C++ソース	# comment
	'\.(js)'			=> "text/x-javascript|text",	# JavaScript	# comment
	'\.(cgi|p[lm])'		=> "text/plain|text",			# perl			# comment
	'\.(php|rb)'		=> "text/plain|text",			# php/ruby		# comment

	'\.html?'			=> "text/html|HTML document",
	'\.(xhtml|xhtm|xht)'=> "application/xhtml+xml|XML|XSL|HTML",
	'\.eml'				=> "text/plain|text",
	'\.(mht|mhtm|mhtml)'=> "text/plain|text",
	'\.rdf'				=> "application/rdf+xml|XSL|XML",
	'\.(xml|xsl)'		=> "application/xml|XSL|XML",
	'\.(css)'			=> "text/plain|text",

	# exec files, etc...												# comment
#	'\.(exe|com)'		=> "application/octet-stream|MS Exec File",		# comment
	'\.(exe)'			=> "application/octet-stream|MS Exec File",
	'\.(chm|hlp)'		=> "application/octet-stream|MS Help File",
	'\.(msi)'			=> "application/octet-stream|MS installer",

);

#--------------------------------------------------------
# 2005.12.19 pochi: mod_perlで実行可能に								# comment
$::functions{"md5_file"} = \&md5_file;
$::functions{"attach_mime_content_type"} = \&attach_mime_content_type;
$::functions{"attach_magic"} = \&attach_magic;
$::functions{"attach_form"} = \&attach_form;
$::functions{"authadminpassword"} = \&authadminpassword;
$::functions{"date"} = \&date;
$::functions{"plugin_attach_bytes"}=\&plugin_attach_bytes;

# file icon image														# comment
if (!$::file_icon) {
	$::file_icon = '<img src="'
		. $::image_url
		. '/file.png" width="20" height="20" alt="file" style="border-width:0px" />';
}

sub attach_magic {
	my ($file)=@_;
	my $buf;
	my $magic_file;
	foreach(@magic_files) {
		if(-r $_) {
			my $mm = File::MMagic->new($_);
			if(open(R,$file)) {
				if(sysread(R,$buf,0x10000)) {
					close(R);
					return $mm->checktype_contents($buf);
				}
				close(R);
			}
		return "";
		}
	}
	return &attach_mime_content_type($file);
}

#-------- convert													# comment
sub plugin_attach_convert
{
	if (!$::file_uploads) {
		return 'file_uploads disabled';
	}

	my $nolist = 0;
	my $noform = 0;

	my @arg = split(/,/, shift);
	if (@arg > 0) {
		foreach (@arg) {
			$_ = lc $_;
			$nolist |= ($_ eq 'nolist');
			$noform |= ($_ eq 'noform');
		}
	}
	my $ret = '';
	if (!$nolist) {
	#	$obj = &new AttachPages($vars['page']);
	#	$ret .= $obj->toString($vars['page'],1);
	}
	if (!$noform) {
		$ret .= &attach_form($::form{mypage});
	}
	return $ret;
}

my %_attach_messages;

#アップロードフォーム												# comment
sub attach_form
{
	my $page = $::form{mypage};	#split(/,/, shift);
#	$r_page = rawurlencode($page);									# comment
	my $r_page = $page;
	my $s_page = &htmlspecialchars($page);
	my $navi =<<"EOD";
  <span class="small">
   [<a href="$::script?cmd=attach&amp;mypage=@{[&encode($page)]}&amp;pcmd=list&amp;refer=@{[&encode($r_page)]}">$::resource{'attach_plugin_msg_listpagelink'}</a>]
   [<a href="$::script?cmd=attach&amp;mypage=@{[&encode($page)]}&amp;pcmd=list">$::resource{'attach_plugin_msg_listall'}</a>]
  </span><br />
EOD
	return $navi if (!$::file_uploads);

	my $maxsize = $::max_filesize;
	my $msg_maxsize = $::resource{attach_plugin_msg_maxsize};
	my $kb = &plugin_attach_bytes($maxsize);
	$msg_maxsize =~ s/%s/$kb/g;

	my $pass = '';
	if ($::file_uploads == 2) {
		%auth=&authadminpassword("input",$::resource{attach_plugin_msg_password},"attach");
		$pass='<br />' . $auth{html};
#		$pass = '<br />' . $::resource{attach_plugin_msg_password}	# comment
#			. ': <input type="password" name="pass" size="8" />';	# comment
	}
	return <<"EOD";
<form enctype="multipart/form-data" action="$::script" method="post" id="attach_form" name="attach_form">
 <div>
  <input type="hidden" name="cmd" value="attach" />
  <input type="hidden" name="pcmd" value="post" />
  <input type="hidden" name="refer" value="$s_page" />
  <input type="hidden" name="mypage" value="$page" />
  <input type="hidden" name="max_file_size" value="$maxsize" />
  $navi
  <span class="small">
   $msg_maxsize
  </span><br />
  $::resource{'attach_plugin_msg_file'}: <input type="file" name="attach_file" />
  $pass
  @{[$auth{crypt} ?
    qq(<span id="attachbutton"></span><script type="text/javascript"><!--\n	gid("attachbutton").innerHTML='<input type="button" value="$::resource{'attach_plugin_btn_upload'}" onclick="fsubmit(\\'attach_form\\',\\'attach\\');" onkeypress="fsubmit(\\'attach_form\\',\\'attach\\',event);" />';\n//--></script>\n<noscript><input type="submit" value="$::resource{'attach_plugin_btn_upload'}" /></noscript>)
    :
   qq(<input type="submit" value="$::resource{'attach_plugin_btn_upload'}" />)
  ]}
 </div>
</form>
EOD
}

sub plugin_attach_bytes {
	my ($size)=@_;
	my $kb = $size . " bytes";
	if($size>1024) {
		$kb = sprintf("%.1f KB", $size / 1024);
	}
	if($size>1024 * 1024) {
		$kb = sprintf("%.1f MB", $size / 1024 / 1024);
	}
	if($size>1024 * 1024 * 1024) {
		$kb = sprintf("%.1f GB", $size / 1024 / 1024 / 1024);
	}
	if($size>1024 * 1024 * 1024 * 1024) {
		$kb = sprintf("%.1f TB", $size / 1024 / 1024 / 1024 / 1024);
	}
	return $kb;
}

sub plugin_attach_action
{
	# backward compatible									# comment
	if ($::form{'openfile'} ne '') {
		$::form{'pcmd'} = 'open';
		$::form{'file'} = $::from{'openfile'};
	}
	if ($::form{'delfile'} ne '') {
		$::form{'pcmd'} = 'delete';
		$::form{'file'} = $::form{'delfile'};
	}

	my $age = $::form{age} ? $::form{age} : 0;
	my $pcmd = $::form{pcmd} ? $::form{pcmd} : '';

	# Authentication												# comment
#	if ($::form{refer} ne '') { #and is_pagename($vars['refer'])) {	# comment
#		my @read_cmds = ('info','open','list');						# comment
#		in_array($pcmd,$read_cmds) ?								# comment
#			check_readable($vars['refer']) : check_editable($vars['refer']);	# comment
#	}	# comment

	# Upload														# comment
	if ($::form{attach_file} ne '') {
	#	my $pass = $::form{pass} ? md5_hex($::form{pass}) : '';		# comment
#		return &attach_upload($::form{attach_file}, $::form{refer}, $::form{mypassword});	# comment
		return &attach_upload($::form{attach_file}, $::form{refer}, $::form{mypassword});
	}

	if ($pcmd eq 'info') {
		return &attach_info;
	} elsif ($pcmd eq 'delete') {
		return &attach_delete;
	} elsif ($pcmd eq 'open') {
		return &attach_open;
	} elsif ($pcmd eq 'list') {
		return &attach_list;
#	} elsif ($pcmd eq 'freeze') {
#		return &attach_freeze(1);
#	} elsif ($pcmd eq 'unfreeze') {
#		return &attach_freeze(0);
#	} elsif ($pcmd eq 'upload') {
#		return &attach_showform;
	}
	return &attach_list if ($::form{mypage} eq '' or !$::database{$::form{mypage}});
	return ('msg'=>"$::form{mypage}\t$::resource{attach_plugin_msg_upload}", 'body'=>&attach_form, 'ispage'=>1);
}

# 詳細フォームを表示												# comment
sub attach_info
{
	my $obj = new AttachFile($::form{refer}, $::form{file}, $::form{age});
	return $obj->getstatus() ? $obj->info()
		: ('msg'=>$::form{refer}, 'body'=>"error:" . $::resource{attach_plugin_err_notfound}, 'ispage'=>1);
}

# 削除																# comment
sub attach_delete
{
	my %auth=&authadminpassword("input","","attach");
	if ($::file_uploads >= 2 && $auth{authed} eq 0) {
		return ('msg'=>$::form{refer}, 'body'=>$::resource{attach_plugin_err_password});
	}

	my $obj = new AttachFile($::form{refer}, $::form{file}, $::form{age});

	# add v0.2.0													# comment
	if($obj->getstatus()) {
		my $file=$::form{file};
		$file.=$::form{age} ne '' ? " (Backup No.$::form{age})" : "";
		&send_mail_to_admin($::form{refer}, "AttachDelete", $file);
		return $obj->delete();
	} else {
		return ('msg'=>"$::form{mypage}\t$::resource{attach_plugin_err_notfound}",, 'body'=>&attach_form, 'ispage'=>1);
	}
#	return $obj->getstatus()								# comment
#		? $obj->delete()									# comment
#		: ('msg'=>"$::form{mypage}\t$::resource{attach_plugin_err_notfound}",, 'body'=>&attach_form, 'ispage'=>1);							# comment
}

# ダウンロード														# comment
sub attach_open
{
	my $obj = new AttachFile($::form{refer}, $::form{file}, $::form{age});
	return $obj->getstatus() ? $obj->open()
		: ('msg'=>$::form{refer}, 'body'=>"error:" . $::resource{attach_plugin_err_notfound});
}

# 一覧取得														# comment
sub attach_list
{
	my $refer = $::form{refer};
	my $obj = new AttachPages($refer);
#	my $msg = $::resource{$refer eq '' ? 'attach_msg_listall' : 'attach_msg_listpage'};			# comment
	my $msg = $refer eq '' ? "\t$::resource{attach_plugin_msg_listall}" : "$refer\t$::resource{attach_plugin_msg_listpage}";
	my $body = $obj->toString(0, 1);
	undef $obj;
	return ('msg'=>$msg,'body'=>$body, 'ispage'=>$refer eq '' ? 0 : 1);
}

# ファイルアップロード												# comment
sub attach_upload
{
	my ($filename, $page, $pass) = @_;

	my %auth=&authadminpassword("input","","attach");
	if ($::file_uploads == 2 && $auth{authed} eq 0) {
		return ('msg'=>$::form{mypage}, 'body'=>$::resource{attach_plugin_err_password});
	}
	my ($parsename, $path, $ffile);
	$parsename = $filename;
	$parsename =~ s#\\#/#g;
	$parsename =~ s/^http:\/\///;
	$parsename =~ /([^:\/]*)(:([0-9]+))?(\/.*)?$/;
	$path = $4 || '/';
	$path =~ /(.*\/)(.*)/;			#$ffileには直下のファイル名	# comment
	$ffile = $2;			#ファイル名が無い場合'/'			# comment
	if($ffile eq '') {
		$ffile=$parsename;
		$ffile=~s/.*\///g;
	}
	$ffile =~ s/\x23.*$//;		# #はページ内リンクなので、削除する	# comment
	$ffile = &code_convert(\$ffile, $::defaultcode);

	my $obj = new AttachFile($page, $ffile);
	if ($obj->{exist}) {
		return ('msg'=>"$::form{mypage}\t$::resource{attach_plugin_err_exists}",'body'=>&attach_form);
	}
	#ファイルの保存												# comment
	unless (open (FILE, ">" . $obj->{filename})) {
		return('msg'=>$::form{mypage}, 'body'=>"$::resource{attach_plugin_err_upload}<br />$!:@{[$obj->{filename}]}");

		exit;
	}
	binmode(FILE);
	my $fsize = 0;
	my ($byte, $buffer);
	while ($byte = read($filename, $buffer, 1024)) {
		print FILE $buffer;
		$fsize += $byte;
		if ($fsize > $::max_filesize) {
			close FILE;
			unlink $obj->{filename};
			return ('msg'=>"\t$::resource{attach_plugin_err_exceed}",'body'=>&attach_form);
		}
	}
	close FILE;
	if(&attach_mime_content_type($ffile) eq '') {
		unlink $obj->{filename};
		return ('msg'=>"\t$::resource{attach_plugin_err_ignoretype}",'body'=>&attach_form);
	}
	my $flag=0;
	foreach(split(/\|/,&attach_mime_content_type($ffile,1))) {
		my $regex=lc $_;
		my $magic=lc &attach_magic($obj->{filename});
		$flag=1 if($magic=~/$regex/);
	}
	if($flag eq 0 && $::AttachFileCheck eq 1) {
		unlink $obj->{filename};
		return ('msg'=>"\t$::resource{attach_plugin_err_ignoremime}",'body'=>&attach_form);
	}
	# add v0.2.0													# comment
	&send_mail_to_admin($::form{mypage}, "AttachUpload", $ffile);
	return ('msg'=>"$::form{mypage}\t$::resource{attach_plugin_msg_uploaded}", 'body'=>&attach_form);

#	$obj->getstatus();												# comment
#	$obj->status['pass'] = ($pass !== TRUE and $pass !== NULL) ? $pass : '';	# comment
#	$obj->putstatus();												# comment

#	return array('result'=>TRUE,'msg'=>$_attach_messages['msg_uploaded'])	# comment
#	# パーミッションを変更		# comment
#	chmod (0666, "$Temp/$basename");								# comment
}

# ファイル名からmimeタイプ取得。									# comment
sub attach_mime_content_type
{
	my $filename = lc shift;
	my $check = shift;
	my $mime_type;
	foreach my $ext (keys %mime) {
		next unless ($ext && defined($mime{$ext}));
		my $tmp=lc $filename;
		my $tmp2=lc $ext;
		if ($tmp =~ /$tmp2$/i) {
			$mime_type = $mime{$ext};
			last;
		}
	}
	$mime_type=~s/\|.*//g if($check+0 eq 0);
	return ($mime_type) ? $mime_type : ''; #default
}


# php互換関数。														# comment
sub md5_file {
	my ($path) = @_;
	my $size=-s $path;
	open(FILE, $path);
	binmode(FILE);
	my $contents;
	read(FILE, $contents, $size + 1);
	close(FILE);
	return md5_hex($contents);
}

#----------------------------------------------------				# comment
# 1ファイル単位のコンテナ											# comment
package AttachFile;

sub plugin_attach_bytes {
	my $funcp = $::functions{"plugin_attach_bytes"};
	return &$funcp(@_);
}

sub dbmname {
	my $funcp = $::functions{"dbmname"};
	return &$funcp(@_);
}

sub md5_file {
	my $funcp = $::functions{"md5_file"};
	return &$funcp(@_);
}

sub htmlspecialchars {
	my $funcp = $::functions{"htmlspecialchars"};
	return &$funcp(@_);
}

sub attach_mime_content_type {
	my $funcp = $::functions{"attach_mime_content_type"};
	return &$funcp(@_);
}

sub attach_magic {
	my $funcp = $::functions{"attach_magic"};
	return &$funcp(@_);
}

sub encode {
	my $funcp = $::functions{"encode"};
	return &$funcp(@_);
}

sub http_header {
	my $funcp = $::functions{"http_header"};
	return &$funcp(@_);
}

sub authadminpassword {
	my $funcp = $::functions{"authadminpassword"};
	return &$funcp(@_);
}

sub attach_form {
	my $funcp = $::functions{"attach_form"};
	return &$funcp(@_);
}

sub code_convert {
	my $funcp = $::functions{"code_convert"};
	return &$funcp(@_);
}

sub plugin_counter_do {
	my $funcp = $::functions{"plugin_counter_do"};
	return &$funcp(@_);
}

sub date {
	my $funcp = $::functions{"date"};
	return &$funcp(@_);
}

sub new
{
	my $this = bless {};
	shift;
	$this->{page} = shift;	# page
	$this->{file} = shift;	# file
	$this->{age}  = shift;	# age;
	$this->{basename} = "$::upload_dir/"
		. &dbmname($this->{page}) . '_' . &dbmname($this->{file});
	$this->{filename} = $this->{basename} . ($this->{age} ? '.' . $this->{age} : '');
	$this->{exist} = (-e $this->{filename}) ? 1 : 0;
	$this->{logname}  = $this->{basename} . ".log";

	$this->{time} = (stat($this->{filename}))[10];
	$this->{md5hash} = ($this->{exist} == 1) ? &md5_file($this->{filename}) : '';
	return $this;
}

# 添付ファイルのオープン									# comment
sub open
{
	my $this = shift;
	my $query = new CGI;
	my $http_header;
	my $filename=$this->{file};

	# add 0.1.8
	if($::AttachCounter > 0) {
		my $pg=$this->{page};
		my $fn=$this->{file};
		&plugin_counter_do("attach\_$pg\_$fn","w");
	}

	# Windows MSIE & Opera & Chrome changed 0.2.0					# comment

	my $charset;
	if($filename=~/[\x81-\xfe]/) {
		if($ENV{HTTP_USER_AGENT} =~/Chrome/) {
			$filename=&code_convert(\$filename,"utf8",$::defaultcode);
			$filename=qq(filename="$filename");
#			$filename="filename*=ISO-2022-JP" . qq{''} . &encode($filename) . qq{"};	# comment
			$filename=~s/%2e/\./g;
			$charset="utf-8";
#		} elsif($ENV{HTTP_USER_AGENT}=~/Opera/) {						# comment
#			$filename=&code_convert(\$filename,"utf8",$::defaultcode);	# comment
#			$filename=qq(filename="$filename");							# comment
#			$charset="utf-8";											# comment
		} elsif($ENV{HTTP_USER_AGENT}=~/MSIE/) {
			$filename=qq{filename="} . &code_convert(\$filename,"sjis") . qq{"};
			$charset="Shift-JIS";
		} else {
#			$filename=&code_convert(\$filename,$::kanjicode);			# comment
			$filename=&code_convert(\$filename,"utf8");
			$filename=qq(filename="$filename");
#			$filename=qq{filename="} . $::charset . qq{''} . &encode($filename) . qq{"};	# comment
			$filename=~s/%2e/\./g;
			$charset="utf-8";
		}
	} else {
		$filename=&code_convert(\$filename,"utf8",$::defaultcode);
		$filename=qq(filename="$filename");
		$charset="utf-8";
	}

	$http_header=$query->header(
		-type=>"$this->{type}; charset=$charset",
		-Content_disposition=>"attachment; $filename",
		-Content_length=>$this->{size},
		-expires=>"now",
		-P3P=>""
	);

	print &http_header($http_header);

	open(FILE, $this->{filename}) || die $!;
	binmode(FILE);
	my $buffer;
	print $buffer while (read(FILE, $buffer, 4096));
	close(FILE);

	exit;
}

# 情報表示															# comment
sub info
{
	my $this = shift;

	my $msg_delete = '<input type="radio" name="pcmd" value="delete" />'
		 . $::resource{attach_plugin_msg_delete} . $::resource{attach_plugin_msg_require} . '<br />';

	my $info = $this->toString(1, 0);
	my %retval;

	# add 0.1.8
	my $counterstring;
	if($::AttachCounter > 0) {
		my $pg=$::form{refer};
		my $fn=$this->{file};
		my %attach_counter=&plugin_counter_do("attach\_$pg\_$fn","r");
		$counterstring=<<EOM;
 <dd>$::resource{attach_plugin_msg_dlcount}: $::resource{attach_plugin_msg_dlcount_total}: $attach_counter{total} $::resource{attach_plugin_msg_dlcount_today}: $attach_counter{today} $::resource{attach_plugin_msg_dlcount_yesterday}: $attach_counter{yesterday}</dd>
EOM
	}

	$retval{msg} = "\t$::resource{attach_plugin_msg_info}";
	$retval{body} =<<EOD;
<p class="small">
 [<a href="$::script?cmd=attach&amp;mypage=@{[&encode($::form{mypage} eq '' ? $::form{refer} : $::form{mypage})]}&amp;pcmd=list&amp;refer=@{[&encode("$::form{refer}")]}">$::resource{attach_plugin_msg_listpagelink}</a>]
 [<a href="$::script?cmd=attach&amp;pcmd=list">$::resource{attach_plugin_msg_listall}</a>]
</p>
<dl>
 <dt>$info</dt>
 <dd>$::resource{attach_plugin_msg_page}: $::form{refer}</dd>
 <dd>$::resource{attach_plugin_msg_filename}:$ this->{filename}</dd>
 <dd>$::resource{attach_plugin_msg_md5hash}: $this->{md5hash}</dd>
 <dd>$::resource{attach_plugin_msg_filesize}: $this->{size_str} ($this->{size} bytes)</dd>
 <dd>Content-type: $this->{type}</dd>
 <dd>Magic: $this->{magic}</dd>
 <dd>$::resource{attach_plugin_msg_date}: $this->{time_str}</dd>$counterstring
</dl>
EOD

	if ($::file_uploads) {
		my $msg_pass;

		if ($::file_uploads >= 2) {
			%auth=&authadminpassword("input",$::resource{attach_plugin_msg_password},"attach");
			$msg_pass='<br />' . $auth{html};
		}

		my $s_page = &htmlspecialchars($this->{page});

		$retval{body} .=<<EOD;
<hr />
<form action="$::script" method="post" id="attach_form" name="attach_form">
 <div>
  <input type="hidden" name="cmd" value="attach" />
  <input type="hidden" name="mypage" value="$this->{page}" />
  <input type="hidden" name="refer" value="$s_page" />
  <input type="hidden" name="file" value="$this->{file}" />
  <input type="hidden" name="age" value="$this->{age}" />
  $msg_delete
  $msg_pass
  @{[$auth{crypt} ?
    qq(<span id="attachbutton"></span><script type="text/javascript"><!--\n	gid("attachbutton").innerHTML='<input type="button" value="$::resource{'attach_plugin_btn_submit'}" onclick="fsubmit(\\'attach_form\\',\\'attach\\');" onkeypress="fsubmit(\\'attach_form\\',\\'attach\\',event);" />';\n//--></script>\n<noscript><input type="submit" value="$::resource{'attach_plugin_btn_submit'}" /></noscript>)
    :
   qq(<input type="submit" value="$::resource{'attach_plugin_btn_submit'}" />)
  ]}
 </div>
</form>
EOD
	}
	return %retval;
}

sub delete
{
	my $this = shift;

	# バックアップ												# comment
	if ($this->{age}) {
		unlink($this->{filename});
	} else {
		my $age;
		do {
			$age = ++$this->{age};
		} while (-e $this->{basename} . '.' . $age);

		if (!rename($this->{basename}, $this->{basename} . '.' . $age)) {
			# rename 失敗
			return ('msg'=>$this->{page}, 'body'=>$::resource{attach_plugin_err_delete});
		}
	}
	return ('msg'=>"$this->{page}\t$::resource{attach_plugin_msg_deleted}", 'body'=>&attach_form);
}

# ステータス取得												# comment
sub getstatus
{
	my $this = shift;

	return 0 if (!$this->{exist});

	# ログファイル取得											# comment
	#if (-e $this->{logname}) {									# comment
	#	$data = file($this->logname);							# comment
	#	foreach ($this->status as $key=>$value)					# comment
	#	{														# comment
	#		$this->status[$key] = chop(array_shift($data));		# comment
	#	}														# comment
	#	$this->status['count'] = explode(',',$this->status['count']);	# comment
	#}															# comment
#	$this->time_str = get_date('Y/m/d H:i:s',$this->time);		# comment

#	my ($sec, $min, $hour, $day, $mon, $year) = localtime($this->{time});
#	$this->{time_str} = sprintf("%d/%02d/%02d %02d:%02d:%02d",
#			$year + 1900, $mon + 1, $day, $hour, $min, $sec);
	$this->{time_str} = &date($::attach_format,$this->{time});
	$this->{size} = -s $this->{filename};
	$this->{size_str} = &plugin_attach_bytes($this->{size});
	$this->{type} = &attach_mime_content_type($this->{file});
	$this->{magic} = &attach_magic($this->{filename});
	return 1;
}

# ステータス保存 (nouse)										# comment
#sub putstatus													# comment
#{																# comment
#	$this->status['count'] = join(',',$this->status['count']);	# comment
#	$fp = fopen($this->logname,'wb')							# comment
#		or die_message('cannot write '.$this->logname);			# comment
#	flock($fp,LOCK_EX);											# comment
#	foreach ($this->status as $key=>$value)						# comment
#	{															# comment
#		fwrite($fp,$value."\n");								# comment
#	}															# comment
#	flock($fp,LOCK_UN);											# comment
#	fclose($fp);												# comment
#}																# comment

# ファイルのリンクを作成										# comment
sub toString {
	my $this = shift;
	my $showicon = shift;
	my $showinfo = shift;

	my $body;
	my $finfo = "&amp;file=" . &encode($this->{file})
		. "&amp;mypage=" . &encode($::form{mypage})
		. "&amp;refer="  . &encode($this->{page})
		. ($this->{age} >= 1 ? "&amp;age=$this->{age}" : "");

	$body .= $::file_icon if ($showicon);
	$body .= "<a href=\"$::script?cmd=attach&amp;pcmd=open$finfo\">$this->{file} "
		. ($this->{age} >= 1 ? "(Backup No.$this->{age})" : "") . "</a>";

	if ($showinfo) {
		$body .= " [<a href=\"$::script?cmd=attach&amp;pcmd=info"
		. "$finfo\">$::resource{attach_plugin_msg_description}</a>]";
	}
	return $body;
}

#----------------------------------------------------			# comment
# ファイル一覧コンテナ作成										# comment
package AttachFiles;
my %files;

sub plugin_attach_bytes {
	my $funcp = $::functions{"plugin_attach_bytes"};
	return &$funcp(@_);
}

sub make_link {
	my $funcp = $::functions{"make_link"};
	return &$funcp(@_);
}

sub new {
	my $this = bless {};
	shift;
	$this->{page} = shift;	# page
	return $this;
}

sub add {
	my $this = shift;
	my $file = shift;
	my $age  = shift;

	# 美しくないけど３次元配列									# comment
	$files{$this->{page}}{$file}{$age} = new AttachFile($this->{page}, $file, $age);
}

# ページ単位の一覧表示											# comment
sub toString {
	my $this = shift;
	my $flat = shift;
	my $page = $this->{page};

	my $ret = "";
	my $files = $this->{files};
	$ret .= "<li>" . &make_link($this->{page}) . "\n<ul>\n";
	my ($target, $notarget, $backup);
	foreach my $key (sort keys %{$files{$page}}) {
		$target = '';
		$notarget = '';
		$backup = '';
		foreach (sort keys %{$files{$page}{$key}}) {
			if ($_ >= 1) {
				$backup .= "<li>" . $files{$page}{$key}{$_}->toString(0, 1) . "</li>\n";
				$notarget = $files{$page}{$key}{$_}->{file};
			} else {
				$target .= $files{$page}{$key}{$_}->toString(0, 1);
			}
		}
		$ret .= "<li>" . ($target ? $target : $notarget);
		$ret .= "\n<ul>\n$backup\n</ul>\n" if ($backup);
		$ret .= "</li>\n";
	}
	return $ret . "</ul>\n</li>\n";
}

sub to_flat {
	my $this = shift;
	my $flat = shift;
	my $ret = "";
	my %files = $this->{files};
	foreach my $key (sort keys %files) {
		foreach (sort keys %{$files{$key}}) {
			$ret .= $key . "." . $_ . $files{$key}{$_}->toString(1, 1) . ' ';
		}
	}
	return $ret;
}

#-------------------------------------------------				# comment
# ページコンテナ作成											# comment
package AttachPages;

sub dbmname {
	my $funcp = $::functions{"dbmname"};
	return &$funcp(@_);
}

my %pages;

# ページコンテナ作成											# comment
sub new {
	my $this = bless {};
	shift;
	$this->{page} = shift;
	my $age = shift;

	opendir(DIR, "$::upload_dir/")
		or die('directory ' . $::upload_dir . ' is not exist or not readable.');
	my @file = readdir(DIR);
	closedir(DIR);

	my $page_pattern = ($this->{page} eq '')
		? '(?:[0-9A-F]{2})+' : &dbmname($::form{mypage});
	my $age_pattern = ($age eq '') ? '(?:\.([0-9]+))?' : ($age ? "\.($age)" : '');
	my $pattern = "^($page_pattern)_((?:[0-9A-F]{2})+)$age_pattern\$";

	my ($_page, $_file, $_age);

	foreach (@file) {
		next if (!/$pattern/);
		$_page = pack("H*", $1);
		$_file = pack("H*", $2);
		$_age = $3 ? $3 : 0;
		next if($_page=~/$::non_list/ && $::attach_nonlist eq 1
				&& $this->{page} eq '');

		$pages{$_page} = new AttachFiles($_page) if (!exists($pages{$_page}));
		$pages{$_page}->add($_file, $_age);
	}
	return $this;
}

# 全ページの添付一覧表示											# comment
sub toString {
	my $this = shift;
	my $page = shift;
	my $flat = shift;

	# page exist check;												# comment
	my $body = "";
	foreach (sort keys %pages) {
		$body .= $pages{$_}->toString($flat);
	}
	return "\n<div id=\"body\">" . $::resource{attach_plugin_err_noexist} . "</div>\n"
			if ($body eq "");
	return "\n<ul>\n$body</ul>\n";
}

1;
__END__

=head1 NAME

attach.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #attach

=head1 DESCRIPTION

File attach on the wiki page.

=head1 SETTING

=head2 pyukiwiki.ini.cgi

=over 4

=item $::file_uploads

0:Do not use / 1:Use / 2:Only auth of frozen password / 3:Only auth of frozen password of file delete

=item $::max_filesize

Upload max file size (bytes)

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/attach

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/attach/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/attach.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/attach.inc.pl?view=log>

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

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
