// EU Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Basque locale.
class HoraLocaleEu extends HoraLocale {
  const HoraLocaleEu();

  @override
  String get code => 'eu';

  @override
  List<String> get months => const [
        'urtarrila',
        'otsaila',
        'martxoa',
        'apirila',
        'maiatza',
        'ekaina',
        'uztaila',
        'abuztua',
        'iraila',
        'urria',
        'azaroa',
        'abendua',
      ];

  @override
  List<String> get monthsShort => const [
        'urt.',
        'ots.',
        'mar.',
        'api.',
        'mai.',
        'eka.',
        'uzt.',
        'abu.',
        'ira.',
        'urr.',
        'aza.',
        'abe.',
      ];

  @override
  List<String> get weekdays => const [
        'igandea',
        'astelehena',
        'asteartea',
        'asteazkena',
        'osteguna',
        'ostirala',
        'larunbata',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ig.',
        'al.',
        'ar.',
        'az.',
        'og.',
        'ol.',
        'lr.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ig',
        'al',
        'ar',
        'az',
        'og',
        'ol',
        'lr',
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
        ll: 'YYYY[ko] MMMM[ren] D[a]',
        lll: 'YYYY[ko] MMMM[ren] D[a] HH:mm',
        llll: 'dddd, YYYY[ko] MMMM[ren] D[a] HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s barru',
        past: 'duela %s',
        s: 'segundo batzuk',
        m: 'minutu bat',
        mm: '%d minutu',
        h: 'ordu bat',
        hh: '%d ordu',
        d: 'egun bat',
        dd: '%d egun',
        mo: 'hilabete bat',
        mos: '%d hilabete',
        y: 'urte bat',
        yy: '%d urte',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
