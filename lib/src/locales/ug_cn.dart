// UG-CN Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Uyghur (China) locale.
class HoraLocaleUgCn extends HoraLocale {
  const HoraLocaleUgCn();

  @override
  String get code => 'ug-cn';

  @override
  List<String> get months => const [
        'يانۋار',
        'فېۋرال',
        'مارت',
        'ئاپرېل',
        'ماي',
        'ئىيۇن',
        'ئىيۇل',
        'ئاۋغۇست',
        'سېنتەبىر',
        'ئۆكتەبىر',
        'نويابىر',
        'دېكابىر',
      ];

  @override
  List<String> get monthsShort => const [
        'يانۋار',
        'فېۋرال',
        'مارت',
        'ئاپرېل',
        'ماي',
        'ئىيۇن',
        'ئىيۇل',
        'ئاۋغۇست',
        'سېنتەبىر',
        'ئۆكتەبىر',
        'نويابىر',
        'دېكابىر',
      ];

  @override
  List<String> get weekdays => const [
        'يەكشەنبە',
        'دۈشەنبە',
        'سەيشەنبە',
        'چارشەنبە',
        'پەيشەنبە',
        'جۈمە',
        'شەنبە',
      ];

  @override
  List<String> get weekdaysShort => const [
        'يە',
        'دۈ',
        'سە',
        'چا',
        'پە',
        'جۈ',
        'شە',
      ];

  @override
  List<String> get weekdaysMin => const [
        'يە',
        'دۈ',
        'سە',
        'چا',
        'پە',
        'جۈ',
        'شە',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'YYYY-MM-DD',
        ll: 'YYYY-يىلىM-ئاينىڭD-كۈنى',
        lll: 'YYYY-يىلىM-ئاينىڭD-كۈنى، HH:mm',
        llll: 'dddd، YYYY-يىلىM-ئاينىڭD-كۈنى، HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s كېيىن',
        past: '%s بۇرۇن',
        s: 'نەچچە سېكونت',
        m: 'بىر مىنۇت',
        mm: '%d مىنۇت',
        h: 'بىر سائەت',
        hh: '%d سائەت',
        d: 'بىر كۈن',
        dd: '%d كۈن',
        mo: 'بىر ئاي',
        mos: '%d ئاي',
        y: 'بىر يىل',
        yy: '%d يىل',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
