// SR Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Serbian locale.
class HoraLocaleSr extends HoraLocale {
  const HoraLocaleSr();

  @override
  String get code => 'sr';

  @override
  List<String> get months => const [
        'Januar',
        'Februar',
        'Mart',
        'April',
        'Maj',
        'Jun',
        'Jul',
        'Avgust',
        'Septembar',
        'Oktobar',
        'Novembar',
        'Decembar',
      ];

  @override
  List<String> get monthsShort => const [
        'Jan.',
        'Feb.',
        'Mar.',
        'Apr.',
        'Maj',
        'Jun',
        'Jul',
        'Avg.',
        'Sep.',
        'Okt.',
        'Nov.',
        'Dec.',
      ];

  @override
  List<String> get weekdays => const [
        'Nedelja',
        'Ponedeljak',
        'Utorak',
        'Sreda',
        'Četvrtak',
        'Petak',
        'Subota',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Ned.',
        'Pon.',
        'Uto.',
        'Sre.',
        'Čet.',
        'Pet.',
        'Sub.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ne',
        'po',
        'ut',
        'sr',
        'če',
        'pe',
        'su',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'H:mm',
        lts: 'H:mm:ss',
        l: 'D. M. YYYY.',
        ll: 'D. MMMM YYYY.',
        lll: 'D. MMMM YYYY. H:mm',
        llll: 'dddd, D. MMMM YYYY. H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'za %s',
        past: 'pre %s',
        s: 'nekoliko sekundi',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
