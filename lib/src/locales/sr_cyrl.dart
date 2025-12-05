// SR-CYRL Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Serbian (Cyrillic) locale.
class HoraLocaleSrCyrl extends HoraLocale {
  const HoraLocaleSrCyrl();

  @override
  String get code => 'sr-cyrl';

  @override
  List<String> get months => const [
        'Јануар',
        'Фебруар',
        'Март',
        'Април',
        'Мај',
        'Јун',
        'Јул',
        'Август',
        'Септембар',
        'Октобар',
        'Новембар',
        'Децембар',
      ];

  @override
  List<String> get monthsShort => const [
        'Јан.',
        'Феб.',
        'Мар.',
        'Апр.',
        'Мај',
        'Јун',
        'Јул',
        'Авг.',
        'Сеп.',
        'Окт.',
        'Нов.',
        'Дец.',
      ];

  @override
  List<String> get weekdays => const [
        'Недеља',
        'Понедељак',
        'Уторак',
        'Среда',
        'Четвртак',
        'Петак',
        'Субота',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Нед.',
        'Пон.',
        'Уто.',
        'Сре.',
        'Чет.',
        'Пет.',
        'Суб.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'не',
        'по',
        'ут',
        'ср',
        'че',
        'пе',
        'су',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'H:mm',
        lts: 'H:mm:ss',
        l: 'D. M. YYYY.',
        ll: 'D. MMMM YYYY.',
        lll: 'D. MMMM YYYY. H:mm',
        llll: 'dddd, D. MMMM YYYY. H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'за %s',
        past: 'пре %s',
        s: 'неколико секунди',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
