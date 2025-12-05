// SL Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Slovenian locale.
class HoraLocaleSl extends HoraLocale {
  const HoraLocaleSl();

  @override
  String get code => 'sl';

  @override
  List<String> get months => const [
        'januar',
        'februar',
        'marec',
        'april',
        'maj',
        'junij',
        'julij',
        'avgust',
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
        'maj.',
        'jun.',
        'jul.',
        'avg.',
        'sep.',
        'okt.',
        'nov.',
        'dec.',
      ];

  @override
  List<String> get weekdays => const [
        'nedelja',
        'ponedeljek',
        'torek',
        'sreda',
        'četrtek',
        'petek',
        'sobota',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ned.',
        'pon.',
        'tor.',
        'sre.',
        'čet.',
        'pet.',
        'sob.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ne',
        'po',
        'to',
        'sr',
        'če',
        'pe',
        'so',
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
        future: 'čez %s',
        past: 'pred %s',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
