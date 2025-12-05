// ZH-CN Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Chinese (Simplified) locale.
class HoraLocaleZhCn extends HoraLocale {
  const HoraLocaleZhCn();

  @override
  String get code => 'zh-cn';

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
        future: '%s内',
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
  String ordinal(int n, [String? unit]) => switch (unit) {
        'W' => '$n周',
        _ => '$n日',
      };

  @override
  String meridiem(int hour, int minute, {bool lowercase = false}) {
    final hm = hour * 100 + minute;
    if (hm < 600) return '凌晨';
    if (hm < 900) return '早上';
    if (hm < 1100) return '上午';
    if (hm < 1300) return '中午';
    if (hm < 1800) return '下午';
    return '晚上';
  }

  @override
  String get invalidDate => '无效日期';
}
