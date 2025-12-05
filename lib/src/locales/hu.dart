// HU Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Hungarian locale.
class HoraLocaleHu extends HoraLocale {
  const HoraLocaleHu();

  @override
  String get code => 'hu';

  @override
  List<String> get months => const [
        'január',
        'február',
        'március',
        'április',
        'május',
        'június',
        'július',
        'augusztus',
        'szeptember',
        'október',
        'november',
        'december',
      ];

  @override
  List<String> get monthsShort => const [
        'jan',
        'feb',
        'márc',
        'ápr',
        'máj',
        'jún',
        'júl',
        'aug',
        'szept',
        'okt',
        'nov',
        'dec',
      ];

  @override
  List<String> get weekdays => const [
        'vasárnap',
        'hétfő',
        'kedd',
        'szerda',
        'csütörtök',
        'péntek',
        'szombat',
      ];

  @override
  List<String> get weekdaysShort => const [
        'vas',
        'hét',
        'kedd',
        'sze',
        'csüt',
        'pén',
        'szo',
      ];

  @override
  List<String> get weekdaysMin => const [
        'v',
        'h',
        'k',
        'sze',
        'cs',
        'p',
        'szo',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'H:mm',
        lts: 'H:mm:ss',
        l: 'YYYY.MM.DD.',
        ll: 'YYYY. MMMM D.',
        lll: 'YYYY. MMMM D. H:mm',
        llll: 'YYYY. MMMM D., dddd H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s múlva',
        past: '%s',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
