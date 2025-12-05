// NL-BE Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Dutch (Belgium) locale.
class HoraLocaleNlBe extends HoraLocale {
  const HoraLocaleNlBe();

  @override
  String get code => 'nl-be';

  @override
  List<String> get months => const [
        'januari',
        'februari',
        'maart',
        'april',
        'mei',
        'juni',
        'juli',
        'augustus',
        'september',
        'oktober',
        'november',
        'december',
      ];

  @override
  List<String> get monthsShort => const [
        'jan.',
        'feb.',
        'mrt.',
        'apr.',
        'mei',
        'jun.',
        'jul.',
        'aug.',
        'sep.',
        'okt.',
        'nov.',
        'dec.',
      ];

  @override
  List<String> get weekdays => const [
        'zondag',
        'maandag',
        'dinsdag',
        'woensdag',
        'donderdag',
        'vrijdag',
        'zaterdag',
      ];

  @override
  List<String> get weekdaysShort => const [
        'zo.',
        'ma.',
        'di.',
        'wo.',
        'do.',
        'vr.',
        'za.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'zo',
        'ma',
        'di',
        'wo',
        'do',
        'vr',
        'za',
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
        llll: 'dddd D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'over %s',
        past: '%s geleden',
        s: 'een paar seconden',
        m: 'één minuut',
        mm: '%d minuten',
        h: 'één uur',
        hh: '%d uur',
        d: 'één dag',
        dd: '%d dagen',
        mo: 'één maand',
        mos: '%d maanden',
        y: 'één jaar',
        yy: '%d jaar',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
