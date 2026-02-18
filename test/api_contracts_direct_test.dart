import 'package:hora/hora.dart';
import 'package:hora/plugins.dart';
import 'package:test/test.dart';

void main() {
  group('Direct API contracts', () {
    test('Hora.toString returns ISO for valid and fixed text for invalid', () {
      final valid = Hora.of(
        year: 2024,
        month: 3,
        day: 15,
        hour: 10,
        minute: 20,
        second: 30,
        utc: true,
      );
      expect(valid.toString(), valid.toIso8601());

      final invalid = Hora.parse('invalid');
      expect(invalid.toString(), 'Invalid Hora');
    });

    test('HoraDuration.toString equals ISO representation', () {
      final d = HoraDuration(days: 5, hours: 2, minutes: 30);
      expect(d.toString(), d.toIso8601());
      expect(d.toString(), 'P5DT2H30M');
    });

    test('FiscalYearConfig and FiscalPeriod toString are stable', () {
      const config = FiscalYearConfig(
        startMonth: 4,
        startDay: 6,
        yearOffset: 1,
      );
      expect(
        config.toString(),
        'FiscalYearConfig(startMonth: 4, startDay: 6, offset: 1)',
      );

      const period = FiscalPeriod(
        year: 2025,
        quarter: 1,
        periodInQuarter: 2,
        config: config,
      );
      expect(period.toString(), period.displayString);
      expect(period.toString(), 'FY2025 Q1');
    });

    test('MinMaxResult.toString includes both bounds', () {
      final min = Hora.of(year: 2024, utc: true);
      final max = Hora.of(year: 2024, month: 12, day: 31, utc: true);
      final mm = MinMaxResult(min: min, max: max);

      final text = mm.toString();
      expect(text, startsWith('MinMaxResult(min: '));
      expect(text, contains(min.toIso8601()));
      expect(text, contains(max.toIso8601()));
    });

    test('LocaleData.toString exposes locale code', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(h.localeData.toString(), 'LocaleData(en)');
    });

    test('MonthCalendar and YearCalendar toString are deterministic', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      final monthCal = h.monthCalendar();
      final yearCal = h.yearCalendar();

      expect(
        monthCal.toString(),
        matches(RegExp(r'^MonthCalendar\(2024-3, \d+ weeks\)$')),
      );
      expect(yearCal.toString(), 'YearCalendar(2024)');
    });

    test('RelativeTimeDiff.toString delegates to format()', () {
      const diff = RelativeTimeDiff(
        years: 0,
        months: 1,
        days: 2,
        hours: 3,
        minutes: 4,
        seconds: 5,
        isFuture: true,
      );
      expect(diff.toString(), diff.format());
      expect(diff.toString(), startsWith('in '));
    });

    test('HoraTimezone.toString returns timezone name', () {
      expect(HoraTimezone.fromOffset(9).toString(), 'UTC+9');
      expect(HoraTimezone.fromOffset(-5, minutes: -30).toString(), 'UTC-5:30');
    });

    test('HoraZoned.compareTo compares by absolute instant', () {
      final utcNoon = Hora.of(
        year: 2024,
        month: 3,
        day: 15,
        hour: 12,
        utc: true,
      );
      final sameInstantJst = utcNoon.inTimezone(HoraTimezone.fromOffset(9));
      final sameInstantEst = utcNoon.inTimezone(HoraTimezone.fromOffset(-5));
      final plusOneHour = utcNoon
          .add(1, TemporalUnit.hour)
          .inTimezone(HoraTimezone.fromOffset(9));

      expect(sameInstantJst.compareTo(sameInstantEst), 0);
      expect(sameInstantJst.compareTo(plusOneHour), isNegative);
      expect(plusOneHour.compareTo(sameInstantEst), isPositive);
    });

    test('HoraZoned.toString matches toIso8601String()', () {
      final zoned = Hora.of(
        year: 2024,
        month: 3,
        day: 15,
        hour: 12,
        second: 1,
        millisecond: 234,
        microsecond: 567,
        utc: true,
      ).inTimezone(HoraTimezone.fromOffset(9));

      expect(zoned.toString(), zoned.toIso8601String());
      expect(zoned.toString(), '2024-03-15T21:00:01.234567+09:00');
    });

    test('TimezoneRange.contains is inclusive on both boundaries', () {
      final tz = HoraTimezone.utc;
      final start = Hora.of(
        year: 2024,
        month: 3,
        day: 15,
        hour: 9,
        utc: true,
      );
      final end = Hora.of(
        year: 2024,
        month: 3,
        day: 15,
        hour: 17,
        utc: true,
      );

      final range = TimezoneRange(
        start: start.inTimezone(tz),
        end: end.inTimezone(tz),
        timezone: tz,
      );

      expect(range.contains(start), isTrue);
      expect(range.contains(end), isTrue);
      expect(
        range.contains(
          Hora.of(year: 2024, month: 3, day: 15, hour: 18, utc: true),
        ),
        isFalse,
      );
    });

    test('TimezoneRange.toString contains span and timezone', () {
      final tz = HoraTimezone.fromOffset(9);
      final range = TimezoneRange(
        start: Hora.of(
          year: 2024,
          month: 3,
          day: 15,
          hour: 9,
          utc: true,
        ).inTimezone(tz),
        end: Hora.of(
          year: 2024,
          month: 3,
          day: 15,
          hour: 10,
          utc: true,
        ).inTimezone(tz),
        timezone: tz,
      );

      final text = range.toString();
      expect(text, startsWith('TimezoneRange('));
      expect(text, contains('UTC+9'));
    });
  });
}
