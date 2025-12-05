// KN Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Kannada locale.
class HoraLocaleKn extends HoraLocale {
  const HoraLocaleKn();

  @override
  String get code => 'kn';

  @override
  List<String> get months => const [
        'ಜನವರಿ',
        'ಫೆಬ್ರವರಿ',
        'ಮಾರ್ಚ್',
        'ಏಪ್ರಿಲ್',
        'ಮೇ',
        'ಜೂನ್',
        'ಜುಲೈ',
        'ಆಗಸ್ಟ್',
        'ಸೆಪ್ಟೆಂಬರ್',
        'ಅಕ್ಟೋಬರ್',
        'ನವೆಂಬರ್',
        'ಡಿಸೆಂಬರ್',
      ];

  @override
  List<String> get monthsShort => const [
        'ಜನ',
        'ಫೆಬ್ರ',
        'ಮಾರ್ಚ್',
        'ಏಪ್ರಿಲ್',
        'ಮೇ',
        'ಜೂನ್',
        'ಜುಲೈ',
        'ಆಗಸ್ಟ್',
        'ಸೆಪ್ಟೆಂ',
        'ಅಕ್ಟೋ',
        'ನವೆಂ',
        'ಡಿಸೆಂ',
      ];

  @override
  List<String> get weekdays => const [
        'ಭಾನುವಾರ',
        'ಸೋಮವಾರ',
        'ಮಂಗಳವಾರ',
        'ಬುಧವಾರ',
        'ಗುರುವಾರ',
        'ಶುಕ್ರವಾರ',
        'ಶನಿವಾರ',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ಭಾನು',
        'ಸೋಮ',
        'ಮಂಗಳ',
        'ಬುಧ',
        'ಗುರು',
        'ಶುಕ್ರ',
        'ಶನಿ',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ಭಾ',
        'ಸೋ',
        'ಮಂ',
        'ಬು',
        'ಗು',
        'ಶು',
        'ಶ',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'A h:mm',
        lts: 'A h:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY, A h:mm',
        llll: 'dddd, D MMMM YYYY, A h:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s ನಂತರ',
        past: '%s ಹಿಂದೆ',
        s: 'ಕೆಲವು ಕ್ಷಣಗಳು',
        m: 'ಒಂದು ನಿಮಿಷ',
        mm: '%d ನಿಮಿಷ',
        h: 'ಒಂದು ಗಂಟೆ',
        hh: '%d ಗಂಟೆ',
        d: 'ಒಂದು ದಿನ',
        dd: '%d ದಿನ',
        mo: 'ಒಂದು ತಿಂಗಳು',
        mos: '%d ತಿಂಗಳು',
        y: 'ಒಂದು ವರ್ಷ',
        yy: '%d ವರ್ಷ',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
