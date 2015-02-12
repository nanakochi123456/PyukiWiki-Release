######################################################################
# mikachan.skin.cgi - This is PyukiWiki, yet another Wiki clone.
# $Id: mikachan.skin.cgi,v 1.277 2012/03/18 11:23:59 papu Exp $
#
# "PyukiWiki" ver 0.2.0-p3 $$
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
# Return:LF Code=UTF-8 1TAB=4Spaces
######################################################################
# Skin.ja:PyukiWiki標準
# Skin.en:PyukiWiki Default
######################################################################

sub skin {
	my ($pagename, $body, $is_page, $bodyclass, $editable, $admineditable, $basehref, $lastmod) = @_;

	my($page,$message,$errmessage)=split(/\t/,$pagename);
	my $cookedpage = &encode($page);
	my $cookedurl=&make_cookedurl($cookedpage);
	my $escapedpage = &htmlspecialchars($page);
	my $escapedpage_short=$escapedpage;
	$escapedpage_short=~s/^.*\///g if($::short_title eq 1);
	my $HelpPage = &encode($::resource{help});
	my $htmlbody;
	my ($title,$headerbody,$menubarbody,$sidebarbody,$footerbody,$notesbody);

	# CSSの設定
	$csscharset=qq( charset="$::charset");
	if($::use_blosxom eq 1) {
		$::IN_HEAD.=<<EOD;
<link rel="stylesheet" href="$::skin_url/blosxom.css" type="text/css" media="screen"$csscharset />
EOD
	}

	# MenuBar, :Header, :Footer, :BodyHeader, :BodyFooter
	# , :Sidebar, :SkinFooter:のHTML生成
	$::pushedpage = $::form{mypage};	# push;
	if($is_page || $::allview eq 1) {
		$::form{mypage}=$::Header;
		$headerbody=$::headerbody . &print_content($::database{$::Header}, $::form{mypage})
			if(&is_exist_page($::Header));
		$::form{mypage}=$::MenuBar;
		$menubarbody=$::menubarbody . &print_content($::database{$::MenuBar}, $::pushedpage)
			if(&is_exist_page($::MenuBar));
		$::form{mypage}=$::SideBar;
		$sidebarbody=$::sidebarbody . &print_content($::database{$::SideBar}, $::pushedpage)
			if(&is_exist_page($::SideBar));
		$::form{mypage}=$::BodyHeader;
		$bodyheaderbody=$::bodyheaderbody . &print_content($::database{$::BodyHeader}, $::form{mypage})
			if(&is_exist_page($::BodyHeader));
		$::form{mypage}=$::BodyFooter;
		$bodyfooterbody=$::bodyfooterbody . &print_content($::database{$::BodyFooter}, $::form{mypage})
			if(&is_exist_page($::BodyFooter));
		$::form{mypage}=$::Footer;
		$footerbody=$::footerbody . &print_content($::database{$::Footer}, $::form{mypage})
			if(&is_exist_page($::Footer));
	}
	# :TitleHeader
	$::form{mypage}=$::TitleHeader;
	$titleheaderbody=&print_content($::database{$::TitleHeader}, $::form{mypage})
			if(&is_exist_page($::TitleHeader));

	$::form{mypage}=$::pushedpage;	# pop;
	$::pushedpage="";

	# add v 0.1.9
	$skinfooterbody=$::database{$::SkinFooter}
		if(&is_exist_page($::SkinFooter));

	# 注釈HTMLの生成
	if (@::notes) {
		$notesbody.= << "EOD";
<div id="note">
<hr class="note_hr" />
EOD
		my $cnt = 1;
		foreach my $note (@::notes) {
			$notesbody.= << "EOD";
<a id="notefoot_$cnt" href="@{[&make_cookedurl($::form{mypage})]}#notetext_$cnt" class="note_super">*$cnt</a>
@{[$::notesview ne 0 ? qq(<span class="small">) : '']}@{[$note]}@{[$::notesview ne 0 ? qq(</span>) : '']}
<br />
EOD
			$cnt++;
		}
		$notesbody.="</div>\n";
	}


	# changed on v0.2.0 moved on v0.2.0-p2
	# <title>タグの生成
	my($title, $title_tag)=&maketitle($page, $message);

	# HTML <head>丫</head> から、画像リンクまで
	$htmlbody=<<"EOD";
$::dtd
<title>$title_tag</title>
@{[$basehref eq '' ? '' : qq(<base href="$basehref" />)]}
<link rel="stylesheet" href="$::skin_url/$::skin{default_css}" type="text/css" media="screen"$csscharset />
<link rel="stylesheet" href="$::skin_url/$::skin{print_css}" type="text/css" media="print"$csscharset />
@{[$::AntiSpam ne "" ? '' : qq(<link rev="made" href="mailto:$::modifier_mail" />)]}
<link rel="top" href="$::script" />
<link rel="index" href="$::script?cmd=list" />
@{[$::use_SiteMap eq 1 ? qq(<link rel="contents" href="$::script?cmd=sitemap" />) : '']}
<link rel="search" href="$::script?cmd=search" />
<link rel="help" href="$::script?$HelpPage" />
<link rel="author" href="$::modifierlink" />
<meta name="description" content="@{[$::IN_TITLE eq '' ? "$title - $escapedpage" : $::IN_TITLE]}" />
<meta name="author" content="$::modifier" />
<meta name="copyright" content="$::modifier" />
<script type="text/javascript" src="$::skin_url/$::skin{common_js}"$csscharset></script>
$::IN_HEAD</head>
<body class="$bodyclass"$::IN_BODY>
<div id="container">
<div id="head">
<div id="header">
<a href="$::modifierlink"><img id="logo" src="$::logo_url" width="$::logo_width" height="$::logo_height" alt="$::logo_alt" title="$::logo_alt" /></a>
EOD

	# ページタイトル、メッセージの表示
	if($errmessage ne '') {
		$htmlbody.=<<EOD;
<h1 class="error">$errmessage</h1>
EOD
	} elsif($page ne '') {
		$htmlbody.=<<EOD;
@{[$titleheaderbody ne '' ? '<table><td><td class="headermain">' : '']}
<h1 class="title"><a
    title="$::resource{searchthispage}"
    href="$::script?cmd=search&amp;mymsg=$cookedpage">$escapedpage_short</a>@{[$message eq '' ? '' : "&nbsp;$message"]}</h1>
<span class="small">@{[&topicpath($page)]}</span>
@{[$titleheaderbody ne '' ? '</td><td class="headerbody">' . $titleheaderbody . '</td></tr></table>' : '']}
EOD
	} else {
		$htmlbody.=<<EOD;
@{[$titleheaderbody ne '' ? '<table><td><td class="headermain">' : '']}
<h1 class="title">$message</h1>
@{[$titleheaderbody ne '' ? '</td><td class="headerbody">' . $titleheaderbody . '</td></tr></table>' : '']}
EOD
	}

	# ナビゲータの表示
	$htmlbody.=<<EOD;
</div>
<div id="navigator">[
EOD
	my $flg=0;
	foreach $name (@::navi) {
		if($name eq '') {
			$htmlbody.=" ] &nbsp; [ " if($flg ne 0);
			$flg=0;
		} else {
			if($::navi{"$name\_html"} ne '') {
				$htmlbody .= " | " if($flg eq 1 && $name!~/\-nobr/);
				$flg=1;
				$htmlbody.=$::navi{"$name\_html"};
			} elsif($::navi{"$name\_name"} ne '') {
				$htmlbody .= " | " if($flg eq 1 && $name!~/\-nobr/);
				$flg=1;
				$htmlbody.=<<EOD;
<a title="@{[$::navi{"$name\_title"} eq '' ? $::navi{"$name\_name"} : $::navi{"$name\_title"}]}" href="$::navi{"$name\_url"}">$::navi{"$name\_name"}</a>
EOD
			}
		}
	}
	$htmlbody.=<<EOD;
]
</div>
<hr class="full_hr" />
@{[ $::last_modified == 1
  ? qq(<div id="lastmodified">$::lastmod_prompt $lastmod</div>)
  : q()
]}
</div>
EOD

	# table定義
	my $colspan=1;
	$colspan++ if($menubarbody ne '');
	$colspan++ if($sidebarbody ne '');

	$htmlbody.= <<"EOD";
<div id="content">
<table class="content_table" border="0" cellpadding="0" cellspacing="0">
@{[$headerbody ne '' ? qq(<tr><td@{[$colspan ne 1 ? qq( colspan="$colspan") : '']}><div id="headerbody">$headerbody</div></td></tr>) : '']}
  <tr>
EOD

	# MenuBarの表示
	if($menubarbody ne '') {
		$htmlbody.=<<"EOD";
    <td class="menubar" valign="top">
    <div id="menubar">
$menubarbody
    </div>
    </td>
EOD
	}

	# コンテンツの表示
	$htmlbody.= <<"EOD";
    <td class="body" valign="top">
      @{[$bodyheaderbody ne '' ?  qq(<div id="bodyheaderbody">$bodyheaderbody</div>\n) : ""]}<div id="body">$body</div>@{[$::notesview eq 0 ? $notesbody : '']}@{[$bodyfooterbody ne '' ? qq(\n<div id="bodyfooterbody">$bodyfooterbody</div>) : ""]}
    </td>
EOD
	# SideBarの表示
	if($sidebarbody ne '') {
		$htmlbody.=<<"EOD";
    <td class="sidebar" valign="top">
    <div id="sidebar">
$sidebarbody
    </div>
    </td>
EOD
	}

	# 下の表示
	$htmlbody.= << "EOD";
  </tr>
@{[$::notesview eq 1 ? qq(<tr><td@{[$colspan ne 1 ? qq( colspan="$colspan") : '']}>$notesbody</td></tr>) : '']}
@{[$footerbody ne '' ? qq(<tr><td@{[$colspan ne 1 ? qq( colspan="$colspan") : '']}><div id="footerbody">$footerbody</div></td></tr>) : '']}
</table>
EOD

	# 注釈の表示（:Footerの下）
	$htmlbody.=$::notesview eq 2 ? $notesbody : '';

	# アイコン、lastmodified表示
	$htmlbody.= <<"EOD";
</div>
<div id="foot">
<hr class="full_hr" />
<div id="toolbar">
EOD
	if($::toolbar ne 0) {
		foreach $name (@::navi) {
			if($name eq '') {
				$htmlbody.=" &nbsp; ";
			} else {
				if(-f "$image_dir/$name.png") {
					if($::toolbar eq 2 || $::navi{"$name\_height"} ne '') {
						my $height=$::navi{"$name\_height"} eq '' ? 20 : $::navi{"$name\_height"};
						my $width=$::navi{"$name\_width"} eq '' ? 20 : $::navi{"$name\_width"};
						$htmlbody.=<<EOD;
	<a title="@{[$::navi{"$name\_title"} eq '' ? $::navi{"$name\_name"} : $::navi{"$name\_title"}]}" href="$::navi{"$name\_url"}"><img alt="@{[$::navi{"$name\_title"} eq '' ? $::navi{"$name\_name"} : $::navi{"$name\_title"}]}" src="$image_url/$name.png" height="$height" width="$width" /></a>
EOD
					}
				}
			}
		}
	}
	$htmlbody.=<<EOD;
</div>
@{[ $::last_modified == 2
 ? qq(<div id="lastmodified">$::lastmod_prompt $lastmod</div>)
 : qq()
]}
<div id="footer">
EOD

	# ページフッタ wiki文法
	# lang=ja
	if($::lang eq 'ja') {
		$footerbody=<<EOD;
@{[$::wiki_title ne '' ? qq(''[[$::wiki_title>$basehref]]'' ) : '']}Modified by [[$::modifier>$::modifierlink]]~
$skinfooterbody~
''[[PyukiWiki $::version>http://pyukiwiki.sfjp.jp/]]''
Copyright&copy; 2004-2012 by [[Nekyo>http://nekyo.qp.land.to/]], [[PyukiWiki Developers Team>http://pyukiwiki.sfjp.jp/]]
License is [[GPL>http://sfjp.jp/projects/opensource/wiki/GPLv3_Info]], [[Artistic>http://www.opensource.jp/artistic/ja/Artistic-ja.html]]~
Based on "[[YukiWiki>http://www.hyuki.com/yukiwiki/]]" 2.1.0 by [[yuki>http://www.hyuki.com/]]
and [[PukiWiki>http://pukiwiki.sfjp.jp/]] by [[PukiWiki Developers Term>http://pukiwiki.sfjp.jp/]]~
EOD
	} else {
	# lang=en and/or other
		$footerbody=<<EOD;
@{[$::wiki_title ne '' ? qq(''[[$::wiki_title>$basehref]]'' ) : '']}Modified by [[$::modifier>$::modifierlink]]~
$skinfooterbody~
''[[PyukiWiki $::version>http://pyukiwiki.sfjp.jp/]]''
Copyright&copy; 2004-2012 by [[Nekyo>http://nekyo.qp.land.to/]], [[PyukiWiki Developers Team>http://pyukiwiki.sfjp.jp/]]
License is [[GPL>http://www.gnu.org/licenses/gpl.html]], [[Artistic>A]]~
Based on "[[YukiWiki>http://www.hyuki.com/yukiwiki/]]" 2.1.0 by [[yuki>http://www.hyuki.com/]]
and [[PukiWiki>http://pukiwiki.sfjp.jp/]] by [[PukiWiki Developers Term>http://pukiwiki.sfjp.jp/]]~
EOD
	}
	$footerbody= &text_to_html($footerbody);
	$footerbody=~s/(<p>|<\/p>)//g;
	$htmlbody.= $footerbody;

	$htmlbody.= <<"EOD";
@{[&convtime]}
</div>
</div>
</div>
</body>
</html>
EOD
	$htmlbody=~s/\&copy\;/\(C\)/g if($::skin_name eq "mikachan");
	return $htmlbody;
}
1;
