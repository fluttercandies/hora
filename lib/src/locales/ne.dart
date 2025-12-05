// NE Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Nepali locale.
class HoraLocaleNe extends HoraLocale {
  const HoraLocaleNe();

  @override
  String get code => 'ne';

  @override
  List<String> get months => const [
        'जनवरी',
        'फेब्रुवरी',
        'मार्च',
        'अप्रिल',
        'मे',
        'जुन',
        'जुलाई',
        'अगष्ट',
        'सेप्टेम्बर',
        'अक्टोबर',
        'नोभेम्बर',
        'डिसेम्बर',
      ];

  @override
  List<String> get monthsShort => const [
        'जन.',
        'फेब्रु.',
        'मार्च',
        'अप्रि.',
        'मई',
        'जुन',
        'जुलाई.',
        'अग.',
        'सेप्ट.',
        'अक्टो.',
        'नोभे.',
        'डिसे.',
      ];

  @override
  List<String> get weekdays => const [
        'आइतबार',
        'सोमबार',
        'मङ्गलबार',
        'बुधबार',
        'बिहिबार',
        'शुक्रबार',
        'शनिबार',
      ];

  @override
  List<String> get weekdaysShort => const [
        'आइत.',
        'सोम.',
        'मङ्गल.',
        'बुध.',
        'बिहि.',
        'शुक्र.',
        'शनि.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'आ.',
        'सो.',
        'मं.',
        'बु.',
        'बि.',
        'शु.',
        'श.',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'Aको h:mm बजे',
        lts: 'Aको h:mm:ss बजे',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY, Aको h:mm बजे',
        llll: 'dddd, D MMMM YYYY, Aको h:mm बजे',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s पछि',
        past: '%s अघि',
        s: 'सेकेन्ड',
        m: 'एक मिनेट',
        mm: '%d मिनेट',
        h: 'घन्टा',
        hh: '%d घन्टा',
        d: 'एक दिन',
        dd: '%d दिन',
        mo: 'एक महिना',
        mos: '%d महिना',
        y: 'एक वर्ष',
        yy: '%d वर्ष',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
