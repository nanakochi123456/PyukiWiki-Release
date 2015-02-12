# release file makefile for pyukiwiki
# $Id$

all:
	@echo "PyukiWIki ${VERSION} Release Builder"
	@echo "Usage: ${MAKE} [build|prof|release|pkg|cvsupdate|clean|cvsclean]"

version:
	@echo "PyukiWIki ${VERSION}"

pkg:
	@${MAKE} -f ${BUILDDIR}/build.mk cvsclean
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzip PKGTYPE=devel PKGPREFIX="-devel"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzip PKGTYPE=updatedevel PKGPREFIX="-update-devel"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzip PKGTYPE=updatecompact PKGPREFIX="-update-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzip PKGTYPE=update PKGPREFIX="-update-full"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzip PKGTYPE=compact PKGPREFIX="-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzip PKGTYPE=release PKGPREFIX="-full"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=updatecompact PKGPREFIX="-update-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=update PKGPREFIX="-update-full"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=devel PKGPREFIX="-devel"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=updatedevel PKGPREFIX="-update-devel"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=compact PKGPREFIX="-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=release PKGPREFIX="-full"

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

buildrelease:FORCE
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-full"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/ "release" lf >/dev/null

cvsupdate:
	@echo "Updating CVS"
#	@rm -rf ${TEMP} ${RELEASE}
	@${SH} ${BUILDDIR}/cvs.sh init ${CVSDIR}
	@${PERL} -e 'mkdir("${CVSDIR}");' 2>/dev/null
	@${PERL} -e 'mkdir("${CVSDIR}/${CVSNAME}");' 2>/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${CVSDIR}/${CVSNAME} cvs lf
	@${SH} ${BUILDDIR}/cvs.sh update ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh commit ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh init ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh makesums ${CVSDIR} ${CVSNAME}
	@${SH} ${BUILDDIR}/cvs.sh update ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh commit ${CVSDIR}

cvsoverride:
	@echo "Override CVS"
#	@rm -rf ${TEMP} ${RELEASE}
	@${SH} ${BUILDDIR}/cvs.sh init ${CVSDIR}
	@${PERL} -e 'mkdir("${CVSDIR}");' 2>/dev/null
	@${PERL} -e 'mkdir("${CVSDIR}/${CVSNAME}");' 2>/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${CVSDIR}/${CVSNAME} touch lf >/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${CVSDIR}/${CVSNAME} cvs lf >/dev/null
	@${SH} ${BUILDDIR}/cvs.sh update ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh commit ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh init ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh makesums ${CVSDIR} ${CVSNAME}
	@${SH} ${BUILDDIR}/cvs.sh update ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh commit ${CVSDIR}

pkgtgz:
	@echo "Building ${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz"
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} 2>/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} ${PKGTYPE} lf >/dev/null
	@cd ${RELEASE} && ${TAR} ${PKGNAME}-${VERSION}${PKGPREFIX}.tar * >/dev/null 2>/dev/null
#	@cd ${RELEASE} && ${GZIP} ${PKGNAME}-${VERSION}${PKGPREFIX}.tar >/dev/null 2>/dev/null
	@cd ${RELEASE} && ${GZIP_7Z} ${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz ${PKGNAME}-${VERSION}${PKGPREFIX}.tar >/dev/null 2>/dev/null
	@rm ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar
	@${PERL} -e 'mkdir("${ARCHIVEDIR}");' 2>/dev/null
	@${PERL} -e 'mkdir("${ARCHIVEDIR}/${PKGNAME}-${VERSION}");' 2>/dev/null
	@cp ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz ${ARCHIVEDIR}/${PKGNAME}-${VERSION}
	@rm ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz

pkgzip:
	@echo "Building ${PKGNAME}-${VERSION}${PKGPREFIX}.zip"
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} 2>/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} ${PKGTYPE} crlf >/dev/null
#	@cd ${RELEASE} && ${ZIP} zip.zip ${PKGNAME}-${VERSION}${PKGPREFIX}/* >/dev/null 2>/dev/null
	@cd ${RELEASE} && ${ZIP_7Z} zip.zip ${PKGNAME}-${VERSION}${PKGPREFIX}/* >/dev/null 2>/dev/null
	@${PERL} -e 'mkdir("${ARCHIVEDIR}");' 2>/dev/null
	@${PERL} -e 'mkdir("${ARCHIVEDIR}/${PKGNAME}-${VERSION}");' 2>/dev/null
	@cp ${RELEASE}/zip.zip ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}.zip
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
			${BUILDDIR}/compressfile.pl

BUILDFILES=sample/pyukiwiki.ini.cgi \
			skin/instag.js \
			skin/common.en.js skin/common.ja.js \
			skin/twitter.js \
			skin/common.sjis.ja.js skin/common.utf8.ja.js \
			lib/File/magic.txt lib/File/magic_compact.txt \
			skin/pyukiwiki.default.css skin/pyukiwiki.print.css

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
