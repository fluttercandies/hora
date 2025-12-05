// BG Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Bulgarian locale.
class HoraLocaleBg extends HoraLocale {
  const HoraLocaleBg();

  @override
  String get code => 'bg';

  @override
  List<String> get months => const [
        'януари',
        'февруари',
        'март',
        'април',
        'май',
        'юни',
        'юли',
        'август',
        'септември',
        'октомври',
        'ноември',
        'декември',
      ];

  @override
  List<String> get monthsShort => const [
        'яну',
        'фев',
        'мар',
        'апр',
        'май',
        'юни',
        'юли',
        'авг',
        'сеп',
        'окт',
        'ное',
        'дек',
      ];

  @override
  List<String> get weekdays => const [
        'неделя',
        'понеделник',
        'вторник',
        'сряда',
        'четвъртък',
        'петък',
        'събота',
      ];

  @override
  List<String> get weekdaysShort => const [
        'нед',
        'пон',
        'вто',
        'сря',
        'чет',
        'пет',
        'съб',
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
        lt: 'H:mm',
        lts: 'H:mm:ss',
        l: 'D.MM.YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY H:mm',
        llll: 'dddd, D MMMM YYYY H:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'след %s',
        past: 'преди %s',
        s: 'няколко секунди',
        m: 'минута',
        mm: '%d минути',
        h: 'час',
        hh: '%d часа',
        d: 'ден',
        dd: '%d дена',
        mo: 'месец',
        mos: '%d месеца',
        y: 'година',
        yy: '%d години',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
