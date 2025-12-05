import 'package:hora/hora.dart';
import 'package:test/test.dart';

void main() {
  group('TemporalUnit', () {
    test('parse full names', () {
      expect(TemporalUnit.parse('year'), TemporalUnit.year);
      expect(TemporalUnit.parse('month'), TemporalUnit.month);
      expect(TemporalUnit.parse('week'), TemporalUnit.week);
      expect(TemporalUnit.parse('day'), TemporalUnit.day);
      expect(TemporalUnit.parse('hour'), TemporalUnit.hour);
      expect(TemporalUnit.parse('minute'), TemporalUnit.minute);
      expect(TemporalUnit.parse('second'), TemporalUnit.second);
      expect(TemporalUnit.parse('millisecond'), TemporalUnit.millisecond);
      expect(TemporalUnit.parse('microsecond'), TemporalUnit.microsecond);
    });

    test('parse plural names', () {
      expect(TemporalUnit.parse('years'), TemporalUnit.year);
      expect(TemporalUnit.parse('months'), TemporalUnit.month);
      expect(TemporalUnit.parse('days'), TemporalUnit.day);
    });

    test('parse symbols', () {
      expect(TemporalUnit.parse('y'), TemporalUnit.year);
      expect(TemporalUnit.parse('M'), TemporalUnit.month);
      expect(TemporalUnit.parse('Q'), TemporalUnit.quarter);
      expect(TemporalUnit.parse('w'), TemporalUnit.week);
      expect(TemporalUnit.parse('d'), TemporalUnit.day);
      expect(TemporalUnit.parse('h'), TemporalUnit.hour);
      expect(TemporalUnit.parse('m'), TemporalUnit.minute);
      expect(TemporalUnit.parse('s'), TemporalUnit.second);
      expect(TemporalUnit.parse('ms'), TemporalUnit.millisecond);
    });

    test('tryParse returns null for invalid', () {
      expect(TemporalUnit.tryParse('invalid'), isNull);
    });

    test('parse throws for invalid', () {
      expect(() => TemporalUnit.parse('invalid'), throwsFormatException);
    });

    test('isFixed property', () {
      expect(TemporalUnit.day.isFixed, isTrue);
      expect(TemporalUnit.hour.isFixed, isTrue);
      expect(TemporalUnit.month.isFixed, isFalse);
      expect(TemporalUnit.year.isFixed, isFalse);
    });

    test('isCalendarBased property', () {
      expect(TemporalUnit.day.isCalendarBased, isFalse);
      expect(TemporalUnit.month.isCalendarBased, isTrue);
      expect(TemporalUnit.year.isCalendarBased, isTrue);
      expect(TemporalUnit.quarter.isCalendarBased, isTrue);
    });

    test('name property', () {
      expect(TemporalUnit.year.name, 'year');
      expect(TemporalUnit.month.name, 'month');
      expect(TemporalUnit.day.name, 'day');
    });

    test('symbol property', () {
      expect(TemporalUnit.year.symbol, 'y');
      expect(TemporalUnit.month.symbol, 'M');
      expect(TemporalUnit.day.symbol, 'd');
    });

    test('plural property', () {
      expect(TemporalUnit.year.plural, 'years');
      expect(TemporalUnit.month.plural, 'months');
    });

    test('duration for fixed units', () {
      expect(TemporalUnit.day.duration, const Duration(days: 1));
      expect(TemporalUnit.hour.duration, const Duration(hours: 1));
      expect(TemporalUnit.minute.duration, const Duration(minutes: 1));
      expect(TemporalUnit.second.duration, const Duration(seconds: 1));
    });

    test('duration throws for calendar units', () {
      expect(
        () => TemporalUnit.month.duration,
        throwsUnsupportedError,
      );
      expect(
        () => TemporalUnit.year.duration,
        throwsUnsupportedError,
      );
    });

    test('values list', () {
      expect(TemporalUnit.values, hasLength(10));
      expect(TemporalUnit.values.first, TemporalUnit.microsecond);
      expect(TemporalUnit.values.last, TemporalUnit.year);
    });
  });
}
