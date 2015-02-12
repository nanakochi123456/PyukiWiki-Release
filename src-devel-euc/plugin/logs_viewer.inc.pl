######################################################################
# logs_viewer.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: logs_viewer.inc.pl,v 1.108 2012/01/31 10:11:58 papu Exp $
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
# Return:LF Code=Shift-JIS 1TAB=4Spaces
######################################################################
# まだ評価版のアクセスログ解析ツールです。
#
# 2012/01/30 キャッシュ機能搭載
# 2012/01/02 リンク先カウンターの解析機能が搭載されていないのを修正
# 2012/01/02 グラフをCSSで出力するようにした
# 2011/12/31 ここまで完成。AWSTATSのおかげです http://awstats.sf.net/
# 2011/12/30 突然作り始める
# TODO
# 全機能をつくり、おかしな所をなおす。（もう少し）
# 生ログダウンロード機能の作成（サーバー上では圧縮して保管）
######################################################################

use strict;
use strict;
use Nana::Logs;

%::logbase;

$logs::daterange_month=31
	if(!defined($logs::daterange_month));

$logs::daterange_yeah=365
	if(!defined($logs::daterange_yeah));

sub plugin_logs_viewer_action {
	my $argv = shift;
	my ($limit, $ignore_page, $flag) = split(/,/, $argv);

	return qq(<div class="error">Not loader logs.ini.cgi</div>)
		if ($logs::directory eq '');

	my %auth=&authadminpassword(submit,"","admin");
	return('msg'=>"\t$::resource{logs_viewer_plugin_title}",'body'=>$auth{html})
		if($auth{authed} eq 0);

	my $body;

	if($::form{date} eq '') {
		$body=&plugin_logs_viewer_index(%auth);
	} else {
		if($::form{action} eq "delete") {
			return &plugin_logs_viewer_delete;
		} else {
			$body=&plugin_logs_viewer_page($::form{date},%auth);
		}
	}

	return('msg'=>"\t$::resource{logs_viewer_plugin_title}",'body'=>$body);
}

sub plugin_logs_viewer_delete {
	my %auth=&authadminpassword(submit);
	my $title=$::resource{logs_viewer_plugin_delete};
	$title=~s/\$1/$::form{mypage}/g;
	return('msg'=>"\t$title",'body'=>$auth{html})
		if($auth{authed} eq 0);
	if($::form{cancel} ne '') {
		print &http_header(
			"Status: 302",
			"Location: $::basehref?cmd=logs_viewer&amp;mypage=@{[&encode($::form{mypage})]}",
			$::HTTP_HEADER
			);
		close(STDOUT);
		&exec_explugin_last;
		exit;
	}
	if($::form{ok} eq '') {
		my $delete = $::resource{logs_viewer_plugin_delete};
		$delete=~s/\$1/$::form{mypage}/g;
		my $confirmmsg=$::resource{logs_viewer_plugin_delete_confirm};
		$confirmmsg=~s/\$1/$::form{mypage}/g;
		my $body=<<EOM;
<h3>$delete</h3>
<form action="$::script" method="POST">
$auth{html}
<input type="hidden" name="cmd" value="logs_viewer" />
<input type="hidden" name="action" value="delete" />
<input type="hidden" name="mypage" value="$::form{mypage}" />
$confirmmsg<br />
<input type="submit" name="ok" value="$::resource{logs_viewer_plugin_delete_confirm_ok}" />
<input type="submit" name="cancel" value="$::resource{logs_viewer_plugin_delete_confirm_cancel}" />
</form>
EOM
		return('msg'=>"\t$title",'body'=>$body);
	} else {
		my $page=$::form{mypage};
		my %counter=&plugin_counter_do($page,"r");
		my $hex=&dbmname($page);
		my $new=$hex;
		my $file = $::counter_dir . "/" . $new . $::counter_ext;
		Nana::File::lock_delete($file);
		my $body=<<EOM;
<strong>$::resource{logs_viewer_plugin_deleted}</strong>
<hr />
<form action="$::script" method="POST">
<input type="hidden" name="cmd" value="logs_viewer" />
<input type="submit" value="$::resource{logs_viewer_plugin_return}" />
</form>
EOM
		$body=~s/\$1/$::form{mypage}/g;
		return('msg'=>"\t$title",'body'=>$body);
	}
}

sub plugin_logs_viewer_page {
	my($date,%auth)=@_;

	&logopen;
	my @list=&Nana::Logs::list(\%::logbase);
	my $target;
	foreach my $hash(@list) {
		my $dt=$hash->{date};
		if($date eq $dt) {
			$target=$hash->{dates};
		}
	}
	if($target eq '') {
	} else {
		my %timestamp;
		foreach(/,/,$target) {
			$timestamp{$target}=$::logbase{"__update__" . $target};
$::debug.="timestamp{$target}=$timestamp{$target}\n";
		}
		my %hash=&Nana::Logs::analysis($target, \%::logbase, \%timestamp);
		my $body=<<EOM;
<h2>$date$::resource{logs_viewer_plugin_details_title}</h2>
<table><tr><td>
<form action="$::script" method="POST">
<input type="hidden" name="cmd" value="logs_viewer" />
$auth{html}
<input type="hidden" name="sort" value="$::form{sort}" />
<input type="submit" name="view" value="$::resource{logs_viewer_plugin_btn_back}" />
</form>
</td><td>
<form action="$::script" method="POST">
<input type="hidden" name="cmd" value="logs_viewer" />
$auth{html}
<input type="hidden" name="action" value="delete" />
<input type="hidden" name="mypage" value="$::form{mypage}" />
<input type="submit" name="view" value="$::resource{logs_viewer_plugin_btn_delete}" />
</form>
</td></tr></table>

<table class="style_table" cellspacing="1" border="0">
EOM

		if($::form{view} ne '') {
			$body.=&printtable($date, $::form{view}, $hash{$::form{view}}, 0);
			$body.="</table>\n";
			return $body;
		}
		$body.=<<EOM;
<thead><tr><td class="style_td" colspan="4" align="center"><strong>$::resource{logs_viewer_plugin_details_mon}&nbsp;$date</strong></td></tr></thead>
<tr><td class="style_td" colspan="3">$::resource{logs_viewer_plugin_details_total}</td><td class="style_td" align="right">$hash{count}</td></tr>
<tr><td class="style_td" colspan="3">$::resource{logs_viewer_plugin_details_pages}</td><td class="style_td" align="right">$hash{pagecount}</td></tr>
<tr><td class="style_td" colspan="3">$::resource{logs_viewer_plugin_details_writes}</td><td class="style_td" align="right">$hash{writecount}</td></tr>
<tr><td class="style_td" colspan="3">$::resource{logs_viewer_plugin_details_attachdownload}</td><td class="style_td" align="right">$hash{attachdownloads}</td></tr>
<tr><td class="style_td" colspan="3">$::resource{logs_viewer_plugin_details_attachupload}</td><td class="style_td" align="right">$hash{attachposts}</td></tr>
<tr><td class="style_td" colspan="3">$::resource{logs_viewer_plugin_details_referer}</td><td class="style_td" align="right">@{[&hashcount($hash{allreferers})]}</td></tr>
<tr><td class="style_td" colspan="3">$::resource{logs_viewer_plugin_details_useragent}</td><td class="style_td" align="right">@{[&hashcount($hash{agents})]}</td></tr>
<tr><td class="style_td" colspan="3">$::resource{logs_viewer_plugin_details_hosts}</td><td class="style_td" align="right">@{[&hashcount($hash{hosts})]}</td></tr>
EOM

		my ($target_year, $target_mon)=split(/-/,$date);
		my $total=0;
		my $maxdata=0;
		my $maxwidth=400;

		# 日ごとの統計
		for(my $i=1; $i<=&lastday($target_year+0, $target_mon+0); $i++) {
			my $target_date=sprintf("%04d-%02d-%02d"
				, $target_year, $target_mon, $i);
			$total=$total+$hash{dates}->{$target_date};
			$maxdata=$hash{dates}->{$target_date}
				if($maxdata < $hash{dates}->{$target_date});
		}
		$body.=<<EOM;
<thead><tr><td class="style_td" colspan="4" align="center"><strong>$::resource{logs_viewer_plugin_day}</strong></td></tr></thead>
EOM
		for(my $i=1; $i<=&lastday($target_year+0, $target_mon+0); $i++) {
			my $target_date=sprintf("%04d-%02d-%02d"
				, $target_year, $target_mon, $i);
			$body.=<<EOM;
<tr>
<td class="style_td" align="right">$i$::resource{logs_viewer_plugin_day_datestr}</td>
<td class="style_td" align="right">@{[$hash{dates}->{$target_date}+0]}</td>
<td class="style_td" colspan="2" width=$maxwidth">
@{[&printgraph($hash{dates}->{$target_date}, $maxdata, $total, $maxwidth)]}
</td>
</tr>
EOM
		}

		# 時間ごとの統計
		$total=0;
		$maxdata=0;
		for(my $i=0; $i<=23; $i++) {
			my $target_hour=sprintf("%02d", $i);
			$total=$total+$hash{hours}->{$target_hour};
			$maxdata=$hash{hours}->{$target_hour}
				if($maxdata < $hash{hours}->{$target_hour});
		}
		$body.=<<EOM;
<thead><tr><td class="style_td" colspan="4" align="center"><strong>$::resource{logs_viewer_plugin_hour}</strong></td></tr></thead>
EOM
		for(my $i=0; $i<=23; $i++) {
			my $target_hour=sprintf("%02d", $i);
			$body.=<<EOM;
<tr>
<td class="style_td" align="right">$target_hour:00</td>
<td class="style_td" align="right">@{[$hash{hours}->{$target_hour}+0]}</td>
<td class="style_td" colspan="2" width=$maxwidth">
@{[&printgraph($hash{hours}->{$target_hour}, $maxdata, $total, $maxwidth)]}
</td>
</tr>
EOM
		}

		my $maxprint=20;

		foreach("pages", "write", "links", "attachdownload", "attachpost"
			, "users"
#			, "countries"
			, "topdomains", "domains", "hosts"
			, "uaos", "browsertypes", "browserversions"
			, "referers", "searchengines", "keywords") {
			$body.=&printtable($date, $_, $hash{$_}, $maxprint);
		}

		$body.=<<EOM;
</table>
EOM
		return $body;
	}
}

sub printtable {
	my ($date, $res, $hash, $maxcount)=@_;
	my $count=&hashcount($hash);
	my $body.=<<EOM;
<thead><tr><td class="style_td" colspan="4" align="center"><strong>$::resource{"logs_viewer_plugin_$res"} @{[$count >= $maxcount ? "$count&nbsp;/&nbsp;" : ""]}@{[$count < $maxcount ? $count : $maxcount]}$::resource{"logs_viewer_plugin_$res\_str"}</strong></td></tr></thead>
EOM
	my $maxwidth=400;
	my %h=%{$hash};
	my $c=$maxcount eq 0 ? $count : $maxcount;
	my $total=0;
	foreach(keys %h) {
		$total=$total+$h{$_};
	}
	my $i=0;
	my $maxvalue;
	foreach(reverse sort {$h{$a} <=> $h{$b}} sort keys %h) {
		$maxvalue=$h{$_} if($h{$_} > $maxvalue);
		$body.=<<EOM;
<tr>
<td class="style_td" align="right"@{[$maxcount eq 0 ? ' rowspan="2"' : '']}>@{[++$i]}</td>
<td class="style_td" align="right"@{[$maxcount eq 0 ? ' rowspan="2"' : '']}>$h{$_}</td>
<td class="style_td" align="right"@{[$maxcount eq 0 ? ' rowspan="2"' : '']}>@{[$total > 0 ? sprintf("%.1f", $h{$_} / $total * 100) : "-"]}%</td>
<td class="style_td">$_</td>@{[$maxcount eq 0 ? '</tr><tr><td class="style_td" width="' . $maxwidth . '">' . &printgraph($h{$_}, $maxvalue, $total, $maxwidth) . '</td>' : '']}
</tr>
EOM
		last if($i >= $c && $maxcount ne 0);
	}
	if($count ne 0 && $maxcount ne 0) {
		$body.=<<EOM;
<tr><td class="style_td" colspan="4" align="center"><a href="$::script?cmd=logs_viewer&amp;date=$date&amp;view=$res">$::resource{"logs_viewer_plugin\_$res\_all"}</a></td></tr>
EOM
	}
	if($maxcount eq 0) {
		$body.=<<EOM;
<tr><td class="style_td" colspan="4" align="center"><a href="$::script?cmd=logs_viewer&amp;date=$date">$::resource{"logs_viewer_plugin_return"}</a></td></tr>
EOM
	}
	return $body;
}

sub plugin_logs_viewer_mkdate {
	my($dt)=@_;
	$dt=&date($logs_viewer::dateformat,$dt*86400);
	return $dt;
}

sub plugin_logs_viewer_index {
	my %auth=@_;
	my $body;

	&logopen;
	my @list=&Nana::Logs::list(\%::logbase);

	$body=<<EOM;
<h2>$::resource{logs_viewer_plugin_list}</h2>
<form action="$::script" method="POST">
<input type="hidden" name="cmd" value="logs_viewer" />
$auth{html}
<select name="sort">
EOM
	foreach my $sort("name","name_reverse","total","total_reverse"
		,"today","today_reverse","yesterday","yesterday_reverse") {
		my $sortmsg=$::resource{"logs_viewer_plugin_sort_" . (split(/_/,$sort))[0]};
		$sortmsg.="($::resource{logs_viewer_plugin_sort_reverse})"
			if($sort=~/reverse/);
		$body.=<<EOM;
<option value="$sort"@{[$::form{sort} eq $sort ? ' selected="selected"' : '']}>$sortmsg</option>
EOM
	}
	$body.=<<EOM;
</select>
<input type="submit" name="view" value="$::resource{logs_viewer_plugin_btn_view}" />
</form>
<table class="style_table" cellspacing="1" border="0">
<thead>
<tr>
<td class="style_td">&nbsp;</td>
<td class="style_td">$::resource{logs_viewer_plugin_index_month}</td>
<td class="style_td" colspan="2">$::resource{logs_viewer_plugin_index_count}</td>
</tr></thead>
EOM
	my $maxwidth=400;
	my $maxcount=0;
	my $total;
	foreach my $hash(@list) {
		my $count=$hash->{count};
		$maxcount=$count if($maxcount<$count);
		$total=$total+$count;
	}
	foreach my $hash(@list) {
		my $date=$hash->{date};
		my $count=$hash->{count};
		$body.=<<EOM;
<tr><td class="style_td">
<form action="$::script" method="POST">
<input type="hidden" name="cmd" value="logs_viewer" />
$auth{html}
<input type="hidden" name="sort" value="$::form{sort}" />
<input type="hidden" name="date" value="$date" />
<input type="submit" value="$::resource{logs_viewer_plugin_btn_details}" />
</form></td><td class="style_td">
<strong>&nbsp;$date</strong></td>
<td class="style_td" align="right">$::resource{logs_viewer_plugin_total}:$count</td>
<td class="style_td" width="$maxwidth">
@{[&printgraph($count, $maxcount, $total, $maxwidth)]}
</td>
</tr>
EOM


	}
	$body.=<<EOM;
</table>
EOM

	&logclose;
	return $body;
}

sub hashcount {
	my($hash)=shift;
	my %h=%{$hash};
	my $count=0;
	foreach(keys %h) {
		$count++;
	}
	return $count;
}

sub printgraph {
	my($count, $maxcount, $total, $maxwidth)=@_;
	$maxwidth=100;
	$maxcount=1 if($maxcount < 1);
	$total=1 if($total < 1);
	my $m=$maxcount;	# $m=$total;
	my $body=<<EOM;
<div class="rating"><div class="graphcont"><div class="graph"><strong class="bar" style="width:@{[sprintf("%d", ($count/$m)*100)]}%;">@{[sprintf("%.1f", ($count/$total)*100)]}%</strong></div></div>
EOM

	return $body;
}

sub logopen {
	if($logs::compress eq 1) {
		&dbopen_gz($logs::directory,\%::logbase);
	} else {
		&dbopen($logs::directory,\%::logbase);
	}
}

sub logclose {
	&dbclose(\%::logbase);
}

1;
__END__

=head1 NAME

logs_viewer.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=logs_viewer

=head1 DESCRIPTION

The detailed history of counters.

=back

=head1 SEE ALSO

=over 4

=over 4

=item PyukiWiki/Plugin/Admin/logs_viewer

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Admin/logs_viewer>

=item PyukiWiki/Plugin/ExPlugin/logs

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/logs/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/Nana/Logs.pml?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/lib/Nana/Logs.pml?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/logs_viewer.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/logs_viewer.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/Nana/Logs.pm?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/lib/Nana/Logs.pm?view=log>

This analysis plugin is diverted from AWStats, and the definition we use the improvement.

L<http://awstats.sf.net/>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/AWS/browsers.pm?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/lib/AWS/browsers.pm?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/AWS/domains.pm?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/lib/AWS/domains.pm?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/AWS/operating_systems.pm?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/lib/AWS/operating_systems.pm?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/AWS/robots.pm?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/lib/AWS/robots.pm?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/AWS/search_engines.pm?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/lib/AWS/search_engines.pm?view=log>

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
