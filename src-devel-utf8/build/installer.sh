#!/bin/sh
######################################################################
# PyukiWiki Installer CGI version 0.2
# $Id: installer.sh,v 1.92 2012/03/18 11:23:55 papu Exp $
# PyukiWiki __PYUKIWIKIVERSION____BUILD__ (__CODE__)
######################################################################
export PATH="/bin:/usr/bin:/usr/local/bin:/opt/bin:/usr/opt/bin:/usr/opt/sbin:/bin:/usr/sbin:/usr/local/sbin:/usr/games:/usr/games/bin:$PATH"
export IVER=0.2
export SH=sh
export TARCMD=tar
export TAROPT=xvf
export ARCCMD=__ARCCMD__
export ARCEXT=__ARCEXT__
export TXTCMD=__TXTCMD__
export TXTEXT=__TXTEXT__
export VER="__PYUKIWIKIVERSION__"
export BUILD="__BUILD__"
export CODE="__CODE__"
export X="installer_sub.sh"
export S=".installertarball"
export I=".installimagetarball"
export httpheader="Content-type: text/html;charset=utf-8"
export TMPPL="/tmp/tmp.$REMOTE_ADDR"
export QS=$QUERY_STRING
export LN=$HTTP_ACCEPT_LANGUAGE

err() {
	if [ $CGI = 1 ]; then
		if [ "`echo $LN | grep ja`" != "" ]; then
			cat <<EOF
$httpheader

<html><head><title>PyukiWikiインストーラ</title></head>
<body><h2>PyukiWikiインストーラ エラー</h2>
<hr>
PyukiWiki CGIインストーラは以下の理由で正常に起動できませんでした。
手動でインストールして下さい。
<hr>
$1
EOF
		else
			cat <<EOF
$httpheader

<html><head><title>PyukiWiki Installer</title></head>
<body><h2>PyukiWiki Installer</h2>
<hr>
Can't execute PyukiWiki CGI Installer<br>
Prease manual install
<hr>
$1
EOF
		fi
		echo \<\/body\><\/html\>
	else
		echo Can\'t execute PyukiWiki Installer
		echo Prease manual install
	fi
	exit
}

wrc() {
	test_file="./writetestfile_pyukiwiki"
	echo test>$test_file
	if [ -f $test_file ]; then
		rm -rf $test_file
		return 0;
	fi
	rm -rf $test_file
	if [ "`echo $LN | grep ja`" != "" ]; then
		err "CGIがユーザー権限で実行されていないので、インストールできません"
	else
		err "It is not running on the user rights CGI, you can not install"
	fi
	return 1;
}

cmdc() {
	if [ "$1" = "" ]; then
		return 0;
	fi
	CMD=`which $1`
	if [ "$CMD" != "" ]; then
		return 0;
	else
		if [ "`echo $LN | grep ja`" != "" ]; then
			err "コマンド $1 がありません"
		else
			err "Not found command $1"
		fi
	fi
}

chk() {
	cmdc $SH
	cmdc echo
	cmdc chmod
	cmdc sed
	cmdc cp
	cmdc rm
	cmdc mv
	cmdc cat
	cmdc grep
	cmdc $TARCMD
	cmdc $ARCCMD
	cmdc $TXTCMD
	wrc
}

export PWD=`pwd`

if [ "$REMOTE_ADDR" != "" ]; then
	CGI=1
else
	CGI=0
fi

if [ $CGI = 1 ]; then
	cat <<EOF
$httpheader

EOF
	chk
	SHELLEXEC=cgistart
	if [ "`echo $QS|grep license`" != "" ]; then
		SHELLEXEC=license
	fi
	if [ "`echo $QS|grep step1`" != "" ]; then
		SHELLEXEC=gpl
	fi
	if [ "`echo $QS|grep step2`" != "" ]; then
		SHELLEXEC=art
	fi
	if [ "`echo $QS|grep step3`" != "" ]; then
		SHELLEXEC=cgititle
	fi
	if [ "`echo $QS|grep install`" != "" ]; then
		SHELLEXEC=cgiinstall
	fi
else
	chk
	SHELLEXEC=shell
fi
