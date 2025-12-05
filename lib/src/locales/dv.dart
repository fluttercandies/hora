// DV Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Divehi locale.
class HoraLocaleDv extends HoraLocale {
  const HoraLocaleDv();

  @override
  String get code => 'dv';

  @override
  List<String> get months => const [
        'ޖެނުއަރީ',
        'ފެބްރުއަރީ',
        'މާރިޗު',
        'އޭޕްރީލު',
        'މޭ',
        'ޖޫން',
        'ޖުލައި',
        'އޯގަސްޓު',
        'ސެޕްޓެމްބަރު',
        'އޮކްޓޯބަރު',
        'ނޮވެމްބަރު',
        'ޑިސެމްބަރު',
      ];

  @override
  List<String> get monthsShort => const [
        'ޖެނުއަރީ',
        'ފެބްރުއަރީ',
        'މާރިޗު',
        'އޭޕްރީލު',
        'މޭ',
        'ޖޫން',
        'ޖުލައި',
        'އޯގަސްޓު',
        'ސެޕްޓެމްބަރު',
        'އޮކްޓޯބަރު',
        'ނޮވެމްބަރު',
        'ޑިސެމްބަރު',
      ];

  @override
  List<String> get weekdays => const [
        'އާދިއްތަ',
        'ހޯމަ',
        'އަންގާރަ',
        'ބުދަ',
        'ބުރާސްފަތި',
        'ހުކުރު',
        'ހޮނިހިރު',
      ];

  @override
  List<String> get weekdaysShort => const [
        'އާދިއްތަ',
        'ހޯމަ',
        'އަންގާރަ',
        'ބުދަ',
        'ބުރާސްފަތި',
        'ހުކުރު',
        'ހޮނިހިރު',
      ];

  @override
  List<String> get weekdaysMin => const [
        'އާދި',
        'ހޯމަ',
        'އަން',
        'ބުދަ',
        'ބުރާ',
        'ހުކު',
        'ހޮނި',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'D/M/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY HH:mm',
        llll: 'dddd D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'ތެރޭގައި %s',
        past: 'ކުރިން %s',
        s: 'ސިކުންތުކޮޅެއް',
        m: 'މިނިޓެއް',
        mm: 'މިނިޓު %d',
        h: 'ގަޑިއިރެއް',
        hh: 'ގަޑިއިރު %d',
        d: 'ދުވަހެއް',
        dd: 'ދުވަސް %d',
        mo: 'މަހެއް',
        mos: 'މަސް %d',
        y: 'އަހަރެއް',
        yy: 'އަހަރު %d',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
