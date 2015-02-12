######################################################################
# counter_viewer.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: counter_viewer.inc.pl,v 1.255 2012/01/31 10:12:03 papu Exp $
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

use strict;
use Nana::File;

$counter_viewer::dateformat="Y-m-d(lL)"
	if(!defined($counter_viewer::dateformat));

sub plugin_counter_viewer_action {
	my $argv = shift;
	my ($limit, $ignore_page, $flag) = split(/,/, $argv);

	return qq(<div class="error">counter.inc.pl can't require</div>)
		if (&exist_plugin("counter") ne 1);

	my %auth=&authadminpassword(submit,"","admin");
	return('msg'=>"\t$::resource{counter_viewer_plugin_title}",'body'=>$auth{html})
		if($auth{authed} eq 0);

	my $body;

	if($::form{mypage} eq '') {
		$body=&plugin_counter_viewer_index(%auth);
	} else {
		if($::form{action} eq "delete") {
			return &plugin_counter_viewer_delete;
		} else {
			$body=&plugin_counter_viewer_page($::form{mypage},%auth);
		}
	}

	return('msg'=>"\t$::resource{counter_viewer_plugin_title}",'body'=>$body);
}

sub plugin_counter_viewer_delete {
	my %auth=&authadminpassword(submit);
	my $title=$::resource{counter_viewer_plugin_delete};
	$title=~s/\$1/$::form{mypage}/g;
	return('msg'=>"\t$title",'body'=>$auth{html})
		if($auth{authed} eq 0);
	if($::form{cancel} ne '') {
		print &http_header(
			"Status: 302",
			"Location: $::basehref?cmd=counter_viewer&amp;mypage=@{[&encode($::form{mypage})]}",
			$::HTTP_HEADER
			);
		close(STDOUT);
		&exec_explugin_last;
		exit;
	}
	if($::form{ok} eq '') {
		my $delete = $::resource{counter_viewer_plugin_delete};
		$delete=~s/\$1/$::form{mypage}/g;
		my $confirmmsg=$::resource{counter_viewer_plugin_delete_confirm};
		$confirmmsg=~s/\$1/$::form{mypage}/g;
		my $body=<<EOM;
<h3>$delete</h3>
<form action="$::script" method="POST">
$auth{html}
<input type="hidden" name="cmd" value="counter_viewer" />
<input type="hidden" name="action" value="delete" />
<input type="hidden" name="mypage" value="$::form{mypage}" />
$confirmmsg<br />
<input type="submit" name="ok" value="$::resource{counter_viewer_plugin_delete_confirm_ok}" />
<input type="submit" name="cancel" value="$::resource{counter_viewer_plugin_delete_confirm_cancel}" />
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
<strong>$::resource{counter_viewer_plugin_deleted}</strong>
<hr />
<form action="$::script" method="POST">
<input type="hidden" name="cmd" value="counter_viewer" />
<input type="submit" value="$::resource{counter_viewer_plugin_return}" />
</form>
EOM
		$body=~s/\$1/$::form{mypage}/g;
		return('msg'=>"\t$title",'body'=>$body);
	}
}

sub plugin_counter_viewer_page {
	my($page,%auth)=@_;
	my %counter=&plugin_counter_do($page,"r");
	my $body=<<EOM;
<h2>@{[&htmlspecialchars($page)]}$::resource{counter_viewer_plugin_details_title}</h2>
<table><tr><td>
<form action="$::script" method="POST">
<input type="hidden" name="cmd" value="counter_viewer" />
$auth{html}
<input type="hidden" name="sort" value="$::form{sort}" />
<input type="submit" name="view" value="$::resource{counter_viewer_plugin_btn_back}" />
</form>
</td><td>
<form action="$::script" method="POST">
<input type="hidden" name="cmd" value="counter_viewer" />
$auth{html}
<input type="hidden" name="action" value="delete" />
<input type="hidden" name="mypage" value="$::form{mypage}" />
<input type="submit" name="view" value="$::resource{counter_viewer_plugin_btn_delete}" />
</form>
</td></tr></table>
<table class="style_table" cellspacing="1" border="0">
<thead><tr>
<td class="style_td">$::resource{counter_viewer_plugin_date}</td>
<td class="style_td">$::resource{counter_viewer_plugin_count}</td>
</tr></thead>
<tr>
<td class="style_td">$::resource{counter_viewer_plugin_total}</td>
<td class="style_td">$counter{total}</td>
</tr><tr>
<td class="style_td">$::resource{counter_viewer_plugin_lastdate}</td>
<td class="style_td">@{[&plugin_counter_viewer_mkdate($counter{date})]}</td>
</tr><tr>
<td class="style_td">$::resource{counter_viewer_plugin_lastip}</td>
<td class="style_td">$counter{ip}</td>
</tr>
EOM
	for(my $i=$counter{date};
		$i>=$counter{date}-($::CounterDates >=1000 ? 1000 : $::CounterDates);
		$i--) {
		$body.=<<EOM;
<tr>
<td class="style_td">@{[&plugin_counter_viewer_mkdate($i)]}</td>
<td class="style_td">@{[$counter{$i}+0]}</td>
</tr>
EOM
	}
	$body.=<<EOM;
</table>
EOM
	return $body;
}

sub plugin_counter_viewer_mkdate {
	my($dt)=@_;
	$dt=&date($counter_viewer::dateformat,$dt*86400);
	return $dt;
}

sub plugin_counter_viewer_index {
	my %auth=@_;
	my @list=();
	my $body;
#	foreach my $pages (keys %::database) {						# comment
#		my %counter=&plugin_counter_do($pages,"r");				# comment
#		push(@list,"$pages\t$counter{total}\t$counter{today}\t$counter{yesterday}\t$counter{version}");		# comment
#	}															# comment

#	# changes other counters									# comment
#	opendir(DIR,$::counter_dir);								# comment
#	my $file;													# comment
#	while($file=readdir(DIR)) {									# comment
#		next if($file!~/\.count$/);								# comment
#		$file=~s/\.count$//g;									# comment
#		my $page=&decode($file);								# comment
#		my %counter=&plugin_counter_do($page,"r");				# comment
#		push(@list,"$page\t$counter{total}\t$counter{today}\t$counter{yesterday}\t$counter{version}");											# comment
#	}															# comment

	# changes pukiwiki compatible								# comment
	opendir(DIR,$::counter_dir);
	my $file;
	my @files;
	while($file=readdir(DIR)) {
		next if($file!~/\.count$/);
		$file=~s/\.count$//g;
		push(@files,$file);
	}
	closedir(DIR);
	my $flg=0;
	foreach (@files) {
		my $page;
		my $file=$_;
		s/0//g;
		s/1//g;
		s/2//g;
		s/3//g;
		s/4//g;
		s/5//g;
		s/6//g;
		s/7//g;
		s/8//g;
		s/9//g;
		s/0//g;
		s/A//g;
		s/B//g;
		s/C//g;
		s/D//g;
		s/E//g;
		s/F//g;
		if($_ ne '') {
			$page=&decode($file);
		} else {
			$page=&undbmname($file);
		}
		my %counter=&plugin_counter_do($page,"r");
		push(@list,"$page\t$counter{total}\t$counter{today}\t$counter{yesterday}\t$counter{version}");
	}

	@list=sort { (split(/\t/,$a))[0] cmp (split(/\t/,$b))[0] } @list;
	if($::form{sort}=~/total/) {
		@list=sort { (split(/\t/,$b))[1] <=> (split(/\t/,$a))[1] } @list;
	} elsif($::form{sort}=~/today/) {
		@list=sort { (split(/\t/,$b))[2] <=> (split(/\t/,$a))[2] } @list;
	} elsif($::form{sort}=~/yesterday/) {
		@list=sort { (split(/\t/,$b))[3] <=> (split(/\t/,$a))[3] } @list;
	}
	@list=reverse @list if($::form{sort}=~/reverse/);

	$body=<<EOM;
<h2>$::resource{counter_viewer_plugin_list}</h2>
<form action="$::script" method="POST">
<input type="hidden" name="cmd" value="counter_viewer" />
$auth{html}
<select name="sort">
EOM
	foreach my $sort("name","name_reverse","total","total_reverse"
		,"today","today_reverse","yesterday","yesterday_reverse") {
		my $sortmsg=$::resource{"counter_viewer_plugin_sort_" . (split(/_/,$sort))[0]};
		$sortmsg.="($::resource{counter_viewer_plugin_sort_reverse})"
			if($sort=~/reverse/);
		$body.=<<EOM;
<option value="$sort"@{[$::form{sort} eq $sort ? ' selected="selected"' : '']}>$sortmsg</option>
EOM
	}
	$body.=<<EOM;
</select>
<input type="submit" name="view" value="$::resource{counter_viewer_plugin_btn_view}" />
</form>
<table class="style_table" cellspacing="1" border="0">
EOM
	foreach(@list) {
		my($name,$total,$today,$yesterday,$version)=split(/\t/,$_);
		my $btn=<<EOM;
<input type="hidden" name="cmd" value="counter_viewer" />
$auth{html}
<input type="hidden" name="sort" value="$::form{sort}" />
<input type="hidden" name="mypage" value="@{[&htmlspecialchars($name)]}" />
<input type="submit" value="$::resource{counter_viewer_plugin_btn_details}"@{[$version > 1 ? '' : ' disabled="disabled"']} />
&nbsp;
EOM
		$body.=<<EOM;
<form action="$::script" method="POST">
<thead><tr><td class="style_td" colspan="4"><strong>$btn
@{[$::database{$name} ne '' ? "<a target=\"_blank\" href=\"$::script?@{[&encode($name)]}\">@{[&htmlspecialchars($name)]}</a>" : @{[&htmlspecialchars($name)]}]}</strong></td></tr></thead>
<tr>
<td class="style_td" align="right">$::resource{counter_viewer_plugin_total}:$total</td>
<td class="style_td" align="right">$::resource{counter_viewer_plugin_today}:$today</td>
<td class="style_td" align="right">$::resource{counter_viewer_plugin_yesterday}:$yesterday</td>
<td class="style_td" align="right">$::resource{counter_viewer_plugin_version}:$version</td>
</tr></form>
EOM
	}
	$body.=<<EOM;
</table>
EOM

	return $body;
}

1;
__END__

=head1 NAME

counter_viewer.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=counter_viewer

=head1 DESCRIPTION

The detailed history of counters.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/counter_viewer

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Admin/counter_viewer/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/counter_viewer.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/counter_viewer.inc.pl?view=log>


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
