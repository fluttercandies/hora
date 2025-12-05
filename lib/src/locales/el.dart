// EL Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Greek locale.
class HoraLocaleEl extends HoraLocale {
  const HoraLocaleEl();

  @override
  String get code => 'el';

  @override
  List<String> get months => const [
        'Ιανουάριος',
        'Φεβρουάριος',
        'Μάρτιος',
        'Απρίλιος',
        'Μάιος',
        'Ιούνιος',
        'Ιούλιος',
        'Αύγουστος',
        'Σεπτέμβριος',
        'Οκτώβριος',
        'Νοέμβριος',
        'Δεκέμβριος',
      ];

  @override
  List<String> get monthsShort => const [
        'Ιαν',
        'Φεβ',
        'Μαρ',
        'Απρ',
        'Μαι',
        'Ιουν',
        'Ιουλ',
        'Αυγ',
        'Σεπτ',
        'Οκτ',
        'Νοε',
        'Δεκ',
      ];

  @override
  List<String> get weekdays => const [
        'Κυριακή',
        'Δευτέρα',
        'Τρίτη',
        'Τετάρτη',
        'Πέμπτη',
        'Παρασκευή',
        'Σάββατο',
      ];

  @override
  List<String> get weekdaysShort => const [
        'Κυρ',
        'Δευ',
        'Τρι',
        'Τετ',
        'Πεμ',
        'Παρ',
        'Σαβ',
      ];

  @override
  List<String> get weekdaysMin => const [
        'Κυ',
        'Δε',
        'Τρ',
        'Τε',
        'Πε',
        'Πα',
        'Σα',
      ];

  @override
  int get weekStart => 1;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY h:mm A',
        llll: 'dddd, D MMMM YYYY h:mm A',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'σε %s',
        past: 'πριν %s',
        s: 'μερικά δευτερόλεπτα',
        m: 'ένα λεπτό',
        mm: '%d λεπτά',
        h: 'μία ώρα',
        hh: '%d ώρες',
        d: 'μία μέρα',
        dd: '%d μέρες',
        mo: 'ένα μήνα',
        mos: '%d μήνες',
        y: 'ένα χρόνο',
        yy: '%d χρόνια',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
