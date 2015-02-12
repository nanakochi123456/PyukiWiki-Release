# release file makefile for pyukiwiki
# $Id: build.mk,v 1.169 2011/12/31 13:06:13 papu Exp $

all:
	@echo "PyukiWIki ${VERSION} Release Builder"
	@echo "Usage: ${MAKE} [build|prof|release|buildrelease|buildreleaseutf8|builddevel|builddevelutf8|buildcompact|buildcompactutf8|pkg|clean|cvsclean]"

version:
	@echo "PyukiWIki ${VERSION}"

pkg:
	@${MAKE} -f ${BUILDDIR}/build.mk cvsclean
	@${MAKE} -f ${BUILDDIR}/build.mk pkgziputf8 PKGTYPE=devel PKGPREFIX="-devel"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgziputf8 PKGTYPE=updatedevel PKGPREFIX="-update-devel"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgziputf8 PKGTYPE=updatecompact PKGPREFIX="-update-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgziputf8 PKGTYPE=update PKGPREFIX="-update-full"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgziputf8 PKGTYPE=compact PKGPREFIX="-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgziputf8 PKGTYPE=release PKGPREFIX="-full"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgzutf8 PKGTYPE=updatecompact PKGPREFIX="-update-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgzutf8 PKGTYPE=update PKGPREFIX="-update-full"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgzutf8 PKGTYPE=devel PKGPREFIX="-devel"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgzutf8 PKGTYPE=updatedevel PKGPREFIX="-update-devel"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgzutf8 PKGTYPE=compact PKGPREFIX="-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgzutf8 PKGTYPE=release PKGPREFIX="-full"

release:FORCE
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-full-utf8 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-update-utf8 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-compact-utf8 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-update-compact-utf8 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-devel-utf8 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-update-devel-utf8 2>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-full-utf8"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-full-utf8 "release" lf utf8 >/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-compact-utf8"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-compact-utf8 "compact" lf utf8 >/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-update-utf8"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-update-utf8 "update" lf utf8 >/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-update-compact-utf8"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-update-compact-utf8 "updatecompact" lf utf8 >/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-devel-utf8"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-devel-utf8 "devel" lf utf8 >/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-update-devel-utf8"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-update-devel-utf8  "updatedevel" lf utf8 >/dev/null


releasedevel:FORCE
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-devel-utf8 2>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-devel-utf8 all plugin"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-devel-utf8 "devel" lf utf8  all >/dev/null


builddevelutf8:FORCE
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-devel-utf8"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/ "devel" lf utf8 >/dev/null


buildreleaseutf8:FORCE
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-full-utf8"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/ "release" lf utf8 >/dev/null


buildcompactutf8:FORCE
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-compact-utf8"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/ "compact" lf utf8 >/dev/null



pkgtgzutf8:
	@echo "Building ${PKGNAME}-${VERSION}${PKGPREFIX}-utf8.tar.gz"
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}-utf8 2>/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}-utf8 ${PKGTYPE} lf utf8 >/dev/null
	@cd ${RELEASE} && ${TAR} ${PKGNAME}-${VERSION}${PKGPREFIX}-utf8.tar * >/dev/null 2>/dev/null
#	@cd ${RELEASE} && ${GZIP} ${PKGNAME}-${VERSION}${PKGPREFIX}-utf8.tar >/dev/null 2>/dev/null
	@cd ${RELEASE} && ${GZIP_7Z} ${PKGNAME}-${VERSION}${PKGPREFIX}-utf8.tar.gz ${PKGNAME}-${VERSION}${PKGPREFIX}-utf8.tar >/dev/null 2>/dev/null
	@rm ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}-utf8.tar
	@${PERL} -e 'mkdir("${ARCHIVEDIR}");' 2>/dev/null
	@${PERL} -e 'mkdir("${ARCHIVEDIR}/${PKGNAME}-${VERSION}");' 2>/dev/null
	@cp ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}-utf8.tar.gz ${ARCHIVEDIR}/${PKGNAME}-${VERSION}
	@rm ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}-utf8.tar.gz

pkgziputf8:
	@echo "Building ${PKGNAME}-${VERSION}${PKGPREFIX}-utf8.zip"
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}-utf8 2>/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}-utf8 ${PKGTYPE} crlf utf8>/dev/null
#	@cd ${RELEASE} && ${ZIP} zip.zip ${PKGNAME}-${VERSION}${PKGPREFIX}/* >/dev/null 2>/dev/null
	@cd ${RELEASE} && ${ZIP_7Z} zip.zip ${PKGNAME}-${VERSION}${PKGPREFIX}-utf8/* >/dev/null 2>/dev/null
	@${PERL} -e 'mkdir("${ARCHIVEDIR}");' 2>/dev/null
	@${PERL} -e 'mkdir("${ARCHIVEDIR}/${PKGNAME}-${VERSION}");' 2>/dev/null
	@cp ${RELEASE}/zip.zip ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}-utf8.zip
	@rm ${RELEASE}/zip.zip

clean:
	@echo "Cleaning work directorys"
	@rm -rf ${TEMP} ${RELEASE}

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
			Makefile

BUILDFILES=sample/pyukiwiki.ini.cgi \
			skin/instag.js \
			skin/common.en.js skin/common.ja.js \
			skin/passwd.js \
			skin/twitter.js \
			skin/common.sjis.ja.js skin/common.utf8.ja.js \
			lib/File/magic.txt lib/File/magic_compact.txt \
			skin/pyukiwiki.default.css skin/pyukiwiki.print.css \
			sample/mikachan.default.css sample/mikachan.print.css \
			sample/mikachan.default.css.org sample/mikachan.print.css.org \
			sample/mikachan.skin.cgi \
			skin/blosxom.css

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
	${PERL} ${BUILDDIR}/Jcode-convert.pl sjis skin/common.ja.js skin/common.sjis.ja.js

skin/common.utf8.ja.js: skin/common.ja.js ${BUILDMAKER}
	${PERL} ${BUILDDIR}/Jcode-convert.pl utf8 skin/common.ja.js skin/common.utf8.ja.js

sample/pyukiwiki.ini.cgi: pyukiwiki.ini.cgi ${BUILDMAKER}
	${PERL} ${BUILDDIR}/makesampleini.pl > sample/pyukiwiki.ini.cgi

skin/instag.js: skin/instag.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js skin/instag.js skin/instag.js.src

skin/passwd.js: skin/passwd.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js skin/passwd.js skin/passwd.js.src

skin/twitter.js: skin/twitter.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js skin/twitter.js skin/twitter.js.src

skin/common.en.js: skin/common.en.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js skin/common.en.js skin/common.en.js.src

skin/common.ja.js: skin/common.ja.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js skin/common.ja.js skin/common.ja.js.src

skin/common.en.js.src: skin/common.lang.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/lang.pl en skin/common.lang.js.src

skin/common.ja.js.src: skin/common.lang.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/lang.pl ja skin/common.lang.js.src

skin/pyukiwiki.default.css: skin/pyukiwiki.default.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/pyukiwiki.default.css skin/pyukiwiki.default.css.org

skin/pyukiwiki.print.css: skin/pyukiwiki.print.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/pyukiwiki.print.css skin/pyukiwiki.print.css.org

skin/blosxom.css: skin/blosxom.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/blosxom.css skin/blosxom.css.org

sample/mikachan.default.css: sample/mikachan.default.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css sample/mikachan.default.css sample/mikachan.default.css.org

sample/mikachan.print.css: sample/mikachan.print.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css sample/mikachan.print.css sample/mikachan.print.css.org

sample/mikachan.skin.cgi: skin/pyukiwiki.skin.cgi ${BUILDMAKER}
	cp skin/pyukiwiki.skin.cgi sample/mikachan.skin.cgi
