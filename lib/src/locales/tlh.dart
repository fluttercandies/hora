// TLH Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Klingon locale.
class HoraLocaleTlh extends HoraLocale {
  const HoraLocaleTlh();

  @override
  String get code => 'tlh';

  @override
  List<String> get months => const [
        'tera’ jar wa’',
        'tera’ jar cha’',
        'tera’ jar wej',
        'tera’ jar loS',
        'tera’ jar vagh',
        'tera’ jar jav',
        'tera’ jar Soch',
        'tera’ jar chorgh',
        'tera’ jar Hut',
        'tera’ jar wa’maH',
        'tera’ jar wa’maH wa’',
        'tera’ jar wa’maH cha’',
      ];

  @override
  List<String> get monthsShort => const [
        'jar wa’',
        'jar cha’',
        'jar wej',
        'jar loS',
        'jar vagh',
        'jar jav',
        'jar Soch',
        'jar chorgh',
        'jar Hut',
        'jar wa’maH',
        'jar wa’maH wa’',
        'jar wa’maH cha’',
      ];

  @override
  List<String> get weekdays => const [
        'lojmItjaj',
        'DaSjaj',
        'povjaj',
        'ghItlhjaj',
        'loghjaj',
        'buqjaj',
        'ghInjaj',
      ];

  @override
  List<String> get weekdaysShort => const [
        'lojmItjaj',
        'DaSjaj',
        'povjaj',
        'ghItlhjaj',
        'loghjaj',
        'buqjaj',
        'ghInjaj',
      ];

  @override
  List<String> get weekdaysMin => const [
        'lojmItjaj',
        'DaSjaj',
        'povjaj',
        'ghItlhjaj',
        'loghjaj',
        'buqjaj',
        'ghInjaj',
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
        
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
