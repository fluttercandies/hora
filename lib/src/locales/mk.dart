// MK Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Macedonian locale.
class HoraLocaleMk extends HoraLocale {
  const HoraLocaleMk();

  @override
  String get code => 'mk';

  @override
  List<String> get months => const [
        'јануари',
        'февруари',
        'март',
        'април',
        'мај',
        'јуни',
        'јули',
        'август',
        'септември',
        'октомври',
        'ноември',
        'декември',
      ];

  @override
  List<String> get monthsShort => const [
        'јан',
        'фев',
        'мар',
        'апр',
        'мај',
        'јун',
        'јул',
        'авг',
        'сеп',
        'окт',
        'ное',
        'дек',
      ];

  @override
  List<String> get weekdays => const [
        'недела',
        'понеделник',
        'вторник',
        'среда',
        'четврток',
        'петок',
        'сабота',
      ];

  @override
  List<String> get weekdaysShort => const [
        'нед',
        'пон',
        'вто',
        'сре',
        'чет',
        'пет',
        'саб',
      ];

  @override
  List<String> get weekdaysMin => const [
        'нe',
        'пo',
        'вт',
        'ср',
        'че',
        'пе',
        'сa',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'H:mm',
        lts: 'H:mm:ss',
        l: 'D.MM.YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY H:mm',
        llll: 'dddd, D MMMM YYYY H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'после %s',
        past: 'пред %s',
        s: 'неколку секунди',
        m: 'минута',
        mm: '%d минути',
        h: 'час',
        hh: '%d часа',
        d: 'ден',
        dd: '%d дена',
        mo: 'месец',
        mos: '%d месеци',
        y: 'година',
        yy: '%d години',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
