// VI Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Vietnamese locale.
class HoraLocaleVi extends HoraLocale {
  const HoraLocaleVi();

  @override
  String get code => 'vi';

  @override
  List<String> get months => const [
        'tháng 1',
        'tháng 2',
        'tháng 3',
        'tháng 4',
        'tháng 5',
        'tháng 6',
        'tháng 7',
        'tháng 8',
        'tháng 9',
        'tháng 10',
        'tháng 11',
        'tháng 12',
      ];

  @override
  List<String> get monthsShort => const [
        'Th01',
        'Th02',
        'Th03',
        'Th04',
        'Th05',
        'Th06',
        'Th07',
        'Th08',
        'Th09',
        'Th10',
        'Th11',
        'Th12',
      ];

  @override
  List<String> get weekdays => const [
        'chủ nhật',
        'thứ hai',
        'thứ ba',
        'thứ tư',
        'thứ năm',
        'thứ sáu',
        'thứ bảy',
      ];

  @override
  List<String> get weekdaysShort => const [
        'CN',
        'T2',
        'T3',
        'T4',
        'T5',
        'T6',
        'T7',
      ];

  @override
  List<String> get weekdaysMin => const [
        'CN',
        'T2',
        'T3',
        'T4',
        'T5',
        'T6',
        'T7',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM [năm] YYYY',
        lll: 'D MMMM [năm] YYYY HH:mm',
        llll: 'dddd, D MMMM [năm] YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s tới',
        past: '%s trước',
        s: 'vài giây',
        m: 'một phút',
        mm: '%d phút',
        h: 'một giờ',
        hh: '%d giờ',
        d: 'một ngày',
        dd: '%d ngày',
        mo: 'một tháng',
        mos: '%d tháng',
        y: 'một năm',
        yy: '%d năm',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
