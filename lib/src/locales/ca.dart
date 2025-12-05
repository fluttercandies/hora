// CA Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Catalan locale.
class HoraLocaleCa extends HoraLocale {
  const HoraLocaleCa();

  @override
  String get code => 'ca';

  @override
  List<String> get months => const [
        'Gener',
        'Febrer',
        'Març',
        'Abril',
        'Maig',
        'Juny',
        'Juliol',
        'Agost',
        'Setembre',
        'Octubre',
        'Novembre',
        'Desembre',
      ];

  @override
  List<String> get monthsShort => const [
        'Gen.',
        'Febr.',
        'Març',
        'Abr.',
        'Maig',
        'Juny',
        'Jul.',
        'Ag.',
        'Set.',
        'Oct.',
        'Nov.',
        'Des.',
      ];

  @override
  List<String> get weekdays => const [
        'Diumenge',
        'Dilluns',
        'Dimarts',
        'Dimecres',
        'Dijous',
        'Divendres',
        'Dissabte',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Dg.',
        'Dl.',
        'Dt.',
        'Dc.',
        'Dj.',
        'Dv.',
        'Ds.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Dg',
        'Dl',
        'Dt',
        'Dc',
        'Dj',
        'Dv',
        'Ds',
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
        ll: 'D MMMM [de] YYYY',
        lll: 'D MMMM [de] YYYY [a les] H:mm',
        llll: 'dddd D MMMM [de] YYYY [a les] H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: r'd\',
        past: 'fa %s',
        s: 'uns segons',
        m: 'un minut',
        mm: '%d minuts',
        h: 'una hora',
        hh: '%d hores',
        d: 'un dia',
        dd: '%d dies',
        mo: 'un mes',
        mos: '%d mesos',
        y: 'un any',
        yy: '%d anys',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
