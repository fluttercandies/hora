// JV Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Javanese locale.
class HoraLocaleJv extends HoraLocale {
  const HoraLocaleJv();

  @override
  String get code => 'jv';

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
        'Nopember',
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
        'Ags',
        'Sep',
        'Okt',
        'Nop',
        'Des',
      ];

  @override
  List<String> get weekdays => const [
        'Minggu',
        'Senen',
        'Seloso',
        'Rebu',
        'Kemis',
        'Jemuwah',
        'Septu',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Min',
        'Sen',
        'Sel',
        'Reb',
        'Kem',
        'Jem',
        'Sep',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Mg',
        'Sn',
        'Sl',
        'Rb',
        'Km',
        'Jm',
        'Sp',
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
        future: 'wonten ing %s',
        past: '%s ingkang kepengker',
        s: 'sawetawis detik',
        m: 'setunggal menit',
        mm: '%d menit',
        h: 'setunggal jam',
        hh: '%d jam',
        d: 'sedinten',
        dd: '%d dinten',
        mo: 'sewulan',
        mos: '%d wulan',
        y: 'setaun',
        yy: '%d taun',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
