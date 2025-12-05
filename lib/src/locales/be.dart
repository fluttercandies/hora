// BE Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Belarusian locale.
class HoraLocaleBe extends HoraLocale {
  const HoraLocaleBe();

  @override
  String get code => 'be';

  @override
  List<String> get months => const [
        'студзень',
        'лютый',
        'сакавік',
        'красавік',
        'травень',
        'чэрвень',
        'ліпень',
        'жнівень',
        'верасень',
        'кастрычнік',
        'лістапад',
        'снежань',
      ];

  @override
  List<String> get monthsShort => const [
        'студ',
        'лют',
        'сак',
        'крас',
        'трав',
        'чэрв',
        'ліп',
        'жнів',
        'вер',
        'каст',
        'ліст',
        'снеж',
      ];

  @override
  List<String> get weekdays => const [
        'нядзеля',
        'панядзелак',
        'аўторак',
        'серада',
        'чацвер',
        'пятніца',
        'субота',
      ];

  @override
  List<String> get weekdaysShort => const [
        'няд',
        'пнд',
        'аўт',
        'сер',
        'чцв',
        'пят',
        'суб',
      ];

  @override
  List<String> get weekdaysMin => const [
        'нд',
        'пн',
        'аў',
        'ср',
        'чц',
        'пт',
        'сб',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 4;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD.MM.YYYY',
        ll: 'D MMMM YYYY г.',
        lll: 'D MMMM YYYY г., HH:mm',
        llll: 'dddd, D MMMM YYYY г., HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'праз %s',
        past: '%s таму',
        s: 'некалькі секунд',
        d: 'дзень',
        dd: 'дзень_дні_дзён',
        mo: 'месяц',
        mos: 'месяц_месяцы_месяцаў',
        y: 'год',
        yy: 'год_гады_гадоў',
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
