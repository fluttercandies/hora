import 'package:hora/hora.dart';
import 'package:hora/src/plugins/timezone.dart';
import 'package:test/test.dart';

void main() {
  group('HoraTimezone', () {
    test('utc has zero offset', () {
      expect(HoraTimezone.utc.offset, Duration.zero);
      expect(HoraTimezone.utc.name, 'UTC');
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
      final tz = HoraTimezone.fromOffset(5, 30);
      expect(tz.offset.inMinutes, 5 * 60 + 30);
      expect(tz.name, 'UTC+5:30');
    });

    test('fromMinutes creates timezone', () {
      final tz = HoraTimezone.fromMinutes(330); // 5:30
      expect(tz.offset.inMinutes, 330);
    });

    test('parse valid format', () {
      expect(HoraTimezone.parse('+05:30').offsetMinutes, 5 * 60 + 30);
      expect(HoraTimezone.parse('-08:00').offsetMinutes, -8 * 60);
      expect(HoraTimezone.parse('+9').offsetMinutes, 9 * 60);
    });

    test('parse invalid format throws', () {
      expect(() => HoraTimezone.parse('invalid'), throwsFormatException);
    });

    test('offsetString formats correctly', () {
      expect(HoraTimezone.fromOffset(5, 30).offsetString, '+05:30');
      expect(HoraTimezone.fromOffset(-8).offsetString, '-08:00');
      expect(HoraTimezone.utc.offsetString, '+00:00');
    });

    test('common timezones are available', () {
      expect(HoraTimezone.common.containsKey('UTC'), isTrue);
      expect(HoraTimezone.common.containsKey('EST'), isTrue);
      expect(HoraTimezone.common.containsKey('JST'), isTrue);
      expect(HoraTimezone.common['JST']!.offset.inHours, 9);
    });

    test('equality', () {
      final tz1 = HoraTimezone.fromOffset(5);
      final tz2 = HoraTimezone.fromOffset(5);
      final tz3 = HoraTimezone.fromOffset(6);

      expect(tz1, equals(tz2));
      expect(tz1, isNot(equals(tz3)));
    });
  });

  group('TimezoneExt', () {
    test('toUtc converts to UTC', () {
      final local = Hora.now();
      final utc = local.toUtc();
      expect(utc.isUtc, isTrue);
    });

    test('toLocal converts to local time', () {
      final utc = Hora.of(year: 2024, month: 3, day: 15, utc: true);
      final local = utc.toLocal();
      expect(local.isUtc, isFalse);
    });

    test('inTimezone converts to target timezone', () {
      // Create a UTC time
      final utc = Hora.of(year: 2024, month: 3, day: 15, hour: 12, utc: true);
      final jst = HoraTimezone.fromOffset(9);

      final converted = utc.inTimezone(jst);
      expect(converted.hour, 21); // 12 + 9 = 21
    });

    test('utcOffset returns offset', () {
      final utc = Hora.of(year: 2024, month: 3, day: 15, utc: true);
      expect(utc.utcOffset, Duration.zero);
    });

    test('timezoneName returns name', () {
      final utc = Hora.of(year: 2024, month: 3, day: 15, utc: true);
      expect(utc.timezoneName, 'UTC');
    });

    test('offsetString formats correctly', () {
      final utc = Hora.of(year: 2024, month: 3, day: 15, utc: true);
      expect(utc.offsetString, '+00:00');
    });

    test('isSameTimezone compares timezones', () {
      final h1 = Hora.of(year: 2024, month: 3, day: 15, utc: true);
      final h2 = Hora.of(year: 2024, month: 3, day: 16, utc: true);
      expect(h1.isSameTimezone(h2), isTrue);
    });

    test('timezoneDifference calculates difference', () {
      final utc = Hora.of(year: 2024, month: 3, day: 15, utc: true);
      final jst = HoraTimezone.fromOffset(9);
      expect(utc.timezoneDifference(jst).inHours, 9);
    });

    test('wallClockIn returns time components', () {
      final utc = Hora.of(year: 2024, month: 3, day: 15, hour: 12, utc: true);
      final jst = HoraTimezone.fromOffset(9);

      final clock = utc.wallClockIn(jst);
      expect(clock.hour, 21);
      expect(clock.minute, 0);
    });
  });

  group('TimezoneRange', () {
    test('duration calculates correctly', () {
      final tz = HoraTimezone.utc;
      final range = TimezoneRange(
        start: Hora.of(year: 2024, month: 3, day: 15, hour: 9, utc: true),
        end: Hora.of(year: 2024, month: 3, day: 15, hour: 17, utc: true),
        timezone: tz,
      );

      expect(range.duration.inHours, 8);
    });

    test('contains checks if time is in range', () {
      final tz = HoraTimezone.utc;
      final range = TimezoneRange(
        start: Hora.of(year: 2024, month: 3, day: 15, hour: 9, utc: true),
        end: Hora.of(year: 2024, month: 3, day: 15, hour: 17, utc: true),
        timezone: tz,
      );

      expect(range.contains(Hora.of(year: 2024, month: 3, day: 15, hour: 12, utc: true)), isTrue);
      expect(range.contains(Hora.of(year: 2024, month: 3, day: 15, hour: 8, utc: true)), isFalse);
    });

    test('inTimezone converts range', () {
      final utc = HoraTimezone.utc;
      final jst = HoraTimezone.fromOffset(9);
      
      final range = TimezoneRange(
        start: Hora.of(year: 2024, month: 3, day: 15, hour: 9, utc: true),
        end: Hora.of(year: 2024, month: 3, day: 15, hour: 17, utc: true),
        timezone: utc,
      );

      final converted = range.inTimezone(jst);
      expect(converted.timezone, equals(jst));
      expect(converted.start.hour, 18); // 9 + 9
    });
  });
}
