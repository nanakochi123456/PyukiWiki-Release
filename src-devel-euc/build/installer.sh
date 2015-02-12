#!/bin/sh
######################################################################
# PyukiWiki Installer CGI
# $Id: installer.sh,v 1.13 2012/01/31 10:11:53 papu Exp $
# Installer version 0.1
# PyukiWiki __PYUKIWIKIVERSION____BUILD__ (__CODE__)
######################################################################
export PATH="/bin:/usr/bin:/usr/local/bin:/opt/bin:/usr/opt/bin/sbin:/bin:/usr/sbin:/usr/local/sbin:/usr/games:/usr/games/bin:$PATH"
export INSTALLERVER=0.1
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

err() {
	if [ $CGI = 1 ]; then
		if [ "`echo $HTTP_ACCEPT_LANGUAGE | grep ja`" != "" ]; then
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
	if [ "`echo $HTTP_ACCEPT_LANGUAGE | grep ja`" != "" ]; then
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
		if [ "`echo $HTTP_ACCEPT_LANGUAGE | grep ja`" != "" ]; then
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
	if [ "`echo $QUERY_STRING|grep license`" != "" ]; then
		SHELLEXEC=license
	fi
	if [ "`echo $QUERY_STRING|grep step1`" != "" ]; then
		SHELLEXEC=gpl
	fi
	if [ "`echo $QUERY_STRING|grep step2`" != "" ]; then
		SHELLEXEC=art
	fi
	if [ "`echo $QUERY_STRING|grep step3`" != "" ]; then
		SHELLEXEC=cgititle
	fi
	if [ "`echo $QUERY_STRING|grep install`" != "" ]; then
		SHELLEXEC=cgiinstall
	fi
else
	chk
	SHELLEXEC=shell
	fi
