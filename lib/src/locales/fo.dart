// FO Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Faroese locale.
class HoraLocaleFo extends HoraLocale {
  const HoraLocaleFo();

  @override
  String get code => 'fo';

  @override
  List<String> get months => const [
        'januar',
        'februar',
        'mars',
        'apríl',
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
        'sunnudagur',
        'mánadagur',
        'týsdagur',
        'mikudagur',
        'hósdagur',
        'fríggjadagur',
        'leygardagur',
      ];

  @override
  List<String> get weekdaysShort => const [
        'sun',
        'mán',
        'týs',
        'mik',
        'hós',
        'frí',
        'ley',
      ];

  @override
  List<String> get weekdaysMin => const [
        'su',
        'má',
        'tý',
        'mi',
        'hó',
        'fr',
        'le',
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
        llll: 'dddd D. MMMM, YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'um %s',
        past: '%s síðani',
        s: 'fá sekund',
        m: 'ein minuttur',
        mm: '%d minuttir',
        h: 'ein tími',
        hh: '%d tímar',
        d: 'ein dagur',
        dd: '%d dagar',
        mo: 'ein mánaður',
        mos: '%d mánaðir',
        y: 'eitt ár',
        yy: '%d ár',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
