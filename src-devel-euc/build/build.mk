# release file makefile for pyukiwiki
# $Id: build.mk,v 1.436 2012/01/31 10:11:53 papu Exp $

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
	${PERL} ${BUILDDIR}/Jcode-convert.pl sjis skin/common.sjis.ja.js skin/common.ja.js

skin/common.utf8.ja.js: skin/common.ja.js ${BUILDMAKER}
	${PERL} ${BUILDDIR}/Jcode-convert.pl utf8 skin/common.utf8.ja.js skin/common.ja.js

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

ftp:
	@echo "Uploading public file mirrorling"
	${PERL} ${BUILDDIR}/ftp.pl
