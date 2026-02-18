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

/// Extended duration utilities.
extension HoraDurationExtUtils on HoraDuration {
  double get _signedTotalSecondsApprox {
    final sign = isNegative ? -1.0 : 1.0;
    final totalSeconds =
        asApproximateSeconds + (milliseconds / 1000) + (microseconds / 1000000);
    return sign * totalSeconds;
  }

  /// Formats the duration as a human-readable string.
  String humanize({bool precise = false}) {
    if (isZero) return '0 seconds';

    final parts = <String>[];
    String formatUnit(int value, String singular) =>
        '$value ${value == 1 ? singular : '${singular}s'}';

    if (years > 0) {
      parts.add(formatUnit(years, 'year'));
    }
    if (months > 0) {
      parts.add(formatUnit(months, 'month'));
    }
    if (weeks > 0) {
      parts.add(formatUnit(weeks, 'week'));
    }
    if (days > 0) {
      parts.add(formatUnit(days, 'day'));
    }
    if (hours > 0) {
      parts.add(formatUnit(hours, 'hour'));
    }
    if (minutes > 0) {
      parts.add(formatUnit(minutes, 'minute'));
    }
    if (seconds > 0) {
      parts.add(formatUnit(seconds, 'second'));
    }

    if (precise) {
      if (milliseconds > 0) {
        parts.add(formatUnit(milliseconds, 'millisecond'));
      }
      if (microseconds > 0) {
        parts.add(formatUnit(microseconds, 'microsecond'));
      }
    } else if (parts.length > 2) {
      parts.removeRange(2, parts.length);
    }

    if (parts.isEmpty) {
      if (milliseconds > 0) {
        parts.add(formatUnit(milliseconds, 'millisecond'));
      } else if (microseconds > 0) {
        parts.add(formatUnit(microseconds, 'microsecond'));
      } else {
        parts.add('0 seconds');
      }
    }

    late final String text;
    if (parts.length == 1) {
      text = parts.first;
    } else if (parts.length == 2) {
      text = '${parts[0]} and ${parts[1]}';
    } else {
      final last = parts.removeLast();
      text = '${parts.join(', ')}, and $last';
    }

    return isNegative ? '-$text' : text;
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
  ///
  /// Other characters pass through as literals.
  /// Use `[text]` to escape text that might contain token characters.
  String format(String formatStr) {
    final buffer = StringBuffer();
    var i = 0;

    while (i < formatStr.length) {
      // Handle escaped text [...]
      if (formatStr[i] == '[') {
        final closeIndex = formatStr.indexOf(']', i);
        if (closeIndex != -1) {
          buffer.write(formatStr.substring(i + 1, closeIndex));
          i = closeIndex + 1;
          continue;
        }
      }

      final remaining = formatStr.substring(i);
      final token = _matchDurationToken(remaining);
      if (token != null) {
        buffer.write(_formatDurationToken(token));
        i += token.length;
      } else {
        buffer.write(formatStr[i]);
        i++;
      }
    }

    return buffer.toString();
  }

  static String? _matchDurationToken(String input) {
    const tokens = [
      'YY',
      'MM',
      'DD',
      'HH',
      'mm',
      'ss',
      'Y',
      'M',
      'D',
      'H',
      'm',
      's',
    ];
    for (final token in tokens) {
      if (input.startsWith(token)) return token;
    }
    return null;
  }

  String _formatDurationToken(String token) => switch (token) {
        'YY' => years.toString().padLeft(2, '0'),
        'Y' => years.toString(),
        'MM' => months.toString().padLeft(2, '0'),
        'M' => months.toString(),
        'DD' => days.toString().padLeft(2, '0'),
        'D' => days.toString(),
        'HH' => hours.toString().padLeft(2, '0'),
        'H' => hours.toString(),
        'mm' => minutes.toString().padLeft(2, '0'),
        'm' => minutes.toString(),
        'ss' => seconds.toString().padLeft(2, '0'),
        's' => seconds.toString(),
        _ => token,
      };

  /// Gets the total hours including all larger units.
  double get totalHours => _signedTotalSecondsApprox / (60 * 60);

  /// Gets the total minutes including all larger units.
  double get totalMinutes => _signedTotalSecondsApprox / 60;

  /// Gets the total seconds including all larger units.
  double get totalSeconds => _signedTotalSecondsApprox;

  /// Gets the total days including all larger units.
  double get totalDays => _signedTotalSecondsApprox / (60 * 60 * 24);

  /// Converts to a Dart [Duration].
  Duration toDartDuration() => asDuration();
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

  static void _validateFinite(double value, String paramName) {
    if (value.isNaN || value.isInfinite) {
      throw ArgumentError.value(
        value,
        paramName,
        'Value must be a finite number.',
      );
    }
  }

  /// Creates a duration from hours (can be fractional).
  static HoraDuration fromHours(double hours) {
    _validateFinite(hours, 'hours');
    final absHours = hours.abs();
    final h = absHours.truncate();
    final remainingMinutes = (absHours - h) * 60;
    final m = remainingMinutes.truncate();
    final remainingSeconds = (remainingMinutes - m) * 60;
    final s = remainingSeconds.truncate();
    final ms = ((remainingSeconds - s) * 1000).round();

    return HoraDuration(
      hours: h.abs(),
      minutes: m.abs(),
      seconds: s.abs(),
      milliseconds: ms.abs(),
      isNegative: hours < 0,
    ).normalize();
  }

  /// Creates a duration from minutes (can be fractional).
  static HoraDuration fromMinutes(double minutes) {
    _validateFinite(minutes, 'minutes');
    final absMinutes = minutes.abs();
    final m = absMinutes.truncate();
    final remainingSeconds = (absMinutes - m) * 60;
    final s = remainingSeconds.truncate();
    final ms = ((remainingSeconds - s) * 1000).round();

    return HoraDuration(
      minutes: m.abs(),
      seconds: s.abs(),
      milliseconds: ms.abs(),
      isNegative: minutes < 0,
    ).normalize();
  }

  /// Creates a duration from seconds (can be fractional).
  static HoraDuration fromSeconds(double seconds) {
    _validateFinite(seconds, 'seconds');
    final absSeconds = seconds.abs();
    final s = absSeconds.truncate();
    final ms = ((absSeconds - s) * 1000).round();

    return HoraDuration(
      seconds: s.abs(),
      milliseconds: ms.abs(),
      isNegative: seconds < 0,
    ).normalize();
  }

  /// Creates a duration from days (can be fractional).
  static HoraDuration fromDays(double days) {
    _validateFinite(days, 'days');
    return HoraDurationFactory.fromHours(days * 24);
  }
}

/// Extension for Hora to work with HoraDuration.
extension HoraDurationOpExt on Hora {
  /// Adds a [HoraDuration] to this date.
  ///
  /// Unlike the built-in `addDuration` which takes a Dart [Duration],
  /// this method handles calendar-aware durations (years, months) properly.
  Hora addHoraDuration(HoraDuration duration) =>
      _applyHoraDuration(duration, negate: false);

  /// Subtracts a [HoraDuration] from this date.
  ///
  /// Unlike the built-in `subtractDuration` which takes a Dart [Duration],
  /// this method handles calendar-aware durations (years, months) properly.
  Hora subtractHoraDuration(HoraDuration duration) =>
      _applyHoraDuration(duration, negate: true);

  Hora _applyHoraDuration(HoraDuration duration, {required bool negate}) {
    _validateDurationComponents(duration);
    var factor = duration.isNegative ? -1 : 1;
    if (negate) {
      factor = -factor;
    }

    return plus(
      years: duration.years * factor,
      months: duration.months * factor,
      weeks: duration.weeks * factor,
      days: duration.days * factor,
      hours: duration.hours * factor,
      minutes: duration.minutes * factor,
      seconds: duration.seconds * factor,
      milliseconds: duration.milliseconds * factor,
      microseconds: duration.microseconds * factor,
    );
  }

  void _validateDurationComponents(HoraDuration duration) {
    final negativeFields = <String>[
      if (duration.years < 0) 'years',
      if (duration.months < 0) 'months',
      if (duration.weeks < 0) 'weeks',
      if (duration.days < 0) 'days',
      if (duration.hours < 0) 'hours',
      if (duration.minutes < 0) 'minutes',
      if (duration.seconds < 0) 'seconds',
      if (duration.milliseconds < 0) 'milliseconds',
      if (duration.microseconds < 0) 'microseconds',
    ];
    if (negativeFields.isEmpty) return;

    throw ArgumentError.value(
      duration,
      'duration',
      'Duration components must be non-negative. '
          'Use isNegative for sign. Invalid fields: ${negativeFields.join(', ')}.',
    );
  }

  /// Gets the HoraDuration between this and another date.
  HoraDuration horaDurationTo(Hora other) => HoraDuration.between(this, other);
}

// Note: toHoraDuration() is already provided by DurationToHora extension
// in extensions.dart, so we don't add a duplicate here.
