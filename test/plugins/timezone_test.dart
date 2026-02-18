import 'package:hora/hora.dart';
import 'package:hora/src/plugins/timezone.dart';
import 'package:test/test.dart';

void main() {
  group('HoraTimezone', () {
    test('utc has zero offset', () {
      expect(HoraTimezone.utc.offset, Duration.zero);
      expect(HoraTimezone.utc.name, 'UTC');
      expect(HoraTimezone.utc.isUtc, isTrue);
    });

    test('fromOffset creates timezone', () {
      final tz = HoraTimezone.fromOffset(5);
      expect(tz.offset.inHours, 5);
      expect(tz.name, 'UTC+5');
    });

    test('fromOffset with negative hours', () {
      final tz = HoraTimezone.fromOffset(-8);
      expect(tz.offset.inHours, -8);
      expect(tz.name, 'UTC-8');
    });

    test('fromOffset with minutes', () {
      final tz = HoraTimezone.fromOffset(5, minutes: 30);
      expect(tz.offset.inMinutes, 5 * 60 + 30);
      expect(tz.name, 'UTC+5:30');
    });

    test('fromOffset with zero hours supports signed minutes', () {
      final positive = HoraTimezone.fromOffset(0, minutes: 30);
      final negative = HoraTimezone.fromOffset(0, minutes: -30);
      expect(positive.offset.inMinutes, 30);
      expect(negative.offset.inMinutes, -30);
    });

    test('fromMinutes creates timezone', () {
      final tz = HoraTimezone.fromMinutes(330);
      expect(tz.offset.inMinutes, 330);
    });

    test('parse supports common and offset formats', () {
      expect(HoraTimezone.parse('+05:30').offsetMinutes, 5 * 60 + 30);
      expect(HoraTimezone.parse('-08:00').offsetMinutes, -8 * 60);
      expect(HoraTimezone.parse('-0530').offsetMinutes, -(5 * 60 + 30));
      expect(HoraTimezone.parse('-00:30').offsetMinutes, -30);
      expect(HoraTimezone.parse('+9').offsetMinutes, 9 * 60);
      expect(HoraTimezone.parse('UTC+8').offsetMinutes, 8 * 60);
      expect(HoraTimezone.parse('gmt-05:30').offsetMinutes, -(5 * 60 + 30));
      expect(HoraTimezone.parse('JST').offsetMinutes, 9 * 60);
      expect(HoraTimezone.parse('Z'), HoraTimezone.utc);
    });

    test('tryParse returns null on invalid input', () {
      expect(HoraTimezone.tryParse('invalid'), isNull);
      expect(HoraTimezone.tryParse('+08:00'), isNotNull);
    });

    test('local() uses system local offset for provided instant', () {
      final utcInstant = DateTime.utc(2024);
      final expectedLocal = utcInstant.toLocal();
      final tz = HoraTimezone.local(utcInstant);
      expect(tz.offsetMinutes, expectedLocal.timeZoneOffset.inMinutes);
    });

    test('parse invalid format throws', () {
      expect(() => HoraTimezone.parse('invalid'), throwsFormatException);
      expect(() => HoraTimezone.parse('UTC+24:00'), throwsFormatException);
      expect(() => HoraTimezone.parse('-05:60'), throwsFormatException);
    });

    test('fromOffset rejects mixed signs between hours and minutes', () {
      expect(
        () => HoraTimezone.fromOffset(5, minutes: -30),
        throwsArgumentError,
      );
      expect(
        () => HoraTimezone.fromOffset(-5, minutes: 30),
        throwsArgumentError,
      );
    });

    test('fromMinutes rejects out-of-range values', () {
      expect(() => HoraTimezone.fromMinutes(1440), throwsArgumentError);
      expect(() => HoraTimezone.fromMinutes(-1440), throwsArgumentError);
    });

    test('offsetString formats correctly', () {
      expect(HoraTimezone.fromOffset(5, minutes: 30).offsetString, '+05:30');
      expect(HoraTimezone.fromOffset(-8).offsetString, '-08:00');
      expect(HoraTimezone.utc.offsetString, '+00:00');
    });

    test('parse(offsetString) round-trips sampled offsets', () {
      const hourSamples = [-23, -12, -5, -1, 0, 1, 5, 9, 14, 23];
      const minuteSamples = [0, 15, 30, 45, 59];

      for (final hours in hourSamples) {
        for (final minuteAbs in minuteSamples) {
          final signedMinutes = switch (hours) {
            0 => minuteAbs,
            final h when h < 0 => -minuteAbs,
            _ => minuteAbs,
          };

          final tz = HoraTimezone.fromOffset(hours, minutes: signedMinutes);
          final parsed = HoraTimezone.parse(tz.offsetString);
          expect(
            parsed.offsetMinutes,
            tz.offsetMinutes,
            reason: 'hours=$hours minuteAbs=$minuteAbs',
          );
        }
      }

      // Explicitly verify zero-hour negative minute offsets.
      final negativeThirty = HoraTimezone.fromOffset(0, minutes: -30);
      final parsedNegative = HoraTimezone.parse(negativeThirty.offsetString);
      expect(parsedNegative.offsetMinutes, negativeThirty.offsetMinutes);
    });

    test('fromMinutes -> offsetString -> parse preserves offsets', () {
      for (var minutes = -1439; minutes <= 1439; minutes += 113) {
        final tz = HoraTimezone.fromMinutes(minutes);
        final parsed = HoraTimezone.parse(tz.offsetString);
        expect(
          parsed.offsetMinutes,
          minutes,
          reason: 'minutes=$minutes string=${tz.offsetString}',
        );
      }
    });

    test('common timezones are available', () {
      expect(HoraTimezone.common.containsKey('UTC'), isTrue);
      expect(HoraTimezone.common.containsKey('EST'), isTrue);
      expect(HoraTimezone.common.containsKey('JST'), isTrue);
      expect(HoraTimezone.common['JST']!.offset.inHours, 9);
    });

    test('equality is based on offset', () {
      final tz1 = HoraTimezone.fromOffset(5, name: 'CustomA');
      final tz2 = HoraTimezone.fromOffset(5, name: 'CustomB');
      final tz3 = HoraTimezone.fromOffset(6);

      expect(tz1, equals(tz2));
      expect(tz1, isNot(equals(tz3)));
    });
  });

  group('HoraZoned', () {
    test('constructor normalizes instant to UTC and validates input', () {
      final instant =
          Hora.of(year: 2024, month: 3, day: 15, hour: 12, utc: true);
      final tz = HoraTimezone.fromOffset(9);
      final zoned = HoraZoned(instant, tz);
      expect(zoned.instantUtc.isUtc, isTrue);
      expect(zoned.timezone, equals(tz));

      final invalid = Hora.parse('invalid');
      expect(() => HoraZoned(invalid, tz), throwsArgumentError);
    });

    test('inTimezone preserves instant and projects wall clock', () {
      final utc = Hora.of(year: 2024, month: 3, day: 15, hour: 12, utc: true);
      final jst = HoraTimezone.fromOffset(9);

      final zoned = utc.inTimezone(jst);
      expect(zoned.instantUtc.unixMicros, utc.toUtc().unixMicros);
      expect(zoned.hour, 21);
      expect(zoned.day, 15);
      expect(zoned.timezone, equals(jst));
    });

    test('withTimezone changes projection only', () {
      final instant = Hora.of(
        year: 2024,
        month: 3,
        day: 15,
        hour: 12,
        utc: true,
      );
      final jstView = instant.inTimezone(HoraTimezone.fromOffset(9));
      final estView = jstView.withTimezone(HoraTimezone.fromOffset(-5));

      expect(estView.instantUtc.unixMicros, jstView.instantUtc.unixMicros);
      expect(estView.hour, 7);
    });

    test('format renders target timezone offset for Z/ZZ tokens', () {
      final instant = Hora.of(
        year: 2024,
        month: 3,
        day: 15,
        hour: 12,
        utc: true,
      );
      final jst = instant.inTimezone(HoraTimezone.fromOffset(9));

      expect(jst.format('YYYY-MM-DD HH:mm Z'), '2024-03-15 21:00 +09:00');
      expect(jst.format('YYYY-MM-DD HH:mm ZZ'), '2024-03-15 21:00 +0900');
      expect(jst.toIso8601String(), '2024-03-15T21:00:00.000000+09:00');
    });

    test('toIso8601String preserves microsecond precision', () {
      final instant = Hora.of(
        year: 2024,
        month: 3,
        day: 15,
        hour: 12,
        second: 1,
        millisecond: 123,
        microsecond: 456,
        utc: true,
      );
      final jst = instant.inTimezone(HoraTimezone.fromOffset(9));

      expect(jst.toIso8601String(), '2024-03-15T21:00:01.123456+09:00');
    });

    test('reinterpretAs changes instant but keeps wall clock', () {
      final utcNoon = Hora.of(
        year: 2024,
        month: 3,
        day: 15,
        hour: 12,
        utc: true,
      );

      final projected = utcNoon.inTimezone(HoraTimezone.fromOffset(0));
      final reinterpreted = projected.reinterpretAs(HoraTimezone.fromOffset(9));

      expect(reinterpreted.isUtc, isTrue);
      expect(reinterpreted.year, 2024);
      expect(reinterpreted.month, 3);
      expect(reinterpreted.day, 15);
      expect(reinterpreted.hour, 3);
    });

    test('wallClock keeps microsecond precision', () {
      final utc = Hora.of(
        year: 2024,
        month: 3,
        day: 15,
        hour: 12,
        second: 1,
        millisecond: 123,
        microsecond: 456,
        utc: true,
      );

      final zoned = utc.inTimezone(HoraTimezone.fromOffset(9));
      expect(zoned.second, 1);
      expect(zoned.millisecond, 123);
      expect(zoned.microsecond, 456);
    });
  });

  group('TimezoneExt on Hora', () {
    test('timezone descriptor reflects utc/local mode', () {
      final utc = Hora.of(year: 2024, month: 3, day: 15, utc: true);
      final local = utc.toLocal();

      expect(utc.timezone, equals(HoraTimezone.utc));
      expect(local.timezone.offset, equals(local.utcOffset));
    });

    test('timezoneDifference calculates difference', () {
      final utc = Hora.of(year: 2024, month: 3, day: 15, utc: true);
      final jst = HoraTimezone.fromOffset(9);
      expect(utc.timezoneDifference(jst).inHours, 9);
    });

    test('wallClockIn returns full components', () {
      final utc = Hora.of(year: 2024, month: 3, day: 15, hour: 12, utc: true);
      final clock = utc.wallClockIn(HoraTimezone.fromOffset(9));

      expect(clock.year, 2024);
      expect(clock.month, 3);
      expect(clock.day, 15);
      expect(clock.hour, 21);
      expect(clock.minute, 0);
      expect(clock.second, 0);
    });

    test('reinterpretTimezone reinterprets wall-clock instant', () {
      final utcNoon = Hora.of(
        year: 2024,
        month: 3,
        day: 15,
        hour: 12,
        utc: true,
      );
      final jstReinterpreted = utcNoon.reinterpretTimezone(
        HoraTimezone.fromOffset(9),
      );

      expect(jstReinterpreted.isUtc, isTrue);
      expect(jstReinterpreted.hour, 3);
    });

    test('invalid Hora does not throw for timezone getters', () {
      final invalid = Hora.parse('invalid');
      expect(invalid.isValid, isFalse);
      expect(invalid.utcOffset, Duration.zero);
      expect(invalid.timezoneName, 'Invalid');
      expect(invalid.timezone.offset, Duration.zero);
      expect(invalid.timezone.name, 'Invalid');
      expect(
        invalid.timezoneDifference(HoraTimezone.fromOffset(9)),
        Duration.zero,
      );
    });

    test('reinterpretTimezone keeps invalid Hora unchanged', () {
      final invalid = Hora.parse('invalid');
      final result = invalid.reinterpretTimezone(HoraTimezone.fromOffset(8));
      expect(result.isValid, isFalse);
    });
  });

  group('Helpers and Range', () {
    test('horaNowIn projects current instant to target timezone', () {
      final jstNow = horaNowIn(HoraTimezone.fromOffset(9));
      expect(jstNow.timezone.offset.inHours, 9);
    });

    test('horaFromUtcMilliseconds returns zoned projection', () {
      final zoned = horaFromUtcMilliseconds(
        0,
        timezone: HoraTimezone.fromOffset(8),
      );

      expect(zoned.year, 1970);
      expect(zoned.month, 1);
      expect(zoned.day, 1);
      expect(zoned.hour, 8);
      expect(zoned.instantUtc.unixMillis, 0);
    });

    test('TimezoneRange duration calculates from instants', () {
      final tz = HoraTimezone.utc;
      final range = TimezoneRange(
        start: Hora.of(year: 2024, month: 3, day: 15, hour: 9, utc: true)
            .inTimezone(tz),
        end: Hora.of(year: 2024, month: 3, day: 15, hour: 17, utc: true)
            .inTimezone(tz),
        timezone: tz,
      );

      expect(range.duration.inHours, 8);
    });

    test('TimezoneRange contains checks wall-clock window', () {
      final tz = HoraTimezone.utc;
      final range = TimezoneRange(
        start: Hora.of(year: 2024, month: 3, day: 15, hour: 9, utc: true)
            .inTimezone(tz),
        end: Hora.of(year: 2024, month: 3, day: 15, hour: 17, utc: true)
            .inTimezone(tz),
        timezone: tz,
      );

      expect(
        range.contains(
          Hora.of(year: 2024, month: 3, day: 15, hour: 12, utc: true),
        ),
        isTrue,
      );
      expect(
        range.contains(
          Hora.of(year: 2024, month: 3, day: 15, hour: 8, utc: true),
        ),
        isFalse,
      );
    });

    test('TimezoneRange inTimezone keeps instants and updates projection', () {
      final utc = HoraTimezone.utc;
      final jst = HoraTimezone.fromOffset(9);
      final range = TimezoneRange(
        start: Hora.of(year: 2024, month: 3, day: 15, hour: 9, utc: true)
            .inTimezone(utc),
        end: Hora.of(year: 2024, month: 3, day: 15, hour: 17, utc: true)
            .inTimezone(utc),
        timezone: utc,
      );

      final converted = range.inTimezone(jst);
      expect(converted.timezone, equals(jst));
      expect(converted.start.hour, 18);
      expect(
        converted.start.instantUtc.unixMicros,
        range.start.instantUtc.unixMicros,
      );
    });

    test('TimezoneRange rejects mismatched timezone inputs', () {
      final utc = HoraTimezone.utc;
      final jst = HoraTimezone.fromOffset(9);

      expect(
        () => TimezoneRange(
          start: Hora.of(year: 2024, month: 3, day: 15, hour: 9, utc: true)
              .inTimezone(utc),
          end: Hora.of(year: 2024, month: 3, day: 15, hour: 17, utc: true)
              .inTimezone(jst),
          timezone: utc,
        ),
        throwsArgumentError,
      );
    });

    test('TimezoneRange rejects end before start', () {
      final utc = HoraTimezone.utc;

      expect(
        () => TimezoneRange(
          start: Hora.of(year: 2024, month: 3, day: 15, hour: 17, utc: true)
              .inTimezone(utc),
          end: Hora.of(year: 2024, month: 3, day: 15, hour: 9, utc: true)
              .inTimezone(utc),
          timezone: utc,
        ),
        throwsArgumentError,
      );
    });

    test('TimezoneRange contains returns false for invalid Hora', () {
      final utc = HoraTimezone.utc;
      final range = TimezoneRange(
        start: Hora.of(year: 2024, month: 3, day: 15, hour: 9, utc: true)
            .inTimezone(utc),
        end: Hora.of(year: 2024, month: 3, day: 15, hour: 17, utc: true)
            .inTimezone(utc),
        timezone: utc,
      );

      expect(range.contains(Hora.parse('invalid')), isFalse);
    });
  });
}
