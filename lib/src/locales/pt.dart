// PT Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Portuguese locale.
class HoraLocalePt extends HoraLocale {
  const HoraLocalePt();

  @override
  String get code => 'pt';

  @override
  List<String> get months => const [
        'janeiro',
        'fevereiro',
        'março',
        'abril',
        'maio',
        'junho',
        'julho',
        'agosto',
        'setembro',
        'outubro',
        'novembro',
        'dezembro',
      ];

  @override
  List<String> get monthsShort => const [
        'jan',
        'fev',
        'mar',
        'abr',
        'mai',
        'jun',
        'jul',
        'ago',
        'set',
        'out',
        'nov',
        'dez',
      ];

  @override
  List<String> get weekdays => const [
        'domingo',
        'segunda-feira',
        'terça-feira',
        'quarta-feira',
        'quinta-feira',
        'sexta-feira',
        'sábado',
      ];

  @override
  List<String> get weekdaysShort => const [
        'dom',
        'seg',
        'ter',
        'qua',
        'qui',
        'sex',
        'sab',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Do',
        '2ª',
        '3ª',
        '4ª',
        '5ª',
        '6ª',
        'Sa',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 4;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'D [de] MMMM [de] YYYY',
        lll: 'D [de] MMMM [de] YYYY [às] HH:mm',
        llll: 'dddd, D [de] MMMM [de] YYYY [às] HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'em %s',
        past: 'há %s',
        s: 'alguns segundos',
        m: 'um minuto',
        mm: '%d minutos',
        h: 'uma hora',
        hh: '%d horas',
        d: 'um dia',
        dd: '%d dias',
        mo: 'um mês',
        mos: '%d meses',
        y: 'um ano',
        yy: '%d anos',
      );

  @override
  String ordinal(int n, [String? unit]) => '$nº';
}
