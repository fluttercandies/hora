// BI Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Bislama locale.
class HoraLocaleBi extends HoraLocale {
  const HoraLocaleBi();

  @override
  String get code => 'bi';

  @override
  List<String> get months => const [
        'Januari',
        'Februari',
        'Maj',
        'Eprel',
        'Mei',
        'Jun',
        'Julae',
        'Okis',
        'Septemba',
        'Oktoba',
        'Novemba',
        'Disemba',
      ];

  @override
  List<String> get monthsShort => const [
        'Jan',
        'Feb',
        'Maj',
        'Epr',
        'Mai',
        'Jun',
        'Jul',
        'Oki',
        'Sep',
        'Okt',
        'Nov',
        'Dis',
      ];

  @override
  List<String> get weekdays => const [
        'Sande',
        'Mande',
        'Tusde',
        'Wenesde',
        'Tosde',
        'Fraede',
        'Sarade',
      ];

  @override
  List<String> get weekdaysShort => const [
        'San',
        'Man',
        'Tus',
        'Wen',
        'Tos',
        'Frae',
        'Sar',
      ];

  @override
  List<String> get weekdaysMin => const [
        'San',
        'Ma',
        'Tu',
        'We',
        'To',
        'Fr',
        'Sar',
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
        future: 'lo %s',
        past: '%s bifo',
        s: 'sam seken',
        m: 'wan minit',
        mm: '%d minit',
        h: 'wan haoa',
        hh: '%d haoa',
        d: 'wan dei',
        dd: '%d dei',
        mo: 'wan manis',
        mos: '%d manis',
        y: 'wan yia',
        yy: '%d yia',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
