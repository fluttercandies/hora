// X-PSEUDO Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Pseudo locale.
class HoraLocaleXPseudo extends HoraLocale {
  const HoraLocaleXPseudo();

  @override
  String get code => 'x-pseudo';

  @override
  List<String> get months => const [
        'J~áñúá~rý',
        'F~ébrú~árý',
        '~Márc~h',
        'Áp~ríl',
        '~Máý',
        '~Júñé~',
        'Júl~ý',
        'Áú~gúst~',
        'Sép~témb~ér',
        'Ó~ctób~ér',
        'Ñ~óvém~bér',
        '~Décé~mbér',
      ];

  @override
  List<String> get monthsShort => const [
        'J~áñ',
        '~Féb',
        '~Már',
        '~Ápr',
        '~Máý',
        '~Júñ',
        '~Júl',
        '~Áúg',
        '~Sép',
        '~Óct',
        '~Ñóv',
        '~Déc',
      ];

  @override
  List<String> get weekdays => const [
        'S~úñdá~ý',
        'Mó~ñdáý~',
        'Túé~sdáý~',
        'Wéd~ñésd~áý',
        'T~húrs~dáý',
        '~Fríd~áý',
        'S~átúr~dáý',
      ];

  @override
  List<String> get weekdaysShort => const [
        'S~úñ',
        '~Móñ',
        '~Túé',
        '~Wéd',
        '~Thú',
        '~Frí',
        '~Sát',
      ];

  @override
  List<String> get weekdaysMin => const [
        'S~ú',
        'Mó~',
        'Tú',
        '~Wé',
        'T~h',
        'Fr~',
        'Sá',
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
        lll: 'D MMMM YYYY HH:mm',
        llll: 'dddd, D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'í~ñ %s',
        past: '%s á~gó',
        s: 'á ~féw ~sécó~ñds',
        m: 'á ~míñ~úté',
        mm: '%d m~íñú~tés',
        h: 'á~ñ hó~úr',
        hh: '%d h~óúrs',
        d: 'á ~dáý',
        dd: '%d d~áýs',
        mo: 'á ~móñ~th',
        mos: '%d m~óñt~hs',
        y: 'á ~ýéár',
        yy: '%d ý~éárs',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
