// AR-KW Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Arabic (Kuwait) locale.
class HoraLocaleArKw extends HoraLocale {
  const HoraLocaleArKw();

  @override
  String get code => 'ar-kw';

  @override
  List<String> get months => const [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'ماي',
        'يونيو',
        'يوليوز',
        'غشت',
        'شتنبر',
        'أكتوبر',
        'نونبر',
        'دجنبر',
      ];

  @override
  List<String> get monthsShort => const [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'ماي',
        'يونيو',
        'يوليوز',
        'غشت',
        'شتنبر',
        'أكتوبر',
        'نونبر',
        'دجنبر',
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
        'احد',
        'اثنين',
        'ثلاثاء',
        'اربعاء',
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
  int get weekStart => 7;

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
