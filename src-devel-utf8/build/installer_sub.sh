#!/bin/sh
CMD=$1
MYCMD=$2
disable='disabled="disabled"'
buttonstyle='style="width:150px;"'
chk='checked="checked"'
update=`echo $BUILD|grep update`

DOCTYPE='<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://ww.w3.org/TR/html4/loose.dtd">'
cat <<EOM>headtmp
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css"><!--
body,td{color:black;background-color:white;margin-left:2%;margin-right:2%;font-size:90%;font-family:verdana,arial,helvetica,Sans-Serif}strong{text-shadow:inherit 0 0 0;font-weight:bold}a:link{color:#215dc6;background-color:inherit;text-decoration:none}a:active{color:#215dc6;background-color:inherit;text-decoration:none}a:visited{color:#a63d21;background-color:inherit;text-decoration:none}a:hover{color:#215dc6;background-color:#cde;text-decoration:underline}h2{font-family:verdana,arial,helvetica,Sans-Serif;color:inherit;background-color:#def;padding:.3em;border:0;margin:0 0 .5em 0}h1.title,h1.error{font-size:30px;text-shadow:inherit 0 0 0;font-weight:bold;background-color:transparent;padding:12px 0 0 0;border:0;margin:12px 0 0 0}h1.error{color:red}*/
//--></style>
</head>
EOM
HEAD=`cat headtmp`
if [ "$update" != "" ]; then
	NAMEJA="アップデーター"
	DOJA="アップデート"
	NAMEEN="Updater"
	DOEN="Update"
	DOZEN=$DOEN
	DOZZEN=$DOEN
else
	NAMEJA="インストーラー"
	DOJA="インストール"
	NAMEEN="Installer"
	DOEN="Install"
	DOZEN="installation"
	DOZZEN="Installation"
fi
HEADJA="<html><head><title>PyukiWiki$NAMEJA</title>"
HEADEN="<html><head><title>PyukiWiki $NAMEEN</title>"
BODYJA="<body><h2>PyukiWiki$NAMEJA</h2>"
BODYEN="<body><h2>PyukiWiki $NAMEEN</h2>"
FOOTJA='<hr><div id="footer"><strong><a href="http://pyukiwiki.sfjp.jp/" class="link" title="PyukiWiki 0.2.0-p2">PyukiWiki 0.2.0-p2</a></strong>Copyright&copy; 2004-2012 by <a href="http://nekyo.qp.land.to/" class="link" title="Nekyo">Nekyo</a>, <a href="http://pyukiwiki.sfjp.jp/" class="link" title="PyukiWiki Developers Team">PyukiWiki Developers Team</a>License is <a href="http://sfjp.jp/projects/opensource/wiki/GPLv3_Info" class="link" title="GPL">GPL</a>, <a href="http://www.opensource.jp/artistic/ja/Artistic-ja.html" class="link" title="Artistic">Artistic</a><br>Based on &quot;<a href="http://www.hyuki.com/yukiwiki/" class="link" title="YukiWiki">YukiWiki</a>&quot; 2.1.0 by <a href="http://www.hyuki.com/" class="link" title="yuki">yuki</a>and <a href="http://pukiwiki.sfjp.jp/" class="link" title="PukiWiki">PukiWiki</a> by <a href="http://pukiwiki.sfjp.jp/" class="link" title="PukiWiki Developers Term">PukiWiki Developers Term</a><br><a href="http://pyukiwiki.sfjp.jp/" class="link" title="PyukiWiki Installer version $IVER">PyukiWiki Installer version $IVER</a></div></div></div></body></html>'
FOOTEN='<hr><div id="footer"><strong><a href="http://pyukiwiki.sfjp.jp/" class="link" title="PyukiWiki Installer 0.2.0-p2">PyukiWiki Installer 0.2.0-p2</a></strong>Copyright&copy; 2004-2012 by <a href="http://nekyo.qp.land.to/" class="link" title="Nekyo">Nekyo</a>, <a href="http://pyukiwiki.sfjp.jp/" class="link" title="PyukiWiki Developers Team">PyukiWiki Developers Team</a>License is <a href="http://www.gnu.org/licenses/gpl.html" class="link" title="GPL">GPL</a>, <a href="http://www.perl.com/language/misc/Artistic.html" class="link" title="Artistic">Artistic</a><br>Based on &quot;<a href="http://www.hyuki.com/yukiwiki/" class="link" title="YukiWiki">YukiWiki</a>&quot; 2.1.0 by <a href="http://www.hyuki.com/" class="link" title="yuki">yuki</a>and <a href="http://pukiwiki.sfjp.jp/" class="link" title="PukiWiki">PukiWiki</a> by <a href="http://pukiwiki.sfjp.jp/" class="link" title="PukiWiki Developers Term">PukiWiki Developers Term</a><br><a href="http://pyukiwiki.sfjp.jp/" class="link" title="PyukiWiki Installer version $IVER">PyukiWiki Installer version $IVER</a></div></div></div></body></html>'

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
	if [ "`echo $LN | grep ja`" != "" ]; then
		echo $DOCTYPE
		echo $HEADJA
		echo $HEAD
		cat <<EOF
$BODYJA
<table>
<tr><td colspan="2">
PyukiWikiを$DOJAします。<br>
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
	echo $FOOTJA|sed -e s/\$IVER/$IVER/g;
	else
	echo $DOCTYPE
	echo $HEADEN
	echo $HEAD
		cat <<EOF
$BODYEN
<table>
<tr><td colspan="2">
$DOEN PyukiWiki.<br>
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
		echo $FOOTEN|sed -e s/\$IVER/$IVER/g;
	fi
fi

if [ "$CMD" = "gpl" ]; then
	if [ "`echo $LN | grep ja`" != "" ]; then
		echo $DOCTYPE
		echo $HEADJA
		echo $HEAD
		cat <<EOF
$BODYJA
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
		echo $FOOTJA|sed -e s/\$IVER/$IVER/g;
	else
		echo $DOCTYPE
		echo $HEADEN
		echo $HEAD
		cat <<EOF
$BODYEN
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
		echo $FOOTEN|sed -e s/\$IVER/$IVER/g;
	fi
fi

if [ "$CMD" = "art" ]; then
	if [ "`echo $LN | grep ja`" != "" ]; then
		echo $DOCTYPE
		echo $HEADJA
		echo $HEAD
		cat <<EOF
$BODYJA
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
		echo $FOOTJA|sed -e s/\$IVER/$IVER/g;
	else
		echo $DOCTYPE
		echo $HEADEN
		echo $HEAD
		cat <<EOF
$BODYEN
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
		echo $FOOTEN|sed -e s/\$IVER/$IVER/g;
	fi
fi

if [ "$CMD" = "license" ]; then
	cat $QS.html
	exit
fi

if [ "$CMD" = "cgititle" ]; then
	UPDATEHTML=""
	if [ "`echo $LN | grep ja`" != "" ]; then
		echo $DOCTYPE
		echo $HEADJA
		echo $HEAD
		cat <<EOF
$BODYJA
<table>
<tr><td colspan="2">
PyukiWikiの$DOJAの準備は完了しました。<br>
以下のオプションを選択して下さい。<br>
次へをクリックすると、$DOJAを開始します。<br>
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<table>
<tr><td>$DOJAモード</td><td>
<input type="radio" name="installmode" value="normal" $chk>通常$DOJA
<input type="radio" name="installmode" value="secure">セキュア$DOJA（パーミッションを厳格に設定します。）
</td></tr>
<tr><td>.htaccessファイル</td><td>
<input type="radio" name="htaccess" value="htaccesson" $chk>設置する
<input type="radio" name="htaccess" value="htaccessoff">削除する
</td></tr>
EOF
		if [ "$update" != "" ]; then
			cat <<EOF
<input type="hidden" name="freeze" value="freezeoff">
EOF
		else
			cat <<EOF
<tr><td>デフォルトを凍結する</td><td>
<input type="radio" name="freeze" value="freezeoff" $chk>凍結しない
<input type="radio" name="freeze" value="freezeon">凍結する
</td></tr>
EOF
		fi
		cat <<EOF
<tr><td>gzip圧縮転送</td><td>
<input type="radio" name="gzip" value="gzipoff">無効
<input type="radio" name="gzip" value="gzipon" $chk>有効
</td></tr>
<tr><td>$DOJAするパス:</td>
<td>$PWD</td></tr>
<tr><td>$DOJAするPyukiWikiのバージョン:</td>
<td>$VER$BUILD ($CODE)$UPDATEHTML</td></tr>
<tr><td>解凍コマンド:</td>
<td>$TXTCMD $ARCCMD $TARCMD</td></tr>
</table>
<input type="submit" name="step3" value="戻る" $buttonstyle>
<input type="submit" name="install" value="次へ" $buttonstyle>
<input type="submit" name="cancel" value="キャンセル" $buttonstyle>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTJA|sed -e s/\$IVER/$IVER/g;
	else
		echo $DOCTYPE
		echo $HEADEN
		echo $HEAD
		cat <<EOF
$BODYEN
<table>
<tr><td colspan="2">
Complete of preparing for the $DOZEN of PyukiWiki<br>
Please select the options.<br>
Press Next, $DOZEN complete.
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<table>
<tr><td>$DOEN Mode</td><td>
<input type="radio" name="installmode" value="normal" $chk>Default $DOEN
<input type="radio" name="installmode" value="secure">Secure $DOEN (Setting strict file and permissions.)
</td></tr>
<tr><td>.htaccess File</td><td>
<input type="radio" name="htaccess" value="htaccesson" $chk>Install
<input type="radio" name="htaccess" value="htaccessoff">Delete
</td></tr>
EOF
		if [ "$update" != "" ]; then
			cat <<EOF
<input type="hidden" name="freeze" value="freezeoff">
EOF
		else
			cat <<EOF
<tr><td>Default to freeze of wiki page</td><td>
<input type="radio" name="freeze" value="freezeoff" $chk>Not freeze
<input type="radio" name="freeze" value="freezeon">Freeze
</td></tr>
EOF
		fi
		cat <<EOF
<tr><td>gzip compress transfer</td><td>
<input type="radio" name="gzip" value="gzipoff">Disable
<input type="radio" name="gzip" value="gzipon" $chk>Enable
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
</td></tr>
</table>
EOF
		echo $FOOTEN|sed -e s/\$IVER/$IVER/g;
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
	rm -rf ./wiki
	cp -pR	$P/* . >/dev/null 2>/dev/null
	cp -pR	$P/.ht* . >/dev/null 2>/dev/null
	cp -pR  $P/attach/.ht* ./attach >/dev/null 2>/dev/null
	cp -pR  $P/cache/.ht* ./cache >/dev/null 2>/dev/null
	cp -pR  $P/counter/.ht* ./counter >/dev/null 2>/dev/null
	cp -pR  $P/diff/.ht* ./diff >/dev/null 2>/dev/null
	cp -pR  $P/image/.ht* ./image >/dev/null 2>/dev/null
	cp -pR  $P/info/.ht* ./info >/dev/null 2>/dev/null
	cp -pR  $P/lib/.ht* ./lib >/dev/null 2>/dev/null
	cp -pR  $P/plugin/.ht* ./plugin >/dev/null 2>/dev/null
	cp -pR  $P/resource/.ht* ./resource >/dev/null 2>/dev/null
	cp -pR  $P/skin/.ht* $P/skin >/dev/null 2>/dev/null
	cp -pR  $P/wiki/.ht* $P/wiki >/dev/null 2>/dev/null
	rm -rf $P
fi

if [ "$CMD" = "cgiinstall" ]; then
	$SH $X extract $MYCMD
	$SH $X setperl $MYCMD
	if [ "`echo $QS|grep secure`" != "" ] ; then
		$SH $X securechmod $MYCMD
		if [ "`echo $LN | grep ja`" != "" ]; then
			INSTALLMODE="セキュア$DOJAモードで$DOJAをしました。<br>"
		else
			INSTALLMODE="$DOZZEN complete in secure mode.<br>"
		fi
	else
		$SH $X chmod $MYCMD
		INSTALLMODE=""
	fi
	if [ "`echo $QS|grep htaccessoff`" != "" ] ; then
		rm -rf .htac*
		rm -rf .htpa*
		echo '1;'>>./info/setup.ini.cgi
		if [ "`echo $LN | grep ja`" != "" ]; then
			HTACCESS=".htaccessファイルを削除しました<br>"
		else
			HTACCESS="Deleted .htaccess file<br>"
		fi
	fi
	if [ "`echo $QS|grep freezeon`" != "" ] ; then
		cd wiki
		for l in `ls`; do if [ "$l" != "526563656E744368616E676573.txt" ]; then grep -v '#freeze' < $l > $l.tmp; echo '#freeze' > $l; cat $l.tmp >> $l; rm $l.tmp; fi; done
		if [ "`echo $LN | grep ja`" != "" ]; then
			FREEZE="初期ページを凍結しました。凍結解除するには、初期パスワード「pass」を使用して下さい。<br>"
		else
			FREEZE="Initial page has been frozen. To cancel the freeze, please use the password "pass".<br>"
		fi
	fi
	if [ "`echo $QS|grep gzipon`" != "" ] ; then
		echo '$::gzip_path="";'>>./info/setup.ini.cgi
		echo '1;'>>./info/setup.ini.cgi
		if [ "`echo $LN | grep ja`" != "" ]; then
			GZIP="gzip圧縮転送は有効です<br>"
		else
			GZIP="gzip compression transfer is enebled<br>"
		fi
	else
		echo '$::gzip_path="nouse";'>>./info/setup.ini.cgi
		echo '1;'>>./info/setup.ini.cgi
		GZIP=""
	fi
	if [ "`echo $QS|grep resetpassword`" != "" ] ; then
		echo '$::adminpass=crypt("pass", "AA");'>>./info/setup.ini.cgi
		echo '$::adminpass{admin}="";'>>./info/setup.ini.cgi
		echo '$::adminpass{frozen}="";'>>./info/setup.ini.cgi
		echo '$::adminpass{attach}="";'>>./info/setup.ini.cgi
		if [ "`echo $LN | grep ja`" != "" ]; then
			PASSRESET="管理者パスワードをリセットしました。<br>"
		else
			PASSRESET="Reset  administrator password.<br>"
		fi
	fi
	if [ "`echo $LN | grep ja`" != "" ]; then
		echo $DOCTYPE
		echo $HEADJA
		echo $HEAD
		cat <<EOF
$BODYJA
<table>
<tr><td colspan="2">
PyukiWikiの$DOJAが完了しました。<br>
$INSTALLMODE$HTACCESS$FREEZE$GZIP
$NAMEJAは、動作を確認した後、不正アクセス防止の為に、必ず削除して下さい。<br>
初回起動時の管理者パスワードは「pass」です。<br>
<br>
動作しない時は、戻るボタンを押してから、$DOJAオプションを変更すると動作する可能性があります。
<br><br>
<font soze="+1"><a href="index.cgi">動作確認はこちらから</a></font>
<div align="left">
<form action="index.cgi" method="GET">
<input type="submit" value="戻る" $buttonstyle $disable>
<input type="submit" value="次へ" $buttonstyle $disable>
<input type="submit" name="complete" value="完了" $buttonstyle>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTJA|sed -e s/\$IVER/$IVER/g;
	else
		echo $DOCTYPE
		echo $HEADEN
		echo $HEAD
		cat <<EOF
$BODYEN
<table>
<tr><td colspan="2">
$DOEN Complete<br>
$INSTALLMODE$HTACCESS$GZIP
Must remove $NAMEEN file, after that it works, to prevent unauthorized access.<br>
Initial administrator password is "pass".<br>
<br>
When this does not work, press the back button, you may work with to change the $DOEN options.
<br><br>
<font size="+1"><a href="index.cgi">Test Pyukiwiki Hear</a></font>
<div align="left">
<form action="index.cgi" method="GET">
<input type="submit" value="Back" $buttonstyle $disable>
<input type="submit" value="Next" $buttonstyle $disable>
<input type="submit" name="complete" value="Complete" $buttonstyle>
</form></div>
</td></tr>
</table>
</body></html>
EOF
		echo $FOOTEN|sed -e s/\$IVER/$IVER/g;
	fi
fi

if [ "$CMD" = "shell" ]; then
	updatecheck
	echo $DOEN PyukiWiki
	echo "Version:$VER$BUILD ($CODE)"
	echo $DOEN to $PWD
	echo -n "Secure $DOEN ? (y/n) : "
	read secure
	echo -n "Press any key to $DOEN (Stop:Ctrl+C) : "
	read ans

	$SH $X extract $MYCMD
	$SH $X setperl $MYCMD
	if [ "`echo $secure|grep '[Yy]'`" != "" ]; then
		$SH $X securechmod $MYCMD
	else
		$SH $X chmod $MYCMD
	fi
	echo "$DOEN complete."
fi

rm headtmp
