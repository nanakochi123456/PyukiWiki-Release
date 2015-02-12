######################################################################
# 
######################################################################
# ��Բ������̤ΰ١��������Ȥ�Ƥ��ޤ��󤬡��ص��ξ��
# v0.1.6�б��Ǥ����ۤ��뤳�ȤȤ��ޤ�����
# ����¾��������ǽ���夷�Ƥ��ޤ���
# PyukiWiki Developer Term
######################################################################
# �Ȥ���
#
# #popular(10(���),FrontPage|MenuBar,[total/today/yesterday...],[notitle])
#
# �������ɽ��������
# �����оݥڡ������оݳ��Υڡ���������ɽ���ǵ��Ҥ���
# ��total/today/yesterday�������оݤ�������������������������������
#   $::CountView=2�Ǥ���С��ʲ�����ѤǤ��ޤ���
#   week - �����ι��
#   lastweek - �轵�ι��
# ��notitle��ʸ�������ꤹ��ȥ����ȥ뤬ɽ������ʤ��ʤ롣
# �ʤ���popurar����Ѥ���ȡ���ưŪ��popular.inc.pl�����󥯥롼��
# ����ޤ���
######################################################################

use strict;
use Nana::Cache;

# ����å����ݻ�����(20ʬ)
$popular::cache_expire=20*60
	if(!defined($popular::cache_expire));

sub plugin_popular_convert {
	my $argv = shift;
	my ($limit, $ignore_page, $flag, $notitle) = split(/,/, $argv);

	return qq(<div class="error">counter.inc.pl can't require</div>)
		if (&exist_plugin("counter") ne 1);

	if ($limit+0 < 1) {$limit = 10;}
	if ($ignore_page eq '') {$ignore_page = '^FrontPage$|MenuBar$';}
	if ($::non_list  ne '') {$ignore_page .= "|$::non_list";}

	$flag=lc $flag;
	$flag="total" if($flag eq '');

	my $cache=new Nana::Cache (
		ext=>"popular",
		files=>100,
		dir=>$::cache_dir,
		size=>100000,
		use=>1,
		expire=>$popular::cache_expire,
	);

	$cache->check(
		"$::plugin_dir/popular.inc.pl",
		"$::plugin_dir/popular.inc.pl",
		"$::res_dir/popular.$::lang.txt",
		"$::explugin_dir/Nana/Cache.pm"
	);
	my $exist_urlhack=-r "$::explugin_dir/urlhack.inc.cgi";
	my $cachefile=&dbmname("$limit-$ignore_page-$flag-$::lang-$exist_urlhack");

	my $out=$cache->read($cachefile);
	my $count = 0;
	if($out eq '') {
		my @populars;
		foreach my $page (sort keys %::database) {
			next if !&is_exist_page($page);
			next if $page =~ /^($::RecentChanges)$/;
			next if $page =~ /($ignore_page)/;
			next unless(&is_readable($page));

			my $cnt=&plugin_counter_selection($flag,&plugin_counter_do($page,"r"));
			push @populars, sprintf("%d\t%s",$cnt,$page)
				if($cnt > 0);
		}
		foreach my $key (sort { $b<=>$a } @populars) {
			last if ($count >= $limit);
			my ($cnt,$page)=split(/\t/,$key);
			$out .= "<li>" . &make_link(&armor_name($page)) . "<span class=\"popular\">($cnt)</span></li>\n";
			$count++;
		}
		if ($out) {
			$out =  '<ul class="popular_list">' . $out . '</ul>';
		}

		if($notitle ne 'notitle') {
			if ($::resource{"popular_plugin_$flag\_frame"}) {
				$out=sprintf $::resource{"popular_plugin_$flag\_frame"}, $count, $out;
			}
		}
		$cache->write($cachefile,$out);
	}
	return $out;
}

1;
__END__

