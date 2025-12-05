// TA Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Tamil locale.
class HoraLocaleTa extends HoraLocale {
  const HoraLocaleTa();

  @override
  String get code => 'ta';

  @override
  List<String> get months => const [
        'ஜனவரி',
        'பிப்ரவரி',
        'மார்ச்',
        'ஏப்ரல்',
        'மே',
        'ஜூன்',
        'ஜூலை',
        'ஆகஸ்ட்',
        'செப்டெம்பர்',
        'அக்டோபர்',
        'நவம்பர்',
        'டிசம்பர்',
      ];

  @override
  List<String> get monthsShort => const [
        'ஜனவரி',
        'பிப்ரவரி',
        'மார்ச்',
        'ஏப்ரல்',
        'மே',
        'ஜூன்',
        'ஜூலை',
        'ஆகஸ்ட்',
        'செப்டெம்பர்',
        'அக்டோபர்',
        'நவம்பர்',
        'டிசம்பர்',
      ];

  @override
  List<String> get weekdays => const [
        'ஞாயிற்றுக்கிழமை',
        'திங்கட்கிழமை',
        'செவ்வாய்கிழமை',
        'புதன்கிழமை',
        'வியாழக்கிழமை',
        'வெள்ளிக்கிழமை',
        'சனிக்கிழமை',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ஞாயிறு',
        'திங்கள்',
        'செவ்வாய்',
        'புதன்',
        'வியாழன்',
        'வெள்ளி',
        'சனி',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ஞா',
        'தி',
        'செ',
        'பு',
        'வி',
        'வெ',
        'ச',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'HH:mm',
        lts: 'HH:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY, HH:mm',
        llll: 'dddd, D MMMM YYYY, HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s இல்',
        past: '%s முன்',
        s: 'ஒரு சில விநாடிகள்',
        m: 'ஒரு நிமிடம்',
        mm: '%d நிமிடங்கள்',
        h: 'ஒரு மணி நேரம்',
        hh: '%d மணி நேரம்',
        d: 'ஒரு நாள்',
        dd: '%d நாட்கள்',
        mo: 'ஒரு மாதம்',
        mos: '%d மாதங்கள்',
        y: 'ஒரு வருடம்',
        yy: '%d ஆண்டுகள்',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
