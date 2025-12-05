import 'package:hora/hora.dart';
import 'package:hora/src/plugins/min_max.dart';
import 'package:test/test.dart';

void main() {
  group('HoraMinMax', () {
    final h1 = Hora.of(year: 2024);
    final h2 = Hora.of(year: 2024, month: 6, day: 15);
    final h3 = Hora.of(year: 2024, month: 12, day: 31);

    group('min2 and max2', () {
      test('min2 returns earlier date', () {
        expect(HoraMinMax.min2(h1, h2), equals(h1));
        expect(HoraMinMax.min2(h2, h1), equals(h1));
      });

      test('max2 returns later date', () {
        expect(HoraMinMax.max2(h1, h2), equals(h2));
        expect(HoraMinMax.max2(h2, h1), equals(h2));
      });
    });

    group('min and max from list', () {
      test('min finds earliest', () {
        expect(HoraMinMax.min([h2, h1, h3]), equals(h1));
      });

      test('max finds latest', () {
        expect(HoraMinMax.max([h2, h1, h3]), equals(h3));
      });

      test('min throws on empty list', () {
        expect(() => HoraMinMax.min([]), throwsStateError);
      });

      test('max throws on empty list', () {
        expect(() => HoraMinMax.max([]), throwsStateError);
      });
    });

    group('minOrNull and maxOrNull', () {
      test('minOrNull returns null for empty list', () {
        expect(HoraMinMax.minOrNull([]), isNull);
      });

      test('maxOrNull returns null for empty list', () {
        expect(HoraMinMax.maxOrNull([]), isNull);
      });

      test('minOrNull finds min for non-empty list', () {
        expect(HoraMinMax.minOrNull([h2, h1, h3]), equals(h1));
      });
    });

    group('minMax', () {
      test('returns both min and max', () {
        final result = HoraMinMax.minMax([h2, h1, h3]);
        expect(result.min, equals(h1));
        expect(result.max, equals(h3));
      });

      test('throws on empty list', () {
        expect(() => HoraMinMax.minMax([]), throwsStateError);
      });

      test('span returns duration between min and max', () {
        final result = HoraMinMax.minMax([h1, h3]);
        expect(result.span.inDays, 365); // 2024 is leap year
      });
    });

    group('clamp', () {
      test('clamps to min when below', () {
        final before = Hora.of(year: 2023);
        expect(HoraMinMax.clamp(before, h1, h3), equals(h1));
      });

      test('clamps to max when above', () {
        final after = Hora.of(year: 2025);
        expect(HoraMinMax.clamp(after, h1, h3), equals(h3));
      });

      test('returns same when within range', () {
        expect(HoraMinMax.clamp(h2, h1, h3), equals(h2));
      });
    });
  });

  group('MinMaxExt', () {
    final h1 = Hora.of(year: 2024);
    final h2 = Hora.of(year: 2024, month: 6, day: 15);
    final h3 = Hora.of(year: 2024, month: 12, day: 31);

    test('min returns earlier', () {
      expect(h2.min(h1), equals(h1));
    });

    test('max returns later', () {
      expect(h1.max(h2), equals(h2));
    });

    test('clampBetween', () {
      final before = Hora.of(year: 2023);
      expect(before.clampBetween(h1, h3), equals(h1));
    });

    test('atLeast', () {
      final before = Hora.of(year: 2023);
      expect(before.atLeast(h1), equals(h1));
      expect(h2.atLeast(h1), equals(h2));
    });

    test('atMost', () {
      final after = Hora.of(year: 2025);
      expect(after.atMost(h3), equals(h3));
      expect(h2.atMost(h3), equals(h2));
    });

    test('isWithin', () {
      expect(h2.isWithin(h1, h3), isTrue);
      expect(h1.isWithin(h1, h3), isTrue); // inclusive
      expect(h3.isWithin(h1, h3), isTrue); // inclusive
    });

    test('isStrictlyWithin', () {
      expect(h2.isStrictlyWithin(h1, h3), isTrue);
      expect(h1.isStrictlyWithin(h1, h3), isFalse); // exclusive
      expect(h3.isStrictlyWithin(h1, h3), isFalse); // exclusive
    });
  });

  group('HoraIterableMinMaxExt', () {
    final dates = [
      Hora.of(year: 2024, month: 6, day: 15),
      Hora.of(year: 2024),
      Hora.of(year: 2024, month: 12, day: 31),
    ];

    test('minHora', () {
      expect(dates.minHora.month, 1);
    });

    test('maxHora', () {
      expect(dates.maxHora.month, 12);
    });

    test('minHoraOrNull', () {
      expect(<Hora>[].minHoraOrNull, isNull);
      expect(dates.minHoraOrNull?.month, 1);
    });

    test('minMaxHora', () {
      final result = dates.minMaxHora;
      expect(result.min.month, 1);
      expect(result.max.month, 12);
    });

    test('sortedChronologically', () {
      final sorted = dates.sortedChronologically;
      expect(sorted.first.month, 1);
      expect(sorted.last.month, 12);
    });

    test('sortedReverseChronologically', () {
      final sorted = dates.sortedReverseChronologically;
      expect(sorted.first.month, 12);
      expect(sorted.last.month, 1);
    });

    test('withinRange', () {
      final start = Hora.of(year: 2024, month: 3);
      final end = Hora.of(year: 2024, month: 9, day: 30);
      final filtered = dates.withinRange(start, end).toList();
      expect(filtered.length, 1);
      expect(filtered.first.month, 6);
    });

    test('span', () {
      expect(dates.span.inDays, 365);
    });

    test('medianHora', () {
      final median = dates.medianHora;
      expect(median, isNotNull);
    });

    test('groupByMonth', () {
      final grouped = dates.groupByMonth();
      expect(grouped.keys.length, 3);
      expect(grouped.containsKey('2024-01'), isTrue);
      expect(grouped.containsKey('2024-06'), isTrue);
      expect(grouped.containsKey('2024-12'), isTrue);
    });

    test('groupByYear', () {
      final allDates = [
        ...dates,
        Hora.of(year: 2023, month: 6),
      ];
      final grouped = allDates.groupByYear();
      expect(grouped.keys.length, 2);
      expect(grouped[2024]?.length, 3);
      expect(grouped[2023]?.length, 1);
    });
  });

  group('HoraListMinMaxExt', () {
    test('sortChronologically in place', () {
      final list = [
        Hora.of(year: 2024, month: 12, day: 31),
        Hora.of(year: 2024),
        Hora.of(year: 2024, month: 6, day: 15),
      ]..sortChronologically();
      expect(list.first.month, 1);
      expect(list.last.month, 12);
    });

    test('sortReverseChronologically in place', () {
      final list = [
        Hora.of(year: 2024),
        Hora.of(year: 2024, month: 12, day: 31),
        Hora.of(year: 2024, month: 6, day: 15),
      ]..sortReverseChronologically();
      expect(list.first.month, 12);
      expect(list.last.month, 1);
    });
  });
}
