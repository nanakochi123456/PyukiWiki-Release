#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id: build.pl,v 1.453 2012/01/31 10:11:53 papu Exp $

$DIR=$ARGV[0];
$TYPE=$ARGV[1];
$LF=$ARGV[2];
$CHARSET=$ARGV[3];
$ALLFLG=$ARGV[4];

use Jcode;

$CHARSET="euc" if($CHARSET eq '');

require 'build/text.pl';

$releasepatch="./releasepatch";

$binary_files='(\.(jpg|png|gif|dat|key|zip|sfx)$)|(^unicode\.pl|favicon\.ico$)';

$cvs_ignore='^3A|\.sum$|\.sign$|^cold|^line|^sfdev|74657374|setup.ini.cgi|\.bak$|\.lk$';
$all_ignore='\.sum$|\.sign$|setup.ini.cgi|\.bak$|\.lk$|^kanato';
$common_ignore=$all_ignore . '|^qrcode|^cold|^line|^Google|^sitemaps\.|^xrea|^unicode\.pl|^3A|74657374|^counter2|^popular2|^bookmark|^clipcopy|^exdate|^ad\.|^ad\_edit|^v\.cgi|^playvideo|setup.ini.cgi$';
$release_ignore=$common_ignore . '|^debug|\.pod$|magic_compact\.txt|\.zip|\.src$|\.inc\.js$|\.inc.\.css';
$update_ignore=$common_ignore . '|\.pod$|magic_compact\.txt|\.zip$|\.src$|htaccess|htpasswd';
$compact_ignore='^aguse|^xframe|^google\_analytics|^linktrack|^ck.inc.pl|^ipv6check|^backup|^pcomment|^back|^hr|^navi|^setlinebreak|^yetlist|^slashpage|^qrcode|^lang\.|^topicpath|^setting|^debug|^Jcode|^Jcode\.pm|magic\.txt|\.en\.(js|css|cgi|txt)|^bugtrack|^(fr|no).*\.inc\.pl|^servererror|^server|^sitemap|^showrss|^perlpod|^Pod|^versionlist|^listfrozen|^urlhack|^punyurl|^opml|^HTTP|^Lite\.pm|^OPML|^atom|^ATOM|^search\_fuzzy|^Search\.pm$|^login|^twitter|\.en\.txt$|GZIP|compressbackup|^logs|^smedia|^GZIP';
$compact_ignore.='^lang\_|^hinad|^lirs|^copy';
$releasec_ignore=$common_ignore . $compact_ignore . '|^debug\.inc\.pl|\.pod$|magic\.txt|\.zip|\.src$';
$updatec_ignore=$common_ignore . $compact_ignore. '|^debug\.inc\.pl|\.pod$|magic\.txt|\.zip$|\.src$|htaccess|htpasswd';
#$compact_filter="./build/obfuscator.pl";

if($ALLFLG eq 'all') {
	$devel_ignore=$all_ignore . '|\.zip$';
} else {
	$devel_ignore=$common_ignore . '|\.zip$';
}
$updated_ignore=$common_ignore . '|\.zip$' . '|htaccess|htpasswd';

$ignore_crlfcut='README.txt|DEVEL.txt|COPYRIGHT.txt|COPYRIGHT.ja.txt|\.htaccess|.htpasswd|pyukiwiki.ini.cgi|wiki\/(.+)?\.txt$';
$ignore_codecheck="build.pl";

@release_dirs=(
	"attach:nodata:0777:0644",
	"backup:nodata:0777:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"diff:nodata:0777:0644",
	"info::0777:666",
	"wiki::0777:0666",
	"image::0755:0644",
	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/HTTP::0755:0644",
	"lib/Jcode::0755:0644",
	"lib/Jcode/Unicode::0755:0644",
	"lib/AWS::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"lib/Digest::0755:0644",
	"lib/Digest/Perl::0755:0644",
	"lib/IDNA::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644"
);

@releasec_dirs=(
	"attach:nodata:0777:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"diff:nodata:0777:0644",
	"info::0777:666",
	"wiki::0777:0666",
	"image::0755:0644",
	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644"
);

@update_dirs=(
	"attach:nodata:0777:0644",
	"backup:nodata:0777:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"diff:nodata:0777:0644",
	"info:nodata:0777:666",
	"wiki:nodata:0777:0666",
	"image::0755:0644",
	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/HTTP::0755:0644",
	"lib/Jcode::0755:0644",
	"lib/Jcode/Unicode::0755:0644",
	"lib/AWS::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"lib/Digest::0755:0644",
	"lib/Digest/Perl::0755:0644",
	"lib/IDNA::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644",
);

@updatec_dirs=(
	"attach:nodata:0777:0644",
	"backup:nodata:0777:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"diff:nodata:0777:0644",
	"info:nodata:0777:666",
	"wiki:nodata:0777:0666",
	"image::0755:0644",
	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644",
);

@devel_dirs=(
	"attach:nodata:0777:0644",
	"backup:nodata:0777:0644",
	"build::0755:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"diff:nodata:0777:0644",
	"info::0777:666",
	"wiki::0777:0666",
	"image::0755:0644",
	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/HTTP::0755:0644",
	"lib/Jcode::0755:0644",
	"lib/Jcode/Unicode::0755:0644",
	"lib/AWS::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"lib/IDNA::0755:0644",
	"lib/Digest::0755:0644",
	"lib/Digest/Perl::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644",
	"releasepatch::0755:0644",
#	"releasepatch/attach:nodata:0777:0644",
#	"releasepatch/build::0755:0644",
#	"releasepatch/cache:nodata:0777:0644",
#	"releasepatch/counter:nodata:0777:0644",
#	"releasepatch/diff:nodata:0777:0644",
	"releasepatch/info::0777:666",
	"releasepatch/wiki::0777:0666",
#	"releasepatch/image::0755:0644",
#	"releasepatch/image/face::0755:0644",
#	"releasepatch/lib::0755:0644",
#	"releasepatch/lib/Algorithm::0755:0644",
#	"releasepatch/lib/Jcode::0755:0644",
#	"releasepatch/lib/Jcode/Unicode::0755:0644",
#	"releasepatch/lib/Nana::0755:0644",
#	"releasepatch/lib/Yuki::0755:0644",
#	"releasepatch/lib/Digest::0755:0644",
#	"releasepatch/plugin::0755:0644",
#	"releasepatch/resource::0755:0644",
#	"releasepatch/sample::0755:0644",
#	"releasepatch/skin::0755:0644"
);

@updated_dirs=(
	"attach:nodata:0777:0644",
	"backup:nodata:0777:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"diff:nodata:0777:0644",
	"info:nodata:0777:666",
	"wiki:nodata:0777:0666",
	"image::0755:0644",
	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/HTTP::0755:0644",
	"lib/Jcode::0755:0644",
	"lib/Jcode/Unicode::0755:0644",
	"lib/AWS::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"lib/IDNA::0755:0644",
	"lib/Digest::0755:0644",
	"lib/Digest/Perl::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644",
	"releasepatch::0755:0644",
#	"releasepatch/attach:nodata:0777:0644",
#	"releasepatch/build::0755:0644",
#	"releasepatch/cache:nodata:0777:0644",
#	"releasepatch/counter:nodata:0777:0644",
#	"releasepatch/diff:nodata:0777:0644",
#	"releasepatch/info::0777:666",
#	"releasepatch/wiki::0777:0666",
#	"releasepatch/image::0755:0644",
#	"releasepatch/image/face::0755:0644",
#	"releasepatch/lib::0755:0644",
#	"releasepatch/lib/Algorithm::0755:0644",
#	"releasepatch/lib/Jcode::0755:0644",
#	"releasepatch/lib/Jcode/Unicode::0755:0644",
#	"releasepatch/lib/Nana::0755:0644",
#	"releasepatch/lib/Yuki::0755:0644",
#	"releasepatch/lib/Digest::0755:0644",
#	"releasepatch/plugin::0755:0644",
#	"releasepatch/resource::0755:0644",
#	"releasepatch/sample::0755:0644",
#	"releasepatch/skin::0755:0644"
);

@cvs_dirs=@devel_dirs;

@release_files=(
	".htaccess:0644",
	".htpasswd:0644",
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"favicon.ico:0644",
	"README.txt:0644",
);

@releasec_files=(
	".htaccess:0644",
	".htpasswd:0644",
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"favicon.ico:0644",
	"README.txt:0644",
);

@update_files=(
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"README.txt:0644",
);

@updatec_files=(
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"README.txt:0644",
);

@devel_files=(
	".htaccess:0644",
	".htpasswd:0644",
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"favicon.ico:0644",
	"Makefile:0644",
	"README.txt:0644",
	"DEVEL.txt:0644",
	"v.cgi:0755",	# for mente
);

@develc_files=(
#	".htaccess:0644",
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"favicon.ico:0644",
	"Makefile:0644",
	"README.txt:0644",
	"DEVEL.txt:0644",
	"v.cgi:0755",	# for mente
);

@cvs_files=@devel_files;

if($TYPE eq 'release') {
	@dirs=@release_dirs;
	@files=@release_files;
	$ignore=$release_ignore;
	$checktimestamp=0;
	$debug=0;
	$podcut=1;
	$commentcut=1;
	$touchonly=0;
}elsif($TYPE eq 'compact') {
	@dirs=@releasec_dirs;
	@files=@releasec_files;
	$ignore=$releasec_ignore;
	$checktimestamp=0;
	$debug=0;
	$podcut=1;
	$commentcut=1;
	$touchonly=0;
} elsif($TYPE eq 'update') {
	@dirs=@update_dirs;
	@files=@update_files;
	$ignore=$update_ignore;
	$checktimestamp=0;
	$debug=0;
	$podcut=1;
	$commentcut=1;
	$touchonly=0;
} elsif($TYPE eq 'updatecompact') {
	@dirs=@updatec_dirs;
	@files=@updatec_files;
	$ignore=$updatec_ignore;
	$checktimestamp=0;
	$debug=0;
	$podcut=1;
	$commentcut=1;
	$touchonly=0;
} elsif($TYPE eq 'devel') {
	@dirs=@devel_dirs;
	@files=@devel_files;
	$ignore=$devel_ignore;
	$checktimestamp=0;
	$debug=1;
	$podcut=0;
	$commentcut=0;
	$touchonly=0;
} elsif($TYPE eq 'updatedevel') {
	@dirs=@updated_dirs;
	@files=@develc_files;
	$ignore=$devel_ignore;
	$checktimestamp=0;
	$debug=1;
	$podcut=0;
	$commentcut=0;
	$touchonly=0;
} elsif($TYPE eq 'cvs') {
	@dirs=@cvs_dirs;
	@files=@cvs_files;
	$ignore=$cvs_ignore;
	$checktimestamp=1;
	$debug=1;
	$podcut=0;
	$commentcut=0;
	$touchonly=0;
} elsif($TYPE eq 'touch') {
	@dirs=@devel_dirs;
	@files=@devel_files;
	$ignore=$devel_ignore;
	$touchonly=1;
	$podcut=0;
	$commentcut=0;
	$debug=0;
} else {
	print STDERR "$0:Type not defined\n";
	exit 1;
}
unless($LF eq 'lf' || $LF eq 'crlf') {
	print STDERR  "$0:LF type not defined\n";
	exit 1;
}
unless(-d $DIR) {
	print STDERR  "$0:$DIR is not directory\n";
	exit 1;
}

open(R,"lib/wiki.cgi");
foreach(<R>) {
	if(/^\$\:\:version/) {
		eval  $_ ;
	}
}
close(R);

foreach my $i (0x00 .. 0xFF) {
	$::_urlescape{chr($i)} = sprintf('%%%02x', $i);
	$::_dbmname_encode{chr($i)} = sprintf('%02X', $i);
	$::_dbmname_decode{sprintf('%02X', $i)} = chr($i);
}

&copyfile($DIR,$LF);

sub copyfile {
	my($temp,$filemode)=@_;
	foreach(@dirs) {
		($dir,$_mode,$dir_chmod,$file_chmod)=split(/:/,$_);
		&mkdir("$temp/$dir",$dir_chmod);
		opendir(DIR,"$dir");
		while($file=readdir(DIR)) {
			next if($file=~/CVS/);
			if(! (-d "$dir/$file")) {
				if($_mode eq 'nodata') {
					next if(!($file eq 'index.html' || $file eq '.htaccess'));
				}
				next if($file=~/$ignore/);
				if($file=~/$binary_files/) {
					&copybin($file_chmod,"$dir/$file","$temp/$dir/$file");
				}else{
					if($file=~/\.inc\.cgi$/) {
						$file2=$file;
						$file2=~s/cgi$/pl/g;
					} else {
						$file2=$file;
					}
					&copyascii($file_chmod,"$dir/$file","$temp/$dir/$file2",$filemode);
				}
			}
		}
		closedir(DIR);
	}
	foreach(@files) {
		($file,$file_chmod)=split(/:/,$_);
		&copyascii($file_chmod,$file,"$temp/$file",$filemode);
	}
}


sub shell {
	my($shell)=@_;
	open(PIPE,"$shell|");
	foreach(<PIPE>) {
		print $_;
#		chomp;
	}
	close(PIPE);
}

sub copyascii {
	my($chmod,$old,$new,$filemode)=@_;
	if($touchonly eq 1) {
		&shell("to	uch $old");
		return;
	}

	if($new=~/wiki\// && $new=~/\.txt$/ && $CHARSET eq 'utf8') {
		if($new=~/(.*)\/(.+)?\.txt$/) {
			$path=$1;
			$dbm=&undbmname($2);
			&Jcode::convert($dbm, "utf8");
			$dbm=&dbmname($dbm);
			$new="$path/$dbm.txt";
		}
	}

	return if((stat($old))[9]<(stat($new))[9] && $checktimestamp eq 1);

	print "copy $old $new($chmod ascii)\n";
	&textinit($old,$::version,$filemode,$TYPE,$CHARSET);
	if(-r "$releasepatch/$old") {
		$oldfile="$releasepatch/$old";
	} else {
		$oldfile="$old";
	}

	if($CHARSET eq 'utf8') {
		open(R,"$oldfile");
		$buf="";
		foreach(<R>) {
			$buf.=$_;
		}
		close(R);
		open(W,">utf8.tmp");
		&Jcode::convert($buf, "utf8");
		print W $buf;
		close(W);
		$oldfile="utf8.tmp";
	}
	open(R,"$oldfile");
	open(W,">$new");
	my $cut=0;
	foreach(<R>) {
		chomp;
		if($old!~/$ignore_codecheck/) {
			if(/\=encoding euc-jp/ && $CHARSET eq 'utf8') {
				$_ = '=encoding utf-8';
			}
			if(/\#euc/) {
				next if($CHARSET ne 'euc');
				s/([\s\t])?#euc//g;
			}
			if(/\#utf8/) {
				next if($CHARSET ne 'utf8');
				s/([\s\t])?#utf8//g;
			}
		}
		# for sorceforge url
		s/L\<\@\@CVSURL\@\@(.*)\>/L\<\@\@CVSURL\@\@$1\?view\=log\>/g;

		# for yuicompress direct source
		if(/\@\@yuicompressor\_(.+)\=\"(.+)\"\@\@/) {
			my $mode=$1;
			my $compressfile=$2;
			&shell("perl ./build/compressfile.pl $mode /tmp/compressfile $compressfile nohead");
			open(YUI,"/tmp/compressfile") || die;
			my $yui="";
			foreach(<YUI>) {
				print $yui.=$_;
			}
			close(YUI);
			unlink("/tmp/compressfile");
			s/\@\@yuicompressor\_(.+)\=\"(.+)\"\@\@/$yui/;
		}

		# for compact source (release v0.2.0 ?)
		if($TYPE=~/release/ || $TYPE=~/compact/) {
			if($TYPE=~/compact/) {
				next if(/#nocompact$/);
			} else {
				next if(/#compact$/);
			}
			s/#nocompact$//g;
			s/#compact$//g;
		}
		$cut=1 if(/^\=(head|lang)/);
		if(/^\=cut/) {
			$cut=0;
			next if($podcut eq 1);
		}
		next if($cut eq 1 && $podcut eq 1);
		next if(/nanami\=true/);
		next if(/\#\s{0,3}nanami/);
#		next if(/^#\t/ && $commentcut eq 1 && $old!~/\.ini/);
#		next if(/^#\t/ && $commentcut eq 1 && $old!~/\.ini/);

#		# “à•”ƒR[ƒh•ÏŠ·
#		if($new=~/\.pl$|\.cgi$/ && $new!~/\.ini\.cgi$/) {
#			s/([\x80-\xff])/'\\' . unpack('H2', $1)/eg
#				if(!/#/);
#		}

		if(!/\#\s{0,3}debug/ || /\#([\s\t]+)?comment/ || $debug eq 1) {
			$ii=0;
			if($commentcut eq 1) {
				#s/([\s\t]+)?\#([\s\t]+)?#([\s\t]+)?comment//g;
				if(/^\#.*comment/) {
				#if(/^\#/ && /\#([\s\t]+)?comment$/) {
					$_="";
				}
				if(/\#([\s\t]+)?comment$/) {
					s/([\s\t]+)?\#.*//g;
					s/^\#.*//g;
				}
				s/\t+#.*$//g if($commentcut eq 1 && $old!~/\.ini/);
			} else {
#				s/([\s\t]+)?\#([\s\t]+)?comment$//g;
			}
			s/([\s\t]+)?$//g;
			$s=$_;
			if($s=~/\@\@CVSURL\@\@/) {
				$tmps=$s;
				$tmps=~s!\@\@CVSURL\@\@/PyukiWiki\-Devel/!\@\@CVSURL\@\@/PyukiWiki\-Devel\-UTF8/!g;
				$s.="\n\n$tmps";
			}
			while($s=~/\@\@(.+?)\@\@/) {
				$rep=$1;
				$s=~s/\@\@$rep\@\@/$text{$rep}/g;
				if($filemode eq 'crlf') {
					$s=~s/\x0D\x0A|\x0D|\x0A/\r\n/g;
				} else {
					$s=~s/\x0D\x0A|\x0D|\x0A/\n/g;
				}
				last if($ii++>10);
			}
			while($s=~/\\\@\\\@\\\@(.+?)\\\@\\\@\\\@/) {
				$rep=$1;
				$s=~s/\\\@\\\@\\\@$rep\\\@\\\@\\\@/$text{$rep}/g;
				if($filemode eq 'crlf') {
					$s=~s/\x0D\x0A|\x0D|\x0A/\r\n/g;
				} else {
					$s=~s/\x0D\x0A|\x0D|\x0A/\n/g;
				}
				last if($ii++>10);
			}
			if(!($file=~/\.txt$/ && $s=~/test/) || $debug eq 1) {
				chomp $s;
				if($s ne '' || $commentcut eq 0 || $old=~/$ignore_crlfcut/) {
					$s=&email($s);
					if($filemode eq 'crlf') {
						print W "$s\r\n";
					} else {
						print W "$s\n";
					}
				}
			}
		}
	}
	close(W);
	close(R);
	# for compact
	if(0) {
	if($TYPE=~/compact/ && $new=~/\.pl$|\.cgi$/ && $new!~/\.ini\.cgi$/) {
		open(R,"$new");
		my $all;
		my $head;
		my $flg=0;
		foreach(<R>) {
			if(/^#/ && $flg eq 0) {
				$head.=$_;
			} else {
				$flg++;
				$all.=$_;
			}
		}
		close(R);
		open(W,">tmp");
		print W $all;
		close(W);
		my $out;
		my $path;
		foreach(split(/:/,$ENV{PATH})) {
			$path="$_/perl";
			last if(-x $path && -r $path);
			$path="not found";
		}
		open(PIPE,"$path $compact_filter tmp|");
		foreach(<PIPE>) {
			next if(/^#/ || $_ eq '');
			$out.=$_;
		}
		close(PIPE);
		unlink("tmp");
		open(W,">$new");
		print W $head;
		$out=~s/\_\_DATA\_\_/\n\_\_DATA\_\_\n/g;
		$out=~s/\_\_END\_\_/\n\_\_END\_\_\n/g;
		while($out=~/\n\n/) {
			$out=~s/\n\n/\n/g;
		}
		print W $out;
		close(W);
	}
	}
	chmod(oct($chmod),"$new");
	unlink("utf8.tmp");
}

sub copybin {
	my($chmod,$old,$new)=@_;

	if($touchonly eq 1) {
		&shell("touch $old");
		return;
	}
	return if((stat($old))[9]<(stat($new))[9] && $checktimestamp eq 1);

	print "copy $old $new ($chmod bin)\n";
	$old="$releasepatch/$old"if(-r "$releasepatch/$old");
	&shell("cp $old $new");
	chmod(oct($chmod),"$new");
}

sub mkdir {
	my($dir,$chmod)=@_;
	unless(-d "$dir") {
		print "mkdir $dir ($chmod)\n";
		mkdir($dir);
		chmod(oct($chmod),"$dir");
	}
}


sub email {
	my($s)=@_;
$esc         = '\\\\';               $Period      = '\.';
$space       = '\040';
$OpenBR      = '\[';                 $CloseBR     = '\]';
$NonASCII    = '\x80-\xff';          $ctrl        = '\000-\037';
$CRlist      = '\n\015';
$qtext       = qq/[^$esc$NonASCII$CRlist\"]/;
$dtext       = qq/[^$esc$NonASCII$CRlist$OpenBR$CloseBR]/;
$quoted_pair = qq<${esc}[^$NonASCII]>;
$atom_char   = qq/[^($space)<>\@,;:\".\'$esc$OpenBR$CloseBR$ctrl$NonASCII]/;
$atom        = qq<$atom_char+(?!$atom_char)>;
$quoted_str  = qq<\"$qtext*(?:$quoted_pair$qtext*)*\">;
$word        = qq<(?:$atom|$quoted_str)>;
$domain_ref  = $atom;
$domain_lit  = qq<$OpenBR(?:$dtext|$quoted_pair)*$CloseBR>;
$sub_domain  = qq<(?:$domain_ref|$domain_lit)>;
$domain      = qq<$sub_domain(?:$Period$sub_domain)+>;
$local_part  = qq<$word(?:$Period$word)*>;
$addr_spec   = qq<$local_part\@$domain>;
$mail_regex  = $addr_spec;

	$s=~s!<($mail_regex)>!&emailsub($1)!gex;
	$s=~s!($mail_regex)!&emailsub($1)!gex;
	return $s;
}

sub emailsub {
	my($ss)=@_;
	$ss=~s/\@/ \(at\) /g;
	$ss=~s/\./ \(dot\) /g;
	return "<$ss>";
}

sub dbmname {
	my ($name) = @_;
#	$name =~ s/(.)/uc unpack('H2', $1)/eg;
	$name =~ s/(.)/$::_dbmname_encode{$1}/g;
	return $name;
}

sub undbmname {
	my ($name) = @_;
#	$name =~ s/(.)/uc unpack('H2', $1)/eg;
	$name =~ s/([0-9A-F][0-9A-F])/$::_dbmname_decode{$1}/g;
	return $name;
}

