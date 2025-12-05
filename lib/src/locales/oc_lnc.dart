// OC-LNC Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Occitan locale.
class HoraLocaleOcLnc extends HoraLocale {
  const HoraLocaleOcLnc();

  @override
  String get code => 'oc-lnc';

  @override
  List<String> get months => const [
        'genièr',
        'febrièr',
        'març',
        'abrial',
        'mai',
        'junh',
        'julhet',
        'agost',
        'setembre',
        'octòbre',
        'novembre',
        'decembre',
      ];

  @override
  List<String> get monthsShort => const [
        'gen',
        'feb',
        'març',
        'abr',
        'mai',
        'junh',
        'julh',
        'ago',
        'set',
        'oct',
        'nov',
        'dec',
      ];

  @override
  List<String> get weekdays => const [
        'dimenge',
        'diluns',
        'dimars',
        'dimècres',
        'dijòus',
        'divendres',
        'dissabte',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Dg',
        'Dl',
        'Dm',
        'Dc',
        'Dj',
        'Dv',
        'Ds',
      ];

  @override
  List<String> get weekdaysMin => const [
        'dg',
        'dl',
        'dm',
        'dc',
        'dj',
        'dv',
        'ds',
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
        lll: 'D MMMM [de] YYYY [a] H:mm',
        llll: 'dddd D MMMM [de] YYYY [a] H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: r'd\',
        past: 'fa %s',
        s: 'unas segondas',
        m: 'una minuta',
        mm: '%d minutas',
        h: 'una ora',
        hh: '%d oras',
        d: 'un jorn',
        dd: '%d jorns',
        mo: 'un mes',
        mos: '%d meses',
        y: 'un an',
        yy: '%d ans',
      );

  @override
  String ordinal(int n, [String? unit]) => '$nº';
}
