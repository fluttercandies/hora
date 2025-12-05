// LB Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Luxembourgish locale.
class HoraLocaleLb extends HoraLocale {
  const HoraLocaleLb();

  @override
  String get code => 'lb';

  @override
  List<String> get months => const [
        'Januar',
        'Februar',
        'Mäerz',
        'Abrëll',
        'Mee',
        'Juni',
        'Juli',
        'August',
        'September',
        'Oktober',
        'November',
        'Dezember',
      ];

  @override
  List<String> get monthsShort => const [
        'Jan.',
        'Febr.',
        'Mrz.',
        'Abr.',
        'Mee',
        'Jun.',
        'Jul.',
        'Aug.',
        'Sept.',
        'Okt.',
        'Nov.',
        'Dez.',
      ];

  @override
  List<String> get weekdays => const [
        'Sonndeg',
        'Méindeg',
        'Dënschdeg',
        'Mëttwoch',
        'Donneschdeg',
        'Freideg',
        'Samschdeg',
      ];

  @override
  List<String> get weekdaysShort => const [
        'So.',
        'Mé.',
        'Dë.',
        'Më.',
        'Do.',
        'Fr.',
        'Sa.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'So',
        'Mé',
        'Dë',
        'Më',
        'Do',
        'Fr',
        'Sa',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'H:mm [Auer]',
        lts: 'H:mm:ss [Auer]',
        l: 'DD.MM.YYYY',
        ll: 'D. MMMM YYYY',
        lll: 'D. MMMM YYYY H:mm [Auer]',
        llll: 'dddd, D. MMMM YYYY H:mm [Auer]',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
