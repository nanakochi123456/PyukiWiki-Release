######################################################################
# recent.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: recent.inc.pl,v 1.506 2012/03/18 11:23:51 papu Exp $
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
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# v 0.1.9 #recent(count,ɽ�����ʤ��ڡ���������ɽ��) ���ɲ�
# v 0.1.6 Ⱦ�ѥ��ڡ����Υڡ������б���Time::Local�����
#         action�ˤ��б�
# v 0.0.3 : + �ڡ���̾�ϰ�����ɽ�����ʤ���
# v 0.0.2 �����ʥߥå��������� RecentChanges �����������
# v 0.0.1 Action�ˤ������ʥߥå�������ǽ�ɲ�
# v 0.0.0
######################################################################
my $useTimeLocal=1;
#my $useTimeLocal=0;
sub get_date {
	my ($time) = @_;
	my (@week) = qw(Sun Mon Tue Wed Thu Fri Sat);
	my ($sec, $min, $hour, $day, $mon, $year, $weekday) = localtime($time);
	$year += 1900;
	$mon++;
	$mon = "0$mon" if $mon < 10;
	$day = "0$day" if $day < 10;
	$hour = "0$hour" if $hour < 10;
	$min = "0$min" if $min < 10;
	$sec = "0$sec" if $sec < 10;
	$weekday = $week[$weekday];
	return "$year-$mon-$day ($weekday) $hour:$min:$sec";
}
sub plugin_recent_action {
	my $limit = shift;
	if ($limit eq '') { $limit = 10; }
	my $recentchanges = $::database{$::RecentChanges};
	my $count = 0;
	my $date = "";
	my $out = "";
	foreach (split(/\n/, $recentchanges)) {
		last if ($count >= $limit);
		/^\- (\d\d\d\d)\-(\d\d)\-(\d\d) \(...\) (\d\d):(\d\d):(\d\d) (.*?)\ \ \- (.*)/;
		next if ($7 eq '' || $7 =~ /\[*:/ || $7 =~ /$::non_list/ || !&is_readable($7));
		if($useTimeLocal eq 1) {
			$out.=qq(- @{[&date($::recent_format, Time::Local::timelocal($6,$5,$4,$3,$2-1,$1-1900))]} $7 - $8\n);
		} else {
			$out.=qq(- $1-$2-$3 $4:$5:$6 $7 - $8\n);
		}
	}
	return('msg'=>"\t$::resource{recentchanges}", 'body'=>&text_to_html($out));
}
sub plugin_recent_convert {
	my $argv = shift;
	my ($limit, $ignore) = split(/,/, $argv);
	if ($limit eq '') { $limit = 10; }
	my $recentchanges = $::database{$::RecentChanges};
	my $count = 0;
	my $date = "";
	my $out = "";
	foreach (split(/\n/, $recentchanges)) {
		last if ($count >= $limit);
		/^\- (\d\d\d\d\-\d\d\-\d\d) \(...\) \d\d:\d\d:\d\d (.*?)\ \ \-/;
		next if ($2 =~ /\[*:/ || $2 =~ /$::non_list/ || !&is_readable($2));
		if ($ignore ne '') {
			next if $2 =~ /($ignore)/;
		}
		if ($2) {
			if ($date ne $1) {
				if ($date ne '') { $out .= "</ul>\n"; }
				$date = $1;
				$out .= "<strong>$date</strong><ul class=\"recent_list\">\n";
			}
			$out .= "<li>" . &make_link($2) . "</li>\n";
			$count++;
		}
	}
	if ($date ne '') { $out .= "</ul>\n"; }
	return $out;
}
1;
__END__
