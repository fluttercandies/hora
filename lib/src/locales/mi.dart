// MI Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Maori locale.
class HoraLocaleMi extends HoraLocale {
  const HoraLocaleMi();

  @override
  String get code => 'mi';

  @override
  List<String> get months => const [
        'Kohi-tāte',
        'Hui-tanguru',
        'Poutū-te-rangi',
        'Paenga-whāwhā',
        'Haratua',
        'Pipiri',
        'Hōngoingoi',
        'Here-turi-kōkā',
        'Mahuru',
        'Whiringa-ā-nuku',
        'Whiringa-ā-rangi',
        'Hakihea',
      ];

  @override
  List<String> get monthsShort => const [
        'Kohi',
        'Hui',
        'Pou',
        'Pae',
        'Hara',
        'Pipi',
        'Hōngoi',
        'Here',
        'Mahu',
        'Whi-nu',
        'Whi-ra',
        'Haki',
      ];

  @override
  List<String> get weekdays => const [
        'Rātapu',
        'Mane',
        'Tūrei',
        'Wenerei',
        'Tāite',
        'Paraire',
        'Hātarei',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Ta',
        'Ma',
        'Tū',
        'We',
        'Tāi',
        'Pa',
        'Hā',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Ta',
        'Ma',
        'Tū',
        'We',
        'Tāi',
        'Pa',
        'Hā',
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
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY [i] HH:mm',
        llll: 'dddd, D MMMM YYYY [i] HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'i roto i %s',
        past: '%s i mua',
        s: 'te hēkona ruarua',
        m: 'he meneti',
        mm: '%d meneti',
        h: 'te haora',
        hh: '%d haora',
        d: 'he ra',
        dd: '%d ra',
        mo: 'he marama',
        mos: '%d marama',
        y: 'he tau',
        yy: '%d tau',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
