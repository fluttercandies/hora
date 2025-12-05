// SI Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Sinhalese locale.
class HoraLocaleSi extends HoraLocale {
  const HoraLocaleSi();

  @override
  String get code => 'si';

  @override
  List<String> get months => const [
        'දුරුතු',
        'නවම්',
        'මැදින්',
        'බක්',
        'වෙසක්',
        'පොසොන්',
        'ඇසළ',
        'නිකිණි',
        'බිනර',
        'වප්',
        'ඉල්',
        'උඳුවප්',
      ];

  @override
  List<String> get monthsShort => const [
        'දුරු',
        'නව',
        'මැදි',
        'බක්',
        'වෙස',
        'පොසො',
        'ඇස',
        'නිකි',
        'බින',
        'වප්',
        'ඉල්',
        'උඳු',
      ];

  @override
  List<String> get weekdays => const [
        'ඉරිදා',
        'සඳුදා',
        'අඟහරුවාදා',
        'බදාදා',
        'බ්‍රහස්පතින්දා',
        'සිකුරාදා',
        'සෙනසුරාදා',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ඉරි',
        'සඳු',
        'අඟ',
        'බදා',
        'බ්‍රහ',
        'සිකු',
        'සෙන',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ඉ',
        'ස',
        'අ',
        'බ',
        'බ්‍ර',
        'සි',
        'සෙ',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'a h:mm',
        lts: 'a h:mm:ss',
        l: 'YYYY/MM/DD',
        ll: 'YYYY MMMM D',
        lll: 'YYYY MMMM D, a h:mm',
        llll: 'YYYY MMMM D [වැනි] dddd, a h:mm:ss',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%sකින්',
        past: '%sකට පෙර',
        s: 'තත්පර කිහිපය',
        m: 'විනාඩිය',
        mm: 'විනාඩි %d',
        h: 'පැය',
        hh: 'පැය %d',
        d: 'දිනය',
        dd: 'දින %d',
        mo: 'මාසය',
        mos: 'මාස %d',
        y: 'වසර',
        yy: 'වසර %d',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
