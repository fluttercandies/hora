// TR Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Turkish locale.
class HoraLocaleTr extends HoraLocale {
  const HoraLocaleTr();

  @override
  String get code => 'tr';

  @override
  List<String> get months => const [
        'Ocak',
        'Şubat',
        'Mart',
        'Nisan',
        'Mayıs',
        'Haziran',
        'Temmuz',
        'Ağustos',
        'Eylül',
        'Ekim',
        'Kasım',
        'Aralık',
      ];

  @override
  List<String> get monthsShort => const [
        'Oca',
        'Şub',
        'Mar',
        'Nis',
        'May',
        'Haz',
        'Tem',
        'Ağu',
        'Eyl',
        'Eki',
        'Kas',
        'Ara',
      ];

  @override
  List<String> get weekdays => const [
        'Pazar',
        'Pazartesi',
        'Salı',
        'Çarşamba',
        'Perşembe',
        'Cuma',
        'Cumartesi',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Paz',
        'Pts',
        'Sal',
        'Çar',
        'Per',
        'Cum',
        'Cts',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Pz',
        'Pt',
        'Sa',
        'Ça',
        'Pe',
        'Cu',
        'Ct',
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
        future: '%s sonra',
        past: '%s önce',
        s: 'birkaç saniye',
        m: 'bir dakika',
        mm: '%d dakika',
        h: 'bir saat',
        hh: '%d saat',
        d: 'bir gün',
        dd: '%d gün',
        mo: 'bir ay',
        mos: '%d ay',
        y: 'bir yıl',
        yy: '%d yıl',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
