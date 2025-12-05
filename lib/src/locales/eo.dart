// EO Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Esperanto locale.
class HoraLocaleEo extends HoraLocale {
  const HoraLocaleEo();

  @override
  String get code => 'eo';

  @override
  List<String> get months => const [
        'januaro',
        'februaro',
        'marto',
        'aprilo',
        'majo',
        'junio',
        'julio',
        'aŭgusto',
        'septembro',
        'oktobro',
        'novembro',
        'decembro',
      ];

  @override
  List<String> get monthsShort => const [
        'jan',
        'feb',
        'mar',
        'apr',
        'maj',
        'jun',
        'jul',
        'aŭg',
        'sep',
        'okt',
        'nov',
        'dec',
      ];

  @override
  List<String> get weekdays => const [
        'dimanĉo',
        'lundo',
        'mardo',
        'merkredo',
        'ĵaŭdo',
        'vendredo',
        'sabato',
      ];

  @override
  List<String> get weekdaysShort => const [
        'dim',
        'lun',
        'mard',
        'merk',
        'ĵaŭ',
        'ven',
        'sab',
      ];

  @override
  List<String> get weekdaysMin => const [
        'di',
        'lu',
        'ma',
        'me',
        'ĵa',
        've',
        'sa',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'YYYY-MM-DD',
        ll: 'D[-a de] MMMM, YYYY',
        lll: 'D[-a de] MMMM, YYYY HH:mm',
        llll: 'dddd, [la] D[-a de] MMMM, YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'post %s',
        past: 'antaŭ %s',
        s: 'sekundoj',
        m: 'minuto',
        mm: '%d minutoj',
        h: 'horo',
        hh: '%d horoj',
        d: 'tago',
        dd: '%d tagoj',
        mo: 'monato',
        mos: '%d monatoj',
        y: 'jaro',
        yy: '%d jaroj',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
