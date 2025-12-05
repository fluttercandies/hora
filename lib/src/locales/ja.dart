// JA Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Japanese locale.
class HoraLocaleJa extends HoraLocale {
  const HoraLocaleJa();

  @override
  String get code => 'ja';

  @override
  List<String> get months => const [
        '1月',
        '2月',
        '3月',
        '4月',
        '5月',
        '6月',
        '7月',
        '8月',
        '9月',
        '10月',
        '11月',
        '12月',
      ];

  @override
  List<String> get monthsShort => const [
        '1月',
        '2月',
        '3月',
        '4月',
        '5月',
        '6月',
        '7月',
        '8月',
        '9月',
        '10月',
        '11月',
        '12月',
      ];

  @override
  List<String> get weekdays => const [
        '日曜日',
        '月曜日',
        '火曜日',
        '水曜日',
        '木曜日',
        '金曜日',
        '土曜日',
      ];

  @override
  List<String> get weekdaysShort => const [
        '日',
        '月',
        '火',
        '水',
        '木',
        '金',
        '土',
      ];

  @override
  List<String> get weekdaysMin => const [
        '日',
        '月',
        '火',
        '水',
        '木',
        '金',
        '土',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'YYYY/MM/DD',
        ll: 'YYYY年M月D日',
        lll: 'YYYY年M月D日 HH:mm',
        llll: 'YYYY年M月D日 dddd HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s後',
        past: '%s前',
        s: '数秒',
        m: '1分',
        mm: '%d分',
        h: '1時間',
        hh: '%d時間',
        d: '1日',
        dd: '%d日',
        mo: '1ヶ月',
        mos: '%dヶ月',
        y: '1年',
        yy: '%d年',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n日';
  @override
  String meridiem(int hour, int minute, {bool lowercase = false}) =>
      hour < 12 ? '午前' : '午後';
}
