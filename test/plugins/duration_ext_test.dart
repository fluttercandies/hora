import 'package:hora/hora.dart';
import 'package:hora/src/plugins/duration_ext.dart';
import 'package:test/test.dart';

void main() {
  group('HoraDurationExtUtils', () {
    group('format', () {
      test('formats HH:mm:ss', () {
        final d = HoraDuration(hours: 2, minutes: 30, seconds: 45);
        expect(d.format('HH:mm:ss'), '02:30:45');
      });

      test('formats with day and hour tokens', () {
        final d = HoraDuration(days: 3, hours: 5);
        // format replaces tokens D and H (but note: s in 'days' will be replaced by seconds value)
        expect(d.format('D-H'), '3-5');
      });
    });

    group('humanize', () {
      test('humanizes seconds', () {
        expect(HoraDuration(seconds: 30).humanize(), contains('second'));
      });

      test('humanizes minutes', () {
        expect(HoraDuration(minutes: 5).humanize(), contains('minute'));
      });

      test('humanizes hours', () {
        expect(HoraDuration(hours: 3).humanize(), contains('hour'));
      });

      test('humanizes days', () {
        expect(HoraDuration(days: 7).humanize(), contains('day'));
      });

      test('humanizes zero duration', () {
        // Core humanize() returns 'a few seconds' for zero duration
        expect(HoraDuration().humanize(), isNotEmpty);
      });
    });

    group('toIso8601 (from HoraDuration)', () {
      test('formats as ISO 8601 duration', () {
        final d = HoraDuration(days: 1, hours: 2, minutes: 30, seconds: 45);
        final iso = d.toIso8601();
        expect(iso, startsWith('P'));
        expect(iso, contains('T'));
      });

      test('formats zero duration', () {
        final d = HoraDuration();
        expect(d.toIso8601(), 'PT0S');
      });
    });

    group('totalHours', () {
      test('calculates total hours', () {
        final d = HoraDuration(days: 1, hours: 12);
        expect(d.totalHours, closeTo(36, 0.1));
      });
    });

    group('totalMinutes', () {
      test('calculates total minutes', () {
        final d = HoraDuration(hours: 2, minutes: 30);
        expect(d.totalMinutes, closeTo(150, 0.1));
      });
    });

    group('operators', () {
      test('adds durations', () {
        final d1 = HoraDuration(hours: 1);
        final d2 = HoraDuration(hours: 2);
        final result = d1 + d2;
        expect(result.hours, 3);
      });

      test('subtracts durations', () {
        final d1 = HoraDuration(hours: 3);
        final d2 = HoraDuration(hours: 1);
        final result = d1 - d2;
        expect(result.hours, 2);
      });

      test('multiplies duration', () {
        final d = HoraDuration(hours: 2);
        final result = d * 3;
        expect(result.hours, 6);
      });
    });
  });

  group('HoraDurationFactoryExt', () {
    test('parse ISO 8601', () {
      final d = HoraDurationFactoryExt.parse('PT1H30M');
      expect(d.hours, 1);
      expect(d.minutes, 30);
    });

    test('parse with days', () {
      final d = HoraDurationFactoryExt.parse('P1DT2H');
      expect(d.days, 1);
      expect(d.hours, 2);
    });

    test('tryParse returns null for invalid', () {
      expect(HoraDurationFactoryExt.tryParse('invalid'), isNull);
    });

    test('fromHours', () {
      final d = HoraDurationFactoryExt.fromHours(2.5);
      expect(d.totalHours, closeTo(2.5, 0.01));
    });

    test('fromMinutes', () {
      final d = HoraDurationFactoryExt.fromMinutes(90);
      expect(d.totalMinutes, closeTo(90, 0.1));
    });
  });

  group('HoraDurationOpExt', () {
    test('addHoraDuration to Hora', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      final d = HoraDuration(days: 5);
      final result = h.addHoraDuration(d);
      expect(result.day, 20);
    });

    test('subtractHoraDuration from Hora', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      final d = HoraDuration(days: 5);
      final result = h.subtractHoraDuration(d);
      expect(result.day, 10);
    });

    test('horaDurationTo', () {
      final h1 = Hora.of(year: 2024, month: 3, day: 15);
      final h2 = Hora.of(year: 2024, month: 3, day: 20);
      final d = h1.horaDurationTo(h2);
      expect(d.totalDays, closeTo(5, 0.1));
    });
  });

  group('DurationToHora extension (from core)', () {
    test('toHoraDuration', () {
      // This extension is defined in extensions.dart
      final dartDuration = Duration(hours: 2, minutes: 30);
      final horaDuration = dartDuration.toHoraDuration();
      expect(horaDuration.totalMinutes, closeTo(150, 0.1));
    });
  });
}
