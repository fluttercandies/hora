// BN Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Bengali locale.
class HoraLocaleBn extends HoraLocale {
  const HoraLocaleBn();

  @override
  String get code => 'bn';

  @override
  List<String> get months => const [
        'জানুয়ারি',
        'ফেব্রুয়ারি',
        'মার্চ',
        'এপ্রিল',
        'মে',
        'জুন',
        'জুলাই',
        'আগস্ট',
        'সেপ্টেম্বর',
        'অক্টোবর',
        'নভেম্বর',
        'ডিসেম্বর',
      ];

  @override
  List<String> get monthsShort => const [
        'জানু',
        'ফেব্রু',
        'মার্চ',
        'এপ্রিল',
        'মে',
        'জুন',
        'জুলাই',
        'আগস্ট',
        'সেপ্ট',
        'অক্টো',
        'নভে',
        'ডিসে',
      ];

  @override
  List<String> get weekdays => const [
        'রবিবার',
        'সোমবার',
        'মঙ্গলবার',
        'বুধবার',
        'বৃহস্পতিবার',
        'শুক্রবার',
        'শনিবার',
      ];

  @override
  List<String> get weekdaysShort => const [
        'রবি',
        'সোম',
        'মঙ্গল',
        'বুধ',
        'বৃহস্পতি',
        'শুক্র',
        'শনি',
      ];

  @override
  List<String> get weekdaysMin => const [
        'রবি',
        'সোম',
        'মঙ্গ',
        'বুধ',
        'বৃহঃ',
        'শুক্র',
        'শনি',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'A h:mm সময়',
        lts: 'A h:mm:ss সময়',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY, A h:mm সময়',
        llll: 'dddd, D MMMM YYYY, A h:mm সময়',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s পরে',
        past: '%s আগে',
        s: 'কয়েক সেকেন্ড',
        m: 'এক মিনিট',
        mm: '%d মিনিট',
        h: 'এক ঘন্টা',
        hh: '%d ঘন্টা',
        d: 'এক দিন',
        dd: '%d দিন',
        mo: 'এক মাস',
        mos: '%d মাস',
        y: 'এক বছর',
        yy: '%d বছর',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
