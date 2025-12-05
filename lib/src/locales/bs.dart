// BS Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Bosnian locale.
class HoraLocaleBs extends HoraLocale {
  const HoraLocaleBs();

  @override
  String get code => 'bs';

  @override
  List<String> get months => const [
        'januar',
        'februar',
        'mart',
        'april',
        'maj',
        'juni',
        'juli',
        'august',
        'septembar',
        'oktobar',
        'novembar',
        'decembar',
      ];

  @override
  List<String> get monthsShort => const [
        'jan.',
        'feb.',
        'mar.',
        'apr.',
        'maj.',
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
        'nedjelja',
        'ponedjeljak',
        'utorak',
        'srijeda',
        'četvrtak',
        'petak',
        'subota',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ned.',
        'pon.',
        'uto.',
        'sri.',
        'čet.',
        'pet.',
        'sub.',
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
        l: 'DD.MM.YYYY',
        ll: 'D. MMMM YYYY',
        lll: 'D. MMMM YYYY H:mm',
        llll: 'dddd, D. MMMM YYYY H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
