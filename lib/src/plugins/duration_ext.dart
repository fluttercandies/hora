/// Duration extension plugin for Hora.
///
/// Provides enhanced duration manipulation and formatting.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/duration_ext.dart';
///
/// // Create durations
/// final d = HoraDurationExt.fromHours(2.5);
/// print(d.humanize()); // "2 hours and 30 minutes"
///
/// // Parse duration strings
/// final d2 = HoraDurationExt.parse('P1DT2H30M');
/// print(d2.totalHours); // 26.5
///
/// // Format durations
/// print(d.format('HH:mm:ss')); // "02:30:00"
/// ```
library;

import '../duration.dart';
import '../hora.dart';
import '../units.dart';

/// Extended duration utilities.
extension HoraDurationExtUtils on HoraDuration {
  /// Formats the duration as a human-readable string.
  String humanize({bool precise = false}) {
    if (isZero) return '0 seconds';

    final parts = <String>[];

    if (years > 0) {
      parts.add('$years ${years == 1 ? 'year' : 'years'}');
    }
    if (months > 0) {
      parts.add('$months ${months == 1 ? 'month' : 'months'}');
    }
    if (weeks > 0 && !precise) {
      parts.add('$weeks ${weeks == 1 ? 'week' : 'weeks'}');
    } else if (days > 0) {
      parts.add('$days ${days == 1 ? 'day' : 'days'}');
    }
    if (hours > 0) {
      parts.add('$hours ${hours == 1 ? 'hour' : 'hours'}');
    }
    if (minutes > 0) {
      parts.add('$minutes ${minutes == 1 ? 'minute' : 'minutes'}');
    }
    if (seconds > 0 || parts.isEmpty) {
      parts.add('$seconds ${seconds == 1 ? 'second' : 'seconds'}');
    }

    if (parts.length == 1) return parts.first;
    if (parts.length == 2) return '${parts[0]} and ${parts[1]}';

    final last = parts.removeLast();
    return '${parts.join(', ')}, and $last';
  }

  /// Formats the duration with a custom format string.
  ///
  /// Supported tokens:
  /// - `Y` or `YY` - Years
  /// - `M` or `MM` - Months
  /// - `D` or `DD` - Days
  /// - `H` or `HH` - Hours
  /// - `m` or `mm` - Minutes
  /// - `s` or `ss` - Seconds
  String format(String formatStr) {
    var result = formatStr;

    // Calculate total values (kept for potential future use)
    // final totalDays = this.days + (weeks * 7) + (months * 30) + (years * 365);
    // final totalHours = hours + (totalDays * 24);
    // final totalMinutes = minutes + (totalHours * 60);
    // final totalSeconds = seconds + (totalMinutes * 60);

    // Replace tokens
    result = result.replaceAll('YY', years.toString().padLeft(2, '0'));
    result = result.replaceAll('Y', years.toString());

    result = result.replaceAll('MM', months.toString().padLeft(2, '0'));
    result = result.replaceAll('M', months.toString());

    result = result.replaceAll('DD', days.toString().padLeft(2, '0'));
    result = result.replaceAll('D', days.toString());

    result = result.replaceAll('HH', hours.toString().padLeft(2, '0'));
    result = result.replaceAll('H', hours.toString());

    result = result.replaceAll('mm', minutes.toString().padLeft(2, '0'));
    result = result.replaceAll('m', minutes.toString());

    result = result.replaceAll('ss', seconds.toString().padLeft(2, '0'));
    result = result.replaceAll('s', seconds.toString());

    return result;
  }

  /// Gets the total hours including all larger units.
  double get totalHours {
    final totalMs = inMilliseconds;
    return totalMs / (1000 * 60 * 60);
  }

  /// Gets the total minutes including all larger units.
  double get totalMinutes {
    final totalMs = inMilliseconds;
    return totalMs / (1000 * 60);
  }

  /// Gets the total seconds including all larger units.
  double get totalSeconds {
    final totalMs = inMilliseconds;
    return totalMs / 1000;
  }

  /// Gets the total days including all larger units.
  double get totalDays {
    final totalMs = inMilliseconds;
    return totalMs / (1000 * 60 * 60 * 24);
  }

  /// Checks if the duration is zero.
  bool get isZero => inMilliseconds == 0;

  /// Checks if the duration is negative.
  bool get isNegative => inMilliseconds < 0;

  /// Gets the absolute value of this duration.
  HoraDuration get abs => isNegative ? negate() : this;

  /// Negates this duration.
  HoraDuration negate() => HoraDuration(
        years: -years,
        months: -months,
        weeks: -weeks,
        days: -days,
        hours: -hours,
        minutes: -minutes,
        seconds: -seconds,
        milliseconds: -milliseconds,
      );

  /// Multiplies this duration by a scalar.
  HoraDuration operator *(num factor) => HoraDuration(
        years: (years * factor).round(),
        months: (months * factor).round(),
        weeks: (weeks * factor).round(),
        days: (days * factor).round(),
        hours: (hours * factor).round(),
        minutes: (minutes * factor).round(),
        seconds: (seconds * factor).round(),
        milliseconds: (milliseconds * factor).round(),
      );

  /// Divides this duration by a scalar.
  HoraDuration operator /(num divisor) => this * (1 / divisor);

  /// Adds two durations.
  HoraDuration operator +(HoraDuration other) => HoraDuration(
        years: years + other.years,
        months: months + other.months,
        weeks: weeks + other.weeks,
        days: days + other.days,
        hours: hours + other.hours,
        minutes: minutes + other.minutes,
        seconds: seconds + other.seconds,
        milliseconds: milliseconds + other.milliseconds,
      );

  /// Subtracts two durations.
  HoraDuration operator -(HoraDuration other) => HoraDuration(
        years: years - other.years,
        months: months - other.months,
        weeks: weeks - other.weeks,
        days: days - other.days,
        hours: hours - other.hours,
        minutes: minutes - other.minutes,
        seconds: seconds - other.seconds,
        milliseconds: milliseconds - other.milliseconds,
      );

  /// Converts to a Dart [Duration].
  Duration toDartDuration() => Duration(milliseconds: inMilliseconds);
}

/// Factory methods for creating durations.
extension HoraDurationFactoryExt on HoraDuration {
  /// Creates a duration from hours (can be fractional).
  static HoraDuration fromHours(double hours) {
    final totalMs = (hours * 60 * 60 * 1000).round();
    return HoraDuration(milliseconds: totalMs);
  }

  /// Creates a duration from minutes (can be fractional).
  static HoraDuration fromMinutes(double minutes) {
    final totalMs = (minutes * 60 * 1000).round();
    return HoraDuration(milliseconds: totalMs);
  }

  /// Creates a duration from seconds (can be fractional).
  static HoraDuration fromSeconds(double seconds) {
    final totalMs = (seconds * 1000).round();
    return HoraDuration(milliseconds: totalMs);
  }

  /// Creates a duration from days (can be fractional).
  static HoraDuration fromDays(double days) {
    final totalMs = (days * 24 * 60 * 60 * 1000).round();
    return HoraDuration(milliseconds: totalMs);
  }

  /// Parses an ISO 8601 duration string.
  ///
  /// Format: `PnYnMnDTnHnMnS`
  ///
  /// Example: `P1Y2M3DT4H5M6S` = 1 year, 2 months, 3 days, 4 hours, 5 minutes, 6 seconds
  static HoraDuration parse(String input) {
    final pattern = RegExp(
      r'^P(?:(\d+)Y)?(?:(\d+)M)?(?:(\d+)W)?(?:(\d+)D)?(?:T(?:(\d+)H)?(?:(\d+)M)?(?:(\d+(?:\.\d+)?)S)?)?$',
    );

    final match = pattern.firstMatch(input.toUpperCase());
    if (match == null) {
      throw FormatException('Invalid ISO 8601 duration: $input');
    }

    final years = int.tryParse(match.group(1) ?? '') ?? 0;
    final months = int.tryParse(match.group(2) ?? '') ?? 0;
    final weeks = int.tryParse(match.group(3) ?? '') ?? 0;
    final days = int.tryParse(match.group(4) ?? '') ?? 0;
    final hours = int.tryParse(match.group(5) ?? '') ?? 0;
    final minutes = int.tryParse(match.group(6) ?? '') ?? 0;
    final secondsStr = match.group(7);
    final seconds = secondsStr != null ? double.tryParse(secondsStr) ?? 0 : 0.0;

    return HoraDuration(
      years: years,
      months: months,
      weeks: weeks,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds.floor(),
      milliseconds: ((seconds - seconds.floor()) * 1000).round(),
    );
  }

  /// Tries to parse an ISO 8601 duration string.
  static HoraDuration? tryParse(String input) {
    try {
      return parse(input);
    } catch (_) {
      return null;
    }
  }
}

/// Extension for Hora to work with HoraDuration.
extension HoraDurationOpExt on Hora {
  /// Adds a [HoraDuration] to this date.
  ///
  /// Unlike the built-in `addDuration` which takes a Dart [Duration],
  /// this method handles calendar-aware durations (years, months) properly.
  Hora addHoraDuration(HoraDuration duration) =>
      add(duration.years, TemporalUnit.year)
          .add(duration.months, TemporalUnit.month)
          .add(duration.weeks, TemporalUnit.week)
          .add(duration.days, TemporalUnit.day)
          .add(duration.hours, TemporalUnit.hour)
          .add(duration.minutes, TemporalUnit.minute)
          .add(duration.seconds, TemporalUnit.second)
          .add(duration.milliseconds, TemporalUnit.millisecond);

  /// Subtracts a [HoraDuration] from this date.
  ///
  /// Unlike the built-in `subtractDuration` which takes a Dart [Duration],
  /// this method handles calendar-aware durations (years, months) properly.
  Hora subtractHoraDuration(HoraDuration duration) =>
      subtract(duration.years, TemporalUnit.year)
          .subtract(duration.months, TemporalUnit.month)
          .subtract(duration.weeks, TemporalUnit.week)
          .subtract(duration.days, TemporalUnit.day)
          .subtract(duration.hours, TemporalUnit.hour)
          .subtract(duration.minutes, TemporalUnit.minute)
          .subtract(duration.seconds, TemporalUnit.second)
          .subtract(duration.milliseconds, TemporalUnit.millisecond);

  /// Gets the HoraDuration between this and another date.
  HoraDuration horaDurationTo(Hora other) => HoraDuration(
        milliseconds: other.unixMillis - unixMillis,
      );
}

// Note: toHoraDuration() is already provided by DurationToHora extension
// in extensions.dart, so we don't add a duplicate here.
