// IT-CH Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Italian (Switzerland) locale.
class HoraLocaleItCh extends HoraLocale {
  const HoraLocaleItCh();

  @override
  String get code => 'it-ch';

  @override
  List<String> get months => const [
        'gennaio',
        'febbraio',
        'marzo',
        'aprile',
        'maggio',
        'giugno',
        'luglio',
        'agosto',
        'settembre',
        'ottobre',
        'novembre',
        'dicembre',
      ];

  @override
  List<String> get monthsShort => const [
        'gen',
        'feb',
        'mar',
        'apr',
        'mag',
        'giu',
        'lug',
        'ago',
        'set',
        'ott',
        'nov',
        'dic',
      ];

  @override
  List<String> get weekdays => const [
        'domenica',
        'lunedì',
        'martedì',
        'mercoledì',
        'giovedì',
        'venerdì',
        'sabato',
      ];

  @override
  List<String> get weekdaysShort => const [
        'dom',
        'lun',
        'mar',
        'mer',
        'gio',
        'ven',
        'sab',
      ];

  @override
  List<String> get weekdaysMin => const [
        'do',
        'lu',
        'ma',
        'me',
        'gi',
        've',
        'sa',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD.MM.YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY HH:mm',
        llll: 'dddd D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'tra %s',
        past: '%s fa',
        s: 'alcuni secondi',
        m: 'un minuto',
        mm: '%d minuti',
        h: r'un\',
        hh: '%d ore',
        d: 'un giorno',
        dd: '%d giorni',
        mo: 'un mese',
        mos: '%d mesi',
        y: 'un anno',
        yy: '%d anni',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
