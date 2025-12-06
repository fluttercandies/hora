import 'package:hora/hora.dart';
import 'package:hora/src/plugins/advanced_format.dart';
import 'package:test/test.dart';

void main() {
  group('AdvancedFormatExt', () {
    group('advancedFormat', () {
      test('formats ordinal day (Do)', () {
        expect(Hora.of(year: 2024, month: 3).advancedFormat('Do'), '1st');
        expect(
          Hora.of(year: 2024, month: 3, day: 2).advancedFormat('Do'),
          '2nd',
        );
        expect(
          Hora.of(year: 2024, month: 3, day: 3).advancedFormat('Do'),
          '3rd',
        );
        expect(
          Hora.of(year: 2024, month: 3, day: 4).advancedFormat('Do'),
          '4th',
        );
        expect(
          Hora.of(year: 2024, month: 3, day: 11).advancedFormat('Do'),
          '11th',
        );
        expect(
          Hora.of(year: 2024, month: 3, day: 21).advancedFormat('Do'),
          '21st',
        );
      });

      test('formats quarter (Q)', () {
        expect(Hora.of(year: 2024).advancedFormat('Q'), '1');
        expect(Hora.of(year: 2024, month: 4).advancedFormat('Q'), '2');
        expect(Hora.of(year: 2024, month: 7).advancedFormat('Q'), '3');
        expect(Hora.of(year: 2024, month: 10).advancedFormat('Q'), '4');
      });

      test('formats unix timestamp (X, x)', () {
        final h = Hora.of(year: 2024, month: 3, day: 15, hour: 12);
        expect(h.advancedFormat('X'), h.unix.toString());
        expect(h.advancedFormat('x'), h.unixMillis.toString());
      });

      test('formats day of year (DDD)', () {
        // DDD returns day of year without padding
        expect(Hora.of(year: 2024).advancedFormat('DDD'), '1');
        expect(Hora.of(year: 2024, month: 2).advancedFormat('DDD'), '32');
      });

      test('formats hour 1-24 (k, kk)', () {
        final midnight = Hora.of(year: 2024, month: 3, day: 15);
        final noon = Hora.of(year: 2024, month: 3, day: 15, hour: 12);

        expect(midnight.advancedFormat('k'), '24');
        expect(noon.advancedFormat('k'), '12');
        expect(midnight.advancedFormat('kk'), '24');
      });

      test('preserves text in brackets', () {
        final h = Hora.of(year: 2024, month: 3, day: 15);
        expect(h.advancedFormat('[Date:] YYYY-MM-DD'), 'Date: 2024-03-15');
      });
    });

    group('quarter getter', () {
      test('returns correct quarter', () {
        expect(Hora.of(year: 2024).quarter, 1);
        expect(Hora.of(year: 2024, month: 3).quarter, 1);
        expect(Hora.of(year: 2024, month: 4).quarter, 2);
        expect(Hora.of(year: 2024, month: 6).quarter, 2);
        expect(Hora.of(year: 2024, month: 7).quarter, 3);
        expect(Hora.of(year: 2024, month: 9).quarter, 3);
        expect(Hora.of(year: 2024, month: 10).quarter, 4);
        expect(Hora.of(year: 2024, month: 12).quarter, 4);
      });
    });

    group('dayOfYear getter', () {
      test('returns correct day of year', () {
        expect(Hora.of(year: 2024).dayOfYear, 1);
        expect(Hora.of(year: 2024, day: 31).dayOfYear, 31);
        expect(Hora.of(year: 2024, month: 2).dayOfYear, 32);
        expect(
          Hora.of(year: 2024, month: 12, day: 31).dayOfYear,
          366,
        ); // leap year
        expect(
          Hora.of(year: 2023, month: 12, day: 31).dayOfYear,
          365,
        ); // non-leap
      });
    });
  });
}
