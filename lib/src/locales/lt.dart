// LT Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Lithuanian locale.
class HoraLocaleLt extends HoraLocale {
  const HoraLocaleLt();

  @override
  String get code => 'lt';

  @override
  List<String> get months => const [
        'sausis',
        'vasaris',
        'kovas',
        'balandis',
        'gegužė',
        'birželis',
        'liepa',
        'rugpjūtis',
        'rugsėjis',
        'spalis',
        'lapkritis',
        'gruodis',
      ];

  @override
  List<String> get monthsShort => const [
        'sau',
        'vas',
        'kov',
        'bal',
        'geg',
        'bir',
        'lie',
        'rgp',
        'rgs',
        'spa',
        'lap',
        'grd',
      ];

  @override
  List<String> get weekdays => const [
        'sekmadienis',
        'pirmadienis',
        'antradienis',
        'trečiadienis',
        'ketvirtadienis',
        'penktadienis',
        'šeštadienis',
      ];

  @override
  List<String> get weekdaysShort => const [
        'sek',
        'pir',
        'ant',
        'tre',
        'ket',
        'pen',
        'šeš',
      ];

  @override
  List<String> get weekdaysMin => const [
        's',
        'p',
        'a',
        't',
        'k',
        'pn',
        'š',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'YYYY-MM-DD',
        ll: 'YYYY [m.] MMMM D [d.]',
        lll: 'YYYY [m.] MMMM D [d.], HH:mm [val.]',
        llll: 'YYYY [m.] MMMM D [d.], dddd, HH:mm [val.]',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'už %s',
        past: 'prieš %s',
        s: 'kelias sekundes',
        m: 'minutę',
        h: 'valandą',
        hh: '%d valandas',
        d: 'dieną',
        dd: '%d dienas',
        mo: 'mėnesį',
        mos: '%d mėnesius',
        y: 'metus',
        yy: '%d metus',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n.';
}
