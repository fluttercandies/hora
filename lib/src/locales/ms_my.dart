// MS-MY Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Malay (Malaysia) locale.
class HoraLocaleMsMy extends HoraLocale {
  const HoraLocaleMsMy();

  @override
  String get code => 'ms-my';

  @override
  List<String> get months => const [
        'Januari',
        'Februari',
        'Mac',
        'April',
        'Mei',
        'Jun',
        'Julai',
        'Ogos',
        'September',
        'Oktober',
        'November',
        'Disember',
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
        'Ogs',
        'Sep',
        'Okt',
        'Nov',
        'Dis',
      ];

  @override
  List<String> get weekdays => const [
        'Ahad',
        'Isnin',
        'Selasa',
        'Rabu',
        'Khamis',
        'Jumaat',
        'Sabtu',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Ahd',
        'Isn',
        'Sel',
        'Rab',
        'Kha',
        'Jum',
        'Sab',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Ah',
        'Is',
        'Sl',
        'Rb',
        'Km',
        'Jm',
        'Sb',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH.mm',
        lts: 'HH.mm.ss',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY [pukul] HH.mm',
        llll: 'dddd, D MMMM YYYY [pukul] HH.mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'dalam %s',
        past: '%s yang lepas',
        s: 'beberapa saat',
        m: 'seminit',
        mm: '%d minit',
        h: 'sejam',
        hh: '%d jam',
        d: 'sehari',
        dd: '%d hari',
        mo: 'sebulan',
        mos: '%d bulan',
        y: 'setahun',
        yy: '%d tahun',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
