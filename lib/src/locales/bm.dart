// BM Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Bambara locale.
class HoraLocaleBm extends HoraLocale {
  const HoraLocaleBm();

  @override
  String get code => 'bm';

  @override
  List<String> get months => const [
        'Zanwuyekalo',
        'Fewuruyekalo',
        'Marisikalo',
        'Awirilikalo',
        'Mɛkalo',
        'Zuwɛnkalo',
        'Zuluyekalo',
        'Utikalo',
        'Sɛtanburukalo',
        'ɔkutɔburukalo',
        'Nowanburukalo',
        'Desanburukalo',
      ];

  @override
  List<String> get monthsShort => const [
        'Zan',
        'Few',
        'Mar',
        'Awi',
        'Mɛ',
        'Zuw',
        'Zul',
        'Uti',
        'Sɛt',
        'ɔku',
        'Now',
        'Des',
      ];

  @override
  List<String> get weekdays => const [
        'Kari',
        'Ntɛnɛn',
        'Tarata',
        'Araba',
        'Alamisa',
        'Juma',
        'Sibiri',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Kar',
        'Ntɛ',
        'Tar',
        'Ara',
        'Ala',
        'Jum',
        'Sib',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Ka',
        'Nt',
        'Ta',
        'Ar',
        'Al',
        'Ju',
        'Si',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'MMMM [tile] D [san] YYYY',
        lll: 'MMMM [tile] D [san] YYYY [lɛrɛ] HH:mm',
        llll: 'dddd MMMM [tile] D [san] YYYY [lɛrɛ] HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s kɔnɔ',
        past: 'a bɛ %s bɔ',
        s: 'sanga dama dama',
        m: 'miniti kelen',
        mm: 'miniti %d',
        h: 'lɛrɛ kelen',
        hh: 'lɛrɛ %d',
        d: 'tile kelen',
        dd: 'tile %d',
        mo: 'kalo kelen',
        mos: 'kalo %d',
        y: 'san kelen',
        yy: 'san %d',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
