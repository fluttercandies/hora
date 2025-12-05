// PL Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Polish locale.
class HoraLocalePl extends HoraLocale {
  const HoraLocalePl();

  @override
  String get code => 'pl';

  @override
  List<String> get months => const [
        'styczeń',
        'luty',
        'marzec',
        'kwiecień',
        'maj',
        'czerwiec',
        'lipiec',
        'sierpień',
        'wrzesień',
        'październik',
        'listopad',
        'grudzień',
      ];

  @override
  List<String> get monthsShort => const [
        'sty',
        'lut',
        'mar',
        'kwi',
        'maj',
        'cze',
        'lip',
        'sie',
        'wrz',
        'paź',
        'lis',
        'gru',
      ];

  @override
  List<String> get weekdays => const [
        'niedziela',
        'poniedziałek',
        'wtorek',
        'środa',
        'czwartek',
        'piątek',
        'sobota',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ndz',
        'pon',
        'wt',
        'śr',
        'czw',
        'pt',
        'sob',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Nd',
        'Pn',
        'Wt',
        'Śr',
        'Cz',
        'Pt',
        'So',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 4;

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
        future: 'za %s',
        past: '%s temu',
        s: 'kilka sekund',
        d: '1 dzień',
        dd: '%d dni',
        mo: 'miesiąc',
        y: 'rok',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
