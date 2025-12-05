// CS Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Czech locale.
class HoraLocaleCs extends HoraLocale {
  const HoraLocaleCs();

  @override
  String get code => 'cs';

  @override
  List<String> get months => const [
        'leden',
        'únor',
        'březen',
        'duben',
        'květen',
        'červen',
        'červenec',
        'srpen',
        'září',
        'říjen',
        'listopad',
        'prosinec',
      ];

  @override
  List<String> get monthsShort => const [
        'led',
        'úno',
        'bře',
        'dub',
        'kvě',
        'čvn',
        'čvc',
        'srp',
        'zář',
        'říj',
        'lis',
        'pro',
      ];

  @override
  List<String> get weekdays => const [
        'neděle',
        'pondělí',
        'úterý',
        'středa',
        'čtvrtek',
        'pátek',
        'sobota',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ne',
        'po',
        'út',
        'st',
        'čt',
        'pá',
        'so',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ne',
        'po',
        'út',
        'st',
        'čt',
        'pá',
        'so',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 4;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'H:mm',
        lts: 'H:mm:ss',
        l: 'DD.MM.YYYY',
        ll: 'D. MMMM YYYY',
        lll: 'D. MMMM YYYY H:mm',
        llll: 'dddd D. MMMM YYYY H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'za %s',
        past: 'před %s',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
