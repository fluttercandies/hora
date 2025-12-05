// LO Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Lao locale.
class HoraLocaleLo extends HoraLocale {
  const HoraLocaleLo();

  @override
  String get code => 'lo';

  @override
  List<String> get months => const [
        'ມັງກອນ',
        'ກຸມພາ',
        'ມີນາ',
        'ເມສາ',
        'ພຶດສະພາ',
        'ມິຖຸນາ',
        'ກໍລະກົດ',
        'ສິງຫາ',
        'ກັນຍາ',
        'ຕຸລາ',
        'ພະຈິກ',
        'ທັນວາ',
      ];

  @override
  List<String> get monthsShort => const [
        'ມັງກອນ',
        'ກຸມພາ',
        'ມີນາ',
        'ເມສາ',
        'ພຶດສະພາ',
        'ມິຖຸນາ',
        'ກໍລະກົດ',
        'ສິງຫາ',
        'ກັນຍາ',
        'ຕຸລາ',
        'ພະຈິກ',
        'ທັນວາ',
      ];

  @override
  List<String> get weekdays => const [
        'ອາທິດ',
        'ຈັນ',
        'ອັງຄານ',
        'ພຸດ',
        'ພະຫັດ',
        'ສຸກ',
        'ເສົາ',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ທິດ',
        'ຈັນ',
        'ອັງຄານ',
        'ພຸດ',
        'ພະຫັດ',
        'ສຸກ',
        'ເສົາ',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ທ',
        'ຈ',
        'ອຄ',
        'ພ',
        'ພຫ',
        'ສກ',
        'ສ',
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
        lll: 'D MMMM YYYY HH:mm',
        llll: 'ວັນdddd D MMMM YYYY HH:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: 'ອີກ %s',
        past: '%sຜ່ານມາ',
        s: 'ບໍ່ເທົ່າໃດວິນາທີ',
        m: '1 ນາທີ',
        mm: '%d ນາທີ',
        h: '1 ຊົ່ວໂມງ',
        hh: '%d ຊົ່ວໂມງ',
        d: '1 ມື້',
        dd: '%d ມື້',
        mo: '1 ເດືອນ',
        mos: '%d ເດືອນ',
        y: '1 ປີ',
        yy: '%d ປີ',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
