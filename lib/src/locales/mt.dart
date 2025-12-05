// MT Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Maltese locale.
class HoraLocaleMt extends HoraLocale {
  const HoraLocaleMt();

  @override
  String get code => 'mt';

  @override
  List<String> get months => const [
        'Jannar',
        'Frar',
        'Marzu',
        'April',
        'Mejju',
        'Ġunju',
        'Lulju',
        'Awwissu',
        'Settembru',
        'Ottubru',
        'Novembru',
        'Diċembru',
      ];

  @override
  List<String> get monthsShort => const [
        'Jan',
        'Fra',
        'Mar',
        'Apr',
        'Mej',
        'Ġun',
        'Lul',
        'Aww',
        'Set',
        'Ott',
        'Nov',
        'Diċ',
      ];

  @override
  List<String> get weekdays => const [
        'Il-Ħadd',
        'It-Tnejn',
        'It-Tlieta',
        'L-Erbgħa',
        'Il-Ħamis',
        'Il-Ġimgħa',
        'Is-Sibt',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Ħad',
        'Tne',
        'Tli',
        'Erb',
        'Ħam',
        'Ġim',
        'Sib',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Ħa',
        'Tn',
        'Tl',
        'Er',
        'Ħa',
        'Ġi',
        'Si',
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
        future: 'f’ %s',
        past: '%s ilu',
        s: 'ftit sekondi',
        m: 'minuta',
        mm: '%d minuti',
        h: 'siegħa',
        hh: '%d siegħat',
        d: 'ġurnata',
        dd: '%d ġranet',
        mo: 'xahar',
        mos: '%d xhur',
        y: 'sena',
        yy: '%d sni',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
