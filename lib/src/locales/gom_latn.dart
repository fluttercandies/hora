// GOM-LATN Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Konkani (Latin) locale.
class HoraLocaleGomLatn extends HoraLocale {
  const HoraLocaleGomLatn();

  @override
  String get code => 'gom-latn';

  @override
  List<String> get months => const [
        'Janer',
        'Febrer',
        'Mars',
        'Abril',
        'Mai',
        'Jun',
        'Julai',
        'Agost',
        'Setembr',
        'Otubr',
        'Novembr',
        'Dezembr',
      ];

  @override
  List<String> get monthsShort => const [
        'Jan.',
        'Feb.',
        'Mars',
        'Abr.',
        'Mai',
        'Jun',
        'Jul.',
        'Ago.',
        'Set.',
        'Otu.',
        'Nov.',
        'Dez.',
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
        'Ait.',
        'Som.',
        'Mon.',
        'Bud.',
        'Bre.',
        'Suk.',
        'Son.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Ai',
        'Sm',
        'Mo',
        'Bu',
        'Br',
        'Su',
        'Sn',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'A h:mm [vazta]',
        lts: 'A h:mm:ss [vazta]',
        l: 'DD-MM-YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY A h:mm [vazta]',
        llll: 'dddd, MMMM[achea] Do, YYYY, A h:mm [vazta]',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
