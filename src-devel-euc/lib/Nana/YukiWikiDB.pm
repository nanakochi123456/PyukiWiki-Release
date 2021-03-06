######################################################################
# YukiWikiDB.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: YukiWikiDB.pm,v 1.491 2012/03/18 11:23:51 papu Exp $
#
# "Nana::YukiWikiDB" ver 0.6 $$
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

package Nana::YukiWikiDB;
$VERSION="0.6";
use strict;
use Nana::File;

# Constructor
sub new {
	return shift->TIEHASH(@_);
}

# error									# debug
sub die {								# debug
	$::debug.="YukiWikiDB:$_[0]\n";		# debug
	return undef;						# debug
}										# debug

# tying												# comment
sub TIEHASH {
	my ($class, $dbname) = @_;
	my $self = {
		dir => $dbname,
		keys => [],
	};
	if (not -d $self->{dir}) {
		if (!mkdir($self->{dir}, 0777)) {
			return &die("mkdir $self->{dir} fail"); # debug
			return undef;
		}
	}
	return bless($self, $class);
}

# Store												# comment
sub STORE {
	my ($self, $key, $value) = @_;
	my ($mode, $filename) = &make_filename($self, $key);
	return Nana::File::lock_store($filename,$value);
}

# Fetch												# comment
sub FETCH {
	my ($self, $key) = @_;
	my ($mode, $filename) = &make_filename($self, $key);
	return (stat($filename))[9] if($mode eq "update");
	return Nana::File::lock_fetch($filename);
}

# Exists											# comment
sub EXISTS {
	my ($self, $key) = @_;
	my ($mode, $filename) = &make_filename($self, $key);
	return -e($filename);
}

# Delete											# comment
sub DELETE {
	my ($self, $key) = @_;
	my ($mode, $filename) = &make_filename($self, $key);
	return Nana::File::lock_delete($filename);
}

sub FIRSTKEY {
	my ($self) = @_;
	if(opendir(DIR, $self->{dir})) {
		my $funcp = $::functions{"undbmname"};
		@{$self->{keys}} = grep /\.txt$/, readdir(DIR);
		foreach my $name (@{$self->{keys}}) {
			$name =~ s/\.txt$//;
			$name=&$funcp($name);
		}
		closedir(DIR);
		return shift @{$self->{keys}};
	} else {											# debug
		return &die("FIRSTKEY: $self->{dir} fail"); 	# debug
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

1;
