// CV Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Chuvash locale.
class HoraLocaleCv extends HoraLocale {
  const HoraLocaleCv();

  @override
  String get code => 'cv';

  @override
  List<String> get months => const [
        'кӑрлач',
        'нарӑс',
        'пуш',
        'ака',
        'май',
        'ҫӗртме',
        'утӑ',
        'ҫурла',
        'авӑн',
        'юпа',
        'чӳк',
        'раштав',
      ];

  @override
  List<String> get monthsShort => const [
        'кӑр',
        'нар',
        'пуш',
        'ака',
        'май',
        'ҫӗр',
        'утӑ',
        'ҫур',
        'авн',
        'юпа',
        'чӳк',
        'раш',
      ];

  @override
  List<String> get weekdays => const [
        'вырсарникун',
        'тунтикун',
        'ытларикун',
        'юнкун',
        'кӗҫнерникун',
        'эрнекун',
        'шӑматкун',
      ];

  @override
  List<String> get weekdaysShort => const [
        'выр',
        'тун',
        'ытл',
        'юн',
        'кӗҫ',
        'эрн',
        'шӑм',
      ];

  @override
  List<String> get weekdaysMin => const [
        'вр',
        'тн',
        'ыт',
        'юн',
        'кҫ',
        'эр',
        'шм',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD-MM-YYYY',
        ll: 'YYYY [ҫулхи] MMMM [уйӑхӗн] D[-мӗшӗ]',
        lll: 'YYYY [ҫулхи] MMMM [уйӑхӗн] D[-мӗшӗ], HH:mm',
        llll: 'dddd, YYYY [ҫулхи] MMMM [уйӑхӗн] D[-мӗшӗ], HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime();

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
