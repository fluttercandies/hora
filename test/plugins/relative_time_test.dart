import 'package:hora/hora.dart';
import 'package:hora/src/plugins/relative_time.dart';
import 'package:test/test.dart';

void main() {
  group('RelativeTimePluginExt', () {
    group('relativeFromNow', () {
      test('formats seconds ago', () {
        final past = Hora.now().subtract(30, TemporalUnit.second);
        expect(past.relativeFromNow(), contains('second'));
      });

      test('respects second-to-minute threshold boundary', () {
        final sec44 = Hora.now().subtract(44, TemporalUnit.second);
        final sec45 = Hora.now().subtract(45, TemporalUnit.second);
        expect(sec44.relativeFromNow(), contains('second'));
        expect(sec45.relativeFromNow(), contains('minute'));
      });

      test('formats minutes ago', () {
        final past = Hora.now().subtract(5, TemporalUnit.minute);
        expect(past.relativeFromNow(), contains('minute'));
      });

      test('respects minute-to-hour threshold boundary', () {
        final min44 = Hora.now().subtract(44, TemporalUnit.minute);
        final min45 = Hora.now().subtract(45, TemporalUnit.minute);
        expect(min44.relativeFromNow(), contains('minute'));
        expect(min45.relativeFromNow(), contains('hour'));
      });

      test('formats hours ago', () {
        final past = Hora.now().subtract(3, TemporalUnit.hour);
        expect(past.relativeFromNow(), contains('hour'));
      });

      test('formats days ago', () {
        final past = Hora.now().subtract(2, TemporalUnit.day);
        expect(past.relativeFromNow(), contains('day'));
      });

      test('formats future dates', () {
        final future = Hora.now().add(5, TemporalUnit.minute);
        expect(future.relativeFromNow(), contains('in'));
      });
    });

    group('relativeFrom', () {
      test('calculates relative time between dates', () {
        final h1 = Hora.of(year: 2024);
        final h2 = Hora.of(year: 2024, day: 3);

        expect(h1.relativeFrom(h2), contains('day'));
        expect(h1.relativeFrom(h2), contains('ago'));
      });

      test('with withoutSuffix config', () {
        final h1 = Hora.of(year: 2024);
        final h2 = Hora.of(year: 2024, day: 3);

        final config = RelativeTimeConfig(withoutSuffix: true);
        final result = h1.relativeFrom(h2, config: config);

        expect(result, isNot(contains('ago')));
        expect(result, isNot(contains('in')));
      });
    });

    group('relativeToNow', () {
      test('returns relative time to now', () {
        final past = Hora.now().subtract(5, TemporalUnit.minute);
        final result = past.relativeToNow();
        expect(result, contains('minute'));
      });
    });

    group('relativeTo', () {
      test('formats relation to another date', () {
        final base = Hora.of(year: 2024, month: 3);
        final future = Hora.of(year: 2024, month: 3, day: 3);
        final result = base.relativeTo(future);
        expect(result, contains('day'));
        expect(result, contains('in'));
      });
    });

    group('relativeFromNowShort', () {
      test('formats short seconds', () {
        final past = Hora.now().subtract(30, TemporalUnit.second);
        expect(past.relativeFromNowShort(), matches(RegExp(r'-\d+s')));
      });

      test('formats short minutes', () {
        final past = Hora.now().subtract(5, TemporalUnit.minute);
        expect(past.relativeFromNowShort(), matches(RegExp(r'-\d+m')));
      });

      test('formats short hours', () {
        final past = Hora.now().subtract(3, TemporalUnit.hour);
        expect(past.relativeFromNowShort(), matches(RegExp(r'-\d+h')));
      });

      test('formats short days', () {
        final past = Hora.now().subtract(5, TemporalUnit.day);
        expect(past.relativeFromNowShort(), matches(RegExp(r'-\d+d')));
      });

      test('formats future with +', () {
        final future = Hora.now().add(5, TemporalUnit.minute);
        expect(future.relativeFromNowShort(), startsWith('+'));
      });
    });
  });

  group('diffFromDetailed', () {
    test('diffFromNowDetailed returns detailed diff from now', () {
      final past = Hora.now().subtract(2, TemporalUnit.hour);
      final diff = past.diffFromNowDetailed();
      expect(diff.totalHours, greaterThanOrEqualTo(2));
    });

    test('returns detailed breakdown', () {
      final h1 = Hora.of(year: 2024);
      final h2 = Hora.of(year: 2024, day: 3, hour: 5);

      final diff = h1.diffFromDetailed(h2);
      expect(diff.days, 2);
      expect(diff.hours, 5);
    });

    test('format returns human readable string', () {
      final h1 = Hora.of(year: 2024);
      final h2 = Hora.of(year: 2024, day: 3);

      final diff = h1.diffFromDetailed(h2);
      expect(diff.format(), contains('day'));
    });

    test('formatCompact returns short string', () {
      final h1 = Hora.of(year: 2024);
      final h2 = Hora.of(year: 2024, day: 3, hour: 5);

      final diff = h1.diffFromDetailed(h2);
      expect(diff.formatCompact(), contains('d'));
      expect(diff.formatCompact(), contains('h'));
    });
  });

  group('RelativeTimeThresholds', () {
    test('default thresholds', () {
      const t = RelativeTimeThresholds();
      expect(t.seconds, 44);
      expect(t.minutes, 44);
      expect(t.hours, 21);
    });

    test('strict thresholds', () {
      const t = RelativeTimeThresholds.strict;
      expect(t.seconds, 59);
      expect(t.minutes, 59);
      expect(t.hours, 23);
    });
  });

  group('RelativeTimeDiff', () {
    test('totalDays calculates correctly', () {
      const diff = RelativeTimeDiff(
        years: 1,
        months: 1,
        days: 5,
        hours: 0,
        minutes: 0,
        seconds: 0,
        isFuture: false,
      );
      expect(diff.totalDays, 365 + 30 + 5);
    });

    test('totalHours calculates correctly', () {
      const diff = RelativeTimeDiff(
        years: 0,
        months: 0,
        days: 2,
        hours: 5,
        minutes: 0,
        seconds: 0,
        isFuture: false,
      );
      expect(diff.totalHours, 2 * 24 + 5);
    });
  });
}
