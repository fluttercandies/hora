// EN-TT Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// English (Trinidad and Tobago) locale.
class HoraLocaleEnTt extends HoraLocale {
  const HoraLocaleEnTt();

  @override
  String get code => 'en-tt';

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
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Su',
        'Mo',
        'Tu',
        'We',
        'Th',
        'Fr',
        'Sa',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 4;

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
  HoraRelativeTime get relativeTime => const HoraRelativeTime();

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
