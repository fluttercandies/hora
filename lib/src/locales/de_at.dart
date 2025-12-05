// DE-AT Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// German (Austria) locale.
class HoraLocaleDeAt extends HoraLocale {
  const HoraLocaleDeAt();

  @override
  String get code => 'de-at';

  @override
  List<String> get months => const [
        'Jänner',
        'Februar',
        'März',
        'April',
        'Mai',
        'Juni',
        'Juli',
        'August',
        'September',
        'Oktober',
        'November',
        'Dezember',
      ];

  @override
  List<String> get monthsShort => const [
        'Jän.',
        'Feb.',
        'März',
        'Apr.',
        'Mai',
        'Juni',
        'Juli',
        'Aug.',
        'Sep.',
        'Okt.',
        'Nov.',
        'Dez.',
      ];

  @override
  List<String> get weekdays => const [
        'Sonntag',
        'Montag',
        'Dienstag',
        'Mittwoch',
        'Donnerstag',
        'Freitag',
        'Samstag',
      ];

  @override
  List<String> get weekdaysShort => const [
        'So.',
        'Mo.',
        'Di.',
        'Mi.',
        'Do.',
        'Fr.',
        'Sa.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'So',
        'Mo',
        'Di',
        'Mi',
        'Do',
        'Fr',
        'Sa',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD.MM.YYYY',
        ll: 'D. MMMM YYYY',
        lll: 'D. MMMM YYYY HH:mm',
        llll: 'dddd, D. MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        past: 'vor %s',
        s: 'ein paar Sekunden',
        mm: '%d Minuten',
        hh: '%d Stunden',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
