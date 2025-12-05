/// Time unit definitions for Hora.
library;

/// Extends Dart's native duration capabilities with semantic time units
/// that support calendar-aware operations like months and years.

/// Represents a semantic unit of time.
///
/// Unlike [Duration] which only handles fixed-length units,
/// [TemporalUnit] supports variable-length units like months and years.
///
/// ```dart
/// final now = Hora.now();
/// now.add(1, TemporalUnit.month);  // Adds exactly one calendar month
/// now.add(1, TemporalUnit.year);   // Adds exactly one calendar year
/// ```
sealed class TemporalUnit {
  const TemporalUnit._();

  /// Microsecond - the smallest unit supported.
  static const TemporalUnit microsecond = _FixedUnit.microsecond;

  /// Millisecond (1000 microseconds).
  static const TemporalUnit millisecond = _FixedUnit.millisecond;

  /// Second (1000 milliseconds).
  static const TemporalUnit second = _FixedUnit.second;

  /// Minute (60 seconds).
  static const TemporalUnit minute = _FixedUnit.minute;

  /// Hour (60 minutes).
  static const TemporalUnit hour = _FixedUnit.hour;

  /// Day (24 hours).
  static const TemporalUnit day = _FixedUnit.day;

  /// Week (7 days).
  static const TemporalUnit week = _FixedUnit.week;

  /// Month - a calendar month (variable length: 28-31 days).
  static const TemporalUnit month = _CalendarUnit.month;

  /// Quarter (3 calendar months).
  static const TemporalUnit quarter = _CalendarUnit.quarter;

  /// Year (12 calendar months, 365 or 366 days).
  static const TemporalUnit year = _CalendarUnit.year;

  /// All available units in ascending order of duration.
  static const List<TemporalUnit> values = [
    microsecond,
    millisecond,
    second,
    minute,
    hour,
    day,
    week,
    month,
    quarter,
    year,
  ];

  /// Whether this unit has a fixed duration.
  bool get isFixed;

  /// Whether this unit is calendar-based (variable duration).
  bool get isCalendarBased => !isFixed;

  /// The singular name of this unit.
  String get name;

  /// The plural name of this unit.
  String get plural => '${name}s';

  /// Short identifier for formatting.
  String get symbol;

  /// Parses a unit from string.
  ///
  /// Accepts:
  /// - Full names: 'year', 'month', 'day', etc.
  /// - Plural forms: 'years', 'months', 'days', etc.
  /// - Symbols: 'y', 'M', 'd', 'h', 'm', 's', 'ms', 'μs'
  ///
  /// Case-insensitive for names, case-sensitive for symbols.
  static TemporalUnit parse(String input) =>
      tryParse(input) ??
      (throw FormatException('Unknown temporal unit: $input'));

  /// Tries to parse a unit from string, returns null if invalid.
  static TemporalUnit? tryParse(String input) {
    // Try symbol match first (case-sensitive)
    for (final unit in values) {
      if (unit.symbol == input) return unit;
    }

    // Try name match (case-insensitive, handles plurals)
    final normalized = input.toLowerCase().replaceAll(RegExp(r's$'), '');
    for (final unit in values) {
      if (unit.name == normalized) return unit;
    }

    // Special aliases
    return switch (normalized) {
      'millisec' => millisecond,
      'microsec' => microsecond,
      'sec' => second,
      'min' => minute,
      'hr' => hour,
      'wk' => week,
      'mon' => month,
      'qtr' => quarter,
      'yr' => year,
      _ => null,
    };
  }
}

/// A time unit with fixed duration.
enum _FixedUnit implements TemporalUnit {
  microsecond(Duration(microseconds: 1), 'microsecond', 'μs'),
  millisecond(Duration(milliseconds: 1), 'millisecond', 'ms'),
  second(Duration(seconds: 1), 'second', 's'),
  minute(Duration(minutes: 1), 'minute', 'm'),
  hour(Duration(hours: 1), 'hour', 'h'),
  day(Duration(days: 1), 'day', 'd'),
  week(Duration(days: 7), 'week', 'w');

  const _FixedUnit(this.duration, this.name, this.symbol);

  /// The fixed duration of this unit.
  final Duration duration;

  @override
  final String name;

  @override
  final String symbol;

  @override
  bool get isFixed => true;

  @override
  bool get isCalendarBased => false;

  @override
  String get plural => '${name}s';
}

/// A calendar-based time unit with variable duration.
enum _CalendarUnit implements TemporalUnit {
  month('month', 'M'),
  quarter('quarter', 'Q'),
  year('year', 'y');

  const _CalendarUnit(this.name, this.symbol);

  @override
  final String name;

  @override
  final String symbol;

  @override
  bool get isFixed => false;

  @override
  bool get isCalendarBased => true;

  @override
  String get plural => '${name}s';
}

/// Extension to get duration from fixed units.
extension FixedUnitDuration on TemporalUnit {
  /// Returns the [Duration] for fixed units.
  ///
  /// Throws [UnsupportedError] for calendar-based units.
  Duration get duration {
    if (this case final _FixedUnit fixed) {
      return fixed.duration;
    }
    throw UnsupportedError(
      'Calendar-based unit "$name" does not have a fixed duration',
    );
  }

  /// Returns the duration in microseconds for fixed units, null for others.
  int? get inMicroseconds {
    if (this case final _FixedUnit fixed) {
      return fixed.duration.inMicroseconds;
    }
    return null;
  }
}
