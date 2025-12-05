/// Week of year plugin for Hora.
///
/// Provides ISO and locale-aware week calculations.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/week_of_year.dart';
///
/// final h = Hora.of(year: 2023, month: 12, day: 31);
///
/// // ISO week (week starts on Monday)
/// print(h.isoWeek); // 52
/// print(h.isoWeekYear); // 2023
///
/// // Locale-aware week (week may start on Sunday)
/// print(h.localeWeek); // depends on locale
///
/// // Week range
/// print(h.startOfIsoWeek);
/// print(h.endOfIsoWeek);
/// ```
library;

import 'package:meta/meta.dart';

import '../hora.dart';
import '../units.dart';

/// Week numbering system.
enum WeekNumbering {
  /// ISO 8601 week numbering (week starts Monday).
  iso,

  /// US week numbering (week starts Sunday).
  us,

  /// Locale-specific week numbering.
  locale,
}

/// Configuration for week calculations.
@immutable
class WeekConfig {
  const WeekConfig({
    this.firstDayOfWeek = DateTime.monday,
    this.minDaysInFirstWeek = 4,
  });

  /// The first day of the week (1 = Monday, 7 = Sunday).
  final int firstDayOfWeek;

  /// Minimum days in the first week of the year.
  /// ISO 8601 uses 4 (the week containing January 4th is week 1).
  final int minDaysInFirstWeek;

  /// ISO 8601 configuration.
  static const iso = WeekConfig();

  /// US configuration (Sunday start, first week contains January 1).
  static const us = WeekConfig(
    firstDayOfWeek: DateTime.sunday,
    minDaysInFirstWeek: 1,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekConfig &&
          firstDayOfWeek == other.firstDayOfWeek &&
          minDaysInFirstWeek == other.minDaysInFirstWeek;

  @override
  int get hashCode => Object.hash(firstDayOfWeek, minDaysInFirstWeek);
}

/// Extension providing week calculations for Hora.
extension WeekOfYearExt on Hora {
  /// Gets the ISO week number (1-53).
  ///
  /// ISO 8601 defines week 1 as the week containing January 4th,
  /// or equivalently, the first week with the majority of its days
  /// in the new year.
  int get isoWeek => _weekOfYear(WeekConfig.iso);

  /// Gets the ISO week year.
  ///
  /// This may differ from the calendar year near year boundaries.
  int get isoWeekYear => _weekYear(WeekConfig.iso);

  /// Gets the locale-aware week number.
  int get localeWeek =>
      _weekOfYear(WeekConfig(firstDayOfWeek: locale.weekStart + 1));

  /// Gets the locale-aware week year.
  int get localeWeekYear =>
      _weekYear(WeekConfig(firstDayOfWeek: locale.weekStart + 1));

  /// Gets the week number using a specific configuration.
  int weekOfYear({WeekConfig config = WeekConfig.iso}) => _weekOfYear(config);

  /// Gets the week year using a specific configuration.
  int weekYear({WeekConfig config = WeekConfig.iso}) => _weekYear(config);

  /// Gets the number of ISO weeks in this year.
  int get isoWeeksInYear => weeksInYear();

  /// Gets the number of weeks in this year.
  int weeksInYear({WeekConfig config = WeekConfig.iso}) {
    final dec28 = Hora.of(year: year, month: 12, day: 28, locale: locale);
    return dec28._weekOfYear(config);
  }

  /// Gets the start of the ISO week.
  Hora get startOfIsoWeek => startOfWeekWith();

  /// Gets the end of the ISO week.
  Hora get endOfIsoWeek => endOfWeekWith();

  /// Gets the start of the week with configuration.
  Hora startOfWeekWith({WeekConfig config = WeekConfig.iso}) {
    var diff = weekday - config.firstDayOfWeek;
    if (diff < 0) diff += 7;
    return subtract(diff, TemporalUnit.day).startOf(TemporalUnit.day);
  }

  /// Gets the end of the week with configuration.
  Hora endOfWeekWith({WeekConfig config = WeekConfig.iso}) =>
      startOfWeekWith(config: config)
          .add(6, TemporalUnit.day)
          .endOf(TemporalUnit.day);

  /// Gets all days in the current week.
  List<Hora> get daysOfWeek {
    final start = startOf(TemporalUnit.week);
    return List.generate(7, (i) => start.add(i, TemporalUnit.day));
  }

  /// Gets all days in the current ISO week.
  List<Hora> get daysOfIsoWeek {
    final start = startOfIsoWeek;
    return List.generate(7, (i) => start.add(i, TemporalUnit.day));
  }

  /// Checks if this is in the same ISO week as another date.
  bool isSameIsoWeek(Hora other) =>
      isoWeekYear == other.isoWeekYear && isoWeek == other.isoWeek;

  /// Checks if this is in the same week as another date.
  bool isSameWeekWith(Hora other, {WeekConfig config = WeekConfig.iso}) =>
      _weekYear(config) == other._weekYear(config) &&
      _weekOfYear(config) == other._weekOfYear(config);

  /// Sets the ISO week of year.
  Hora setIsoWeek(int week) {
    final currentWeek = isoWeek;
    return add(week - currentWeek, TemporalUnit.week);
  }

  /// Sets the ISO week year.
  Hora setIsoWeekYear(int weekYear) {
    final currentWeekYear = isoWeekYear;
    return add(weekYear - currentWeekYear, TemporalUnit.year);
  }

  /// Gets the day of the week in ISO format (1 = Monday, 7 = Sunday).
  int get isoDayOfWeek => weekday == 0 ? 7 : weekday;

  /// Gets the ordinal week of the month (1-5).
  int get weekOfMonth => ((day - 1) ~/ 7) + 1;

  /// Checks if this week spans two months.
  bool get weekSpansMonths {
    final start = startOf(TemporalUnit.week);
    final end = endOf(TemporalUnit.week);
    return start.month != end.month;
  }

  /// Checks if this week spans two years.
  bool get weekSpansYears {
    final start = startOf(TemporalUnit.week);
    final end = endOf(TemporalUnit.week);
    return start.year != end.year;
  }

  int _weekOfYear(WeekConfig config) {
    // Find the first day of the first week of the year
    final jan1 = Hora.of(year: year, locale: locale);
    var jan1Weekday = jan1.weekday;
    if (jan1Weekday == 0) jan1Weekday = 7; // Convert Sunday 0 to 7

    // Calculate how many days until the first day of week 1
    var daysToFirstWeek = config.firstDayOfWeek - jan1Weekday;
    if (daysToFirstWeek > 0) {
      daysToFirstWeek -= 7;
    }

    // Does week 1 have enough days?
    final daysInFirstWeek = 7 + daysToFirstWeek;
    final week1Start = daysInFirstWeek >= config.minDaysInFirstWeek
        ? jan1.add(daysToFirstWeek, TemporalUnit.day)
        : jan1.add(daysToFirstWeek + 7, TemporalUnit.day);

    final daysDiff = diff(week1Start, TemporalUnit.day).toInt();

    if (daysDiff < 0) {
      // This date belongs to the previous year's last week
      final prevYear =
          Hora.of(year: year - 1, month: 12, day: 28, locale: locale);
      return prevYear._weekOfYear(config);
    }

    return (daysDiff ~/ 7) + 1;
  }

  int _weekYear(WeekConfig config) {
    final week = _weekOfYear(config);
    if (month == 1 && week > 50) {
      return year - 1;
    }
    if (month == 12 && week == 1) {
      return year + 1;
    }
    return year;
  }
}

/// Extension for week iteration.
extension WeekIterationExt on Hora {
  /// Generates all weeks in the year.
  Iterable<Hora> get weeksInThisYear sync* {
    var current = Hora.of(year: year, locale: locale).startOfIsoWeek;

    // Move to first week of this year if needed
    if (current.isoWeekYear < year) {
      current = current.add(1, TemporalUnit.week);
    }

    while (current.isoWeekYear == year) {
      yield current;
      current = current.add(1, TemporalUnit.week);
    }
  }

  /// Generates weeks between this date and another.
  Iterable<Hora> weeksUntil(Hora end) sync* {
    var current = startOfIsoWeek;
    final endWeek = end.startOfIsoWeek;

    while (!current.isAfter(endWeek)) {
      yield current;
      current = current.add(1, TemporalUnit.week);
    }
  }
}
