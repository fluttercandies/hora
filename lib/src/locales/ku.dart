// KU Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Kurdish locale.
class HoraLocaleKu extends HoraLocale {
  const HoraLocaleKu();

  @override
  String get code => 'ku';

  @override
  List<String> get months => const [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];

  @override
  List<String> get monthsShort => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

  @override
  List<String> get weekdays => const [
        'یەکشەممە',
        'دووشەممە',
        'سێشەممە',
        'چوارشەممە',
        'پێنجشەممە',
        'هەینی',
        'شەممە',
      ];

  @override
  List<String> get weekdaysShort => const [
        'یەکشەم',
        'دووشەم',
        'سێشەم',
        'چوارشەم',
        'پێنجشەم',
        'هەینی',
        'شەممە',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ی',
        'د',
        'س',
        'چ',
        'پ',
        'هـ',
        'ش',
      ];

  @override
  int get weekStart => 6;

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
        future: 'لە %s',
        past: 'لەمەوپێش %s',
        s: 'چەند چرکەیەک',
        m: 'یەک خولەک',
        mm: '%d خولەک',
        h: 'یەک کاتژمێر',
        hh: '%d کاتژمێر',
        d: 'یەک ڕۆژ',
        dd: '%d ڕۆژ',
        mo: 'یەک مانگ',
        mos: '%d مانگ',
        y: 'یەک ساڵ',
        yy: '%d ساڵ',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
  @override
  String meridiem(int hour, int minute, {bool lowercase = false}) =>
      hour < 12 ? 'پ.ن' : 'د.ن';
}
