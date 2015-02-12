######################################################################
# autometarobot.inc.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: autometarobot.inc.pl,v 1.42 2006/03/17 14:00:10 papu Exp $
#
# "PyukiWiki" version 0.1.6 $$
# Author: Nanami http://lineage.netgamers.jp/
# Copyright (C) 2004-2006 by Nekyo.
# http://nekyo.hp.infoseek.co.jp/
# Copyright (C) 2005-2006 PyukiWiki Developers Team
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
# To use this plugin, rename to 'autometarobot.inc.cgi'
######################################################################
#
# �ڡ���������ܥåȷ��������󥸥�ؤΥ�����ɤ�ư��������
#
######################################################################

$::auto_meta_maxkeyword=30								# ��ư������ɤ����ñ���
	if(!defined($::auto_meta_maxkeyword));				# 0�ʤ���Ф��ʤ�
$::auto_meta_minlength=6								# ��ư������ɤκǾ�ʸ����
	if(!defined($::auto_meta_minlength));

# Initlize

sub plugin_autometarobot_init {
	return ('init'=>1, 'func'=>'meta_robots', 'meta_robots'=>\&meta_robots);
}

# hack wiki.cgi of meta_robots

sub meta_robots {
	my($cmd,$pagename,$body)=@_;
	my $robots;
	my $keyword;
	if($cmd=~/edit|admin|diff|attach/
		|| $::form{mypage} eq '' && $cmd!~/list|sitemap|recent/
		|| $::form{mypage}=~/SandBox|$::resource{help}|$::resource{rulepage}|$::MenuBar|$::non_list/
		|| &is_readable($::form{mypage}) eq 0) {
		$robots.=<<EOD;
<meta name="robots" content="NOINDEX,NOFOLLOW,NOARCHIVE" />
<meta name="googlebot" content="NOINDEX,NOFOLLOW,NOARCHIVE" />
EOD
	} else {
		$robots.=<<EOD;
<meta name="robots" content="INDEX,FOLLOW" />
<meta name="googlebot" content="INDEX,FOLLOW,ARCHIVE" /> 
EOD
		$keyword=$::meta_keyword;
		if($::auto_meta_maxkeyword>0) {
			$keyword="$::wiki_title," . &htmlspecialchars($pagename);
			# �ʲ�������ɼ�ư����
			my @keyword;
			$keyword="$::wiki_title," . &htmlspecialchars($pagename);
			# <h?>��</h?>����Ĵ��WikiName
			foreach($body=~/(<h\d>(.+)<\/h\d>|<strong>(.+)<\/strong>|$::wiki_name)/g) {
				s/[\x0d\x0a]//g;
				s/<.*?>//g;
				$keyword.="$_ ";
			}
			# img alt="��", a title="��"
			foreach($body=~/<(?:a|img)(?:.+?)(?:alt|title)="(.+?)"(?:.+)>/g) {
				next if(/^$::non_list|$::isurl/);
				s/[\x0d\x0a]//g;
				s/<.*?>//g;
				next if(/$::resource{editthispage}|$::resource{admineditthispage}/);
				$keyword.="$_ ";
			}
			$keyword=~s/$::_symbol_anchor//g;
			$keyword=~s/([\x0-\x2f|\x3a-\x40|\x5b-\x60|\x7b-\x7f]|(?:\xA1\xA1))/,/g;

			my $ascii = '[\x00-\x7F]'; # 1�Х��� EUC-JPʸ��
			my $twoBytes = '(?:[\x8E\xA1-\xFE][\xA1-\xFE])'; # 2�Х��� EUC-JPʸ��
			my $threeBytes = '(?:\x8F[\xA1-\xFE][\xA1-\xFE])'; # 3�Х��� EUC-JPʸ��
			$keyword=~s/($ascii)($twoBytes|threeBytes)/$1,$2/g;
			$keyword=~s/($twoBytes|threeBytes)($ascii)/$1,$2/g;
			my @keyword;
			foreach(split(/,/,$keyword)) {
				push(@keyword,$_)
					unless(length($_) < $::auto_meta_minlength);
			}
			$keyword="";
			my $i=0;
			foreach(@keyword) {
				unless($keyword=~/$_/) {
					$keyword.="$_,";
					last if(++$i >= $::auto_meta_maxkeyword);
				}
			}
			$keyword=~s/,$//g;
		}
		$robots.=<<EOD;
<meta name="keywords" content="$keyword" />
EOD
	}
	return $robots;
}

1;
__DATA__
sub plugin_autometarobot_setup {
	return(
	'ja'=>'�������󥸥������ư�����������',
	'en'=>'Auto generation keyword for robot of search engine',
	'override'=>'meta_robots',
	'url'=>'http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/autometarobot/'
	);
}
__END__
=head1 NAME

autometarobot.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

The keyword for robot type search engines is generated automatically.

=head1 USAGE

rename to autometarobot.inc.cgi

=head1 OVERRIDE

meta_robots function was overrided.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/autometarobot

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/autometarobot/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/lib/autometarobot.inc.pl>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://lineage.netgamers.jp/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=head1 LICENSE

Copyright (C) 2005-2006 by Nanami.

Copyright (C) 2005-2006 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut