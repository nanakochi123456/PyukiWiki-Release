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
#Perl4上で動作させる必要がありそうだった（でもやってません）ので、変数にmy宣言などはしてません。 $year、$month、$day等の変数は外部でも良く使っていそうな変数名なので、ご注意を。
 sub date_to_days {
  # yy-mm-dd、yyyy-mm-dd形式の日付を1970年1月1日からの日数に直します。
  # 1970年1月1日は1になります。
  $datestr  = shift(@_);
  $dayspast = 0;
  # 分解
  unless ($datestr =~ /^(\d{2,4})[^\d](\d{2})[^\d](\d{2})/) {
    return undef;
  }
  ($year, $month, $day) = ($1, $2, $3);
  if    ($year < 70)   { $year += 2000; }
  elsif ($year < 1900) { $year += 1900; }
  # 年の処理
  for ($i = 1970; $i < $year; $i++) {
    $yeardays = ($i % 4 == 0 && ($i % 400 == 0 || $i % 100 != 0)) ? 366 : 365;
    $dayspast += $yeardays;
  }
  # 月の処理
  @days_in_month = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
  for ($i = 1; $i < $month; $i++) {
    $monthdays = ($i == 2 && $year % 4 == 0 && ($year % 400 == 0 || $year % 100 != 0)) ? 29 : $days_in_month[$i - 1];
    $dayspast += $monthdays;
  }
  # 日の処理
  $dayspast += $day;
  return $dayspast;
}
1;
__END__
