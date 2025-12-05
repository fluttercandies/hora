// SD Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Sindhi locale.
class HoraLocaleSd extends HoraLocale {
  const HoraLocaleSd();

  @override
  String get code => 'sd';

  @override
  List<String> get months => const [
        'جنوري',
        'فيبروري',
        'مارچ',
        'اپريل',
        'مئي',
        'جون',
        'جولاءِ',
        'آگسٽ',
        'سيپٽمبر',
        'آڪٽوبر',
        'نومبر',
        'ڊسمبر',
      ];

  @override
  List<String> get monthsShort => const [
        'جنوري',
        'فيبروري',
        'مارچ',
        'اپريل',
        'مئي',
        'جون',
        'جولاءِ',
        'آگسٽ',
        'سيپٽمبر',
        'آڪٽوبر',
        'نومبر',
        'ڊسمبر',
      ];

  @override
  List<String> get weekdays => const [
        'آچر',
        'سومر',
        'اڱارو',
        'اربع',
        'خميس',
        'جمع',
        'ڇنڇر',
      ];

  @override
  List<String> get weekdaysShort => const [
        'آچر',
        'سومر',
        'اڱارو',
        'اربع',
        'خميس',
        'جمع',
        'ڇنڇر',
      ];

  @override
  List<String> get weekdaysMin => const [
        'آچر',
        'سومر',
        'اڱارو',
        'اربع',
        'خميس',
        'جمع',
        'ڇنڇر',
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
        future: '%s پوء',
        past: '%s اڳ',
        s: 'چند سيڪنڊ',
        m: 'هڪ منٽ',
        mm: '%d منٽ',
        h: 'هڪ ڪلاڪ',
        hh: '%d ڪلاڪ',
        d: 'هڪ ڏينهن',
        dd: '%d ڏينهن',
        mo: 'هڪ مهينو',
        mos: '%d مهينا',
        y: 'هڪ سال',
        yy: '%d سال',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
