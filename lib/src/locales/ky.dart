// KY Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Kyrgyz locale.
class HoraLocaleKy extends HoraLocale {
  const HoraLocaleKy();

  @override
  String get code => 'ky';

  @override
  List<String> get months => const [
        'январь',
        'февраль',
        'март',
        'апрель',
        'май',
        'июнь',
        'июль',
        'август',
        'сентябрь',
        'октябрь',
        'ноябрь',
        'декабрь',
      ];

  @override
  List<String> get monthsShort => const [
        'янв',
        'фев',
        'март',
        'апр',
        'май',
        'июнь',
        'июль',
        'авг',
        'сен',
        'окт',
        'ноя',
        'дек',
      ];

  @override
  List<String> get weekdays => const [
        'Жекшемби',
        'Дүйшөмбү',
        'Шейшемби',
        'Шаршемби',
        'Бейшемби',
        'Жума',
        'Ишемби',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Жек',
        'Дүй',
        'Шей',
        'Шар',
        'Бей',
        'Жум',
        'Ише',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Жк',
        'Дй',
        'Шй',
        'Шр',
        'Бй',
        'Жм',
        'Иш',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD.MM.YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY HH:mm',
        llll: 'dddd, D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s ичинде',
        past: '%s мурун',
        s: 'бирнече секунд',
        m: 'бир мүнөт',
        mm: '%d мүнөт',
        h: 'бир саат',
        hh: '%d саат',
        d: 'бир күн',
        dd: '%d күн',
        mo: 'бир ай',
        mos: '%d ай',
        y: 'бир жыл',
        yy: '%d жыл',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
