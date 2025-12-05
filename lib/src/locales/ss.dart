// SS Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Swati locale.
class HoraLocaleSs extends HoraLocale {
  const HoraLocaleSs();

  @override
  String get code => 'ss';

  @override
  List<String> get months => const [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];

  @override
  List<String> get monthsShort => const [
        'Bhi',
        'Ina',
        'Inu',
        'Mab',
        'Ink',
        'Inh',
        'Kho',
        'Igc',
        'Iny',
        'Imp',
        'Lwe',
        'Igo',
      ];

  @override
  List<String> get weekdays => const [
        'Lisontfo',
        'Umsombuluko',
        'Lesibili',
        'Lesitsatfu',
        'Lesine',
        'Lesihlanu',
        'Umgcibelo',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Lis',
        'Umb',
        'Lsb',
        'Les',
        'Lsi',
        'Lsh',
        'Umg',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Li',
        'Us',
        'Lb',
        'Lt',
        'Ls',
        'Lh',
        'Ug',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY h:mm A',
        llll: 'dddd, D MMMM YYYY h:mm A',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'nga %s',
        past: 'wenteka nga %s',
        s: 'emizuzwana lomcane',
        m: 'umzuzu',
        mm: '%d emizuzu',
        h: 'lihora',
        hh: '%d emahora',
        d: 'lilanga',
        dd: '%d emalanga',
        mo: 'inyanga',
        mos: '%d tinyanga',
        y: 'umnyaka',
        yy: '%d iminyaka',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
