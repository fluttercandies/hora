// RO Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Romanian locale.
class HoraLocaleRo extends HoraLocale {
  const HoraLocaleRo();

  @override
  String get code => 'ro';

  @override
  List<String> get months => const [
        'Ianuarie',
        'Februarie',
        'Martie',
        'Aprilie',
        'Mai',
        'Iunie',
        'Iulie',
        'August',
        'Septembrie',
        'Octombrie',
        'Noiembrie',
        'Decembrie',
      ];

  @override
  List<String> get monthsShort => const [
        'Ian.',
        'Febr.',
        'Mart.',
        'Apr.',
        'Mai',
        'Iun.',
        'Iul.',
        'Aug.',
        'Sept.',
        'Oct.',
        'Nov.',
        'Dec.',
      ];

  @override
  List<String> get weekdays => const [
        'Duminică',
        'Luni',
        'Marți',
        'Miercuri',
        'Joi',
        'Vineri',
        'Sâmbătă',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Dum',
        'Lun',
        'Mar',
        'Mie',
        'Joi',
        'Vin',
        'Sâm',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Du',
        'Lu',
        'Ma',
        'Mi',
        'Jo',
        'Vi',
        'Sâ',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'H:mm',
        lts: 'H:mm:ss',
        l: 'DD.MM.YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY H:mm',
        llll: 'dddd, D MMMM YYYY H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'peste %s',
        past: 'acum %s',
        s: 'câteva secunde',
        m: 'un minut',
        mm: '%d minute',
        h: 'o oră',
        hh: '%d ore',
        d: 'o zi',
        dd: '%d zile',
        mo: 'o lună',
        mos: '%d luni',
        y: 'un an',
        yy: '%d ani',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
