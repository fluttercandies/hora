// HY-AM Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Armenian locale.
class HoraLocaleHyAm extends HoraLocale {
  const HoraLocaleHyAm();

  @override
  String get code => 'hy-am';

  @override
  List<String> get months => const [
        'հունվարի',
        'փետրվարի',
        'մարտի',
        'ապրիլի',
        'մայիսի',
        'հունիսի',
        'հուլիսի',
        'օգոստոսի',
        'սեպտեմբերի',
        'հոկտեմբերի',
        'նոյեմբերի',
        'դեկտեմբերի',
      ];

  @override
  List<String> get monthsShort => const [
        'հնվ',
        'փտր',
        'մրտ',
        'ապր',
        'մյս',
        'հնս',
        'հլս',
        'օգս',
        'սպտ',
        'հկտ',
        'նմբ',
        'դկտ',
      ];

  @override
  List<String> get weekdays => const [
        'կիրակի',
        'երկուշաբթի',
        'երեքշաբթի',
        'չորեքշաբթի',
        'հինգշաբթի',
        'ուրբաթ',
        'շաբաթ',
      ];

  @override
  List<String> get weekdaysShort => const [
        'կրկ',
        'երկ',
        'երք',
        'չրք',
        'հնգ',
        'ուրբ',
        'շբթ',
      ];

  @override
  List<String> get weekdaysMin => const [
        'կրկ',
        'երկ',
        'երք',
        'չրք',
        'հնգ',
        'ուրբ',
        'շբթ',
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
        ll: 'D MMMM YYYY թ.',
        lll: 'D MMMM YYYY թ., HH:mm',
        llll: 'dddd, D MMMM YYYY թ., HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s հետո',
        past: '%s առաջ',
        s: 'մի քանի վայրկյան',
        m: 'րոպե',
        mm: '%d րոպե',
        h: 'ժամ',
        hh: '%d ժամ',
        d: 'օր',
        dd: '%d օր',
        mo: 'ամիս',
        mos: '%d ամիս',
        y: 'տարի',
        yy: '%d տարի',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
