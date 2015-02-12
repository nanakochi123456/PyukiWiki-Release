# nanakodate

$plugin_nanakodate_target="2007-06-26";
sub plugin_nanakodate_convert {
	my ($str)=shift;
	my $dates=
		&date_to_days(&date("Y-m-d"))
	  - &date_to_days($plugin_nanakodate_target);
	$str=~s/DATES/$dates/g;
	return $str;0
}

#Perl4���ư�����ɬ�פ����ꤽ�����ä��ʤǤ��äƤޤ���ˤΤǡ��ѿ���my����ʤɤϤ��Ƥޤ��� $year��$month��$day�����ѿ��ϳ����Ǥ��ɤ��ȤäƤ��������ѿ�̾�ʤΤǡ�����դ�
 sub date_to_days {
  # yy-mm-dd��yyyy-mm-dd���������դ�1970ǯ1��1�������������ľ���ޤ���
  # 1970ǯ1��1����1�ˤʤ�ޤ���
  $datestr  = shift(@_);
  $dayspast = 0;
  # ʬ��
  unless ($datestr =~ /^(\d{2,4})[^\d](\d{2})[^\d](\d{2})/) {
    return undef;
  }
  ($year, $month, $day) = ($1, $2, $3);
  if    ($year < 70)   { $year += 2000; }
  elsif ($year < 1900) { $year += 1900; }
  # ǯ�ν���
  for ($i = 1970; $i < $year; $i++) {
    $yeardays = ($i % 4 == 0 && ($i % 400 == 0 || $i % 100 != 0)) ? 366 : 365;
    $dayspast += $yeardays;
  }
  # ��ν���
  @days_in_month = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
  for ($i = 1; $i < $month; $i++) {
    $monthdays = ($i == 2 && $year % 4 == 0 && ($year % 400 == 0 || $year % 100 != 0)) ? 29 : $days_in_month[$i - 1];
    $dayspast += $monthdays;
  }
  # ���ν���
  $dayspast += $day;
  return $dayspast;
}

1;
__END__
