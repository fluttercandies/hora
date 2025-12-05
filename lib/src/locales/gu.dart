// GU Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Gujarati locale.
class HoraLocaleGu extends HoraLocale {
  const HoraLocaleGu();

  @override
  String get code => 'gu';

  @override
  List<String> get months => const [
        'જાન્યુઆરી',
        'ફેબ્રુઆરી',
        'માર્ચ',
        'એપ્રિલ',
        'મે',
        'જૂન',
        'જુલાઈ',
        'ઑગસ્ટ',
        'સપ્ટેમ્બર',
        'ઑક્ટ્બર',
        'નવેમ્બર',
        'ડિસેમ્બર',
      ];

  @override
  List<String> get monthsShort => const [
        'જાન્યુ.',
        'ફેબ્રુ.',
        'માર્ચ',
        'એપ્રિ.',
        'મે',
        'જૂન',
        'જુલા.',
        'ઑગ.',
        'સપ્ટે.',
        'ઑક્ટ્.',
        'નવે.',
        'ડિસે.',
      ];

  @override
  List<String> get weekdays => const [
        'રવિવાર',
        'સોમવાર',
        'મંગળવાર',
        'બુધ્વાર',
        'ગુરુવાર',
        'શુક્રવાર',
        'શનિવાર',
      ];

  @override
  List<String> get weekdaysShort => const [
        'રવિ',
        'સોમ',
        'મંગળ',
        'બુધ્',
        'ગુરુ',
        'શુક્ર',
        'શનિ',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ર',
        'સો',
        'મં',
        'બુ',
        'ગુ',
        'શુ',
        'શ',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'A h:mm વાગ્યે',
        lts: 'A h:mm:ss વાગ્યે',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY, A h:mm વાગ્યે',
        llll: 'dddd, D MMMM YYYY, A h:mm વાગ્યે',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s મા',
        past: '%s પેહલા',
        s: 'અમુક પળો',
        m: 'એક મિનિટ',
        mm: '%d મિનિટ',
        h: 'એક કલાક',
        hh: '%d કલાક',
        d: 'એક દિવસ',
        dd: '%d દિવસ',
        mo: 'એક મહિનો',
        mos: '%d મહિનો',
        y: 'એક વર્ષ',
        yy: '%d વર્ષ',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
