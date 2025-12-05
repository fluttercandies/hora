// TG Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Tajik locale.
class HoraLocaleTg extends HoraLocale {
  const HoraLocaleTg();

  @override
  String get code => 'tg';

  @override
  List<String> get months => const [
        'январ',
        'феврал',
        'март',
        'апрел',
        'май',
        'июн',
        'июл',
        'август',
        'сентябр',
        'октябр',
        'ноябр',
        'декабр',
      ];

  @override
  List<String> get monthsShort => const [
        'янв',
        'фев',
        'мар',
        'апр',
        'май',
        'июн',
        'июл',
        'авг',
        'сен',
        'окт',
        'ноя',
        'дек',
      ];

  @override
  List<String> get weekdays => const [
        'якшанбе',
        'душанбе',
        'сешанбе',
        'чоршанбе',
        'панҷшанбе',
        'ҷумъа',
        'шанбе',
      ];

  @override
  List<String> get weekdaysShort => const [
        'яшб',
        'дшб',
        'сшб',
        'чшб',
        'пшб',
        'ҷум',
        'шнб',
      ];

  @override
  List<String> get weekdaysMin => const [
        'яш',
        'дш',
        'сш',
        'чш',
        'пш',
        'ҷм',
        'шб',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY HH:mm',
        llll: 'dddd, D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'баъди %s',
        past: '%s пеш',
        s: 'якчанд сония',
        m: 'як дақиқа',
        mm: '%d дақиқа',
        h: 'як соат',
        hh: '%d соат',
        d: 'як рӯз',
        dd: '%d рӯз',
        mo: 'як моҳ',
        mos: '%d моҳ',
        y: 'як сол',
        yy: '%d сол',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
