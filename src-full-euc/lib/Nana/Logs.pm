######################################################################
# Logs.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: Logs.pm,v 1.23 2011/12/31 13:06:10 papu Exp $
#
# "Nana::Logs" version 0.1 $$
# Author: Nanami
# http://nanakochi.daiba.cx/
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
package	Nana::Logs;
use 5.8.1;
#use strict;
use vars qw($VERSION);
$VERSION = '0.1';
$LOGS::Load=0;
use Nana::YukiWikiDB;
use Nana::YukiWikiDB_GZIP;
my @SearchEnginesSearchIDOrder;
my @RobotsSearchIDOrder;
sub list {
	my ($logbase)=@_;
	my @list;
	my (%db)=%{$logbase};
	my $nowmonth=&date("Y\-m");
	my %oldmonth;
	my %olddates;
	&init;
	foreach my $date (reverse sort keys %db) {
		my $mon=substr($date,0,7);
		foreach(split(/\n/,$db{$date})) {
			$oldmonth{$mon}++;
		}
		$olddates{$mon}.="$date,";
	}
	$olddates{$mon}=~s/,$//;
	foreach my $mon(reverse sort keys %oldmonth) {
		push @list, {
			date	=> $mon,
			count	=> $oldmonth{$mon},
			dates	=> 	$olddates{$mon},
		};
	}
	return @list;
}
sub analysis {
	my($lists,$logbase)=@_;
	my (%db)=%{$logbase};
	&init;
	my %dates;
	my %hours;
	my %weeks;
	my %host;
	my %hosts;
	my %tmpcountries;
#	my %countries;
	my %topdomains;
	my %domains;
	my %tmptopdomains;
	my %tmpdomains;
	my %agents;
	my %uabrowser;
	my %uabrowserver;
	my %browsertype;
	my %browserversion;
	my %uaos;
	my %os;
	my %page;
	my $pages=0;
	my %write;
	my $writes=0;
	my %attachdownload;
	my $attachdownloads=0;
	my %attachpost;
	my $attachposts=0;
	my %user;
	my $users=0;
	my %referer;
	my %allreferer;
	my %searchengine;
	my %keywords;
	my $counts=0;
	foreach my $list(split(/,/,$lists)) {
		foreach my $log(split(/\n/,$db{$list})) {
			$counts++;
			my($hosts,$dates,$user,$method,$cmd,$lang,$page,$agent,$refer)
				= split(/\t/,$log);
			my($host,$ip)=split(/ /,$hosts);
			my($date,$week,$time)=split(/ /,$dates);
			my($date_y, $date_m, $date_d)=split(/-/,$date);
			my($time_h, $time_m, $time_s)=split(/:/,$time);
			$dates{$date}++;
			$hours{$time_h}++;
			$weeks{$week}++;
			if($cmd eq "read") {
				$page{"$lang\t$page"}++;
				$pages++;
			}
			if(($cmd eq "write" || $cmd=~/edit/ || $cmd=~/comment/
				|| $cmd=~/article/ || $cmd eq "bugtrack" || $cmd eq "vote")
				&& $method eq "POST") {
				$write{"$lang\t$page"}++;
				$writes++;
			}
			if($cmd eq "attach-open") {
				$attachdownload{"$lang\t$page"}++;
				$attachdownloads++;
			}
			if(($cmd eq "attach-post" || $cmd eq "attach-delete")
			 && $method eq "POST") {
				$attachpost{"$lang\t$page"}++;
				$attachposts++;
			}
			if($cmd eq "attach-post" || $cmd eq "attach-delete") {
				$attachpost{"$lang\t$page"}++;
				$attachposts++;
			}
			$user{$user}++;
			$hosts{"$hosts ($ip)"}++;
			my $domain;
#			my $tmpcountries=lc $host;
			my $tmpdomain=lc $host;
#			if($tmpcountries{$ip} eq '') {
#				foreach(keys %DomainsHashIDLib) {
#					my $top=$_;
#					my $regex=$_;
#					next if($regex=/\./);
#					if($tmpcountries=~/\.$regex$/) {
#						$tmpcountries{$ip}="$top ($DomainsHashIDLib{$top})";
#						my $country=$tmpcountries;
#						$country=~s/\.$regex$//g;
#						$domain=~s/.*\.//g;
#						last;
#					}
#				}
#			}
			if($tmptopdomains{$ip} eq '') {
				foreach(keys %DomainsHashIDLib) {
					my $top=$_;
					my $regex=$_;
					$regex=~s/\./\\\./g;
					if($tmpdomain=~/\.$regex$/) {
						$tmptopdomains{$ip}="$top ($DomainsHashIDLib{$top})";
						my $domain=$tmpdomain;
						$domain=~s/\.$regex$//g;
						$domain=~s/.*\.//g;
						$tmpdomains{$ip}="$domain.$top";
						last;
					}
				}
				if($tmptopdomains{$ip} eq '') {
					my $regipv4='^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'
							+ '|(::ffff:\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})';
					my $regipv4='^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
					my $regipv6='((([0-9a-f]{1,4}:){7}([0-9a-f]{1,4}|:))|(([0-9a-f]{1,4}:){6}(:[0-9a-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9a-f]{1,4}:){5}(((:[0-9a-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9a-f]{1,4}:){4}(((:[0-9a-f]{1,4}){1,3})|((:[0-9a-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){3}(((:[0-9a-f]{1,4}){1,4})|((:[0-9a-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){2}(((:[0-9a-f]{1,4}){1,5})|((:[0-9a-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){1}(((:[0-9a-f]{1,4}){1,6})|((:[0-9a-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9a-f]{1,4}){1,7})|((:[0-9a-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?';
					if($ip=~/$regipv4/) {
						$tmptopdomains{$ip}="IPV4 Address";
					} elsif($ip=~/$regipv6/) {
						$tmptopdomains{$ip}="IPV6 Address";
					} else {
						$tmptopdomains{$ip}=$host ? $host : $ip;
					}
					$tmpdomains{$ip}=$host ? $host : $ip;
				}
			}
			$topdomains{$tmptopdomains{$ip}}++;
			$domains{$tmpdomains{$ip}}++;
			$agents{$agent}++;
			my $browser=lc $agent;
			if(! $uaos{$browser}) {
				foreach my $regex(@OSSearchIDOrder) {
					if($browser=~/$regex/) {
						$uaos{$browser}=&target($OSHashLib{$OSHashID{$regex}});
						last;
					}
				}
			}
			if(! $uaos{$browser}) {
				$uaos{$browser}='Unknown';
			}
			$os{$uaos{$browser}}++;
			if(! $uabrowser{$browser}) {
				my $found = 0;
				if(!$found) {
					foreach(@RobotsSearchIDOrder) {
						if($browser =~ /$_/) {
							$uabrowser{$browser}='Robot';
							$uabrowserver{$browser}=&target($RobotsHashIDLib{$_});
							$found=1;
							last;
						}
					}
				}
				if(!$found) {
					foreach my $id(@BrowsersFamily) {
						if($browser=~/$BrowsersVersionHashIDLib{$id}/) {
							my $version=$2 eq '' ? $1 : $2;
							if($id eq "safari") {
								$version=
									$BrowsersSafariBuildToVersionHash{$version}
										 . " ($version)";
							}
							$found=1;
							$uabrowser{$browser}=$BrowsersHashIDLib{$id};
							$uabrowserver{$browser}="$BrowsersHashIDLib{$id}/$version";
							last;
						}
					}
				}
				if(!$found) {
					foreach (@BrowsersSearchIDOrder) {
						if($browser =~ /$_/ ) {
							my $browserver = $browser;
							$browserver=~s/.*$_[_+\/ ]([\d\.]*).*/$1/;
							$uabrowser{$browser}=$BrowsersHashIDLib{$_};
							$uabrowserver{$browser}="$_/$browserver";
							$found=1;
							last;
						}
					}
				}
				if(!$found) {
					$uabrowser{$browser}='Unknown';
					$uabrowserver{$browser}='Unknown';
				}
			}
			$browsertype{$uabrowser{$browser}}++;
			$browserversion{$uabrowserver{$browser}}++;
			$refer=~s/&amp;/&/g;
			$found=0;
			foreach(@SearchEnginesSearchIDOrder) {
				if($refer=~/$_/) {
					$searchengine{$SearchEnginesHashLib{$SearchEnginesHashID{$_}}}++;
					my $query=$SearchEnginesKnownUrl{$SearchEnginesHashID{$_}};
					my $q=$refer;
					$q=~s/\?/&/g;
					foreach $u(split(/&/,$q)) {
						if($u=~/^$query/) {
							my $tmp=&decode($u);
							$tmp=~s/^$query//g;
							my $word=&code_convert(\$tmp,$::defaultcode);
							$keywords{"$page - $word"}++;
						}
					}
				}
			}
			if(!$found) {
				$referer{$refer}++;
			}
			$allreferer{$refer}++;
		}
	}
	return(
		count			=> $counts,
		pagecount		=> $pages,
		writecount		=> $writes,
		attachdownloads	=> $attachdownloads,
		attachposts		=> $attachposts,
		dates			=> \%dates,
		hours			=> \%hours,
		weeks			=> \%weeks,
		hosts			=> \%hosts,
#		countries		=> \%countries,
		topdomains		=> \%topdomains,
		domains			=> \%domains,
		uaos			=> \%os,
		browsertypes	=> \%browsertype,
		browserversions	=> \%browserversion,
		pages			=> \%page,
		links			=> \%links,
		write			=> \%write,
		attachdownload	=> \%attachdownload,
		attachpost		=> \%attachpost,
		users			=> \%user,
		referers		=> \%referer,
		agents			=> \%agents,
		allreferers		=> \%allreferer,
		searchengines	=> \%searchengine,
		keywords		=> \%keywords,
	);
}
sub target {
	my ($html)=shift;
	if($::htmlmode=~/xhtml/) {
		if($html=~/target="_blank"/) {
			$html=~s/<a href="($::isurl)" (.*)target="_blank">/<a href="$1" $2 onclick="return openURI('$1','$target');">/g;
		}
	}
	return $html;
}
sub UnCompileRegex {
	shift =~ /\(\?[-\w]*:(.*)\)/;
	return $1;
}
sub init {
	if($LOGS::Load eq 0) {
		require "$::explugin_dir/AWS/browsers.pm";
		require "$::explugin_dir/AWS/domains.pm";
		require "$::explugin_dir/AWS/operating_systems.pm";
		require "$::explugin_dir/AWS/robots.pm";
		require "$::explugin_dir/AWS/search_engines.pm";
		$LOGS::Load=1;
		push(@SearchEnginesSearchIDOrder, @SearchEnginesSearchIDOrder_list1);
		push(@SearchEnginesSearchIDOrder, @SearchEnginesSearchIDOrder_list2);
		push(@RobotsSearchIDOrder, @RobotsSearchIDOrder_list1);
		push(@RobotsSearchIDOrder, @RobotsSearchIDOrder_list2);
		push(@RobotsSearchIDOrder, @RobotsSearchIDOrder_listgen);
	}
}
sub date {
	my $funcp = $::functions{"date"};
	return &$funcp(@_);
}
sub code_convert {
	my $funcp = $::functions{"code_convert"};
	return &$funcp(@_);
}
sub decode {
	my $funcp = $::functions{"decode"};
	return &$funcp(@_);
}
1;
__END__
