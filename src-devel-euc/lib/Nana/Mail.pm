######################################################################
# Mail.pm - This is PyukiWiki, yet another Wiki clone.
# $Id: Mail.pm,v 1.423 2012/03/01 10:39:20 papu Exp $
#
# "Nana::Mail" version 0.4 $$
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
# require perl version >= 5.8.1
######################################################################

package	Nana::Mail;
use 5.8.1;
use strict;
use vars qw($VERSION);
$VERSION = '0.4';

# sendmail¥Ñ¥¹¸¡º÷¸õÊä
$Nana::Mail::sendmail=<<EOM;
/var/qmail/bin/sendmail
/usr/sbin/sendmail
/usr/bin/sendmail
EOM

######################################################################

use Jcode;

sub utf8mail {
	my $flg=0;
	if($::send_utf8_mail ne 0) {
		if(&load_module("Jcode") && &load_module("MIME::Base64")) {
			return 1;
		}
	}
	return 0;
}

sub mime_conv {
	my($str,$code)=@_;
	if (&utf8mail) {
		return "" if($str eq "");
		$str=Jcode->new($str,$code)->utf8;
		$str=MIME::Base64::encode_base64($str, "");
		$str='=?utf-8?B?' . $str . '?=';
	} else {
		$str=Jcode->new($str,$code)->jis;
		$str=Jcode->new($str)->mime_encode;
	}
	return $str;
}

sub mime_conv_body {
	my($data,$code)=@_;
	if (&utf8mail) {
		$data=Jcode->new($data,$code)->utf8;
		$data=MIME::Base64::encode_base64($data);
	} else {
		$data=Jcode->new($data,$code)->jis;
	}
	return $data;
}

sub send {
	my(%hash)=@_;
	my $to=$hash{to};
	my $to_name=&mime_conv($hash{to_name},$::defaultcode);
	my $from=$hash{from};
	my $from_name=&mime_conv($hash{from_name},$::defaultcode);
	my $subject=$hash{subject};
	$subject="[Wiki] $::basehref" if($subject eq '');
	$subject=&mime_conv($subject,$::defaultcode);
	my $data=&mime_conv_body($hash{data},$::defaultcode);
	return 1 if($to eq '' || $from eq '' || $::modifier_sendmail eq '');

	$to=qq($to_name\n <$to>) if($to_name ne '');
	$from=qq($from_name\n <$from>) if($from_name ne '');
	my $mail;
	my $part=time;

	if (&utf8mail) {
		$mail=<<EOM;
To: $to
From: $from
Subject: $subject
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_$part"
Content-Transfer-Encoding: 7bit

------=_Part_$part
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

$data
------=_Part_$part--
EOM
	} else {
		$mail=<<EOM;
To: $to
From: $from
Subject: $subject
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

$data
EOM
	}
	&sendmail($mail);
}

sub sendmail {
	my($mail)=@_;
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

sub load_module {
	my $funcp = $::functions{"load_module"};
	return &$funcp(@_);
}
1;
__END__
