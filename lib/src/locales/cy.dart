// CY Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Welsh locale.
class HoraLocaleCy extends HoraLocale {
  const HoraLocaleCy();

  @override
  String get code => 'cy';

  @override
  List<String> get months => const [
        'Ionawr',
        'Chwefror',
        'Mawrth',
        'Ebrill',
        'Mai',
        'Mehefin',
        'Gorffennaf',
        'Awst',
        'Medi',
        'Hydref',
        'Tachwedd',
        'Rhagfyr',
      ];

  @override
  List<String> get monthsShort => const [
        'Ion',
        'Chwe',
        'Maw',
        'Ebr',
        'Mai',
        'Meh',
        'Gor',
        'Aws',
        'Med',
        'Hyd',
        'Tach',
        'Rhag',
      ];

  @override
  List<String> get weekdays => const [
        'Dydd Sul',
        'Dydd Llun',
        'Dydd Mawrth',
        'Dydd Mercher',
        'Dydd Iau',
        'Dydd Gwener',
        'Dydd Sadwrn',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Sul',
        'Llun',
        'Maw',
        'Mer',
        'Iau',
        'Gwe',
        'Sad',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Su',
        'Ll',
        'Ma',
        'Me',
        'Ia',
        'Gw',
        'Sa',
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
        llll: 'dddd, D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'mewn %s',
        past: '%s yn ôl',
        s: 'ychydig eiliadau',
        m: 'munud',
        mm: '%d munud',
        h: 'awr',
        hh: '%d awr',
        d: 'diwrnod',
        dd: '%d diwrnod',
        mo: 'mis',
        mos: '%d mis',
        y: 'blwyddyn',
        yy: '%d flynedd',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
