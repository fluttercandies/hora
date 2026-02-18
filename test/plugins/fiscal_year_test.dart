import 'package:hora/hora.dart';
import 'package:hora/src/plugins/fiscal_year.dart';
import 'package:test/test.dart';

void main() {
  group('FiscalYearExt', () {
    group('with default config (January start)', () {
      test('fiscalYear matches calendar year', () {
        expect(Hora.of(year: 2024, month: 3).fiscalYear(), 2024);
        expect(Hora.of(year: 2024, month: 12).fiscalYear(), 2024);
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
        expect(Hora.of(year: 2024).fiscalYear(startMonth: 4), 2023);
        expect(Hora.of(year: 2024, month: 3).fiscalYear(startMonth: 4), 2023);
        // April onward: current fiscal year
        expect(Hora.of(year: 2024, month: 4).fiscalYear(startMonth: 4), 2024);
        expect(Hora.of(year: 2024, month: 12).fiscalYear(startMonth: 4), 2024);
      });

      test('fiscalQuarter with April start', () {
        expect(Hora.of(year: 2024, month: 4).fiscalQuarter(startMonth: 4), 1);
        expect(Hora.of(year: 2024, month: 7).fiscalQuarter(startMonth: 4), 2);
        expect(Hora.of(year: 2024, month: 10).fiscalQuarter(startMonth: 4), 3);
        expect(Hora.of(year: 2024).fiscalQuarter(startMonth: 4), 4);
      });

      test('fiscalQuarterWithConfig respects fiscal boundary day', () {
        const ukTax = FiscalYearConfig.ukTax; // April 6
        expect(
          Hora.of(year: 2024, month: 4, day: 5).fiscalQuarterWithConfig(ukTax),
          4,
        );
        expect(
          Hora.of(year: 2024, month: 4, day: 6).fiscalQuarterWithConfig(ukTax),
          1,
        );
      });

      test('fiscalPeriod maps pre-boundary startMonth dates to period 12', () {
        const ukTax = FiscalYearConfig.ukTax; // April 6
        for (var day = 1; day <= 5; day++) {
          final p = Hora.of(year: 2024, month: 4, day: day)
              .fiscalPeriod(config: ukTax);
          expect(p.quarter, 4, reason: 'day=$day');
          expect(p.period, 12, reason: 'day=$day');
        }

        final boundary =
            Hora.of(year: 2024, month: 4, day: 6).fiscalPeriod(config: ukTax);
        expect(boundary.quarter, 1);
        expect(boundary.period, 1);
      });
    });

    group('with July start (Australia)', () {
      test('fiscalYear', () {
        expect(Hora.of(year: 2024, month: 6).fiscalYear(startMonth: 7), 2023);
        expect(Hora.of(year: 2024, month: 7).fiscalYear(startMonth: 7), 2024);
      });
    });

    group('with October start (US Federal)', () {
      test('fiscalYear', () {
        expect(
          Hora.of(year: 2024, month: 9).fiscalYear(startMonth: 10),
          2023,
        );
        expect(
          Hora.of(year: 2024, month: 10).fiscalYear(startMonth: 10),
          2024,
        );
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

    test('daysRemainingInFiscalYear uses calendar-aware totals', () {
      final start = Hora.of(year: 2024);
      final end = Hora.of(year: 2024, month: 12, day: 31);
      expect(start.daysRemainingInFiscalYear(), 365);
      expect(end.daysRemainingInFiscalYear(), 0);
    });

    test('daysRemainingInFiscalQuarter counts down to quarter end', () {
      final q2Start = Hora.of(year: 2024, month: 4);
      final q2End = Hora.of(year: 2024, month: 6, day: 30);
      expect(q2Start.daysRemainingInFiscalQuarter(), 90);
      expect(q2End.daysRemainingInFiscalQuarter(), 0);
    });

    test('fiscalYearProgress returns normalized progress', () {
      final start = Hora.of(year: 2024);
      final end = Hora.of(year: 2024, month: 12, day: 31);
      expect(start.fiscalYearProgress(), closeTo(1 / 366, 1e-12));
      expect(end.fiscalYearProgress(), closeTo(1, 1e-12));
    });

    test('daysRemainingInFiscalYear supports non-January fiscal starts', () {
      final start = Hora.of(year: 2024, month: 4);
      final end = Hora.of(year: 2025, month: 3, day: 31);
      expect(start.daysRemainingInFiscalYear(startMonth: 4), 364);
      expect(end.daysRemainingInFiscalYear(startMonth: 4), 0);
    });

    test('startOfFiscalYear preserves utc mode', () {
      final utc = Hora.of(year: 2024, month: 6, day: 15, utc: true);
      final start = utc.startOfFiscalYear(startMonth: 4);

      expect(start.isUtc, isTrue);
    });

    test('endOfFiscalYear preserves utc mode', () {
      final utc = Hora.of(year: 2024, month: 6, day: 15, utc: true);
      final end = utc.endOfFiscalYear(startMonth: 4);

      expect(end.isUtc, isTrue);
    });

    test('supports Feb 29 fiscal boundary with non-leap-year fallback', () {
      final config = const FiscalYearConfig(startMonth: 2, startDay: 29);

      final nonLeapBefore = Hora.of(year: 2023, month: 2, day: 27);
      expect(nonLeapBefore.fiscalYearWithConfig(config), 2022);

      final nonLeapBoundary = Hora.of(year: 2023, month: 2, day: 28);
      expect(nonLeapBoundary.fiscalYearWithConfig(config), 2023);
      final nonLeapStart = nonLeapBoundary.startOfFiscalYearWithConfig(config);
      expect(nonLeapStart.year, 2023);
      expect(nonLeapStart.month, 2);
      expect(nonLeapStart.day, 28);

      final leapBoundary = Hora.of(year: 2024, month: 2, day: 29);
      expect(leapBoundary.fiscalYearWithConfig(config), 2024);
      final leapStart = leapBoundary.startOfFiscalYearWithConfig(config);
      expect(leapStart.year, 2024);
      expect(leapStart.month, 2);
      expect(leapStart.day, 29);
    });

    test('endOfFiscalYear handles leap boundary transitions correctly', () {
      final config = const FiscalYearConfig(startMonth: 2, startDay: 29);

      final nonLeapBoundary = Hora.of(year: 2023, month: 2, day: 28);
      final nonLeapEnd = nonLeapBoundary.endOfFiscalYearWithConfig(config);
      expect(nonLeapEnd.year, 2024);
      expect(nonLeapEnd.month, 2);
      expect(nonLeapEnd.day, 28);

      final leapBoundary = Hora.of(year: 2024, month: 2, day: 29);
      final leapEnd = leapBoundary.endOfFiscalYearWithConfig(config);
      expect(leapEnd.year, 2025);
      expect(leapEnd.month, 2);
      expect(leapEnd.day, 27);
    });

    test('isSameFiscalYear uses configured fiscal boundary', () {
      final beforeBoundary = Hora.of(year: 2024, month: 3, day: 31);
      final afterBoundary = Hora.of(year: 2024, month: 4);
      final anotherInFy2024 = Hora.of(year: 2025, month: 3, day: 31);

      expect(
        afterBoundary.isSameFiscalYear(anotherInFy2024, startMonth: 4),
        isTrue,
      );
      expect(
        afterBoundary.isSameFiscalYear(beforeBoundary, startMonth: 4),
        isFalse,
      );
    });

    test('isSameFiscalQuarter distinguishes quarter boundaries', () {
      final q1Date = Hora.of(year: 2024, month: 4, day: 15);
      final q1End = Hora.of(year: 2024, month: 6, day: 30);
      final q2Start = Hora.of(year: 2024, month: 7);

      expect(q1Date.isSameFiscalQuarter(q1End, startMonth: 4), isTrue);
      expect(q1Date.isSameFiscalQuarter(q2Start, startMonth: 4), isFalse);
    });

    test('fiscalPeriod stays within valid quarter/period ranges', () {
      const config = FiscalYearConfig.ukTax;
      for (var year = 2023; year <= 2026; year++) {
        for (var month = 1; month <= 12; month++) {
          final maxDay = Hora.of(year: year, month: month).daysInMonth;
          for (final day in [1, 15, maxDay]) {
            final period = Hora.of(year: year, month: month, day: day)
                .fiscalPeriod(config: config);
            expect(
              period.quarter >= 1 && period.quarter <= 4,
              isTrue,
              reason: '$year-$month-$day quarter=${period.quarter}',
            );
            expect(
              period.period >= 1 && period.period <= 12,
              isTrue,
              reason: '$year-$month-$day period=${period.period}',
            );
          }
        }
      }
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

    test('rejects impossible day for configured month at runtime', () {
      final h = Hora.of(year: 2024, month: 6, day: 15);
      final invalid = const FiscalYearConfig(startMonth: 4, startDay: 31);
      expect(() => h.fiscalYearWithConfig(invalid), throwsArgumentError);
    });
  });

  group('FiscalPeriod', () {
    test('constructor stores values', () {
      const period = FiscalPeriod(
        year: 2024,
        quarter: 3,
        periodInQuarter: 2,
        config: FiscalYearConfig.japan,
      );
      expect(period.year, 2024);
      expect(period.quarter, 3);
      expect(period.periodInQuarter, 2);
      expect(period.config, FiscalYearConfig.japan);
    });

    test('displayString', () {
      final h = Hora.of(year: 2024, month: 5);
      final period = h.fiscalPeriod();
      expect(period.displayString, startsWith('FY'));
    });

    test('period returns month index in fiscal year', () {
      final h = Hora.of(year: 2024, month: 8);
      final period = h.fiscalPeriod(config: FiscalYearConfig.japan);
      expect(period.quarter, 2);
      expect(period.periodInQuarter, 2);
      expect(period.period, 5);
    });

    test('shortDisplay uses two-digit year with fiscal label', () {
      final h = Hora.of(year: 2024, month: 10);
      final period = h.fiscalPeriod(config: FiscalYearConfig.usGovernment);
      expect(period.year, 2025);
      expect(period.shortDisplay, 'FY25-Q1');
    });
  });
}
