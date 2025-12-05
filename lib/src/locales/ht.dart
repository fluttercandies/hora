// HT Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Haitian Creole locale.
class HoraLocaleHt extends HoraLocale {
  const HoraLocaleHt();

  @override
  String get code => 'ht';

  @override
  List<String> get months => const [
        'janvye',
        'fevriye',
        'mas',
        'avril',
        'me',
        'jen',
        'jiyè',
        'out',
        'septanm',
        'oktòb',
        'novanm',
        'desanm',
      ];

  @override
  List<String> get monthsShort => const [
        'jan.',
        'fev.',
        'mas',
        'avr.',
        'me',
        'jen',
        'jiyè.',
        'out',
        'sept.',
        'okt.',
        'nov.',
        'des.',
      ];

  @override
  List<String> get weekdays => const [
        'dimanch',
        'lendi',
        'madi',
        'mèkredi',
        'jedi',
        'vandredi',
        'samdi',
      ];

  @override
  List<String> get weekdaysShort => const [
        'dim.',
        'len.',
        'mad.',
        'mèk.',
        'jed.',
        'van.',
        'sam.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'di',
        'le',
        'ma',
        'mè',
        'je',
        'va',
        'sa',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY HH:mm',
        llll: 'dddd D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'nan %s',
        past: 'sa gen %s',
        s: 'kèk segond',
        m: 'yon minit',
        mm: '%d minit',
        h: 'inèdtan',
        hh: '%d zè',
        d: 'yon jou',
        dd: '%d jou',
        mo: 'yon mwa',
        mos: '%d mwa',
        y: 'yon ane',
        yy: '%d ane',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
