// ZH-HK Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Chinese (Hong Kong) locale.
class HoraLocaleZhHk extends HoraLocale {
  const HoraLocaleZhHk();

  @override
  String get code => 'zh-hk';

  @override
  List<String> get months => const [
        '一月',
        '二月',
        '三月',
        '四月',
        '五月',
        '六月',
        '七月',
        '八月',
        '九月',
        '十月',
        '十一月',
        '十二月',
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
        '星期日',
        '星期一',
        '星期二',
        '星期三',
        '星期四',
        '星期五',
        '星期六',
      ];

  @override
  List<String> get weekdaysShort => const [
        '週日',
        '週一',
        '週二',
        '週三',
        '週四',
        '週五',
        '週六',
      ];

  @override
  List<String> get weekdaysMin => const [
        '日',
        '一',
        '二',
        '三',
        '四',
        '五',
        '六',
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
        llll: 'YYYY年M月D日dddd HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s內',
        past: '%s前',
        s: '幾秒',
        m: '一分鐘',
        mm: '%d 分鐘',
        h: '一小時',
        hh: '%d 小時',
        d: '一天',
        dd: '%d 天',
        mo: '一個月',
        mos: '%d 個月',
        y: '一年',
        yy: '%d 年',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
  // Note: Complex meridiem logic - may need manual adjustment
  @override
  String meridiem(int hour, int minute, {bool lowercase = false}) {
    final m = hour < 12 ? 'AM' : 'PM';
    return lowercase ? m.toLowerCase() : m;
  }
}
