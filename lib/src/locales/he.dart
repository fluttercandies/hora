// HE Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Hebrew locale.
class HoraLocaleHe extends HoraLocale {
  const HoraLocaleHe();

  @override
  String get code => 'he';

  @override
  List<String> get months => const [
        'ינואר',
        'פברואר',
        'מרץ',
        'אפריל',
        'מאי',
        'יוני',
        'יולי',
        'אוגוסט',
        'ספטמבר',
        'אוקטובר',
        'נובמבר',
        'דצמבר',
      ];

  @override
  List<String> get monthsShort => const [
        'ינו',
        'פבר',
        'מרץ',
        'אפר',
        'מאי',
        'יונ',
        'יול',
        'אוג',
        'ספט',
        'אוק',
        'נוב',
        'דצמ',
      ];

  @override
  List<String> get weekdays => const [
        'ראשון',
        'שני',
        'שלישי',
        'רביעי',
        'חמישי',
        'שישי',
        'שבת',
      ];

  @override
  List<String> get weekdaysShort => const [
        'א׳',
        'ב׳',
        'ג׳',
        'ד׳',
        'ה׳',
        'ו׳',
        'ש׳',
      ];

  @override
  List<String> get weekdaysMin => const [
        'א׳',
        'ב׳',
        'ג׳',
        'ד׳',
        'ה׳',
        'ו',
        'ש׳',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'D [ב]MMMM YYYY',
        lll: 'D [ב]MMMM YYYY HH:mm',
        llll: 'dddd, D [ב]MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'בעוד %s',
        past: 'לפני %s',
        s: 'מספר שניות',
        m: 'דקה',
        mm: '%d דקות',
        h: 'שעה',
        hh: '%d שעות',
        d: 'יום',
        dd: '%d ימים',
        mo: 'חודש',
        mos: '%d חודשים',
        y: 'שנה',
        yy: '%d שנים',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
