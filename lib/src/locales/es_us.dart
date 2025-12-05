// ES-US Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Spanish (United States) locale.
class HoraLocaleEsUs extends HoraLocale {
  const HoraLocaleEsUs();

  @override
  String get code => 'es-us';

  @override
  List<String> get months => const [
        'enero',
        'febrero',
        'marzo',
        'abril',
        'mayo',
        'junio',
        'julio',
        'agosto',
        'septiembre',
        'octubre',
        'noviembre',
        'diciembre',
      ];

  @override
  List<String> get monthsShort => const [
        'ene',
        'feb',
        'mar',
        'abr',
        'may',
        'jun',
        'jul',
        'ago',
        'sep',
        'oct',
        'nov',
        'dic',
      ];

  @override
  List<String> get weekdays => const [
        'domingo',
        'lunes',
        'martes',
        'miércoles',
        'jueves',
        'viernes',
        'sábado',
      ];

  @override
  List<String> get weekdaysShort => const [
        'dom.',
        'lun.',
        'mar.',
        'mié.',
        'jue.',
        'vie.',
        'sáb.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'do',
        'lu',
        'ma',
        'mi',
        'ju',
        'vi',
        'sá',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        ll: 'D [de] MMMM [de] YYYY',
        lll: 'D [de] MMMM [de] YYYY h:mm A',
        llll: 'dddd, D [de] MMMM [de] YYYY h:mm A',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'en %s',
        past: 'hace %s',
        s: 'unos segundos',
        m: 'un minuto',
        mm: '%d minutos',
        h: 'una hora',
        hh: '%d horas',
        d: 'un día',
        dd: '%d días',
        mo: 'un mes',
        mos: '%d meses',
        y: 'un año',
        yy: '%d años',
      );

  @override
  String ordinal(int n, [String? unit]) => '$nº';
}
