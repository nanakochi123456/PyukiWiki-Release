######################################################################
# antispam.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: antispam.inc.pl,v 1.93 2011/05/03 20:43:28 papu Exp $
#
# "PyukiWiki" version 0.1.8-rc6 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2010 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2010 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'antispam.inc.cgi'
######################################################################
#
# �᡼�륢�ɥ쥹��ư�����ɻ�
#
# �Ȥ�����
#   ��antispam.inc.pl��antispam.inc.cgi�˥�͡��ह������ǻȤ��ޤ�
#
######################################################################


## ����ȡ�����ˤ����硢16ʸ����Ʊ���ʸ����¸�ߤ��ƤϤ����ʤ�
#$antispam::token="Tfj8a9xNoLkm2Z43"
#	if(!defined($antispam::token));

# Initlize

sub plugin_antispam_init {
	my $header;
	if($::AntiSpam eq '') {
		$::AntiSpam=$antispam::token;
		if($::AntiSpam eq '') {
			my (@token) = ('0'..'9', 'A'..'Z', 'a'..'z');
			$::AntiSpam="";
			my $add=0;
			for(my $i=0; $i<16;) {
				my $token;
				$token=$token[(time + $add++ + $i + int(rand(62))) % 62]; # 62 is scalar(@token)
				if($::AntiSpam!~/$token/) {
					$::AntiSpam.=$token;
					$i++;
				}
			}
		}
	}
	$header=qq(<script type="text/javascript">@{[!$::is_xhtml ? "<!--\n" : '']}var cs = "$::AntiSpam";@{[!$::is_xhtml ? '//-->' : '']}</script>\n);

	$::functions{make_link_mail}=\&make_link_mail;
	return ('header'=>$header,'init'=>1
		, 'func'=>'make_link_mail', 'make_link_mail'=>\&make_link_mail);
}

# hack wiki.cgi of make_link_mail

sub make_link_mail {
	my($chunk,$escapedchunk)=@_;

	my $adr=$chunk;
	$adr=~s/^[Mm][Aa][Ii][Ll][Tt][Oo]://g;
	my $mailtoadr="mailto:$adr";
	return qq(<a href="$mailtoadr" class="mail">$escapedchunk</a>) if($::AntiSpam eq '');

	my $chunk1=&Enc_UntiSpam("mailto:$adr");

	if($adr eq $escapedchunk || $mailtoadr eq $escapedchunk) {
		$escapedchunk=&Enc_UntiSpam("$escapedchunk");
		return qq(<span class="mail" onclick="addec_link('$chunk1\')" onkeypress="void(0);"><script type="text/javascript">@{[!$::is_xhtml ? "<!--\n" : '']}addec_text('$escapedchunk');\n@{[!$::is_xhtml ? '//-->' : '']}</script></span>);
	} else {
		return qq(<span class="mail" onclick="addec_link('$chunk1\')" onkeypress="void(0);">$escapedchunk</span>);
	}
}

sub Enc_UntiSpam {
	my( $adr ) = @_;
	my( $i, $dd, $res, $dif );
	my $enc_list = $::AntiSpam;
	$dif = int(rand(127));
	$res = substr($enc_list,$dif/0x10,1).substr($enc_list,$dif%0x10,1);
	for( $i = 0 ; $i < length( $adr ) ; $i ++ ) {
		$dd = ord(substr($adr,$i,1))+$dif;
		$res .= substr($enc_list,$dd/0x10,1).substr($enc_list,$dd%0x10,1);
	}
	return( $res );
}

1;
__DATA__
sub plugin_antispam_setup {
	return(
	'ja'=>'���ǥ᡼���ɻ�',
	'en'=>'Anti Spam Plugin',
	'override'=>'make_link_mail',
	'url'=>'http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/antispam/'
	);
}
__END__

=head1 NAME

antispam.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Anti Spam Plugin

=head1 DESCRIPTION

All the mail addresses outputted by PyukiWiki are enciphered, and it enables it to decode by the browser for the measure to troublesome mail and a mail address collection program.

=head1 USAGE

rename to antispam.inc.cgi

=head1 OVERRIDE

make_link_mail function was overrided.

=head1 WARNING

The mail address at the time of being outputted like direct html of <a href="mailto:..."> from plug-in is not enciphered.

Please go via a function make_link_mail.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/antispam

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/antispam/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/antispam.inc.pl?view=log>

=item The measure against a collection contractor (an automatic collection program and robot) of a mail address

L<http://ninja.index.ne.jp/~toshi/soft/untispam.shtml>

The anti spam library is copy free.

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=item Toshi(NINJA104)

L<http://ninja.index.ne.jp/~toshi/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2010 by Nanami.

Copyright (C) 2005-2010 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
