import 'package:hora/hora.dart';
import 'package:test/test.dart';

void main() {
  group('HoraLocale', () {
    test('HoraLocaleEn has correct code', () {
      const locale = HoraLocaleEn();
      expect(locale.code, 'en');
    });

    test('HoraLocaleEn has 12 months', () {
      const locale = HoraLocaleEn();
      expect(locale.months, hasLength(12));
      expect(locale.monthsShort, hasLength(12));
    });

    test('HoraLocaleEn has 7 weekdays', () {
      const locale = HoraLocaleEn();
      expect(locale.weekdays, hasLength(7));
      expect(locale.weekdaysShort, hasLength(7));
      expect(locale.weekdaysMin, hasLength(7));
    });

    test('HoraLocaleEn ordinal', () {
      const locale = HoraLocaleEn();
      expect(locale.ordinal(1), '1st');
      expect(locale.ordinal(2), '2nd');
      expect(locale.ordinal(3), '3rd');
      expect(locale.ordinal(4), '4th');
      expect(locale.ordinal(11), '11th');
      expect(locale.ordinal(21), '21st');
    });

    test('HoraLocaleEn meridiem', () {
      const locale = HoraLocaleEn();
      expect(locale.meridiem(8, 0), 'AM');
      expect(locale.meridiem(14, 0), 'PM');
      expect(locale.meridiem(8, 0, lowercase: true), 'am');
      expect(locale.meridiem(14, 0, lowercase: true), 'pm');
    });
  });

  group('HoraLocaleZhCn', () {
    test('has correct code', () {
      const locale = HoraLocaleZhCn();
      expect(locale.code, 'zh-cn');
    });

    test('has Chinese month names', () {
      const locale = HoraLocaleZhCn();
      expect(locale.months[0], '一月');
      expect(locale.months[11], '十二月');
    });

    test('has Chinese weekday names', () {
      const locale = HoraLocaleZhCn();
      expect(locale.weekdays[0], '星期日');
      expect(locale.weekdays[1], '星期一');
    });

    test('weekStart is Monday', () {
      const locale = HoraLocaleZhCn();
      expect(locale.weekStart, 1);
    });

    test('meridiem returns Chinese periods', () {
      const locale = HoraLocaleZhCn();
      expect(locale.meridiem(5, 0), '凌晨');
      expect(locale.meridiem(8, 0), '早上');
      expect(locale.meridiem(10, 0), '上午');
      expect(locale.meridiem(12, 0), '中午');
      expect(locale.meridiem(15, 0), '下午');
      expect(locale.meridiem(20, 0), '晚上');
    });

    test('invalidDate is Chinese', () {
      const locale = HoraLocaleZhCn();
      expect(locale.invalidDate, '无效日期');
    });
  });

  group('HoraFormats', () {
    test('default formats', () {
      const formats = HoraFormats();
      expect(formats.lt, 'h:mm A');
      expect(formats.lts, 'h:mm:ss A');
      expect(formats.l, 'MM/DD/YYYY');
      expect(formats.ll, 'MMMM D, YYYY');
    });

    test('Chinese formats', () {
      const locale = HoraLocaleZhCn();
      expect(locale.formats.l, 'YYYY/MM/DD');
      expect(locale.formats.ll, 'YYYY年M月D日');
    });
  });

  group('HoraRelativeTime', () {
    test('default templates', () {
      const rel = HoraRelativeTime();
      expect(rel.future, 'in %s');
      expect(rel.past, '%s ago');
      expect(rel.s, 'a few seconds');
      expect(rel.m, 'a minute');
    });

    test('format() creates relative string', () {
      const rel = HoraRelativeTime();
      expect(rel.format(5, 'mm', isFuture: false), '5 minutes ago');
      expect(rel.format(3, 'hh', isFuture: true), 'in 3 hours');
    });

    test('Chinese relative time', () {
      const locale = HoraLocaleZhCn();
      expect(locale.relativeTime.future, '%s内');
      expect(locale.relativeTime.past, '%s前');
    });
  });

  group('Hora with Locale', () {
    test('withLocale changes locale', () {
      final h = Hora.now();
      final zhHora = h.withLocale(const HoraLocaleZhCn());
      expect(zhHora.locale.code, 'zh-cn');
    });

    test('format uses locale month names', () {
      final h = Hora.of(year: 2023, month: 6, day: 15);
      final zhHora = h.withLocale(const HoraLocaleZhCn());
      expect(zhHora.format('MMMM'), '六月');
    });

    test('format uses locale weekday names', () {
      // 2023-12-25 is Monday
      final h = Hora.of(
        year: 2023,
        month: 12,
        day: 25,
        locale: const HoraLocaleZhCn(),
      );
      expect(h.format('dddd'), '星期一');
    });

    test('format uses locale meridiem', () {
      final h = Hora.of(
        year: 2023,
        month: 12,
        day: 25,
        hour: 14,
        locale: const HoraLocaleZhCn(),
      );
      expect(h.format('A'), '下午');
    });

    test('globalLocale affects new instances', () {
      final original = Hora.globalLocale;
      Hora.globalLocale = const HoraLocaleZhCn();

      final h = Hora.now();
      expect(h.locale.code, 'zh-cn');

      // Restore
      Hora.globalLocale = original;
    });
  });
}
