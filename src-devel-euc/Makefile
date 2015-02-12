# release file makefile for pyukiwiki
# $Id: Makefile,v 1.474 2012/03/18 11:23:49 papu Exp $

ARCHIVEDIR=./archive
BUILDDIR=./build
TEMP=./temp
RELEASE=./release

SH?=/usr/local/bin/bash
#SH?=/bin/sh
PERL=perl

TAR="tar cvf"
#ZIP="zip -9 -r"
#GZIP="gzip -9"
#BZIP="bzip2 -9"
#XZ="xz -9"

# vv use this...
GZIP_7Z="7za a -tgzip -mx9 -mpass=10 -mfb=256"
BZIP2_7Z="7za a -tbzip2 -mx9 -mpass=10 -md=100m"
XZ_7Z="7za a -txz -mx9 -m0=BCJ2 -m1=LZMA:d23"
ZIP_7Z="7za a -tzip -mx9 -mpass=10 -mfb=256"
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

buildall:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} buildall VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR} \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} BZIP2_7Z=${BZIP2_7Z} XZ_7Z=${XZ_7Z} \
		ZIP_7Z=${ZIP_7Z} 7Z_7Z=${7Z_7Z}

buildallutf8:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} buildallutf8 VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR}  \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} BZIP2_7Z=${BZIP2_7Z} XZ_7Z=${XZ_7Z} \
		ZIP_7Z=${ZIP_7Z} 7Z_7Z=${7Z_7Z}

builddevel:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} builddevel VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR}  \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} BZIP2_7Z=${BZIP2_7Z} XZ_7Z=${XZ_7Z} \
		ZIP_7Z=${ZIP_7Z} 7Z_7Z=${7Z_7Z}

builddevelutf8:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} builddevelutf8 VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR}  \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} BZIP2_7Z=${BZIP2_7Z} XZ_7Z=${XZ_7Z} \
		ZIP_7Z=${ZIP_7Z} 7Z_7Z=${7Z_7Z}

buildrelease:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	${MAKE} buildrelease VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR}  \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} BZIP2_7Z=${BZIP2_7Z} XZ_7Z=${XZ_7Z} \
		ZIP_7Z=${ZIP_7Z} 7Z_7Z=${7Z_7Z}

buildreleaseutf8:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} buildreleaseutf8 VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR}  \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} BZIP2_7Z=${BZIP2_7Z} XZ_7Z=${XZ_7Z} \
		ZIP_7Z=${ZIP_7Z} 7Z_7Z=${7Z_7Z}

buildcompact:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} buildcompact VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR}  \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} BZIP2_7Z=${BZIP2_7Z} XZ_7Z=${XZ_7Z} \
		ZIP_7Z=${ZIP_7Z} 7Z_7Z=${7Z_7Z}

buildcompactutf8:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} buildcompactutf8 VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR}  \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} BZIP2_7Z=${BZIP2_7Z} XZ_7Z=${XZ_7Z} \
		ZIP_7Z=${ZIP_7Z} 7Z_7Z=${7Z_7Z}

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
