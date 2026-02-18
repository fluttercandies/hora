import 'package:hora/hora.dart';
import 'package:hora/src/plugins/buddhist_era.dart';
import 'package:test/test.dart';

void main() {
  group('BuddhistEraExt', () {
    test('buddhistYear adds 543 to Gregorian year', () {
      expect(Hora.of(year: 2024).buddhistYear, 2567);
      expect(Hora.of(year: 2000).buddhistYear, 2543);
      expect(Hora.of(year: 1).buddhistYear, 544);
    });

    test('buddhistYearShort returns two-digit year', () {
      expect(Hora.of(year: 2024).buddhistYearShort, 67);
      expect(Hora.of(year: 1957).buddhistYearShort, 0);
    });

    test('formatBuddhistEra with BBBB token', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(h.formatBuddhistEra('BBBB'), '2567');
    });

    test('formatBuddhistEra with BB token', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(h.formatBuddhistEra('BB'), '67');
    });

    test('formatBuddhistEra combines with standard tokens', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(h.formatBuddhistEra('DD/MM/BBBB'), '15/03/2567');
    });

    test('formatBuddhistEra preserves text in brackets', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(h.formatBuddhistEra('[Year] BBBB [BE]'), 'Year 2567 BE');
    });

    test('formatBuddhistEra does not expand tokens inside escaped text', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(h.formatBuddhistEra('[BBBB] BB'), 'BBBB 67');
    });

    test('horaBuddhistEra creates Gregorian-equivalent Hora', () {
      final h = horaBuddhistEra(year: 2567, month: 3, day: 15);
      expect(h.year, 2024);
      expect(h.month, 3);
      expect(h.day, 15);
    });

    test('withBuddhistYear updates CE year while preserving date fields', () {
      final original = Hora.of(
        year: 2024,
        month: 3,
        day: 15,
        hour: 10,
        minute: 20,
        second: 30,
      );
      final updated = original.withBuddhistYear(2568);

      expect(updated.year, 2025);
      expect(updated.month, 3);
      expect(updated.day, 15);
      expect(updated.hour, 10);
      expect(updated.minute, 20);
      expect(updated.second, 30);
    });
  });

  group('MultiEraCalendarExt', () {
    test('yearIn supports common, buddhist and minguo eras', () {
      final h = Hora.of(year: 2024);
      expect(h.yearIn(CalendarEra.common), 2024);
      expect(h.yearIn(CalendarEra.buddhist), 2567);
      expect(h.yearIn(CalendarEra.minguo), 113);
    });

    test('japanese era uses exact boundary dates', () {
      final showaLast = Hora.of(year: 1989, day: 7);
      expect(showaLast.japaneseEraName, equals('昭和'));
      expect(showaLast.yearIn(CalendarEra.japanese), equals(64));

      final heiseiFirst = Hora.of(year: 1989, day: 8);
      expect(heiseiFirst.japaneseEraName, equals('平成'));
      expect(heiseiFirst.yearIn(CalendarEra.japanese), equals(1));

      final heiseiLast = Hora.of(year: 2019, month: 4, day: 30);
      expect(heiseiLast.japaneseEraName, equals('平成'));
      expect(heiseiLast.yearIn(CalendarEra.japanese), equals(31));

      final reiwaFirst = Hora.of(year: 2019, month: 5);
      expect(reiwaFirst.japaneseEraName, equals('令和'));
      expect(reiwaFirst.yearIn(CalendarEra.japanese), equals(1));
    });
  });
}
