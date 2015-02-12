######################################################################
# pyukiwiki.ini.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: pyukiwiki.ini.cgi,v 1.310 2012/03/01 10:39:23 papu Exp $
#
# "PyukiWiki" version 0.2.0-p2 $$
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

use strict;

# 言語
$::lang = "ja";				# ja:日本語/en:英語(参考)
$::kanjicode = "utf8";		# utf8 only
$::charset = "utf-8";		# utf-8 only

# 言語コード変換			# Jcode Only!!
$::code_method{ja}="Jcode";	# ja : Jcode

# データ格納ディレクトリ
$::data_home = '.';		# CGIからのみアクセスするデータのディレクトリ
$::data_pub = '.';		# ブラウザから見れるデータのディレクトリ
$::data_url = '.';		# ブラウザからの絶対・相対ディレクトリ
$::bin_home = '.';		# 通常は変更しないで下さい

# cgi-binが別のディレクトリの例
# for sourceforge.jp
# /home/groups/p/py/pyukiwiki/htdocs
# /home/groups/p/py/pyukiwiki/cgi-bin
#$::data_home = '.';
#$::data_pub = '../htdocs';
#$::data_url = '..';

# Windows NT Server (IIS+ActivePerl)の場合の例
#$::data_home = 'C:/inetpub/cgi-bin/pyuki/';
#$::data_pub = 'C:/inetpub/cgi-bin/pyuki/';
#$::data_url = '.';

$::data_dir    = "$::data_home/wiki";		# ページデータ保存用
$::backup_dir  = "$::data_home/backup";		# バックアップ保存用#nocompact
$::diff_dir    = "$::data_home/diff";		# 差分保存用
$::cache_dir   = "$::data_pub/cache";		# 一時用
$::cache_url   = "$::data_url/cache";		# 一時用
$::upload_dir  = "$::data_pub/attach";		# 添付用
$::upload_url  = "$::data_url/attach";		# 添付用URL
$::counter_dir = "$::data_home/counter";	# カウンタ用
$::plugin_dir  = "$::data_home/plugin";		# プラグイン用
$::explugin_dir= "$::bin_home/lib";			# プラグイン用
$::skin_dir    = "$::data_pub/skin";		# スキン用
$::skin_url    = "$::data_url/skin";		# スキン用URL
$::image_dir   = "$::data_pub/image";		# 画像用
$::image_url   = "$::data_url/image";		# 画像用URL
$::info_dir    = "$::data_home/info";		# 情報用
$::res_dir     = "$::data_home/resource";	# リソース
$::sys_dir	   = $::explugin_dir;			# システム用

# スキン名称
$::skin_name   = "pyukiwiki";
$::use_blosxom=0;	# blosxom.cssを使用するとき１にする

# 動的セットアップファイル
# pyukiwiki.ini.cgiの変更部分のみをsetup.ini.cgiに記載することで、
# 今後のアップデートが容易になります。
$::setup_file	= "$::info_dir/setup.ini.cgi" if($::setup_file eq '');

# プロキシ設定
#$::proxy_host = '';
#$::proxy_port = 3128;

# wiki、修正者情報 (各変数の言語名の連想配列にすると、言語別にできます）
$::wiki_title = '';										# サイト名（なくても可）
#$::wiki_title{en}='';									# 英語時のタイトル(sample)
$::modifier = 'anonymous';								# 修正者名
$::modifierlink = '';									# 修正者URI
$::modifier_mail = '';									# 修正者メールアドレス
$::meta_keyword="$::wiki_title";						# 検索キーワード

# 1:タイトルの親階層を省略する, 0:省略しない
$::short_title=0;

# ロゴ
$::logo_url="$::image_url/pyukiwiki.png";				# URL
$::logo_width=80;										# 横幅
$::logo_height=80;										# 高さ
$::logo_alt="[PyukiWiki]";								# ロゴの代替文字

# スクリプト名
# servererror、urlhackプラグインを使用する場合は、自動取得ではなく
# $::scriptを必ず指定して下さい。
#$::script			= 'index.cgi';
$::script			= '';								# 自動取得

# 基準URL
#$::basehref		= 'http://hogehoge/path/index.cgi';	# 自動取得
$::basehref			= '';

# 基準パス (cookie用)
#$::basepath		= '/path';							# 自動取得
$::basepath			= '';

# デフォルトページ名
$::FrontPage		= 'FrontPage';
$::RecentChanges	= 'RecentChanges';
$::MenuBar			= 'MenuBar';
$::SideBar			= ':SideBar';
$::TitleHeader		= ':TitleHeader';
$::Header			= ':Header';
$::Footer			= ':Footer';
$::BodyHeader		= ':BodyHeader';
$::BodyFooter		= ':BodyFooter';
$::SkinFooter		= ':SkinFooter';					# PyukiWikiの
														# (c)に載せる

$::InterWikiName	= 'InterWikiName';
$::ErrorPage		= "ErrorPage";
$::AdminPage		= "AdminPage";
$::IndexPage		= "IndexPage";
$::SearchPage		= "SearchPage";
$::CreatePage		= "CreatePage";

# 管理者パスワード (全共通パスワード）
$::adminpass = crypt("pass", "AA");

# パスワードを別にする場合
#（全共通パスワードでも認証します。全共通を使用しない場合推測困難なパスを入力）
#$::adminpass = 'aetipaesgyaigygoqyiwgorygaeta';# デフォルトを使用時用デコード不能パス
#$::adminpass{admin} = crypt("admin","AA");		# 管理者用パスワード、全共通
#$::adminpass{frozen} = crypt("frozen","AA");	# 凍結用パスワード
#$::adminpass{attach} = crypt("attach","AA");	# 添付用パスワード

# パスワードを簡易暗号化して送信する。
$::Use_CryptPass=1;

# 言語リスト
#$::lang_list="ja en cn";

# RSS設定
$::rss_lines=15;								# RSS出力行数
$::rss_description_line=1;						# descriptionの行数を指定
												# 1と2以上では動作が異なる


# RSS情報 (各変数の言語名の連想配列にすると、言語別にできます）
$::modifier_rss_title=$::wiki_title;			# RSS表題
$::modifier_rss_link='';						# RSSリンク先（自動取得）
$::modifier_rss_description = "Modified by $::modifier";	# RSSの説明

#$::modifier_rss_title = "PyukiWiki $::version";
#$::modifier_rss_link = 'http://pyukiwiki.sfjp.jp/';
#$::modifier_rss_description = 'This is PyukiWiki.';

# Exプラグイン設定
$::useExPlugin = 1;		# expluginを 1:使う/0:使わない

# HTML出力モード
$::htmlmode="html4";	# html4        : //W3C//HTML 4.01 Transitional
						# xhtml10      : //W3C//XHTML 1.0 Strict
						# xhtml10t     : //W3C//XHTML 1.0 Transitional
						# xhtml11      : //W3C//XHTML 1.1
						# xhtmlbasic10 : //W3C//DTD XHTML Basic 1.0

# バックアップの使用#nocompact
$::useBackUp=1;#nocompact

# 表示設定
$::usefacemark = 1;		# フェースマークを 1:使う/0:使わない。
$::use_popup = 1;   	# リンク先を
						# 0:普通にリンクする
						# 1:ポップアップ (target=_blank)
						# 2:HTTP_HOSTを比較して、同一なら普通に
						# 3:$basehrefを比較して同一なら普通に
						# (wiki以下のページのみ、動作しないサーバーもあります)
						# (閲覧者がcookieで0/1-3相当を選択可)
$::line_break = 0;		# wiki文書をデフォルトで改行させる場合 1
						# (0の場合、&br;か~で明示的に改行させる必要があります。デフォルト)
$::last_modified = 2;	# 最終更新日 0:非表示/1:上に表示/2:下に表示
$::lastmod_prompt = 'Last-modified:'; # 最終更新日のプロンプト
$::allview = 1;			# 1:すべての画面でHeader, MenuBar, Footerを表示する, 0:しない

$::notesview = 0;		# 注釈を 0:$bodyの下に表示 ,1:footerの上に表示, 2:footerの下に表示
$::enable_convtime = 1;	# コンバートタイム 1:表示/0:非表示(perlversionも表示されます)

$::diff_disable_email = 1;# diffプラグインにおいてメールアドレスを隠す。#compact
$::diff_disable_email = 1;# diff及びバックアッププラグインにおいてメールアドレスを隠す。#nocompact
$::backup_disable_email = 1;# バックアッププラグインのソース表示にてメールアドレスを隠す。#nocompact

# 日時フォーマット
$::date_format = 'Y-m-d'; 			# replace &date; to this format.
$::time_format = 'H:i:s'; 			# replace &time; to this format,
$::now_format="Y-m-d(lL) H:i:s";	# replace &now; to this format.
$::lastmod_format="Y-m-d(lL) H:i:s";# lastmod format
$::recent_format="Y-m-d(lL) H:i:s";	# RecentChanges(?cmd=recent) format
$::backup_format="Y-m-d(lL) H:i:s"; # backup list format#nocompact
$::attach_format="Y-m-d(lL) H:i:s";	# attach info
$::ref_format="Y-m-d(lL) H:i:s";	# ref info

#$::lastmod_format="y年n月j日(lL) ALg時k分S秒";	# 日本語表示の例

	# 年  :Y:西暦(4桁)/y:西暦(2桁)
	# 月  :n:1-12/m:01-12/M:Jan-Dec/F:January-December
	# 日  :j:1-31/J:01-31
	# 曜日:l:Sunday-Saturday/D:Sun-Sat/DL:日曜日-土曜日/lL:日-土
	# ampm:a:am or pm/A:AM or PM/AL:午前 or 午後
	# 時  : g:1-12/G:0-23/h:01-12/H/00-23
	# 分  : k:0-59/i:00-59
	# 秒  : S:0-59/s:00-59
	# O   : グリニッジとの時間差
	# r RFC 822 フォーマットされた日付 例: Thu, 21 Dec 2000 16:01:07 +0200
	# Z タイムゾーンのオフセット秒数。 -43200 から 43200
	# L 閏年であるかどうかを表す論理値。 1なら閏年。0なら閏年ではない。
	# lL:現在のロケールの言語での曜日（短）
	# DL:現在のロケールの言語での曜日（長）
	# aL:現在のロケールの言語での午前午後（大文字）
	# AL:現在のロケールの言語での午前午後（小文字）
	# t 指定した月の日数。 28 から 31
	# B Swatch インターネット時間 000 から 999
	# U Unix 時(1970年1月1日0時0分0秒)からの秒数 See also time()

# ページ編集
$::cols = 80;			# テキストエリアのカラム数
$::rows = 25;			# テキストエリアの行数
$::extend_edit = 1;		# 拡張機能(JavaScript) 1:使用/0:未使用
$::pukilike_edit = 3;	# PukiWikiライクの編集画面
						# 0:Pyukiwiki/1:PukiWiki/2:PukiWiki+雛形読み込み機能
						# 3:PukiWiki+新規作成のみ雛形読み込み機能
$::edit_afterpreview=1;	# プレビューを 0:編集画面の上 1:編集画面の下
$::new_refer='[[$1]]';	# 新規作成の場合、関連ページのリンクを初期値として表示
#$::new_refer='';			# 空文字にすると表示されません
$::new_dirnavi=1;		# 新規ページ作成画面で、どのページの下層に来るか
						# 選択できるようにする 1:使用/0:未使用
$::write_location=1;	# ページ編集後、locationで移動する
						# 無効でも二重書き込みにはなりませんが、誤ってリロードボタンを
						# 押したときのブラウザーの警告を阻止できます。
						# 無料サーバー系では、0にしないと動作しません。
$::partedit=1;			# 部分編集を0:使わない 1:使う 2:凍結ページも 3:
$::partfirstblock=0;	# 1:最初の見出しより前の部分を1番目の見出しとみなして編集できるようにする
$::usePukiWikiStyle=1;	# PukiWIki書式を 0:使わない 1:使う
$::writefrozenplugin=1;	# 掲示板等、凍結されているページでもプラグインから書き込めるようにする。
						# 0:不可 1:可
$::newpage_auth=0;		# 新規ページ作成で 0:誰でもできる, 1:凍結パスワードが必要
						# ただしプラグインから生成される新規ページには適用しません
$::use_escapeoff=2;		# IEにおいて、誤ってESCキーを押して、入力した内容が消失
						# するのを阻止する。
						# 2 にすると、setting.inc.cgi でデフォルトで有効になる。

$::setting_savename=0;	# setting.inc.cgi にて、掲示板等の名前の保存を、1 で
						# デフォルトで有効にする。setting.inc.cgi有効時のみ機能

# 自動リンク
$::nowikiname = 0;		# 0:WikiNameを自動リンク 1:明示的に [[ ]] が必要
$::autourllink = 1;		# URLの自動リンク ([[ ]] で明示的に指定されたものはのぞく)
$::automaillink = 1;	# メールアドレスの自動リンク ([[ ]] で明示的に指定されたものはのぞく)
$::useFileScheme=0;		# 0:通常, 1:file:// のスキーマを有効にする（イントラネット向け）
$::IntraMailAddr = 0;	# 1:イントラネット向けのドメインなしメールアドレスを有効
$::use_autoimg = 1;		# URLが画像であれば、無条件に imgタグを張る

# クッキー
$::cookie_expire=3*30*86400;	# 保存cookieの有効期限(3ヶ月)
$::cookie_refresh=86400;		# 保存cookieのリフレッシュ間隔(１日)


# アクセスカウンター
$::CounterVersion=1;	# 1:今日と昨日のみ保存、2:↓日数分保存
$::CounterDates=365;	# 保存する日数(14〜1000)
$::CounterHostCheck=1;	# 1:カウンターのリモートホストをチェック/0:リロードでもカウントする

# 添付
$::file_uploads = 2;		# 添付を 0:使わない/1:使う/2:認証付き/3:削除のみ認証付
$::max_filesize = 1000000;	# アップロードファイルの容量
$::AttachFileCheck=1;		# 添付ファイルの内容監査を 0:拡張子のみ/1:内容監査もする
							# 0の場合、セキュリティー上の問題になるので
							# 信頼できるイントラ(local)ネット以外では使用しないで下さい。
$::AttachCounter=0;			# 添付ファイルのカウントをするだけ(1)、表示もする(2)

# ヘルプ
$::use_HelpPlugin=1;	# ヘルプをプラグインで実行する（ナビゲータが変化します）
						# ヘルプページを編集する場合は
						# ?cmd=adminedit&mypage=%a5%d8%a5%eb%a5%d7 で
						# UTF-8版であれば
						# ?cmd=adminedit&mypage=?%e3%83%98%e3%83%ab%e3%83%97 で

$::no_HelpLink=0;		# ヘルプのリンクを表示しない。
						# (共同編集しないページで有効です）

# 検索
$::use_FuzzySearch=1;	# 0:通常検索/1:日本語あいまい検索を使用する
$::use_Highlight=1;		# 1:検索時、強調表示をする。#nocompact

# サイトマップ
$::use_SiteMap=0;		# 0:Listのみ/1:List,サイトマップ両方

# ナビゲータの配列
$::naviindex=1;			# 0:リロード〜 / 1:トップ〜

# ページ名の下のtopicpathの使用
$::useTopicPath=1;		# 0:使用しない / 1:使用する
						# ページからのプラグイン呼び出しには影響されません

# セパレータ			# 階層指定用
$::separator='/';

# ドット
$::dot='.';

# 下の画像ツールバー
$::toolbar=2;			# 0:表示しない 1:RSS等のみ 2:すべて表示（部分編集のアイコンも）

# 閲覧者環境設定機能を使う
$::use_Setting=1;

# スキンセレクタを使う
$::use_SkinSel=1;

$::_symbol_anchor = '&dagger;';
$::maxrecent = 50;

# 一覧・更新一覧に含めないページ名(正規表現で)
$::non_list = qq((^\:|$::separator\:));
#$::non_list = qq((^\:));
#$::non_list = qq((^\:|$::MenuBar\$)); # example of MenuBar

# 添付ファイルの全ページの一覧を上記正規表現で指定したページを除く
$::attach_nonlist = 1;

# gzip パスを強制的に指定する。
# 指定しない場合は、gzipパスを自動検索し、
# それでもなければ、Compress::Zlib を使用します。
#$::gzip_path = '/bin/gzip -1';			# fast
#$::gzip_path = '/usr/bin/gzip -1 -f';	# fast
#$::gzip_path = '/bin/gzip -9';			# max compress
#$::gzip_path = '/usr/bin/gzip -9 -f';	# max compress
#$::gzip_path = 'nouse';				# 使用しない場合
										# 動かない場合コメントアウト

# sendmailパスの指定 $::modifier_mail宛てにメール通知
$::modifier_sendmail=<<EOM;
/usr/sbin/sendmail -t
/usr/bin/sendmail -t
/usr/lib/sendmail -t
/var/qmail/bin/sendmail -t
EOM

# Wiki更新通知を管理人に知らせる場合 1
$::sendmail_to_admin = 0;

# UTF-8メールの送信  MIME::Base64が必要
$::send_utf8_mail=0;

# P3Pのコンパクトポリシー http://fs.pics.enc.or.jp/p3pwiz/p3p_ja.html
# 必要であれば /w3c以下ディレクトリにも適切にファイルを設置し、有効にします
#$::P3P="NON DSP COR CURa ADMa DEVa IVAa IVDa OUR SAMa PUBa IND ONL UNI COM NAV INT CNT STA";

# ナビゲータにリンクを追加するサンプル
#push(@::addnavi,"link:help");		# helpの前に追加
##push(@::addnavi,"link::help");	# helpの後ろに追加
#$::navi{"link_title"}="リンク集";
#$::navi{"link_url"}="$::script?%a5%ea%a5%f3%a5%af";	# page of 'リンク'
#$::navi{"link_name"}="リンク集";
#$::navi{"link_type"}="page";
#$::navi{"link_height"}=14;
#$::navi{"link_width"}=16;

# フィルター関連
$::filter_flg = 1;					# 1でフィルター機能を有効にする。
$::chk_uri_count = 10;				# 旧オプション
$::chk_wiki_uri_count = 10;			# 編集画面でホームページアドレスが
									# 10個以上になるとスパムとみなす。
$::chk_article_uri_count = 1;		# 掲示板等でホームページアドレスが
									# １つ（個数）でもあるとスパムとみなす。
$::chk_article_mail_count = 1;		# 掲示板等でメールアドレスが
									# １つ（個数）でもあるとスパムとみなす。
$::chk_write_jp_only = 0;			# 編集画面で日本語が一字も入ってないと
									# スパムとみなす。
									# なお、デフォルトはプラグインだけや
									# ソースファイルや英語等のページを作れる
									# ようにOFFにしてある。
$::chk_jp_only = 1;					# 掲示板、コメント等に日本語が一字も
									# 入っていないとスパムとみなす。
$::deny_log = "$::cache_dir/deny.log";
									# ログファイル。
									# 指定されているとログを取る。
									# 無くても問題ない。

$::black_log = "$::cache_dir/black.lst";
									# フィルターフラグが付いているときの
									# ログ出力先

# タイムゾーン設定

$::TZ='';							# 自動取得
#$::TZ='9';							# こちらのが処理はやいかも？（日本用）

# 書き込み禁止キーワード
$::disablewords=<<EOM;
example.com
EOM

1;

__END__
=head1 NAME

pyukiwiki.ini.cgi - This is pyukiwiki setting file

=head1 DESCRIPTION

This file is a configuration file of PyukiWiki.
Please carry out a suitable setup before setting up CGI.

=cut

