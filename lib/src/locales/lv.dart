// LV Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Latvian locale.
class HoraLocaleLv extends HoraLocale {
  const HoraLocaleLv();

  @override
  String get code => 'lv';

  @override
  List<String> get months => const [
        'janvāris',
        'februāris',
        'marts',
        'aprīlis',
        'maijs',
        'jūnijs',
        'jūlijs',
        'augusts',
        'septembris',
        'oktobris',
        'novembris',
        'decembris',
      ];

  @override
  List<String> get monthsShort => const [
        'jan',
        'feb',
        'mar',
        'apr',
        'mai',
        'jūn',
        'jūl',
        'aug',
        'sep',
        'okt',
        'nov',
        'dec',
      ];

  @override
  List<String> get weekdays => const [
        'svētdiena',
        'pirmdiena',
        'otrdiena',
        'trešdiena',
        'ceturtdiena',
        'piektdiena',
        'sestdiena',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Sv',
        'P',
        'O',
        'T',
        'C',
        'Pk',
        'S',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Sv',
        'P',
        'O',
        'T',
        'C',
        'Pk',
        'S',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD.MM.YYYY.',
        ll: 'YYYY. [gada] D. MMMM',
        lll: 'YYYY. [gada] D. MMMM, HH:mm',
        llll: 'YYYY. [gada] D. MMMM, dddd, HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'pēc %s',
        past: 'pirms %s',
        s: 'dažām sekundēm',
        m: 'minūtes',
        mm: '%d minūtēm',
        h: 'stundas',
        hh: '%d stundām',
        d: 'dienas',
        dd: '%d dienām',
        mo: 'mēneša',
        mos: '%d mēnešiem',
        y: 'gada',
        yy: '%d gadiem',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
