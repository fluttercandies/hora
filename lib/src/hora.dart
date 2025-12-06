import 'package:meta/meta.dart';

import 'locale.dart';
import 'plugin.dart';
import 'units.dart';

/// An immutable, chainable date-time wrapper with rich manipulation APIs.
///
/// [Hora] wraps Dart's [DateTime] and provides:
/// - Immutable operations (all methods return new instances)
/// - Fluent chainable API
/// - Plugin extensibility
/// - Internationalization support
///
/// ## Creating instances
///
/// ```dart
/// Hora.now();                    // Current time
/// Hora.fromDateTime(dateTime);   // From DateTime
/// Hora.parse('2023-12-25');      // From ISO string
/// Hora.unix(1703462400);         // From Unix timestamp (seconds)
/// Hora.unixMillis(1703462400000); // From Unix timestamp (milliseconds)
/// ```
///
/// ## Manipulation
///
/// ```dart
/// final h = Hora.now();
/// h.add(1, TemporalUnit.day);      // Add 1 day
/// h.subtract(2, TemporalUnit.week); // Subtract 2 weeks
/// h.startOf(TemporalUnit.month);   // Start of month
/// h.endOf(TemporalUnit.year);      // End of year
/// ```
@immutable
class Hora implements Comparable<Hora> {
  /// Creates an invalid [Hora] instance.
  const Hora._invalid(this._locale)
      : _dateTime = null,
        _isValid = false;

  // Private constructor for cloning
  const Hora._clone(DateTime dateTime, this._locale, this._isValid)
      : _dateTime = dateTime;

  /// Creates a [Hora] from a [DateTime].
  Hora.fromDateTime(DateTime dateTime, {HoraLocale? locale})
      : _dateTime = dateTime,
        _locale = locale ?? Hora.globalLocale,
        _isValid = true;

  /// Creates a [Hora] representing the current moment.
  factory Hora.now({HoraLocale? locale}) =>
      Hora.fromDateTime(DateTime.now(), locale: locale);

  /// Creates a [Hora] representing the current moment in UTC.
  factory Hora.nowUtc({HoraLocale? locale}) =>
      Hora.fromDateTime(DateTime.now().toUtc(), locale: locale);

  /// Creates a [Hora] from individual date-time components.
  factory Hora.of({
    required int year,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
    bool utc = false,
    HoraLocale? locale,
  }) {
    final dt = utc
        ? DateTime.utc(
            year,
            month,
            day,
            hour,
            minute,
            second,
            millisecond,
            microsecond,
          )
        : DateTime(
            year,
            month,
            day,
            hour,
            minute,
            second,
            millisecond,
            microsecond,
          );
    return Hora.fromDateTime(dt, locale: locale);
  }

  /// Creates a [Hora] from a Unix timestamp in seconds.
  factory Hora.unix(int seconds, {HoraLocale? locale}) => Hora.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(seconds * 1000),
        locale: locale,
      );

  /// Creates a [Hora] from a Unix timestamp in milliseconds.
  factory Hora.unixMillis(int milliseconds, {HoraLocale? locale}) =>
      Hora.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(milliseconds),
        locale: locale,
      );

  /// Creates a [Hora] from a Unix timestamp in microseconds.
  factory Hora.unixMicros(int microseconds, {HoraLocale? locale}) =>
      Hora.fromDateTime(
        DateTime.fromMicrosecondsSinceEpoch(microseconds),
        locale: locale,
      );

  /// Parses a date-time string.
  ///
  /// Supports ISO 8601 and common formats.
  /// Returns an invalid [Hora] if parsing fails (check with [isValid]).
  factory Hora.parse(String input, {HoraLocale? locale}) {
    final dt = DateTime.tryParse(input);
    if (dt != null) {
      return Hora.fromDateTime(dt, locale: locale);
    }
    // Try additional formats
    final parsed = _tryParseFormats(input);
    if (parsed != null) {
      return Hora.fromDateTime(parsed, locale: locale);
    }
    // Return invalid Hora
    return Hora._invalid(locale ?? Hora.globalLocale);
  }

  /// Tries to parse a date-time string, returns null if invalid.
  static Hora? tryParse(String input, {HoraLocale? locale}) {
    final result = Hora.parse(input, locale: locale);
    return result.isValid ? result : null;
  }

  final DateTime? _dateTime;
  final HoraLocale _locale;
  final bool _isValid;

  /// Private accessor that throws if invalid.
  /// Use this for internal operations that require a valid DateTime.
  DateTime get _dt {
    if (!_isValid || _dateTime == null) {
      throw StateError('Cannot access dateTime on an invalid Hora instance');
    }
    return _dateTime!;
  }

  // ============ Static Configuration ============

  /// The global default locale.
  static HoraLocale globalLocale = const HoraLocaleEn();

  /// Registered plugins.
  static final List<HoraPlugin> _plugins = [];

  /// Registers a plugin globally.
  static void use(HoraPlugin plugin) {
    if (!_plugins.contains(plugin)) {
      _plugins.add(plugin);
    }
  }

  // ============ Basic Getters ============

  /// The underlying [DateTime] object.
  /// Throws [StateError] if this is an invalid Hora instance.
  DateTime get dateTime => _dt;

  /// Whether this instance represents a valid date-time.
  bool get isValid => _isValid;

  /// Whether this is in UTC timezone.
  bool get isUtc => _dt.isUtc;

  /// Whether this is in local timezone.
  bool get isLocal => !_dt.isUtc;

  /// The current locale.
  HoraLocale get locale => _locale;

  // ============ Date Components ============

  /// The year.
  int get year => _dt.year;

  /// The month (1-12).
  int get month => _dt.month;

  /// The day of month (1-31).
  int get day => _dt.day;

  /// The day of week (1=Monday, 7=Sunday) per ISO 8601.
  int get weekday => _dt.weekday;

  /// The hour (0-23).
  int get hour => _dt.hour;

  /// The minute (0-59).
  int get minute => _dt.minute;

  /// The second (0-59).
  int get second => _dt.second;

  /// The millisecond (0-999).
  int get millisecond => _dt.millisecond;

  /// The microsecond (0-999).
  int get microsecond => _dt.microsecond;

  /// Unix timestamp in seconds.
  int get unix => _dt.millisecondsSinceEpoch ~/ 1000;

  /// Unix timestamp in milliseconds.
  int get unixMillis => _dt.millisecondsSinceEpoch;

  /// Unix timestamp in microseconds.
  int get unixMicros => _dt.microsecondsSinceEpoch;

  /// The timezone offset.
  Duration get timeZoneOffset => _dt.timeZoneOffset;

  /// The timezone name.
  String get timeZoneName => _dt.timeZoneName;

  // ============ Derived Getters ============

  /// The quarter (1-4).
  int get quarter => (month - 1) ~/ 3 + 1;

  /// The day of year (1-366).
  int get dayOfYear {
    final start = DateTime(year);
    return _dt.difference(start).inDays + 1;
  }

  /// Number of days in the current month.
  int get daysInMonth => DateTime(year, month + 1, 0).day;

  /// Number of days in the current year.
  int get daysInYear => isLeapYear ? 366 : 365;

  /// Whether the year is a leap year.
  bool get isLeapYear =>
      (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);

  /// The ISO week number (1-53).
  int get isoWeek {
    // ISO week starts on Monday
    final thursday = _dt.add(Duration(days: 4 - weekday));
    final firstThursday = DateTime(thursday.year, 1, 4);
    final firstMonday = firstThursday.subtract(
      Duration(days: firstThursday.weekday - 1),
    );
    return ((thursday.difference(firstMonday).inDays) ~/ 7) + 1;
  }

  /// The ISO week year.
  int get isoWeekYear {
    final thursday = _dt.add(Duration(days: 4 - weekday));
    return thursday.year;
  }

  /// Number of ISO weeks in the year.
  int get isoWeeksInYear {
    final dec28 = DateTime(year, 12, 28);
    final dayOfDec28 = dec28.weekday;
    final lastThursday = dec28.add(Duration(days: 4 - dayOfDec28));
    final firstThursday = DateTime(year, 1, 4).subtract(
      Duration(days: DateTime(year, 1, 4).weekday - 4),
    );
    return ((lastThursday.difference(firstThursday).inDays) ~/ 7) + 1;
  }

  // ============ Manipulation ============

  /// Returns a new [Hora] with the specified amount added.
  Hora add(int amount, TemporalUnit unit) {
    if (!_isValid) return this;

    return switch (unit) {
      TemporalUnit.year => _withDate(year: year + amount),
      TemporalUnit.quarter => _withDate(month: month + amount * 3),
      TemporalUnit.month => _withDate(month: month + amount),
      TemporalUnit.week => _addDuration(Duration(days: amount * 7)),
      TemporalUnit.day => _addDuration(Duration(days: amount)),
      TemporalUnit.hour => _addDuration(Duration(hours: amount)),
      TemporalUnit.minute => _addDuration(Duration(minutes: amount)),
      TemporalUnit.second => _addDuration(Duration(seconds: amount)),
      TemporalUnit.millisecond => _addDuration(Duration(milliseconds: amount)),
      TemporalUnit.microsecond => _addDuration(Duration(microseconds: amount)),
    };
  }

  /// Returns a new [Hora] with the specified amount subtracted.
  Hora subtract(int amount, TemporalUnit unit) => add(-amount, unit);

  /// Returns a new [Hora] with a [Duration] added.
  Hora addDuration(Duration duration) => _addDuration(duration);

  /// Returns a new [Hora] with a [Duration] subtracted.
  Hora subtractDuration(Duration duration) => _addDuration(-duration);

  Hora _addDuration(Duration duration) =>
      _copyWith(dateTime: _dt.add(duration));

  Hora _withDate({int? year, int? month, int? day}) {
    final y = year ?? this.year;
    final m = month ?? this.month;
    // Clamp day to valid range for the new month
    final maxDay = DateTime(y, m + 1, 0).day;
    final d = (day ?? this.day).clamp(1, maxDay);

    final dt = isUtc
        ? DateTime.utc(y, m, d, hour, minute, second, millisecond, microsecond)
        : DateTime(y, m, d, hour, minute, second, millisecond, microsecond);
    return _copyWith(dateTime: dt);
  }

  /// Returns a new [Hora] set to the start of the specified unit.
  Hora startOf(TemporalUnit unit) {
    if (!_isValid) return this;

    return switch (unit) {
      TemporalUnit.year => Hora.of(
          year: year,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.quarter => Hora.of(
          year: year,
          month: (quarter - 1) * 3 + 1,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.month => Hora.of(
          year: year,
          month: month,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.week => _startOfWeek(),
      TemporalUnit.day => Hora.of(
          year: year,
          month: month,
          day: day,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.hour => Hora.of(
          year: year,
          month: month,
          day: day,
          hour: hour,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.minute => Hora.of(
          year: year,
          month: month,
          day: day,
          hour: hour,
          minute: minute,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.second => Hora.of(
          year: year,
          month: month,
          day: day,
          hour: hour,
          minute: minute,
          second: second,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.millisecond => Hora.of(
          year: year,
          month: month,
          day: day,
          hour: hour,
          minute: minute,
          second: second,
          millisecond: millisecond,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.microsecond => this,
    };
  }

  Hora _startOfWeek() {
    final weekStart = _locale.weekStart;
    var diff = weekday - weekStart;
    if (diff < 0) diff += 7;
    return subtract(diff, TemporalUnit.day).startOf(TemporalUnit.day);
  }

  /// Returns a new [Hora] set to the end of the specified unit.
  Hora endOf(TemporalUnit unit) {
    if (!_isValid) return this;

    return switch (unit) {
      TemporalUnit.year => Hora.of(
          year: year,
          month: 12,
          day: 31,
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.quarter => Hora.of(
          year: year,
          month: quarter * 3,
          day: DateTime(year, quarter * 3 + 1, 0).day,
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.month => Hora.of(
          year: year,
          month: month,
          day: daysInMonth,
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.week => _endOfWeek(),
      TemporalUnit.day => Hora.of(
          year: year,
          month: month,
          day: day,
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.hour => Hora.of(
          year: year,
          month: month,
          day: day,
          hour: hour,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.minute => Hora.of(
          year: year,
          month: month,
          day: day,
          hour: hour,
          minute: minute,
          second: 59,
          millisecond: 999,
          microsecond: 999,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.second => Hora.of(
          year: year,
          month: month,
          day: day,
          hour: hour,
          minute: minute,
          second: second,
          millisecond: 999,
          microsecond: 999,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.millisecond => Hora.of(
          year: year,
          month: month,
          day: day,
          hour: hour,
          minute: minute,
          second: second,
          millisecond: millisecond,
          microsecond: 999,
          utc: isUtc,
          locale: _locale,
        ),
      TemporalUnit.microsecond => this,
    };
  }

  Hora _endOfWeek() {
    final weekEnd = (_locale.weekStart + 6) % 7;
    var diff = weekEnd - weekday;
    if (diff < 0) diff += 7;
    return add(diff, TemporalUnit.day).endOf(TemporalUnit.day);
  }

  // ============ Comparison ============

  /// Whether this is before [other].
  bool isBefore(Hora other) => _dt.isBefore(other._dt);

  /// Whether this is after [other].
  bool isAfter(Hora other) => _dt.isAfter(other._dt);

  /// Whether this is the same as [other] at the given granularity.
  bool isSame(Hora other, [TemporalUnit unit = TemporalUnit.millisecond]) =>
      startOf(unit)._dt.isAtSameMomentAs(other.startOf(unit)._dt);

  /// Whether this is the same or before [other].
  bool isSameOrBefore(Hora other, [TemporalUnit? unit]) {
    if (unit != null) {
      return isSame(other, unit) || isBefore(other);
    }
    return !isAfter(other);
  }

  /// Whether this is the same or after [other].
  bool isSameOrAfter(Hora other, [TemporalUnit? unit]) {
    if (unit != null) {
      return isSame(other, unit) || isAfter(other);
    }
    return !isBefore(other);
  }

  /// Whether this is between [start] and [end].
  ///
  /// [inclusivity] controls boundary inclusion:
  /// - '()' excludes both (default)
  /// - '[]' includes both
  /// - '[)' includes start only
  /// - '(]' includes end only
  bool isBetween(Hora start, Hora end, [String inclusivity = '()']) {
    final includeStart = inclusivity.startsWith('[');
    final includeEnd = inclusivity.endsWith(']');

    final afterStart = includeStart ? isSameOrAfter(start) : isAfter(start);
    final beforeEnd = includeEnd ? isSameOrBefore(end) : isBefore(end);

    return afterStart && beforeEnd;
  }

  /// The difference between this and [other].
  Duration difference(Hora other) => _dt.difference(other._dt);

  /// The difference in the specified unit.
  ///
  /// If [precise] is true, returns a fractional result.
  num diff(Hora other, TemporalUnit unit, {bool precise = false}) {
    final diffMs = unixMillis - other.unixMillis;

    num result;
    switch (unit) {
      case TemporalUnit.year:
        result = _monthDiff(other) / 12;
      case TemporalUnit.quarter:
        result = _monthDiff(other) / 3;
      case TemporalUnit.month:
        result = _monthDiff(other);
      case TemporalUnit.week:
        result = diffMs / Duration.millisecondsPerDay / 7;
      case TemporalUnit.day:
        result = diffMs / Duration.millisecondsPerDay;
      case TemporalUnit.hour:
        result = diffMs / Duration.millisecondsPerHour;
      case TemporalUnit.minute:
        result = diffMs / Duration.millisecondsPerMinute;
      case TemporalUnit.second:
        result = diffMs / Duration.millisecondsPerSecond;
      case TemporalUnit.millisecond:
        result = diffMs.toDouble();
      case TemporalUnit.microsecond:
        result = (unixMicros - other.unixMicros).toDouble();
    }

    return precise ? result : result.truncate();
  }

  double _monthDiff(Hora other) {
    if (day < other.day) {
      return -other._monthDiff(this);
    }
    final wholeMonths = (year - other.year) * 12 + (month - other.month);
    final anchor = other.add(wholeMonths, TemporalUnit.month);
    final isNegative = isBefore(anchor);
    final anchor2 =
        other.add(wholeMonths + (isNegative ? -1 : 1), TemporalUnit.month);

    final diff = unixMillis - anchor.unixMillis;
    final range = isNegative
        ? anchor.unixMillis - anchor2.unixMillis
        : anchor2.unixMillis - anchor.unixMillis;

    return wholeMonths + diff / range;
  }

  @override
  int compareTo(Hora other) => _dt.compareTo(other._dt);

  // ============ Query ============

  /// Whether this is today.
  bool get isToday => isSame(Hora.now(), TemporalUnit.day);

  /// Whether this is yesterday.
  bool get isYesterday =>
      isSame(Hora.now().subtract(1, TemporalUnit.day), TemporalUnit.day);

  /// Whether this is tomorrow.
  bool get isTomorrow =>
      isSame(Hora.now().add(1, TemporalUnit.day), TemporalUnit.day);

  /// Whether this is in the past.
  bool get isPast => isBefore(Hora.now());

  /// Whether this is in the future.
  bool get isFuture => isAfter(Hora.now());

  /// Whether this is a weekend day (Saturday or Sunday).
  bool get isWeekend =>
      weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Whether this is a weekday (Monday to Friday).
  bool get isWeekday => !isWeekend;

  // ============ Conversion ============

  /// Converts to UTC timezone.
  Hora toUtc() => _copyWith(dateTime: _dt.toUtc());

  /// Converts to local timezone.
  Hora toLocal() => _copyWith(dateTime: _dt.toLocal());

  /// Converts to a different locale.
  Hora withLocale(HoraLocale locale) => _copyWith(locale: locale);

  /// Creates a copy with optional modifications.
  Hora copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
    bool? utc,
    HoraLocale? locale,
  }) {
    final y = year ?? this.year;
    final m = month ?? this.month;
    final maxDay = DateTime(y, m + 1, 0).day;
    final d = (day ?? this.day).clamp(1, maxDay);

    final isUtcResult = utc ?? isUtc;
    final dt = isUtcResult
        ? DateTime.utc(
            y,
            m,
            d,
            hour ?? this.hour,
            minute ?? this.minute,
            second ?? this.second,
            millisecond ?? this.millisecond,
            microsecond ?? this.microsecond,
          )
        : DateTime(
            y,
            m,
            d,
            hour ?? this.hour,
            minute ?? this.minute,
            second ?? this.second,
            millisecond ?? this.millisecond,
            microsecond ?? this.microsecond,
          );

    return Hora._clone(dt, locale ?? _locale, _isValid);
  }

  Hora _copyWith({DateTime? dateTime, HoraLocale? locale}) =>
      Hora._clone(dateTime ?? _dt, locale ?? _locale, _isValid);

  /// Converts to a [DateTime].
  /// Throws [StateError] if this is an invalid Hora instance.
  DateTime toDateTime() => _dt;

  /// Converts to a list: [year, month, day, hour, minute, second, ms, μs].
  List<int> toList() => [
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      ];

  /// Converts to a map of components.
  Map<String, int> toMap() => {
        'year': year,
        'month': month,
        'day': day,
        'hour': hour,
        'minute': minute,
        'second': second,
        'millisecond': millisecond,
        'microsecond': microsecond,
      };

  // ============ Formatting ============

  /// Formats the date-time using the given pattern.
  ///
  /// See [HoraFormatter] for available tokens.
  String format([String pattern = 'YYYY-MM-DDTHH:mm:ssZ']) =>
      HoraFormatter.format(this, pattern);

  /// Returns the ISO 8601 string representation.
  String toIso8601() => _dt.toIso8601String();

  // ============ Operators ============

  /// Adds a [Duration].
  Hora operator +(Duration duration) => addDuration(duration);

  /// Subtracts a [Duration].
  Hora operator -(Duration duration) => subtractDuration(duration);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Hora &&
          _dateTime == other._dateTime &&
          _isValid == other._isValid;

  @override
  int get hashCode => Object.hash(_dateTime, _isValid);

  @override
  String toString() => isValid ? toIso8601() : 'Invalid Hora';

  // ============ Parsing Helpers ============

  static DateTime? _tryParseFormats(String input) {
    // Common date patterns
    final patterns = [
      // YYYY/MM/DD
      RegExp(r'^(\d{4})/(\d{1,2})/(\d{1,2})$'),
      // DD/MM/YYYY
      RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$'),
      // YYYY.MM.DD
      RegExp(r'^(\d{4})\.(\d{1,2})\.(\d{1,2})$'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(input);
      if (match != null) {
        try {
          if (input.contains('/') && !input.startsWith(RegExp(r'\d{4}'))) {
            // DD/MM/YYYY format
            return DateTime(
              int.parse(match.group(3)!),
              int.parse(match.group(2)!),
              int.parse(match.group(1)!),
            );
          } else {
            // YYYY/MM/DD or YYYY.MM.DD format
            return DateTime(
              int.parse(match.group(1)!),
              int.parse(match.group(2)!),
              int.parse(match.group(3)!),
            );
          }
        } catch (_) {
          continue;
        }
      }
    }

    return null;
  }
}

/// Date-time formatter for [Hora].
class HoraFormatter {
  HoraFormatter._();

  static final _formatRegex = RegExp(
    r'\[([^\]]+)]|Y{1,4}|M{1,4}|D{1,2}|d{1,4}|H{1,2}|h{1,2}|a|A|m{1,2}|s{1,2}|S{1,3}|Z{1,2}|X|x|Q|w{1,2}|W{1,2}|k{1,2}|E',
  );

  /// Formats a [Hora] using the given pattern.
  ///
  /// ## Tokens
  ///
  /// | Token | Output |
  /// |-------|--------|
  /// | YY | 23 |
  /// | YYYY | 2023 |
  /// | M | 1-12 |
  /// | MM | 01-12 |
  /// | MMM | Jan-Dec |
  /// | MMMM | January-December |
  /// | D | 1-31 |
  /// | DD | 01-31 |
  /// | d | 0-6 (weekday) |
  /// | dd | Su-Sa |
  /// | ddd | Sun-Sat |
  /// | dddd | Sunday-Saturday |
  /// | H | 0-23 |
  /// | HH | 00-23 |
  /// | h | 1-12 |
  /// | hh | 01-12 |
  /// | k | 1-24 |
  /// | kk | 01-24 |
  /// | m | 0-59 |
  /// | mm | 00-59 |
  /// | s | 0-59 |
  /// | ss | 00-59 |
  /// | S | 0-9 (1/10 second) |
  /// | SS | 00-99 (1/100 second) |
  /// | SSS | 000-999 (millisecond) |
  /// | a | am/pm |
  /// | A | AM/PM |
  /// | Z | +05:00 |
  /// | ZZ | +0500 |
  /// | X | Unix timestamp (seconds) |
  /// | x | Unix timestamp (ms) |
  /// | Q | 1-4 (quarter) |
  /// | w | 1-53 (week of year) |
  /// | ww | 01-53 |
  /// | W | 1-53 (ISO week) |
  /// | WW | 01-53 |
  /// | E | 1-7 (ISO weekday) |
  /// | \[text\] | Escaped text |
  static String format(Hora hora, String pattern) {
    if (!hora.isValid) {
      return hora.locale.invalidDate;
    }

    return pattern.replaceAllMapped(_formatRegex, (match) {
      final token = match.group(0)!;

      // Handle escaped text
      if (token.startsWith('[') && token.endsWith(']')) {
        return token.substring(1, token.length - 1);
      }

      return _formatToken(hora, token);
    });
  }

  static String _formatToken(Hora h, String token) {
    final locale = h.locale;

    return switch (token) {
      // Year
      'YY' => (h.year % 100).toString().padLeft(2, '0'),
      'YYYY' => h.year.toString().padLeft(4, '0'),
      // Month
      'M' => h.month.toString(),
      'MM' => h.month.toString().padLeft(2, '0'),
      'MMM' => locale.monthsShort[h.month - 1],
      'MMMM' => locale.months[h.month - 1],
      // Day
      'D' => h.day.toString(),
      'DD' => h.day.toString().padLeft(2, '0'),
      // Weekday
      'd' => (h.weekday % 7).toString(), // 0=Sunday
      'dd' => locale.weekdaysMin[h.weekday % 7],
      'ddd' => locale.weekdaysShort[h.weekday % 7],
      'dddd' => locale.weekdays[h.weekday % 7],
      'E' => h.weekday.toString(), // 1=Monday (ISO)
      // Hour (24h)
      'H' => h.hour.toString(),
      'HH' => h.hour.toString().padLeft(2, '0'),
      // Hour (12h)
      'h' => ((h.hour % 12) == 0 ? 12 : h.hour % 12).toString(),
      'hh' =>
        ((h.hour % 12) == 0 ? 12 : h.hour % 12).toString().padLeft(2, '0'),
      // Hour (1-24)
      'k' => (h.hour == 0 ? 24 : h.hour).toString(),
      'kk' => (h.hour == 0 ? 24 : h.hour).toString().padLeft(2, '0'),
      // Minute
      'm' => h.minute.toString(),
      'mm' => h.minute.toString().padLeft(2, '0'),
      // Second
      's' => h.second.toString(),
      'ss' => h.second.toString().padLeft(2, '0'),
      // Fractional seconds
      'S' => (h.millisecond ~/ 100).toString(),
      'SS' => (h.millisecond ~/ 10).toString().padLeft(2, '0'),
      'SSS' => h.millisecond.toString().padLeft(3, '0'),
      // AM/PM
      'a' => locale.meridiem(h.hour, h.minute, lowercase: true),
      'A' => locale.meridiem(h.hour, h.minute),
      // Timezone
      'Z' => _formatOffset(h.timeZoneOffset, ':'),
      'ZZ' => _formatOffset(h.timeZoneOffset, ''),
      // Unix timestamp
      'X' => h.unix.toString(),
      'x' => h.unixMillis.toString(),
      // Quarter
      'Q' => h.quarter.toString(),
      // Week of year
      'w' => _weekOfYear(h).toString(),
      'ww' => _weekOfYear(h).toString().padLeft(2, '0'),
      // ISO week
      'W' => h.isoWeek.toString(),
      'WW' => h.isoWeek.toString().padLeft(2, '0'),
      _ => token,
    };
  }

  static String _formatOffset(Duration offset, String separator) {
    final isNegative = offset.isNegative;
    final abs = offset.abs();
    final hours = abs.inHours;
    final minutes = abs.inMinutes % 60;
    final sign = isNegative ? '-' : '+';
    return '$sign${hours.toString().padLeft(2, '0')}$separator${minutes.toString().padLeft(2, '0')}';
  }

  static int _weekOfYear(Hora h) {
    final yearStart = h.locale.yearStart;
    final startOfYear = DateTime(h.year, 1, yearStart);
    final startOfWeek = startOfYear.subtract(
      Duration(days: (startOfYear.weekday - h.locale.weekStart + 7) % 7),
    );

    if (h.dateTime.isBefore(startOfWeek)) {
      // Belongs to previous year's last week
      return Hora.of(year: h.year - 1, month: 12, day: 31, locale: h.locale)
          .isoWeek;
    }

    final diff = h.dateTime.difference(startOfWeek).inDays;
    return (diff ~/ 7) + 1;
  }
}
