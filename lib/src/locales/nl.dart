// NL Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Dutch locale.
class HoraLocaleNl extends HoraLocale {
  const HoraLocaleNl();

  @override
  String get code => 'nl';

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
        'jan',
        'feb',
        'mrt',
        'apr',
        'mei',
        'jun',
        'jul',
        'aug',
        'sep',
        'okt',
        'nov',
        'dec',
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
  int get yearStart => 4;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD-MM-YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY HH:mm',
        llll: 'dddd D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'over %s',
        past: '%s geleden',
        s: 'een paar seconden',
        m: 'een minuut',
        mm: '%d minuten',
        h: 'een uur',
        hh: '%d uur',
        d: 'een dag',
        dd: '%d dagen',
        mo: 'een maand',
        mos: '%d maanden',
        y: 'een jaar',
        yy: '%d jaar',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
