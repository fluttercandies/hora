// TL-PH Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Tagalog (Philippines) locale.
class HoraLocaleTlPh extends HoraLocale {
  const HoraLocaleTlPh();

  @override
  String get code => 'tl-ph';

  @override
  List<String> get months => const [
        'Enero',
        'Pebrero',
        'Marso',
        'Abril',
        'Mayo',
        'Hunyo',
        'Hulyo',
        'Agosto',
        'Setyembre',
        'Oktubre',
        'Nobyembre',
        'Disyembre',
      ];

  @override
  List<String> get monthsShort => const [
        'Ene',
        'Peb',
        'Mar',
        'Abr',
        'May',
        'Hun',
        'Hul',
        'Ago',
        'Set',
        'Okt',
        'Nob',
        'Dis',
      ];

  @override
  List<String> get weekdays => const [
        'Linggo',
        'Lunes',
        'Martes',
        'Miyerkules',
        'Huwebes',
        'Biyernes',
        'Sabado',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Lin',
        'Lun',
        'Mar',
        'Miy',
        'Huw',
        'Biy',
        'Sab',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Li',
        'Lu',
        'Ma',
        'Mi',
        'Hu',
        'Bi',
        'Sab',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'MM/D/YYYY',
        lll: 'MMMM D, YYYY HH:mm',
        llll: 'dddd, MMMM DD, YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'sa loob ng %s',
        past: '%s ang nakalipas',
        s: 'ilang segundo',
        m: 'isang minuto',
        mm: '%d minuto',
        h: 'isang oras',
        hh: '%d oras',
        d: 'isang araw',
        dd: '%d araw',
        mo: 'isang buwan',
        mos: '%d buwan',
        y: 'isang taon',
        yy: '%d taon',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
