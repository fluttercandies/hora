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

/// Type-safe fields for component reads.
enum HoraGetField {
  year,
  month,
  day,
  hour,
  minute,
  second,
  millisecond,
  microsecond,
  weekday,
  quarter,
  dayOfYear,
  isoWeek,
  isoWeekYear,
}

/// Type-safe fields for component writes.
enum HoraSetField {
  year,
  month,
  day,
  hour,
  minute,
  second,
  millisecond,
  microsecond,
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
  static Hora from(Map<String, Object?> map, {bool utc = false}) {
    final source = Map<String, Object?>.from(map);
    _convertLegacyDateAlias(source);
    return Hora.fromMap(source, utc: utc);
  }

  /// Creates a Hora from a map, returning null if the map is empty.
  static Hora? tryFrom(Map<String, Object?>? map, {bool utc = false}) {
    if (map == null || map.isEmpty) return null;
    final source = Map<String, Object?>.from(map);
    _convertLegacyDateAlias(source);
    return Hora.tryFrom(source, utc: utc);
  }

  static void _convertLegacyDateAlias(Map<String, Object?> source) {
    if (source.containsKey(DateTimeKeys.day) ||
        source.containsKey(DateTimeKeys.days) ||
        !source.containsKey(DateTimeKeys.date)) {
      return;
    }
    final numericDay = _toInt(source[DateTimeKeys.date]);
    if (numericDay == null) return;
    source[DateTimeKeys.day] = numericDay;
    source.remove(DateTimeKeys.date);
  }

  static int? _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) {
      if (value is double && !value.isFinite) return null;
      final intValue = value.toInt();
      if (value != intValue) return null;
      return intValue;
    }
    if (value is String) return int.tryParse(value.trim());
    return null;
  }
}

/// Extension on [Hora] for object-based operations.
extension ObjectSupportExtension on Hora {
  static const _deltaFields = <_ObjectDeltaField>[
    _ObjectDeltaField(
      TemporalUnit.year,
      [DateTimeKeys.year, DateTimeKeys.years],
    ),
    _ObjectDeltaField(TemporalUnit.quarter, [
      DateTimeKeys.quarter,
      DateTimeKeys.quarters,
    ]),
    _ObjectDeltaField(
      TemporalUnit.month,
      [DateTimeKeys.month, DateTimeKeys.months],
    ),
    _ObjectDeltaField(
      TemporalUnit.week,
      [DateTimeKeys.week, DateTimeKeys.weeks],
    ),
    _ObjectDeltaField(TemporalUnit.day, [
      DateTimeKeys.day,
      DateTimeKeys.days,
      DateTimeKeys.date,
    ]),
    _ObjectDeltaField(
      TemporalUnit.hour,
      [DateTimeKeys.hour, DateTimeKeys.hours],
    ),
    _ObjectDeltaField(TemporalUnit.minute, [
      DateTimeKeys.minute,
      DateTimeKeys.minutes,
    ]),
    _ObjectDeltaField(TemporalUnit.second, [
      DateTimeKeys.second,
      DateTimeKeys.seconds,
    ]),
    _ObjectDeltaField(TemporalUnit.millisecond, [
      DateTimeKeys.millisecond,
      DateTimeKeys.milliseconds,
    ]),
    _ObjectDeltaField(TemporalUnit.microsecond, [
      DateTimeKeys.microsecond,
      DateTimeKeys.microseconds,
    ]),
  ];
  static const Set<String> _deltaSupportedKeys = {
    DateTimeKeys.year,
    DateTimeKeys.years,
    DateTimeKeys.quarter,
    DateTimeKeys.quarters,
    DateTimeKeys.month,
    DateTimeKeys.months,
    DateTimeKeys.week,
    DateTimeKeys.weeks,
    DateTimeKeys.day,
    DateTimeKeys.days,
    DateTimeKeys.date,
    DateTimeKeys.hour,
    DateTimeKeys.hours,
    DateTimeKeys.minute,
    DateTimeKeys.minutes,
    DateTimeKeys.second,
    DateTimeKeys.seconds,
    DateTimeKeys.millisecond,
    DateTimeKeys.milliseconds,
    DateTimeKeys.microsecond,
    DateTimeKeys.microseconds,
  };
  static const Set<String> _setSupportedKeys = {
    DateTimeKeys.year,
    DateTimeKeys.years,
    DateTimeKeys.month,
    DateTimeKeys.months,
    DateTimeKeys.day,
    DateTimeKeys.days,
    DateTimeKeys.date,
    DateTimeKeys.hour,
    DateTimeKeys.hours,
    DateTimeKeys.minute,
    DateTimeKeys.minutes,
    DateTimeKeys.second,
    DateTimeKeys.seconds,
    DateTimeKeys.millisecond,
    DateTimeKeys.milliseconds,
    DateTimeKeys.microsecond,
    DateTimeKeys.microseconds,
  };

  /// Adds duration specified by a map.
  ///
  /// Supported keys:
  /// - `years`, `months`, `weeks`, `days`
  /// - `hours`, `minutes`, `seconds`
  /// - `milliseconds`, `microseconds`
  /// - `quarters`
  Hora addObject(Map<String, Object?> map) => _applyObjectDelta(map);

  /// Subtracts duration specified by a map.
  Hora subtractObject(Map<String, Object?> map) =>
      _applyObjectDelta(map, subtract: true);

  /// Sets components specified by a map.
  ///
  /// Unlike [addObject], this sets absolute values rather than adding.
  Hora setObject(Map<String, Object?> map) {
    final normalized = _normalizeObjectMap(
      map,
      supportedKeys: _setSupportedKeys,
      operation: 'setObject',
    );
    return copyWith(
      year: _readInt(normalized, [DateTimeKeys.year, DateTimeKeys.years]),
      month: _readInt(normalized, [DateTimeKeys.month, DateTimeKeys.months]),
      day: _readInt(
        normalized,
        [DateTimeKeys.day, DateTimeKeys.days, DateTimeKeys.date],
      ),
      hour: _readInt(normalized, [DateTimeKeys.hour, DateTimeKeys.hours]),
      minute: _readInt(
        normalized,
        [DateTimeKeys.minute, DateTimeKeys.minutes],
      ),
      second: _readInt(
        normalized,
        [DateTimeKeys.second, DateTimeKeys.seconds],
      ),
      millisecond: _readInt(
        normalized,
        [DateTimeKeys.millisecond, DateTimeKeys.milliseconds],
      ),
      microsecond: _readInt(
        normalized,
        [DateTimeKeys.microsecond, DateTimeKeys.microseconds],
      ),
    );
  }

  /// Gets a component by name.
  ///
  /// Throws [ArgumentError] if [key] is not recognized.
  int getByKey(String key) {
    final field = _parseGetField(key);
    if (field == null) {
      throw ArgumentError.value(
        key,
        'key',
        'Unsupported field name.',
      );
    }
    return getByField(field);
  }

  /// Gets a component using a type-safe field.
  int getByField(HoraGetField field) => switch (field) {
        HoraGetField.year => year,
        HoraGetField.month => month,
        HoraGetField.day => day,
        HoraGetField.hour => hour,
        HoraGetField.minute => minute,
        HoraGetField.second => second,
        HoraGetField.millisecond => millisecond,
        HoraGetField.microsecond => microsecond,
        HoraGetField.weekday => weekday,
        HoraGetField.quarter => quarter,
        HoraGetField.dayOfYear => dayOfYear,
        HoraGetField.isoWeek => isoWeek,
        HoraGetField.isoWeekYear => isoWeekYear,
      };

  /// Sets a component by name.
  ///
  /// Throws [ArgumentError] if [key] is not recognized.
  Hora setByKey(String key, int value) {
    final field = _parseSetField(key);
    if (field == null) {
      throw ArgumentError.value(
        key,
        'key',
        'Unsupported field name.',
      );
    }
    return setByField(field, value);
  }

  /// Sets a component using a type-safe field.
  Hora setByField(HoraSetField field, int value) => switch (field) {
        HoraSetField.year => copyWith(year: value),
        HoraSetField.month => copyWith(month: value),
        HoraSetField.day => copyWith(day: value),
        HoraSetField.hour => copyWith(hour: value),
        HoraSetField.minute => copyWith(minute: value),
        HoraSetField.second => copyWith(second: value),
        HoraSetField.millisecond => copyWith(millisecond: value),
        HoraSetField.microsecond => copyWith(microsecond: value),
      };

  Hora _applyObjectDelta(Map<String, Object?> map, {bool subtract = false}) {
    final normalized = _normalizeObjectMap(
      map,
      supportedKeys: _deltaSupportedKeys,
      operation: subtract ? 'subtractObject' : 'addObject',
    );
    var result = this;
    for (final field in _deltaFields) {
      final amount = _readInt(normalized, field.keys);
      if (amount == null || amount == 0) {
        continue;
      }
      result = subtract
          ? result.subtract(amount, field.unit)
          : result.add(amount, field.unit);
    }
    return result;
  }

  Map<String, Object?> _normalizeObjectMap(
    Map<String, Object?> map, {
    required Set<String> supportedKeys,
    required String operation,
  }) {
    final normalized = <String, Object?>{};
    final firstOriginalKey = <String, String>{};
    for (final entry in map.entries) {
      final canonical = _canonicalKey(entry.key);
      if (!normalized.containsKey(canonical)) {
        normalized[canonical] = entry.value;
        firstOriginalKey[canonical] = entry.key;
        continue;
      }

      final existing = normalized[canonical];
      if (!_rawValueEqual(existing, entry.value)) {
        throw ArgumentError.value(
          entry.value,
          entry.key,
          'Conflicting values for key "$canonical" '
          'from "${firstOriginalKey[canonical]}" and "${entry.key}".',
        );
      }
    }

    final unknownKeys = normalized.keys
        .where((key) => !supportedKeys.contains(key))
        .toList()
      ..sort();
    if (unknownKeys.isNotEmpty) {
      throw ArgumentError.value(
        normalized,
        operation,
        'Unsupported key(s): ${unknownKeys.join(', ')}.',
      );
    }

    return normalized;
  }

  int? _readInt(Map<String, Object?> map, List<String> keys) {
    var hasValue = false;
    int? resolved;
    for (final key in keys) {
      if (!map.containsKey(key)) continue;
      final parsed = _toInt(map[key]);
      if (parsed == null) {
        throw ArgumentError.value(
          map[key],
          key,
          'Expected an integer value.',
        );
      }
      if (hasValue && resolved != parsed) {
        throw ArgumentError.value(
          map[key],
          key,
          'Conflicting integer values for alias keys ${keys.join(', ')}.',
        );
      }
      hasValue = true;
      resolved = parsed;
    }
    return hasValue ? resolved : null;
  }

  bool _rawValueEqual(Object? left, Object? right) {
    if (identical(left, right)) return true;
    if (left == null || right == null) return false;

    final leftInt = _toInt(left);
    final rightInt = _toInt(right);
    if (leftInt != null && rightInt != null) {
      return leftInt == rightInt;
    }

    if (left is String && right is String) {
      return left.trim() == right.trim();
    }

    return left == right;
  }

  int? _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) {
      if (value is double && !value.isFinite) return null;
      final intValue = value.toInt();
      if (value != intValue) return null;
      return intValue;
    }
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  String _canonicalKey(String key) =>
      key.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');

  HoraGetField? _parseGetField(String key) => switch (_canonicalKey(key)) {
        'year' || 'years' => HoraGetField.year,
        'month' || 'months' => HoraGetField.month,
        'day' || 'days' || 'date' => HoraGetField.day,
        'hour' || 'hours' => HoraGetField.hour,
        'minute' || 'minutes' => HoraGetField.minute,
        'second' || 'seconds' => HoraGetField.second,
        'millisecond' || 'milliseconds' => HoraGetField.millisecond,
        'microsecond' || 'microseconds' => HoraGetField.microsecond,
        'weekday' => HoraGetField.weekday,
        'quarter' || 'quarters' => HoraGetField.quarter,
        'dayofyear' => HoraGetField.dayOfYear,
        'isoweek' => HoraGetField.isoWeek,
        'isoweekyear' => HoraGetField.isoWeekYear,
        _ => null,
      };

  HoraSetField? _parseSetField(String key) => switch (_canonicalKey(key)) {
        'year' || 'years' => HoraSetField.year,
        'month' || 'months' => HoraSetField.month,
        'day' || 'days' || 'date' => HoraSetField.day,
        'hour' || 'hours' => HoraSetField.hour,
        'minute' || 'minutes' => HoraSetField.minute,
        'second' || 'seconds' => HoraSetField.second,
        'millisecond' || 'milliseconds' => HoraSetField.millisecond,
        'microsecond' || 'microseconds' => HoraSetField.microsecond,
        _ => null,
      };
}

class _ObjectDeltaField {
  const _ObjectDeltaField(this.unit, this.keys);

  final TemporalUnit unit;
  final List<String> keys;
}
