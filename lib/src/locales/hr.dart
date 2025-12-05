// HR Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Croatian locale.
class HoraLocaleHr extends HoraLocale {
  const HoraLocaleHr();

  @override
  String get code => 'hr';

  @override
  List<String> get months => const [
        'siječanj',
        'veljača',
        'ožujak',
        'travanj',
        'svibanj',
        'lipanj',
        'srpanj',
        'kolovoz',
        'rujan',
        'listopad',
        'studeni',
        'prosinac',
      ];

  @override
  List<String> get monthsShort => const [
        'sij.',
        'velj.',
        'ožu.',
        'tra.',
        'svi.',
        'lip.',
        'srp.',
        'kol.',
        'ruj.',
        'lis.',
        'stu.',
        'pro.',
      ];

  @override
  List<String> get weekdays => const [
        'nedjelja',
        'ponedjeljak',
        'utorak',
        'srijeda',
        'četvrtak',
        'petak',
        'subota',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ned.',
        'pon.',
        'uto.',
        'sri.',
        'čet.',
        'pet.',
        'sub.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ne',
        'po',
        'ut',
        'sr',
        'če',
        'pe',
        'su',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'H:mm',
        lts: 'H:mm:ss',
        l: 'DD.MM.YYYY',
        ll: 'D. MMMM YYYY',
        lll: 'D. MMMM YYYY H:mm',
        llll: 'dddd, D. MMMM YYYY H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'za %s',
        past: 'prije %s',
        s: 'sekunda',
        m: 'minuta',
        mm: '%d minuta',
        h: 'sat',
        hh: '%d sati',
        d: 'dan',
        dd: '%d dana',
        mo: 'mjesec',
        mos: '%d mjeseci',
        y: 'godina',
        yy: '%d godine',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
