/// Object support plugin for Hora.
///
/// This plugin adds support for creating and manipulating Hora instances
/// using Map objects instead of individual parameters. This makes it easier
/// to work with date-time data from JSON or other map-based sources.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/object_support.dart';
///
/// // Create from map
/// final h = HoraObject.from({
///   'year': 2023,
///   'month': 12,
///   'day': 25,
///   'hour': 10,
///   'minute': 30,
/// });
///
/// // Add using map
/// final h2 = h.addObject({'days': 5, 'hours': 2});
///
/// // Subtract using map
/// final h3 = h.subtractObject({'months': 1});
///
/// // Set using map
/// final h4 = h.setObject({'hour': 0, 'minute': 0, 'second': 0});
/// ```
library;

import '../hora.dart';
import '../units.dart';

/// Keys used in date-time object maps.
class DateTimeKeys {
  DateTimeKeys._();

  static const year = 'year';
  static const years = 'years';
  static const month = 'month';
  static const months = 'months';
  static const day = 'day';
  static const days = 'days';
  static const date = 'date';
  static const hour = 'hour';
  static const hours = 'hours';
  static const minute = 'minute';
  static const minutes = 'minutes';
  static const second = 'second';
  static const seconds = 'seconds';
  static const millisecond = 'millisecond';
  static const milliseconds = 'milliseconds';
  static const microsecond = 'microsecond';
  static const microseconds = 'microseconds';
  static const week = 'week';
  static const weeks = 'weeks';
  static const quarter = 'quarter';
  static const quarters = 'quarters';
}

/// Factory for creating Hora from maps.
class HoraObject {
  HoraObject._();

  /// Creates a Hora from a map of date-time components.
  ///
  /// Supported keys:
  /// - `year` / `years`
  /// - `month` / `months` (1-12)
  /// - `day` / `days` / `date`
  /// - `hour` / `hours`
  /// - `minute` / `minutes`
  /// - `second` / `seconds`
  /// - `millisecond` / `milliseconds`
  /// - `microsecond` / `microseconds`
  static Hora from(Map<String, dynamic> map, {bool utc = false}) {
    final year = _getInt(map, [DateTimeKeys.year, DateTimeKeys.years]) ??
        DateTime.now().year;
    final month = _getInt(map, [DateTimeKeys.month, DateTimeKeys.months]) ?? 1;
    final day = _getInt(
          map,
          [DateTimeKeys.day, DateTimeKeys.days, DateTimeKeys.date],
        ) ??
        1;
    final hour = _getInt(map, [DateTimeKeys.hour, DateTimeKeys.hours]) ?? 0;
    final minute =
        _getInt(map, [DateTimeKeys.minute, DateTimeKeys.minutes]) ?? 0;
    final second =
        _getInt(map, [DateTimeKeys.second, DateTimeKeys.seconds]) ?? 0;
    final millisecond =
        _getInt(map, [DateTimeKeys.millisecond, DateTimeKeys.milliseconds]) ??
            0;
    final microsecond =
        _getInt(map, [DateTimeKeys.microsecond, DateTimeKeys.microseconds]) ??
            0;

    return Hora.of(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
      microsecond: microsecond,
      utc: utc,
    );
  }

  /// Creates a Hora from a map, returning null if the map is empty.
  static Hora? tryFrom(Map<String, dynamic>? map, {bool utc = false}) {
    if (map == null || map.isEmpty) return null;
    return from(map, utc: utc);
  }

  static int? _getInt(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value != null) {
        if (value is int) return value;
        if (value is num) return value.toInt();
        if (value is String) return int.tryParse(value);
      }
    }
    return null;
  }
}

/// Extension on [Hora] for object-based operations.
extension ObjectSupportExtension on Hora {
  /// Adds duration specified by a map.
  ///
  /// Supported keys:
  /// - `years`, `months`, `weeks`, `days`
  /// - `hours`, `minutes`, `seconds`
  /// - `milliseconds`, `microseconds`
  /// - `quarters`
  Hora addObject(Map<String, dynamic> map) {
    var result = this;

    // Process each key in order of magnitude
    final years = _getNum(map, [DateTimeKeys.year, DateTimeKeys.years]);
    if (years != null && years != 0) {
      result = result.add(years.toInt(), TemporalUnit.year);
    }

    final quarters =
        _getNum(map, [DateTimeKeys.quarter, DateTimeKeys.quarters]);
    if (quarters != null && quarters != 0) {
      result = result.add(quarters.toInt(), TemporalUnit.quarter);
    }

    final months = _getNum(map, [DateTimeKeys.month, DateTimeKeys.months]);
    if (months != null && months != 0) {
      result = result.add(months.toInt(), TemporalUnit.month);
    }

    final weeks = _getNum(map, [DateTimeKeys.week, DateTimeKeys.weeks]);
    if (weeks != null && weeks != 0) {
      result = result.add(weeks.toInt(), TemporalUnit.week);
    }

    final days =
        _getNum(map, [DateTimeKeys.day, DateTimeKeys.days, DateTimeKeys.date]);
    if (days != null && days != 0) {
      result = result.add(days.toInt(), TemporalUnit.day);
    }

    final hours = _getNum(map, [DateTimeKeys.hour, DateTimeKeys.hours]);
    if (hours != null && hours != 0) {
      result = result.add(hours.toInt(), TemporalUnit.hour);
    }

    final minutes = _getNum(map, [DateTimeKeys.minute, DateTimeKeys.minutes]);
    if (minutes != null && minutes != 0) {
      result = result.add(minutes.toInt(), TemporalUnit.minute);
    }

    final seconds = _getNum(map, [DateTimeKeys.second, DateTimeKeys.seconds]);
    if (seconds != null && seconds != 0) {
      result = result.add(seconds.toInt(), TemporalUnit.second);
    }

    final milliseconds =
        _getNum(map, [DateTimeKeys.millisecond, DateTimeKeys.milliseconds]);
    if (milliseconds != null && milliseconds != 0) {
      result = result.add(milliseconds.toInt(), TemporalUnit.millisecond);
    }

    final microseconds =
        _getNum(map, [DateTimeKeys.microsecond, DateTimeKeys.microseconds]);
    if (microseconds != null && microseconds != 0) {
      result = result.add(microseconds.toInt(), TemporalUnit.microsecond);
    }

    return result;
  }

  /// Subtracts duration specified by a map.
  Hora subtractObject(Map<String, dynamic> map) {
    // Negate all values
    final negated = <String, dynamic>{};
    for (final entry in map.entries) {
      final value = entry.value;
      if (value is num) {
        negated[entry.key] = -value;
      }
    }
    return addObject(negated);
  }

  /// Sets components specified by a map.
  ///
  /// Unlike [addObject], this sets absolute values rather than adding.
  Hora setObject(Map<String, dynamic> map) => copyWith(
        year: _getInt(map, [DateTimeKeys.year, DateTimeKeys.years]),
        month: _getInt(map, [DateTimeKeys.month, DateTimeKeys.months]),
        day: _getInt(
          map,
          [DateTimeKeys.day, DateTimeKeys.days, DateTimeKeys.date],
        ),
        hour: _getInt(map, [DateTimeKeys.hour, DateTimeKeys.hours]),
        minute: _getInt(map, [DateTimeKeys.minute, DateTimeKeys.minutes]),
        second: _getInt(map, [DateTimeKeys.second, DateTimeKeys.seconds]),
        millisecond:
            _getInt(map, [DateTimeKeys.millisecond, DateTimeKeys.milliseconds]),
        microsecond:
            _getInt(map, [DateTimeKeys.microsecond, DateTimeKeys.microseconds]),
      );

  /// Gets a component by name.
  ///
  /// Returns null if the key is not recognized.
  int? getByKey(String key) => switch (key.toLowerCase()) {
        'year' || 'years' => year,
        'month' || 'months' => month,
        'day' || 'days' || 'date' => day,
        'hour' || 'hours' => hour,
        'minute' || 'minutes' => minute,
        'second' || 'seconds' => second,
        'millisecond' || 'milliseconds' => millisecond,
        'microsecond' || 'microseconds' => microsecond,
        'weekday' => weekday,
        'quarter' || 'quarters' => quarter,
        'dayofyear' => dayOfYear,
        'isoweek' => isoWeek,
        'isoweekyear' => isoWeekYear,
        _ => null,
      };

  /// Sets a component by name.
  ///
  /// Returns this instance if the key is not recognized.
  Hora setByKey(String key, int value) => switch (key.toLowerCase()) {
        'year' || 'years' => copyWith(year: value),
        'month' || 'months' => copyWith(month: value),
        'day' || 'days' || 'date' => copyWith(day: value),
        'hour' || 'hours' => copyWith(hour: value),
        'minute' || 'minutes' => copyWith(minute: value),
        'second' || 'seconds' => copyWith(second: value),
        'millisecond' || 'milliseconds' => copyWith(millisecond: value),
        'microsecond' || 'microseconds' => copyWith(microsecond: value),
        _ => this,
      };

  num? _getNum(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value != null) {
        if (value is num) return value;
        if (value is String) return num.tryParse(value);
      }
    }
    return null;
  }

  int? _getInt(Map<String, dynamic> map, List<String> keys) =>
      _getNum(map, keys)?.toInt();
}
