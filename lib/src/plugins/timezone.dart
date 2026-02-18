/// Timezone plugin for Hora.
///
/// Provides fixed-offset timezone parsing, instant-to-timezone projection,
/// and wall-clock reinterpretation utilities.
library;

import 'dart:collection';

import 'package:meta/meta.dart';

import '../hora.dart';

/// Represents a fixed-offset timezone.
@immutable
class HoraTimezone {
  const HoraTimezone._(this.offset, this._name);

  /// Creates a timezone from UTC offset hours and minutes.
  factory HoraTimezone.fromOffset(
    int hours, {
    int minutes = 0,
    String? name,
  }) {
    if (hours.abs() > 23) {
      throw ArgumentError.value(
        hours,
        'hours',
        'Timezone hour offset must be in -23..23.',
      );
    }
    if (minutes.abs() > 59) {
      throw ArgumentError.value(
        minutes,
        'minutes',
        'Timezone minute offset must be in -59..59.',
      );
    }
    if (hours != 0 &&
        minutes != 0 &&
        ((hours > 0 && minutes < 0) || (hours < 0 && minutes > 0))) {
      throw ArgumentError.value(
        minutes,
        'minutes',
        'Minute offset sign must match hour offset sign.',
      );
    }

    final totalMinutes = switch ((hours, minutes)) {
      (0, final m) => m,
      (final h, final m) when h < 0 => h * 60 - m.abs(),
      (final h, final m) => h * 60 + m.abs(),
    };

    return HoraTimezone.fromMinutes(totalMinutes, name: name);
  }

  /// Creates a timezone from total offset minutes.
  factory HoraTimezone.fromMinutes(int totalMinutes, {String? name}) {
    const maxOffsetMinutes = 23 * 60 + 59;
    if (totalMinutes.abs() > maxOffsetMinutes) {
      throw ArgumentError.value(
        totalMinutes,
        'totalMinutes',
        'Timezone offset must be in -1439..1439 minutes.',
      );
    }

    final offset = Duration(minutes: totalMinutes);
    return HoraTimezone._(offset, name ?? _nameFromOffset(offset));
  }

  /// Parses timezone text.
  ///
  /// Supported examples:
  /// - `Z`, `UTC`, `GMT`
  /// - `UTC+08`, `GMT-05:30`
  /// - `+08`, `-0530`, `+05:30`
  /// - Common abbreviations in [common], such as `JST`, `PST`, `CET`
  factory HoraTimezone.parse(String input) {
    final normalized = input.trim();
    if (normalized.isEmpty) {
      throw const FormatException('Invalid timezone format: empty input');
    }

    final upper = normalized.toUpperCase();
    if (upper == 'Z' || upper == 'UTC' || upper == 'GMT') {
      return utc;
    }

    final fromCommon = common[upper];
    if (fromCommon != null) {
      return fromCommon;
    }

    var core = upper;
    if (core.startsWith('UTC') || core.startsWith('GMT')) {
      core = core.substring(3).trim();
      if (core.isEmpty) return utc;
    }

    final compact = core.replaceAll(' ', '');
    final match =
        RegExp(r'^([+-])?(\d{1,2})(?::?(\d{2}))?$').firstMatch(compact);
    if (match == null) {
      throw FormatException('Invalid timezone format: $input');
    }

    final sign = match.group(1) == '-' ? -1 : 1;
    final hours = int.parse(match.group(2)!);
    final minutes = match.group(3) == null ? 0 : int.parse(match.group(3)!);

    if (hours > 23 || minutes > 59) {
      throw FormatException(
        'Invalid timezone format: $input. '
        'Hour must be 0..23 and minute must be 0..59.',
      );
    }

    return HoraTimezone.fromMinutes(
      sign * (hours * 60 + minutes),
      name: core.startsWith('+') || core.startsWith('-')
          ? _nameFromOffset(Duration(minutes: sign * (hours * 60 + minutes)))
          : null,
    );
  }

  /// Creates local system timezone at [at] instant (uses system/DST rules).
  factory HoraTimezone.local([DateTime? at]) {
    final dt = (at ?? DateTime.now()).toLocal();
    final name = dt.timeZoneName.trim();
    return HoraTimezone.fromMinutes(
      dt.timeZoneOffset.inMinutes,
      name: name.isEmpty ? null : name,
    );
  }

  /// Parses timezone text and returns null instead of throwing.
  static HoraTimezone? tryParse(String input) {
    try {
      return HoraTimezone.parse(input);
    } catch (_) {
      return null;
    }
  }

  /// UTC timezone.
  static const utc = HoraTimezone._(Duration.zero, 'UTC');

  /// Common timezone abbreviations (fixed offsets only, no IANA database).
  static final Map<String, HoraTimezone> common = UnmodifiableMapView({
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
    'IST': HoraTimezone.fromOffset(5, minutes: 30),
    'AEST': HoraTimezone.fromOffset(10),
    'AEDT': HoraTimezone.fromOffset(11),
    'CET': HoraTimezone.fromOffset(1),
    'CEST': HoraTimezone.fromOffset(2),
    'WET': HoraTimezone.utc,
    'WEST': HoraTimezone.fromOffset(1),
  });

  /// UTC offset.
  final Duration offset;

  final String _name;

  /// Display name or identifier.
  String get name => _name;

  /// Whether offset is UTC.
  bool get isUtc => offset == Duration.zero;

  /// Offset in hours (fractional if needed).
  double get offsetHours => offset.inMinutes / 60;

  /// Offset in minutes.
  int get offsetMinutes => offset.inMinutes;

  /// Formats offset as `+HH:mm`.
  String get offsetString {
    final hours = offset.inHours.abs();
    final minutes = offset.inMinutes.abs() % 60;
    final sign = offset.isNegative ? '-' : '+';
    return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  static String _nameFromOffset(Duration offset) {
    if (offset == Duration.zero) return 'UTC';

    final sign = offset.isNegative ? '-' : '+';
    final absOffset = offset.abs();
    final hours = absOffset.inHours;
    final minutes = absOffset.inMinutes % 60;

    if (minutes == 0) {
      return 'UTC$sign$hours';
    }
    return 'UTC$sign$hours:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HoraTimezone && offset == other.offset;

  @override
  int get hashCode => offset.hashCode;

  @override
  String toString() => name;
}

/// A timezone-aware view of an instant.
@immutable
class HoraZoned implements Comparable<HoraZoned> {
  HoraZoned(Hora instant, this.timezone)
      : instantUtc = (() {
          if (!instant.isValid) {
            throw ArgumentError.value(
              instant,
              'instant',
              'HoraZoned requires a valid Hora instant.',
            );
          }
          return instant.toUtc();
        })();

  /// The original instant normalized to UTC.
  final Hora instantUtc;

  /// The fixed-offset timezone used for wall-clock projection.
  final HoraTimezone timezone;

  DateTime get _wallClockUtcDateTime => DateTime.fromMicrosecondsSinceEpoch(
        instantUtc.unixMicros + timezone.offset.inMicroseconds,
        isUtc: true,
      );

  /// Wall-clock time in [timezone], represented as a UTC-based Hora container.
  Hora get wallClock => Hora.fromDateTime(
        _wallClockUtcDateTime,
        locale: instantUtc.locale,
      );

  int get year => _wallClockUtcDateTime.year;
  int get month => _wallClockUtcDateTime.month;
  int get day => _wallClockUtcDateTime.day;
  int get weekday => _wallClockUtcDateTime.weekday;
  int get hour => _wallClockUtcDateTime.hour;
  int get minute => _wallClockUtcDateTime.minute;
  int get second => _wallClockUtcDateTime.second;
  int get millisecond => _wallClockUtcDateTime.millisecond;
  int get microsecond => _wallClockUtcDateTime.microsecond;

  int get unix => instantUtc.unix;
  int get unixMillis => instantUtc.unixMillis;
  int get unixMicros => instantUtc.unixMicros;

  Duration get utcOffset => timezone.offset;

  /// Same instant in another timezone.
  HoraZoned withTimezone(HoraTimezone tz) => HoraZoned(instantUtc, tz);

  /// Reinterprets current wall-clock as belonging to [targetTimezone].
  ///
  /// This changes the underlying instant.
  Hora reinterpretAs(HoraTimezone targetTimezone) {
    final wallMicros = _wallClockUtcDateTime.microsecondsSinceEpoch;
    final reinterpretedMicros =
        wallMicros - targetTimezone.offset.inMicroseconds;
    return Hora.fromTimestamp(
      reinterpretedMicros,
      locale: instantUtc.locale,
      utc: true,
      unit: UnixTimestampUnit.microseconds,
    );
  }

  /// Formats wall-clock time using Hora tokens and target timezone offset.
  String format([String pattern = 'YYYY-MM-DDTHH:mm:ssZ']) {
    final transformed = _injectOffsetPlaceholders(pattern);
    final rendered = wallClock.format(transformed);
    return rendered
        .replaceAll(_offsetTokenColonMarker, timezone.offsetString)
        .replaceAll(
          _offsetTokenCompactMarker,
          timezone.offsetString.replaceAll(':', ''),
        );
  }

  /// ISO 8601 output with timezone offset, e.g. `2024-03-15T21:00:00+09:00`.
  String toIso8601String() {
    final dt = _wallClockUtcDateTime;
    final year = dt.year.toString().padLeft(4, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    final second = dt.second.toString().padLeft(2, '0');
    final micros =
        (dt.millisecond * 1000 + dt.microsecond).toString().padLeft(6, '0');
    return '$year-$month-$day'
        'T$hour:$minute:$second.$micros'
        '${timezone.offsetString}';
  }

  static const _offsetTokenColonMarker = '__hora_tz_offset_colon__';
  static const _offsetTokenCompactMarker = '__hora_tz_offset_compact__';

  static String _injectOffsetPlaceholders(String pattern) {
    final buffer = StringBuffer();
    var i = 0;
    while (i < pattern.length) {
      final char = pattern[i];
      if (char == '[') {
        final end = pattern.indexOf(']', i + 1);
        if (end == -1) {
          buffer.write(pattern.substring(i));
          break;
        }
        buffer.write(pattern.substring(i, end + 1));
        i = end + 1;
        continue;
      }

      if (pattern.startsWith('ZZ', i)) {
        buffer.write('[$_offsetTokenCompactMarker]');
        i += 2;
        continue;
      }
      if (pattern.startsWith('Z', i)) {
        buffer.write('[$_offsetTokenColonMarker]');
        i += 1;
        continue;
      }

      buffer.write(char);
      i += 1;
    }
    return buffer.toString();
  }

  @override
  int compareTo(HoraZoned other) => instantUtc.compareTo(other.instantUtc);

  @override
  String toString() => toIso8601String();
}

/// Extension providing timezone operations for [Hora].
extension TimezoneExt on Hora {
  /// UTC offset of this Hora based on UTC/local mode.
  Duration get utcOffset {
    if (!isValid) return Duration.zero;
    return isUtc ? Duration.zero : toDateTime().timeZoneOffset;
  }

  /// Timezone name of this Hora based on UTC/local mode.
  String get timezoneName {
    if (!isValid) return 'Invalid';
    return isUtc ? 'UTC' : toDateTime().timeZoneName;
  }

  /// Current timezone descriptor for this Hora instance.
  HoraTimezone get timezone {
    if (!isValid) return HoraTimezone.fromMinutes(0, name: 'Invalid');
    return isUtc
        ? HoraTimezone.utc
        : HoraTimezone.fromMinutes(
            utcOffset.inMinutes,
            name: timezoneName.trim().isEmpty ? null : timezoneName,
          );
  }

  /// Projects this instant into [tz] as a timezone-aware wall-clock view.
  HoraZoned inTimezone(HoraTimezone tz) => HoraZoned(this, tz);

  /// Reinterprets this wall-clock into [targetTimezone], changing instant.
  Hora reinterpretTimezone(HoraTimezone targetTimezone) {
    if (!isValid) return this;
    final newMicros = unixMicros +
        utcOffset.inMicroseconds -
        targetTimezone.offset.inMicroseconds;
    return Hora.fromTimestamp(
      newMicros,
      locale: locale,
      utc: true,
      unit: UnixTimestampUnit.microseconds,
    );
  }

  /// Time difference from current timezone to [tz].
  Duration timezoneDifference(HoraTimezone tz) =>
      isValid ? tz.offset - utcOffset : Duration.zero;

  /// Full wall-clock projection in [tz].
  ({
    int year,
    int month,
    int day,
    int hour,
    int minute,
    int second,
    int millisecond,
    int microsecond,
  }) wallClockIn(HoraTimezone tz) {
    final zoned = inTimezone(tz);
    return (
      year: zoned.year,
      month: zoned.month,
      day: zoned.day,
      hour: zoned.hour,
      minute: zoned.minute,
      second: zoned.second,
      millisecond: zoned.millisecond,
      microsecond: zoned.microsecond,
    );
  }
}

/// Creates a timezone-projected view from UTC milliseconds.
HoraZoned horaFromUtcMilliseconds(
  int milliseconds, {
  HoraTimezone timezone = HoraTimezone.utc,
}) {
  final utc = Hora.fromTimestamp(
    milliseconds,
    utc: true,
    unit: UnixTimestampUnit.milliseconds,
  );
  return utc.inTimezone(timezone);
}

/// Creates a timezone-projected view for the current instant.
HoraZoned horaNowIn(HoraTimezone timezone) => Hora.now().inTimezone(timezone);

/// Represents a time range in a fixed timezone wall-clock space.
class TimezoneRange {
  TimezoneRange({
    required this.start,
    required this.end,
    required this.timezone,
  }) {
    if (start.timezone != timezone || end.timezone != timezone) {
      throw ArgumentError(
        'start/end timezone must match range timezone.',
      );
    }
    if (end.instantUtc.isBefore(start.instantUtc)) {
      throw ArgumentError(
        'Range end must be the same as or after start instant.',
      );
    }
  }

  final HoraZoned start;
  final HoraZoned end;
  final HoraTimezone timezone;

  /// Duration between instants.
  Duration get duration => end.instantUtc.difference(start.instantUtc);

  /// Checks if [time] is within the wall-clock range in [timezone].
  bool contains(Hora time) {
    if (!time.isValid) return false;
    final wall = time.inTimezone(timezone).wallClock;
    return !wall.isBefore(start.wallClock) && !wall.isAfter(end.wallClock);
  }

  /// Converts this range to another timezone view while preserving instants.
  TimezoneRange inTimezone(HoraTimezone tz) => TimezoneRange(
        start: start.withTimezone(tz),
        end: end.withTimezone(tz),
        timezone: tz,
      );

  @override
  String toString() =>
      'TimezoneRange(${start.toIso8601String()} - ${end.toIso8601String()}, ${timezone.name})';
}
