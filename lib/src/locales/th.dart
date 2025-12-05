// TH Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Thai locale.
class HoraLocaleTh extends HoraLocale {
  const HoraLocaleTh();

  @override
  String get code => 'th';

  @override
  List<String> get months => const [
        'มกราคม',
        'กุมภาพันธ์',
        'มีนาคม',
        'เมษายน',
        'พฤษภาคม',
        'มิถุนายน',
        'กรกฎาคม',
        'สิงหาคม',
        'กันยายน',
        'ตุลาคม',
        'พฤศจิกายน',
        'ธันวาคม',
      ];

  @override
  List<String> get monthsShort => const [
        'ม.ค.',
        'ก.พ.',
        'มี.ค.',
        'เม.ย.',
        'พ.ค.',
        'มิ.ย.',
        'ก.ค.',
        'ส.ค.',
        'ก.ย.',
        'ต.ค.',
        'พ.ย.',
        'ธ.ค.',
      ];

  @override
  List<String> get weekdays => const [
        'อาทิตย์',
        'จันทร์',
        'อังคาร',
        'พุธ',
        'พฤหัสบดี',
        'ศุกร์',
        'เสาร์',
      ];

  @override
  List<String> get weekdaysShort => const [
        'อาทิตย์',
        'จันทร์',
        'อังคาร',
        'พุธ',
        'พฤหัส',
        'ศุกร์',
        'เสาร์',
      ];

  @override
  List<String> get weekdaysMin => const [
        'อา.',
        'จ.',
        'อ.',
        'พ.',
        'พฤ.',
        'ศ.',
        'ส.',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'H:mm',
        lts: 'H:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY เวลา H:mm',
        llll: 'วันddddที่ D MMMM YYYY เวลา H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'อีก %s',
        past: '%sที่แล้ว',
        s: 'ไม่กี่วินาที',
        m: '1 นาที',
        mm: '%d นาที',
        h: '1 ชั่วโมง',
        hh: '%d ชั่วโมง',
        d: '1 วัน',
        dd: '%d วัน',
        mo: '1 เดือน',
        mos: '%d เดือน',
        y: '1 ปี',
        yy: '%d ปี',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
