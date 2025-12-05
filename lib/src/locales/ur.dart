// UR Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Urdu locale.
class HoraLocaleUr extends HoraLocale {
  const HoraLocaleUr();

  @override
  String get code => 'ur';

  @override
  List<String> get months => const [
        'جنوری',
        'فروری',
        'مارچ',
        'اپریل',
        'مئی',
        'جون',
        'جولائی',
        'اگست',
        'ستمبر',
        'اکتوبر',
        'نومبر',
        'دسمبر',
      ];

  @override
  List<String> get monthsShort => const [
        'جنوری',
        'فروری',
        'مارچ',
        'اپریل',
        'مئی',
        'جون',
        'جولائی',
        'اگست',
        'ستمبر',
        'اکتوبر',
        'نومبر',
        'دسمبر',
      ];

  @override
  List<String> get weekdays => const [
        'اتوار',
        'پیر',
        'منگل',
        'بدھ',
        'جمعرات',
        'جمعہ',
        'ہفتہ',
      ];

  @override
  List<String> get weekdaysShort => const [
        'اتوار',
        'پیر',
        'منگل',
        'بدھ',
        'جمعرات',
        'جمعہ',
        'ہفتہ',
      ];

  @override
  List<String> get weekdaysMin => const [
        'اتوار',
        'پیر',
        'منگل',
        'بدھ',
        'جمعرات',
        'جمعہ',
        'ہفتہ',
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
        llll: 'dddd، D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s بعد',
        past: '%s قبل',
        s: 'چند سیکنڈ',
        m: 'ایک منٹ',
        mm: '%d منٹ',
        h: 'ایک گھنٹہ',
        hh: '%d گھنٹے',
        d: 'ایک دن',
        dd: '%d دن',
        mo: 'ایک ماہ',
        mos: '%d ماہ',
        y: 'ایک سال',
        yy: '%d سال',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
