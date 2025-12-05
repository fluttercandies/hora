// NN Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Norwegian Nynorsk locale.
class HoraLocaleNn extends HoraLocale {
  const HoraLocaleNn();

  @override
  String get code => 'nn';

  @override
  List<String> get months => const [
        'januar',
        'februar',
        'mars',
        'april',
        'mai',
        'juni',
        'juli',
        'august',
        'september',
        'oktober',
        'november',
        'desember',
      ];

  @override
  List<String> get monthsShort => const [
        'jan',
        'feb',
        'mar',
        'apr',
        'mai',
        'jun',
        'jul',
        'aug',
        'sep',
        'okt',
        'nov',
        'des',
      ];

  @override
  List<String> get weekdays => const [
        'sundag',
        'måndag',
        'tysdag',
        'onsdag',
        'torsdag',
        'fredag',
        'laurdag',
      ];

  @override
  List<String> get weekdaysShort => const [
        'sun',
        'mån',
        'tys',
        'ons',
        'tor',
        'fre',
        'lau',
      ];

  @override
  List<String> get weekdaysMin => const [
        'su',
        'må',
        'ty',
        'on',
        'to',
        'fr',
        'la',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD.MM.YYYY',
        ll: 'D. MMMM YYYY',
        lll: 'D. MMMM YYYY [kl.] H:mm',
        llll: 'dddd D. MMMM YYYY [kl.] HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'om %s',
        past: 'for %s sidan',
        s: 'nokre sekund',
        m: 'eitt minutt',
        mm: '%d minutt',
        h: 'ein time',
        hh: '%d timar',
        d: 'ein dag',
        dd: '%d dagar',
        mo: 'ein månad',
        mos: '%d månadar',
        y: 'eitt år',
        yy: '%d år',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
