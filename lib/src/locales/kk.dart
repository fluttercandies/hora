// KK Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Kazakh locale.
class HoraLocaleKk extends HoraLocale {
  const HoraLocaleKk();

  @override
  String get code => 'kk';

  @override
  List<String> get months => const [
        'қаңтар',
        'ақпан',
        'наурыз',
        'сәуір',
        'мамыр',
        'маусым',
        'шілде',
        'тамыз',
        'қыркүйек',
        'қазан',
        'қараша',
        'желтоқсан',
      ];

  @override
  List<String> get monthsShort => const [
        'қаң',
        'ақп',
        'нау',
        'сәу',
        'мам',
        'мау',
        'шіл',
        'там',
        'қыр',
        'қаз',
        'қар',
        'жел',
      ];

  @override
  List<String> get weekdays => const [
        'жексенбі',
        'дүйсенбі',
        'сейсенбі',
        'сәрсенбі',
        'бейсенбі',
        'жұма',
        'сенбі',
      ];

  @override
  List<String> get weekdaysShort => const [
        'жек',
        'дүй',
        'сей',
        'сәр',
        'бей',
        'жұм',
        'сен',
      ];

  @override
  List<String> get weekdaysMin => const [
        'жк',
        'дй',
        'сй',
        'ср',
        'бй',
        'жм',
        'сн',
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
        future: '%s ішінде',
        past: '%s бұрын',
        s: 'бірнеше секунд',
        m: 'бір минут',
        mm: '%d минут',
        h: 'бір сағат',
        hh: '%d сағат',
        d: 'бір күн',
        dd: '%d күн',
        mo: 'бір ай',
        mos: '%d ай',
        y: 'бір жыл',
        yy: '%d жыл',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
