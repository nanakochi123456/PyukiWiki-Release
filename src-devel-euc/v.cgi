#!/usr/bin/perl
#!/usr/local/bin/perl --
#!c:/perl/bin/perl.exe
#!c:\perl\bin\perl.exe
#!c:\perl64\bin\perl.exe
######################################################################
# v.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: v.cgi,v 1.108 2012/03/18 11:23:49 papu Exp $
#
# "playvideo" ver 2.2a $$
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
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# 2012/02/18 change: WMVがなくてもMP4があれば一応動くようにした。
#                    その為、アップロード時に MP4::Infoが必要になります。
#                    IEでのポップアップを開くのが遅いのを修正した。
# 2012/02/14 change: 別ウィンドウを開かなくても出るモードを設置した。（β版）
# 2012/02/13 change: JavaScriptポップアップでウィンドウサイズを変更するように
#                    した。
#                    video.jsを2.0.2から3.0.7にバージョンアップした。
# 2011/10/07 change: 複数のサイトに動画が分散していても対応できるようにした。
#                    ただし、wmvだけはPyukiWikiと同じサイトに設置しなければ
#                    いけませんが、mp4やflvも別サイトに設置することが
#                    できるようになった。
#                    このバージョンにするには、deletecache をする必要があり、
#                    かつ、FLV、MP4ファイルを消去した場合、もう一度 deletecache
#                    をする必要があります。
#                    無圧縮zip以外にも、生のWMVファイルをダウンロードできる
#                    ようにした。（デフォルトは無圧縮zip）
# 2011/10/05 change: HEADリクエストを用いて、WMV以外の拡張子の動画を
#                    PyukiWikiが設置してあるサーバー以外に設定できるように
#                    した。また、IE 9 において、video.jsを無効化した。
# 2011/10/02 change: HTML5プレイヤーに対応、その為、HTML5ブラウザーでなく
#                    Flashで再生する場合に、別途MP4ファイルが必要になる。
#                    その時の変換フォーマットは、FlowPlayerが認識するように
#                    MPEG4 AVC/H.264形式で変換しなければならない。
#                    旧来のFlashでの再生もサポートしていますが、IE10の
#                    デスクトップ版以外でサポートされなくなるため、互換性の為に
#                    準備だけはしてあります。
#                    IE9の不具合で、IE9においては、HTML5プレイヤーは使用
#                    できないようになっています。
# 2011/09/11 change: デフォルトのスキンを読み込めるようにした。
#                    FireFoxでキー操作により動画のリロードするのを阻止した。
#                    設定してある漢字コードで出力できるようにした。
# 2011/06/12 change: flv動画にも対応した。ただし、wmvも必要です。
# 2011/05/26 change: wmvにタグが付けられている場合、zipファイルのダウンロード
#                    ファイル名をその名前に指定できるようにした。
# 2011/05/26 change: info/setup.cgiに対応した
# 2011/03/14 change: Content-disposition: attachment; filename="$file.wvx"
#                    を出力すると問題がある可能性があるため、出力を
#                    抑制した。
# 2011/03/01 change: 拡張子をwvxに変更した。
#                    Content-Type: video/x-ms-wvx を出力した。
#                    Content-disposition: attachment; filename="$file.wvx"
#                    を出力した。
# 2010/12/10 change: ニコニコ動画に対応した
# 2010/11/13 change: 無圧縮zipでダウンロードできるようにした。
#                    大量の動画があるときキャッシュから取得するように
#                    した。ただし、有効期限は１時間です。
# 2010/10/27 change: MSIE とOpera以外はWindwos Mediaプレイヤー
#                    再生時に_blank(実質別タブ）になるようにした。
#                    Safariでは本当に別窓になります。
# 2010/10/24 change: use sub make_link_target
######################################################################
# You MUST modify following initial file.
BEGIN {
	$::ini_file = "pyukiwiki.ini.cgi";
######################################################################
$PLUGIN="playvideo";
$VERSION="2.2a";

	$::_conv_start = (times)[0];

	$::ini_file = "pyukiwiki.ini.cgi" if($::ini_file eq "");
	require $::ini_file;
	require $::setup_file if (-r $::setup_file);

	push @INC, "$::sys_dir";
	push @INC, "$::sys_dir/CGI";
}

# If Windows NT Server, use sample it
#BEGIN {
#	chdir("C:/inetpub/cgi-bin/pyuki");
#	push @INC, "C:/inetpub/cgi-bin/pyuki/lib/";
#	push @INC, "C:/inetpub/cgi-bin/pyuki/lib/CGI";
#	push @INC, "C:/inetpub/cgi-bin/pyuki/";
#	$::_conv_start = (times)[0];
#}

$::defaultcode="euc";

require "$::plugin_dir/playvideo_v_cgi.pl";

__END__
=head1 NAME

v.cgi - PyukiWiki External Plugin of video player wrapper

=head1 SYNOPSIS

Playvideo Plugin

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/playvideo/

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Nanami/playvideo/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/v.cgi?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/v.cgi?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/playvideo.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/playvideo.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/playvideo_v_cgi.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/playvideo_v_cgi.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

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
