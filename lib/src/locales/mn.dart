// MN Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Mongolian locale.
class HoraLocaleMn extends HoraLocale {
  const HoraLocaleMn();

  @override
  String get code => 'mn';

  @override
  List<String> get months => const [
        'Нэгдүгээр сар',
        'Хоёрдугаар сар',
        'Гуравдугаар сар',
        'Дөрөвдүгээр сар',
        'Тавдугаар сар',
        'Зургадугаар сар',
        'Долдугаар сар',
        'Наймдугаар сар',
        'Есдүгээр сар',
        'Аравдугаар сар',
        'Арван нэгдүгээр сар',
        'Арван хоёрдугаар сар',
      ];

  @override
  List<String> get monthsShort => const [
        '1 сар',
        '2 сар',
        '3 сар',
        '4 сар',
        '5 сар',
        '6 сар',
        '7 сар',
        '8 сар',
        '9 сар',
        '10 сар',
        '11 сар',
        '12 сар',
      ];

  @override
  List<String> get weekdays => const [
        'Ням',
        'Даваа',
        'Мягмар',
        'Лхагва',
        'Пүрэв',
        'Баасан',
        'Бямба',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Ням',
        'Дав',
        'Мяг',
        'Лха',
        'Пүр',
        'Баа',
        'Бям',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Ня',
        'Да',
        'Мя',
        'Лх',
        'Пү',
        'Ба',
        'Бя',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'YYYY-MM-DD',
        ll: 'YYYY оны MMMMын D',
        lll: 'YYYY оны MMMMын D HH:mm',
        llll: 'dddd, YYYY оны MMMMын D HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s',
        past: '%s',
        s: 'саяхан',
        m: 'м',
        mm: '%dм',
        h: '1ц',
        hh: '%dц',
        d: '1ө',
        dd: '%dө',
        mo: '1с',
        mos: '%dс',
        y: '1ж',
        yy: '%dж',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
