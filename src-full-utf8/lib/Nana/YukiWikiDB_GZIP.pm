######################################################################
# YukiWikiDB_GZIP.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: YukiWikiDB_GZIP.pm,v 1.239 2012/03/18 11:23:56 papu Exp $
#
# "Nana::YukiWikiDB_GZIP" ver 0.7 $$
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
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################
package Nana::YukiWikiDB_GZIP;
$VERSION="0.7";
use strict;
use Nana::File;
use Nana::GZIP;
# Constructor
sub new {
	return shift->TIEHASH(@_);
}
sub TIEHASH {
	my ($class, $dbname) = @_;
	my $self = {
		dir => $dbname,
		keys => [],
		gzip => Nana::GZIP::init(),
	};
	if (not -d $self->{dir}) {
		if (!mkdir($self->{dir}, 0777)) {
			return undef;
		}
	}
	return bless($self, $class);
}
sub STORE {
	my ($self, $key, $value) = @_;
	my ($mode, $filename) = &make_filename($self, $key);
	my ($mode, $filename_gz) = &make_filename_gz($self, $key);
	if($self->{gzip} eq 1) {
		Nana::File::lock_delete($filename);
		return Nana::File::lock_store($filename_gz,
			Nana::GZIP::gzipcompress($value));
	}
	return Nana::File::lock_store($filename,$value);
}
sub FETCH {
	my ($self, $key) = @_;
	my ($mode, $filename) = &make_filename($self, $key);
	my ($mode, $filename_gz) = &make_filename_gz($self, $key);
	if($self->{gzip} eq 1) {
		if(-e $filename_gz) {
			return (stat($filename_gz))[9] if($mode eq "update");
			my $data=Nana::File::lock_fetch($filename_gz);
			return Nana::GZIP::gzipuncompress($data);
		}
	}
	return (stat($filename))[9] if($mode eq "update");
	return Nana::File::lock_fetch($filename);
}
sub EXISTS {
	my ($self, $key) = @_;
	my ($mode, $filename) = &make_filename($self, $key);
	my ($mode, $filename_gz) = &make_filename_gz($self, $key);
	return 1 if (-e $filename);
	return 1 if (-e $filename_gz);
	return 0;
}
sub DELETE {
	my ($self, $key) = @_;
	my $filename = &make_filename($self, $key);
	my $filename_gz = &make_filename_gz($self, $key);
	Nana::File::lock_delete($filename);
	Nana::File::lock_delete($filename_gz);
}
sub FIRSTKEY {
	my ($self) = @_;
	if(opendir(DIR, $self->{dir})) {
		my $funcp = $::functions{"undbmname"};
		@{$self->{keys}} = grep /\.txt\.gz$/, readdir(DIR);
		foreach my $name (@{$self->{keys}}) {
			$name =~ s/\.gz$//;
			$name =~ s/\.txt$//;
			$name=&$funcp($name);
		}
		closedir(DIR);
		return shift @{$self->{keys}};
	}
	return;
}
sub NEXTKEY {
	my ($self) = @_;
	return shift @{$self->{keys}};
}
sub make_filename {
	my ($self, $key) = @_;
	my $mode="";
	if($key=~/^\_\_(.+?)\_\_(.+?)$/) {
		$mode=$1;
		$key=$2;
	}
	$key =~ s/(.)/$::_dbmname_encode{$1}/g;
	return ($mode, $self->{dir} . "/$key.txt");
}
sub make_filename_gz {
	my ($self, $key) = @_;
	my $mode="";
	if($key=~/^\_\_(.+?)\_\_(.+?)$/) {
		$mode=$1;
		$key=$2;
	}
	$key =~ s/(.)/$::_dbmname_encode{$1}/g;
	return ($mode, $self->{dir} . "/$key.txt.gz");
}
1;
