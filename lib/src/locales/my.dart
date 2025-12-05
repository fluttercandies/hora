// MY Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Burmese locale.
class HoraLocaleMy extends HoraLocale {
  const HoraLocaleMy();

  @override
  String get code => 'my';

  @override
  List<String> get months => const [
        'ဇန်နဝါရီ',
        'ဖေဖော်ဝါရီ',
        'မတ်',
        'ဧပြီ',
        'မေ',
        'ဇွန်',
        'ဇူလိုင်',
        'သြဂုတ်',
        'စက်တင်ဘာ',
        'အောက်တိုဘာ',
        'နိုဝင်ဘာ',
        'ဒီဇင်ဘာ',
      ];

  @override
  List<String> get monthsShort => const [
        'ဇန်',
        'ဖေ',
        'မတ်',
        'ပြီ',
        'မေ',
        'ဇွန်',
        'လိုင်',
        'သြ',
        'စက်',
        'အောက်',
        'နို',
        'ဒီ',
      ];

  @override
  List<String> get weekdays => const [
        'တနင်္ဂနွေ',
        'တနင်္လာ',
        'အင်္ဂါ',
        'ဗုဒ္ဓဟူး',
        'ကြာသပတေး',
        'သောကြာ',
        'စနေ',
      ];

  @override
  List<String> get weekdaysShort => const [
        'နွေ',
        'လာ',
        'ဂါ',
        'ဟူး',
        'ကြာ',
        'သော',
        'နေ',
      ];

  @override
  List<String> get weekdaysMin => const [
        'နွေ',
        'လာ',
        'ဂါ',
        'ဟူး',
        'ကြာ',
        'သော',
        'နေ',
      ];

  @override
  int get weekStart => 1;

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
        future: 'လာမည့် %s မှာ',
        past: 'လွန်ခဲ့သော %s က',
        s: 'စက္ကန်.အနည်းငယ်',
        m: 'တစ်မိနစ်',
        mm: '%d မိနစ်',
        h: 'တစ်နာရီ',
        hh: '%d နာရီ',
        d: 'တစ်ရက်',
        dd: '%d ရက်',
        mo: 'တစ်လ',
        mos: '%d လ',
        y: 'တစ်နှစ်',
        yy: '%d နှစ်',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
