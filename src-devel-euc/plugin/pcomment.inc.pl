######################################################################
# pcomment.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: pcomment.inc.pl,v 1.4 2006/03/17 14:00:10 papu Exp $
#
# "PyukiWiki" version 0.1.6 $$
# Author: Nanami http://lineage.netgamers.jp/
# Copyright (C) 2004-2006 by Nekyo.
# http://nekyo.hp.infoseek.co.jp/
# Copyright (C) 2005-2006 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################

use strict;

use Digest::MD5;
#use Digest::Perl::MD5;

# ������������Υե����ޥå�
$pcomment::format = "\x08MSG\x08 -- \x08NAME\x08 \x08NOW\x08"
	if(!defined($pcomment::format));

# ̾���ʤ��ǽ������ʤ�
$pcomment::noname = 1
	if(!defined($pcomment::noname));

# ��ʸ�����ܤ���Ƥ��ʤ���票�顼
$pcomment::nodata = 1
	if(!defined($pcomment::nodata));

# �����ȤΥƥ����ȥ��ꥢ��ɽ���� 
$pcomment::size_msg = 40
	if(!defined($pcomment::size_name));

# �����Ȥ�̾���ƥ����ȥ��ꥢ��ɽ���� 
$pcomment::size_name = 10
	if(!defined($pcomment::size_name));

# �����Ȥ�̾�������ե����ޥå�
$pcomment::format_name = "\'\'[[\$1>$::resource{profile_page}/\$1]]\'\'"
	if(!defined($pcomment::format_name));

# �����Ȥ���������ե����ޥå�
$pcomment::format_msg = q{$1}
	if(!defined($pcomment::format_msg));

# �����Ȥ����������ե����ޥå� (&new ��ǧ���Ǥ��뤳��)
$pcomment::format_now = "Y-m-d(lL) H:i:s"
	if(!defined($pcomment::format_now));

# �ǥե���ȤΥ����ȥڡ���
$pcomment::comment_page = "$::resource{comment_page}/\$1"
	if(!defined($pcomment::comment_page));

# �ǥե���Ȥκǿ�������ɽ����
$pcomment::num_comments = 10
	if(!defined($pcomment::num_comments));

# �������Ƥ�1:above(��Ƭ)/0:below(����)�Τɤ�����������뤫
$pcomment::direction_default=1
	if(!defined($pcomment::direction_default));

# 0:���ʤ�/1:���֥ڡ����Υ����ॹ����׹���/2:�����ȥڡ����Υ����ॹ����׹���/3:ξ��
$pcomment::timestamp=2
	if(!defined($pcomment::timestamp));

# 0:�񤭹��߸女���ȥڡ��������/1:�񤭹��߸����֥ڡ��������
$pcomment::viewcommentpage=1
	if(!defined($pcomment::viewcommentpage));

# 1:�����ȥڡ�����������������뤷�����֤ˤ��Ƥ����ʥե����फ��Ͻ񤭹��߲�ǽ�Ǥ���
$pcomment::frozencommentpage=1
	if(!defined($pcomment::frozencommentpage));

sub plugin_pcomment_action {

	if (($::form{mymsg} =~ /^\s*$/ && $pcomment::nodata eq 1)
	 || ($::form{myname} =~ /^\s*$/ && $pcomment::noname eq 1)
		&& $::form{noname} eq '') {
		return('msg'=>"$::form{mypage}\t\t$::resource{pcomment_plugin_err}",'body'=>&text_to_html($::database{$::form{mypage}}),'ispage'=>1);
	}

	# �����ȹԤ�����
	my $datestr = ($::form{nodate} == 1) ? '' : &date($pcomment::format_now);
	my $__name=$pcomment::format_name;
	$__name=~s/\$1/$::form{myname}/g;
	my $_name = $::form{myname} ? " $__name : " : " ";
	my $_msg=$pcomment::format_msg;
	$_msg=~s/\$1/$::form{mymsg}/g;
	my $_now = "&new{$datestr};";

	my $pcomment = $pcomment::format;
	$pcomment =~ s/\x08MSG\x08/$_msg/;
	$pcomment =~ s/\x08NAME\x08/$_name/;
	$pcomment =~ s/\x08NOW\x08/$_now/;
	$pcomment = "-" . $pcomment;

	# �����ȥڡ����β���
	my ($i, @pcomments)=&plugin_pcomment_get($::form{page},0,$::form{above});
	if($::form{reply} eq '') {
		if($::form{above}) {
			push(@pcomments,$pcomment);
		} else {
			unshift(@pcomments,$pcomment);
		}
	} else {
		my @tmp=();
		foreach(@pcomments) {
			push(@tmp,$_);
			if($::form{reply} eq Digest::MD5::md5_hex($_)) {
				if(/^--/) {
					push(@tmp,"--" . $pcomment);
				} elsif(/^-/) {
					push(@tmp,"-" . $pcomment);
				} else {
					push(@tmp,$pcomment);
				}
			}
		}
		@pcomments=@tmp;
	}
	# ���
	my $postdata=join("\n"
		, sprintf($::resource{pcomment_plugin_commentpage_title},$::form{mypage})
		, sprintf($::resource{pcomment_plugin_commentpage_backlink},$::form{mypage},$::form{mypage})
		, @pcomments);

	# �����ȥڡ���������¸�ߤ��ʤ����Τߡ�
	if($pcomment::frozencommentpage eq 1) {
		if(&get_info($::form{page}, $::info_CreateTime)+0 eq 0) {
			&set_info($::form{page}, $::info_IsFrozen, 1);
		}
	}
	if ($::form{mymsg}) {
		# ���ڡ����Υ����ॹ�����
		if($pcomment::timestamp % 2) {
			&set_info($::form{mypage}, $::info_UpdateTime, time);
			&set_info($::form{mypage}, $::info_LastModifiedTime, time);
			&update_recent_changes;
$::debug.="1 $::form{mypage}\n";
		}
		# �����ȥڡ����Υ����ॹ�����
		if(int($pcomment::timestamp / 2)
				|| &get_info($::form{page}, $::info_CreateTime)+0 eq 0) {
			my $pushpage=$::form{mypage};
			&set_info($::form{page}, $::info_UpdateTime, time);
			&set_info($::form{page}, $::info_LastModifiedTime, time);
			if(&get_info($::form{page}, $::info_CreateTime)+0 eq 0) {
				&set_info($::form{page}, $::info_CreateTime, time);
			}
			$::form{mypage}=$::form{page};
			&update_recent_changes;
$::debug.="2 $::form{mypage}\n";
			$::form{mypage}=$pushpage;
		}
		$::form{mymsg} = $postdata;
		undef $::form{mytouch};
		if($pcomment::viewcommentpage eq 1) {
			my $basepage=$::form{mypage};
			$::form{mypage}=$::form{page};
$::debug.="3 $::form{mypage} $basepage\n";
			&do_write("FrozenWrite",$basepage);
		} else {
			$::form{mypage}=$::form{page};
$::debug.="4 $::form{mypage}\n";
			&do_write("FrozenWrite");
		}
	} else {
		$::form{cmd} = 'read';
		&do_read;
	}
	&close_db;
	exit;
}

sub plugin_pcomment_convert {
	my @argv = split(/,/, shift);
	my $noname=0;
	return ' '
		if($::writefrozenplugin eq 0 && &get_info($::form{mypage}, $::info_IsFrozen) eq 1);

	my $above = $pcomment::direction_default;
	my $reply = 0;
	my $nodate = '';
	my $nametags = $::resource{pcomment_plugin_yourname} . qq(<input type="text" name="myname" value="$::name_cookie{myname}" size="$pcomment::size_name" />);

	my $pcomment_page;
	my $pcomment_msgs;

	# ���ץ�������
	foreach (@argv) {
		chomp;
		if (/below/) {
			$above = 0;
		} elsif (/above/) {
			$above = 1;
		} elsif (/nodate/) {
			$nodate = 1;
		} elsif (/reply/) {
			$reply = 1;
		} elsif (/noname/) {
			$nametags = '';
			$noname=1;
		} elsif(/\d{1,4}/) {
			$pcomment_msgs=$_;
		} else {
			$pcomment_page=$_;
		}
	}

	# �ǥե���ȤΥ����ȥڡ��������ꡩ
	if($pcomment_page eq '') {
		$pcomment_page=$pcomment::comment_page;
		$pcomment_page=~s/\$1/$::form{mypage}/g;
	}
	# �ǥե���Ȥ�ɽ���Կ������ꡩ
	if($pcomment_msgs+0 <= 0) {
		$pcomment_msgs = $pcomment::num_comments;
	}

	# �ץ�ӥ塼���륳���Ȥ��ɤ߹���
	my ($i, @pcomments)=&plugin_pcomment_get($pcomment_page,$pcomment_msgs,$above);
	my $pcomment_info;
	my $pcomments;
	if($i eq 0) {
		$pcomments="$::resource{pcomment_plugin_msg_none}<br />\n";
	} else {
		foreach(@pcomments) {
			my $digest=Digest::MD5::md5_hex($_);
			s/^(-{1,2})([^-])/$1\x1$digest\x2$2/g if($reply eq 1);
			$pcomments.="$_\n";
		}
		$pcomments=&text_to_html($pcomments);
		$pcomments=~s/\x1(.+)\x2/<input class="pcmt" type="radio" name="reply" value="$1" \/>/g if($reply eq 1);
		$pcomment_info=&text_to_html(
			sprintf($::resource{pcomment_plugin_msg_recent},$i) . " "
				. "[[$::resource{pcomment_plugin_msg_all}>$pcomment_page]]\n");
	}
	my $conflictchecker = &get_info($pcomment_page, $::info_ConflictChecker);
	my $body=<<EOD;
 <div>
   <input type="hidden" name="cmd" value="pcomment" />
   <input type="hidden" name="mypage" value="@{[&escape($::form{mypage})]}" />
   <input type="hidden" name="page" value="@{[&escape($pcomment_page)]}" />
   <input type="hidden" name="myConflictChecker" value="$conflictchecker" />
   <input type="hidden" name="mytouch" value="on" />
   <input type="hidden" name="nodate" value="$nodate" />
   <input type="hidden" name="above" value="$above" />
   @{[$noname eq 1 ? qq(   <input type="hidden" name="noname" value="1" />) : ""]}
@{[$reply eq 1 ? qq(   <input class="pcmt" type="radio" name="reply" value="" checked />) : ""]}
   $nametags
   <input type="text" name="mymsg" value="" size="$pcomment::size_msg" />
   <input type="submit" value="$::resource{pcomment_plugin_pcommentbutton}" />
 </div>
EOD
	if($above eq 1) {
		$body=$pcomment_info . $pcomments . $body;
	} else {
		$body=$body . $pcomments . $pcomment_info;
	}
	return <<EOD;
<form action="$::script" method="post">
$body
</form>
EOD
}

sub plugin_pcomment_get {
	my($pcomment_page,$pcomment_msgs,$above)=@_;
	my @pcomments=();
	my $i=0;
	if(&is_exist_page($pcomment_page)) {
		foreach(
				$above eq 1
					? reverse split(/\n/,$::database{$pcomment_page})
					: split(/\n/,$::database{$pcomment_page})) {
			last if($i>=$pcomment_msgs && $pcomment_msgs ne 0);
			if(/^-{1,3}/) {
				chomp;
				push(@pcomments,$_);
				if(!/^--{1,2}/) {
					$i++;
				}
			}
		}
	}
	@pcomments=reverse @pcomments if($above eq 1);
	return ($i, @pcomments);
}

1;
__END__

=head1 NAME

pcomment.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #pcomment
 #pcomment({ [Comment record page], [Display counts], [noname], [nodate], [above], [below], [reply] })

=head1 DESCRIPTION

It is comment plugin which can record a comment on another page. Only the newest comment can be displayed on the installed place. A radio button can be displayed and a comment can also be attached to the specified portion.

=head1 USAGE

=over 4

=item Comment record page

Comment record page being alike -- specify the page name which records a comment. If it omits, it is in pcomment plugin.  Comment is recorded on the page specified by $pcomment::comment_page. default   [Comment/(installed page name)] it is . Even if the specified page does not exist, it creates, when a comment is added first.

The Paige name constituted only numerically cannot be specified as Comment record page.

=item Display counts

Display counts specifies the number of the newest comments to display. Only the number-less list of the 1st level is counted. When it omits, display the default number of cases of pcomment.(Default 10)

=item noname

Not display name input.

=item nodate

Not display date.

=item above

The inserted comment is displayed on form. The top of a comment is old and it ranks with new order toward the bottom.

=item below

The inserted comment is displayed on the bottom of form. The bottom of a comment is old and it ranks with new order toward a top.

=item reply

A radio button is displayed on the head of a comment. The reply to a certain comment is attained with checking the radio button of the comment.

=back


=head1 SETTING

=head2 pyukiwiki.ini.cgi

=over 4

=item $::writefrozenplugin

write frozen page

=head2 pcomment.inc.pl

=over 4

=item $pcomment::format

pcomment format

do not change \x08 code

=item $pcomment::noname

do error of no name

=item $pcomment::nodata

do error of no pcomment

=item $pcomment::size_msg

Colums of comment textarea.

=item $pcomment::size_name 

Colums of name textarea.

=item $pcomment::format_name

Insert format of name.

=item $pcomment::format_msg

Insert format of comment.

=item $pcomment::format_now

Insert format of date.

It is necessary to be the form which can be recognized with new plugin.

=item $pcomment::comment_page

Default comment page.

=item $pcomment::num_comments = 10

Default number of the newest comment displays.

=item $pcomment::direction_default

It specifies in which of 1:above(head)/0:below (end) the contents of an input are inserted.

=item $pcomment::timestamp

Renewal of a time stump is specified as follows.

 0: none
 1: Renewal of a time stump of an installation page.
 2: Renewal of a time stump of a comment page   (default)
 3: Both.

=item $pcomment::viewcommentpage

The screen changes after writing are specified.

 0: Return to the comment page after writing.
 1: Return to the installation page after writing.   (default)

=item $pcomment::frozencommentpage

1: Change into the state where it freeze, at the time of comment page new creation.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/pcomment

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/pcomment/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/pcomment.inc.pl>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://lineage.netgamers.jp/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2006 by Nanami.

Copyright (C) 2005-2006 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
