// DA Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Danish locale.
class HoraLocaleDa extends HoraLocale {
  const HoraLocaleDa();

  @override
  String get code => 'da';

  @override
  List<String> get months => const [
        'januar',
        'februar',
        'marts',
        'april',
        'maj',
        'juni',
        'juli',
        'august',
        'september',
        'oktober',
        'november',
        'december',
      ];

  @override
  List<String> get monthsShort => const [
        'jan.',
        'feb.',
        'mar.',
        'apr.',
        'maj',
        'juni',
        'juli',
        'aug.',
        'sept.',
        'okt.',
        'nov.',
        'dec.',
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
        'søn.',
        'man.',
        'tirs.',
        'ons.',
        'tors.',
        'fre.',
        'lør.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'sø.',
        'ma.',
        'ti.',
        'on.',
        'to.',
        'fr.',
        'lø.',
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
        lll: 'D. MMMM YYYY HH:mm',
        llll: 'dddd [d.] D. MMMM YYYY [kl.] HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'om %s',
        past: '%s siden',
        s: 'få sekunder',
        m: 'et minut',
        mm: '%d minutter',
        h: 'en time',
        hh: '%d timer',
        d: 'en dag',
        dd: '%d dage',
        mo: 'en måned',
        mos: '%d måneder',
        y: 'et år',
        yy: '%d år',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
