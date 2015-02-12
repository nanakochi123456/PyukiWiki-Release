#!/bin/sh
#--------------------------------------------------------------
# PyukiWiki Installer CGI Maker
# $Id: makeinstaller.sh,v 1.62 2012/03/01 10:39:24 papu Exp $
#--------------------------------------------------------------
ZIPCMD=$1
P7ZCMD=$2
ORGFILE=$3
TOFILE=$4.cgi
ZIPFILE=$4.zip
P7ZFILE=$4.exe
P7ZSFXFILE=./build/7zSD.sfx
P7ZCONFIGFILE=/tmp/config.txt
VERSION=$5
PREFIX=$6
ARCMETHOD=$7
TXTMETHOD=$8
CODE=$9
TEMPDIR="/tmp"
TEMP1="$TEMPDIR/tmp1"
TEMP2="$TEMPDIR/tmp2"
TEMP3="$TEMPDIR/tmp3"

arc() {
	if [ "$ARCMETHOD" = "gz" ]; then
#		ARCCMD="GZIP="gzip -9"
		ARCCMD="7za a -tgzip -mx9"
		EXTCMD="gunzip"
	fi
	if [ "$ARCMETHOD" = "bz2" ]; then
#		ARCCMD="bzip2 -9"
		ARCCMD="7za a -tbzip2 -mx9"
		EXTCMD="bunzip2"
	fi
	if [ "$ARCMETHOD" = "xz" ]; then
#		ARCCMD="xz -9"
		ARCCMD="7za a -txz -mx9"
		EXTCMD="unxz"
	fi
#	echo cp ./build/installer_sub.sh $TEMP1
	cd build
	tar cvf $TEMP1 installer_sub.sh *.html >/dev/null 2>/dev/null
	cd ..
#	cp ./build/installer_sub.sh $TEMP1 >/dev/null 2>/dev/null
#	echo $ARCCMD $TEMP1.$ARCMETHOD $TEMP1
	$ARCCMD $TEMP1.$ARCMETHOD $TEMP1 >/dev/null 2>/dev/null

	if [ "$TXTMETHOD" = "b64" ]; then
		TXTENCCMD="b64encode"
		TXTCMD="b64decode"
	fi
	if [ "$TXTMETHOD" = "uu" ]; then
		TXTENCCMD="uuencode"
		TXTCMD="uudecode"
	fi
	if [ "$TXTMETHOD" = "shar" ]; then
		TXTENCCMD=""
		TXTCMD=""
	fi

	if [ "$TXTMETHOD" = "shar" ]; then
		perl ./build/base64.pl b64encode < $TEMP1.$ARCMETHOD > $TEMP2
#		cp $TEMP1.$ARCMETHOD $TEMP2
	else
		$TXTENCCMD -o $TEMP2 $TEMP1.$ARCMETHOD a >/dev/null 2>/dev/null
	fi
}

txt() {
	if [ "$TXTMETHOD" = "b64" ]; then
		TXTENCCMD="b64encode"
		TXTCMD="b64decode"
	fi
	if [ "$TXTMETHOD" = "uu" ]; then
		TXTENCCMD="uuencode"
		TXTCMD="uudecode"
	fi
	if [ "$TXTMETHOD" = "shar" ]; then
		TXTENCCMD=""
		TXTCMD=""
	fi
	if [ "$TXTMETHOD" = "shar" ]; then
		perl ./build/base64.pl b64encode < $ORGFILE > $TEMP3
#		cp $ORGFILE $TEMP3
	else
		$TXTENCCMD -o $TEMP3 $ORGFILE a >/dev/null 2>/dev/null
	fi

}

arc
txt

cat ./build/installer.sh \
	| sed -e "s/__ARCCMD__/$EXTCMD/g" \
	| sed -e "s/__TXTCMD__/$TXTCMD/g" \
	| sed -e "s/__ARCEXT__/$ARCMETHOD/g" \
	| sed -e "s/__TXTEXT__/$TXTMETHOD/g" \
	| sed -e "s/__PYUKIWIKIVERSION__/$VERSION/g" \
	| sed -e "s/__BUILD__/$PREFIX/g" \
	| sed -e "s/__CODE__/$CODE/g"> $TOFILE

if [ "$TXTMETHOD" = "shar" ]; then
#	echo sed \'s/^X//\'\>\$S\<\<\'aaaaaaaa\'>>$TOFILE
#	sed 's/^/X/' $TEMP2>>$TOFILE
	echo cat\>\$S\<\<\'aaaaaaaa\'>>$TOFILE
	cat $TEMP2>>$TOFILE
	echo aaaaaaaa>>$TOFILE
else
	#echo sed \'s/^X//\'\>\$S\<\<\'aaaaaaaa\'>>$TOFILE
	echo cat\>\$S\<\<\'aaaaaaaa\'>>$TOFILE
	cat>$TEMPDIR/tmp.pl<<EOF
open(R,"$TEMP2");
foreach(<R>){
#print "X\$_";
print "\$_";
}
close(R);
EOF
	perl $TEMPDIR/tmp.pl>>$TOFILE
	echo aaaaaaaa>>$TOFILE
fi

# hexencode
#perl -e 'while(<STDIN>){chomp;$z.="$_\r";}foreach my $i (0x00 .. 0xFF) {$x{chr($i)} = sprintf("%02X", $i); }$z =~ s/(.)/$x{$1}/g; print $z;'

# hexdecode
#perl -e 'while(<STDIN>){$z.=$_;}$i=~s/0D/0A/g;foreach my $i (0x00 .. 0xFF) {$x{sprintf("%02X", $i)}=chr($i);}$z=~s/([0-9A-F][0-9A-F])/$x{$1}/g; print $z;'

#if [ "$TXTMETHOD" = "shar" ]; then
#	echo cat \<\<EOF\|perl -e \'while\(<STDIN>\){chomp;$z.=$_;}$z=~s/\r/\n/g;print $z;\'\>\$TMPPL >>$TOFILE
#	perl -e 'while(<STDIN>){chomp;$z.="$_\r";}foreach my $i (0x00 .. 0xFF) {$x{chr($i)} = sprintf("\\%02X", $i); }$z =~ s/(.)/$x{$1}/g; print $z;' < ./build/b64decode.pl >>$TOFILE
#	echo EOF >>$TOFILE
#fi


if [ "$TXTMETHOD" = "shar" ]; then
#	echo sed \'s/^X//\'\>\$S\<\<\'bbbbbbbb\'>>$TOFILE
#	sed 's/^/X/' $TEMP3>>$TOFILE
	echo cat\>\$I\<\<\'bbbbbbbb\'>>$TOFILE
	cat $TEMP3>>$TOFILE
	echo aaaaaaaa>>$TOFILE
	echo bbbbbbbb>>$TOFILE
else
	#echo sed \'s/^X//\'\>\$I\<\<\'bbbbbbbb\'>>$TOFILE
	echo cat\>\$I\<\<\'bbbbbbbb\'>>$TOFILE
	cat>$TEMPDIR/tmp.pl<<EOF
open(R,"$TEMP3");
foreach(<R>){
#print "X\$_";
print "\$_";
}
close(R);
EOF
	perl $TEMPDIR/tmp.pl>>$TOFILE
	echo bbbbbbbb>>$TOFILE
fi

rm $TEMP1.$ARCMETHOD
rm $TEMP2
rm $TEMP3

#cat $TEMP2 >> $TOFILE
#cat $TEMP3 >> $TOFILE
rm -f $TEMPDIR/tmp.pl

cat ./build/installer2.sh \
	| sed -e "s/__ARCCMD__/$EXTCMD/g" \
	| sed -e "s/__TXTCMD__/$TXTCMD/g" \
	| sed -e "s/__ARCEXT__/$ARCMETHOD/g" \
	| sed -e "s/__TXTEXT__/$TXTMETHOD/g" \
	| sed -e "s/__PYUKIWIKIVERSION__/$VERSION/g" \
	| sed -e "s/__BUILD__/$PREFIX/g" \
	| sed -e "s/__CODE__/$CODE/g">> $TOFILE

# make zip file
$ZIPCMD $ZIPFILE $TOFILE ./build/CGI_INSTALLER.*.txt ./README.txt ./COPYRIGHT.*.txt ./COPYRIGHT.txt >/dev/null 2>/dev/null

# remove installer
rm $TOFILE
