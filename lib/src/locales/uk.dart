// UK Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Ukrainian locale.
class HoraLocaleUk extends HoraLocale {
  const HoraLocaleUk();

  @override
  String get code => 'uk';

  @override
  List<String> get months => const [
        'січень',
        'лютий',
        'березень',
        'квітень',
        'травень',
        'червень',
        'липень',
        'серпень',
        'вересень',
        'жовтень',
        'листопад',
        'грудень',
      ];

  @override
  List<String> get monthsShort => const [
        'січ',
        'лют',
        'бер',
        'квіт',
        'трав',
        'черв',
        'лип',
        'серп',
        'вер',
        'жовт',
        'лист',
        'груд',
      ];

  @override
  List<String> get weekdays => const [
        'неділя',
        'понеділок',
        'вівторок',
        'середа',
        'четвер',
        'п’ятниця',
        'субота',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ндл',
        'пнд',
        'втр',
        'срд',
        'чтв',
        'птн',
        'сбт',
      ];

  @override
  List<String> get weekdaysMin => const [
        'нд',
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
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD.MM.YYYY',
        ll: 'D MMMM YYYY р.',
        lll: 'D MMMM YYYY р., HH:mm',
        llll: 'dddd, D MMMM YYYY р., HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'за %s',
        past: '%s тому',
        s: 'декілька секунд',
        d: 'день',
        dd: 'день_дні_днів',
        mo: 'місяць',
        mos: 'місяць_місяці_місяців',
        y: 'рік',
        yy: 'рік_роки_років',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
