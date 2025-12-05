// AR-IQ Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Arabic (Iraq) locale.
class HoraLocaleArIq extends HoraLocale {
  const HoraLocaleArIq();

  @override
  String get code => 'ar-iq';

  @override
  List<String> get months => const [
        'كانون الثاني',
        'شباط',
        'آذار',
        'نيسان',
        'أيار',
        'حزيران',
        'تموز',
        'آب',
        'أيلول',
        'تشرين الأول',
        ' تشرين الثاني',
        'كانون الأول',
      ];

  @override
  List<String> get monthsShort => const [
        'كانون الثاني',
        'شباط',
        'آذار',
        'نيسان',
        'أيار',
        'حزيران',
        'تموز',
        'آب',
        'أيلول',
        'تشرين الأول',
        ' تشرين الثاني',
        'كانون الأول',
      ];

  @override
  List<String> get weekdays => const [
        'الأحد',
        'الإثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
      ];

  @override
  List<String> get weekdaysShort => const [
        'أحد',
        'إثنين',
        'ثلاثاء',
        'أربعاء',
        'خميس',
        'جمعة',
        'سبت',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ح',
        'ن',
        'ث',
        'ر',
        'خ',
        'ج',
        'س',
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
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY HH:mm',
        llll: 'dddd D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'في %s',
        past: 'منذ %s',
        s: 'ثوان',
        m: 'دقيقة',
        mm: '%d دقائق',
        h: 'ساعة',
        hh: '%d ساعات',
        d: 'يوم',
        dd: '%d أيام',
        mo: 'شهر',
        mos: '%d أشهر',
        y: 'سنة',
        yy: '%d سنوات',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
