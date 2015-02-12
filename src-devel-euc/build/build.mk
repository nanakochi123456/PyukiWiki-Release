# release file makefile for pyukiwiki
# $Id: build.mk,v 1.524 2012/03/18 11:23:49 papu Exp $

all:
	@echo "PyukiWIki ${VERSION} Release Builder"
	@echo "Usage: ${MAKE} [build|prof|release|buildrelease|buildreleaseutf8|builddevel|builddevelutf8|buildcompact|buildcompactutf8|pkg|clean|cvsclean|ftp]"

version:
	@echo "PyukiWIki ${VERSION}"

pkg:
	@${MAKE} -f ${BUILDDIR}/build.mk cvsclean
	@${MAKE} -f ${BUILDDIR}/build.mk pkgclean
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=updatecompact PKGPREFIX="-update-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=update PKGPREFIX="-update-full"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=devel PKGPREFIX="-devel"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=updatedevel PKGPREFIX="-update-devel"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=compact PKGPREFIX="-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=release PKGPREFIX="-full"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzip PKGTYPE=devel PKGPREFIX="-devel"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzipupdate PKGTYPE=updatedevel PKGPREFIX="-update-devel"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzipupdate PKGTYPE=updatecompact PKGPREFIX="-update-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzipupdate PKGTYPE=update PKGPREFIX="-update-full"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzip PKGTYPE=compact PKGPREFIX="-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzip PKGTYPE=release PKGPREFIX="-full"

release:FORCE
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-full 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-update 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-compact 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-update-compact 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-devel 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-update-devel 2>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-full"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-full "release" lf >/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-compact"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-compact "compact" lf >/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-update"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-update "update" lf >/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-update-compact"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-update-compact "updatecompact" lf >/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-devel"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-devel "devel" lf >/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-update-devel"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-update-devel  "updatedevel" lf >/dev/null


releasedevel:FORCE
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-devel 2>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-devel all plugin"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-devel "devel" lf euc all >/dev/null

buildall:FORCE
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-devel(all)"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/ "devel" lf euc all>/dev/null


builddevel:FORCE
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-devel"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/ "devel" lf >/dev/null


buildrelease:FORCE
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-full"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/ "release" lf >/dev/null


buildcompact:FORCE
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-compact"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/ "compact" lf >/dev/null


pkgtgz:
	@echo "Building ${PKGNAME}-${VERSION}${PKGPREFIX}"
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} 2>/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} ${PKGTYPE} lf >/dev/null
	@echo "Taping ${PKGNAME}-${VERSION}${PKGPREFIX}.tar"
	@cd ${RELEASE} && ${TAR} ${PKGNAME}-${VERSION}${PKGPREFIX}.tar * >/dev/null 2>/dev/null
	@echo "Compress ${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz"
	@cd ${RELEASE} && ${GZIP_7Z} ${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz ${PKGNAME}-${VERSION}${PKGPREFIX}.tar >/dev/null 2>/dev/null
	@echo "Compress ${PKGNAME}-${VERSION}${PKGPREFIX}.tar.bz2"
	@cd ${RELEASE} && ${BZIP2_7Z} ${PKGNAME}-${VERSION}${PKGPREFIX}.tar.bz2 ${PKGNAME}-${VERSION}${PKGPREFIX}.tar >/dev/null 2>/dev/null
	@echo "Compress ${PKGNAME}-${VERSION}${PKGPREFIX}.tar.xz"
	@cd ${RELEASE} && ${XZ_7Z} ${PKGNAME}-${VERSION}${PKGPREFIX}.tar.xz ${PKGNAME}-${VERSION}${PKGPREFIX}.tar >/dev/null 2>/dev/null
	@rm ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar
	@${PERL} -e 'mkdir("${ARCHIVEDIR}");' 2>/dev/null
	@${PERL} -e 'mkdir("${ARCHIVEDIR}/${PKGNAME}-${VERSION}");' 2>/dev/null
	@cp ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz ${ARCHIVEDIR}/${PKGNAME}-${VERSION}
	@cp ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.bz2 ${ARCHIVEDIR}/${PKGNAME}-${VERSION}
	@cp ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.xz ${ARCHIVEDIR}/${PKGNAME}-${VERSION}
	@rm ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz
	@rm ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.bz2
	@rm ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.xz
	@echo "Make installer ${PKGNAME}-${VERSION}${PKGPREFIX}"
	@${SH} ${BUILDDIR}/makeinstaller.sh "${ZIP_7Z}" "${7Z_7Z}" ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}_installer ${VERSION} ${PKGPREFIX} gz shar EUC
#	@${SH} ${BUILDDIR}/makeinstaller.sh "${ZIP_7Z}" "${7Z_7Z}" ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}_installer_gz_uu ${VERSION} ${PKGPREFIX} gz uu EUC
#	@${SH} ${BUILDDIR}/makeinstaller.sh "${ZIP_7Z}" "${7Z_7Z}" ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.bz2 ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}_installer_bz2_b64 ${VERSION} ${PKGPREFIX} bz2 b64 EUC
#	@${SH} ${BUILDDIR}/makeinstaller.sh "${ZIP_7Z}" "${7Z_7Z}" ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.xz ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}_installer_xz_b64 ${VERSION} ${PKGPREFIX} xz b64 EUC

pkgzip:
	@echo "Building ${PKGNAME}-${VERSION}${PKGPREFIX}"
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} 2>/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} ${PKGTYPE} crlf >/dev/null
	@cd ${RELEASE} && ${ZIP_7Z} zip.zip ${PKGNAME}-${VERSION}${PKGPREFIX}/* ${PKGNAME}-${VERSION}${PKGPREFIX}/.htaccess >/dev/null 2>/dev/null
	@${PERL} -e 'mkdir("${ARCHIVEDIR}");' 2>/dev/null
	@${PERL} -e 'mkdir("${ARCHIVEDIR}/${PKGNAME}-${VERSION}");' 2>/dev/null
	@cp ${RELEASE}/zip.zip ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}.zip
	@rm ${RELEASE}/zip.zip

pkgzipupdate:
	@echo "Building ${PKGNAME}-${VERSION}${PKGPREFIX}"
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} 2>/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} ${PKGTYPE} crlf >/dev/null
	@echo "Compress ${PKGNAME}-${VERSION}${PKGPREFIX}.zip"
	@cd ${RELEASE} && ${ZIP_7Z} zip.zip ${PKGNAME}-${VERSION}${PKGPREFIX}/* >/dev/null 2>/dev/null
	@${PERL} -e 'mkdir("${ARCHIVEDIR}");' 2>/dev/null
	@${PERL} -e 'mkdir("${ARCHIVEDIR}/${PKGNAME}-${VERSION}");' 2>/dev/null
	@cp ${RELEASE}/zip.zip ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}.zip
	@rm ${RELEASE}/zip.zip

	@echo "Taping ${PKGNAME}-${VERSION}${PKGPREFIX}-utf8.tar"



clean:
	@echo "Cleaning work directorys"
	@rm -rf ${TEMP} ${RELEASE}

pkgclean:
	@echo "Cleaning Arvhive directorys"
	@rm -rf ${TEMP} ${RELEASE} ${ARCHIVEDIR}


cvsclean:
	@echo "Cleaning CVS tags"
	@for p in `find .|grep CVS`; do rm -rf $${p}; done

BUILDMAKER=${BUILDDIR}/makesampleini.pl \
			${BUILDDIR}/Jcode-convert.pl \
			${BUILDDIR}/lang.pl \
			${BUILDDIR}/getversion.pl \
			${BUILDDIR}/build.mk \
			${BUILDDIR}/build.pl \
			${BUILDDIR}/compactmagic.pl \
			${BUILDDIR}/compressfile.pl \
			${BUILDDIR}/text.pl \
			${BUILDDIR}/makeinstaller.sh \
			${BUILDDIR}/installer.sh \
			${BUILDDIR}/installer2.sh \
			${BUILDDIR}/installer_sub.sh \
			${BUILDDIR}/b64decode.pl \
			${BUILDDIR}/base64.pl \
			${BUILDDIR}/class.JavaScriptPacker.php \
			${BUILDDIR}/example-file.php \
			Makefile

BUILDFILES=sample/pyukiwiki.ini.cgi \
			skin/instag.js \
			skin/instag.css \
			skin/common.en.js skin/common.ja.js \
			skin/passwd.js \
			skin/twitter.js \
			skin/common.sjis.ja.js skin/common.utf8.ja.js \
			lib/File/magic.txt lib/File/magic_compact.txt \
			skin/pyukiwiki.default.css skin/pyukiwiki.print.css \
			sample/mikachan.default.css sample/mikachan.print.css \
			sample/mikachan.default.css.org sample/mikachan.print.css.org \
			sample/mikachan.skin.cgi \
			skin/blosxom.css \
			skin/video.js \
			skin/flowplayer-3.2.6.min.js \
			skin/jquery.js \
			skin/videoresize.js \
			skin/video-js.css \
			skin/ad.css \
			skin/syntaxhighlighter/shAutoloader.js \
			skin/syntaxhighlighter/shBrushAS3.js \
			skin/syntaxhighlighter/shBrushAppleScript.js \
			skin/syntaxhighlighter/shBrushBash.js \
			skin/syntaxhighlighter/shBrushCSharp.js \
			skin/syntaxhighlighter/shBrushColdFusion.js \
			skin/syntaxhighlighter/shBrushCpp.js \
			skin/syntaxhighlighter/shBrushCss.js \
			skin/syntaxhighlighter/shBrushDelphi.js \
			skin/syntaxhighlighter/shBrushDiff.js \
			skin/syntaxhighlighter/shBrushErlang.js \
			skin/syntaxhighlighter/shBrushGroovy.js \
			skin/syntaxhighlighter/shBrushJScript.js \
			skin/syntaxhighlighter/shBrushJava.js \
			skin/syntaxhighlighter/shBrushJavaFX.js \
			skin/syntaxhighlighter/shBrushPerl.js \
			skin/syntaxhighlighter/shBrushPhp.js \
			skin/syntaxhighlighter/shBrushPlain.js \
			skin/syntaxhighlighter/shBrushPowerShell.js \
			skin/syntaxhighlighter/shBrushPython.js \
			skin/syntaxhighlighter/shBrushRuby.js \
			skin/syntaxhighlighter/shBrushSass.js \
			skin/syntaxhighlighter/shBrushScala.js \
			skin/syntaxhighlighter/shBrushSql.js \
			skin/syntaxhighlighter/shBrushVb.js \
			skin/syntaxhighlighter/shBrushXml.js \
			skin/syntaxhighlighter/shCore.css \
			skin/syntaxhighlighter/shCore.js \
			skin/syntaxhighlighter/shThemeDefault.css \
			skin/syntaxhighlighter/shThemeDjango.css \
			skin/syntaxhighlighter/shThemeEclipse.css \
			skin/syntaxhighlighter/shThemeEmacs.css \
			skin/syntaxhighlighter/shThemeFadeToGrey.css \
			skin/syntaxhighlighter/shThemeMDUltra.css \
			skin/syntaxhighlighter/shThemeMidnight.css \
			skin/syntaxhighlighter/shThemeRDark.css

prof:FORCE
	@${PERL} -d:DProf index.cgi >/dev/null 2>/dev/null
	@dprofpp -O 30
	@rm tmon.out

build:FORCE ${BUILDFILES} ${BUILDMAKER}

FORCE:

lib/File/magic.txt: lib/File/magic.txt.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compactmagic.pl lib/File/magic.txt.src>lib/File/magic.txt

lib/File/magic_compact.txt: lib/File/magic.txt.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compactmagic.pl lib/File/magic.txt.src compact>lib/File/magic_compact.txt

skin/common.sjis.ja.js: skin/common.ja.js ${BUILDMAKER}
	${PERL} ${BUILDDIR}/Jcode-convert.pl sjis skin/common.sjis.ja.js skin/common.ja.js

skin/common.utf8.ja.js: skin/common.ja.js ${BUILDMAKER}
	${PERL} ${BUILDDIR}/Jcode-convert.pl utf8 skin/common.utf8.ja.js skin/common.ja.js

sample/pyukiwiki.ini.cgi: pyukiwiki.ini.cgi ${BUILDMAKER}
	${PERL} ${BUILDDIR}/makesampleini.pl > sample/pyukiwiki.ini.cgi

skin/instag.js: skin/instag.js.src ${BUILDMAKER}
	cat skin/instag.js.src skin/jqModal.js.src skin/farbtastic.js.src > tmpjsinstag
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/instag.js tmpjsinstag
	rm tmpjsinstag

skin/instag.css: skin/jqModal.css.src skin/farbtastic.css.src ${BUILDMAKER}
	cat skin/jqModal.css.src skin/farbtastic.css.src > tmpcss
	${PERL} ${BUILDDIR}/compressfile.pl css skin/instag.css tmpcss
	rm tmpcss

skin/passwd.js: skin/passwd.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/passwd.js skin/passwd.js.src

skin/twitter.js: skin/twitter.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js skin/twitter.js skin/twitter.js.src

skin/common.en.js: skin/common.en.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/common.en.js skin/common.en.js.src

skin/common.ja.js: skin/common.ja.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/common.ja.js skin/common.ja.js.src

skin/common.en.js.src: skin/common.lang.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/lang.pl en skin/common.lang.js.src

skin/common.ja.js.src: skin/common.lang.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/lang.pl ja skin/common.lang.js.src

skin/pyukiwiki.default.css: skin/pyukiwiki.default.css.org skin/pyukiwiki.admin.css.org ${BUILDMAKER}
	cat skin/pyukiwiki.default.css.org skin/pyukiwiki.admin.css.org >tmpcsspyukiwikidefault
	${PERL} ${BUILDDIR}/compressfile.pl css skin/pyukiwiki.default.css tmpcsspyukiwikidefault
	rm tmpcsspyukiwikidefault

skin/pyukiwiki.print.css: skin/pyukiwiki.print.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/pyukiwiki.print.css skin/pyukiwiki.print.css.org

skin/blosxom.css: skin/blosxom.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/blosxom.css skin/blosxom.css.org

skin/video-js.css: skin/video-js.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/video-js.css skin/video-js.css.org

skin/videoresize.js: skin/videoresize.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/videoresize.js skin/videoresize.js.src

skin/video.js: skin/video.js.src skin/videoresize.js.src ${BUILDMAKER}
	cat skin/videoresize.js.src skin/video.js.src > tmpjsvideojs
	${PERL} ${BUILDDIR}/compressfile.pl js skin/video.js tmpjsvideojs
	rm tmpjsvideojs

skin/flowplayer-3.2.6.min.js: skin/flowplayer-3.2.6.min.js.src skin/videoresize.js.src ${BUILDMAKER}
	cat skin/videoresize.js.src skin/flowplayer-3.2.6.min.js.src > tmpjsflowplayer
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/flowplayer-3.2.6.min.js tmpjsflowplayer
	rm tmpjsflowplayer

skin/jquery.js: skin/jquery.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/jquery.js skin/jquery.js.src

skin/ad.css: skin/ad.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/ad.css skin/ad.css.org

sample/mikachan.default.css: sample/mikachan.default.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css sample/mikachan.default.css sample/mikachan.default.css.org

sample/mikachan.print.css: sample/mikachan.print.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css sample/mikachan.print.css sample/mikachan.print.css.org

sample/mikachan.skin.cgi: skin/pyukiwiki.skin.cgi ${BUILDMAKER}
	cp skin/pyukiwiki.skin.cgi sample/mikachan.skin.cgi

skin/syntaxhighlighter/shCore.js: skin/syntaxhighlighter/shCore.js.src skin/syntaxhighlighter/XRegExp.js.src ${BUILDMAKER}
	cat skin/syntaxhighlighter/shCore.js.src skin/syntaxhighlighter/XRegExp.js.src > tmpjsshcore
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shCore.js tmpjsshcore
	rm tmpjsshcore

skin/syntaxhighlighter/shAutoloader.js: skin/syntaxhighlighter/shAutoloader.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shAutoloader.js skin/syntaxhighlighter/shAutoloader.js.src

skin/syntaxhighlighter/shBrushAS3.js: skin/syntaxhighlighter/shBrushAS3.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushAS3.js skin/syntaxhighlighter/shBrushAS3.js.src

skin/syntaxhighlighter/shBrushAppleScript.js: skin/syntaxhighlighter/shBrushAppleScript.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushAppleScript.js skin/syntaxhighlighter/shBrushAppleScript.js.src

skin/syntaxhighlighter/shBrushBash.js: skin/syntaxhighlighter/shBrushBash.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushBash.js skin/syntaxhighlighter/shBrushBash.js.src

skin/syntaxhighlighter/shBrushCSharp.js: skin/syntaxhighlighter/shBrushCSharp.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushCSharp.js skin/syntaxhighlighter/shBrushCSharp.js.src

skin/syntaxhighlighter/shBrushColdFusion.js: skin/syntaxhighlighter/shBrushColdFusion.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushColdFusion.js skin/syntaxhighlighter/shBrushColdFusion.js.src

skin/syntaxhighlighter/shBrushCpp.js: skin/syntaxhighlighter/shBrushCpp.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushCpp.js skin/syntaxhighlighter/shBrushCpp.js.src

skin/syntaxhighlighter/shBrushCss.js: skin/syntaxhighlighter/shBrushCss.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushCss.js skin/syntaxhighlighter/shBrushCss.js.src

skin/syntaxhighlighter/shBrushDelphi.js: skin/syntaxhighlighter/shBrushDelphi.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushDelphi.js skin/syntaxhighlighter/shBrushDelphi.js.src

skin/syntaxhighlighter/shBrushDiff.js: skin/syntaxhighlighter/shBrushDiff.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushDiff.js skin/syntaxhighlighter/shBrushDiff.js.src

skin/syntaxhighlighter/shBrushErlang.js: skin/syntaxhighlighter/shBrushErlang.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushErlang.js skin/syntaxhighlighter/shBrushErlang.js.src

skin/syntaxhighlighter/shBrushGroovy.js: skin/syntaxhighlighter/shBrushGroovy.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushGroovy.js skin/syntaxhighlighter/shBrushGroovy.js.src

skin/syntaxhighlighter/shBrushJScript.js: skin/syntaxhighlighter/shBrushJScript.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushJScript.js skin/syntaxhighlighter/shBrushJScript.js.src

skin/syntaxhighlighter/shBrushJava.js: skin/syntaxhighlighter/shBrushJava.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushJava.js skin/syntaxhighlighter/shBrushJava.js.src

skin/syntaxhighlighter/shBrushJavaFX.js: skin/syntaxhighlighter/shBrushJavaFX.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushJavaFX.js skin/syntaxhighlighter/shBrushJavaFX.js.src

skin/syntaxhighlighter/shBrushPerl.js: skin/syntaxhighlighter/shBrushPerl.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushPerl.js skin/syntaxhighlighter/shBrushPerl.js.src

skin/syntaxhighlighter/shBrushPhp.js: skin/syntaxhighlighter/shBrushPhp.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushPhp.js skin/syntaxhighlighter/shBrushPhp.js.src

skin/syntaxhighlighter/shBrushPlain.js: skin/syntaxhighlighter/shBrushPlain.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushPlain.js skin/syntaxhighlighter/shBrushPlain.js.src

skin/syntaxhighlighter/shBrushPowerShell.js: skin/syntaxhighlighter/shBrushPowerShell.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushPowerShell.js skin/syntaxhighlighter/shBrushPowerShell.js.src

skin/syntaxhighlighter/shBrushPython.js: skin/syntaxhighlighter/shBrushPython.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushPython.js skin/syntaxhighlighter/shBrushPython.js.src

skin/syntaxhighlighter/shBrushRuby.js: skin/syntaxhighlighter/shBrushRuby.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushRuby.js skin/syntaxhighlighter/shBrushRuby.js.src

skin/syntaxhighlighter/shBrushSass.js: skin/syntaxhighlighter/shBrushSass.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushSass.js skin/syntaxhighlighter/shBrushSass.js.src

skin/syntaxhighlighter/shBrushScala.js: skin/syntaxhighlighter/shBrushScala.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushScala.js skin/syntaxhighlighter/shBrushScala.js.src

skin/syntaxhighlighter/shBrushSql.js: skin/syntaxhighlighter/shBrushSql.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushSql.js skin/syntaxhighlighter/shBrushSql.js.src

skin/syntaxhighlighter/shBrushVb.js: skin/syntaxhighlighter/shBrushVb.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushVb.js skin/syntaxhighlighter/shBrushVb.js.src

skin/syntaxhighlighter/shBrushXml.js: skin/syntaxhighlighter/shBrushXml.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/syntaxhighlighter/shBrushXml.js skin/syntaxhighlighter/shBrushXml.js.src

skin/syntaxhighlighter/shCore.css: skin/syntaxhighlighter/shCore.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/syntaxhighlighter/shCore.css skin/syntaxhighlighter/shCore.css.src

skin/syntaxhighlighter/shThemeDefault.css: skin/syntaxhighlighter/shThemeDefault.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/syntaxhighlighter/shThemeDefault.css skin/syntaxhighlighter/shThemeDefault.css.src

skin/syntaxhighlighter/shThemeDjango.css: skin/syntaxhighlighter/shThemeDjango.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/syntaxhighlighter/shThemeDjango.css skin/syntaxhighlighter/shThemeDjango.css.src

skin/syntaxhighlighter/shThemeEclipse.css: skin/syntaxhighlighter/shThemeEclipse.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/syntaxhighlighter/shThemeEclipse.css skin/syntaxhighlighter/shThemeEclipse.css.src

skin/syntaxhighlighter/shThemeEmacs.css: skin/syntaxhighlighter/shThemeEmacs.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/syntaxhighlighter/shThemeEmacs.css skin/syntaxhighlighter/shThemeEmacs.css.src

skin/syntaxhighlighter/shThemeFadeToGrey.css: skin/syntaxhighlighter/shThemeFadeToGrey.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/syntaxhighlighter/shThemeFadeToGrey.css skin/syntaxhighlighter/shThemeFadeToGrey.css.src

skin/syntaxhighlighter/shThemeMDUltra.css: skin/syntaxhighlighter/shThemeMDUltra.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/syntaxhighlighter/shThemeMDUltra.css skin/syntaxhighlighter/shThemeMDUltra.css.src

skin/syntaxhighlighter/shThemeMidnight.css: skin/syntaxhighlighter/shThemeMidnight.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/syntaxhighlighter/shThemeMidnight.css skin/syntaxhighlighter/shThemeMidnight.css.src

skin/syntaxhighlighter/shThemeRDark.css: skin/syntaxhighlighter/shThemeRDark.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/syntaxhighlighter/shThemeRDark.css skin/syntaxhighlighter/shThemeRDark.css.src

ftp:
	@echo "Uploading public file mirrorling"
	${PERL} ${BUILDDIR}/ftp.pl
