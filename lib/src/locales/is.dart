// IS Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Icelandic locale.
class HoraLocaleIs extends HoraLocale {
  const HoraLocaleIs();

  @override
  String get code => 'is';

  @override
  List<String> get months => const [
        'janúar',
        'febrúar',
        'mars',
        'apríl',
        'maí',
        'júní',
        'júlí',
        'ágúst',
        'september',
        'október',
        'nóvember',
        'desember',
      ];

  @override
  List<String> get monthsShort => const [
        'jan',
        'feb',
        'mar',
        'apr',
        'maí',
        'jún',
        'júl',
        'ágú',
        'sep',
        'okt',
        'nóv',
        'des',
      ];

  @override
  List<String> get weekdays => const [
        'sunnudagur',
        'mánudagur',
        'þriðjudagur',
        'miðvikudagur',
        'fimmtudagur',
        'föstudagur',
        'laugardagur',
      ];

  @override
  List<String> get weekdaysShort => const [
        'sun',
        'mán',
        'þri',
        'mið',
        'fim',
        'fös',
        'lau',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Su',
        'Má',
        'Þr',
        'Mi',
        'Fi',
        'Fö',
        'La',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'H:mm',
        lts: 'H:mm:ss',
        l: 'DD.MM.YYYY',
        ll: 'D. MMMM YYYY',
        lll: 'D. MMMM YYYY [kl.] H:mm',
        llll: 'dddd, D. MMMM YYYY [kl.] H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'eftir %s',
        past: 'fyrir %s síðan',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
