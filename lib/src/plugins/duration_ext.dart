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
/// // Create durations with fractional values
/// final d = HoraDurationFactory.fromHours(2.5);
/// print(d.humanize()); // "2 hours and 30 minutes"
///
/// // Parse duration strings (using HoraDuration.parse from core)
/// final d2 = HoraDuration.parse('P1DT2H30M');
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

  /// Converts to a Dart [Duration].
  Duration toDartDuration() => Duration(milliseconds: inMilliseconds);
}

/// Factory class for creating durations with fractional values.
///
/// Use these methods when you need to create durations from fractional
/// hours, minutes, etc.
///
/// ```dart
/// final d = HoraDurationFactory.fromHours(2.5);
/// print(d.hours); // 2
/// print(d.minutes); // 30
/// ```
class HoraDurationFactory {
  HoraDurationFactory._();

  /// Creates a duration from hours (can be fractional).
  static HoraDuration fromHours(double hours) {
    final h = hours.truncate();
    final remainingMinutes = (hours - h) * 60;
    final m = remainingMinutes.truncate();
    final remainingSeconds = (remainingMinutes - m) * 60;
    final s = remainingSeconds.truncate();
    final ms = ((remainingSeconds - s) * 1000).round();

    return HoraDuration(
      hours: h,
      minutes: m,
      seconds: s,
      milliseconds: ms,
      isNegative: hours < 0,
    );
  }

  /// Creates a duration from minutes (can be fractional).
  static HoraDuration fromMinutes(double minutes) {
    final m = minutes.truncate();
    final remainingSeconds = (minutes - m) * 60;
    final s = remainingSeconds.truncate();
    final ms = ((remainingSeconds - s) * 1000).round();

    return HoraDuration(
      minutes: m.abs(),
      seconds: s.abs(),
      milliseconds: ms.abs(),
      isNegative: minutes < 0,
    );
  }

  /// Creates a duration from seconds (can be fractional).
  static HoraDuration fromSeconds(double seconds) {
    final s = seconds.truncate();
    final ms = ((seconds - s) * 1000).round();

    return HoraDuration(
      seconds: s.abs(),
      milliseconds: ms.abs(),
      isNegative: seconds < 0,
    );
  }

  /// Creates a duration from days (can be fractional).
  static HoraDuration fromDays(double days) {
    final d = days.truncate();
    final remainingHours = (days - d) * 24;
    return HoraDurationFactory.fromHours(remainingHours).copyWith(
      days: d.abs(),
      isNegative: days < 0,
    );
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
