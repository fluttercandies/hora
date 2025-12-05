// TZM Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Central Atlas Tamazight locale.
class HoraLocaleTzm extends HoraLocale {
  const HoraLocaleTzm();

  @override
  String get code => 'tzm';

  @override
  List<String> get months => const [
        'ⵉⵏⵏⴰⵢⵔ',
        'ⴱⵕⴰⵢⵕ',
        'ⵎⴰⵕⵚ',
        'ⵉⴱⵔⵉⵔ',
        'ⵎⴰⵢⵢⵓ',
        'ⵢⵓⵏⵢⵓ',
        'ⵢⵓⵍⵢⵓⵣ',
        'ⵖⵓⵛⵜ',
        'ⵛⵓⵜⴰⵏⴱⵉⵔ',
        'ⴽⵟⵓⴱⵕ',
        'ⵏⵓⵡⴰⵏⴱⵉⵔ',
        'ⴷⵓⵊⵏⴱⵉⵔ',
      ];

  @override
  List<String> get monthsShort => const [
        'ⵉⵏⵏⴰⵢⵔ',
        'ⴱⵕⴰⵢⵕ',
        'ⵎⴰⵕⵚ',
        'ⵉⴱⵔⵉⵔ',
        'ⵎⴰⵢⵢⵓ',
        'ⵢⵓⵏⵢⵓ',
        'ⵢⵓⵍⵢⵓⵣ',
        'ⵖⵓⵛⵜ',
        'ⵛⵓⵜⴰⵏⴱⵉⵔ',
        'ⴽⵟⵓⴱⵕ',
        'ⵏⵓⵡⴰⵏⴱⵉⵔ',
        'ⴷⵓⵊⵏⴱⵉⵔ',
      ];

  @override
  List<String> get weekdays => const [
        'ⴰⵙⴰⵎⴰⵙ',
        'ⴰⵢⵏⴰⵙ',
        'ⴰⵙⵉⵏⴰⵙ',
        'ⴰⴽⵔⴰⵙ',
        'ⴰⴽⵡⴰⵙ',
        'ⴰⵙⵉⵎⵡⴰⵙ',
        'ⴰⵙⵉⴹⵢⴰⵙ',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ⴰⵙⴰⵎⴰⵙ',
        'ⴰⵢⵏⴰⵙ',
        'ⴰⵙⵉⵏⴰⵙ',
        'ⴰⴽⵔⴰⵙ',
        'ⴰⴽⵡⴰⵙ',
        'ⴰⵙⵉⵎⵡⴰⵙ',
        'ⴰⵙⵉⴹⵢⴰⵙ',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ⴰⵙⴰⵎⴰⵙ',
        'ⴰⵢⵏⴰⵙ',
        'ⴰⵙⵉⵏⴰⵙ',
        'ⴰⴽⵔⴰⵙ',
        'ⴰⴽⵡⴰⵙ',
        'ⴰⵙⵉⵎⵡⴰⵙ',
        'ⴰⵙⵉⴹⵢⴰⵙ',
      ];

  @override
  int get weekStart => 6;

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
        future: 'ⴷⴰⴷⵅ ⵙ ⵢⴰⵏ %s',
        past: 'ⵢⴰⵏ %s',
        s: 'ⵉⵎⵉⴽ',
        m: 'ⵎⵉⵏⵓⴺ',
        mm: '%d ⵎⵉⵏⵓⴺ',
        h: 'ⵙⴰⵄⴰ',
        hh: '%d ⵜⴰⵙⵙⴰⵄⵉⵏ',
        d: 'ⴰⵙⵙ',
        dd: '%d oⵙⵙⴰⵏ',
        mo: 'ⴰⵢoⵓⵔ',
        mos: '%d ⵉⵢⵢⵉⵔⵏ',
        y: 'ⴰⵙⴳⴰⵙ',
        yy: '%d ⵉⵙⴳⴰⵙⵏ',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
