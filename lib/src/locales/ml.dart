// ML Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Malayalam locale.
class HoraLocaleMl extends HoraLocale {
  const HoraLocaleMl();

  @override
  String get code => 'ml';

  @override
  List<String> get months => const [
        'ജനുവരി',
        'ഫെബ്രുവരി',
        'മാർച്ച്',
        'ഏപ്രിൽ',
        'മേയ്',
        'ജൂൺ',
        'ജൂലൈ',
        'ഓഗസ്റ്റ്',
        'സെപ്റ്റംബർ',
        'ഒക്ടോബർ',
        'നവംബർ',
        'ഡിസംബർ',
      ];

  @override
  List<String> get monthsShort => const [
        'ജനു.',
        'ഫെബ്രു.',
        'മാർ.',
        'ഏപ്രി.',
        'മേയ്',
        'ജൂൺ',
        'ജൂലൈ.',
        'ഓഗ.',
        'സെപ്റ്റ.',
        'ഒക്ടോ.',
        'നവം.',
        'ഡിസം.',
      ];

  @override
  List<String> get weekdays => const [
        'ഞായറാഴ്ച',
        'തിങ്കളാഴ്ച',
        'ചൊവ്വാഴ്ച',
        'ബുധനാഴ്ച',
        'വ്യാഴാഴ്ച',
        'വെള്ളിയാഴ്ച',
        'ശനിയാഴ്ച',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ഞായർ',
        'തിങ്കൾ',
        'ചൊവ്വ',
        'ബുധൻ',
        'വ്യാഴം',
        'വെള്ളി',
        'ശനി',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ഞാ',
        'തി',
        'ചൊ',
        'ബു',
        'വ്യാ',
        'വെ',
        'ശ',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'A h:mm -നു',
        lts: 'A h:mm:ss -നു',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY, A h:mm -നു',
        llll: 'dddd, D MMMM YYYY, A h:mm -നു',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s കഴിഞ്ഞ്',
        past: '%s മുൻപ്',
        s: 'അൽപ നിമിഷങ്ങൾ',
        m: 'ഒരു മിനിറ്റ്',
        mm: '%d മിനിറ്റ്',
        h: 'ഒരു മണിക്കൂർ',
        hh: '%d മണിക്കൂർ',
        d: 'ഒരു ദിവസം',
        dd: '%d ദിവസം',
        mo: 'ഒരു മാസം',
        mos: '%d മാസം',
        y: 'ഒരു വർഷം',
        yy: '%d വർഷം',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
