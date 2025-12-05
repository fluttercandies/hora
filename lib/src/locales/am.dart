// AM Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Amharic locale.
class HoraLocaleAm extends HoraLocale {
  const HoraLocaleAm();

  @override
  String get code => 'am';

  @override
  List<String> get months => const [
        'ጃንዋሪ',
        'ፌብሯሪ',
        'ማርች',
        'ኤፕሪል',
        'ሜይ',
        'ጁን',
        'ጁላይ',
        'ኦገስት',
        'ሴፕቴምበር',
        'ኦክቶበር',
        'ኖቬምበር',
        'ዲሴምበር',
      ];

  @override
  List<String> get monthsShort => const [
        'ጃንዋ',
        'ፌብሯ',
        'ማርች',
        'ኤፕሪ',
        'ሜይ',
        'ጁን',
        'ጁላይ',
        'ኦገስ',
        'ሴፕቴ',
        'ኦክቶ',
        'ኖቬም',
        'ዲሴም',
      ];

  @override
  List<String> get weekdays => const [
        'እሑድ',
        'ሰኞ',
        'ማክሰኞ',
        'ረቡዕ',
        'ሐሙስ',
        'አርብ',
        'ቅዳሜ',
      ];

  @override
  List<String> get weekdaysShort => const [
        'እሑድ',
        'ሰኞ',
        'ማክሰ',
        'ረቡዕ',
        'ሐሙስ',
        'አርብ',
        'ቅዳሜ',
      ];

  @override
  List<String> get weekdaysMin => const [
        'እሑ',
        'ሰኞ',
        'ማክ',
        'ረቡ',
        'ሐሙ',
        'አር',
        'ቅዳ',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 4;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'MMMM D ፣ YYYY',
        lll: 'MMMM D ፣ YYYY HH:mm',
        llll: 'dddd ፣ MMMM D ፣ YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'በ%s',
        past: '%s በፊት',
        s: 'ጥቂት ሰከንዶች',
        m: 'አንድ ደቂቃ',
        mm: '%d ደቂቃዎች',
        h: 'አንድ ሰዓት',
        hh: '%d ሰዓታት',
        d: 'አንድ ቀን',
        dd: '%d ቀናት',
        mo: 'አንድ ወር',
        mos: '%d ወራት',
        y: 'አንድ ዓመት',
        yy: '%d ዓመታት',
      );

  @override
  String ordinal(int n, [String? unit]) => '$nኛ';
}
