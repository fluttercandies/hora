// FY Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Frisian locale.
class HoraLocaleFy extends HoraLocale {
  const HoraLocaleFy();

  @override
  String get code => 'fy';

  @override
  List<String> get months => const [
        'jannewaris',
        'febrewaris',
        'maart',
        'april',
        'maaie',
        'juny',
        'july',
        'augustus',
        'septimber',
        'oktober',
        'novimber',
        'desimber',
      ];

  @override
  List<String> get monthsShort => const [
        'jan.',
        'feb.',
        'mrt.',
        'apr.',
        'mai',
        'jun.',
        'jul.',
        'aug.',
        'sep.',
        'okt.',
        'nov.',
        'des.',
      ];

  @override
  List<String> get weekdays => const [
        'snein',
        'moandei',
        'tiisdei',
        'woansdei',
        'tongersdei',
        'freed',
        'sneon',
      ];

  @override
  List<String> get weekdaysShort => const [
        'si.',
        'mo.',
        'ti.',
        'wo.',
        'to.',
        'fr.',
        'so.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Si',
        'Mo',
        'Ti',
        'Wo',
        'To',
        'Fr',
        'So',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD-MM-YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY HH:mm',
        llll: 'dddd D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'oer %s',
        past: '%s lyn',
        s: 'in pear sekonden',
        m: 'ien minút',
        mm: '%d minuten',
        h: 'ien oere',
        hh: '%d oeren',
        d: 'ien dei',
        dd: '%d dagen',
        mo: 'ien moanne',
        mos: '%d moannen',
        y: 'ien jier',
        yy: '%d jierren',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
