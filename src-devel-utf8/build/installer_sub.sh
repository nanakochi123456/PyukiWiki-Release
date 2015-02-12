#!/bin/sh
CMD=$1
MYCMD=$2
disable='disabled="disabled"'
buttonstyle='style="width:150px;"'
checked='checked="checked"'
DOCTYPE='<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
HEADJA='<html><head><title>PyukiWikiインストーラ</title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><link rel="stylesheet" href="http://pyukiwiki.sourceforge.jp/skin/pyukiwiki.default.css" type="text/css" media="screen" charset="EUC-JP"></head>'
HEADEN='<html><head><title>PyukiWiki Installer</title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><link rel="stylesheet" href="http://pyukiwiki.sourceforge.jp/skin/pyukiwiki.default.css" type="text/css" media="screen" charset="EUC-JP"></head>'
FOOTJA='<hr><div id="footer"><strong><a href="http://pyukiwiki.sfjp.jp/" class="link" title="PyukiWiki 0.2.0-p1">PyukiWiki 0.2.0-p1</a></strong>Copyright&copy; 2004-2012 by <a href="http://nekyo.qp.land.to/" class="link" title="Nekyo">Nekyo</a>, <a href="http://pyukiwiki.sfjp.jp/" class="link" title="PyukiWiki Developers Team">PyukiWiki Developers Team</a>License is <a href="http://sfjp.jp/projects/opensource/wiki/GPLv3_Info" class="link" title="GPL">GPL</a>, <a href="http://www.opensource.jp/artistic/ja/Artistic-ja.html" class="link" title="Artistic">Artistic</a><br>Based on &quot;<a href="http://www.hyuki.com/yukiwiki/" class="link" title="YukiWiki">YukiWiki</a>&quot; 2.1.0 by <a href="http://www.hyuki.com/" class="link" title="yuki">yuki</a>and <a href="http://pukiwiki.sfjp.jp/" class="link" title="PukiWiki">PukiWiki</a> by <a href="http://pukiwiki.sfjp.jp/" class="link" title="PukiWiki Developers Term">PukiWiki Developers Term</a><br><a href="http://pyukiwiki.sfjp.jp/" class="link" title="PyukiWiki Installer version $INSTALLERVER"PyukiWiki Installer version $INSTALLERVER</a></div></div></div></body></html>'
FOOTEN='<hr><div id="footer"><strong><a href="http://pyukiwiki.sfjp.jp/" class="link" title="PyukiWiki Installer 0.2.0-p1">PyukiWiki Installer 0.2.0-p1</a></strong>Copyright&copy; 2004-2012 by <a href="http://nekyo.qp.land.to/" class="link" title="Nekyo">Nekyo</a>, <a href="http://pyukiwiki.sfjp.jp/" class="link" title="PyukiWiki Developers Team">PyukiWiki Developers Team</a>License is <a href="http://www.gnu.org/licenses/gpl.html" class="link" title="GPL">GPL</a>, <a href="http://www.perl.com/language/misc/Artistic.html" class="link" title="Artistic">Artistic</a><br>Based on &quot;<a href="http://www.hyuki.com/yukiwiki/" class="link" title="YukiWiki">YukiWiki</a>&quot; 2.1.0 by <a href="http://www.hyuki.com/" class="link" title="yuki">yuki</a>and <a href="http://pukiwiki.sfjp.jp/" class="link" title="PukiWiki">PukiWiki</a> by <a href="http://pukiwiki.sfjp.jp/" class="link" title="PukiWiki Developers Term">PukiWiki Developers Term</a><br><a href="http://pyukiwiki.sfjp.jp/" class="link" title="PyukiWiki Installer version $INSTALLERVER"PyukiWiki Installer version $INSTALLERVER</a></div></div></div></body></html>'

getversion() {
	# pyukiwiki
	if [ -f $F ]; then
		V=`grep \$::version $F`
		OLDVERSION=""
		if [ "$V" != "" ]; then
			OLDVERSION=`perl -e '$V;print \$::version;'`
			OLDVERSION="PyukiWiki version $OLDVERSION"
		else
			# pukiwiki
			V=`grep S_VERSION $F`
			if [ "$V" != "" ]; then
				OLDVERSION=`echo $V|sed -e 's/.*S_VERSION//g'|sed -e "s/'//g"|sed -e "s/,//g"|sed -e "s/ //g"|sed -e "s/\(//g"|sed -e "s/\)//g|sed -e "s/;//g""`
				OLDVERSION="PukiWiki version $OLDVERSION"
			fi
		fi
	fi
}

updatecheck() {
	UPDATEFLAG=0
	if [ "`ls index.cgi 2>/dev/null``ls nph-index.cgi 2>/dev/null``ls index.php 2>/dev/null`" == "" ]; then
		F=lib/wiki.cgi
		getversion
		UPDATEFLAG=3
		if [ "$OLDVERSION" != "" ]; then
			F=index.cgi
			getversion
			UPDATEFLAG=2
		fi
		if [ "$OLDVERSION" != "" ]; then
			F=lib/init.php
			getversion
			UPDATEFLAG=1
		fi
		if [ "$OLDVERSION" != "" ]; then
			OLDVERSION="Other script"
			UPDATEFLAG=-1
		fi
	fi
}

if [ "$CMD" = "cgistart" ]; then
	if [ "`echo $HTTP_ACCEPT_LANGUAGE | grep ja`" != "" ]; then
		echo $DOCTYPE
		echo $HEADJA
		cat <<EOF
<body><h2>PyukiWikiインストーラ</h2>
<table>
<tr><td colspan="2">
PyukiWikiをインストールします。<br>
「次へ」を押して下さい。
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<input type="submit" name="dummy" value="戻る" $buttonstyle $disable>
<input type="submit" name="step1" value="次へ" $buttonstyle>
<input type="submit" name="cancel" value="キャンセル" $buttonstyle $disable>
</form></div>
</td></tr>
</table>
EOF
	echo $FOOTJA
	else
	echo $DOCTYPE
	echo $HEADEN
		cat <<EOF
<body><h2>PyukiWiki Installer</h2>
<table>
<tr><td colspan="2">
Install PyukiWiki.<br>
Press "Next"
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<input type="submit" name="dummy" value="Back" $buttonstyle $disable>
<input type="submit" name="step1" value="Next" $buttonstyle>
<input type="submit" name="cancel" value="Cancel" $buttonstyle $disable>
</form></div>
</td></tr>
</table>
EOF
	echo $FOOTEN
	fi
fi

if [ "$CMD" = "gpl" ]; then
	if [ "`echo $HTTP_ACCEPT_LANGUAGE | grep ja`" != "" ]; then
		echo $DOCTYPE
		echo $HEADJA
		cat <<EOF
<body><h2>PyukiWikiインストーラ</h2>
<table>
<tr><td colspan="2">
<iframe src="$SCRIPT_NAME?license_gpl_ja" width="800" height="300"></iframe>
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<input type="submit" name="dummy" value="戻る" $buttonstyle>
<input type="submit" name="step2" value="同意する" $buttonstyle>
<input type="submit" name="cancel" value="同意しない" $buttonstyle>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTJA
	else
		echo $DOCTYPE
		echo $HEADEN
		cat <<EOF
<body><h2>PyukiWiki Installer</h2>
<table>
<tr><td colspan="2">
<iframe src="$SCRIPT_NAME?license_gpl_en" width="800" height="300"></iframe>
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<input type="submit" name="dummy" value="Back" $buttonstyle>
<input type="submit" name="step2" value="Agreement" $buttonstyle>
<input type="submit" name="cancel" value="Disagree" $buttonstyle>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTEN
	fi
fi

if [ "$CMD" = "art" ]; then
	if [ "`echo $HTTP_ACCEPT_LANGUAGE | grep ja`" != "" ]; then
		echo $DOCTYPE
		echo $HEADJA
		cat <<EOF
<body><h2>PyukiWikiインストーラ</h2>
<table>
<tr><td colspan="2">
<iframe src="$SCRIPT_NAME?license_art_ja" width="800" height="300"></iframe>
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<input type="submit" name="step1" value="戻る" $buttonstyle>
<input type="submit" name="step3" value="同意する" $buttonstyle>
<input type="submit" name="cancel" value="キャンセル" $buttonstyle>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTJA
	else
		echo $DOCTYPE
		echo $HEADEN
		cat <<EOF
<body><h2>PyukiWiki Installer</h2>
<table>
<tr><td colspan="2">
<iframe src="$SCRIPT_NAME?license_art_en" width="800" height="300"></iframe>
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<input type="submit" name="step1" value="Back" $buttonstyle>
<input type="submit" name="step3" value="Agreement" $buttonstyle>
<input type="submit" name="cancel" value="Disagree" $buttonstyle>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTEN
	fi
fi

if [ "$CMD" = "license" ]; then
	cat $QUERY_STRING.html
	exit
fi

if [ "$CMD" = "cgititle" ]; then
	UPDATEHTML=""
	if [ "`echo $HTTP_ACCEPT_LANGUAGE | grep ja`" != "" ]; then
		echo $DOCTYPE
		echo $HEADJA
		cat <<EOF
<body><h2>PyukiWikiインストーラ</h2>
<table>
<tr><td colspan="2">
PyukiWikiのインストールの準備は完了しました。<br>
以下のオプションを選択して下さい。<br>
次へをクリックすると、インストールを開始します。<br>
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<table>
<tr><td>インストールモード</td><td>
<input type="radio" name="installmode" value="normal" $checked>通常インストール
<input type="radio" name="installmode" value="secure">セキュアインストール（パーミッションを厳格に設定します。）
</td></tr>
<tr><td>.htaccessファイル</td><td>
<input type="radio" name="htaccess" value="htaccesson" $checked>設置する
<input type="radio" name="htaccess" value="htaccessoff">削除する
</td></tr>
<tr><td>gzip圧縮転送</td><td>
<input type="radio" name="gzip" value="gzipoff">無効
<input type="radio" name="gzip" value="gzipon" $checked>有効
</td></tr>
<tr><td>インストールするパス:</td>
<td>$PWD</td></tr>
<tr><td>インストールするPyukiWikiのバージョン:</td>
<td>$VER$BUILD ($CODE)$UPDATEHTML</td></tr>
<tr><td>解凍コマンド:</td>
<td>$TXTCMD $ARCCMD $TARCMD</td></tr>
</table>
<input type="submit" name="step3" value="戻る" $buttonstyle>
<input type="submit" name="install" value="次へ" $buttonstyle>
<input type="submit" name="cancel" value="キャンセル" $buttonstyle>
</form></div>
<hr>
</td></tr>
</table>
EOF
		echo $FOOTJA
	else
		echo $DOCTYPE
		echo $HEADEN
		cat <<EOF
<body><h2>PyukiWikiインストーラ</h2>
<table>
<tr><td colspan="2">
Complete of preparing for the installation of PyukiWiki<br>
Please select the options.<br>
Press Next, installation complete.
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<table>
<tr><td>Install Modeインストールモード</td><td>
<input type="radio" name="installmode" value="normal" $checked>Default Install
<input type="radio" name="installmode" value="secure">Secure Install (Setting strict file and permissions.)
</td></tr>
<tr><td>.htaccess File</td><td>
<input type="radio" name="htaccess" value="htaccesson" $checked>Install
<input type="radio" name="htaccess" value="htaccessoff">Delete
</td></tr>
<tr><td>gzip compress transfer</td><td>
<input type="radio" name="gzip" value="gzipoff">Disable
<input type="radio" name="gzip" value="gzipon" $checked>Enable
</td></tr>
<tr><td>Target Path:</td>
<td>$PWD</td></tr>
<tr><td>PyukiWiki Version:</td>
<td>$VER$BUILD ($CODE)$UPDATEHTML</td></tr>
<tr><td>Extract comomand:</td>
<td>$TXTCMD $ARCCMD $TARCMD</td></tr>
</table>
<input type="submit" name="step3" value="Back" $buttonstyle>
<input type="submit" name="install" value="Next" $buttonstyle>
<input type="submit" name="cancel" value="Cancel" $buttonstyle>
</form></div>
<hr>
</td></tr>
</table>
EOF
		echo $FOOTEN
	fi
fi

if [ "$CMD" = "setperl" ]; then
	PERL=`which perl`
	if [ "`echo $PERL`" != "" ]; then
		echo \#\!$PERL>index.cgi.tmp
		cat index.cgi>>index.cgi.tmp
		cp index.cgi.tmp index.cgi
		rm index.cgi.tmp
	fi
fi

if [ "$CMD" = "securechmod" ]; then
	chmod 700 backup cache counter diff info wiki session user 2>/dev/null
	chmod 700 backup.* cache.* counter.* diff.* info.*  wiki.* 2>/dev/null
	chmod 700 lib plugin release resource sample 2>/dev/null
	chmod 701 attach image skin 2>/dev/null
	chmod 701 attach.* skin.* 2>/dev/null
	chmod 701 index.cgi 2>/dev/null
	chmod 700 pyukiwiki.ini.cgi 2>/dev/null
fi

if [ "$CMD" = "chmod" ]; then
	chmod 755 backup cache counter diff info wiki session user 2>/dev/null
	chmod 755 backup.* cache.* counter.* diff.* info.*  wiki.* 2>/dev/null
	chmod 755 lib plugin release resource sample 2>/dev/null
	chmod 755 attach image skin 2>/dev/null
	chmod 755 attach.* skin.* 2>/dev/null
	chmod 755 index.cgi 2>/dev/null
	chmod 755 pyukiwiki.ini.cgi 2>/dev/null
fi

if [ "$CMD" = "extract" ]; then
	cp $I $I.$TXTEXT
	rm $I
	if [ "$TXTCMD" = "" ]; then
		perl $TMPPL < $I.$TXTEXT > $I.$ARCEXT
	else
		$TXTCMD -o $I.$ARCEXT $I.$TXTEXT
	fi
	$ARCCMD $I.$ARCEXT >/dev/null  2>/dev/null
	$TARCMD $TAROPT $I >/dev/null  2>/dev/null
	if [ "$CODE" = "UTF-8" ]; then
		P="pyukiwiki-$VER$BUILD-utf8"
	else
		P="pyukiwiki-$VER$BUILD"
	fi
	cp -pR	$P/* . >/dev/null 2>/dev/null
	cp -pR	$P/.ht* . >/dev/null 2>/dev/null
	cp -pR  $P/attach/.ht* $P/attach >/dev/null 2>/dev/null
	cp -pR  $P/build/.ht* $P/build >/dev/null 2>/dev/null
	cp -pR  $P/cache/.ht* $P/cache >/dev/null 2>/dev/null
	cp -pR  $P/counter/.ht* $P/counter >/dev/null 2>/dev/null
	cp -pR  $P/diff/.ht* $P/diff >/dev/null 2>/dev/null
	cp -pR  $P/image/.ht* $P/image >/dev/null 2>/dev/null
	cp -pR  $P/info/.ht* $P/info >/dev/null 2>/dev/null
	cp -pR  $P/lib/.ht* $P/lib >/dev/null 2>/dev/null
	cp -pR  $P/logs/.ht* $P/logs >/dev/null 2>/dev/null
	cp -pR  $P/plugin/.ht* $P/plugin >/dev/null 2>/dev/null
	cp -pR  $P/releasepatch/.ht* $P/releasepatch >/dev/null 2>/dev/null
	cp -pR  $P/resource/.ht* $P/resource >/dev/null 2>/dev/null
	cp -pR  $P/sample/.ht* $P/sample >/dev/null 2>/dev/null
	cp -pR  $P/skin/.ht* $P/skin >/dev/null 2>/dev/null
	cp -pR  $P/wiki/.ht* $P/wiki >/dev/null 2>/dev/null
	rm -rf $P
fi

if [ "$CMD" = "cgiinstall" ]; then
	$SH $X extract $MYCMD
	$SH $X setperl $MYCMD
	if [ "`echo $QUERY_STRING|grep secure`" != "" ] ; then
		$SH $X securechmod $MYCMD
		if [ "`echo $HTTP_ACCEPT_LANGUAGE | grep ja`" != "" ]; then
			INSTALLMODE="セキュアインストールモードでインストールをしました。<br>"
		else
			INSTALLMODE="Installation complete in secure mode.<br>"
		fi
	else
		$SH $X chmod $MYCMD
		INSTALLMODE=""
	fi
	if [ "`echo $QUERY_STRING|grep htaccessoff`" != "" ] ; then
		rm -rf .htac*
		rm -rf .htpa*
		echo '1;'>>./info/setup.ini.cgi
		if [ "`echo $HTTP_ACCEPT_LANGUAGE | grep ja`" != "" ]; then
			HTACCESS=".htaccessファイルを削除しました<br>"
		else
			HTACCESS="Deleted .htaccess file<br>"
		fi
	fi
	if [ "`echo $QUERY_STRING|grep gzipon`" != "" ] ; then
		echo '$::gzip_path="";'>>./info/setup.ini.cgi
		echo '1;'>>./info/setup.ini.cgi
		if [ "`echo $HTTP_ACCEPT_LANGUAGE | grep ja`" != "" ]; then
			GZIP="gzip圧縮転送は有効です<br>"
		else
			GZIP="gzip compression transfer is enebled<br>"
		fi
	else
		echo '$::gzip_path="nouse";'>>./info/setup.ini.cgi
		echo '1;'>>./info/setup.ini.cgi
		GZIP=""
	fi
	if [ "`echo $QUERY_STRING|grep resetpassword`" != "" ] ; then
		echo '$::adminpass=crypt("pass", "AA");'>>./info/setup.ini.cgi
		echo '$::adminpass{admin}="";'>>./info/setup.ini.cgi
		echo '$::adminpass{frozen}="";'>>./info/setup.ini.cgi
		echo '$::adminpass{attach}="";'>>./info/setup.ini.cgi
		if [ "`echo $HTTP_ACCEPT_LANGUAGE | grep ja`" != "" ]; then
			PASSRESET="管理者パスワードをリセットしました。<br>"
		else
			PASSRESET="Reset  administrator password.<br>"
		fi
	fi
	if [ "`echo $HTTP_ACCEPT_LANGUAGE | grep ja`" != "" ]; then
		echo $DOCTYPE
		echo $HEADJA
		cat <<EOF
<body><h2>PyukiWikiインストーラ</h2>
<table>
<tr><td colspan="2">
PyukiWikiのインストールが完了しました。<br>
$INSTALLMODE$HTACCESS$GZIP
インストーラは、動作を確認した後、不正アクセス防止の為に、必ず削除して下さい。<br>
初回起動時の管理者パスワードは「pass」です。<br>
<br>
動作しない時は、戻るボタンを押してから、インストールオプションを変更すると動作する可能性があります。
<hr>
<a href="index.cgi">動作確認はこちらから</a>
<div align="left">
<form action="index.cgi" method="GET">
<input type="submit" value="戻る" $buttonstyle>
<input type="submit" value="次へ" $buttonstyle $disable>
<input type="submit" name="complete" value="完了" $buttonstyle>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTJA
	else
		echo $DOCTYPE
		echo $HEADEN
		cat <<EOF
<body><h2>PyukiWiki Installer</h2>
<table>
<tr><td colspan="2">
Install Complete<br>
$INSTALLMODE$HTACCESS$GZIP
Must remove installer file, after that it works, to prevent unauthorized access.<br>
Initial administrator password is "pass".<br>
<br>
When this does not work, press the back button, you may work with to change the installation options.
<hr>
<a href="index.cgi">Test Pyukiwiki Hear</a>
<div align="left">
<form action="index.cgi" method="GET">
<input type="submit" value="Back" $buttonstyle>
<input type="submit" value="Next" $buttonstyle $disable>
<input type="submit" name="complete" value="Complete" $buttonstyle>
</form></div>
</td></tr>
</table>
</body></html>
EOF
		echo $FOOTEN
	fi
fi

if [ "$CMD" = "shell" ]; then
	updatecheck
	echo Install PyukiWiki
	echo "Version:$VER$BUILD ($CODE)"
	echo Install to $PWD
	echo -n "Secure install ? (y/n) : "
	read secure
	echo -n "Press any key to install (Stop:Ctrl+C) : "
	read ans

	$SH $X extract $MYCMD
	$SH $X setperl $MYCMD
	if [ "`echo $secure|grep '[Yy]'`" != "" ]; then
		$SH $X securechmod $MYCMD
	else
		$SH $X chmod $MYCMD
	fi
	echo "Install complete."
fi
