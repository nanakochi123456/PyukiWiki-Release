#!/usr/bin/perl
# ncftp mirroring for pyukiwiki
# $Id: ftp.pl,v 1.11 2012/03/18 11:23:55 papu Exp $

# format
# local-folder \t servername \t username \t password \t directory \t url
$PASSFILE="../../ftppass";

&mkdir;
&copy;
&ftp;

sub mkdir {
	&shell("mkdir pyukiwiki 1>/dev/null 2>/dev/null");
	&shell("mkdir pyukiwiki/image 1>/dev/null 2>/dev/null");
	&shell("mkdir pyukiwiki/font 1>/dev/null 2>/dev/null");
	&shell("mkdir pyukiwiki/skin-plala 1>/dev/null 2>/dev/null");
	&shell("mkdir pyukiwiki/skin-vector 1>/dev/null 2>/dev/null");
	&shell("mkdir pyukiwiki/skin-geocities 1>/dev/null 2>/dev/null");
	&shell("mkdir pyukiwiki/skin-sakura 1>/dev/null 2>/dev/null");
	&shell("mkdir pyukiwiki/skin-tok2 1>/dev/null 2>/dev/null");
}

sub copy {
	&shell("cp -pR font pyukiwiki/font");
	&shell("cp -pR release/pyukiwiki*-devel/image/* pyukiwiki/image");
	&shell("cp -pR release/pyukiwiki*-devel/skin/*.js pyukiwiki/skin-sakura");
	&shell("cp -pR release/pyukiwiki*-devel/skin/*.css pyukiwiki/skin-sakura");
	&shell("cp -pR release/pyukiwiki*-devel/sample/*.css pyukiwiki/skin-sakura");
	&shell("cp -pR release/pyukiwiki*-devel/skin/*.js pyukiwiki/skin-plala");
	&shell("cp -pR release/pyukiwiki*-devel/skin/*.css pyukiwiki/skin-plala");
	&shell("cp -pR release/pyukiwiki*-devel/sample/*.css pyukiwiki/skin-plala");
	&shell("cp -pR release/pyukiwiki*-devel/skin/*.js pyukiwiki/skin-geocities");
	&shell("cp -pR release/pyukiwiki*-devel/skin/*.css pyukiwiki/skin-geocities");
	&shell("cp -pR release/pyukiwiki*-devel/sample/*.css pyukiwiki/skin-geocities");
	&shell("cp -pR release/pyukiwiki*-devel/skin/*.js pyukiwiki/skin-vector");
	&shell("cp -pR release/pyukiwiki*-devel/skin/*.css pyukiwiki/skin-vector");
	&shell("cp -pR release/pyukiwiki*-devel/sample/*.css pyukiwiki/skin-vector");
	&shell("cp -pR release/pyukiwiki*-devel/skin/*.js pyukiwiki/skin-tok2");
	&shell("cp -pR release/pyukiwiki*-devel/skin/*.css pyukiwiki/skin-tok2");
	&shell("cp -pR release/pyukiwiki*-devel/sample/*.css pyukiwiki/skin-tok2");


	open(R, $PASSFILE) || die "$PASSFILE not found";
	foreach(<R>) {
		chomp;
		my($orgfolder, $folder, $server, $user, $pass, $dir, $url, $editurl)=split(/\t/, $_);
		next if($editurl eq '');
		opendir(DIR,"pyukiwiki/$folder");
		while($file=readdir(DIR)) {
			next if($file!~/\.css$/);
			open(DATA, "pyukiwiki/$folder/$file");
			$buf="";
			foreach(<DATA>) {
				$buf.=$_;
			}
			close(DATA);
			$regex=$editurl;
			$regex=~s/\./\./g;
			$regex=~s/\//\//g;
			$buf=~s/url\(\'\.\//url\(\'$regex/g;
			open(DATA, ">pyukiwiki/$folder/$file");
			print DATA $buf;
			close(DATA);
		}
	}
	close(R);
}

sub ftp {
	open(R, $PASSFILE) || die "$PASSFILE not found";
	foreach(<R>) {
		chomp;
		my($orgfolder, $folder, $server, $user, $pass, $dir, $url, $editurl)=split(/\t/, $_);
		$pipe="chdir $orgfolder; ncftpput -R -u $user -p $pass $server $dir *|";
		print "$pipe\n";
		open(PIPE, $pipe) || die "$pipe error";
		foreach(<PIPE>) {
			print $_;
		}
	close(PIPE);
	}
	close(R);
}

sub shell {
	my($shell)=@_;
	open(PIPE,"$shell|");
	foreach(<PIPE>) {
		chomp;
	}
	close(PIPE);
}
