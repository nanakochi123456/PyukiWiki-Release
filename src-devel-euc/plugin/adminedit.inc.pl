######################################################################
# adminedit.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: adminedit.inc.pl,v 1.97 2011/05/04 07:26:50 papu Exp $
#
# "PyukiWiki" version 0.1.9 $$
# Author: Nekyo
# Copyright (C) 2004-2011 by Nekyo.
# http://nekyo.qp.land.to/
# Copyright (C) 2005-2011 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=Shift-JIS 1TAB=4Spaces
######################################################################

use strict;

sub plugin_adminedit_action {
	if (1 == &exist_plugin('edit')) {
		my ($page) = &unarmor_name(&armor_name($::form{mypage}));
		my $body;
		if (not &is_editable($page)) {
			$body .= qq(<p><strong>$::resource{edit_plugin_cantchange}</strong></p>);
		} else {
			$body .= qq(<p><strong>$::resource{adminedit_plugin_passwordneeded}</strong></p>);
			# 2005.11.2 pochi: •”•ª•ÒW‚ð‰Â”\‚É (thanks Walrus)
			my $pagemsg;
			if ($::form{mypart} =~ /^\d+$/ and $::form{mypart}) {
				my $mymsg = (&read_by_part($page))[$::form{mypart} - 1];
				$pagemsg = \$mymsg;

			} else {
				# original
				$pagemsg = \$::database{$page};
			}
			$body .= &plugin_edit_editform($$pagemsg,
				&get_info($page, $::info_ConflictChecker), admin=>1);
		}
		return ('msg'=>"$page\t$::resource{adminedit_plugin_title}", 'body'=>$body, 'ispage'=>1);
	}
	return "";
}

1;
__END__

=head1 NAME

adminedit.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=adminedit&mypage=pagename

=head1 DESCRIPTION

Edit page and frozen/unfrozen page.

Frozen password is required in order to edit and freeze.

The page name must be encoded.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/adminedit

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Nanami/adminedit/>

=item PyukiWiki CVS

L<http://sourceforge.jp/cvs/view/pyukiwiki/PyukiWiki-Devel/plugin/adminedit.inc.pl?view=log>

=back

=head1 AUTHOR

=over 4

=item Nekyo

L<http://nekyo.qp.land.to/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2004-2011 by Nekyo.

Copyright (C) 2005-2011 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
