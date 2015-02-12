# release file makefile for pyukiwiki
# $Id: Makefile,v 1.316 2011/12/31 13:06:08 papu Exp $

ARCHIVEDIR=./archive
BUILDDIR=./build
TEMP=./temp
RELEASE=./release

SH?=/usr/local/bin/bash
#SH?=/bin/sh
PERL=perl

ZIP="zip -9 -r"
TAR="tar cvf"
GZIP="gzip -9"

# vv use this...
GZIP_7Z="7za a -tgzip -mx9"
ZIP_7Z="7za a -tzip -mx9"
#GZIP_7Z="7za a -tgzip"
#ZIP_7Z="7za a -tzip"

PKGNAME=pyukiwiki

all:
	@${MAKE} all VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR} \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} ZIP_7Z=${ZIP_7Z}

clean:
	@${MAKE} clean VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} PERL=${PERL}
cvsclean:
	@${MAKE} cvsclean VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} PERL=${PERL}
build:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}

buildrelease:FORCE
	@${MAKE} buildrelease VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR} \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME}


builddevel:FORCE
	@${MAKE} builddevel VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR} \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME}


buildcompact:FORCE
	@${MAKE} buildcompact VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR} \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME}


prof:FORCE
	@${MAKE} prof VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}

version:FORCE
	@${MAKE} version VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}

FORCE:

pkg:
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} pkg VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR}  \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} ZIP_7Z=${ZIP_7Z}

release:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} release VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR}  \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} ZIP_7Z=${ZIP_7Z}

releasedevel:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} releasedevel VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR}  \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} ZIP_7Z=${ZIP_7Z}
