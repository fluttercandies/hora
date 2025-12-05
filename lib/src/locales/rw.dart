// RW Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Kinyarwanda locale.
class HoraLocaleRw extends HoraLocale {
  const HoraLocaleRw();

  @override
  String get code => 'rw';

  @override
  List<String> get months => const [
        'Mutarama',
        'Gashyantare',
        'Werurwe',
        'Mata',
        'Gicurasi',
        'Kamena',
        'Nyakanga',
        'Kanama',
        'Nzeri',
        'Ukwakira',
        'Ugushyingo',
        'Ukuboza',
      ];

  @override
  List<String> get monthsShort => const [
        'Mut',
        'Gas',
        'Wer',
        'Mat',
        'Gic',
        'Kam',
        'Nya',
        'Kan',
        'Nze',
        'Ukw',
        'Ugu',
        'Uku',
      ];

  @override
  List<String> get weekdays => const [
        'Ku Cyumweru',
        'Kuwa Mbere',
        'Kuwa Kabiri',
        'Kuwa Gatatu',
        'Kuwa Kane',
        'Kuwa Gatanu',
        'Kuwa Gatandatu',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Ku ',
        'Kuw',
        'Kuw',
        'Kuw',
        'Kuw',
        'Kuw',
        'Kuw',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Ku',
        'Ku',
        'Ku',
        'Ku',
        'Ku',
        'Ku',
        'Ku',
      ];

  @override
  int get weekStart => 7;

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
