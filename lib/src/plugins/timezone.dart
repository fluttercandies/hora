/// Timezone plugin for Hora.
///
/// Provides timezone conversion and awareness.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/timezone.dart';
///
/// // Create a timezone
/// final nyc = HoraTimezone.fromOffset(-5);
/// final tokyo = HoraTimezone.fromOffset(9);
///
/// // Convert between timezones
/// final now = Hora.now();
/// final nycTime = now.inTimezone(nyc);
/// final tokyoTime = now.inTimezone(tokyo);
///
/// // Get timezone offset
/// print(now.utcOffset); // e.g., Duration(hours: -8)
/// ```
///
/// Note: This is a simplified timezone implementation.
/// For full timezone database support, consider using
/// the `timezone` package.
library;

import 'package:meta/meta.dart';

import '../hora.dart';

/// Represents a timezone with a fixed UTC offset.
///
/// This is a simplified representation. For full timezone
/// support with DST handling, use the `timezone` package.
@immutable
class HoraTimezone {
  const HoraTimezone._(this.offset, this._name);

  /// Creates a timezone from a UTC offset in hours.
  factory HoraTimezone.fromOffset(int hours, [int minutes = 0]) {
    final offset = Duration(hours: hours, minutes: minutes);
    final sign = hours >= 0 ? '+' : '';
    final name = minutes == 0
        ? 'UTC$sign$hours'
        : 'UTC$sign$hours:${minutes.abs().toString().padLeft(2, '0')}';
    return HoraTimezone._(offset, name);
  }

  /// Creates a timezone from a total offset in minutes.
  factory HoraTimezone.fromMinutes(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes.abs() % 60;
    return HoraTimezone.fromOffset(hours, minutes);
  }

  /// Parses a timezone string like "+05:30" or "-08:00".
  factory HoraTimezone.parse(String input) {
    final pattern = RegExp(r'^([+-]?)(\d{1,2}):?(\d{2})?$');
    final match = pattern.firstMatch(input.trim());
    if (match == null) {
      throw FormatException('Invalid timezone format: $input');
    }

    final sign = match.group(1) == '-' ? -1 : 1;
    final hours = int.parse(match.group(2)!) * sign;
    final minutes = match.group(3) != null ? int.parse(match.group(3)!) : 0;

    return HoraTimezone.fromOffset(hours, minutes);
  }

  /// UTC timezone.
  static const utc = HoraTimezone._(Duration.zero, 'UTC');

  /// Common timezone abbreviations (simplified, no DST).
  static final Map<String, HoraTimezone> common = {
    'UTC': utc,
    'GMT': utc,
    'EST': HoraTimezone.fromOffset(-5),
    'EDT': HoraTimezone.fromOffset(-4),
    'CST': HoraTimezone.fromOffset(-6),
    'CDT': HoraTimezone.fromOffset(-5),
    'MST': HoraTimezone.fromOffset(-7),
    'MDT': HoraTimezone.fromOffset(-6),
    'PST': HoraTimezone.fromOffset(-8),
    'PDT': HoraTimezone.fromOffset(-7),
    'JST': HoraTimezone.fromOffset(9),
    'KST': HoraTimezone.fromOffset(9),
    'CST_CN': HoraTimezone.fromOffset(8),
    'IST': HoraTimezone.fromOffset(5, 30),
    'AEST': HoraTimezone.fromOffset(10),
    'AEDT': HoraTimezone.fromOffset(11),
    'CET': HoraTimezone.fromOffset(1),
    'CEST': HoraTimezone.fromOffset(2),
    'WET': HoraTimezone.fromOffset(0),
    'WEST': HoraTimezone.fromOffset(1),
  };

  /// The UTC offset.
  final Duration offset;

  final String _name;

  /// The timezone name/identifier.
  String get name => _name;

  /// The offset in hours (may be fractional).
  double get offsetHours => offset.inMinutes / 60;

  /// The offset in minutes.
  int get offsetMinutes => offset.inMinutes;

  /// Formats the offset as a string like "+05:30".
  String get offsetString {
    final hours = offset.inHours.abs();
    final minutes = offset.inMinutes.abs() % 60;
    final sign = offset.isNegative ? '-' : '+';
    return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HoraTimezone && offset == other.offset;

  @override
  int get hashCode => offset.hashCode;

  @override
  String toString() => name;
}

/// Extension providing timezone operations for Hora.
extension TimezoneExt on Hora {
  /// Gets the UTC offset of this date.
  Duration get utcOffset {
    if (isUtc) return Duration.zero;
    return toDateTime().timeZoneOffset;
  }

  /// Gets the timezone name of this date.
  String get timezoneName {
    if (isUtc) return 'UTC';
    return toDateTime().timeZoneName;
  }

  /// Converts this date to UTC.
  Hora toUtc() {
    if (isUtc) return this;
    return Hora.fromDateTime(toDateTime().toUtc(), locale: locale);
  }

  /// Converts this date to local time.
  Hora toLocal() {
    if (!isUtc) return this;
    return Hora.fromDateTime(toDateTime().toLocal(), locale: locale);
  }

  /// Converts this date to a specific timezone.
  Hora inTimezone(HoraTimezone tz) {
    // First convert to UTC
    final utcTime = isUtc ? this : toUtc();

    // Then apply the target timezone offset
    final targetMs = utcTime.unixMillis + tz.offset.inMilliseconds;
    final dt = DateTime.fromMillisecondsSinceEpoch(targetMs, isUtc: true);

    return Hora.of(
      year: dt.year,
      month: dt.month,
      day: dt.day,
      hour: dt.hour,
      minute: dt.minute,
      second: dt.second,
      millisecond: dt.millisecond,
      utc: true,
      locale: locale,
    );
  }

  /// Creates a Hora with the same local time but in a different timezone.
  ///
  /// This doesn't convert the time, it reinterprets it.
  Hora withTimezone(HoraTimezone tz) {
    // Create the same wall clock time but offset by timezone
    final localMs = unixMillis;
    final currentOffset = isUtc ? Duration.zero : utcOffset;
    final newMs =
        localMs - currentOffset.inMilliseconds + tz.offset.inMilliseconds;

    return Hora.unixMillis(newMs, locale: locale);
  }

  /// Gets the timezone offset in hours.
  double get offsetHours => utcOffset.inMinutes / 60;

  /// Gets the timezone offset formatted as a string.
  String get offsetString {
    final offset = utcOffset;
    final hours = offset.inHours.abs();
    final minutes = offset.inMinutes.abs() % 60;
    final sign = offset.isNegative ? '-' : '+';
    return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Checks if this is in the same timezone as another date.
  bool isSameTimezone(Hora other) => utcOffset == other.utcOffset;

  /// Gets the time difference to another timezone.
  Duration timezoneDifference(HoraTimezone tz) => tz.offset - utcOffset;

  /// Gets the wall clock time in another timezone.
  ///
  /// Returns only the time components (hour, minute, second) as a record.
  ({int hour, int minute, int second}) wallClockIn(HoraTimezone tz) {
    final converted = inTimezone(tz);
    return (
      hour: converted.hour,
      minute: converted.minute,
      second: converted.second,
    );
  }
}

/// Extension for creating timezone-aware Hora instances.
extension TimezoneConstructorExt on Hora {
  /// Creates a Hora from UTC milliseconds with timezone info.
  static Hora fromUtcMilliseconds(
    int milliseconds, {
    HoraTimezone timezone = HoraTimezone.utc,
  }) {
    final utc = Hora.unixMillis(milliseconds);
    return utc.inTimezone(timezone);
  }

  /// Creates a Hora representing "now" in a specific timezone.
  static Hora nowIn(HoraTimezone timezone) => Hora.now().inTimezone(timezone);
}

/// Represents a time range with timezone awareness.
class TimezoneRange {
  const TimezoneRange({
    required this.start,
    required this.end,
    required this.timezone,
  });

  final Hora start;
  final Hora end;
  final HoraTimezone timezone;

  /// Gets the duration of this range.
  Duration get duration => Duration(
        milliseconds: end.unixMillis - start.unixMillis,
      );

  /// Checks if a time falls within this range.
  bool contains(Hora time) {
    final tzTime = time.inTimezone(timezone);
    return !tzTime.isBefore(start) && !tzTime.isAfter(end);
  }

  /// Converts this range to a different timezone.
  TimezoneRange inTimezone(HoraTimezone tz) => TimezoneRange(
        start: start.inTimezone(tz),
        end: end.inTimezone(tz),
        timezone: tz,
      );

  @override
  String toString() => 'TimezoneRange($start - $end, ${timezone.name})';
}
