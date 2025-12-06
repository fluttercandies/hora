// TZL Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Talossan locale.
class HoraLocaleTzl extends HoraLocale {
  const HoraLocaleTzl();

  @override
  String get code => 'tzl';

  @override
  List<String> get months => const [
        'Januar',
        'Fevraglh',
        'Març',
        'Avrïu',
        'Mai',
        'Gün',
        'Julia',
        'Guscht',
        'Setemvar',
        'Listopäts',
        'Noemvar',
        'Zecemvar',
      ];

  @override
  List<String> get monthsShort => const [
        'Jan',
        'Fev',
        'Mar',
        'Avr',
        'Mai',
        'Gün',
        'Jul',
        'Gus',
        'Set',
        'Lis',
        'Noe',
        'Zec',
      ];

  @override
  List<String> get weekdays => const [
        'Súladi',
        'Lúneçi',
        'Maitzi',
        'Márcuri',
        'Xhúadi',
        'Viénerçi',
        'Sáturi',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Súl',
        'Lún',
        'Mai',
        'Már',
        'Xhú',
        'Vié',
        'Sát',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Sú',
        'Lú',
        'Ma',
        'Má',
        'Xh',
        'Vi',
        'Sá',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH.mm',
        lts: 'HH.mm.ss',
        l: 'DD.MM.YYYY',
        ll: 'D. MMMM [dallas] YYYY',
        lll: 'D. MMMM [dallas] YYYY HH.mm',
        llll: 'dddd, [li] D. MMMM [dallas] YYYY HH.mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime();

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
