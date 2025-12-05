// SE Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Northern Sami locale.
class HoraLocaleSe extends HoraLocale {
  const HoraLocaleSe();

  @override
  String get code => 'se';

  @override
  List<String> get months => const [
        'ođđajagemánnu',
        'guovvamánnu',
        'njukčamánnu',
        'cuoŋománnu',
        'miessemánnu',
        'geassemánnu',
        'suoidnemánnu',
        'borgemánnu',
        'čakčamánnu',
        'golggotmánnu',
        'skábmamánnu',
        'juovlamánnu',
      ];

  @override
  List<String> get monthsShort => const [
        'ođđj',
        'guov',
        'njuk',
        'cuo',
        'mies',
        'geas',
        'suoi',
        'borg',
        'čakč',
        'golg',
        'skáb',
        'juov',
      ];

  @override
  List<String> get weekdays => const [
        'sotnabeaivi',
        'vuossárga',
        'maŋŋebárga',
        'gaskavahkku',
        'duorastat',
        'bearjadat',
        'lávvardat',
      ];

  @override
  List<String> get weekdaysShort => const [
        'sotn',
        'vuos',
        'maŋ',
        'gask',
        'duor',
        'bear',
        'láv',
      ];

  @override
  List<String> get weekdaysMin => const [
        's',
        'v',
        'm',
        'g',
        'd',
        'b',
        'L',
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
        ll: 'MMMM D. [b.] YYYY',
        lll: 'MMMM D. [b.] YYYY [ti.] HH:mm',
        llll: 'dddd, MMMM D. [b.] YYYY [ti.] HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s geažes',
        past: 'maŋit %s',
        s: 'moadde sekunddat',
        m: 'okta minuhta',
        mm: '%d minuhtat',
        h: 'okta diimmu',
        hh: '%d diimmut',
        d: 'okta beaivi',
        dd: '%d beaivvit',
        mo: 'okta mánnu',
        mos: '%d mánut',
        y: 'okta jahki',
        yy: '%d jagit',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
