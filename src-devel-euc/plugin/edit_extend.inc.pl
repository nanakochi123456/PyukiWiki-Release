#######################################################################
# edit_extend.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: edit_extend.inc.pl,v 1.23 2012/03/18 11:23:51 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
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

use strict;

$edit_extend::read_instagcss=0;
$edit_extend::read_instagjs=0;
$edit_extend::read_jquery=0;

sub plugin_edit_extend_edit_init {
	%::resource=&read_resource("$::res_dir/edit_extend.$::lang.txt", %::resource);
	if(-r "$::skin_dir/instag.css") {
		$::IN_HEAD.=qq(<link rel="stylesheet" href="$::skin_url/instag.css" type="text/css" media="screen" charset="utf-8" />\n);
		$edit_extend::read_instagcss=1;
	}
	if(-r "$::skin_dir/jquery.js") {
	$::IN_HEAD.=qq(<script type="text/javascript" src="$::skin_url/jquery.js"></script>\n);
		$edit_extend::read_jquery=1;
	}
	if(-r "$::skin_dir/instag.js") {
		$::IN_HEAD.=qq(<script type="text/javascript" src="$::skin_url/instag.js"></script>\n);
		$edit_extend::read_instagjs=1;
	}
}

sub mkextend {
	my($res, $first, $last, $image)=@_;
	$res=$::resource{$res} if($::resource{$res} ne '');
	return <<EOM;
<a title="$res" href="javascript:insTag('$first','$last','$res');">
@{[$image=~/$::image_extention/
	? qq(<img src="$::image_url/$image" alt="$res" border="0" vspace="0" hspace="1" height="14" width="14" />) : $image]}</a>
EOM
}

sub plugin_edit_extend_edit {
	my $body;
	return
		if($edit_extend::read_instagcss eq 0 || $edit_extend::read_instagjs eq 0);
	$body="<div>";

	$body.=&mkextend(
		"edit_plugin_instag_bold", qq(\\'\\'), qq(\\'\\'), "<strong>B</strong>");

	$body.=&mkextend(
		"edit_plugin_instag_italic", qq(\\'\\'\\'), qq(\\'\\'\\'), "<i>I</i>");
	$body.=&mkextend(
		"edit_plugin_instag_underline", '%%%', '%%%', "<ins>U</ins>");
	$body.=&mkextend(
		"edit_plugin_instag_delline", '%%', '%%', "<del>D</del>");
	$body.=&mkextend(
		"edit_plugin_instag_list_ul", '\\n-', '', "list_ex.png");
	$body.=&mkextend(
		"edit_plugin_instag_list_ol", '\\n+' ,'', "numbered.png");
	$body.=&mkextend(
		"edit_plugin_instag_list_center", '\\nCENTER:','\n', "center.png");
	$body.=&mkextend(
		"edit_plugin_instag_list_left", '\\nLEFT:','\n', "left_just.png");
	$body.=&mkextend(
		"edit_plugin_instag_list_right", '\\nRIGHT:','\n', "right_just.png");
	$body.=&mkextend(
		"edit_plugin_instag_list_head", '\\n*','', "<strong>H1</strong>");
	$body.=&mkextend(
		"edit_plugin_instag_list_head", '\\n**','', "<strong>H2</strong>");
	$body.=&mkextend(
		"edit_plugin_instag_list_wikipage", '[[',']]', "[[]]");
	$body.=&mkextend(
		"edit_plugin_instag_list_link", '[[','&gt;http://]]', "http:://");
	$body.=&mkextend(
		"edit_plugin_instag_list_ref", '#ref(',')', "attach.png");
	$body.=&mkextend(
		"edit_plugin_instag_list_break", '','~\\n', "&lt;BR&gt;");
	$body.=&mkextend(
		"edit_plugin_instag_list_hr", '\\n----\\n','', "<strong>--</strong>");

if(0) {
	$body.=&mkextend(
		"edit_plugin_instag_list_size", '&size(20){','};', "20");
	$body.=&mkextend(
		"edit_plugin_instag_list_size", '&size(30){','};', "30");
	my @csscolorlist=split(/\|/,$::resource{edit_plugin_instag_csscolor});
	foreach(@csscolorlist) {
		my ($name, $code)=split(/\#/,$_);
		$body.=&mkextend(
			$::resource{"edit_plugin_instag_colorname_" . lc $name} ne ''
			? $::resource{"edit_plugin_instag_colorname_" . lc $name} : $name,
			"&color($name){",'};',
			qq(<span style="color:$name;background-color:$name;">&nbsp;&nbsp;</span>));
	}
}
	if($edit_extend::read_jquery) {
		my $teststring=$::resource{edit_plugin_instag_color_title};
		my $teststring2=$::resource{edit_plugin_instag_size_teststring};
		$body.=<<EOD;
<a href="#" onclick="return false;" id="panellink4">
<span style="font-weight: bold;">$::resource{edit_plugin_instag_font_title}</span></a>
<span class="editpanel editfontpanel" id="panelbody4">
EOD
		foreach(split(/,/,$::resource{edit_plugin_instag_fontlist})) {
			$body.=<<EOD;
<script type="text/javascript"><!--
var fontname="@{[$_]}";
//--></script>
<a href="#" onclick="insTag(\'&amp;font(font){\',\'};\',\'font\');return true;" class="jqmClose fontsample" style="font-size:$::resource{edit_plugin_instag_fontlist_samplesize}px; font-family: $_;">
$teststring2 ($_)</a><br />
EOD
		}
		$body.=<<EOD;
</span>
EOD
		$body.=<<EOD;
<a href="#" onclick="return false;" id="panellink3">
<span style="font-weight: bold;">$::resource{edit_plugin_instag_size_title}</span></a>
<span class="editpanel editsizepanel" id="panelbody3">
EOD
		foreach(split(/,/,$::resource{edit_plugin_instag_sizelist})) {
			$body.=<<EOD;
<script type="text/javascript"><!--
var sizename="@{[$_]}px";
//--></script>
<a href="#" onclick="insTag(\'&amp;size(sizename){\',\'};\',\'size\');return false;" class="jqmClose sizesample" style="font-size:@{[$_]}px">
$teststring2 (@{[$_]}px)</a><br />
EOD
		}
		$body.=<<EOD;
</span>
EOD
		$body.=<<EOD;
<a href="#" onclick="return false;" id="panellink1">
<span style="font-weight: bold; color:red;">$teststring</span></a>
<span class="editpanel editcolorpicker" id="panelbody1">
<input type="text" class="colortext" id="panel1" name="panel1" value="#000000" />
<a href="#" onclick="insTag(\'&amp;color(\'+gid(\'editform\').panel1.value+\'){\',\'};\',\'color\');return false;" class="jqmClose"><span id="picker1"></span></a>
</span>
EOD
		$body.=<<EOD;
<a href="#" onclick="return false;" id="panellink2">
<span style="font-weight: bold; color:white; background-color:red;">$teststring</span></a>
<span class="editpanel editcolorpicker" id="panelbody2">
<input type="text" class="colortext" id="panel2" name="panel2" value="#ffffff" />
<a href="#" onclick="insTag(\'&amp;color(,\'+gid(\'editform\').panel2.value+\'){\',\'};\',\'color\');return false;" class="jqmClose"><span id="picker2"></span></a>
</span>
EOD
		if($::usePukiWikiStyle) {
			$body.=<<EOD;
<a href="#" onclick="return false;" id="panellink5">
<span style="font-weight: bold;">$::resource{edit_plugin_instag_face_title}</span></a>
<span class="editpanel editfacepanel" id="panelbody5">
EOD
			foreach(split(/,/,$::resource{edit_plugin_instag_face_list})) {
				my $img=&text_to_html($_);
				$img=~s/<p>//g;
				$img=~s/<\/p>//g;
				$_=~s/\&/\\&amp;/g;
				$body.=<<EOD;
<a href="#" onclick="insTag(\'$_\',\'\',\'\');return false;" class="jqmClose facesample">
$img</a>
EOD
			}
			$body.=<<EOD;
</span>
EOD
		}
	}
	$body.=<<EOD;
</div>
EOD
	return $body;
}
1;
__END__

=head1 NAME

edit_extend.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 none

=head1 DESCRIPTION

Extend Edit module

This is submodule of edit.inc.pl

=head1 SETTING

=head 2 pyukiwiki.ini.cgi

=over 4

=item $::extend_edit

0 - Non use

1 - PyukiWiki Compatible

2 - New PyukiWiki Design

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/edit_extend

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/edit_extend/>

=item PyukiWiki/Plugin/Standard/edit

L<http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/Standard/edit/>

=item PyukiWiki CVS

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/edit_extend.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/edit_extend.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/edit.inc.pl?view=log>

L<http://sfjp.jp/cvs/view/pyukiwiki/PyukiWiki-Devel-UTF8/plugin/edit.inc.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sfjp.jp/>

=back

=head1 LICENSE

=item Nanami

L<http://nanakochi.daiba.cx/> etc...

=cut
