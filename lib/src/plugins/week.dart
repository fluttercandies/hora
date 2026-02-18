/// Unified week calculation plugin for Hora.
///
/// Provides ISO 8601, US, and locale-aware week numbering with
/// a single [WeekConfig] to control all behavior.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/week.dart';
///
/// final h = Hora.of(year: 2023, month: 12, day: 31);
///
/// // ISO week (week starts on Monday, min 4 days in first week)
/// print(h.isoWeek);     // 52
/// print(h.isoWeekYear); // 2023
///
/// // US week (week starts on Sunday, Jan 1 is always in week 1)
/// print(h.weekOfYear(config: WeekConfig.us));
///
/// // Locale-aware week
/// print(h.localeWeek);
///
/// // Week navigation
/// print(h.startOfIsoWeek);
/// print(h.endOfIsoWeek);
/// print(h.daysOfIsoWeek);
/// ```
library;

import 'package:meta/meta.dart';

import '../hora.dart';
import '../locale.dart';
import '../units.dart';

void _validateWeekConfig(WeekConfig config) {
  if (config.firstDayOfWeek < DateTime.monday ||
      config.firstDayOfWeek > DateTime.sunday) {
    throw ArgumentError.value(
      config.firstDayOfWeek,
      'firstDayOfWeek',
      'firstDayOfWeek must be 1 (Monday) through 7 (Sunday).',
    );
  }
  if (config.minDaysInFirstWeek < 1 || config.minDaysInFirstWeek > 7) {
    throw ArgumentError.value(
      config.minDaysInFirstWeek,
      'minDaysInFirstWeek',
      'minDaysInFirstWeek must be 1 through 7.',
    );
  }
}

/// Configuration for week calculations.
///
/// Controls the first day of the week and the minimum number of days
/// required in the first week of the year.
///
/// ```dart
/// // ISO 8601: Monday start, 4-day threshold
/// WeekConfig.iso
///
/// // US convention: Sunday start, Jan 1 always in week 1
/// WeekConfig.us
///
/// // From locale
/// WeekConfig.fromLocale(hora.locale)
///
/// // Custom
/// WeekConfig(firstDayOfWeek: DateTime.saturday, minDaysInFirstWeek: 1)
/// ```
@immutable
class WeekConfig {
  /// Creates a week configuration.
  ///
  /// [firstDayOfWeek] uses the same values as [DateTime.monday] (1)
  /// through [DateTime.sunday] (7).
  ///
  /// [minDaysInFirstWeek] determines when the first week of the year starts:
  /// - 4 = ISO 8601 (first week must contain Thursday)
  /// - 1 = US convention (first week contains Jan 1)
  const WeekConfig({
    this.firstDayOfWeek = DateTime.monday,
    this.minDaysInFirstWeek = 4,
  })  : assert(
          firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
          'firstDayOfWeek must be 1 (Monday) through 7 (Sunday)',
        ),
        assert(
          minDaysInFirstWeek >= 1 && minDaysInFirstWeek <= 7,
          'minDaysInFirstWeek must be 1 through 7',
        );

  /// Creates a [WeekConfig] from a [HoraLocale].
  factory WeekConfig.fromLocale(HoraLocale locale) => WeekConfig(
        firstDayOfWeek: locale.weekStart,
        minDaysInFirstWeek: locale.yearStart,
      );

  /// ISO 8601 configuration (Monday start, 4-day first week threshold).
  static const iso = WeekConfig();

  /// US configuration (Sunday start, Jan 1 always in week 1).
  static const us = WeekConfig(
    firstDayOfWeek: DateTime.sunday,
    minDaysInFirstWeek: 1,
  );

  /// The first day of the week (1 = Monday, 7 = Sunday).
  final int firstDayOfWeek;

  /// Minimum days required in the first week of the year.
  final int minDaysInFirstWeek;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekConfig &&
          firstDayOfWeek == other.firstDayOfWeek &&
          minDaysInFirstWeek == other.minDaysInFirstWeek;

  @override
  int get hashCode => Object.hash(firstDayOfWeek, minDaysInFirstWeek);

  @override
  String toString() =>
      'WeekConfig(firstDay: $firstDayOfWeek, minDays: $minDaysInFirstWeek)';
}

/// Week calculations for [Hora].
///
/// Provides locale-aware and custom week numbering through a unified
/// [WeekConfig] parameter. ISO 8601 week properties (`isoWeek`,
/// `isoWeekYear`, `isoWeeksInYear`) are available directly on [Hora].
extension HoraWeekExt on Hora {
  // ============ Locale-Aware Shortcuts ============

  /// The locale-aware week number.
  int get localeWeek => weekOfYear(config: WeekConfig.fromLocale(locale));

  /// The locale-aware week year.
  int get localeWeekYear => weekYear(config: WeekConfig.fromLocale(locale));

  // ============ ISO Convenience Methods ============

  /// The start of the current ISO week (Monday 00:00:00.000000).
  Hora get startOfIsoWeek => startOfWeek();

  /// The end of the current ISO week (Sunday 23:59:59.999999).
  Hora get endOfIsoWeek => endOfWeek();

  /// All 7 days in the current ISO week.
  List<Hora> get daysOfIsoWeek => daysOfWeekWith();

  // ============ Configurable Methods ============

  /// The week number within the year (1–53).
  ///
  /// Uses [config] to determine week start day and first-week rules.
  /// Defaults to ISO 8601.
  int weekOfYear({WeekConfig config = WeekConfig.iso}) {
    _validateWeekConfig(config);
    return _weekOfYear(config);
  }

  /// The year to which the current week belongs.
  ///
  /// This may differ from the calendar year near year boundaries.
  int weekYear({WeekConfig config = WeekConfig.iso}) {
    _validateWeekConfig(config);
    return _weekYear(config);
  }

  /// The number of weeks in the specified year (52 or 53).
  int weeksInYear({WeekConfig config = WeekConfig.iso}) {
    _validateWeekConfig(config);
    // Dec 28 is always in the last week of its own year.
    final dec28 = Hora.of(
      year: year,
      month: 12,
      day: 28,
      utc: isUtc,
      locale: locale,
    );
    return dec28._weekOfYear(config);
  }

  /// The start of the current week at 00:00:00.000000.
  Hora startOfWeek({WeekConfig config = WeekConfig.iso}) {
    _validateWeekConfig(config);
    var diff = weekday - config.firstDayOfWeek;
    if (diff < 0) diff += 7;
    return subtract(diff, TemporalUnit.day).startOf(TemporalUnit.day);
  }

  /// The end of the current week at 23:59:59.999999.
  Hora endOfWeek({WeekConfig config = WeekConfig.iso}) =>
      startOfWeek(config: config)
          .add(6, TemporalUnit.day)
          .endOf(TemporalUnit.day);

  /// All 7 days in the current week.
  List<Hora> daysOfWeekWith({WeekConfig config = WeekConfig.iso}) {
    _validateWeekConfig(config);
    final start = startOfWeek(config: config);
    return List.generate(7, (i) => start.add(i, TemporalUnit.day));
  }

  /// Sets the week of year, returning a new [Hora].
  Hora setWeekOfYear(int week, {WeekConfig config = WeekConfig.iso}) {
    _validateWeekConfig(config);
    final current = _weekOfYear(config);
    return add(week - current, TemporalUnit.week);
  }

  /// Sets the week year, returning a new [Hora].
  Hora setWeekYear(int targetYear, {WeekConfig config = WeekConfig.iso}) {
    _validateWeekConfig(config);
    final currentWeek = _weekOfYear(config);
    final currentWeekday = _adjustedWeekday(config);

    final firstWeekStart = _firstWeekStart(targetYear, config);
    final targetDate = firstWeekStart.add(
      Duration(days: (currentWeek - 1) * 7 + currentWeekday),
    );

    return copyWith(
      year: targetDate.year,
      month: targetDate.month,
      day: targetDate.day,
    );
  }

  /// Whether this date is in the same ISO week as [other].
  bool isSameIsoWeek(Hora other) =>
      isoWeekYear == other.isoWeekYear && isoWeek == other.isoWeek;

  /// Whether this date is in the same week as [other].
  bool isSameWeek(Hora other, {WeekConfig config = WeekConfig.iso}) {
    _validateWeekConfig(config);
    return _weekYear(config) == other._weekYear(config) &&
        _weekOfYear(config) == other._weekOfYear(config);
  }

  /// The ISO day of the week (1 = Monday, 7 = Sunday).
  int get isoDayOfWeek => weekday;

  /// The ordinal week of the month (1–5).
  int get weekOfMonth => ((day - 1) ~/ 7) + 1;

  /// Whether this week spans two calendar months.
  bool weekSpansMonths({WeekConfig config = WeekConfig.iso}) {
    _validateWeekConfig(config);
    final s = startOfWeek(config: config);
    final e = endOfWeek(config: config);
    return s.month != e.month;
  }

  /// Whether this week spans two calendar years.
  bool weekSpansYears({WeekConfig config = WeekConfig.iso}) {
    _validateWeekConfig(config);
    final s = startOfWeek(config: config);
    final e = endOfWeek(config: config);
    return s.year != e.year;
  }

  // ============ Internal ============

  int _adjustedWeekday(WeekConfig config) =>
      (weekday - config.firstDayOfWeek + 7) % 7;

  int _weekOfYear(WeekConfig config) {
    _validateWeekConfig(config);
    final weekBasedYear = _weekYear(config);
    final date = DateTime.utc(year, month, day);
    final firstWeekStart = _firstWeekStart(weekBasedYear, config);
    return (date.difference(firstWeekStart).inDays ~/ 7) + 1;
  }

  int _weekYear(WeekConfig config) {
    _validateWeekConfig(config);
    final date = DateTime.utc(year, month, day);
    final firstWeekStartThisYear = _firstWeekStart(year, config);
    if (date.isBefore(firstWeekStartThisYear)) {
      return year - 1;
    }

    final firstWeekStartNextYear = _firstWeekStart(year + 1, config);
    if (!date.isBefore(firstWeekStartNextYear)) {
      return year + 1;
    }

    return year;
  }

  DateTime _firstWeekStart(int targetYear, WeekConfig config) {
    _validateWeekConfig(config);
    final jan1 = DateTime.utc(targetYear);
    final weekdayOffset = (jan1.weekday - config.firstDayOfWeek + 7) % 7;
    final weekStartContainingJan1 = jan1.subtract(
      Duration(days: weekdayOffset),
    );
    final daysInFirstWeek = 7 - weekdayOffset;

    if (daysInFirstWeek >= config.minDaysInFirstWeek) {
      return weekStartContainingJan1;
    }
    return weekStartContainingJan1.add(const Duration(days: 7));
  }
}

/// Week iteration utilities for [Hora].
extension HoraWeekIterationExt on Hora {
  /// Generates all ISO week start dates in the current year.
  Iterable<Hora> get weeksInThisYear sync* {
    if (!isValid) {
      throw StateError('weeksInThisYear requires a valid Hora instance.');
    }

    var current =
        Hora.of(year: year, utc: isUtc, locale: locale).startOfIsoWeek;

    if (current.isoWeekYear < year) {
      current = current.add(1, TemporalUnit.week);
    }

    while (current.isoWeekYear == year) {
      yield current;
      current = current.add(1, TemporalUnit.week);
    }
  }

  /// Generates week start dates from this date to [end] (inclusive).
  Iterable<Hora> weeksUntil(
    Hora end, {
    WeekConfig config = WeekConfig.iso,
  }) sync* {
    if (!isValid) {
      throw ArgumentError.value(
        this,
        'this',
        'weeksUntil() requires a valid start Hora.',
      );
    }
    if (!end.isValid) {
      throw ArgumentError.value(
        end,
        'end',
        'weeksUntil() requires a valid end Hora.',
      );
    }

    var current = startOfWeek(config: config);
    final endWeek = end.startOfWeek(config: config);

    while (!current.isAfter(endWeek)) {
      yield current;
      current = current.add(1, TemporalUnit.week);
    }
  }
}
