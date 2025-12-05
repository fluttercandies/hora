// PA-IN Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Punjabi (India) locale.
class HoraLocalePaIn extends HoraLocale {
  const HoraLocalePaIn();

  @override
  String get code => 'pa-in';

  @override
  List<String> get months => const [
        'ਜਨਵਰੀ',
        'ਫ਼ਰਵਰੀ',
        'ਮਾਰਚ',
        'ਅਪ੍ਰੈਲ',
        'ਮਈ',
        'ਜੂਨ',
        'ਜੁਲਾਈ',
        'ਅਗਸਤ',
        'ਸਤੰਬਰ',
        'ਅਕਤੂਬਰ',
        'ਨਵੰਬਰ',
        'ਦਸੰਬਰ',
      ];

  @override
  List<String> get monthsShort => const [
        'ਜਨਵਰੀ',
        'ਫ਼ਰਵਰੀ',
        'ਮਾਰਚ',
        'ਅਪ੍ਰੈਲ',
        'ਮਈ',
        'ਜੂਨ',
        'ਜੁਲਾਈ',
        'ਅਗਸਤ',
        'ਸਤੰਬਰ',
        'ਅਕਤੂਬਰ',
        'ਨਵੰਬਰ',
        'ਦਸੰਬਰ',
      ];

  @override
  List<String> get weekdays => const [
        'ਐਤਵਾਰ',
        'ਸੋਮਵਾਰ',
        'ਮੰਗਲਵਾਰ',
        'ਬੁਧਵਾਰ',
        'ਵੀਰਵਾਰ',
        'ਸ਼ੁੱਕਰਵਾਰ',
        'ਸ਼ਨੀਚਰਵਾਰ',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ਐਤ',
        'ਸੋਮ',
        'ਮੰਗਲ',
        'ਬੁਧ',
        'ਵੀਰ',
        'ਸ਼ੁਕਰ',
        'ਸ਼ਨੀ',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ਐਤ',
        'ਸੋਮ',
        'ਮੰਗਲ',
        'ਬੁਧ',
        'ਵੀਰ',
        'ਸ਼ੁਕਰ',
        'ਸ਼ਨੀ',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'A h:mm ਵਜੇ',
        lts: 'A h:mm:ss ਵਜੇ',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY, A h:mm ਵਜੇ',
        llll: 'dddd, D MMMM YYYY, A h:mm ਵਜੇ',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s ਵਿੱਚ',
        past: '%s ਪਿਛਲੇ',
        s: 'ਕੁਝ ਸਕਿੰਟ',
        m: 'ਇਕ ਮਿੰਟ',
        mm: '%d ਮਿੰਟ',
        h: 'ਇੱਕ ਘੰਟਾ',
        hh: '%d ਘੰਟੇ',
        d: 'ਇੱਕ ਦਿਨ',
        dd: '%d ਦਿਨ',
        mo: 'ਇੱਕ ਮਹੀਨਾ',
        mos: '%d ਮਹੀਨੇ',
        y: 'ਇੱਕ ਸਾਲ',
        yy: '%d ਸਾਲ',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
