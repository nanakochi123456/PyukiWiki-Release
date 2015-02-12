######################################################################
# antispam.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: antispam.inc.pl,v 1.336 2012/03/18 11:23:55 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
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
# This is extented plugin.
# To use this plugin, rename to 'antispam.inc.cgi'
######################################################################
#
# メールアドレス自動収集防止
#
# 使い方：
#   ・antispam.inc.plをantispam.inc.cgiにリネームするだけで使えます
#
######################################################################

# Initlize												# comment

sub plugin_antispam_init {
	$::AntiSpam_Count=0;
	$::AntiSpam="enable";
	$::functions{make_link_mail}=\&make_link_mail;
	return ('init'=>1
		, 'func'=>'make_link_mail', 'make_link_mail'=>\&make_link_mail);
}

# hack wiki.cgi of make_link_mail						# comment

sub make_link_mail {
	my($chunk,$escapedchunk)=@_;
	my $adr=$chunk;
	$::IN_HEAD.=&maketoken if($::Token eq '');
	$adr=~s/^[Mm][Aa][Ii][Ll][Tt][Oo]://g;
	my $mailtoadr="mailto:$adr";
	return qq(<a href="$mailtoadr" class="mail">$escapedchunk</a>) if($::Token eq '');

	my $chunk1=&Enc_UntiSpam("mailto:$adr");

	$::AntiSpam_Count++;
	my $id="antispammail$::AntiSpam_Count";

	if($adr eq $escapedchunk || $mailtoadr eq $escapedchunk) {
		$escapedchunk=&Enc_UntiSpam("$escapedchunk");
		$::AntiSpam_Count++;
		return qq(<span class="mail" id="$id" onclick="addec_link('$chunk1\')" onkeypress="void(0);"><script type="text/javascript"><!--\naddec_text('$escapedchunk','$id');\n//--></script></span>);
	} else {
		return qq(<span class="mail" id="$id" onclick="addec_link('$chunk1\','$id')" onkeypress="void(0);">$escapedchunk</span>);
	}
}

sub Enc_UntiSpam {
	my($ad) = @_;
	return &password_encode($ad,$::Token);
}

1;
__DATA__
sub plugin_antispam_setup {
	return(
	'ja'=>'迷惑メール防止',
	'en'=>'Anti Spam Plugin',
	'override'=>'make_link_mail',
	'url'=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/antispam/'
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

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/antispam/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/antispam.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/lib/antispam.inc.pl?view=log>

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

L<http://pyukiwiki.sfjp.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2012 by Nanami.

Copyright (C) 2005-2012 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
