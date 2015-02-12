######################################################################
# YukiWikiDB.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: YukiWikiDB.pm,v 1.172 2011/12/31 13:06:14 papu Exp $
#
# "Nana::YukiWikiDB" version 0.4 $$
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
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################
package Nana::YukiWikiDB;
$VERSION="0.4";
use strict;
use Nana::File;
# Constructor
sub new {
	return shift->TIEHASH(@_);
}
# tying
sub TIEHASH {
	my ($class, $dbname) = @_;
	my $self = {
		dir => $dbname,
		keys => [],
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
	my $filename = &make_filename($self, $key);
	return Nana::File::lock_store($filename,$value);
}
sub FETCH {
	my ($self, $key) = @_;
	my $filename = &make_filename($self, $key);
	return Nana::File::lock_fetch($filename);
}
sub EXISTS {
	my ($self, $key) = @_;
	my $filename = &make_filename($self, $key);
	return -e($filename);
}
# Delete
sub DELETE {
	my ($self, $key) = @_;
	my $filename = &make_filename($self, $key);
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
	}
	return;
}
sub NEXTKEY {
	my ($self) = @_;
	return shift @{$self->{keys}};
}
sub make_filename {
	my ($self, $key) = @_;
	$key =~ s/(.)/$::_dbmname_encode{$1}/g;
	return $self->{dir} . "/$key.txt";
}
1;