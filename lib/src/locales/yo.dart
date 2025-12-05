// YO Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Yoruba locale.
class HoraLocaleYo extends HoraLocale {
  const HoraLocaleYo();

  @override
  String get code => 'yo';

  @override
  List<String> get months => const [
        'Sẹ́rẹ́',
        'Èrèlè',
        'Ẹrẹ̀nà',
        'Ìgbé',
        'Èbibi',
        'Òkùdu',
        'Agẹmo',
        'Ògún',
        'Owewe',
        'Ọ̀wàrà',
        'Bélú',
        'Ọ̀pẹ̀̀',
      ];

  @override
  List<String> get monthsShort => const [
        'Sẹ́r',
        'Èrl',
        'Ẹrn',
        'Ìgb',
        'Èbi',
        'Òkù',
        'Agẹ',
        'Ògú',
        'Owe',
        'Ọ̀wà',
        'Bél',
        'Ọ̀pẹ̀̀',
      ];

  @override
  List<String> get weekdays => const [
        'Àìkú',
        'Ajé',
        'Ìsẹ́gun',
        'Ọjọ́rú',
        'Ọjọ́bọ',
        'Ẹtì',
        'Àbámẹ́ta',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Àìk',
        'Ajé',
        'Ìsẹ́',
        'Ọjr',
        'Ọjb',
        'Ẹtì',
        'Àbá',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Àì',
        'Aj',
        'Ìs',
        'Ọr',
        'Ọb',
        'Ẹt',
        'Àb',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY h:mm A',
        llll: 'dddd, D MMMM YYYY h:mm A',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'ní %s',
        past: '%s kọjá',
        s: 'ìsẹjú aayá die',
        m: 'ìsẹjú kan',
        mm: 'ìsẹjú %d',
        h: 'wákati kan',
        hh: 'wákati %d',
        d: 'ọjọ́ kan',
        dd: 'ọjọ́ %d',
        mo: 'osù kan',
        mos: 'osù %d',
        y: 'ọdún kan',
        yy: 'ọdún %d',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
