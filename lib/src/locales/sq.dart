// SQ Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Albanian locale.
class HoraLocaleSq extends HoraLocale {
  const HoraLocaleSq();

  @override
  String get code => 'sq';

  @override
  List<String> get months => const [
        'Janar',
        'Shkurt',
        'Mars',
        'Prill',
        'Maj',
        'Qershor',
        'Korrik',
        'Gusht',
        'Shtator',
        'Tetor',
        'Nëntor',
        'Dhjetor',
      ];

  @override
  List<String> get monthsShort => const [
        'Jan',
        'Shk',
        'Mar',
        'Pri',
        'Maj',
        'Qer',
        'Kor',
        'Gus',
        'Sht',
        'Tet',
        'Nën',
        'Dhj',
      ];

  @override
  List<String> get weekdays => const [
        'E Diel',
        'E Hënë',
        'E Martë',
        'E Mërkurë',
        'E Enjte',
        'E Premte',
        'E Shtunë',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Die',
        'Hën',
        'Mar',
        'Mër',
        'Enj',
        'Pre',
        'Sht',
      ];

  @override
  List<String> get weekdaysMin => const [
        'D',
        'H',
        'Ma',
        'Më',
        'E',
        'P',
        'Sh',
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
        future: 'në %s',
        past: '%s më parë',
        s: 'disa sekonda',
        m: 'një minutë',
        mm: '%d minuta',
        h: 'një orë',
        hh: '%d orë',
        d: 'një ditë',
        dd: '%d ditë',
        mo: 'një muaj',
        mos: '%d muaj',
        y: 'një vit',
        yy: '%d vite',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
