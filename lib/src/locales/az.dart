// AZ Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Azerbaijani locale.
class HoraLocaleAz extends HoraLocale {
  const HoraLocaleAz();

  @override
  String get code => 'az';

  @override
  List<String> get months => const [
        'yanvar',
        'fevral',
        'mart',
        'aprel',
        'may',
        'iyun',
        'iyul',
        'avqust',
        'sentyabr',
        'oktyabr',
        'noyabr',
        'dekabr',
      ];

  @override
  List<String> get monthsShort => const [
        'yan',
        'fev',
        'mar',
        'apr',
        'may',
        'iyn',
        'iyl',
        'avq',
        'sen',
        'okt',
        'noy',
        'dek',
      ];

  @override
  List<String> get weekdays => const [
        'Bazar',
        'Bazar ertəsi',
        'Çərşənbə axşamı',
        'Çərşənbə',
        'Cümə axşamı',
        'Cümə',
        'Şənbə',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Baz',
        'BzE',
        'ÇAx',
        'Çər',
        'CAx',
        'Cüm',
        'Şən',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Bz',
        'BE',
        'ÇA',
        'Çə',
        'CA',
        'Cü',
        'Şə',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

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
        future: '%s sonra',
        past: '%s əvvəl',
        s: 'bir neçə saniyə',
        m: 'bir dəqiqə',
        mm: '%d dəqiqə',
        h: 'bir saat',
        hh: '%d saat',
        d: 'bir gün',
        dd: '%d gün',
        mo: 'bir ay',
        mos: '%d ay',
        y: 'bir il',
        yy: '%d il',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
