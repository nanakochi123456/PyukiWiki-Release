#!/bin/sh
# mirror make tool

mkdir pyukiwiki 1>/dev/null 2>/dev/null
mkdir pyukiwiki/image 1>/dev/null 2>/dev/null
mkdir pyukiwiki/skin-plala 1>/dev/null 2>/dev/null
mkdir pyukiwiki/skin-vector 1>/dev/null 2>/dev/null
mkdir pyukiwiki/skin-geocities 1>/dev/null 2>/dev/null
mkdir pyukiwiki/skin-sakura 1>/dev/null 2>/dev/null
mkdir pyukiwiki/skin-tok2 1>/dev/null 2>/dev/null

cp -pR release/pyukiwiki*-devel/image/* pyukiwiki/image
cp -pR release/pyukiwiki*-devel/skin/*.js pyukiwiki/skin-sakura
cp -pR release/pyukiwiki*-devel/skin/*.css pyukiwiki/skin-sakura
cp -pR release/pyukiwiki*-devel/sample/*.css pyukiwiki/skin-sakura
cp -pR release/pyukiwiki*-devel/skin/*.js pyukiwiki/skin-plala
cp -pR release/pyukiwiki*-devel/skin/*.css pyukiwiki/skin-plala
cp -pR release/pyukiwiki*-devel/sample/*.css pyukiwiki/skin-plala
cp -pR release/pyukiwiki*-devel/skin/*.js pyukiwiki/skin-geocities
cp -pR release/pyukiwiki*-devel/skin/*.css pyukiwiki/skin-geocities
cp -pR release/pyukiwiki*-devel/sample/*.css pyukiwiki/skin-geocities
cp -pR release/pyukiwiki*-devel/skin/*.js pyukiwiki/skin-vector
cp -pR release/pyukiwiki*-devel/skin/*.css pyukiwiki/skin-vector
cp -pR release/pyukiwiki*-devel/sample/*.css pyukiwiki/skin-vector
cp -pR release/pyukiwiki*-devel/skin/*.js pyukiwiki/skin-tok2
cp -pR release/pyukiwiki*-devel/skin/*.css pyukiwiki/skin-tok2
cp -pR release/pyukiwiki*-devel/sample/*.css pyukiwiki/skin-tok2


for prc in skin-plala skin-vector skin-geocities skin-sakura; do cp -pR release/pyukiwiki*-devel/skin/*.js pyukiwiki/$prc; done
for prc in skin-plala skin-vector skin-geocities skin-sakura; do cp -pR release/pyukiwiki*-devel/skin/*.css pyukiwiki/$prc; done

for prc in `ls pyukiwiki/skin-plala/*.css`; do cat pyukiwiki/skin-plala/$prc|perl -e "foreach(<STDIN>){print $_;}">/tmp/tmp; cp /tmp/tmp pyukiwiki/skin-plala/$prc; rm /tmp/tmp; done

#for prc in `ls pyukiwiki/skin-sakura/*.css`; do cat pyukiwiki/skin-sakura/$prc|sed -e "s/url\('\.\/url\('\http:\/\/nanaochi\.sakura\.ne\.jp\/pyukiwiki\/skin\/g">/tmp/tmp; cp /tmp/tmp pyukiwiki/skin-sakura/$prc; rm /tmp/tmp; done

#for prc in `ls pyukiwiki/skin-geocities/*.css`; do cat pyukiwiki/skin-geocities/$prc|sed -e "s/url\('\.\/url\('\http:\/\/geocities\.yahoo\.co\.jp\/gl\/pyukiwikidev\/pyukiwiki\/skin\/g">/tmp/tmp; cp /tmp/tmp pyukiwiki/skin-sakura/$prc; rm /tmp/tmp; done

for prc in `ls pyukiwiki/skin-vector/*.css`; do cat pyukiwiki/skin-vector/$prc|sed -e "s/url\('\.\/url\('\http:\/\/geocities\.yahoo\.co\.jp\/gl\/pyukiwikidev\/pyukiwiki\/skin\/g">/tmp/tmp; cp /tmp/tmp pyukiwiki/skin-vector/$prc; rm /tmp/tmp; done
