// SW Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Swahili locale.
class HoraLocaleSw extends HoraLocale {
  const HoraLocaleSw();

  @override
  String get code => 'sw';

  @override
  List<String> get months => const [
        'Januari',
        'Februari',
        'Machi',
        'Aprili',
        'Mei',
        'Juni',
        'Julai',
        'Agosti',
        'Septemba',
        'Oktoba',
        'Novemba',
        'Desemba',
      ];

  @override
  List<String> get monthsShort => const [
        'Jan',
        'Feb',
        'Mac',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Ago',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];

  @override
  List<String> get weekdays => const [
        'Jumapili',
        'Jumatatu',
        'Jumanne',
        'Jumatano',
        'Alhamisi',
        'Ijumaa',
        'Jumamosi',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Jpl',
        'Jtat',
        'Jnne',
        'Jtan',
        'Alh',
        'Ijm',
        'Jmos',
      ];

  @override
  List<String> get weekdaysMin => const [
        'J2',
        'J3',
        'J4',
        'J5',
        'Al',
        'Ij',
        'J1',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD.MM.YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY HH:mm',
        llll: 'dddd, D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s baadaye',
        past: 'tokea %s',
        s: 'hivi punde',
        m: 'dakika moja',
        mm: 'dakika %d',
        h: 'saa limoja',
        hh: 'masaa %d',
        d: 'siku moja',
        dd: 'masiku %d',
        mo: 'mwezi mmoja',
        mos: 'miezi %d',
        y: 'mwaka mmoja',
        yy: 'miaka %d',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
