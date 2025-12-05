// TK Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Turkmen locale.
class HoraLocaleTk extends HoraLocale {
  const HoraLocaleTk();

  @override
  String get code => 'tk';

  @override
  List<String> get months => const [
        'Ýanwar',
        'Fewral',
        'Mart',
        'Aprel',
        'Maý',
        'Iýun',
        'Iýul',
        'Awgust',
        'Sentýabr',
        'Oktýabr',
        'Noýabr',
        'Dekabr',
      ];

  @override
  List<String> get monthsShort => const [
        'Ýan',
        'Few',
        'Mar',
        'Apr',
        'Maý',
        'Iýn',
        'Iýl',
        'Awg',
        'Sen',
        'Okt',
        'Noý',
        'Dek',
      ];

  @override
  List<String> get weekdays => const [
        'Ýekşenbe',
        'Duşenbe',
        'Sişenbe',
        'Çarşenbe',
        'Penşenbe',
        'Anna',
        'Şenbe',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Ýek',
        'Duş',
        'Siş',
        'Çar',
        'Pen',
        'Ann',
        'Şen',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Ýk',
        'Dş',
        'Sş',
        'Çr',
        'Pn',
        'An',
        'Şn',
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
        future: '%s soň',
        past: '%s öň',
        s: 'birnäçe sekunt',
        m: 'bir minut',
        mm: '%d minut',
        h: 'bir sagat',
        hh: '%d sagat',
        d: 'bir gün',
        dd: '%d gün',
        mo: 'bir aý',
        mos: '%d aý',
        y: 'bir ýyl',
        yy: '%d ýyl',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
