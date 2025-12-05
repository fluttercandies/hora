// ID Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Indonesian locale.
class HoraLocaleId extends HoraLocale {
  const HoraLocaleId();

  @override
  String get code => 'id';

  @override
  List<String> get months => const [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];

  @override
  List<String> get monthsShort => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agt',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];

  @override
  List<String> get weekdays => const [
        'Minggu',
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Min',
        'Sen',
        'Sel',
        'Rab',
        'Kam',
        'Jum',
        'Sab',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Mg',
        'Sn',
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
        past: '%s yang lalu',
        s: 'beberapa detik',
        m: 'semenit',
        mm: '%d menit',
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
  String ordinal(int n, [String? unit]) => '$n.';
}
