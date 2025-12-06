import 'package:hora/hora.dart';
import 'package:hora/src/plugins/locale_data.dart';
import 'package:test/test.dart';

void main() {
  group('LocaleData', () {
    test('code returns locale code', () {
      final h = Hora.now();
      expect(h.localeData.code, 'en');
    });

    test('months returns 12 months', () {
      final data = Hora.now().localeData;
      expect(data.months.length, 12);
      expect(data.months.first, 'January');
    });

    test('monthsShort returns 12 short month names', () {
      final data = Hora.now().localeData;
      expect(data.monthsShort.length, 12);
      expect(data.monthsShort.first, 'Jan');
    });

    test('weekdays returns 7 weekday names', () {
      final data = Hora.now().localeData;
      expect(data.weekdays.length, 7);
      expect(data.weekdays[0], 'Sunday');
    });

    test('weekdaysShort returns 7 short weekday names', () {
      final data = Hora.now().localeData;
      expect(data.weekdaysShort.length, 7);
    });

    test('weekdaysMin returns 7 minimal weekday names', () {
      final data = Hora.now().localeData;
      expect(data.weekdaysMin.length, 7);
    });

    test('firstDayOfWeek', () {
      final data = Hora.now().localeData;
      // weekStart returns 1-7 (ISO format: 1=Monday, 7=Sunday)
      expect(data.firstDayOfWeek, inInclusiveRange(1, 7));
    });

    test('ordinal generates ordinal suffixes', () {
      final data = Hora.now().localeData;
      expect(data.ordinal(1), '1st');
      expect(data.ordinal(2), '2nd');
      expect(data.ordinal(3), '3rd');
      expect(data.ordinal(4), '4th');
      expect(data.ordinal(11), '11th');
      expect(data.ordinal(21), '21st');
    });

    test('monthName validates range', () {
      final data = Hora.now().localeData;
      expect(data.monthName(1), 'January');
      expect(data.monthName(12), 'December');
      expect(() => data.monthName(0), throwsArgumentError);
      expect(() => data.monthName(13), throwsArgumentError);
    });

    test('weekdayName validates range', () {
      final data = Hora.now().localeData;
      expect(data.weekdayName(0), 'Sunday');
      expect(data.weekdayName(6), 'Saturday');
      expect(() => data.weekdayName(-1), throwsArgumentError);
      expect(() => data.weekdayName(7), throwsArgumentError);
    });
  });

  group('LocaleDataExt', () {
    test('monthName returns current month name', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(h.monthName, 'March');
    });

    test('monthNameShort returns current short month name', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(h.monthNameShort, 'Mar');
    });

    test('weekdayName returns current weekday name', () {
      final h = Hora.of(year: 2024, month: 3, day: 15); // Friday
      expect(h.weekdayName, 'Friday');
    });

    test('weekdayNameShort returns current short weekday name', () {
      final h = Hora.of(year: 2024, month: 3, day: 15); // Friday
      expect(h.weekdayNameShort, 'Fri');
    });

    test('dayOrdinal returns ordinal for day', () {
      expect(Hora.of(year: 2024, month: 3).dayOrdinal, '1st');
      expect(Hora.of(year: 2024, month: 3, day: 2).dayOrdinal, '2nd');
      expect(Hora.of(year: 2024, month: 3, day: 3).dayOrdinal, '3rd');
    });

    test('meridiemString returns AM/PM', () {
      expect(
        Hora.of(year: 2024, month: 3, day: 15, hour: 9).meridiemString,
        'AM',
      );
      expect(
        Hora.of(year: 2024, month: 3, day: 15, hour: 14).meridiemString,
        'PM',
      );
    });
  });

  group('LocaleIterationExt', () {
    test('monthEntries iterates all months', () {
      final entries = Hora.now().localeData.monthEntries.toList();
      expect(entries.length, 12);
      expect(entries.first.key, 1);
      expect(entries.first.value, 'January');
      expect(entries.last.key, 12);
      expect(entries.last.value, 'December');
    });

    test('weekdayEntries iterates all weekdays', () {
      final entries = Hora.now().localeData.weekdayEntries.toList();
      expect(entries.length, 7);
      expect(entries.first.key, 0);
      expect(entries.first.value, 'Sunday');
    });
  });

  group('with different locale', () {
    test('Chinese locale', () {
      final h = Hora.of(year: 2024, month: 3, day: 15)
          .withLocale(const HoraLocaleZhCn());

      expect(h.localeData.code, 'zh-cn');
      expect(h.monthName, '三月');
    });
  });
}
