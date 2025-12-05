// SK Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Slovak locale.
class HoraLocaleSk extends HoraLocale {
  const HoraLocaleSk();

  @override
  String get code => 'sk';

  @override
  List<String> get months => const [
        'január',
        'február',
        'marec',
        'apríl',
        'máj',
        'jún',
        'júl',
        'august',
        'september',
        'október',
        'november',
        'december',
      ];

  @override
  List<String> get monthsShort => const [
        'jan',
        'feb',
        'mar',
        'apr',
        'máj',
        'jún',
        'júl',
        'aug',
        'sep',
        'okt',
        'nov',
        'dec',
      ];

  @override
  List<String> get weekdays => const [
        'nedeľa',
        'pondelok',
        'utorok',
        'streda',
        'štvrtok',
        'piatok',
        'sobota',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ne',
        'po',
        'ut',
        'st',
        'št',
        'pi',
        'so',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ne',
        'po',
        'ut',
        'st',
        'št',
        'pi',
        'so',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 4;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'H:mm',
        lts: 'H:mm:ss',
        l: 'DD.MM.YYYY',
        ll: 'D. MMMM YYYY',
        lll: 'D. MMMM YYYY H:mm',
        llll: 'dddd D. MMMM YYYY H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'za %s',
        past: 'pred %s',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
