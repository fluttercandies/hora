// AF Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Afrikaans locale.
class HoraLocaleAf extends HoraLocale {
  const HoraLocaleAf();

  @override
  String get code => 'af';

  @override
  List<String> get months => const [
        'Januarie',
        'Februarie',
        'Maart',
        'April',
        'Mei',
        'Junie',
        'Julie',
        'Augustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];

  @override
  List<String> get monthsShort => const [
        'Jan',
        'Feb',
        'Mrt',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];

  @override
  List<String> get weekdays => const [
        'Sondag',
        'Maandag',
        'Dinsdag',
        'Woensdag',
        'Donderdag',
        'Vrydag',
        'Saterdag',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Son',
        'Maa',
        'Din',
        'Woe',
        'Don',
        'Vry',
        'Sat',
      ];

  @override
  List<String> get weekdaysMin => const [
        'So',
        'Ma',
        'Di',
        'Wo',
        'Do',
        'Vr',
        'Sa',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY HH:mm',
        llll: 'dddd, D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'oor %s',
        past: '%s gelede',
        mm: '%d minute',
        hh: '%d ure',
        dd: '%d dae',
        mos: '%d maande',
        yy: '%d jaar',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
