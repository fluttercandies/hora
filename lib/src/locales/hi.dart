// HI Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Hindi locale.
class HoraLocaleHi extends HoraLocale {
  const HoraLocaleHi();

  @override
  String get code => 'hi';

  @override
  List<String> get months => const [
        'जनवरी',
        'फ़रवरी',
        'मार्च',
        'अप्रैल',
        'मई',
        'जून',
        'जुलाई',
        'अगस्त',
        'सितम्बर',
        'अक्टूबर',
        'नवम्बर',
        'दिसम्बर',
      ];

  @override
  List<String> get monthsShort => const [
        'जन.',
        'फ़र.',
        'मार्च',
        'अप्रै.',
        'मई',
        'जून',
        'जुल.',
        'अग.',
        'सित.',
        'अक्टू.',
        'नव.',
        'दिस.',
      ];

  @override
  List<String> get weekdays => const [
        'रविवार',
        'सोमवार',
        'मंगलवार',
        'बुधवार',
        'गुरूवार',
        'शुक्रवार',
        'शनिवार',
      ];

  @override
  List<String> get weekdaysShort => const [
        'रवि',
        'सोम',
        'मंगल',
        'बुध',
        'गुरू',
        'शुक्र',
        'शनि',
      ];

  @override
  List<String> get weekdaysMin => const [
        'र',
        'सो',
        'मं',
        'बु',
        'गु',
        'शु',
        'श',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'A h:mm बजे',
        lts: 'A h:mm:ss बजे',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY, A h:mm बजे',
        llll: 'dddd, D MMMM YYYY, A h:mm बजे',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s में',
        past: '%s पहले',
        s: 'कुछ ही क्षण',
        m: 'एक मिनट',
        mm: '%d मिनट',
        h: 'एक घंटा',
        hh: '%d घंटे',
        d: 'एक दिन',
        dd: '%d दिन',
        mo: 'एक महीने',
        mos: '%d महीने',
        y: 'एक वर्ष',
        yy: '%d वर्ष',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
