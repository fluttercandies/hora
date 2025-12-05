// FI Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Finnish locale.
class HoraLocaleFi extends HoraLocale {
  const HoraLocaleFi();

  @override
  String get code => 'fi';

  @override
  List<String> get months => const [
        'tammikuu',
        'helmikuu',
        'maaliskuu',
        'huhtikuu',
        'toukokuu',
        'kesäkuu',
        'heinäkuu',
        'elokuu',
        'syyskuu',
        'lokakuu',
        'marraskuu',
        'joulukuu',
      ];

  @override
  List<String> get monthsShort => const [
        'tammi',
        'helmi',
        'maalis',
        'huhti',
        'touko',
        'kesä',
        'heinä',
        'elo',
        'syys',
        'loka',
        'marras',
        'joulu',
      ];

  @override
  List<String> get weekdays => const [
        'sunnuntai',
        'maanantai',
        'tiistai',
        'keskiviikko',
        'torstai',
        'perjantai',
        'lauantai',
      ];

  @override
  List<String> get weekdaysShort => const [
        'su',
        'ma',
        'ti',
        'ke',
        'to',
        'pe',
        'la',
      ];

  @override
  List<String> get weekdaysMin => const [
        'su',
        'ma',
        'ti',
        'ke',
        'to',
        'pe',
        'la',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 4;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH.mm',
        lts: 'HH.mm.ss',
        l: 'DD.MM.YYYY',
        ll: 'D. MMMM[ta] YYYY',
        lll: 'D. MMMM[ta] YYYY, [klo] HH.mm',
        llll: 'dddd, D. MMMM[ta] YYYY, [klo] HH.mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s päästä',
        past: '%s sitten',
        s: 'muutama sekunti',
        m: 'minuutti',
        mm: '%d minuuttia',
        h: 'tunti',
        hh: '%d tuntia',
        d: 'päivä',
        dd: '%d päivää',
        mo: 'kuukausi',
        mos: '%d kuukautta',
        y: 'vuosi',
        yy: '%d vuotta',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
