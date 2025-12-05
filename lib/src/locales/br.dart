// BR Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Breton locale.
class HoraLocaleBr extends HoraLocale {
  const HoraLocaleBr();

  @override
  String get code => 'br';

  @override
  List<String> get months => const [
        'Genver',
        'Cʼhwevrer',
        'Meurzh',
        'Ebrel',
        'Mae',
        'Mezheven',
        'Gouere',
        'Eost',
        'Gwengolo',
        'Here',
        'Du',
        'Kerzu',
      ];

  @override
  List<String> get monthsShort => const [
        'Gen',
        'Cʼhwe',
        'Meu',
        'Ebr',
        'Mae',
        'Eve',
        'Gou',
        'Eos',
        'Gwe',
        'Her',
        'Du',
        'Ker',
      ];

  @override
  List<String> get weekdays => const [
        'Sul',
        'Lun',
        'Meurzh',
        'Mercʼher',
        'Yaou',
        'Gwener',
        'Sadorn',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Sul',
        'Lun',
        'Meu',
        'Mer',
        'Yao',
        'Gwe',
        'Sad',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Su',
        'Lu',
        'Me',
        'Mer',
        'Ya',
        'Gw',
        'Sa',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'h[e]mm A',
        lts: 'h[e]mm:ss A',
        l: 'DD/MM/YYYY',
        ll: 'D [a viz] MMMM YYYY',
        lll: 'D [a viz] MMMM YYYY h[e]mm A',
        llll: 'dddd, D [a viz] MMMM YYYY h[e]mm A',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'a-benn %s',
        past: '%s ʼzo',
        s: 'un nebeud segondennoù',
        m: 'v',
        mm: 'munutenn',
        h: 'un eur',
        hh: '%d eur',
        d: 'z',
        dd: 'devezh',
        mo: 'ur miz',
        mos: 'miz',
        y: 'ur bloaz',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
  @override
  String meridiem(int hour, int minute, {bool lowercase = false}) =>
      hour < 12 ? 'a.m.' : 'g.m.';
}
