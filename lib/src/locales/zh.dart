// ZH Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Chinese locale.
class HoraLocaleZh extends HoraLocale {
  const HoraLocaleZh();

  @override
  String get code => 'zh';

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
        '周日',
        '周一',
        '周二',
        '周三',
        '周四',
        '周五',
        '周六',
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
  int get weekStart => 1;

  @override
  int get yearStart => 4;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'YYYY/MM/DD',
        ll: 'YYYY年M月D日',
        lll: 'YYYY年M月D日Ah点mm分',
        llll: 'YYYY年M月D日ddddAh点mm分',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s后',
        past: '%s前',
        s: '几秒',
        m: '1 分钟',
        mm: '%d 分钟',
        h: '1 小时',
        hh: '%d 小时',
        d: '1 天',
        dd: '%d 天',
        mo: '1 个月',
        mos: '%d 个月',
        y: '1 年',
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
