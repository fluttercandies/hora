/// Business day calculations plugin for Hora.
///
/// Provides methods for working with business days, including:
/// - Adding/subtracting business days
/// - Checking if a date is a business day
/// - Finding the next/previous business day
/// - Custom holiday calendars
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/business_day.dart';
///
/// final h = Hora.of(year: 2023, month: 12, day: 25);
///
/// // Check if it's a business day (excludes weekends)
/// print(h.isBusinessDay()); // false (Monday but might be holiday)
///
/// // Add business days
/// final nextBizDay = h.addBusinessDays(5);
///
/// // With custom holidays
/// final holidays = HolidayCalendar.us2023();
/// print(h.isBusinessDay(holidays: holidays)); // false (Christmas)
/// ```
library;

import '../hora.dart';
import '../units.dart';

/// A calendar of holidays for business day calculations.
///
/// Holidays can be defined as specific dates or recurring annual dates.
class HolidayCalendar {
  /// Creates a holiday calendar with the given holidays.
  const HolidayCalendar({
    this.fixedHolidays = const [],
    this.annualHolidays = const [],
    this.name = 'Custom',
  });

  /// Creates an empty calendar with no holidays.
  const HolidayCalendar.empty() : this();

  /// Fixed holidays (specific dates).
  final List<DateTime> fixedHolidays;

  /// Annual recurring holidays (month, day pairs).
  final List<(int month, int day)> annualHolidays;

  /// The name of this calendar.
  final String name;

  /// Checks if the given date is a holiday.
  bool isHoliday(DateTime date) {
    // Check fixed holidays
    for (final holiday in fixedHolidays) {
      if (holiday.year == date.year &&
          holiday.month == date.month &&
          holiday.day == date.day) {
        return true;
      }
    }

    // Check annual holidays
    for (final (month, day) in annualHolidays) {
      if (date.month == month && date.day == day) {
        return true;
      }
    }

    return false;
  }

  /// Creates a new calendar by merging with another.
  HolidayCalendar merge(HolidayCalendar other) => HolidayCalendar(
        fixedHolidays: [...fixedHolidays, ...other.fixedHolidays],
        annualHolidays: [...annualHolidays, ...other.annualHolidays],
        name: '$name + ${other.name}',
      );

  /// US Federal Holidays (fixed dates only, not observed dates).
  static const usCommon = HolidayCalendar(
    annualHolidays: [
      (1, 1), // New Year's Day
      (7, 4), // Independence Day
      (12, 25), // Christmas
    ],
    name: 'US Common',
  );

  /// Chinese statutory holidays (fixed dates).
  static const cnCommon = HolidayCalendar(
    annualHolidays: [
      (1, 1), // New Year's Day
      (5, 1), // Labor Day
      (10, 1), // National Day
      (10, 2), // National Day
      (10, 3), // National Day
    ],
    name: 'CN Common',
  );
}

/// Configuration for business day calculations.
class BusinessDayConfig {
  /// Creates a business day configuration.
  const BusinessDayConfig({
    this.weekendDays = const {DateTime.saturday, DateTime.sunday},
    this.holidays = const HolidayCalendar.empty(),
  });

  /// Days of the week considered as weekend (1=Monday, 7=Sunday).
  final Set<int> weekendDays;

  /// Holiday calendar to use.
  final HolidayCalendar holidays;

  /// Default configuration (Saturday and Sunday as weekends, no holidays).
  static const BusinessDayConfig standard = BusinessDayConfig();

  /// Middle Eastern configuration (Friday and Saturday as weekends).
  static const BusinessDayConfig middleEast = BusinessDayConfig(
    weekendDays: {DateTime.friday, DateTime.saturday},
  );

  /// Creates a new config with custom weekend days.
  BusinessDayConfig withWeekends(Set<int> weekendDays) =>
      BusinessDayConfig(weekendDays: weekendDays, holidays: holidays);

  /// Creates a new config with custom holidays.
  BusinessDayConfig withHolidays(HolidayCalendar holidays) =>
      BusinessDayConfig(weekendDays: weekendDays, holidays: holidays);
}

/// Extension providing business day calculations.
extension BusinessDayExt on Hora {
  /// Checks if this date is a business day.
  ///
  /// A business day is one that is not a weekend and not a holiday.
  bool isBusinessDay([BusinessDayConfig config = BusinessDayConfig.standard]) {
    if (!isValid) return false;

    // Check if weekend
    if (config.weekendDays.contains(weekday)) {
      return false;
    }

    // Check if holiday
    if (config.holidays.isHoliday(dateTime)) {
      return false;
    }

    return true;
  }

  /// Checks if this date is a weekend.
  bool isWeekendDay([BusinessDayConfig config = BusinessDayConfig.standard]) =>
      config.weekendDays.contains(weekday);

  /// Checks if this date is a holiday.
  bool isHoliday([HolidayCalendar? calendar]) {
    if (calendar == null) return false;
    return calendar.isHoliday(dateTime);
  }

  /// Returns the next business day.
  ///
  /// If this is already a business day, returns a copy of this.
  /// Otherwise, returns the next date that is a business day.
  Hora nextBusinessDay([
    BusinessDayConfig config = BusinessDayConfig.standard,
  ]) {
    var current = this;
    while (!current.isBusinessDay(config)) {
      current = current.add(1, TemporalUnit.day);
    }
    return current;
  }

  /// Returns the previous business day.
  ///
  /// If this is already a business day, returns a copy of this.
  /// Otherwise, returns the previous date that is a business day.
  Hora previousBusinessDay([
    BusinessDayConfig config = BusinessDayConfig.standard,
  ]) {
    var current = this;
    while (!current.isBusinessDay(config)) {
      current = current.subtract(1, TemporalUnit.day);
    }
    return current;
  }

  /// Returns the nearest business day.
  ///
  /// If this is a business day, returns this.
  /// Otherwise, returns whichever is closer: the next or previous business day.
  /// If equidistant, prefers the next business day.
  Hora nearestBusinessDay([
    BusinessDayConfig config = BusinessDayConfig.standard,
  ]) {
    if (isBusinessDay(config)) return this;

    final next = nextBusinessDay(config);
    final prev = previousBusinessDay(config);

    final daysToNext = next.diff(this, TemporalUnit.day).abs();
    final daysToPrev = diff(prev, TemporalUnit.day).abs();

    return daysToNext <= daysToPrev ? next : prev;
  }

  /// Adds the specified number of business days.
  ///
  /// ```dart
  /// final h = Hora.of(year: 2023, month: 12, day: 22); // Friday
  /// final result = h.addBusinessDays(3); // Wednesday (skips Sat, Sun)
  /// ```
  Hora addBusinessDays(
    int days, [
    BusinessDayConfig config = BusinessDayConfig.standard,
  ]) {
    if (days == 0) return this;

    var current = this;
    var remaining = days.abs();
    final direction = days.isNegative ? -1 : 1;

    while (remaining > 0) {
      current = direction > 0
          ? current.add(1, TemporalUnit.day)
          : current.subtract(1, TemporalUnit.day);

      if (current.isBusinessDay(config)) {
        remaining--;
      }
    }

    return current;
  }

  /// Subtracts the specified number of business days.
  Hora subtractBusinessDays(
    int days, [
    BusinessDayConfig config = BusinessDayConfig.standard,
  ]) =>
      addBusinessDays(-days, config);

  /// Returns the number of business days between this and [other].
  ///
  /// The result is positive if [other] is after this, negative otherwise.
  int businessDaysBetween(
    Hora other, [
    BusinessDayConfig config = BusinessDayConfig.standard,
  ]) {
    if (!isValid || !other.isValid) return 0;

    final start = isBefore(other) ? this : other;
    final end = isBefore(other) ? other : this;
    final sign = isBefore(other) ? 1 : -1;

    var count = 0;
    var current = start;

    while (current.isBefore(end)) {
      if (current.isBusinessDay(config)) {
        count++;
      }
      current = current.add(1, TemporalUnit.day);
    }

    return count * sign;
  }

  /// Returns the start of the business week.
  ///
  /// By default, returns Monday. For Middle Eastern config, returns Sunday.
  Hora startOfBusinessWeek([
    BusinessDayConfig config = BusinessDayConfig.standard,
  ]) {
    var current = startOf(TemporalUnit.day);

    // Find the first non-weekend day of the week
    while (config.weekendDays.contains(current.weekday)) {
      current = current.subtract(1, TemporalUnit.day);
    }

    // Go back to the start of the business week
    while (!config.weekendDays.contains(
      current.subtract(1, TemporalUnit.day).weekday,
    )) {
      current = current.subtract(1, TemporalUnit.day);
    }

    return current;
  }

  /// Returns the end of the business week.
  Hora endOfBusinessWeek([
    BusinessDayConfig config = BusinessDayConfig.standard,
  ]) {
    var current = startOf(TemporalUnit.day);

    // Find the last non-weekend day of the week
    while (config.weekendDays.contains(current.weekday)) {
      current = current.add(1, TemporalUnit.day);
    }

    // Go forward to the end of the business week
    while (!config.weekendDays.contains(
      current.add(1, TemporalUnit.day).weekday,
    )) {
      current = current.add(1, TemporalUnit.day);
    }

    return current.endOf(TemporalUnit.day);
  }
}
