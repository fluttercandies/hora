// NB Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Norwegian Bokmål locale.
class HoraLocaleNb extends HoraLocale {
  const HoraLocaleNb();

  @override
  String get code => 'nb';

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
        'jan.',
        'feb.',
        'mars',
        'april',
        'mai',
        'juni',
        'juli',
        'aug.',
        'sep.',
        'okt.',
        'nov.',
        'des.',
      ];

  @override
  List<String> get weekdays => const [
        'søndag',
        'mandag',
        'tirsdag',
        'onsdag',
        'torsdag',
        'fredag',
        'lørdag',
      ];

  @override
  List<String> get weekdaysShort => const [
        'sø.',
        'ma.',
        'ti.',
        'on.',
        'to.',
        'fr.',
        'lø.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'sø',
        'ma',
        'ti',
        'on',
        'to',
        'fr',
        'lø',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 4;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD.MM.YYYY',
        ll: 'D. MMMM YYYY',
        lll: 'D. MMMM YYYY [kl.] HH:mm',
        llll: 'dddd D. MMMM YYYY [kl.] HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'om %s',
        past: '%s siden',
        s: 'noen sekunder',
        m: 'ett minutt',
        mm: '%d minutter',
        h: 'en time',
        hh: '%d timer',
        d: 'en dag',
        dd: '%d dager',
        mo: 'en måned',
        mos: '%d måneder',
        y: 'ett år',
        yy: '%d år',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
