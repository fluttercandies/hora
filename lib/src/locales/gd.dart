// GD Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Scottish Gaelic locale.
class HoraLocaleGd extends HoraLocale {
  const HoraLocaleGd();

  @override
  String get code => 'gd';

  @override
  List<String> get months => const [
        'Am Faoilleach',
        'An Gearran',
        'Am Màrt',
        'An Giblean',
        'An Cèitean',
        'An t-Ògmhios',
        'An t-Iuchar',
        'An Lùnastal',
        'An t-Sultain',
        'An Dàmhair',
        'An t-Samhain',
        'An Dùbhlachd',
      ];

  @override
  List<String> get monthsShort => const [
        'Faoi',
        'Gear',
        'Màrt',
        'Gibl',
        'Cèit',
        'Ògmh',
        'Iuch',
        'Lùn',
        'Sult',
        'Dàmh',
        'Samh',
        'Dùbh',
      ];

  @override
  List<String> get weekdays => const [
        'Didòmhnaich',
        'Diluain',
        'Dimàirt',
        'Diciadain',
        'Diardaoin',
        'Dihaoine',
        'Disathairne',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Did',
        'Dil',
        'Dim',
        'Dic',
        'Dia',
        'Dih',
        'Dis',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Dò',
        'Lu',
        'Mà',
        'Ci',
        'Ar',
        'Ha',
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
        future: 'ann an %s',
        past: 'bho chionn %s',
        s: 'beagan diogan',
        m: 'mionaid',
        mm: '%d mionaidean',
        h: 'uair',
        hh: '%d uairean',
        d: 'latha',
        dd: '%d latha',
        mo: 'mìos',
        mos: '%d mìosan',
        y: 'bliadhna',
        yy: '%d bliadhna',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
