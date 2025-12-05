// RN Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Kirundi locale.
class HoraLocaleRn extends HoraLocale {
  const HoraLocaleRn();

  @override
  String get code => 'rn';

  @override
  List<String> get months => const [
        'Nzero',
        'Ruhuhuma',
        'Ntwarante',
        'Ndamukiza',
        'Rusama',
        'Ruhenshi',
        'Mukakaro',
        'Myandagaro',
        'Nyakanga',
        'Gitugutu',
        'Munyonyo',
        'Kigarama',
      ];

  @override
  List<String> get monthsShort => const [
        'Nzer',
        'Ruhuh',
        'Ntwar',
        'Ndam',
        'Rus',
        'Ruhen',
        'Muk',
        'Myand',
        'Nyak',
        'Git',
        'Muny',
        'Kig',
      ];

  @override
  List<String> get weekdays => const [
        'Ku wa Mungu',
        'Ku wa Mbere',
        'Ku wa Kabiri',
        'Ku wa Gatatu',
        'Ku wa Kane',
        'Ku wa Gatanu',
        'Ku wa Gatandatu',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Kngu',
        'Kmbr',
        'Kbri',
        'Ktat',
        'Kkan',
        'Ktan',
        'Kdat',
      ];

  @override
  List<String> get weekdaysMin => const [
        'K7',
        'K1',
        'K2',
        'K3',
        'K4',
        'K5',
        'K6',
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
        llll: 'dddd, D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'mu %s',
        past: '%s',
        s: 'amasegonda',
        m: 'Umunota',
        mm: '%d iminota',
        h: 'isaha',
        hh: '%d amasaha',
        d: 'Umunsi',
        dd: '%d iminsi',
        mo: 'ukwezi',
        mos: '%d amezi',
        y: 'umwaka',
        yy: '%d imyaka',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
