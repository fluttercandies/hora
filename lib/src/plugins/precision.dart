/// Precision plugin for Hora.
///
/// Provides precision-aware comparisons and rounding operations.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/precision.dart';
///
/// final h1 = Hora.of(year: 2023, month: 7, day: 15, hour: 10, minute: 30);
/// final h2 = Hora.of(year: 2023, month: 7, day: 15, hour: 10, minute: 45);
///
/// // Compare with precision
/// print(h1.isSameAs(h2, precision: TimePrecision.hour)); // true
/// print(h1.isSameAs(h2, precision: TimePrecision.minute)); // false
///
/// // Round to precision
/// final rounded = h1.roundTo(TimePrecision.hour);
/// print(rounded.minute); // 0
/// ```
library;

import '../hora.dart';
import '../units.dart';

/// Represents different levels of time precision.
enum TimePrecision {
  /// Year precision.
  year,

  /// Quarter precision.
  quarter,

  /// Month precision.
  month,

  /// Week precision.
  week,

  /// Day precision.
  day,

  /// Hour precision.
  hour,

  /// Minute precision.
  minute,

  /// Second precision.
  second,

  /// Millisecond precision.
  millisecond,
}

/// Extension to convert TimePrecision to TemporalUnit.
extension TimePrecisionExt on TimePrecision {
  /// Converts this precision to a TemporalUnit.
  TemporalUnit get toUnit => switch (this) {
      TimePrecision.year => TemporalUnit.year,
      TimePrecision.quarter => TemporalUnit.quarter,
      TimePrecision.month => TemporalUnit.month,
      TimePrecision.week => TemporalUnit.week,
      TimePrecision.day => TemporalUnit.day,
      TimePrecision.hour => TemporalUnit.hour,
      TimePrecision.minute => TemporalUnit.minute,
      TimePrecision.second => TemporalUnit.second,
      TimePrecision.millisecond => TemporalUnit.millisecond,
    };

  /// Gets the number of milliseconds in this precision unit.
  int get milliseconds => switch (this) {
      TimePrecision.year => 365 * 24 * 60 * 60 * 1000,
      TimePrecision.quarter => 91 * 24 * 60 * 60 * 1000,
      TimePrecision.month => 30 * 24 * 60 * 60 * 1000,
      TimePrecision.week => 7 * 24 * 60 * 60 * 1000,
      TimePrecision.day => 24 * 60 * 60 * 1000,
      TimePrecision.hour => 60 * 60 * 1000,
      TimePrecision.minute => 60 * 1000,
      TimePrecision.second => 1000,
      TimePrecision.millisecond => 1,
    };
}

/// Represents a rounding mode for time operations.
enum RoundingMode {
  /// Round down (floor).
  floor,

  /// Round up (ceiling).
  ceil,

  /// Round to nearest (half up).
  round,

  /// Truncate (same as floor).
  truncate,
}

/// Extension providing precision operations for Hora.
extension PrecisionExt on Hora {
  /// Checks if this date is the same as another with the given precision.
  bool isSameAs(Hora other, {required TimePrecision precision}) => switch (precision) {
      TimePrecision.year => year == other.year,
      TimePrecision.quarter => year == other.year && quarter == other.quarter,
      TimePrecision.month => year == other.year && month == other.month,
      TimePrecision.week =>
        isoWeekYear == other.isoWeekYear && isoWeek == other.isoWeek,
      TimePrecision.day =>
        year == other.year && month == other.month && day == other.day,
      TimePrecision.hour => year == other.year &&
          month == other.month &&
          day == other.day &&
          hour == other.hour,
      TimePrecision.minute => year == other.year &&
          month == other.month &&
          day == other.day &&
          hour == other.hour &&
          minute == other.minute,
      TimePrecision.second => year == other.year &&
          month == other.month &&
          day == other.day &&
          hour == other.hour &&
          minute == other.minute &&
          second == other.second,
      TimePrecision.millisecond => unixMillis == other.unixMillis,
    };

  /// Checks if this date is before another with the given precision.
  bool isBeforeWithPrecision(Hora other, {required TimePrecision precision}) {
    final thisTruncated = truncateTo(precision);
    final otherTruncated = other.truncateTo(precision);
    return thisTruncated.isBefore(otherTruncated);
  }

  /// Checks if this date is after another with the given precision.
  bool isAfterWithPrecision(Hora other, {required TimePrecision precision}) {
    final thisTruncated = truncateTo(precision);
    final otherTruncated = other.truncateTo(precision);
    return thisTruncated.isAfter(otherTruncated);
  }

  /// Truncates this date to the given precision.
  Hora truncateTo(TimePrecision precision) => switch (precision) {
      TimePrecision.year => Hora.of(year: year, locale: locale),
      TimePrecision.quarter => Hora.of(
          year: year,
          month: (quarter - 1) * 3 + 1,
          locale: locale,
        ),
      TimePrecision.month => Hora.of(year: year, month: month, locale: locale),
      TimePrecision.week => startOf(TemporalUnit.week),
      TimePrecision.day => Hora.of(
          year: year,
          month: month,
          day: day,
          locale: locale,
        ),
      TimePrecision.hour => Hora.of(
          year: year,
          month: month,
          day: day,
          hour: hour,
          locale: locale,
        ),
      TimePrecision.minute => Hora.of(
          year: year,
          month: month,
          day: day,
          hour: hour,
          minute: minute,
          locale: locale,
        ),
      TimePrecision.second => Hora.of(
          year: year,
          month: month,
          day: day,
          hour: hour,
          minute: minute,
          second: second,
          locale: locale,
        ),
      TimePrecision.millisecond => this,
    };

  /// Rounds this date to the given precision.
  Hora roundTo(TimePrecision precision,
      {RoundingMode mode = RoundingMode.round,}) {
    switch (mode) {
      case RoundingMode.floor:
      case RoundingMode.truncate:
        return truncateTo(precision);

      case RoundingMode.ceil:
        return _ceilTo(precision);

      case RoundingMode.round:
        return _roundTo(precision);
    }
  }

  Hora _ceilTo(TimePrecision precision) {
    final truncated = truncateTo(precision);
    if (truncated == this) return this;
    return truncated.add(1, precision.toUnit);
  }

  Hora _roundTo(TimePrecision precision) {
    final truncated = truncateTo(precision);
    if (truncated == this) return this;

    final half = switch (precision) {
      TimePrecision.year => 6,
      TimePrecision.quarter => 45,
      TimePrecision.month => 15,
      TimePrecision.week => 3,
      TimePrecision.day => 12,
      TimePrecision.hour => 30,
      TimePrecision.minute => 30,
      TimePrecision.second => 500,
      TimePrecision.millisecond => 0,
    };

    final remainder = switch (precision) {
      TimePrecision.year => month,
      TimePrecision.quarter => day,
      TimePrecision.month => day,
      TimePrecision.week => weekday,
      TimePrecision.day => hour,
      TimePrecision.hour => minute,
      TimePrecision.minute => second,
      TimePrecision.second => millisecond,
      TimePrecision.millisecond => 0,
    };

    if (remainder >= half) {
      return truncated.add(1, precision.toUnit);
    }
    return truncated;
  }

  /// Computes the difference with precision-aware truncation.
  int diffWithPrecision(Hora other, {required TimePrecision precision}) => truncateTo(precision)
        .diff(
          other.truncateTo(precision),
          precision.toUnit,
        )
        .toInt();

  /// Gets the nearest precision boundary.
  Hora nearestBoundary(TimePrecision precision) => roundTo(precision);

  /// Aligns this date to a grid of the specified interval.
  ///
  /// For example, `alignTo(15, TimePrecision.minute)` aligns to
  /// 15-minute intervals (0, 15, 30, 45 minutes).
  Hora alignTo(int interval, TimePrecision precision) {
    final truncated = truncateTo(precision);
    final value = switch (precision) {
      TimePrecision.year => year,
      TimePrecision.quarter => quarter,
      TimePrecision.month => month,
      TimePrecision.week => isoWeek,
      TimePrecision.day => day,
      TimePrecision.hour => hour,
      TimePrecision.minute => minute,
      TimePrecision.second => second,
      TimePrecision.millisecond => millisecond,
    };

    final aligned = (value ~/ interval) * interval;
    final diff = value - aligned;

    return truncated.subtract(diff, precision.toUnit);
  }

  /// Creates a Hora with only the specified precision components.
  ///
  /// Higher precision components are set to their minimum values.
  Hora withPrecision(TimePrecision precision) => truncateTo(precision);
}

/// Extension for precision-aware iteration.
extension PrecisionIterationExt on Hora {
  /// Generates a sequence of dates at the given precision interval.
  Iterable<Hora> every(
    int interval,
    TimePrecision precision, {
    Hora? until,
    int? count,
  }) sync* {
    var current = this;
    var generated = 0;

    while (true) {
      if (until != null && current.isAfter(until)) break;
      if (count != null && generated >= count) break;

      yield current;
      current = current.add(interval, precision.toUnit);
      generated++;
    }
  }

  /// Generates dates between this and another at the given precision.
  Iterable<Hora> stepTo(Hora end, {required TimePrecision precision}) sync* {
    final step = isBefore(end) ? 1 : -1;
    var current = this;

    while (step > 0 ? !current.isAfter(end) : !current.isBefore(end)) {
      yield current;
      current = current.add(step, precision.toUnit);
    }
  }
}
