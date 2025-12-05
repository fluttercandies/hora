// FR-CH Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// French (Switzerland) locale.
class HoraLocaleFrCh extends HoraLocale {
  const HoraLocaleFrCh();

  @override
  String get code => 'fr-ch';

  @override
  List<String> get months => const [
        'janvier',
        'février',
        'mars',
        'avril',
        'mai',
        'juin',
        'juillet',
        'août',
        'septembre',
        'octobre',
        'novembre',
        'décembre',
      ];

  @override
  List<String> get monthsShort => const [
        'janv.',
        'févr.',
        'mars',
        'avr.',
        'mai',
        'juin',
        'juil.',
        'août',
        'sept.',
        'oct.',
        'nov.',
        'déc.',
      ];

  @override
  List<String> get weekdays => const [
        'dimanche',
        'lundi',
        'mardi',
        'mercredi',
        'jeudi',
        'vendredi',
        'samedi',
      ];

  @override
  List<String> get weekdaysShort => const [
        'dim.',
        'lun.',
        'mar.',
        'mer.',
        'jeu.',
        'ven.',
        'sam.',
      ];

  @override
  List<String> get weekdaysMin => const [
        'di',
        'lu',
        'ma',
        'me',
        'je',
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
        future: 'dans %s',
        past: 'il y a %s',
        s: 'quelques secondes',
        m: 'une minute',
        h: 'une heure',
        hh: '%d heures',
        d: 'un jour',
        dd: '%d jours',
        mo: 'un mois',
        mos: '%d mois',
        y: 'un an',
        yy: '%d ans',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
