/// Relative time plugin for Hora.
///
/// Provides human-readable relative time formatting.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/relative_time.dart';
///
/// final past = Hora.now().subtract(5, TemporalUnit.minute);
/// print(past.fromNow()); // "5 minutes ago"
///
/// final future = Hora.now().add(2, TemporalUnit.day);
/// print(future.fromNow()); // "in 2 days"
///
/// final other = Hora.of(year: 2020, month: 1, day: 1);
/// print(Hora.now().from(other)); // "3 years ago"
/// ```
library;

import '../hora.dart';

/// Configuration for relative time formatting.
class RelativeTimeConfig {
  const RelativeTimeConfig({
    this.thresholds = const RelativeTimeThresholds(),
    this.withoutSuffix = false,
    this.addSuffix = true,
  });

  /// The thresholds for switching between units.
  final RelativeTimeThresholds thresholds;

  /// Whether to omit the suffix ("ago" / "in").
  final bool withoutSuffix;

  /// Whether to add a suffix.
  final bool addSuffix;

  /// Default configuration.
  static const defaultConfig = RelativeTimeConfig();
}

/// Thresholds for determining which unit to use in relative time.
class RelativeTimeThresholds {
  const RelativeTimeThresholds({
    this.seconds = 44,
    this.minutes = 44,
    this.hours = 21,
    this.days = 25,
    this.months = 10,
  });

  /// Seconds before switching to "a minute ago".
  final int seconds;

  /// Minutes before switching to "an hour ago".
  final int minutes;

  /// Hours before switching to "a day ago".
  final int hours;

  /// Days before switching to "a month ago".
  final int days;

  /// Months before switching to "a year ago".
  final int months;

  /// Strict thresholds for more precise output.
  static const strict = RelativeTimeThresholds(
    seconds: 59,
    minutes: 59,
    hours: 23,
    days: 29,
    months: 11,
  );
}

/// Represents a relative time unit for formatting.
enum RelativeTimeUnit {
  second,
  minute,
  hour,
  day,
  month,
  year,
}

/// Extension providing relative time formatting for Hora.
extension RelativeTimePluginExt on Hora {
  /// Gets the relative time from now.
  ///
  /// Examples:
  /// - "a few seconds ago"
  /// - "5 minutes ago"
  /// - "in 2 hours"
  String relativeFromNow({
    RelativeTimeConfig config = RelativeTimeConfig.defaultConfig,
  }) =>
      relativeFrom(Hora.now(locale: locale), config: config);

  /// Gets the relative time from another date.
  String relativeFrom(
    Hora other, {
    RelativeTimeConfig config = RelativeTimeConfig.defaultConfig,
  }) {
    final diffMs = other.unixMillis - unixMillis;
    final isFuture = diffMs < 0;
    final absDiffMs = diffMs.abs();

    final (unit, value) = _determineUnit(absDiffMs, config.thresholds);
    return _formatRelativeTime(unit, value, isFuture, config);
  }

  /// Gets the relative time to now.
  String relativeToNow({
    RelativeTimeConfig config = RelativeTimeConfig.defaultConfig,
  }) =>
      relativeTo(Hora.now(locale: locale), config: config);

  /// Gets the relative time to another date.
  String relativeTo(
    Hora other, {
    RelativeTimeConfig config = RelativeTimeConfig.defaultConfig,
  }) =>
      other.relativeFrom(this, config: config);

  /// Gets a short relative time string.
  ///
  /// Examples: "5m", "2h", "3d"
  String relativeFromNowShort() {
    final diffMs = Hora.now().unixMillis - unixMillis;
    final isFuture = diffMs < 0;
    final absDiffMs = diffMs.abs();

    final prefix = isFuture ? '+' : '-';

    if (absDiffMs < 60 * 1000) {
      final s = absDiffMs ~/ 1000;
      return '$prefix${s}s';
    } else if (absDiffMs < 60 * 60 * 1000) {
      final m = absDiffMs ~/ (60 * 1000);
      return '$prefix${m}m';
    } else if (absDiffMs < 24 * 60 * 60 * 1000) {
      final h = absDiffMs ~/ (60 * 60 * 1000);
      return '$prefix${h}h';
    } else if (absDiffMs < 30 * 24 * 60 * 60 * 1000) {
      final d = absDiffMs ~/ (24 * 60 * 60 * 1000);
      return '$prefix${d}d';
    } else if (absDiffMs < 365 * 24 * 60 * 60 * 1000) {
      final mo = absDiffMs ~/ (30 * 24 * 60 * 60 * 1000);
      return '$prefix${mo}mo';
    } else {
      final y = absDiffMs ~/ (365 * 24 * 60 * 60 * 1000);
      return '$prefix${y}y';
    }
  }

  /// Gets a precise relative time breakdown.
  RelativeTimeDiff diffFromNowDetailed() => diffFromDetailed(Hora.now());

  /// Gets a precise relative time breakdown from another date.
  RelativeTimeDiff diffFromDetailed(Hora other) {
    final diffMs = (other.unixMillis - unixMillis).abs();
    final isFuture = other.isBefore(this);

    var remaining = diffMs;

    final years = remaining ~/ (365 * 24 * 60 * 60 * 1000);
    remaining %= 365 * 24 * 60 * 60 * 1000;

    final months = remaining ~/ (30 * 24 * 60 * 60 * 1000);
    remaining %= 30 * 24 * 60 * 60 * 1000;

    final days = remaining ~/ (24 * 60 * 60 * 1000);
    remaining %= 24 * 60 * 60 * 1000;

    final hours = remaining ~/ (60 * 60 * 1000);
    remaining %= 60 * 60 * 1000;

    final minutes = remaining ~/ (60 * 1000);
    remaining %= 60 * 1000;

    final seconds = remaining ~/ 1000;

    return RelativeTimeDiff(
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      isFuture: isFuture,
    );
  }

  (RelativeTimeUnit, int) _determineUnit(int diffMs, RelativeTimeThresholds t) {
    final seconds = diffMs ~/ 1000;
    final minutes = seconds ~/ 60;
    final hours = minutes ~/ 60;
    final days = hours ~/ 24;
    final months = days ~/ 30;
    final years = days ~/ 365;

    if (seconds < t.seconds) {
      return (RelativeTimeUnit.second, seconds);
    } else if (minutes < t.minutes) {
      return (RelativeTimeUnit.minute, minutes);
    } else if (hours < t.hours) {
      return (RelativeTimeUnit.hour, hours);
    } else if (days < t.days) {
      return (RelativeTimeUnit.day, days);
    } else if (months < t.months) {
      return (RelativeTimeUnit.month, months);
    } else {
      return (RelativeTimeUnit.year, years);
    }
  }

  String _formatRelativeTime(
    RelativeTimeUnit unit,
    int value,
    bool isFuture,
    RelativeTimeConfig config,
  ) {
    final rel = locale.relativeTime;
    String text;

    switch (unit) {
      case RelativeTimeUnit.second:
        text = rel.s;
      case RelativeTimeUnit.minute:
        text = value == 1 ? rel.m : rel.mm.replaceAll('%d', value.toString());
      case RelativeTimeUnit.hour:
        text = value == 1 ? rel.h : rel.hh.replaceAll('%d', value.toString());
      case RelativeTimeUnit.day:
        text = value == 1 ? rel.d : rel.dd.replaceAll('%d', value.toString());
      case RelativeTimeUnit.month:
        text = value == 1 ? rel.mo : rel.mos.replaceAll('%d', value.toString());
      case RelativeTimeUnit.year:
        text = value == 1 ? rel.y : rel.yy.replaceAll('%d', value.toString());
    }

    if (config.withoutSuffix || !config.addSuffix) {
      return text;
    }

    return isFuture
        ? rel.future.replaceAll('%s', text)
        : rel.past.replaceAll('%s', text);
  }
}

/// Represents a detailed breakdown of time difference.
class RelativeTimeDiff {
  const RelativeTimeDiff({
    required this.years,
    required this.months,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.isFuture,
  });

  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final bool isFuture;

  /// Gets the total days.
  int get totalDays => years * 365 + months * 30 + days;

  /// Gets the total hours.
  int get totalHours => totalDays * 24 + hours;

  /// Gets the total minutes.
  int get totalMinutes => totalHours * 60 + minutes;

  /// Gets the total seconds.
  int get totalSeconds => totalMinutes * 60 + seconds;

  /// Formats as a human-readable string.
  String format({bool showAll = false}) {
    final parts = <String>[];

    if (years > 0 || showAll) parts.add('$years years');
    if (months > 0 || showAll) parts.add('$months months');
    if (days > 0 || showAll) parts.add('$days days');
    if (hours > 0 || showAll) parts.add('$hours hours');
    if (minutes > 0 || showAll) parts.add('$minutes minutes');
    if (seconds > 0 || showAll) parts.add('$seconds seconds');

    if (parts.isEmpty) return '0 seconds';

    final text = parts.join(', ');
    return isFuture ? 'in $text' : '$text ago';
  }

  /// Formats as a compact string.
  String formatCompact() {
    final parts = <String>[];

    if (years > 0) parts.add('${years}y');
    if (months > 0) parts.add('${months}mo');
    if (days > 0) parts.add('${days}d');
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (seconds > 0 || parts.isEmpty) parts.add('${seconds}s');

    return parts.join(' ');
  }

  @override
  String toString() => format();
}
