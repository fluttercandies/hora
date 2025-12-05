// GL Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Galician locale.
class HoraLocaleGl extends HoraLocale {
  const HoraLocaleGl();

  @override
  String get code => 'gl';

  @override
  List<String> get months => const [
        'xaneiro',
        'febreiro',
        'marzo',
        'abril',
        'maio',
        'xuño',
        'xullo',
        'agosto',
        'setembro',
        'outubro',
        'novembro',
        'decembro',
      ];

  @override
  List<String> get monthsShort => const [
        'xan.',
        'feb.',
        'mar.',
        'abr.',
        'mai.',
        'xuñ.',
        'xul.',
        'ago.',
        'set.',
        'out.',
        'nov.',
        'dec.',
      ];

  @override
  List<String> get weekdays => const [
        'domingo',
        'luns',
        'martes',
        'mércores',
        'xoves',
        'venres',
        'sábado',
      ];

  @override
  List<String> get weekdaysShort => const [
        'dom.',
        'lun.',
        'mar.',
        'mér.',
        'xov.',
        'ven.',
        'sáb.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'do',
        'lu',
        'ma',
        'mé',
        'xo',
        've',
        'sá',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'H:mm',
        lts: 'H:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'D [de] MMMM [de] YYYY',
        lll: 'D [de] MMMM [de] YYYY H:mm',
        llll: 'dddd, D [de] MMMM [de] YYYY H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'en %s',
        past: 'fai %s',
        s: 'uns segundos',
        m: 'un minuto',
        mm: '%d minutos',
        h: 'unha hora',
        hh: '%d horas',
        d: 'un día',
        dd: '%d días',
        mo: 'un mes',
        mos: '%d meses',
        y: 'un ano',
        yy: '%d anos',
      );

  @override
  String ordinal(int n, [String? unit]) => '$nº';
}
