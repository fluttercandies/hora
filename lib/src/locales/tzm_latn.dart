// TZM-LATN Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Central Atlas Tamazight (Latin) locale.
class HoraLocaleTzmLatn extends HoraLocale {
  const HoraLocaleTzmLatn();

  @override
  String get code => 'tzm-latn';

  @override
  List<String> get months => const [
        'innayr',
        'brˤayrˤ',
        'marˤsˤ',
        'ibrir',
        'mayyw',
        'ywnyw',
        'ywlywz',
        'ɣwšt',
        'šwtanbir',
        'ktˤwbrˤ',
        'nwwanbir',
        'dwjnbir',
      ];

  @override
  List<String> get monthsShort => const [
        'innayr',
        'brˤayrˤ',
        'marˤsˤ',
        'ibrir',
        'mayyw',
        'ywnyw',
        'ywlywz',
        'ɣwšt',
        'šwtanbir',
        'ktˤwbrˤ',
        'nwwanbir',
        'dwjnbir',
      ];

  @override
  List<String> get weekdays => const [
        'asamas',
        'aynas',
        'asinas',
        'akras',
        'akwas',
        'asimwas',
        'asiḍyas',
      ];

  @override
  List<String> get weekdaysShort => const [
        'asamas',
        'aynas',
        'asinas',
        'akras',
        'akwas',
        'asimwas',
        'asiḍyas',
      ];

  @override
  List<String> get weekdaysMin => const [
        'asamas',
        'aynas',
        'asinas',
        'akras',
        'akwas',
        'asimwas',
        'asiḍyas',
      ];

  @override
  int get weekStart => 6;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY HH:mm',
        llll: 'dddd D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'dadkh s yan %s',
        past: 'yan %s',
        s: 'imik',
        m: 'minuḍ',
        mm: '%d minuḍ',
        h: 'saɛa',
        hh: '%d tassaɛin',
        d: 'ass',
        dd: '%d ossan',
        mo: 'ayowr',
        mos: '%d iyyirn',
        y: 'asgas',
        yy: '%d isgasn',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
