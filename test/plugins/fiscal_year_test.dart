import 'package:hora/hora.dart';
import 'package:hora/src/plugins/fiscal_year.dart';
import 'package:test/test.dart';

void main() {
  group('FiscalYearExt', () {
    group('with default config (January start)', () {
      test('fiscalYear matches calendar year', () {
        expect(Hora.of(year: 2024, month: 3).fiscalYear(), 2025);
        expect(Hora.of(year: 2024, month: 12).fiscalYear(), 2025);
      });

      test('fiscalQuarter matches calendar quarter', () {
        expect(Hora.of(year: 2024).fiscalQuarter(), 1);
        expect(Hora.of(year: 2024, month: 4).fiscalQuarter(), 2);
        expect(Hora.of(year: 2024, month: 7).fiscalQuarter(), 3);
        expect(Hora.of(year: 2024, month: 10).fiscalQuarter(), 4);
      });
    });

    group('with April start (common in some countries)', () {
      test('fiscalYear depends on month', () {
        // January-March: still in previous fiscal year
        expect(Hora.of(year: 2024).fiscalYear(startMonth: 4), 2024);
        expect(Hora.of(year: 2024, month: 3).fiscalYear(startMonth: 4), 2024);
        // April onward: current fiscal year
        expect(Hora.of(year: 2024, month: 4).fiscalYear(startMonth: 4), 2025);
        expect(Hora.of(year: 2024, month: 12).fiscalYear(startMonth: 4), 2025);
      });

      test('fiscalQuarter with April start', () {
        expect(Hora.of(year: 2024, month: 4).fiscalQuarter(startMonth: 4), 1);
        expect(Hora.of(year: 2024, month: 7).fiscalQuarter(startMonth: 4), 2);
        expect(Hora.of(year: 2024, month: 10).fiscalQuarter(startMonth: 4), 3);
        expect(Hora.of(year: 2024).fiscalQuarter(startMonth: 4), 4);
      });
    });

    group('with July start (Australia)', () {
      test('fiscalYear', () {
        expect(Hora.of(year: 2024, month: 6).fiscalYear(startMonth: 7), 2024);
        expect(Hora.of(year: 2024, month: 7).fiscalYear(startMonth: 7), 2025);
      });
    });

    group('with October start (US Federal)', () {
      test('fiscalYear', () {
        expect(Hora.of(year: 2024, month: 9).fiscalYear(startMonth: 10), 2024);
        expect(Hora.of(year: 2024, month: 10).fiscalYear(startMonth: 10), 2025);
      });
    });
  });

  group('FiscalYearRangeExt', () {
    test('startOfFiscalYear with default config', () {
      final h = Hora.of(year: 2024, month: 6, day: 15);
      final start = h.startOfFiscalYear();

      expect(start.year, 2024);
      expect(start.month, 1);
      expect(start.day, 1);
    });

    test('endOfFiscalYear with default config', () {
      final h = Hora.of(year: 2024, month: 6, day: 15);
      final end = h.endOfFiscalYear();

      expect(end.year, 2024);
      expect(end.month, 12);
      expect(end.day, 31);
    });

    test('startOfFiscalYear with April config', () {
      final h1 = Hora.of(year: 2024, month: 2);
      expect(h1.startOfFiscalYear(startMonth: 4).year, 2023);
      expect(h1.startOfFiscalYear(startMonth: 4).month, 4);

      final h2 = Hora.of(year: 2024, month: 5);
      expect(h2.startOfFiscalYear(startMonth: 4).year, 2024);
      expect(h2.startOfFiscalYear(startMonth: 4).month, 4);
    });

    test('startOfFiscalQuarter', () {
      final h = Hora.of(year: 2024, month: 5, day: 15);
      final start = h.startOfFiscalQuarter();

      expect(start.month, 4);
      expect(start.day, 1);
    });

    test('endOfFiscalQuarter', () {
      final h = Hora.of(year: 2024, month: 5, day: 15);
      final end = h.endOfFiscalQuarter();

      expect(end.month, 6);
      expect(end.day, 30);
    });
  });

  group('FiscalYearConfig', () {
    test('default config starts in January', () {
      const config = FiscalYearConfig();
      expect(config.startMonth, 1);
    });

    test('presets', () {
      expect(FiscalYearConfig.usGovernment.startMonth, 10);
      expect(FiscalYearConfig.japan.startMonth, 4);
      expect(FiscalYearConfig.australia.startMonth, 7);
    });
  });

  group('FiscalPeriod', () {
    test('displayString', () {
      final h = Hora.of(year: 2024, month: 5);
      final period = h.fiscalPeriod();
      expect(period.displayString, startsWith('FY'));
    });
  });
}
