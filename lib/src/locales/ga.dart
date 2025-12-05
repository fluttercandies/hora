// GA Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Irish locale.
class HoraLocaleGa extends HoraLocale {
  const HoraLocaleGa();

  @override
  String get code => 'ga';

  @override
  List<String> get months => const [
        'Eanáir',
        'Feabhra',
        'Márta',
        'Aibreán',
        'Bealtaine',
        'Meitheamh',
        'Iúil',
        'Lúnasa',
        'Meán Fómhair',
        'Deireadh Fómhair',
        'Samhain',
        'Nollaig',
      ];

  @override
  List<String> get monthsShort => const [
        'Ean',
        'Fea',
        'Már',
        'Aib',
        'Beal',
        'Mei',
        'Iúil',
        'Lún',
        'MFómh',
        'DFómh',
        'Samh',
        'Noll',
      ];

  @override
  List<String> get weekdays => const [
        'Dé Domhnaigh',
        'Dé Luain',
        'Dé Máirt',
        'Dé Céadaoin',
        'Déardaoin',
        'Dé hAoine',
        'Dé Sathairn',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Dom',
        'Lua',
        'Mái',
        'Céa',
        'Déa',
        'Aoi',
        'Sat',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Do',
        'Lu',
        'Má',
        'Cé',
        'Dé',
        'Ao',
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
        future: 'i %s',
        past: '%s ó shin',
        s: 'cúpla soicind',
        m: 'nóiméad',
        mm: '%d nóiméad',
        h: 'uair an chloig',
        hh: '%d uair an chloig',
        d: 'lá',
        dd: '%d lá',
        mo: 'mí',
        mos: '%d mí',
        y: 'bliain',
        yy: '%d bliain',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
