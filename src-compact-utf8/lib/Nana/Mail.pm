######################################################################
# Mail.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: Mail.pm,v 1.172 2011/12/31 13:06:14 papu Exp $
#
# "Nana::Mail" version 0.3 $$
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
# require perl version >= 5.8.1
######################################################################
package	Nana::Mail;
use 5.8.1;
use strict;
use vars qw($VERSION);
$VERSION = '0.3';
# sendmailパス検索候補
$Nana::Mail::sendmail=<<EOM;
/var/qmail/bin/sendmail
/usr/sbin/sendmail
/usr/bin/sendmail
EOM
######################################################################
use Jcode;
sub mime_conv {
	my($str,$code)=@_;
	$str=Jcode->new($str,$code)->jis;
	$str=Jcode->new($str)->mime_encode;
	return $str;
}
sub send {
	my(%hash)=@_;
	my $to=&mime_conv($hash{to},$::defaultcode);
	my $to_name=&mime_conv($hash{to_name},$::defaultcode);
	my $from=&mime_conv($hash{from},$::defaultcode);
	my $from_name=&mime_conv($hash{from_name},$::defaultcode);
	my $subject=&mime_conv($hash{subject},$::defaultcode);
	my $data=Jcode->new($hash{data},$::defaultcode)->jis;
	return 1 if($to eq '' || $from eq '' || $::modifier_sendmail eq '');
	$subject="[Wiki] $::basehref" if($subject eq '');
	$to=qq($to_name\n <$to>) if($to_name ne '');
	$from=qq($from_name\n <$from>) if($from_name ne '');
	my $mail=<<EOM;
To: $to
From: $from
Subject: $subject
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
$data
EOM
	foreach(split(/\n/,"$::modifier_sendmail\n$Nana::Mail::sendmail")) {
		my($exec,$opt1, $opt2, $opt3, $opt4, $opt5)=split(/ /,$_);
		if(-r $exec) {
			open(MAIL, "| $exec $opt1 $opt2 $opt3 $opt4 $opt5");
			print MAIL $mail;
			close(MAIL);
			return 0;
		}
	}
	return 1
}
sub toadmin {
	my($mode,$page,$data)=@_;
	$data=$::database{$page} if($data eq '');
	my $getremotehost = $::functions{"getremotehost"};
	&$getremotehost;
	my $message = <<"EOD";
--------
WIKI = $::modifier_rss_title
MODE = $mode
REMOTE_ADDR = $ENV{REMOTE_ADDR}
REMOTE_HOST = $ENV{REMOTE_HOST}
--------
$page
--------
$data
--------
EOD
	&send(to=>$::modifier_mail, from=>$::modifier_mail,
		  subject=>"[Wiki]$mode $::basehref", data=>$message);
}
1;
__END__