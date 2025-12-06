// EN-CA Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// English (Canada) locale.
class HoraLocaleEnCa extends HoraLocale {
  const HoraLocaleEnCa();

  @override
  String get code => 'en-ca';

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
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        l: 'YYYY-MM-DD',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime();

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
