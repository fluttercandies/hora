// KM Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Khmer locale.
class HoraLocaleKm extends HoraLocale {
  const HoraLocaleKm();

  @override
  String get code => 'km';

  @override
  List<String> get months => const [
        'មករា',
        'កុម្ភៈ',
        'មីនា',
        'មេសា',
        'ឧសភា',
        'មិថុនា',
        'កក្កដា',
        'សីហា',
        'កញ្ញា',
        'តុលា',
        'វិច្ឆិកា',
        'ធ្នូ',
      ];

  @override
  List<String> get monthsShort => const [
        'មករា',
        'កុម្ភៈ',
        'មីនា',
        'មេសា',
        'ឧសភា',
        'មិថុនា',
        'កក្កដា',
        'សីហា',
        'កញ្ញា',
        'តុលា',
        'វិច្ឆិកា',
        'ធ្នូ',
      ];

  @override
  List<String> get weekdays => const [
        'អាទិត្យ',
        'ច័ន្ទ',
        'អង្គារ',
        'ពុធ',
        'ព្រហស្បតិ៍',
        'សុក្រ',
        'សៅរ៍',
      ];

  @override
  List<String> get weekdaysShort => const [
        'អា',
        'ច',
        'អ',
        'ព',
        'ព្រ',
        'សុ',
        'ស',
      ];

  @override
  List<String> get weekdaysMin => const [
        'អា',
        'ច',
        'អ',
        'ព',
        'ព្រ',
        'សុ',
        'ស',
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
        future: '%sទៀត',
        past: '%sមុន',
        s: 'ប៉ុន្មានវិនាទី',
        m: 'មួយនាទី',
        mm: '%d នាទី',
        h: 'មួយម៉ោង',
        hh: '%d ម៉ោង',
        d: 'មួយថ្ងៃ',
        dd: '%d ថ្ងៃ',
        mo: 'មួយខែ',
        mos: '%d ខែ',
        y: 'មួយឆ្នាំ',
        yy: '%d ឆ្នាំ',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
