/// Min/Max plugin for Hora.
///
/// Provides utilities for finding minimum and maximum dates.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/min_max.dart';
///
/// final dates = [
///   Hora.of(year: 2023, month: 1, day: 1),
///   Hora.of(year: 2023, month: 6, day: 15),
///   Hora.of(year: 2023, month: 12, day: 31),
/// ];
///
/// // Find min and max
/// final earliest = HoraMinMax.min(dates);
/// final latest = HoraMinMax.max(dates);
///
/// // Use extension methods
/// final minMax = dates.minMaxHora();
/// print(minMax.min); // January 1
/// print(minMax.max); // December 31
///
/// // Clamp to range
/// final clamped = someDate.clampBetween(start, end);
/// ```
library;

import '../hora.dart';

/// Result containing both min and max values.
class MinMaxResult {
  const MinMaxResult({
    required this.min,
    required this.max,
  });

  /// The minimum value.
  final Hora min;

  /// The maximum value.
  final Hora max;

  /// The span between min and max.
  Duration get span => Duration(
        milliseconds: max.unixMillis - min.unixMillis,
      );

  @override
  String toString() => 'MinMaxResult(min: $min, max: $max)';
}

/// Utility class for min/max operations on Hora.
class HoraMinMax {
  HoraMinMax._();

  /// Gets the minimum of two dates.
  static Hora min2(Hora a, Hora b) => a.isBefore(b) ? a : b;

  /// Gets the maximum of two dates.
  static Hora max2(Hora a, Hora b) => a.isAfter(b) ? a : b;

  /// Gets the minimum from a list of dates.
  ///
  /// Throws [StateError] if the list is empty.
  static Hora min(Iterable<Hora> dates) {
    if (dates.isEmpty) {
      throw StateError('Cannot find min of empty collection');
    }
    return dates.reduce(min2);
  }

  /// Gets the maximum from a list of dates.
  ///
  /// Throws [StateError] if the list is empty.
  static Hora max(Iterable<Hora> dates) {
    if (dates.isEmpty) {
      throw StateError('Cannot find max of empty collection');
    }
    return dates.reduce(max2);
  }

  /// Gets the minimum from a list, or null if empty.
  static Hora? minOrNull(Iterable<Hora> dates) {
    if (dates.isEmpty) return null;
    return dates.reduce(min2);
  }

  /// Gets the maximum from a list, or null if empty.
  static Hora? maxOrNull(Iterable<Hora> dates) {
    if (dates.isEmpty) return null;
    return dates.reduce(max2);
  }

  /// Gets both min and max from a list.
  ///
  /// Throws [StateError] if the list is empty.
  static MinMaxResult minMax(Iterable<Hora> dates) {
    if (dates.isEmpty) {
      throw StateError('Cannot find min/max of empty collection');
    }

    final iterator = dates.iterator..moveNext();
    var minVal = iterator.current;
    var maxVal = iterator.current;

    while (iterator.moveNext()) {
      final current = iterator.current;
      if (current.isBefore(minVal)) minVal = current;
      if (current.isAfter(maxVal)) maxVal = current;
    }

    return MinMaxResult(min: minVal, max: maxVal);
  }

  /// Gets both min and max, or null if empty.
  static MinMaxResult? minMaxOrNull(Iterable<Hora> dates) {
    if (dates.isEmpty) return null;
    return minMax(dates);
  }

  /// Clamps a date to be within a range.
  static Hora clamp(Hora value, Hora min, Hora max) {
    if (value.isBefore(min)) return min;
    if (value.isAfter(max)) return max;
    return value;
  }
}

/// Extension providing min/max operations for Hora.
extension MinMaxExt on Hora {
  /// Gets the earlier of this and another date.
  Hora min(Hora other) => HoraMinMax.min2(this, other);

  /// Gets the later of this and another date.
  Hora max(Hora other) => HoraMinMax.max2(this, other);

  /// Clamps this date to be within a range.
  Hora clampBetween(Hora min, Hora max) => HoraMinMax.clamp(this, min, max);

  /// Ensures this date is not before the minimum.
  Hora atLeast(Hora min) => isBefore(min) ? min : this;

  /// Ensures this date is not after the maximum.
  Hora atMost(Hora max) => isAfter(max) ? max : this;

  /// Checks if this date is within a range (inclusive).
  bool isWithin(Hora start, Hora end) => !isBefore(start) && !isAfter(end);

  /// Checks if this date is strictly within a range (exclusive).
  bool isStrictlyWithin(Hora start, Hora end) =>
      isAfter(start) && isBefore(end);
}

/// Extension providing min/max operations for `Iterable<Hora>`.
extension HoraIterableMinMaxExt on Iterable<Hora> {
  /// Gets the minimum date.
  Hora get minHora => HoraMinMax.min(this);

  /// Gets the maximum date.
  Hora get maxHora => HoraMinMax.max(this);

  /// Gets the minimum date or null if empty.
  Hora? get minHoraOrNull => HoraMinMax.minOrNull(this);

  /// Gets the maximum date or null if empty.
  Hora? get maxHoraOrNull => HoraMinMax.maxOrNull(this);

  /// Gets both min and max.
  MinMaxResult get minMaxHora => HoraMinMax.minMax(this);

  /// Gets both min and max or null if empty.
  MinMaxResult? get minMaxHoraOrNull => HoraMinMax.minMaxOrNull(this);

  /// Sorts this iterable chronologically.
  List<Hora> get sortedChronologically {
    final list = toList()..sort((a, b) => a.compareTo(b));
    return list;
  }

  /// Sorts this iterable reverse chronologically.
  List<Hora> get sortedReverseChronologically {
    final list = toList()..sort((a, b) => b.compareTo(a));
    return list;
  }

  /// Gets dates that fall within a range.
  Iterable<Hora> withinRange(Hora start, Hora end) =>
      where((h) => h.isWithin(start, end));

  /// Gets the span between the earliest and latest dates.
  Duration get span {
    final mm = minMaxHoraOrNull;
    if (mm == null) return Duration.zero;
    return mm.span;
  }

  /// Gets the median date.
  Hora? get medianHora {
    final sorted = sortedChronologically;
    if (sorted.isEmpty) return null;
    return sorted[sorted.length ~/ 2];
  }

  /// Groups dates by day.
  Map<String, List<Hora>> groupByDay() {
    final result = <String, List<Hora>>{};
    for (final h in this) {
      final key = h.format('YYYY-MM-DD');
      (result[key] ??= []).add(h);
    }
    return result;
  }

  /// Groups dates by month.
  Map<String, List<Hora>> groupByMonth() {
    final result = <String, List<Hora>>{};
    for (final h in this) {
      final key = h.format('YYYY-MM');
      (result[key] ??= []).add(h);
    }
    return result;
  }

  /// Groups dates by year.
  Map<int, List<Hora>> groupByYear() {
    final result = <int, List<Hora>>{};
    for (final h in this) {
      (result[h.year] ??= []).add(h);
    }
    return result;
  }
}

/// Extension for `List<Hora>` with in-place sorting.
extension HoraListMinMaxExt on List<Hora> {
  /// Sorts this list chronologically in-place.
  void sortChronologically() {
    sort((a, b) => a.compareTo(b));
  }

  /// Sorts this list reverse chronologically in-place.
  void sortReverseChronologically() {
    sort((a, b) => b.compareTo(a));
  }
}
