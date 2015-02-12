PyukiWiki - 自由にページを追加・削除・編集できるWebページ構築CGI

	"PyukiWiki" ver 0.2.0-p3 $$
	Copyright (C)
	  2005-2012 PukiWiki Developers Team
	  2004-2012 Nekyo (Based on PukiWiki, YukiWiki)
	License: GPL version 3 or (at your option) any later version
			and/or Artistic version 1 or later version.
	Based on YukiWiki http://www.hyuki.com/yukiwiki/
	and PukiWiki http://pukiwiki.sfjp.jp/

	URL:
	http://nekyo.qp.land.to/
	http://pyukiwiki.sfjp.jp/

	MAIL:
		Nanami <nanami (at) daiba (dot) cx> (注：バーチャル女の子です)

	$Id: README.txt,v 1.334 2012/03/18 11:23:54 papu Exp $

	このテキストファイルはUTF-8、TAB4で記述されています。

-------------------------------------------------
■目次
-------------------------------------------------
・最新情報
・概要
・ライセンス
・寄付について
・パッケージについて
・はじめに
・ファイル一覧
・CSSを編集したければ？
・JavaScriptを編集したければ？
・もし動かなければ？
・アップデート版においての追記
・簡単なFAQ
・0.2.0-p2からの主な変更点
・0.2.0-p1からの主な変更点
・0.2.0からの主な変更点
・0.1.9からの主な変更点
・0.1.8からの主な変更点
・0.1.7からの主な変更点
・0.1.5からの主な変更点
・使用しているライブラリ等
・謝辞
・作者

-------------------------------------------------
■最新情報
-------------------------------------------------
以下のURLで最新情報を入手してください。
http://nekyo.qp.land.to/
http://pyukiwiki.sfjp.jp/

-------------------------------------------------
■概要
-------------------------------------------------
PyukiWiki（ぴゅきうぃき）はハイパーテキストを素早く容易に追加・編集・削除できる
Webアプリケーション(WikiWikiWeb)です。テキストデータからHTMLを生成することがで
き、Webブラウザーから何度でも修正することができます。

PyukiWikiはperl言語で書かれたスクリプトなので、多くのCGI動作可能なWebサーバー
（無料含む）に容易に設置でき、軽快に動作します。

なお、更に軽快に動作をさせたいのであれば、かなり最適化された
Nekyo氏のバージョンをご利用下さい。

http://nekyo.qp.land.to/

ただし、このバージョンは工夫をしないと、セキュリティーリスクが
ありますので注意して下さい。ユーザー権限のあるサーバーでは、
CGIインストーラで簡単に設定できるようになっています。

-------------------------------------------------
■ライセンス
-------------------------------------------------
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

>このプログラムはフリーソフトウェアです。それを再配布し、かつ、
>またはPerl自体と同じ条件の下でそれを修正することができます。

PyukiWikiは、GPL3もしくはArtisticライセンスの元で配布されます。
自由に利用し、自由に配布し、自由に改造し、それを再配布して構いません。
ただし、原版と同名のパッケージとして名乗ることを禁止します。
詳しくは、下記のURL，または、インストール済のPyukiWikiのwiki文から
ご確認下さい。

同梱しているライブラリには、一部MITライセンスの物が含まれますが
こちらは適用しません。

・PyukiWiki:ライセンスについて
　@@BASEURL/PyukiWiki/Install/License/

・GNU GPL
　http://www.gnu.org/licenses/gpl.html

・GNU GPLの日本語版
　http://sfjp.jp/magazine/07/09/02/130237

・GPL3情報ページ
　http://sfjp.jp/projects/opensource/wiki/GPLv3_Info

・参考　GPL2（[旧バージョン）
　http://www.opensource.jp/gpl/gpl.ja.html

・The Artistic License 1.0
　http://dev.perl.org/licenses/artistic.html

・The Artistic License 日本語訳
　http://www.opensource.jp/artistic/ja/Artistic-ja.html

・参考　Perl6's License Should be (GPL|Artistic-2.0)
　http://dev.perl.org/perl6/rfc/346.html

-------------------------------------------------
■寄付について
-------------------------------------------------
開発環境強化、継続的な開発の為に、寄付をお願いして
います。
vector シェアレジ（本ドキュメント記載時は準備中）、
銀行振り込みに対応しています。

銀行振り込み等は以下のお振込に対応しています。
・銀行振り込み
　スルガ銀行、住信SBIネット銀行、三菱東京UFJ銀行
　三井住友銀行
・Edy to Edy
・電子マネー自体の郵送
・以下、18歳未満禁止
　タバコ自体を送る、出会い系サイト無料登録

vector シェアレジは以下のお振込に対応しています。
・クレジットカード
　VISA、MASTER、AMEX、JCB、UC、DC、NICOS、SAISON、
　ORICO、UFJ(MILLION)、DINERS、JACCS
・電子マネー（WebMoney、Bitcash）

寄付をしたくないが、安いものを買い物したい
　激安問屋！かいもの.jp
　http://shop.daiba.cx/ （http://かいもの.jp/)


寄付金額に関しては、いくらでも構いません。
ただし、vectorシェアレジでは、システム上、1000円
または、3000円と設定しています。

寄付に関してのURLは、以下となります。
http://www.daiba.cx/%3a%e5%af%84%e4%bb%98%e3%81%8a%e6%8c%af%e8%be%bc%e5%85%88/

寄付のうち、銀行振り込み、Edy to Edy、vector シェア
レジから受け取った金額のうち、５％を、少ないながらも
東日本大震災への寄付金として準備致します。

-------------------------------------------------
■動作環境
-------------------------------------------------
PyukiWikiの動作環境は以下のとおりです。

・サーバーとして、LinuxまたはFreeBSD、Solaris等 *NIX環境
　MacOS X (未検証)
　Windows （一部制限があります）

・CGIの動作し、Perl5.8.1（なるだけ）以降が動作するWebサーバー
　なお、Perl 5.0004に関しては現バージョンでは未サポートです。
　最新のPerl5.10系及び5.12系、5.14系でも動作確認済みです。

・full版はインストール時に2Mバイト、compact版は
　インストール時に1Mバイト必要です。

・compact版は、以下のモジュールがサーバーにインストール
　されている必要があります。
　Jcode.pm、Time::Local

-------------------------------------------------
■パッケージについて
-------------------------------------------------
・-full
　通常はこちらをインストールします。

・-compact
　サーバーの容量が少ない場合、こちらを導入してみて下さい。
　以下の制限があります。
　・あいまい検索,sitemap,showrss,bugtrack,perlpod,settingがない
　・管理プラグイン(listfrozen,server,servererror,versionlist)がない
　・PukiWiki互換ダミープラグインがない
　・Explugin lang, setting, urlhack, punyurl等多数ない
　・添付ファイルは一部の圧縮ファイル、画像以外できません。
　・英語関係ファイルがない
　・バックアップができない
　・Jcode.pm、Time::Localがサーバーにインストールされている必要がある
　・その他、多くの制限事項がある

・-update-full, -update-compact
　アップデート用のファイルです。
　初期wiki、及び .htaccess ファイルがありません。

・-devel
　PyukiWikiプラグイン、及びコア開発に必要なツールが
　揃っています。ドキュメントのpodが付属しています。
　インストール時に約3Mバイトを使用します。

・?-utf8
　UTF8版です。他のコードセットは使用できません。
　また、UTF8版ではないバージョンとは互換性がありません。
　ただし、従来のwikiページを移行する為の管理者向けプラグイン
　convertutf8 が全バージョンに付属しています。

-------------------------------------------------
■はじめに
-------------------------------------------------
(1) index.cgiの一行目をあなたのサーバに合わせて修正します。




	等

　  Windows サーバーでは、
    #!c:/perl/bin/perl.exe
    #!c:\perl\bin\perl.exe
    #!c:\perl64\bin\perl.exe
　  を設定しても良いでしょう。

(2) pyukiwiki.ini.cgi の変数の値を修正します。

(3)「ファイル一覧」にあるファイルをサーバに転送します。
    転送モードやパーミッションを適切に設定します。

(4) ブラウザでサーバ上の index.cgiのURLにアクセスします。

-------------------------------------------------
■ファイル一覧
-------------------------------------------------
ここでのファイル一覧は、最新の一覧が翅いされていない可能性が
あります

●説明文

以下のファイルは、
Webサーバに転送する必要はありません。

+-- README.txt			解説文書（このファイル）
+-- COPYRIGHT.txt		GNU GENERAL PUBLIC LICENSE(原文）
+-- COPYRIGHT.ja.txt	GNU GENERAL PUBLIC LICENSE(日本語訳）

●CGI群

以下のファイルはCGIが実行できるディレクトリにFTPします。

 * と記載されているファイルは、コンパクト版にはありません。

                       転送モード パーミッション   説明
+-- index.cgi               TEXT  755 (rwxr-xr-x)  CGIwrapper
+-- pyukiwiki.ini.cgi       TEXT  644 (rw-r--r--)  定義ファイル
+-- lib                           755 (rwxr-xr-x)  使用モジュール群
    +-- wiki.cgi            TEXT  644 (rw-r--r--)  CGI本体
    +-- aguse.inc.pl*       TEXT  644 (rw-r--r--)  Exプラグイン
    +-- antispam.inc.pl     TEXT  644 (rw-r--r--)  Exプラグイン
    +-- antispamwiki.inc..  TEXT  644 (rw-r--r--)  Exプラグイン
    +-- authadmin_..inc.pl  TEXT  644 (rw-r--r--)  Exプラグイン
    +-- autometa....inc.pl  TEXT  644 (rw-r--r--)  Exプラグイン
    +-- google_an...inc.pl* TEXT  644 (rw-r--r--)  Exプラグイン
    +-- iecompati...inc.pl  TEXT  644 (rw-r--r--)  Exプラグイン
    +-- lang.inc.pl*        TEXT  644 (rw-r--r--)  Exプラグイン
    +-- linktrack.inc.pl*   TEXT  644 (rw-r--r--)  Exプラグイン
    +-- logs.inc.pl*        TEXT  644 (rw-r--r--)  Exプラグイン
    +-- punyurl.inc.pl*     TEXT  644 (rw-r--r--)  Exプラグイン
    +-- setting.inc.pl*     TEXT  644 (rw-r--r--)  Exプラグイン
    +-- slashpage.inc.pl*   TEXT  644 (rw-r--r--)  Exプラグイン
    +-- urlhack.inc.pl*     TEXT  644 (rw-r--r--)  Exプラグイン
    +-- Algorithm                 755 (rwxr-xr-x)  ディレクトリ
    |   +-- Diff.pm         TEXT  644 (rw-r--r--)  差分用
    |   AWS *                     755 (rwxr-xr-x)  ディレクトリ
    |   |-- browsers.pm*    TEXT  644 (rw-r--r--)  アクセス解析定義ファイル
    |   |-- domains.pm*     TEXT  644 (rw-r--r--)  （リリース版のみ）
    |   |-- operating_...*  TEXT  644 (rw-r--r--)
    |   |-- robots.pm*      TEXT  644 (rw-r--r--)
    |   +-- search_eng...*  TEXT  644 (rw-r--r--)
    +-- Digest*                   755 (rwxr-xr-x)  ディレクトリ
    |   +-- Perl*                 755 (rwxr-xr-x)  ディレクトリ
    |       +-- MD5.pm*     TEXT  644 (rw-r--r--)  md5 計算用
    +-- File                      755 (rwxr-xr-x)  ディレクトリ
    |   |-- MMagic.pm       TEXT  644 (rw-r--r--)  ファイル種別監査用
    |   |-- magic.txt*      TEXT  644 (rw-r--r--)  Magicファイル（リリース版のみ）
    |   +-- magic_compa..** TEXT  644 (rw-r--r--)  Magicファイル（コンパクト版のみ）
    +-- HTTP                      755 (rwxr-wr-x)  ディレクトリ
    |   +-- Lite.pm         TEXT  644 (rw-r--r--)  HTTPクライアント
    +-- IDNA*                     755 (rwxr-wr-x)  ディレクトリ
    |   +-- Punycode.pm*    TEXT  644 (rw-r--r--)  recent.inc.plで使用
    +-- Jcode*                    755 (rwxr-wr-x)  ディレクトリ
    |   +-- Unicode*              755 (rwxr-wr-x)  ディレクトリ
    |   |   +-- Contants.pm*TEXT  644 (rw-r--r--)  Jcode.pm で使用
    |   |   +-- NoXS.pm*    TEXT  644 (rw-r--r--)  Jcode.pm で使用
    |   |-- _Classic.pm*    TEXT  644 (rw-r--r--)  Jcode.pm で使用
    |   |-- Contants.pm*    TEXT  644 (rw-r--r--)  Jcode.pm で使用
    |   |-- H2Z.pm*         TEXT  644 (rw-r--r--)  Jcode.pm で使用
    |   |-- Tr.pm*          TEXT  644 (rw-r--r--)  Jcode.pm で使用
    |   +-- Unicode.pm*     TEXT  644 (rw-r--r--)  Jcode.pm で使用
    +-- Nana                      755 (rwxr-xr-x)  ディレクトリ
    |   |-- Cache.pm        TEXT  644 (rw-r--r--)  キャッシュモジュール
    |   |-- File.pm         TEXT  644 (rw-r--r--)  ファイルアクセスモジュール
    |   |-- GZIP.pm*        TEXT  644 (rw-r--r--)  gzip圧縮モジュール
    |   |-- HTTP.pm         TEXT  644 (rw-r--r--)  HTTPクライアント
    |   |-- Lock.pm         TEXT  644 (rw-r--r--)  ファイルロック用
    |   |-- Logs.pm*        TEXT  644 (rw-r--r--)  アクセスログ解析用
    |   |-- Mail.pm         TEXT  644 (rw-r--r--)  メール送信用
    |   |-- Pod2Wiki.pm*    TEXT  644 (rw-r--r--)  pod→wiki変換モジュール
    |   |-- Search.pm*      TEXT  644 (rw-r--r--)  あいまい検索用
    |   |-- YukiWikiDB.pm   TEXT  644 (rw-r--r--)  YukiWikiDB
    |   +-- YukiWikiDB_G..* TEXT  644 (rw-r--r--)  gzip圧縮版YukiWikiDB
    +-- Time                      755 (rwxr-wr-x)  ディレクトリ
    |   +-- Local.pm        TEXT  644 (rw-r--r--)  recent.inc.plで使用
    +-- Yuki                      755 (rwxr-xr-x)  ディレクトリ
        |-- DiffText.pm     TEXT  644 (rw-r--r--)  差分用
        |-- RSS.pm          TEXT  644 (rw-r--r--)  RSS用
        +-- YukiWikiDB.pm   TEXT  644 (rw-r--r--)  オリジナルのYukiWikiDB

●参照ファイル

以下のファイルは、
pyukiwiki.ini.cgi 内の変数 $::data_homeで指定するディレクトリに転送します。
詳しくは pyukiwiki.ini.cgi を参照して下さい。

+-- backup                        777 (rwxrwxrwx)  バックアップ保存用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- counter                       777 (rwxrwxrwx)  カウンタ値保存用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- diff                          777 (rwxrwxrwx)  差分保存用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- info                          777 (rwxrwxrwx)  情報保存用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- plugin                        777 (rwxrwxrwx)  プラグイン用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- resource                      755 (rwxr-xr-x)  リソース用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
|   +-- すべてのファイル    TEXT  644 (rw-r--r--)  リソースファイル
|   +-- conflict.ja.txt     TEXT  644 (rw-r--r--)  更新の衝突時のテキスト
+-- wiki                          777 (rwxrwxrwx)  ページデータ保存用ディレクトリ
    +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用

※バックアップ保持用ディレクトリは compactバージョンにはありません。

以下のファイルは、
pyukiwiki.ini.cgi 内の変数 $::data_pubで指定するディレクトリに転送します。
詳しくは pyukiwiki.ini.cgi を参照して下さい。


                       転送モード パーミッション   説明
+-- attach                        777 (rwxrwxrwx)  添付保存用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- cache                         777 (rwxrwxrwx)  一時ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- image                         755 (rwxr-xr-x)  画像保存用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- skin                          755 (rwxr-xr-x)  スキン用ディレクトリ
    +-- pyukiwiki.skin.ja.cgi     644 (rw-r--r--)  スキンファイル
    +-- default.ja.css            644 (rw-r--r--)  表示用 css
    +-- print.ja.css              644 (rw-r--r--)  印刷用 css
    +-- blosxom.css               644 (rw-r--r--)  blosxom 用 css
    +-- instag.js                 644 (rw-r--r--)  拡張編集用 JavaScript
    +-- common.ja.js              644 (rw-r--r--)  共通使用JavaScript
    +-- index.html                644 (rw-r--r--)  一覧表示防止用

●パーミッション設定のTIPS
一部ユーザー権限で動作するWebサーバーの場合、「とりあえず」
index.cgiのパーミッションを 701 (rwx-----x) にすることで動作します。
その他、セキュリティーを強化したい場合は、各ディレクトリを以下のように
設定します。

+-- attach                        701 (rwx-----x)  添付保存用ディレクトリ
+-- backup                        700 (rwx------)  バックアップ保存用ディレクトリ
+-- cache                         701 (rwx-----x)  一時ディレクトリ
+-- counter                       700 (rwx------)  カウンタ値保存用ディレクトリ
+-- diff                          700 (rwx------)  差分保存用ディレクトリ
+-- image                         701 (rwx-----x)  画像保存用ディレクトリ
+-- info                          700 (rwx------)  情報保存用ディレクトリ
+-- lib                           700 (rwx------)  使用モジュール群
+-- plugin                        700 (rwx------)  プラグイン用ディレクトリ
+-- resource                      700 (rwx------)  リソース用ディレクトリ
+-- skin                          701 (rwx-----x)  スキン用ディレクトリ
+-- wiki                          700 (rwx------)  ページデータ保存用ディレクトリ

-------------------------------------------------
■CSSを編集したければ？
-------------------------------------------------
・CSSはyuicompressorで圧縮されています。その為、編集しずらいと思いますので、
　編集をするのであれば、*.css.orgを参照して下さい。
　再圧縮するには、こちら（英語）をご覧下さい。
　http://developer.yahoo.com/yui/compressor/

-------------------------------------------------
■JavaScriptを編集したければ？
-------------------------------------------------
・JavaScriptは、yuicompressor、または、Packer Javascript en PHPで
　圧縮されています。
　その為、編集しずらいと思いますので、-devel 版をダウンロードの上
　*.js.srcを参照して下さい。
　再圧縮するには、こちら（英語）をご覧下さい。
　http://developer.yahoo.com/yui/compressor/
　http://joliclic.free.fr/php/javascript-packer/en/index.php
　JavaScriptファイルは、一部ファイルを除き、yuicompressorで圧縮後、そのまま
　javascript-packerでパック化して更にサイズ軽減を行なっています。

-------------------------------------------------
■もし動かなければ？
-------------------------------------------------
・パーミッションが正しいかどうか確認して下さい。
　サーバー提供会社、プロバイダ奨励のパーミッションをなるだけ優先して下さい。

・それでもだめなら.htaccessをまず削除してみて下さい。
　特に、attach/.htaccess, image/.htaccess, skin/.htaccessの削除を忘れないで下さい。

・一部のプロバイダーでは、設定に工夫が必要です。

・もしかしたら、OSがWindows系の場合がありますので、適切な設定をして下さい。

・MD5の設定変更については、このバージョンで解消されています。

・CGI.pmが導入されていないサーバーでは、別途配布されているCGI.pm.zipを解凍して
　lib 以下に置いて下さい。
　http://pyukiwiki.sfjp.jp/PyukiWiki/Download からダウンロードできます。

・utf8にしたら文字化けする？PukiWiki宛てのInterWikiが正常ではない？
　perl5.8.0以前のバージョンでかつサーバー上にJcodeがインストールされていません。
　代替のJcode.pm 0.88をインストールして下さい。
　http://pyukiwiki.sfjp.jp/cgi-bin/w/PyukiWiki/Download からダウンロードできます。

-------------------------------------------------
■アップデート版においての追記
-------------------------------------------------
アップデート版でも、ルートフォルダ（ディレクトリの）
「pyukiwiki.ini.cgi」が上書きされるため
アップデート前に必ずリネームして下さい。

また、こちらがお勧めですが、info/setup.ini.cgi に
pyukiwiki.ini.cgi の変更部分を記述すれば
スムーズにアップデートできるかと思います。

-------------------------------------------------
■簡単なFAQ
-------------------------------------------------
・PyukiWikiの作者が変ったのですか？
　いいえ、変ったのではなく追加です。
　とはいえ、原作者のNekyo氏は、現在開発を停止している模様です。

・PyukiWikiの動作が重いのですが
　compact版にすると多少は軽くなりますが、更に軽くする場合、Nekyo氏のオリジナル
　版をご利用になるとよいでしょう。ただし、多くの機能が制限されます。
　http://nekyo.qp.land.to/
　最新バグFix対応版は、こちらから
　http://sourceforge.jp/projects/pyukiwiki/releases/?package_id=4436

・既存のプラグインが動かなくなってしまったのですが？
　可能な限り、過去バージョン向けのプラグインを動作できるよう変更はしていますが、
　実質、0.1.6にて大幅に仕様が変更になり動作しなくなったものもあります。
　(popular, rename等は、既存バージョン用のプラグインが「まともに」
 （＝ちょっとしたことでも）動作しないので、新しいバージョンを添付しています）

・インストールしてみて、動かない？
　正常にパーミッション設定、及び、ファイルの適切な編集が完了したにも
　関わらず、動作しない場合は、gzip圧縮を無効にしてみて下さい。
　pyukiwiki.ini.cgi で
　$::gzip_path = 'nouse';
　を設定するか、
　info/setup.cgi で
　$::gzip_path = 'nouse';
　を設定してみて下さい。

・mod_perl、speedy_cgiで動かないのですが？
　mod_perlには対応確認済みです。speedy_cgiは未確認です。

・wiki.cgiが醜い(本来の変換は見にくい）のですが・・・
　-full版、-compact版は、実際に動作する環境の為に、余計なコメント等を
　大幅に削除しています。
　また、ベンチマークを取得して、ある程度サブルーチンの順番も考慮しています。
　そのため、0.1.5から比べて見にくいソースになっています。
　wiki.cgiのサブルーチンのコメントが必要な方は、-devel版をダウンロードして下さい。
　同一のバージョンであれば、-full版と-devel版であれば、混在しても動作します。

・ライセンスがかわったのですか？
　「you can redistribute it and/or modify it under the same terms as Perl itself.」
　「＝Perlと同じライセンスで再配布できます。」
　の文面を明確にすると、GPL3とArtisticライセンスが適用されることになります。
　SourceForge.jpプロジェクト登録のため、ライセンスをはっきりさせるために
　明記したのであり、基本的にはYukiWikiからのライセンスを継承しているものと考えています。

・PyukiWiki0.1.5のwikiをそのまま移行すると文面がおかしくなるのですが？
　多くのPukiWiki文法を取り入れると同時に、多くの文法不具合も修正されています。
　仕様外の文法で記述されている場合、不具合が生じることがあります。
　また、インラインプラグイン(&plugin(...);)において、「;」で終了していないと、
　不具合が起きます。ネスト可能にする為に厳格に文法チェックを行なっていますので、
　閉じていない場合は、「；」で閉じるようにして下さい。

・プラグインを作成してみたい？
　sample/ ディレクトリの、stationary.inc.pl、及び、stationary_explugin.inc.plを
　参考にして下さい。
　ExPluginは、本来プログラミングではあってはならない、関数の重複を逆に利用して
　実現している機能ですので、重複させる関数を設定する時には、十分注意して
　下さい。

-------------------------------------------------
■0.2.0-p2からの主な変更点
-------------------------------------------------
・セキュリティーホールFix
・ping Exプラグイン (weblog更新ping)作成（まだテスト版）
・trackback Exプラグイン、tb.inc.pl プラグイン (トラックバック）作成（受信のみ）
・extend edit の改良（IEでは一応動作しますが、まだ正常に動作しません）
・jquery.jsをcompact版以外同封
・PukiWiki Plusの顔文字を追加
・JavaScriptの圧縮方法の変更
・linktrack.inc.cgiのHTML出力量を削減

-------------------------------------------------
■0.2.0-p1からの主な変更点
-------------------------------------------------
・compact版できちんとビルドできていなかったのを修正
・index.cgi wrapperの変更（重要）
・スキンファイルの存在の確認方法の変更
・JavaScriptの見直し
・CSSの見直し
・正規表現の見直し
・ページ名/MenuBar 等、階層下専用のMenuBar等を設定できるようにするプラグイン pathmenu.inc.cgiを追加
・pyukiwiki.skin.cgiの変更
・sub encodeが規則通り動作していなかったのを修正
・UTF8メールを送信できるようにした。ただし、MIME::Base64が必要
・検索をすると、検索キーワードをハイライトするように修正
・Nana::Search.pm の追加
・search.inc.pl、search_fuzzy.inc.pl の変更
・title.inc.plの変更
・attach.inc.pl、ref.inc.plの変更 - ファイルサイズ、登録日を読みやすくした。また、マウスをリンクに合わせなくても表示するオプションを追記
・server.inc.plの変更　−　ベンチマーク時間を短縮し、更に短い時間でベンチマークを取得できるようにした。
・location.inc.plの変更
・adminchangepasswordinc.plの変更
・agent.inc.plの追加
・ls2.inc.plのオプション追加
・topicpath.inc.plの変更
・edit.inc.plの変更
・rss10page.inc.plの変更
・rss10.inc.plの変更
・vote.inc.plの仕様変更（従来通り動くモードもあります）
・spam_filterの挙動の追加及び変更（pyukiwiki.ini.cgiに変更があります）
・Digest::MD5、Digest::Perl::MD5を切り替える必要のないように、Nana:MD5を作成した。
・urlhack.inc.cgi 短縮アドレスのwikiページに対応
・twitter.jsの不具合修正
・ごく軽度のXSS脆弱性を修正（凍結ページでのみ起きます）

インストーラの変更点 (0.2)
・update のものを、アップデータの名乗るように変更した。
・インストーラ内で、全ページを凍結できる設定を追加した。
・外部CSS参照していたのを取り込んだ。

-------------------------------------------------
■0.2.0からの主な変更点
-------------------------------------------------
・ライセンスの変更（GPL2からGPL3にバージョンアップ）、Artsticは変更なし
・自分でも把握しきれないぐらいの、多くのバグフィックス
・評価用に、CGIインストーラの作成
・smedia.inc.pl
　ページによって、リンクはきちんとされるものの、リンクが異なることを修正した。
・Nana/Logs/Logs.pm
　負荷が重すぎる為、一時的に、１か月おきだけでなく、１日おきの一覧を出力
　できるようにした。
　アクセスログのキャッシュ化をした。

-------------------------------------------------
■0.1.9からの主な変更点
-------------------------------------------------
・XHTML 1.1 時に、Content-type: application/xhtml+xml で出力
　するようにした。
・UTF8版を追加した。変換する為の管理者用プラグインも作成しましたが、
　非常に重い物となっています。
・管理者向けパスワードを簡易暗号化するようにした。
　ただし、ごくまれに（約1000分の1の確率)で正常に認証できないバグが
　あります。
・ビルド時に、DEVEL版以外のコメントを削除できるようにした。
・ビルド時に、compact版の不要な行を削除できるようにした。
・バックアップ機能を追記した。
・backupプラグインの追加
・titleプラグインの追加
・暫定的にIPV6に対応した。
・PukiWiki互換の凍結方法にした。ただし、info/ ディレクトリは今まで通り
　必要です。
・カウンターファイルをPukiWiki互換にした。
・-DEVEL版以外を可能な限りコンパクトにしてみた。
・wiki文法に [[(url...(gif|png|jpe?g))>link url,説明文]]を加えた
・IEにおいて、ESCキーを押してしまったことにより、入力内容が元に戻ってしまう
　のを阻止した。
・#imgプラグインにおいて、jpg,png,gif以外の画像を表示できるようにした。
・#imgプラグインにおいて、height、widthを指定できるようにした。

-------------------------------------------------
■0.1.8からの主な変更点
-------------------------------------------------
・いくらかのバグフィックス
・#twitterプラグインを追加した。
・Nana::HTTPのHTTPクライアントがまともに動作しない場合があるので、
　別途 HTTP::Lite を用意した。
・表示軽量化、及びほんのごくわずかな節電対策の為の
　gzip圧縮標準化、及び、JavaScript、CSSの圧縮化

-------------------------------------------------
■0.1.7からの主な変更点
-------------------------------------------------
・#article、#comment、#pcommentの本文に日本語文面がなければ
　拒否されるようになりました。
　また、URL文字列が10個以上含まれるものも拒否されるように
　なりました。(両者ともpyukiwiki.ini.cgiで設定可）
・rss10以外の廃止
・jcode.plの廃止（Jcode.pmのみの対応になります）
・InterWikiNameに検索エンジンを追加した
・一部のバグの修正等
・一部のURLリンク切れの修正

-------------------------------------------------
■0.1.5からの主な変更点
-------------------------------------------------
・多くのPukiWiki文法を取り入れました。
　PukiWikiとの互換性がいっそう高くなり、表現力が高くなります。

・wiki.cgi起動と同時に動的に読み込む expluginを搭載しました。
　内部の関数をハック（乗っ取り）し、別の動作をさせることができます。
　(overloadモジュールを使用していません）

・システムメッセージ対応
　スキン(sub skin)に渡される ページ名($page)に、以下のような仕様変更があります。
　ページ名は、タブ区切りで、以下のような内容となります。
　"ページ名(空白のこともあり)" \t "システムメッセージ" \t "エラーメッセージ"

・スキンで、printをせず、変数に格納することとなりました。
　そのため、既存のスキンはそのままではご利用になれません。
　$htmlbody 等の変数に一括して格納し、最後に return する必要があります。

・半角スペースを含むページが作成可能になりました
　ただし、先頭・最後に半角スペースがあるページは作れません

・[[[うぃき]]] のようなブラケットをしたときに出たバグを修正しました。

・部分編集に対応しました。
　巨大なページでも、編集しやすくなりました。

・SEO対策をしました。
　・URLから「?」等を省く、urlhack.inc.cgiプラグインの追加
　・編集画面等では、ロボットがクロールしないようにMETAタグを設定した

・nph CGIに対応しました。
　ファイル名の先頭を nph- にすると、直接HTTP/1.1 200 OK から出力します。

・$::IN_HEAD、$::HTTP_HEADER変数に代入すると、それぞれ、<head>タグ内、
　HTTPヘッダに代入されるようになった。

・xhtmlに対応しました。
　デフォルトでは HTML 4.01 Transitionalで出力されますが、以下を選択することが
　できます。
　・XHTML 1.1
　・XHTML 1.0 Strict (非正式対応)
　・XHTML 1.0 Transitional (非正式対応)
　・XHTML Basic 1.0 (非正式対応)

・_action のリターン値に以下を追加
　・http_header
　・header
　・ispage
　・notviewmenu

・WikiNameを廃止することができるようになりました。

・スキンで表示せず、内部でバッファリングするようにした。

・スキンの最も下のCopyrightのフッタをwiki文法に変更した

・htmlディレクトリとcgi-binディレクトリが異なるシステムで、従来より
　設置しやすくしました。

・リソースを分割して、プラグイン実行時に動的に読み込むようにした

・pagenavi.inc.pl
　PyukiWIki/Download>0.1.6 をそれぞれに、リンクしたい時に
　便利なプラグインです。
　, 区切りで、Wiki文法で入力しますが、 / を含む場合は
　ページ名だけを入力します。
　#pagenavi(*,PyukiWIki/Download>0.1.6,''ダウンロード'') 等

・server.inc.pl
　（wikiで使うようなものではないのですが・・・）
　サーバー情報を詳細に表示するプラグインです。
　実行は、?cmd=server のみで、凍結パスワードが必要になります。

・servererror.inc.pl
　.htaccessでの、ErrorDocumentから呼び出すサーバーエラー表示
　プラグインです。

・sitemap.inc.pl
　以前公開していたものを、バグフィックスして標準化しました

・deletecache.inc.pl
　管理者用プラグインで、キャッシュディレクトリの中身をすべて削除します。

・article.inc.pl
　改行自動変換を実装（変数フラグのみあった）
　名前なし、サブジェクトなし投稿を禁じるフラグをつけた
　ページが凍結されていても投稿できるようにもなった。

・attach.inc.pl
　多くの既存バグを修正
　nph CGIに対応
　アップロードは自由だが、削除はパスワードが必要なモードを加えた

・comment.inc.pl
　ページが凍結されていても投稿できるようにもなった。

・counter.inc.pl
　新形式のカウンターに対応（1年分保存可能です。設定が必要です）
　旧形式のカウンターのバグを自動修正する機能をもたせた
　昨日以前を昨日と認識するバグを修正
　MenuBar等にカウンターを置いた時の処理変更

・edit.inc.pl
　PukiWikiライクな編集画面になるようになった。
　既存ページから、雛形として読み込む機能を追加

・lookup.inc.pl
　InterWikiName正規化に伴い変更
　$::usepopup変数に対応
　nph CGIに対応

・newpage.inc.pl
　ページのprefixを選択できるようになった。

・recent.inc.pl
　半角スペースを含むページに対応

・rss10.inc.pl
　半角スペースを含むページに対応
　nph CGIに対応

・search.inc.pl
　search_fuzzy.inc.pl追加に伴う変更

・search_fuzzy.inc.pl
　日本語あいまい検索用です。
　モジュールをuseしているので別のモジュールになっています。直接呼出しはできません

・showrss.inc.pl
　PyukiWikiのRSSが正しく取得できなかったのを修正

・ref.inc.pl
　いくつかのバグを修正
　$::usepopup変数に対応

・その他プラグイン
　いくつかの、PukiWiki内部制御用のコマンドを、ダミープラグインとして
　実装しています。

・サンプル
　CGIを外部から呼び出せない等の理由で、外部からInterWikiできないwikiのために、
　PHPやHTML+JavaScriptのwrapperをサンプルとして添付しました。

-------------------------------------------------
■使用しているライブラリ等
-------------------------------------------------

・YukiWikiDB関連　結城浩氏、極悪氏
　http://www.hyuki.com/yukiwiki/wiki.cgi?YukiWikiDB2
　http://www.hyuki.com/yukiwiki/wiki.cgi?YukiWikiDB%a4%ce%a5%ed%a5%c3%a5%af%b5%a1%c7%bd
　http://www.hyuki.com/yukiwiki/wiki.cgi?YukiWikiLock

・RSS.pm、Difftext.pm
　http://www.hyuki.com/yukiwiki/

・Algorithm::Diff
　http://search.cpan.org/~tyemq/

・File::MMagic
　http://search.cpan.org/~knok/
　なお、MMagic.pm内臓のmagicデータは、データ判別においての材料が不足している為
　削除してあります。

・Time::Local
　http://search.cpan.org/~drolsky/

・Digest::Perl::MD5
　http://search.cpan.org/~delta/

・Jcode.pm
　http://openlab.jp/Jcode/index-j.html
　http://search.cpan.org/~dankogai/

・IDNA::Punycode
　http://search.cpan.org/~roburban/

・迷惑メール収集業者対策＠Toshi (NINJA104)
　http://ninja.index.ne.jp/~toshi/soft/untispam.shtml

・ppblog
　http://p2b.jp/
　多くの有用なJavaScriptを利用させて頂いています。

　・FireFoxのツールチップ改造＠martin
　　http://martin.p2b.jp/index.php?date=20050201
　・ブラウザ内での画像ポップアップ
　　http://martin.p2b.jp/index.php?UID=1115484023

・Perlメモより＠大崎 博基氏
　http://www.din.or.jp/~ohzaki/perl.htm
　http://www.din.or.jp/~ohzaki/regex.htm
　・URL及びメールアドレスの正規表現
　・年月日から曜日を取得する
　・年月から末日を取得する
　・第Ｎ　Ｗ曜日ｎ日付を求める
　・EUC文字関係の処理
　・リネームロック
　・改行コードを統一する
　・その他

・twitter取得用JavaScript
　http://twitstat.us/
　オリジナルソースは http://twitstat.us/twitstat.js

・jQuery
　http://jquery.com/

・jqModal (instag.jsに結合済)
　http://dev.iceburg.net/jquery/jqModal/

・Farbtastic Color Picker
　http://acko.net/blog/farbtastic-jquery-color-picker-plug-in/

・AWStats（アクセスログ解析）
　http://awstats.sf.net/
　http://www.starplatinum.jp/awstats/awstats70/
　特に、テーブル定義は、そのまま使用させて頂きました。

-------------------------------------------------
■謝辞
-------------------------------------------------
・本家のWikiを作ったWard Cunninghamに感謝します。
　http://c2.com/cgi/wiki

・PyukiWikiを楽しんで使ってくださるみなさんに感謝します。

・PukiWiki、YukiWiki等多くのWikiクローンの作者さんたちに感謝します。

・YukiWiki
　http://www.hyuki.com/yukiwiki/
　PyukiWikiのベースとして、YukiWikiはなくてはならないものでした。

・PukiWiki (PHP)
　http://pukiwiki.sourceforge.jp/
　デザインをはじめ、多くの書式等を参考にしました。

・PukiWiki Plus! (PHP)
　http://pukiwiki.cafelounge.net/plus/
　国際化の実装方法のアイデア、国アイコンの公開に感謝します。

・「極悪」さんのwiki (Perl)
　http://hpcgi1.nifty.com/dune/gwiki.pl
　特に、YukiWikiDBに感謝します。

・塚本牧生さんのWalWiki (Perl)
　http://digit.que.ne.jp/work/
　テーブル機能、部分編集機能に感謝します。

・その他、パッチを提供して頂いた以下の方に感謝します。
　Mr koizumi, wadldw, pochi

-------------------------------------------------
■作者
-------------------------------------------------
Copyright (C) 2004-2012 by Nekyo
http://nekyo.qp.land.to/

Copyright (C) 2002-2007 by Hiroshi Yuki
http://www.hyuki.com/

Copyright (C) 2005-2012 by ななみ (ななこっち★)
http://nanakochi.daiba.cx/ http://www.daiba.cx/ http://chat.daiba.cx/
http://pyu.be/
http://twitter.com/nanakochi123456/
http://ja.wikipedia.org/wiki/%e5%88%a9%e7%94%a8%e8%80%85%3aPapu

Copyright (C) 2004-2007 by やしがにもどき
http://hpcgi1.nifty.com/it2f/wikinger/pyukiwiki.cgi
（リンク切れ）

Copyright (C) 2005-2007 by Junichi
http://www.re-birth.com/
（コンテンツなし）

Copyright (C) 2005-2012 PukiWiki Developers Team
http://pyukiwiki.sfjp.jp/
