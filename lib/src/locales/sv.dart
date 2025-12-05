// SV Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Swedish locale.
class HoraLocaleSv extends HoraLocale {
  const HoraLocaleSv();

  @override
  String get code => 'sv';

  @override
  List<String> get months => const [
        'januari',
        'februari',
        'mars',
        'april',
        'maj',
        'juni',
        'juli',
        'augusti',
        'september',
        'oktober',
        'november',
        'december',
      ];

  @override
  List<String> get monthsShort => const [
        'jan',
        'feb',
        'mar',
        'apr',
        'maj',
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
        'söndag',
        'måndag',
        'tisdag',
        'onsdag',
        'torsdag',
        'fredag',
        'lördag',
      ];

  @override
  List<String> get weekdaysShort => const [
        'sön',
        'mån',
        'tis',
        'ons',
        'tor',
        'fre',
        'lör',
      ];

  @override
  List<String> get weekdaysMin => const [
        'sö',
        'må',
        'ti',
        'on',
        'to',
        'fr',
        'lö',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 4;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'YYYY-MM-DD',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY [kl.] HH:mm',
        llll: 'dddd D MMMM YYYY [kl.] HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'om %s',
        past: 'för %s sedan',
        s: 'några sekunder',
        m: 'en minut',
        mm: '%d minuter',
        h: 'en timme',
        hh: '%d timmar',
        d: 'en dag',
        dd: '%d dagar',
        mo: 'en månad',
        mos: '%d månader',
        y: 'ett år',
        yy: '%d år',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
