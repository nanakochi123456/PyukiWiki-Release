# release file makefile for pyukiwiki
# $Id: Makefile,v 1.245 2012/01/31 10:12:00 papu Exp $

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
BZIP="bzip2 -9"
XZ="xz -9"

# vv use this...
GZIP_7Z="7za a -tgzip -mx9"
BZIP2_7Z="7za a -tbzip2 -mx9"
XZ_7Z="7za a -txz -mx9"
ZIP_7Z="7za a -tzip -mx9"
7Z_7Z="7za a -t7z -m1=LZMA:d25:fb255 -m2=LZMA:d19 -m3=LZMA:d19 -mb0:1 -mb0s1:2 -mb0s2:3 -mx"

PKGNAME=pyukiwiki

all:
	@${MAKE} all VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR} \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} BZIP2_7Z=${BZIP2_7Z} XZ_7Z=${XZ_7Z} \
		ZIP_7Z=${ZIP_7Z} 7Z_7Z=${7Z_7Z}

clean:
	@${MAKE} clean VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} PERL=${PERL}
pkgclean:
	@${MAKE} pkgclean VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} PERL=${PERL}
cvsclean:
	@${MAKE} cvsclean VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} PERL=${PERL}
ftp:
	@${MAKE} ftp VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} PERL=${PERL} BUILDDIR=${BUILDDIR}

build:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}

	@${MAKE} buildrelease VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR} \

buildreleaseutf8:FORCE
	@${MAKE} buildreleaseutf8 VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR} \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME}


builddevelutf8:FORCE
	@${MAKE} builddevelutf8 VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR} \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME}


buildcompactutf8:FORCE
	@${MAKE} buildcompactutf8 VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR} \
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
		GZIP_7Z=${GZIP_7Z} BZIP2_7Z=${BZIP2_7Z} XZ_7Z=${XZ_7Z} \
		ZIP_7Z=${ZIP_7Z} 7Z_7Z=${7Z_7Z}

release:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} release VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR}  \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} BZIP2_7Z=${BZIP2_7Z} XZ_7Z=${XZ_7Z} \
		ZIP_7Z=${ZIP_7Z} 7Z_7Z=${7Z_7Z}

releasedevel:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} releasedevel VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR}  \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} BZIP2_7Z=${BZIP2_7Z} XZ_7Z=${XZ_7Z} \
		ZIP_7Z=${ZIP_7Z} 7Z_7Z=${7Z_7Z}
