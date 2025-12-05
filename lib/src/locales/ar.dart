// AR Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Arabic locale.
class HoraLocaleAr extends HoraLocale {
  const HoraLocaleAr();

  @override
  String get code => 'ar';

  @override
  List<String> get months => const [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر',
      ];

  @override
  List<String> get monthsShort => const [
        'ينا',
        'فبر',
        'مار',
        'أبر',
        'ماي',
        'يون',
        'يول',
        'أغس',
        'سبت',
        'أكت',
        'نوف',
        'ديس',
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
  int get weekStart => 6;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'D/‏M/‏YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY HH:mm',
        llll: 'dddd D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'بعد %s',
        past: 'منذ %s',
        s: 'ثانية واحدة',
        m: 'دقيقة واحدة',
        mm: '%d دقائق',
        h: 'ساعة واحدة',
        hh: '%d ساعات',
        d: 'يوم واحد',
        dd: '%d أيام',
        mo: 'شهر واحد',
        mos: '%d أشهر',
        y: 'عام واحد',
        yy: '%d أعوام',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
