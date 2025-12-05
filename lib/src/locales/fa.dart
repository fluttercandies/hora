// FA Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Persian locale.
class HoraLocaleFa extends HoraLocale {
  const HoraLocaleFa();

  @override
  String get code => 'fa';

  @override
  List<String> get months => const [
        'ژانویه',
        'فوریه',
        'مارس',
        'آوریل',
        'مه',
        'ژوئن',
        'ژوئیه',
        'اوت',
        'سپتامبر',
        'اکتبر',
        'نوامبر',
        'دسامبر',
      ];

  @override
  List<String> get monthsShort => const [
        'ژانویه',
        'فوریه',
        'مارس',
        'آوریل',
        'مه',
        'ژوئن',
        'ژوئیه',
        'اوت',
        'سپتامبر',
        'اکتبر',
        'نوامبر',
        'دسامبر',
      ];

  @override
  List<String> get weekdays => const [
        'یک‌شنبه',
        'دوشنبه',
        'سه‌شنبه',
        'چهارشنبه',
        'پنج‌شنبه',
        'جمعه',
        'شنبه',
      ];

  @override
  List<String> get weekdaysShort => const [
        r'یک\u200cشنبه',
        'دوشنبه',
        r'سه\u200cشنبه',
        'چهارشنبه',
        r'پنج\u200cشنبه',
        'جمعه',
        'شنبه',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ی',
        'د',
        'س',
        'چ',
        'پ',
        'ج',
        'ش',
      ];

  @override
  int get weekStart => 6;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY HH:mm',
        llll: 'dddd, D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'در %s',
        past: '%s پیش',
        s: 'چند ثانیه',
        m: 'یک دقیقه',
        mm: '%d دقیقه',
        h: 'یک ساعت',
        hh: '%d ساعت',
        d: 'یک روز',
        dd: '%d روز',
        mo: 'یک ماه',
        mos: '%d ماه',
        y: 'یک سال',
        yy: '%d سال',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
