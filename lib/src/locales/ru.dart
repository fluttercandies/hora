// RU Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Russian locale.
class HoraLocaleRu extends HoraLocale {
  const HoraLocaleRu();

  @override
  String get code => 'ru';

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
        'янв.',
        'февр.',
        'март',
        'апр.',
        'май',
        'июнь',
        'июль',
        'авг.',
        'сент.',
        'окт.',
        'нояб.',
        'дек.',
      ];

  @override
  List<String> get weekdays => const [
        'воскресенье',
        'понедельник',
        'вторник',
        'среда',
        'четверг',
        'пятница',
        'суббота',
      ];

  @override
  List<String> get weekdaysShort => const [
        'вск',
        'пнд',
        'втр',
        'срд',
        'чтв',
        'птн',
        'сбт',
      ];

  @override
  List<String> get weekdaysMin => const [
        'вс',
        'пн',
        'вт',
        'ср',
        'чт',
        'пт',
        'сб',
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
        ll: 'D MMMM YYYY г.',
        lll: 'D MMMM YYYY г., H:mm',
        llll: 'dddd, D MMMM YYYY г., H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'через %s',
        past: '%s назад',
        s: 'несколько секунд',
        h: 'час',
        hh: 'час_часа_часов',
        d: 'день',
        dd: 'день_дня_дней',
        mo: 'месяц',
        mos: 'месяц_месяца_месяцев',
        y: 'год',
        yy: 'год_года_лет',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
  // Note: Complex meridiem logic - may need manual adjustment
  @override
  String meridiem(int hour, int minute, {bool lowercase = false}) {
    final m = hour < 12 ? 'AM' : 'PM';
    return lowercase ? m.toLowerCase() : m;
  }
}
