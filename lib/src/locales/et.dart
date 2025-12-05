// ET Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Estonian locale.
class HoraLocaleEt extends HoraLocale {
  const HoraLocaleEt();

  @override
  String get code => 'et';

  @override
  List<String> get months => const [
        'jaanuar',
        'veebruar',
        'märts',
        'aprill',
        'mai',
        'juuni',
        'juuli',
        'august',
        'september',
        'oktoober',
        'november',
        'detsember',
      ];

  @override
  List<String> get monthsShort => const [
        'jaan',
        'veebr',
        'märts',
        'apr',
        'mai',
        'juuni',
        'juuli',
        'aug',
        'sept',
        'okt',
        'nov',
        'dets',
      ];

  @override
  List<String> get weekdays => const [
        'pühapäev',
        'esmaspäev',
        'teisipäev',
        'kolmapäev',
        'neljapäev',
        'reede',
        'laupäev',
      ];

  @override
  List<String> get weekdaysShort => const [
        'P',
        'E',
        'T',
        'K',
        'N',
        'R',
        'L',
      ];

  @override
  List<String> get weekdaysMin => const [
        'P',
        'E',
        'T',
        'K',
        'N',
        'R',
        'L',
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
        future: '%s pärast',
        past: '%s tagasi',
        dd: '%d päeva',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
