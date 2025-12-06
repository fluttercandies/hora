// MR Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Marathi locale.
class HoraLocaleMr extends HoraLocale {
  const HoraLocaleMr();

  @override
  String get code => 'mr';

  @override
  List<String> get months => const [
        'जानेवारी',
        'फेब्रुवारी',
        'मार्च',
        'एप्रिल',
        'मे',
        'जून',
        'जुलै',
        'ऑगस्ट',
        'सप्टेंबर',
        'ऑक्टोबर',
        'नोव्हेंबर',
        'डिसेंबर',
      ];

  @override
  List<String> get monthsShort => const [
        'जाने.',
        'फेब्रु.',
        'मार्च.',
        'एप्रि.',
        'मे.',
        'जून.',
        'जुलै.',
        'ऑग.',
        'सप्टें.',
        'ऑक्टो.',
        'नोव्हें.',
        'डिसें.',
      ];

  @override
  List<String> get weekdays => const [
        'रविवार',
        'सोमवार',
        'मंगळवार',
        'बुधवार',
        'गुरूवार',
        'शुक्रवार',
        'शनिवार',
      ];

  @override
  List<String> get weekdaysShort => const [
        'रवि',
        'सोम',
        'मंगळ',
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
        lt: 'A h:mm वाजता',
        lts: 'A h:mm:ss वाजता',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY, A h:mm वाजता',
        llll: 'dddd, D MMMM YYYY, A h:mm वाजता',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime();

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
