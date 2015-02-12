######################################################################
# Logs.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: Logs.pm,v 1.109 2012/01/31 10:11:57 papu Exp $
#
# "Nana::Logs" version 0.2 $$
# Author: Nanami
# http://nanakochi.daiba.cx/
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
package	Nana::Logs;
use 5.8.1;
#use strict;
use vars qw($VERSION);
$VERSION = '0.2';
$LOGS::Load=0;
#use Nana::YukiWikiDB;
#use Nana::YukiWikiDB_GZIP;
use Nana::Cache;
use Nana::GZIP;
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
	foreach my $date (reverse sort keys %db) {
		my $c=0;
		foreach(split(/\n/,$db{$date})) {
			$c++;
		}
		push @list, {
			date	=> $date,
			count	=> $c,
			dates	=> $date,
		};
	}
	return @list;
}
sub analysis {
	my($lists,$logbase, $timestamp)=@_;
	my (%db)=%{$logbase};
	my (%t)=%{$timestamp};
	&init;
	my %dates=();
	my %hours=();
	my %weeks=();
	my %host=();
	my %hosts=();
	my %tmpcountries=();
#	my %countries=();
	my %topdomains=();
	my %domains=();
	my %tmptopdomains=();
	my %tmpdomains=();
	my %agents=();
	my %uabrowser=();
	my %uabrowserver=();
	my %browsertypes=();
	my %browserversions=();
	my %uaos=();
	my %os=();
	my %page=();
	my $pages=0;
	my %write=();
	my $writes=0;
	my %attachdownload=();
	my $attachdownloads=0;
	my %attachpost=();
	my $attachposts=0;
	my %users=();
	my %links=();
	my %referers=();
	my %allreferers=();
	my %searchengine=();
	my %keywords=();
	my $counts=0;
	my %hash;
	foreach my $list(split(/,/,$lists)) {
		%hash=&analysis_sub($db{$list}, $list, $t{$list});
		$counts+=$hash{count};
		$pages+=$hash{pagecount};
		$writes+=$hash{writes};
		$attachdownloads+=$hash{attachdownloads};
		$attachuploads+=$hash{attachuploads};
		foreach(keys %{$hash{"dates"}} ) { $dates{$_}=$hash{"dates"}->{$_}; }
		foreach(keys %{$hash{"hours"}} ) { $dates{$_}=$hash{"hours"}->{$_}; }
		foreach(keys %{$hash{"weeks"}} ) { $weeks{$_}=$hash{"weeks"}->{$_}; }
		foreach(keys %{$hash{"hosts"}} ) { $hosts{$_}=$hash{"hosts"}->{$_}; }
#		foreach(keys %{$hash{"countries"}} ) { $countries{$_}=$hash{"countries"}->{$_}; }
		foreach(keys %{$hash{"topdomains"}} ) { $topdomains{$_}=$hash{"topdomains"}->{$_}; }
		foreach(keys %{$hash{"domains"}} ) { $domains{$_}=$hash{"domains"}->{$_}; }
		foreach(keys %{$hash{"uaos"}} ) { $os{$_}=$hash{"uaos"}->{$_}; }
		foreach(keys %{$hash{"browsertypes"}} ) { $browsertypes{$_}=$hash{"browsertypes"}->{$_}; }
		foreach(keys %{$hash{"browserversions"}} ) { $browserversions{$_}=$hash{"browserversions"}->{$_}; }
		foreach(keys %{$hash{"pages"}} ) { $page{$_}=$hash{"pages"}->{$_}; }
		foreach(keys %{$hash{"links"}} ) { $links{$_}=$hash{"links"}->{$_}; }
		foreach(keys %{$hash{"write"}} ) { $write{$_}=$hash{"write"}->{$_}; }
		foreach(keys %{$hash{"attachdownload"}} ) { $attachdownload{$_}=$hash{"attachdownload"}->{$_}; }
		foreach(keys %{$hash{"attachpost"}} ) { $attachpost{$_}=$hash{"attachpost"}->{$_}; }
		foreach(keys %{$hash{"users"}} ) { $users{$_}=$hash{"users"}->{$_}; }
		foreach(keys %{$hash{"referers"}} ) { $referers{$_}=$hash{"referers"}->{$_}; }
		foreach(keys %{$hash{"agents"}} ) { $agents{$_}=$hash{"agents"}->{$_}; }
		foreach(keys %{$hash{"allreferers"}} ) { $allreferers{$_}=$hash{"allreferers"}->{$_}; }
		foreach(keys %{$hash{"searchengines"}} ) { $searchengines{$_}=$hash{"searchengines"}->{$_}; }
		foreach(keys %{$hash{"keywords"}} ) { $keywords{$_}=$hash{"keywords"}->{$_}; }
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
		browsertypes	=> \%browsertypes,
		browserversions	=> \%browserversions,
		pages			=> \%page,
		links			=> \%links,
		write			=> \%write,
		attachdownload	=> \%attachdownload,
		attachpost		=> \%attachpost,
		users			=> \%users,
		referers		=> \%referers,
		agents			=> \%agents,
		allreferers		=> \%allreferers,
		searchengines	=> \%searchengine,
		keywords		=> \%keywords,
	);
}
sub analysis_sub {
	my ($data, $target, $t)=@_;
	my %dates=();
	my %hours=();
	my %weeks=();
	my %host=();
	my %hosts=();
	my %tmpcountries=();
#	my %countries=();
	my %topdomains=();
	my %domains=();
	my %tmptopdomains=();
	my %tmpdomains=();
	my %agents=();
	my %uabrowser=();
	my %uabrowserver=();
	my %browsertypes=();
	my %browserversions=();
	my %uaos=();
	my %os=();
	my %page=();
	my $pages=0;
	my %write=();
	my $writes=0;
	my %attachdownload=();
	my $attachdownloads=0;
	my %attachpost=();
	my $attachposts=0;
	my %users=();
	my %links=();
	my %referers=();
	my %allreferers=();
	my %searchengine=();
	my %keywords=();
	my $counts=0;
	my $cache=new Nana::Cache (
		ext=>"logs",
		files=>10000,
		dir=>$::cache_dir,
		size=>100000,
		use=>1,
		expire=>365*24*60*60,
		crlf=>1
	);
	my $timestamp=0;
	my $cachefile="logs_$target";
	my $buf=Nana::GZIP::gzipuncompress($cache->read($cachefile,1));
	foreach(split(/\n/,$buf)) {
		my($k,$n,$v)=split(/\f/,$_);
		$timestamp=$v if($k eq "timestamp");
	}
	if($buf ne '' && $timestamp >= $t) {
		foreach(split(/\n/,$buf)) {
			my($k,$n,$v)=split(/\f/,$_);
			$counts=$v if($k eq "count");
			$pages=$v if($k eq "pagecount");
			$writes=$v if($k eq "writecount");
			$attachdownloads=$v if($k eq "attachdownloads");
			$attachposts=$v if($k eq "attachposts");
			$dates{$n}=$v if($k eq "dates");
			$hours{$n}=$v if($k eq "hours");
			$weeks{$n}=$v if($k eq "weeks");
			$hosts{$n}=$v if($k eq "hosts");
			$countries{$n}=$v if($k eq "countries");
			$topdomains{$n}=$v if($k eq "topdomains");
			$domains{$n}=$v if($k eq "domains");
			$os{$n}=$v if($k eq "uaos");
			$browsertypes{$n}=$v if($k eq "browsertypes");
			$browserversions{$n}=$v if($k eq "browserversions");
			$page{$n}=$v if($k eq "pages");
			$links{$n}=$v if($k eq "links");
			$write{$n}=$v if($k eq "write");
			$attachdownload{$n}=$v if($k eq "attachdownload");
			$attachpost{$n}=$v if($k eq "attachpost");
			$users{$n}=$v if($k eq "users");
			$referers{$n}=$v if($k eq "referers");
			$agents{$n}=$v if($k eq "agents");
			$allreferers{$n}=$v if($k eq "allreferers");
			$searchengine{$n}=$v if($k eq "searchengines");
			$keywords{$n}=$v if($k eq "keywords");
		}
	} else {
		foreach my $log(split(/\n/,$data)) {
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
			if($cmd eq "ck") {
				$links{"$lang\t$page"}++;
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
			$users{$user}++;
			$hosts{"$hosts ($ip)"}++;
			my $domain;
			my $tmpdomain=lc $host;
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
			$browsertypes{$uabrowser{$browser}}++;
			$browserversions{$uabrowserver{$browser}}++;
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
				$referers{$refer}++;
			}
			$allreferers{$refer}++;
		}
		$buf=<<EOM;
timestamp\f\f$t
count\f\f$counts
pagecount\f\f$pages
writecount\f\f$writes
attachdownloads\f\f$attachdownloads
attachposts\f\f$attachposts
EOM
		foreach(keys %dates) { $buf.="dates\f$_\f$dates{$_}\n"; }
		foreach(keys %hours) { $buf.="hours\f$_\f$hours{$_}\n"; }
		foreach(keys %weeks) { $buf.="weeks\f$_\f$weeks{$_}\n"; }
		foreach(keys %hosts) { $buf.="hosts\f$_\f$hosts{$_}\n"; }
#		foreach(keys %countries) { $buf.="countries\f$_\f$countries{$_}\n"; }
		foreach(keys %topdomains) { $buf.="topdomains\f$_\f$topdomains{$_}\n"; }
		foreach(keys %domains) { $buf.="domains\f$_\f$domains{$_}\n"; }
		foreach(keys %os) { $buf.="uaos\f$_\f$os{$_}\n"; }
		foreach(keys %domains) { $buf.="domains\f$_\f$domains{$_}\n"; }
		foreach(keys %browsertypes) { $buf.="browsertypes\f$_\f$browsertypes{$_}\n"; }
		foreach(keys %browserversions) { $buf.="browserversions\f$_\f$browserversions{$_}\n"; }
		foreach(keys %page) { $buf.="pages\f$_\f$page{$_}\n"; }
		foreach(keys %links) { $buf.="links\f$_\f$links{$_}\n"; }
		foreach(keys %write) { $buf.="write\f$_\f$write{$_}\n"; }
		foreach(keys %attachdownload) { $buf.="attachdownload\f$_\f$attachdownload{$_}\n"; }
		foreach(keys %attachpost) { $buf.="attachpost\f$_\f$attachpost{$_}\n"; }
		foreach(keys %users) { $buf.="users\f$_\f$users{$_}\n"; }
		foreach(keys %referers) { $buf.="referers\f$_\f$referers{$_}\n"; }
		foreach(keys %agents) { $buf.="agents\f$_\f$agents{$_}\n"; }
		foreach(keys %allreferers) { $buf.="allreferers\f$_\f$allreferers{$_}\n"; }
		foreach(keys %searchengine) { $buf.="searchengines\f$_\f$searchengine{$_}\n"; }
		foreach(keys %keywords) { $buf.="keywords\f$_\f$keywords{$_}\n"; }
		$cache->write($cachefile,Nana::GZIP::gzipcompress($buf));
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
		browsertypes	=> \%browsertypes,
		browserversions	=> \%browserversions,
		pages			=> \%page,
		links			=> \%links,
		write			=> \%write,
		attachdownload	=> \%attachdownload,
		attachpost		=> \%attachpost,
		users			=> \%users,
		referers		=> \%referers,
		agents			=> \%agents,
		allreferers		=> \%allreferers,
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
