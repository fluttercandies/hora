// UZ-LATN Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Uzbek (Latin) locale.
class HoraLocaleUzLatn extends HoraLocale {
  const HoraLocaleUzLatn();

  @override
  String get code => 'uz-latn';

  @override
  List<String> get months => const [
        'Yanvar',
        'Fevral',
        'Mart',
        'Aprel',
        'May',
        'Iyun',
        'Iyul',
        'Avgust',
        'Sentabr',
        'Oktabr',
        'Noyabr',
        'Dekabr',
      ];

  @override
  List<String> get monthsShort => const [
        'Yan',
        'Fev',
        'Mar',
        'Apr',
        'May',
        'Iyun',
        'Iyul',
        'Avg',
        'Sen',
        'Okt',
        'Noy',
        'Dek',
      ];

  @override
  List<String> get weekdays => const [
        'Yakshanba',
        'Dushanba',
        'Seshanba',
        'Chorshanba',
        'Payshanba',
        'Juma',
        'Shanba',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Yak',
        'Dush',
        'Sesh',
        'Chor',
        'Pay',
        'Jum',
        'Shan',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Ya',
        'Du',
        'Se',
        'Cho',
        'Pa',
        'Ju',
        'Sha',
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
        llll: 'D MMMM YYYY, dddd HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'Yaqin %s ichida',
        past: '%s oldin',
        s: 'soniya',
        m: 'bir daqiqa',
        mm: '%d daqiqa',
        h: 'bir soat',
        hh: '%d soat',
        d: 'bir kun',
        dd: '%d kun',
        mo: 'bir oy',
        mos: '%d oy',
        y: 'bir yil',
        yy: '%d yil',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
