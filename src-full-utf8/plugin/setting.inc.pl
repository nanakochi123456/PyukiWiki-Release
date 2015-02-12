######################################################################
# setting.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: setting.inc.pl,v 1.308 2012/03/01 10:39:26 papu Exp $
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
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################
# cookie設定用プラグイン
# 設定はリソースファイルにします。
# ExPlugin setting.inc.cgi、$::write_location=1を有効にする必要があります
######################################################################
sub plugin_setting_action {
	my $body;
	return if($::useExPlugin eq 1 && $::_exec_plugined{setting} ne 2);
	if($::form{submit} ne '') {
		my @http_headers=();
		push(@http_headers, "Status: 302");
		if($::form{refer} ne '') {
			push(@http_headers, "Location: $::basehref?@{[&encode($::form{refer})]}");
		} elsif($::form{mypage} ne '') {
			push(@http_headers, "Location: $::basehref?@{[&encode($::form{mypage})]}");
		} else {
			push(@http_headers, "Location: $::basehref?cmd=setting");
		}
		foreach(keys %::form) {
			if(/^_(.*)/) {
				my $setting=$1;
				my $opt=$::resource{"plugin_setting_" . $setting . "_list"};
				if($opt=~/^sub/) {
					$opt=~s/^sub//g;
					@optlist=eval $opt;
					$::debug.=$@;
				} else {
					foreach my $list(split(/,/,$opt)) {
						push(@optlist,$list);
					}
				}
				my $flg=0;
				foreach(@optlist) {
					my($v,$n)=split(/:/,$_);
					$flg=1 if($v eq $::form{"_" . $setting});
				}
				if($flg eq 0) {
					$body.="err:$setting<br />";
				} else {
					$::setting_cookie{$setting}=$::form{"_" . $setting};
				}
			}
		}
		&setcookie($::setting_cookie, 1, %::setting_cookie);
		print &http_header(
			@http_headers,
			$::HTTP_HEADER
			);
		close(STDOUT);
		exit;
	}
	$body.=<<EOM;
<h3>$::resource{plugin_setting_title}</h3>
<form action="$::script" method="POST">
<input type="hidden" name="cmd" value="setting" />
<input type="hidden" name="refer" value="$::form{refer}" />
<input type="hidden" name="mypage" value="$::form{mypage}" />
<table>
EOM
	foreach my $setting(split(/,/,$::resource{plugin_setting_list})) {
		my $opts;
		my @optlist=();
		my $check=$::resource{"plugin_setting_" . $setting . "_check"};
		if($check=~/^sub/) {
			$check=~s/^sub//g;
			$check=eval $check;
			$::debug.=$@;
		} elsif($check eq '') {
			$check=1;
		}
		if($check eq 1) {
			my $opt=$::resource{"plugin_setting_" . $setting . "_list"};
			if($opt=~/^sub/) {
				$opt=~s/^sub//g;
				@optlist=eval $opt;
				$::debug.=$@;
			} else {
				foreach my $list(split(/,/,$opt)) {
					push(@optlist,$list);
				}
			}
			my $default=$::resource{"plugin_setting_" . $setting . "_default"};
			if($default=~/^sub/) {
				$default=~s/^sub//g;
				$default=eval $default;
				$::debug.=$@;
			}
			foreach(@optlist) {
				my $checked;
				my $name;
				my $value;
				if(/:/) {
					($value,$name)=split(/:/,$_);
				} else {
					$name=$_;
					$value=$_;
				}
				if($::setting_cookie{$setting} ne '') {
					$checked=qq( checked="checked") if($value eq $::setting_cookie{$setting});
				} else {
					$checked=qq( checked="checked") if($value eq $default);
				}
				$opts.=<<EOM;
<input type="radio" name="_$setting" value="$value"$checked />$name
EOM
			}
			$body.=<<EOM;
<tr><td>$::resource{"plugin_setting_" . $setting}</td><td>$opts</td></tr>
EOM
		}
	}
	$body.=<<EOM;
<tr><td>&nbsp;</td><td><input type="submit" name="submit" value="$::resource{plugin_setting_button}" /></td></tr>
</table>
</form>
EOM
	return('msg'=>"\t$::resource{plugin_setting_title}", 'body'=>$body);
}
1;
__END__
