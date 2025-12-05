// BO Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Tibetan locale.
class HoraLocaleBo extends HoraLocale {
  const HoraLocaleBo();

  @override
  String get code => 'bo';

  @override
  List<String> get months => const [
        'ཟླ་བ་དང་པོ',
        'ཟླ་བ་གཉིས་པ',
        'ཟླ་བ་གསུམ་པ',
        'ཟླ་བ་བཞི་པ',
        'ཟླ་བ་ལྔ་པ',
        'ཟླ་བ་དྲུག་པ',
        'ཟླ་བ་བདུན་པ',
        'ཟླ་བ་བརྒྱད་པ',
        'ཟླ་བ་དགུ་པ',
        'ཟླ་བ་བཅུ་པ',
        'ཟླ་བ་བཅུ་གཅིག་པ',
        'ཟླ་བ་བཅུ་གཉིས་པ',
      ];

  @override
  List<String> get monthsShort => const [
        'ཟླ་དང་པོ',
        'ཟླ་གཉིས་པ',
        'ཟླ་གསུམ་པ',
        'ཟླ་བཞི་པ',
        'ཟླ་ལྔ་པ',
        'ཟླ་དྲུག་པ',
        'ཟླ་བདུན་པ',
        'ཟླ་བརྒྱད་པ',
        'ཟླ་དགུ་པ',
        'ཟླ་བཅུ་པ',
        'ཟླ་བཅུ་གཅིག་པ',
        'ཟླ་བཅུ་གཉིས་པ',
      ];

  @override
  List<String> get weekdays => const [
        'གཟའ་ཉི་མ་',
        'གཟའ་ཟླ་བ་',
        'གཟའ་མིག་དམར་',
        'གཟའ་ལྷག་པ་',
        'གཟའ་ཕུར་བུ',
        'གཟའ་པ་སངས་',
        'གཟའ་སྤེན་པ་',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ཉི་མ་',
        'ཟླ་བ་',
        'མིག་དམར་',
        'ལྷག་པ་',
        'ཕུར་བུ',
        'པ་སངས་',
        'སྤེན་པ་',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ཉི་མ་',
        'ཟླ་བ་',
        'མིག་དམར་',
        'ལྷག་པ་',
        'ཕུར་བུ',
        'པ་སངས་',
        'སྤེན་པ་',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'A h:mm',
        lts: 'A h:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY, A h:mm',
        llll: 'dddd, D MMMM YYYY, A h:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s ལ་',
        past: '%s སྔོན་ལ་',
        s: 'ཏོག་ཙམ་',
        m: 'སྐར་མ་གཅིག་',
        mm: 'སྐར་མ་ %d',
        h: 'ཆུ་ཚོད་གཅིག་',
        hh: 'ཆུ་ཚོད་ %d',
        d: 'ཉིན་གཅིག་',
        dd: 'ཉིན་ %d',
        mo: 'ཟླ་བ་གཅིག་',
        mos: 'ཟླ་བ་ %d',
        y: 'ལོ་གཅིག་',
        yy: 'ལོ་ %d',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
