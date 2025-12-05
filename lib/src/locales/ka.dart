// KA Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Georgian locale.
class HoraLocaleKa extends HoraLocale {
  const HoraLocaleKa();

  @override
  String get code => 'ka';

  @override
  List<String> get months => const [
        'იანვარი',
        'თებერვალი',
        'მარტი',
        'აპრილი',
        'მაისი',
        'ივნისი',
        'ივლისი',
        'აგვისტო',
        'სექტემბერი',
        'ოქტომბერი',
        'ნოემბერი',
        'დეკემბერი',
      ];

  @override
  List<String> get monthsShort => const [
        'იან',
        'თებ',
        'მარ',
        'აპრ',
        'მაი',
        'ივნ',
        'ივლ',
        'აგვ',
        'სექ',
        'ოქტ',
        'ნოე',
        'დეკ',
      ];

  @override
  List<String> get weekdays => const [
        'კვირა',
        'ორშაბათი',
        'სამშაბათი',
        'ოთხშაბათი',
        'ხუთშაბათი',
        'პარასკევი',
        'შაბათი',
      ];

  @override
  List<String> get weekdaysShort => const [
        'კვი',
        'ორშ',
        'სამ',
        'ოთხ',
        'ხუთ',
        'პარ',
        'შაბ',
      ];

  @override
  List<String> get weekdaysMin => const [
        'კვ',
        'ორ',
        'სა',
        'ოთ',
        'ხუ',
        'პა',
        'შა',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY h:mm A',
        llll: 'dddd, D MMMM YYYY h:mm A',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s შემდეგ',
        past: '%s წინ',
        s: 'წამი',
        m: 'წუთი',
        mm: '%d წუთი',
        h: 'საათი',
        hh: '%d საათის',
        d: 'დღეს',
        dd: '%d დღის განმავლობაში',
        mo: 'თვის',
        mos: '%d თვის',
        y: 'წელი',
        yy: '%d წლის',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
