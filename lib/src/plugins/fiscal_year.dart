/// Fiscal year plugin for Hora.
///
/// Provides fiscal year calculations with customizable start month.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/fiscal_year.dart';
///
/// // Default fiscal year (starts in January)
/// final h = Hora.of(year: 2023, month: 7, day: 15);
/// print(h.fiscalYear()); // 2023
///
/// // Fiscal year starting in April (common for governments)
/// print(h.fiscalYear(startMonth: 4)); // 2024
///
/// // Get fiscal quarter
/// print(h.fiscalQuarter(startMonth: 4)); // Q2
/// ```
library;

import 'package:meta/meta.dart';

import '../hora.dart';
import '../units.dart';

void _validateFiscalYearConfig(FiscalYearConfig config) {
  if (config.startMonth < 1 || config.startMonth > 12) {
    throw ArgumentError.value(
      config.startMonth,
      'startMonth',
      'startMonth must be between 1 and 12.',
    );
  }
  if (config.startDay < 1 || config.startDay > 31) {
    throw ArgumentError.value(
      config.startDay,
      'startDay',
      'startDay must be between 1 and 31.',
    );
  }

  // Validate against the maximum possible day in the configured month.
  // February allows up to 29 to support leap-year fiscal boundaries.
  final maxPossibleDay = DateTime(2024, config.startMonth + 1, 0).day;
  if (config.startDay > maxPossibleDay) {
    throw ArgumentError.value(
      config.startDay,
      'startDay',
      'startDay exceeds valid maximum $maxPossibleDay for month ${config.startMonth}.',
    );
  }
}

int _effectiveFiscalStartDay({
  required int year,
  required int month,
  required int startDay,
}) {
  final maxDay = DateTime(year, month + 1, 0).day;
  return startDay > maxDay ? maxDay : startDay;
}

/// Configuration for fiscal year calculations.
@immutable
class FiscalYearConfig {
  const FiscalYearConfig({
    this.startMonth = 1,
    this.startDay = 1,
    this.yearOffset = 0,
  })  : assert(
          startMonth >= 1 && startMonth <= 12,
          'startMonth must be between 1 and 12',
        ),
        assert(
          startDay >= 1 && startDay <= 31,
          'startDay must be between 1 and 31',
        );

  /// The month when the fiscal year starts (1-12).
  final int startMonth;

  /// The day when the fiscal year starts (1-31).
  final int startDay;

  /// Offset to add to the fiscal year number.
  ///
  /// For example, if the fiscal year starting in July 2023 should be
  /// labeled as "FY2024", use offset = 1.
  final int yearOffset;

  /// Creates a config for US government fiscal year (starts October 1).
  /// The fiscal year is labeled by the ending year (FY2024 = Oct 2023 - Sep 2024).
  static const usGovernment = FiscalYearConfig(startMonth: 10, yearOffset: 1);

  /// Creates a config for UK government fiscal year (starts April 6).
  static const ukTax = FiscalYearConfig(startMonth: 4, startDay: 6);

  /// Creates a config for Japanese fiscal year (starts April 1).
  static const japan = FiscalYearConfig(startMonth: 4);

  /// Creates a config for Australian fiscal year (starts July 1).
  static const australia = FiscalYearConfig(startMonth: 7);

  /// Creates a config for Indian fiscal year (starts April 1).
  static const india = FiscalYearConfig(startMonth: 4);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FiscalYearConfig &&
          startMonth == other.startMonth &&
          startDay == other.startDay &&
          yearOffset == other.yearOffset;

  @override
  int get hashCode => Object.hash(startMonth, startDay, yearOffset);

  @override
  String toString() =>
      'FiscalYearConfig(startMonth: $startMonth, startDay: $startDay, offset: $yearOffset)';
}

/// Represents a fiscal year period.
@immutable
class FiscalPeriod {
  const FiscalPeriod({
    required this.year,
    required this.quarter,
    required this.periodInQuarter,
    required this.config,
  });

  /// The fiscal year number.
  final int year;

  /// The fiscal quarter (1-4).
  final int quarter;

  /// The period number within the quarter (1-3 for months).
  final int periodInQuarter;

  /// The configuration used.
  final FiscalYearConfig config;

  /// Gets the fiscal period (month) number within the fiscal year (1-12).
  int get period => (quarter - 1) * 3 + periodInQuarter;

  /// Gets a display string like "FY2024 Q1".
  String get displayString => 'FY$year Q$quarter';

  /// Gets a short display like "FY24-Q1".
  String get shortDisplay {
    final shortYear = year % 100;
    return "FY${shortYear.toString().padLeft(2, '0')}-Q$quarter";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FiscalPeriod &&
          year == other.year &&
          quarter == other.quarter &&
          periodInQuarter == other.periodInQuarter;

  @override
  int get hashCode => Object.hash(year, quarter, periodInQuarter);

  @override
  String toString() => displayString;
}

/// Extension providing fiscal year calculations for Hora.
extension FiscalYearExt on Hora {
  /// Gets the fiscal year for this date.
  ///
  /// [startMonth] - The month the fiscal year starts (1-12).
  /// [yearOffset] - Offset to add to the year number.
  int fiscalYear({int startMonth = 1, int yearOffset = 0}) {
    final config = FiscalYearConfig(
      startMonth: startMonth,
      yearOffset: yearOffset,
    );
    return fiscalYearWithConfig(config);
  }

  /// Gets the fiscal year using a configuration.
  ///
  /// The fiscal year is identified by the calendar year in which it starts.
  /// Use [FiscalYearConfig.yearOffset] to shift the label (e.g., US Government
  /// uses offset 1 so FY2024 = Oct 2023 - Sep 2024).
  int fiscalYearWithConfig(FiscalYearConfig config) {
    _validateFiscalYearConfig(config);
    final boundaryDay = _effectiveFiscalStartDay(
      year: year,
      month: config.startMonth,
      startDay: config.startDay,
    );
    if (month < config.startMonth ||
        (month == config.startMonth && day < boundaryDay)) {
      return year - 1 + config.yearOffset;
    }
    return year + config.yearOffset;
  }

  /// Gets the fiscal quarter (1-4).
  int fiscalQuarter({int startMonth = 1}) =>
      fiscalQuarterWithConfig(FiscalYearConfig(startMonth: startMonth));

  /// Gets the fiscal quarter using a configuration.
  int fiscalQuarterWithConfig(FiscalYearConfig config) {
    _validateFiscalYearConfig(config);
    final fiscalMonth = _fiscalMonthWithConfig(config);
    return ((fiscalMonth - 1) ~/ 3) + 1;
  }

  /// Gets the complete fiscal period information.
  FiscalPeriod fiscalPeriod({
    FiscalYearConfig config = const FiscalYearConfig(),
  }) {
    _validateFiscalYearConfig(config);
    final fy = fiscalYearWithConfig(config);
    final fm = _fiscalMonthWithConfig(config);
    final fq = ((fm - 1) ~/ 3) + 1;
    final periodInQ = ((fm - 1) % 3) + 1;

    return FiscalPeriod(
      year: fy,
      quarter: fq,
      periodInQuarter: periodInQ,
      config: config,
    );
  }

  /// Gets the start of the fiscal year.
  Hora startOfFiscalYear({int startMonth = 1, int startDay = 1}) {
    final config = FiscalYearConfig(startMonth: startMonth, startDay: startDay);
    return startOfFiscalYearWithConfig(config);
  }

  /// Gets the start of the fiscal year using a configuration.
  Hora startOfFiscalYearWithConfig(FiscalYearConfig config) {
    _validateFiscalYearConfig(config);
    final fy = fiscalYearWithConfig(config);
    final startYear = fy - config.yearOffset;
    final effectiveStartDay = _effectiveFiscalStartDay(
      year: startYear,
      month: config.startMonth,
      startDay: config.startDay,
    );
    return Hora.of(
      year: startYear,
      month: config.startMonth,
      day: effectiveStartDay,
      utc: isUtc,
      locale: locale,
    );
  }

  /// Gets the end of the fiscal year.
  Hora endOfFiscalYear({int startMonth = 1, int startDay = 1}) {
    final config = FiscalYearConfig(startMonth: startMonth, startDay: startDay);
    return endOfFiscalYearWithConfig(config);
  }

  /// Gets the end of the fiscal year using a configuration.
  Hora endOfFiscalYearWithConfig(FiscalYearConfig config) {
    _validateFiscalYearConfig(config);
    final fy = fiscalYearWithConfig(config);
    final nextStartYear = (fy + 1) - config.yearOffset;
    final nextStartDay = _effectiveFiscalStartDay(
      year: nextStartYear,
      month: config.startMonth,
      startDay: config.startDay,
    );
    final nextStart = Hora.of(
      year: nextStartYear,
      month: config.startMonth,
      day: nextStartDay,
      utc: isUtc,
      locale: locale,
    );
    return nextStart.subtract(1, TemporalUnit.day).endOf(TemporalUnit.day);
  }

  /// Gets the start of the fiscal quarter.
  Hora startOfFiscalQuarter({int startMonth = 1}) {
    final fq = fiscalQuarter(startMonth: startMonth);
    final fyStart = startOfFiscalYear(startMonth: startMonth);
    return fyStart.add((fq - 1) * 3, TemporalUnit.month);
  }

  /// Gets the end of the fiscal quarter.
  Hora endOfFiscalQuarter({int startMonth = 1}) {
    final start = startOfFiscalQuarter(startMonth: startMonth);
    return start
        .add(3, TemporalUnit.month)
        .subtract(1, TemporalUnit.day)
        .endOf(TemporalUnit.day);
  }

  /// Gets the number of days remaining in the fiscal year.
  int daysRemainingInFiscalYear({int startMonth = 1, int startDay = 1}) {
    final end = endOfFiscalYear(startMonth: startMonth, startDay: startDay);
    return end.diff(this, TemporalUnit.day).toInt();
  }

  /// Gets the number of days remaining in the fiscal quarter.
  int daysRemainingInFiscalQuarter({int startMonth = 1}) {
    final end = endOfFiscalQuarter(startMonth: startMonth);
    return end.diff(this, TemporalUnit.day).toInt();
  }

  /// Gets the progress through the fiscal year as a fraction (0.0 - 1.0).
  double fiscalYearProgress({int startMonth = 1, int startDay = 1}) {
    final start = startOfFiscalYear(startMonth: startMonth, startDay: startDay);
    final end = endOfFiscalYear(startMonth: startMonth, startDay: startDay);
    final totalDays = end.diff(start, TemporalUnit.day).toInt() + 1;
    final daysPassed = diff(start, TemporalUnit.day).toInt() + 1;
    return daysPassed / totalDays;
  }

  /// Checks if this date is in the same fiscal year as another.
  bool isSameFiscalYear(Hora other, {int startMonth = 1}) =>
      fiscalYear(startMonth: startMonth) ==
      other.fiscalYear(startMonth: startMonth);

  /// Checks if this date is in the same fiscal quarter as another.
  bool isSameFiscalQuarter(Hora other, {int startMonth = 1}) =>
      isSameFiscalYear(other, startMonth: startMonth) &&
      fiscalQuarter(startMonth: startMonth) ==
          other.fiscalQuarter(startMonth: startMonth);

  int _fiscalMonthWithConfig(FiscalYearConfig config) {
    _validateFiscalYearConfig(config);
    final boundaryDay = _effectiveFiscalStartDay(
      year: year,
      month: config.startMonth,
      startDay: config.startDay,
    );
    if (month < config.startMonth) {
      return month + 12 - config.startMonth + 1;
    }
    if (month == config.startMonth && day < boundaryDay) {
      // Dates before the boundary day in startMonth belong to the previous
      // fiscal year and should map to fiscal month 12.
      return 12;
    }
    return month - config.startMonth + 1;
  }
}
