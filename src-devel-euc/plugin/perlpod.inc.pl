######################################################################
# perlpod.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: perlpod.inc.pl,v 1.424 2012/01/31 10:11:58 papu Exp $
#
# "PyukiWiki" version 0.2.0-p1 $$
# Author: Nanami http://nanakochi.daiba.cx/
# Copyright (C) 2004-2012 Nekyo
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2012 PyukiWiki Developers Team
# http://pyukiwiki.sfjp.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sfjp.jp/
# License: GPL3 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################

use Nana::Pod2Wiki;
use strict;

require "$::plugin_dir/contents.inc.pl";

sub plugin_perlpod_action {
	my $file;
	$file=$::form{file};
	return if($file=~/\.\./ || $file=~/^\// || $file=~/[|><%'"]/);
	return('msg'=>"\t$::$file"
		,'body'=>&perlpod($file
						, $::form{notitle} ne '' ? "notitle" : ""
						, $::form{source} ne '' ? 1 : 0));
}
#%>	# for hidemaru										# comment

sub plugin_perlpod_convert {
	my $file;
	my($file,$notitle,$source)=split(/,/,shift);
	$source+=0;
	return if($file=~/\.\./ || $file=~/^\// || $file=~/[|><%'"]/);
	return(&perlpod($file,$notitle ne '' ? "notitle" : "",$source));
}
#%>	# for hidemaru										# comment

sub getperlpath{
	my $perlpath;
	if(open(R,"$0")) {
		$perlpath=<R>;
		close(R);
		$perlpath=~s/#!//g;
		$perlpath=~s/-//g;
		$perlpath=~s/ //g;
		$perlpath=~s/[\r\n]//g;
		return $perlpath;
	}
	return '';
}

sub perlpod {
	my($file,$notitle,$source)=@_;
	$file=~s/.*\///g;
	my $dir;
	$::interwiki_definition="";
	$::interwiki_definition2="";

	foreach my $dirs($::data_home, $::data_pub, $::explugin_dir, $::plugin_dir
			, $::res_dir, $::skin_dir, $::image_dir) {
		if(-r "$dir/$file") {
			my $html;
			return &perlpod_sub("$dir/$file",$notitle,$source);
		}
	}
	foreach my $dirs($::explugin_dir, $::plugin_dir, $::res_dir, $::skin_dir, $::data_home, $::data_pub) {
		my $ret=&perlpod_sub2($dirs,$file);
		if($ret ne '') {
			return &perlpod_sub($ret,$notitle,$source);
		}
	}
	return("File nod found:$file");
}

my $level=0;

sub perlpod_sub {
	my($file,$notitle,$source)=@_;
	my ($name,$body)=Nana::Pod2Wiki::pod2wiki($file,$notitle);
	my $html;
	my $query=&htmlspecialchars($ENV{QUERY_STRING});
	if($source+0 eq 0) {
		if($notitle eq '') {
			$html=&text_to_html("*$name\n\pod2wikidummycontents\n----\n$body");
			my $contents=&plugin_contents_main("?$query",split(/\n/,"*$name\n\pod2wikidummycontents\n----\n$body"));
			$html=~s!pod2wikidummycontents!$contents!g;
		} else {
			$html.=&plugin_contents_main("?$query",split(/\n/,"$body"));
			$html.=&text_to_html("----\n$body");
		}
	} else {
		if($notitle eq '') {
			$html="*$name\n\#contents\n----\n$body";
		} else {
			$html="#contents\n";
			$html.="----\n$body";
		}
		$html=<<EOM;
<form>
<textarea cols="$::cols" rows="$::rows" name="mymsg">$html</textarea>
</form>
EOM
	}
	$html=~s/\x5/\#/g;
	$html=~s/\x6/\&/g;
	$html=~s/\x4/\:/g;
	return $html;
}

sub perlpod_sub2 {
	my($dir,$file)=@_;

	opendir(DIR,$dir);
	my @files=readdir(DIR);
	closedir(DIR);

	foreach(@files) {
		next if($_ eq '.' || $_ eq '..');
		my $path="$dir/$_";
		return $path if($_ eq $file);
		if(-d $path) {
			$level++;
			return '' if($level > 10);
			my $ret=&perlpod_sub2($path,$file);
			return $ret if($ret ne '');
			$level--;
		}
	}
	return "";
}


1;
__END__

=head1 NAME

perlpod.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=perlpod&file=perl script file or pod file. [&notitle=true] [&source=true]
 #perlpod(perl script file or pod file.)

=head1 DESCRIPTION

View perl document of pod

A directory cannot be specified because of the measure against security.

Automatically Recursive search of the bottom of the directory setup by pyukiwiki.ini.cgi.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/perlpod

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/perlpod/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/perlpod.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/perlpod.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/lib/Nana/Pod2Wiki.pm?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/lib/Nana/Pod2Wiki.pm?view=log>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sfjp.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2012 by Nanami.

Copyright (C) 2005-2012 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
