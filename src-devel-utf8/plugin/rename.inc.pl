######################################################################
# rename.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: rename.inc.pl,v 1.255 2012/01/31 10:12:04 papu Exp $
#
# "PyukiWiki" version 0.2.0-p1 $$
# Author: Junichi http://www.re-birth.com/
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
# オリジナルとの変更点
# ・表示文字列をリソースから読み込む
# ・全てのページ名が表示されるのが、セキュリティー的に問題あるため
#   最初に認証画面に移動する。
#   共通認証システムの使用に変更
# ・Locationヘッダの出力方法を変更
######################################################################

use constant PLUGIN_RENAME_LOGPAGE => ':RenameLog';

# %_rename_messages is deleted, moved to ./resource/rename.??.txt	# comment
# by nanami															# comment

sub plugin_rename_action {

	%::auth=&authadminpassword(submit);
	return('msg'=>"\t$::resource{rename_plugin_msg_title}",'body'=>$auth{html})
		if($auth{authed} eq 0);

	$method = &plugin_rename_getvar('method');
	if ($method eq 'regex') {
		my $src = &plugin_rename_getvar('src');
		if ($src eq '') {
			 return &plugin_rename_phase1();
		}

		$src_pattern = $src;
		$src_pattern=~s/\//\\\//g;
		my @arr0 = grep(/^$src_pattern/, sort keys %::database);

		if(@arr0 == 0){
			return &plugin_rename_phase1('nomatch');
		}

		my $dst = &plugin_rename_getvar('dst');

		my @arr1 = map {my $val = $_;$val=~s/$src_pattern/$dst/;$val} @arr0;

		foreach $page (@arr1) {
			if (! &is_pagename($page)) {
				return &plugin_rename_phase1('notvalid');
			}
		}

		return &plugin_rename_regex(\@arr0, \@arr1);
	} else {
		#  $method eq 'page'									# comment
		$page  = &plugin_rename_getvar('page');
		$refer = &plugin_rename_getvar('refer');

		if ($refer eq '') {
			return &plugin_rename_phase1();
		} elsif (! &is_exist_page($refer)) {
			return &plugin_rename_phase1('notpage', $refer);
		} elsif ($refer eq $whatsnew) {
			return &plugin_rename_phase1('norename', $refer);
		} elsif ($page eq '' || $page eq $refer) {
			return &plugin_rename_phase2();
		} elsif (not &is_pagename($page)) {
			return &plugin_rename_phase2('notvalid');
		} else {
			return &plugin_rename_refer();
		}
	}
}


#  変数を取得する												# comment
sub plugin_rename_getvar {
	my ($key) = @_;

	return $::form{$key};
	return isset($vars[$key]) ? $vars[$key] : '';
}

#  エラーメッセージを作る										# comment
sub plugin_rename_err {
	my ($err,$page) = @_;

	if ($err eq '') {
		return '';
	}

	$body = $::resource{'rename_plugin_err_' . $err};
	if (ref($page) eq 'ARRAY') {
		$page = join(", ", @$page);
	}
	if ($page ne ''){
		 $body = sprintf($body, &htmlspecialchars($page));
	}

	$msg = sprintf($::resource{'rename_plugin_err'}, $body);
	return $msg;
}

# 第一段階:ページ名または正規表現の入力							# comment
sub plugin_rename_phase1 {
	my ($err, $page) = @_;

	$msg    = &plugin_rename_err($err, $page);
	$refer  = &plugin_rename_getvar('refer');
	$method = &plugin_rename_getvar('method');

	$radio_regex = $radio_page = '';
	if ($method eq 'regex') {
		$radio_regex = ' checked="checked"';
	} else {
		$radio_page  = ' checked="checked"';
	}
	$select_refer = &plugin_rename_getselecttag($refer);

	$s_src = htmlspecialchars(&plugin_rename_getvar('src'));
	$s_dst = htmlspecialchars(&plugin_rename_getvar('dst'));

	%ret = ();
	$ret{'msg'}  = "\t$::resource{'rename_plugin_msg_title'}";
	$ret{'body'} = <<EOD;
$msg
<form action="$::script" method="post">
 <div>
  <input type="hidden" name="cmd" value="rename" />
  $auth{html}
  <input type="radio"  name="method" value="page"$radio_page />
  @{[$::resource{'rename_plugin_msg_page'}]}:$select_refer<br />
  <input type="radio" name="method" value="regex"$radio_regex />
  @{[$::resource{'rename_plugin_msg_regex'}]}:<br />
  From:<br />
  <input type="text" name="src" size="80" value="$s_src" /><br />
  To:<br />
  <input type="text" name="dst" size="80" value="$s_dst" /><br />
  <input type="submit" value="@{[$::resource{'rename_plugin_btn_next'}]}" /><br />
 </div>
</form>
EOD

	return %ret;
}

# 第二段階:新しい名前の入力									# comment
sub plugin_rename_phase2 {
	my $err = shift;

	$msg   = &plugin_rename_err($err);
	$page  = &plugin_rename_getvar('page');
	$refer = &plugin_rename_getvar('refer');

	if ($page eq '') {
		$page = $refer;
	}

	$msg_related = '';
	@related = &plugin_rename_getrelated($refer);
	if (@related > 0) {
		$msg_related = $::resource{'rename_plugin_msg_do_related'} .
			'<input type="checkbox" name="related" value="1" checked="checked" /><br />';
	}

	$msg_rename = sprintf($::resource{'rename_plugin_msg_rename'}, &make_pagelink($refer));
	$s_page  = &htmlspecialchars($page);
	$s_refer = &htmlspecialchars($refer);

	%ret = ();
	$ret{'msg'}  = "\t$::resource{'rename_plugin_msg_title'}";
	$ret{'body'} = <<EOD;
$msg
<form action="$::script" method="post">
 <div>
  <input type="hidden" name="cmd" value="rename" />
  $auth{html}
  <input type="hidden" name="refer"  value="$s_refer" />
  $msg_rename<br />
  @{[$::resource{'rename_plugin_msg_newname'}]}:<input type="text" name="page" size="80" value="$s_page" /><br />
  $msg_related
  <input type="submit" value="@{[$::resource{'rename_plugin_btn_next'}]}" /><br />
 </div>
</form>
EOD

	if (@related > 0) {
		$ret{'body'} .= '<hr /><p>' . $::resource{'rename_plugin_msg_related'} . '</p><ul>';
		foreach $name (sort @related) {
			$ret{'body'} .= '<li>' . &make_pagelink($name) . '</li>';
		}
		$ret{'body'} .= '</ul>';
	}

	return %ret;
}

# ページ名と関連するページを列挙し、phase3へ				# comment
sub plugin_rename_refer {
	$page  = &plugin_rename_getvar('page');
	$refer = &plugin_rename_getvar('refer');

	my %pages = ();
	$pages{&dbmname($refer)} = &dbmname($page);

	if (&plugin_rename_getvar('related') ne '') {
		$from = &strip_bracket($refer);
		$to   = &strip_bracket($page);

		foreach $_page (&plugin_rename_getrelated($refer)) {
			# $_pageの置換結果を$_page_toへ代入				# comment
			($_page_to = $_page)=~s/$from/$to/;
			$pages{&dbmname($_page)} = &dbmname($_page_to);
		}
	}
	# この時点で%pagesには、旧ページ名 => 新ページ名 というデータが入っている	# comment
	return &plugin_rename_phase3(%pages);
}

# 正規表現でページを置換									# comment
sub plugin_rename_regex {
	my ($arr_from, $arr_to) = @_;

	@exists = ();
	foreach my $page (@$arr_to) {
		if (&is_exist_page($page)) {
			push(@exists, $page);
		}
	}

	if (@exists > 0) {
		# 置換後のページ名がすでに存在する場合				# comment
		return &plugin_rename_phase1('already', \@exists);
	} else {
		%pages = ();
		foreach $refer (@$arr_from) {
			$pages{&dbmname($refer)} = &dbmname(shift(@$arr_to));
		}
		return &plugin_rename_phase3(%pages);
	}
}

sub plugin_rename_phase3 {
	my(%pages) = @_;

	my $msg = my $input = '';
	my %files = &plugin_rename_get_files(%pages);


	%exists = ();
	foreach $_page (keys %files) {
		my $arr = $files{$_page};
		foreach $old (keys %{$arr}) {
			$new = $arr->{$old};
			if (-e $new) {
				$exists{$_page}{$old} = $new;
			}
		}
	}

	$pass = &plugin_rename_getvar('mypassword');
#	v0.1.6 changed by nanami							# comment
#	if ($pass ne '' && &valid_password($pass)) {		# comment
	if (&plugin_rename_getvar('exec') eq 1) {
		return &plugin_rename_proceed(\%pages, \%files, \%exists);
#	} elsif ($pass ne '') {								# comment
#		$msg = &plugin_rename_err('adminpass');			# comment
	}

	$method = &plugin_rename_getvar('method');
	if ($method eq 'regex') {
		$s_src = &htmlspecialchars(&plugin_rename_getvar('src'));
		$s_dst = &htmlspecialchars(&plugin_rename_getvar('dst'));
		$msg   .= $::resource{'rename_plugin_msg_regex'} . '<br />';
		$input .= '<input type="hidden" name="method" value="regex" />';
		$input .= '<input type="hidden" name="src"    value="' . $s_src . '" />';
		$input .= '<input type="hidden" name="dst"    value="' . $s_dst . '" />';
	} else {
		$s_refer   = &htmlspecialchars(&plugin_rename_getvar('refer'));
		$s_page    = &htmlspecialchars(&plugin_rename_getvar('page'));
		$s_related = &htmlspecialchars(&plugin_rename_getvar('related'));
		$msg   .= $::resource{'rename_plugin_msg_page'} . '<br />';
		$input .= '<input type="hidden" name="method"  value="page" />';
		$input .= '<input type="hidden" name="refer"   value="' . $s_refer   . '" />';
		$input .= '<input type="hidden" name="page"    value="' . $s_page    . '" />';
		$input .= '<input type="hidden" name="related" value="' . $s_related . '" />';
	}

	if ((keys %exists) >0) {
		$msg .= $::resource{'rename_plugin_err_already_below'} . '<ul>';
		foreach $page (keys %exists) {
			my $arr = $exists{$page};

			$msg .= '<li>' . &make_pagelink(&dbmname_decode($page));
			$msg .= $::resource{'rename_plugin_msg_arrow'};
			$msg .= &htmlspecialchars(&dbmname_decode($pages{$page}));
			if ((keys %$arr) > 0) {
				$msg .= '<ul>' . "\n";
				foreach $ofile (keys %$arr) {
					$nfile = $arr->{$ofile};
					$msg .= '<li>' . $ofile .
					$::resource{'rename_plugin_msg_arrow'} . $nfile . '</li>' . "\n";
				}
				$msg .= '</ul>';
			}
			$msg .= '</li>' . "\n";
		}
		$msg .= '</ul><hr />' . "\n";

		$input .= '<input type="radio" name="exist" value="0" checked="checked" />' .
			$::resource{'rename_plugin_msg_exist_none'} . '<br />';
		$input .= '<input type="radio" name="exist" value="1" />' .
			$::resource{'rename_plugin_msg_exist_overwrite'} . '<br />';
	}

	%ret = ();
	$ret{'msg'} = "\t$::resource{'rename_plugin_msg_title'}";
	# v0.1.6 changed by nanami									# comment
	$ret{'body'} = <<EOD;
<p>$msg</p>
<table><tr><td>
@{[$::resource{'rename_plugin_msg_confirm'}]}
</td><td>
<form action="$::script" method="post">
 <div>
  $auth{html}
  <input type="hidden" name="cmd" value="rename" />
  <input type="hidden" name="exec" value="1" />
  $input
  <input type="submit" value="$::resource{'rename_plugin_btn_submit'}" />
 </div>
</form>
</td></tr>
</table>
EOD
#  @{[$::resource{'rename_plugin_msg_adminpass'}]}				# comment
#  <input type="password" name="mypassword" value="" />			# comment

	$ret{'body'} .= '<ul>' . "\n";
	foreach $old (reverse sort keys %pages) {
		$new = $pages{$old};
		$ret{'body'} .= '<li>' .  &make_pagelink(&dbmname_decode($old)) .
			$::resource{'rename_plugin_msg_arrow'} .
			&htmlspecialchars(&dbmname_decode($new)) .  '</li>' . "\n";
	}
	$ret{'body'} .= '</ul>' . "\n";
	return %ret;
}


# 処理対象のファイルの情報（元ファイルパス、新ファイルパス）の一覧を取得する	# comment
sub plugin_rename_get_files {
	my (%pages) = @_;

	my %files = ();
	@dirs  = ($::diff_dir, $::data_dir, $::counter_dir, $::info_dir);#compact
	@dirs  = ($::diff_dir, $::data_dir, $::counter_dir, $::info_dir, $::backup_dir);#nocompact
	if (&exist_plugin('attach')){
		push (@dirs, $::upload_dir);
	}
	if (&exist_plugin('rename')) {
		push (@dirs, $::rename_dir);
	}
	#  and more ...										# comment

	foreach $path (@dirs) {
		opendir(DH,$path);
		if (! DH){
			next;
		}

		# PyukiWikiのディレクトリ定義で最後が/でないため付加する。	# comment
		if($path=~/.*[^\/]$/) {
			$path .= '/';
		}

		while ($file = readdir(DH)) {
			if ($file eq '.' || $file eq '..'){
				next;
			}

			foreach $from (keys %pages) {

				$to = $pages{$from};

#				# カウンターの場合は、一度デコードして&encode()する。	# comment
#				if($path=~/$::rename_dir/) {						# comment
#					$from = &encode(&dbmname_decode($from));		# comment
#					$to = &encode(&dbmname_decode($to));			# comment
#				}													# comment

				# / を \/ へ置換									# comment
				$from=~s/\//\\\//g;

				# パターンの最後の ([._].+) はPyukiでは不要と思われる	# comment
				my $pattern = '^' . $from . '([._].+)$';
				if (not $file=~/$pattern/) {
					next;
				}

				$newfile = $to . $1;
				$files{$from}{$path . $file} = $path . $newfile;
			}
		}
	}

	return %files;
}

# 処理本体															# comment
sub plugin_rename_proceed {
	my ($pages, $files, $exists) = @_;

	# パラメータexistが1(上書き)でなければ存在するページを処理対象からはずす	# comment
	if (&plugin_rename_getvar('exist') ne '1') {

		foreach my $key (keys %$exists) {
			my $arr = $exists->{$key};
			delete $files->{$key};
		}
	}

#	set_time_limit(0);												# comment
	foreach $page(keys %$files) {
		$arr = $files->{$page};

		foreach $old (keys %$arr) {
			$new = $arr->{$old};

			# 存在していて、かつ、値が格納されている場合 $newを削除する	# comment
			if (exists($exists->{$page}{$old}) && defined($exists->{$page}{$old})){
				unlink($new);
			}
			rename($old, $new);
			#  linkデータベースを更新する BugTrack/327 arino		# comment
#			links_update($old);										# comment
#			links_update($new);										# comment
		}
	}

	# ログページのデータを取得して、追記							# comment
	$postdata = $::database{PLUGIN_RENAME_LOGPAGE};
	$postdata .= '*' . &date($::date_format . " " . $::time_format . " (D)") . "\n";
	if (&plugin_rename_getvar('method') eq 'regex') {
		$postdata .= '-' . $::resource{'rename_plugin_msg_regex'} . "\n";
		$postdata .= '--From:[[' . &plugin_rename_getvar('src') . ']]' . "\n";
		$postdata .= '--To:[['   . &plugin_rename_getvar('dst') . ']]' . "\n";
	} else {
		$postdata .= '-' . $::resource{'rename_plugin_msg_page'} . "\n";
		$postdata .= '--From:[[' . &plugin_rename_getvar('refer') . ']]' . "\n";
		$postdata .= '--To:[['   . &plugin_rename_getvar('page')  . ']]' . "\n";
	}

	if ((keys %$exists) > 0) {
		$postdata .= "\n" . $::resource{'rename_plugin_msg_result'} . "\n";
		foreach  $page (keys %$exists) {
			$arr = $exists->{$page};
			$postdata .= '-' . &dbmname_decode($page) .
				$::resource{'rename_plugin_msg_arrow'} . &dbmname_decode($pages->{$page}) . "\n";
			foreach $ofile (keys %$arr) {
				$nfile = $arr->{$ofile};
				$postdata .= '--' . $ofile .
					$::resource{'rename_plugin_msg_arrow'} . $nfile . "\n";
			}
		}
		$postdata .= '----' . "\n";
	}

	foreach $old (keys %$pages) {
		$new = $pages->{$old};
		$postdata .= '-' . &dbmname_decode($old) .
			$::resource{'rename_plugin_msg_arrow'} . &dbmname_decode($new) . "\n";
	}


	#  更新の衝突はチェックしない。								# comment

	#  ファイルの書き込み										# comment
	$::database{::PLUGIN_RENAME_LOGPAGE} = $postdata;
	&close_db();

	# リダイレクト												# comment
	$page = &plugin_rename_getvar('page');
	if ($page eq '') {
		$page = PLUGIN_RENAME_LOGPAGE;
	}

#	pkwk_headers_sent();										# comment
#	header('Location: ' . get_script_uri() . '?' . rawurlencode($page));	# comment
#	v0.1.6 changed by nanami									# comment
#	print "Location: $::script?@{[&encode($page)]}\n\n";		# comment
#	exit;														# comment
	print &http_header(
		"Status: 302",
		"Location: $::basehref?@{[&encode($page)]}"
		);
}

sub plugin_rename_getrelated {
	my ($page) = @_;

	@related = ();
	@pages = keys %::database;

	($striped_page = &strip_bracket($page))=~s/\//\\\//g;
	$pattern = '(?:^|\/)' . $striped_page . '(?:\/|$)';

	foreach  $name (@pages) {
		if ($name eq $page) {
			next;
		}
		if ($name=~/$pattern/) {
			push(@related, $name);
		}
	}

	return @related;
}


# 存在するページすべてのプルダウンを作成							# comment
sub plugin_rename_getselecttag {
	my ($page) = @_;

	my %pages = ();
	foreach $_page (sort keys %::database) {
#		if ($_page == $whatsnew) {									# comment
#			next;													# comment
#		}															# comment

		$selected = ($_page eq $page) ? ' selected' : '';
		$s_page = &htmlspecialchars($_page);
		$pages{$_page} = '<option value="' . $s_page . '"' . $selected . '>' .
			$s_page . '</option>';

	}

	my @pages = sort values %pages;

	$list = join("\n ", @pages);

	return <<EOD;
<select name="refer">
 <option value=""></option>
 $list
</select>
EOD

}

# ページ名のデコード　<==> dbmname									# comment
sub dbmname_decode {
	my $name = shift;
	return ($name =~/^[0-9a-f]+$/i) ? pack('H*', $name ) : $name ;
}

# [[ ]] を取り除く													# comment
# from PukiWiki lib/func.php										# comment
sub strip_bracket {
	my ($str) = @_;

	if ($str=~/^\[\[(.*)\]\]$/) {
		return $1;
	} else {
		return $str;
	}
}

# from PukiWiki lib/make_link.php									# comment
# 部分実装です。													# comment
sub make_pagelink {
	my $page = shift;
	return qq|<a href="$::script?@{[&encode($page)]}">$page</a>|;
}

# ページ名として正しいかどうかチェック								# comment
# from PukiWiki lib/func.php										# comment
sub is_pagename {
	my ($str) = @_;
	my $is_pagename= (not &is_interwiki($str) &&
						$str=~/^(?!\/)$bracket_name$(?<!\/$)/ &&
						$str=~/(^|\/)\.{1,2}(\/|$)/);
	# SOURCE_ENCODINGに該当する処理は省略							# comment
	return $is_pagename;
}

# from PukiWiki lib/func.php										# comment
sub is_interwiki {
	my ($str) = @_;

	# 判定には、暫定でPyukiWikiの$interwiki_name2を使用				# comment

	# from PukiWiki lib/init.php									# comment
	# my $InterWikiName = '(\[\[)?((?:(?!\s|:|\]\]).)+):(.+)(?(1)\]\])';	# comment

	# from PyukiWiki index.cgi										# comment
	# my $interwiki_name = '([^:]+):([^:].*)';						# comment
	# my $interwiki_name2 = '([^:]+):([^:#].*?)(#.*)?';				# comment

	return $str=~/^$interwiki_name$/;
}


1;
__END__

=head1 NAME

rename.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=rename[&refer=encoded_page_name]

=head1 DESCRIPTION

Changing a Wiki page name.

rename, difference (diff), and an attached file are also united and renamed.

Transplant from PukiWiki.

The portion which is not mounted by PyukiWiki is omitted.

=head1 BUGS

Updating is not applied to recent.

=head1 SEE ALSO

=over 4

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Admin/rename/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/rename.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/rename.inc.pl?view=log>

=item Site manufacture/PyukiWiki/Plugin/Rename

It is the correspondence version to 0.1.5.

L<http://www.re-birth.com/pyuki/wiki.cgi?%a5%b5%a5%a4%a5%c8%c0%a9%ba%ee%2fPyukiWiki%2f%a5%d7%a5%e9%a5%b0%a5%a4%a5%f3%2f%a5%ea%a5%cd%a1%bc%a5%e0>

=back

=head1 AUTHOR

=over 4

=item Junichi

L<http://www.re-birth.com/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sfjp.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2012 by Junichi.

Copyright (C) 2005-2012 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
