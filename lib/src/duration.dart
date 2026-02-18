import 'package:meta/meta.dart';

import 'hora.dart';
import 'locale.dart';

/// A duration that supports both fixed and calendar-based units.
///
/// Unlike Dart's [Duration], [HoraDuration] can represent durations
/// in months and years, which have variable lengths.
///
/// ## Creating Durations
///
/// ```dart
/// HoraDuration.ofDays(30);
/// HoraDuration.ofMonths(2);
/// HoraDuration.ofYears(1);
/// HoraDuration.parse('P1Y2M3D'); // ISO 8601
/// HoraDuration(years: 1, months: 6, days: 15);
/// ```
///
/// ## Conversion
///
/// ```dart
/// final d = HoraDuration(days: 45);
/// d.inDays;     // 45
/// d.inWeeks;    // 6 (truncated)
/// d.asDuration; // Duration(days: 45)
/// ```
@immutable
class HoraDuration implements Comparable<HoraDuration> {
  /// Creates a duration with all components.
  const HoraDuration({
    this.years = 0,
    this.months = 0,
    this.weeks = 0,
    this.days = 0,
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
    this.milliseconds = 0,
    this.microseconds = 0,
    this.isNegative = false,
  });

  /// Creates a duration from years.
  factory HoraDuration.ofYears(int years) =>
      HoraDuration(years: years.abs(), isNegative: years < 0);

  /// Creates a duration from months.
  factory HoraDuration.ofMonths(int months) =>
      HoraDuration(months: months.abs(), isNegative: months < 0);

  /// Creates a duration from weeks.
  factory HoraDuration.ofWeeks(int weeks) =>
      HoraDuration(weeks: weeks.abs(), isNegative: weeks < 0);

  /// Creates a duration from days.
  factory HoraDuration.ofDays(int days) =>
      HoraDuration(days: days.abs(), isNegative: days < 0);

  /// Creates a duration from hours.
  factory HoraDuration.ofHours(int hours) =>
      HoraDuration(hours: hours.abs(), isNegative: hours < 0);

  /// Creates a duration from minutes.
  factory HoraDuration.ofMinutes(int minutes) =>
      HoraDuration(minutes: minutes.abs(), isNegative: minutes < 0);

  /// Creates a duration from seconds.
  factory HoraDuration.ofSeconds(int seconds) =>
      HoraDuration(seconds: seconds.abs(), isNegative: seconds < 0);

  /// Creates a duration from milliseconds.
  factory HoraDuration.ofMilliseconds(int ms) =>
      HoraDuration(milliseconds: ms.abs(), isNegative: ms < 0);

  /// Creates a duration from microseconds.
  factory HoraDuration.ofMicroseconds(int us) =>
      HoraDuration(microseconds: us.abs(), isNegative: us < 0);

  /// Creates a duration from a Dart [Duration].
  factory HoraDuration.fromDuration(Duration duration) {
    final isNeg = duration.isNegative;
    final abs = duration.abs();
    return HoraDuration(
      days: abs.inDays,
      hours: abs.inHours % 24,
      minutes: abs.inMinutes % 60,
      seconds: abs.inSeconds % 60,
      milliseconds: abs.inMilliseconds % 1000,
      microseconds: abs.inMicroseconds % 1000,
      isNegative: isNeg,
    );
  }

  /// Creates a duration between two [Hora] instances.
  factory HoraDuration.between(Hora start, Hora end) {
    final isNeg = end.isBefore(start);
    final (early, late) = isNeg ? (end, start) : (start, end);

    var years = late.year - early.year;
    var months = late.month - early.month;
    var days = late.day - early.day;

    if (days < 0) {
      months--;
      // Use the number of days in the month before late's month
      days += DateTime(late.year, late.month, 0).day;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    final earlyTime = Duration(
      hours: early.hour,
      minutes: early.minute,
      seconds: early.second,
      milliseconds: early.millisecond,
      microseconds: early.microsecond,
    );
    final lateTime = Duration(
      hours: late.hour,
      minutes: late.minute,
      seconds: late.second,
      milliseconds: late.millisecond,
      microseconds: late.microsecond,
    );

    var timeDiff = lateTime - earlyTime;
    if (timeDiff.isNegative) {
      days--;
      timeDiff = const Duration(days: 1) + timeDiff;
    }

    return HoraDuration(
      years: years,
      months: months,
      days: days,
      hours: timeDiff.inHours,
      minutes: timeDiff.inMinutes % 60,
      seconds: timeDiff.inSeconds % 60,
      milliseconds: timeDiff.inMilliseconds % 1000,
      microseconds: timeDiff.inMicroseconds % 1000,
      isNegative: isNeg,
    );
  }

  /// Parses an ISO 8601 duration string.
  ///
  /// Format: `P[n]Y[n]M[n]W[n]DT[n]H[n]M[n]S`
  ///
  /// Examples:
  /// - `P1Y` - 1 year
  /// - `P2M` - 2 months
  /// - `P3W` - 3 weeks
  /// - `P1Y2M3DT4H5M6S` - 1 year, 2 months, 3 days, 4 hours, 5 minutes, 6 seconds
  /// - `-P1D` - negative 1 day
  factory HoraDuration.parse(String input) {
    final result = tryParse(input);
    if (result == null) {
      throw FormatException('Invalid ISO 8601 duration: $input');
    }
    return result;
  }

  /// Creates a zero duration.
  static const zero = HoraDuration();

  /// Tries to parse an ISO 8601 duration string.
  static HoraDuration? tryParse(String input) {
    final regex = RegExp(
      r'^(-)?P(?:(\d+)Y)?(?:(\d+)M)?(?:(\d+)W)?(?:(\d+)D)?(?:T(?:(\d+)H)?(?:(\d+)M)?(?:(\d+(?:\.\d+)?)S)?)?$',
      caseSensitive: false,
    );

    final match = regex.firstMatch(input.trim());
    if (match == null) return null;
    final hasAnyComponent = List<int>.generate(7, (i) => i + 2)
        .any((index) => match.group(index) != null);
    if (!hasAnyComponent) return null;

    final isNeg = match.group(1) == '-';
    int parseNum(String? s) => s == null ? 0 : int.tryParse(s) ?? 0;
    (int, int, int) parseSeconds(String? s) {
      if (s == null) return (0, 0, 0);
      final parts = s.split('.');
      final sec = int.tryParse(parts[0]) ?? 0;
      if (parts.length == 1) return (sec, 0, 0);
      final frac = parts[1].padRight(6, '0');
      final ms = int.tryParse(frac.substring(0, 3)) ?? 0;
      final us = int.tryParse(frac.substring(3, 6)) ?? 0;
      return (sec, ms, us);
    }

    final year = parseNum(match.group(2));
    final month = parseNum(match.group(3));
    final week = parseNum(match.group(4));
    final day = parseNum(match.group(5));
    final hour = parseNum(match.group(6));
    final minute = parseNum(match.group(7));
    final (sec, ms, us) = parseSeconds(match.group(8));
    final hasMagnitude = year > 0 ||
        month > 0 ||
        week > 0 ||
        day > 0 ||
        hour > 0 ||
        minute > 0 ||
        sec > 0 ||
        ms > 0 ||
        us > 0;

    return HoraDuration(
      years: year,
      months: month,
      weeks: week,
      days: day,
      hours: hour,
      minutes: minute,
      seconds: sec,
      milliseconds: ms,
      microseconds: us,
      isNegative: isNeg && hasMagnitude,
    );
  }

  final int years;
  final int months;
  final int weeks;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final int milliseconds;
  final int microseconds;
  final bool isNegative;

  /// Whether this duration is zero.
  bool get isZero =>
      years == 0 &&
      months == 0 &&
      weeks == 0 &&
      days == 0 &&
      hours == 0 &&
      minutes == 0 &&
      seconds == 0 &&
      milliseconds == 0 &&
      microseconds == 0;

  bool get _isSignedNegative => isNegative && !isZero;

  /// Whether this duration contains calendar units (years/months).
  bool get hasCalendarUnits => years != 0 || months != 0;

  // ============ Total Values ============

  /// Total months (years * 12 + months).
  int get inMonths => years * 12 + months;

  /// Total days (weeks * 7 + days). Does not include years/months.
  int get inDays => weeks * 7 + days;

  /// Total hours. Does not include years/months.
  int get inHours => inDays * 24 + hours;

  /// Total minutes. Does not include years/months.
  int get inMinutes => inHours * 60 + minutes;

  /// Total seconds. Does not include years/months.
  int get inSeconds => inMinutes * 60 + seconds;

  /// Total milliseconds. Does not include years/months.
  int get inMilliseconds => inSeconds * 1000 + milliseconds;

  /// Total microseconds. Does not include years/months.
  int get inMicroseconds => inMilliseconds * 1000 + microseconds;

  // ============ As Approximate Values ============

  /// Approximate total days (using 30.4375 days/month).
  double get asApproximateDays =>
      (years * 365.25) + (months * 30.4375) + (weeks * 7) + days;

  /// Approximate total hours.
  double get asApproximateHours => asApproximateDays * 24 + hours;

  /// Approximate total minutes.
  double get asApproximateMinutes => asApproximateHours * 60 + minutes;

  /// Approximate total seconds.
  double get asApproximateSeconds => asApproximateMinutes * 60 + seconds;

  // ============ Conversion ============

  /// Converts to a Dart [Duration].
  ///
  /// Note: Years and months are converted using average values.
  Duration asDuration() {
    final sign = _isSignedNegative ? -1 : 1;
    final totalMicros =
        (asApproximateSeconds * 1000000 + milliseconds * 1000 + microseconds) *
            sign;
    return Duration(microseconds: totalMicros.round());
  }

  /// Returns the absolute (non-negative) duration.
  HoraDuration abs() => isNegative ? copyWith(isNegative: false) : this;

  /// Returns the negated duration.
  HoraDuration negate() => copyWith(isNegative: !isNegative);

  /// Normalizes the duration (e.g., 90 minutes -> 1 hour 30 minutes).
  HoraDuration normalize() {
    var us = microseconds;
    var ms = milliseconds + us ~/ 1000;
    us = us % 1000;
    var s = seconds + ms ~/ 1000;
    ms = ms % 1000;
    var m = minutes + s ~/ 60;
    s = s % 60;
    var h = hours + m ~/ 60;
    m = m % 60;
    var d = days + h ~/ 24;
    h = h % 24;
    final w = weeks + d ~/ 7;
    d = d % 7;
    var mo = months + years * 12;
    final y = mo ~/ 12;
    mo = mo % 12;

    return HoraDuration(
      years: y,
      months: mo,
      weeks: w,
      days: d,
      hours: h,
      minutes: m,
      seconds: s,
      milliseconds: ms,
      microseconds: us,
      isNegative: isNegative,
    );
  }

  // ============ Arithmetic ============

  /// Returns the negation of this duration.
  HoraDuration operator -() => HoraDuration(
        years: years,
        months: months,
        weeks: weeks,
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds,
        isNegative: !isNegative,
      );

  /// Adds another duration.
  ///
  /// Note: This does not normalize the result. Call [normalize] if needed.
  HoraDuration operator +(HoraDuration other) {
    if (isNegative != other.isNegative) {
      return isNegative ? other - abs() : this - other.abs();
    }

    return HoraDuration(
      years: years + other.years,
      months: months + other.months,
      weeks: weeks + other.weeks,
      days: days + other.days,
      hours: hours + other.hours,
      minutes: minutes + other.minutes,
      seconds: seconds + other.seconds,
      milliseconds: milliseconds + other.milliseconds,
      microseconds: microseconds + other.microseconds,
      isNegative: isNegative,
    );
  }

  /// Subtracts another duration.
  ///
  /// Converts both durations to total microseconds (with approximate
  /// month/year conversions), computes the difference, then reconstructs
  /// the result preserving calendar unit proportions.
  HoraDuration operator -(HoraDuration other) {
    if (other.isNegative) {
      return this + other.abs();
    }

    // Convert to total microseconds for a correct scalar subtraction.
    final sign = isNegative ? -1 : 1;
    final otherSign = other.isNegative ? -1 : 1;

    const monthUs = 2629800000000; // round(30.4375 days in microseconds)
    final thisTotalUs = sign * (inMicroseconds + (inMonths * monthUs));
    final otherTotalUs =
        otherSign * (other.inMicroseconds + (other.inMonths * monthUs));
    final diffUs = thisTotalUs - otherTotalUs;

    final isResultNeg = diffUs < 0;

    // Reconstruct from absolute scalar microseconds so every component stays non-negative.
    // Months remain approximate (30.4375 days), consistent with subtraction semantics.
    final absUs = diffUs.abs();
    final moAbs = absUs ~/ monthUs;
    final remainUs = absUs - (moAbs * monthUs);

    final y = moAbs ~/ 12;
    final mo = moAbs % 12;

    var us = remainUs;
    // Only decompose into weeks if either operand originally had weeks.
    final hasWeeks = weeks > 0 || other.weeks > 0;
    int w;
    if (hasWeeks) {
      w = us ~/ (7 * 86400000000);
      us -= w * 7 * 86400000000;
    } else {
      w = 0;
    }
    final d = us ~/ 86400000000;
    us -= d * 86400000000;
    final h = us ~/ 3600000000;
    us -= h * 3600000000;
    final m = us ~/ 60000000;
    us -= m * 60000000;
    final s = us ~/ 1000000;
    us -= s * 1000000;
    final ms = us ~/ 1000;
    us -= ms * 1000;

    return HoraDuration(
      years: y,
      months: mo,
      weeks: w,
      days: d,
      hours: h,
      minutes: m,
      seconds: s,
      milliseconds: ms,
      microseconds: us,
      isNegative: isResultNeg && absUs != 0,
    );
  }

  /// Multiplies the duration by a factor.
  HoraDuration operator *(num factor) {
    if (factor.isNaN || factor.isInfinite) {
      throw ArgumentError.value(
        factor,
        'factor',
        'Factor must be a finite number.',
      );
    }
    final f = factor.abs();
    return HoraDuration(
      years: (years * f).round(),
      months: (months * f).round(),
      weeks: (weeks * f).round(),
      days: (days * f).round(),
      hours: (hours * f).round(),
      minutes: (minutes * f).round(),
      seconds: (seconds * f).round(),
      milliseconds: (milliseconds * f).round(),
      microseconds: (microseconds * f).round(),
      isNegative: factor < 0 ? !_isSignedNegative : _isSignedNegative,
    ).normalize();
  }

  // ============ Formatting ============

  /// Returns the ISO 8601 duration string.
  String toIso8601() {
    final buf = StringBuffer();
    if (_isSignedNegative) buf.write('-');
    buf.write('P');

    if (years != 0) buf.write('${years}Y');
    if (months != 0) buf.write('${months}M');
    if (weeks != 0) buf.write('${weeks}W');
    if (days != 0) buf.write('${days}D');

    if (hours != 0 ||
        minutes != 0 ||
        seconds != 0 ||
        milliseconds != 0 ||
        microseconds != 0) {
      buf.write('T');
      if (hours != 0) buf.write('${hours}H');
      if (minutes != 0) buf.write('${minutes}M');
      if (seconds != 0 || milliseconds != 0 || microseconds != 0) {
        if (milliseconds != 0 || microseconds != 0) {
          final frac = (milliseconds * 1000 + microseconds)
              .toString()
              .padLeft(6, '0')
              .replaceAll(RegExp(r'0+$'), '');
          buf.write('$seconds.$frac');
        } else {
          buf.write(seconds);
        }
        buf.write('S');
      }
    }

    if (buf.length == 1 || (buf.length == 2 && _isSignedNegative)) {
      buf.write('T0S');
    }

    return buf.toString();
  }

  /// Returns a human-readable string.
  String humanize({HoraLocale? locale}) {
    locale ??= const HoraLocaleEn();
    final rel = locale.relativeTime;

    if (years != 0) {
      return years == 1 ? rel.y : rel.yy.replaceAll('%d', years.toString());
    }
    if (months != 0) {
      return months == 1 ? rel.mo : rel.mos.replaceAll('%d', months.toString());
    }
    if (weeks != 0) {
      return weeks == 1 ? rel.w : rel.ww.replaceAll('%d', weeks.toString());
    }
    if (days != 0) {
      return days == 1 ? rel.d : rel.dd.replaceAll('%d', days.toString());
    }
    if (hours != 0) {
      return hours == 1 ? rel.h : rel.hh.replaceAll('%d', hours.toString());
    }
    if (minutes != 0) {
      return minutes == 1 ? rel.m : rel.mm.replaceAll('%d', minutes.toString());
    }
    return rel.s;
  }

  /// Creates a copy with optional modifications.
  HoraDuration copyWith({
    int? years,
    int? months,
    int? weeks,
    int? days,
    int? hours,
    int? minutes,
    int? seconds,
    int? milliseconds,
    int? microseconds,
    bool? isNegative,
  }) =>
      HoraDuration(
        years: years ?? this.years,
        months: months ?? this.months,
        weeks: weeks ?? this.weeks,
        days: days ?? this.days,
        hours: hours ?? this.hours,
        minutes: minutes ?? this.minutes,
        seconds: seconds ?? this.seconds,
        milliseconds: milliseconds ?? this.milliseconds,
        microseconds: microseconds ?? this.microseconds,
        isNegative: isNegative ?? this.isNegative,
      );

  @override
  int compareTo(HoraDuration other) {
    // First compare by approximate scalar magnitude including sub-second parts.
    final scalarCmp = asDuration().inMicroseconds.compareTo(
          other.asDuration().inMicroseconds,
        );
    if (scalarCmp != 0) return scalarCmp;

    // Tie-break to provide deterministic ordering and avoid compareTo(==0)
    // for durations that are structurally different but numerically close
    // under approximation.
    return _componentTupleCompare(other);
  }

  int _componentTupleCompare(HoraDuration other) {
    final fieldsThis = <int>[
      if (_isSignedNegative) 1 else 0,
      years,
      months,
      weeks,
      days,
      hours,
      minutes,
      seconds,
      milliseconds,
      microseconds,
    ];
    final fieldsOther = <int>[
      if (other._isSignedNegative) 1 else 0,
      other.years,
      other.months,
      other.weeks,
      other.days,
      other.hours,
      other.minutes,
      other.seconds,
      other.milliseconds,
      other.microseconds,
    ];

    for (var i = 0; i < fieldsThis.length; i++) {
      final cmp = fieldsThis[i].compareTo(fieldsOther[i]);
      if (cmp != 0) return cmp;
    }
    return 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HoraDuration &&
          years == other.years &&
          months == other.months &&
          weeks == other.weeks &&
          days == other.days &&
          hours == other.hours &&
          minutes == other.minutes &&
          seconds == other.seconds &&
          milliseconds == other.milliseconds &&
          microseconds == other.microseconds &&
          _isSignedNegative == other._isSignedNegative;

  @override
  int get hashCode => Object.hash(
        years,
        months,
        weeks,
        days,
        hours,
        minutes,
        seconds,
        milliseconds,
        microseconds,
        _isSignedNegative,
      );

  @override
  String toString() => toIso8601();
}
