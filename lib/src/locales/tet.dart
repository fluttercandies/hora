// TET Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Tetum locale.
class HoraLocaleTet extends HoraLocale {
  const HoraLocaleTet();

  @override
  String get code => 'tet';

  @override
  List<String> get months => const [
        'Janeiru',
        'Fevereiru',
        'Marsu',
        'Abril',
        'Maiu',
        'Juñu',
        'Jullu',
        'Agustu',
        'Setembru',
        'Outubru',
        'Novembru',
        'Dezembru',
      ];

  @override
  List<String> get monthsShort => const [
        'Jan',
        'Fev',
        'Mar',
        'Abr',
        'Mai',
        'Jun',
        'Jul',
        'Ago',
        'Set',
        'Out',
        'Nov',
        'Dez',
      ];

  @override
  List<String> get weekdays => const [
        'Domingu',
        'Segunda',
        'Tersa',
        'Kuarta',
        'Kinta',
        'Sesta',
        'Sabadu',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Dom',
        'Seg',
        'Ters',
        'Kua',
        'Kint',
        'Sest',
        'Sab',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Do',
        'Seg',
        'Te',
        'Ku',
        'Ki',
        'Ses',
        'Sa',
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
        future: 'iha %s',
        past: '%s liuba',
        s: 'minutu balun',
        m: 'minutu ida',
        mm: 'minutu %d',
        h: 'oras ida',
        hh: 'oras %d',
        d: 'loron ida',
        dd: 'loron %d',
        mo: 'fulan ida',
        mos: 'fulan %d',
        y: 'tinan ida',
        yy: 'tinan %d',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
