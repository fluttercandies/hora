// UZ Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Uzbek locale.
class HoraLocaleUz extends HoraLocale {
  const HoraLocaleUz();

  @override
  String get code => 'uz';

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
        'Якшанба',
        'Душанба',
        'Сешанба',
        'Чоршанба',
        'Пайшанба',
        'Жума',
        'Шанба',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Якш',
        'Душ',
        'Сеш',
        'Чор',
        'Пай',
        'Жум',
        'Шан',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Як',
        'Ду',
        'Се',
        'Чо',
        'Па',
        'Жу',
        'Ша',
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
        llll: 'D MMMM YYYY, dddd HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'Якин %s ичида',
        past: '%s олдин',
        s: 'фурсат',
        m: 'бир дакика',
        mm: '%d дакика',
        h: 'бир соат',
        hh: '%d соат',
        d: 'бир кун',
        dd: '%d кун',
        mo: 'бир ой',
        mos: '%d ой',
        y: 'бир йил',
        yy: '%d йил',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
