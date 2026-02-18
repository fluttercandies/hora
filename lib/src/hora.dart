import 'package:meta/meta.dart';

import 'locale.dart';
import 'units.dart';

/// Parsing behavior for [Hora.parse] and [Hora.from] string inputs.
enum HoraParseMode {
  /// Parse only native ISO 8601 and `DateTime`-supported formats.
  strict,

  /// Parse ISO first, then fallback to additional common formats.
  smart,
}

/// Precision for Unix timestamp inputs in [Hora.from].
enum UnixTimestampUnit {
  /// Detect precision from digit length.
  auto,

  /// Seconds since epoch.
  seconds,

  /// Milliseconds since epoch.
  milliseconds,

  /// Microseconds since epoch.
  microseconds,
}

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

  /// Creates a [Hora] from a Unix timestamp with configurable precision.
  factory Hora.fromTimestamp(
    int value, {
    HoraLocale? locale,
    bool utc = false,
    UnixTimestampUnit unit = UnixTimestampUnit.auto,
  }) {
    final dt = _dateTimeFromUnixTimestamp(value, unit: unit);
    final result = Hora.fromDateTime(dt, locale: locale);
    return utc ? result.toUtc() : result;
  }

  /// Creates a [Hora] from map-based date-time input.
  ///
  /// Common supported fields:
  /// - Absolute date parts: `year`, `month`, `day` (or plural forms)
  /// - Time parts: `hour`, `minute`, `second`, `millisecond`, `microsecond`
  /// - Date string: `date`, `datetime`, `iso`
  /// - Unix timestamps: `timestamp`, `unix`, `unixMillis`, `unixMicros`
  /// - UTC flag: `utc`
  factory Hora.fromMap(
    Map<String, Object?> source, {
    HoraLocale? locale,
    bool utc = false,
    HoraParseMode parseMode = HoraParseMode.smart,
    UnixTimestampUnit timestampUnit = UnixTimestampUnit.auto,
  }) {
    final normalized = _normalizeMap(source);
    if (normalized.isEmpty) {
      throw ArgumentError.value(
        source,
        'source',
        'Map must contain at least one string key.',
      );
    }
    return Hora._fromNormalizedMap(
      normalized,
      locale: locale,
      utc: utc,
      parseMode: parseMode,
      timestampUnit: timestampUnit,
    );
  }

  /// Creates a [Hora] from mixed input types with a single API.
  ///
  /// Supported [source] types:
  /// - [Hora]
  /// - [DateTime]
  /// - [String] (parsed via [Hora.parse])
  /// - [int]/[num] Unix timestamp
  /// - `Map<String, Object?>` date components
  ///
  /// When [source] is numeric, [timestampUnit] controls its precision.
  /// With [UnixTimestampUnit.auto], precision is inferred from digit length.
  factory Hora.from(
    Object source, {
    HoraLocale? locale,
    bool utc = false,
    UnixTimestampUnit timestampUnit = UnixTimestampUnit.auto,
    HoraParseMode parseMode = HoraParseMode.smart,
  }) {
    if (source is Hora) {
      if (!source.isValid) {
        return Hora._invalid(locale ?? source.locale);
      }
      final withTimezone = utc ? source.toUtc() : source;
      return locale != null ? withTimezone.withLocale(locale) : withTimezone;
    }

    if (source is DateTime) {
      final dt = utc ? source.toUtc() : source;
      return Hora.fromDateTime(dt, locale: locale);
    }

    if (source is String) {
      final parsed = Hora.parse(source, locale: locale, mode: parseMode);
      if (!parsed.isValid) return parsed;
      return utc ? parsed.toUtc() : parsed;
    }

    if (source is int) {
      return Hora.fromTimestamp(
        source,
        locale: locale,
        utc: utc,
        unit: timestampUnit,
      );
    }

    if (source is double) {
      if (source.isNaN || source.isInfinite) {
        throw ArgumentError.value(
          source,
          'source',
          'Unix timestamp must be a finite integer.',
        );
      }
      if (source % 1 != 0) {
        throw ArgumentError.value(
          source,
          'source',
          'Unix timestamp must be an integer.',
        );
      }
      return Hora.fromTimestamp(
        source.toInt(),
        locale: locale,
        utc: utc,
        unit: timestampUnit,
      );
    }

    if (source is Map) {
      final normalized = _normalizeMap(source);
      if (normalized.isEmpty) {
        throw ArgumentError.value(
          source,
          'source',
          'Map source must contain at least one string key.',
        );
      }
      return Hora._fromNormalizedMap(
        normalized,
        locale: locale,
        utc: utc,
        parseMode: parseMode,
        timestampUnit: timestampUnit,
      );
    }

    throw ArgumentError.value(
      source,
      'source',
      'Unsupported input type. Use Hora, DateTime, String, num, or Map.',
    );
  }

  /// Parses a date-time string.
  ///
  /// Supports ISO 8601 and common formats.
  /// Returns an invalid [Hora] if parsing fails (check with [isValid]).
  factory Hora.parse(
    String input, {
    HoraLocale? locale,
    HoraParseMode mode = HoraParseMode.smart,
  }) {
    final normalized = input.trim();
    if (_hasInvalidIsoLikeComponents(normalized)) {
      return Hora._invalid(locale ?? Hora.globalLocale);
    }
    final dt = DateTime.tryParse(normalized);
    if (dt != null) {
      return Hora.fromDateTime(dt, locale: locale);
    }

    if (mode == HoraParseMode.strict) {
      return Hora._invalid(locale ?? Hora.globalLocale);
    }

    // Try additional formats in smart mode.
    final parsed = _tryParseFormats(normalized);
    if (parsed != null) {
      return Hora.fromDateTime(parsed, locale: locale);
    }
    return Hora._invalid(locale ?? Hora.globalLocale);
  }

  /// Tries to parse a date-time string, returns null if invalid.
  static Hora? tryParse(
    String input, {
    HoraLocale? locale,
    HoraParseMode mode = HoraParseMode.smart,
  }) {
    final result = Hora.parse(input, locale: locale, mode: mode);
    return result.isValid ? result : null;
  }

  /// Tries to create [Hora] from mixed input types, returns null on failure.
  static Hora? tryFrom(
    Object? source, {
    HoraLocale? locale,
    bool utc = false,
    UnixTimestampUnit timestampUnit = UnixTimestampUnit.auto,
    HoraParseMode parseMode = HoraParseMode.smart,
  }) {
    if (source == null) return null;
    try {
      final result = Hora.from(
        source,
        locale: locale,
        utc: utc,
        timestampUnit: timestampUnit,
        parseMode: parseMode,
      );
      return result.isValid ? result : null;
    } catch (error) {
      if (error is ArgumentError || error is FormatException) {
        return null;
      }
      rethrow;
    }
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
    final startOfYear = DateTime.utc(year);
    final currentDate = DateTime.utc(year, month, day);
    return currentDate.difference(startOfYear).inDays + 1;
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
    final currentDate = DateTime.utc(year, month, day);
    final thursday = currentDate.add(Duration(days: 4 - currentDate.weekday));
    final firstThursday = DateTime.utc(thursday.year, 1, 4);
    final firstMonday = firstThursday.subtract(
      Duration(days: firstThursday.weekday - 1),
    );
    return ((thursday.difference(firstMonday).inDays) ~/ 7) + 1;
  }

  /// The ISO week year.
  int get isoWeekYear {
    final currentDate = DateTime.utc(year, month, day);
    final thursday = currentDate.add(Duration(days: 4 - currentDate.weekday));
    return thursday.year;
  }

  /// Number of ISO weeks in the year.
  int get isoWeeksInYear {
    final dec28 = DateTime.utc(year, 12, 28);
    final dayOfDec28 = dec28.weekday;
    final lastThursday = dec28.add(Duration(days: 4 - dayOfDec28));
    final firstThursday = DateTime.utc(year, 1, 4).subtract(
      Duration(days: DateTime.utc(year, 1, 4).weekday - 4),
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

  /// Adds multiple units in one call.
  ///
  /// This is a 2.0-friendly API for reducing chaining and improving
  /// readability at call sites.
  Hora plus({
    int years = 0,
    int quarters = 0,
    int months = 0,
    int weeks = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) =>
      _applyCompositeDelta(
        years: years,
        quarters: quarters,
        months: months,
        weeks: weeks,
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds,
      );

  /// Subtracts multiple units in one call.
  Hora minus({
    int years = 0,
    int quarters = 0,
    int months = 0,
    int weeks = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) =>
      _applyCompositeDelta(
        negate: true,
        years: years,
        quarters: quarters,
        months: months,
        weeks: weeks,
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds,
      );

  Hora _applyCompositeDelta({
    bool negate = false,
    int years = 0,
    int quarters = 0,
    int months = 0,
    int weeks = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) {
    if (!_isValid) return this;

    final factor = negate ? -1 : 1;
    var result = this;
    final deltas = <(int amount, TemporalUnit unit)>[
      (years * factor, TemporalUnit.year),
      (quarters * factor, TemporalUnit.quarter),
      (months * factor, TemporalUnit.month),
      (weeks * factor, TemporalUnit.week),
      (days * factor, TemporalUnit.day),
      (hours * factor, TemporalUnit.hour),
      (minutes * factor, TemporalUnit.minute),
      (seconds * factor, TemporalUnit.second),
      (milliseconds * factor, TemporalUnit.millisecond),
      (microseconds * factor, TemporalUnit.microsecond),
    ];

    for (final (amount, unit) in deltas) {
      if (amount == 0) continue;
      result = result.add(amount, unit);
    }
    return result;
  }

  /// Alias for [copyWith] with a shorter, intention-revealing name.
  Hora set({
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
  }) =>
      copyWith(
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second,
        millisecond: millisecond,
        microsecond: microsecond,
        utc: utc,
        locale: locale,
      );

  /// Returns a new [Hora] with a [Duration] added.
  Hora addDuration(Duration duration) {
    if (!_isValid) return this;
    return _addDuration(duration);
  }

  /// Returns a new [Hora] with a [Duration] subtracted.
  Hora subtractDuration(Duration duration) {
    if (!_isValid) return this;
    return _addDuration(-duration);
  }

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

  bool _canCompareWith(Hora other) => _isValid && other._isValid;

  void _requireComparableWith(Hora other, String operation) {
    if (_canCompareWith(other)) return;
    throw StateError('Cannot $operation with invalid Hora instances.');
  }

  static HoraInclusivity _parseInclusivity(String inclusivity) =>
      HoraInclusivity.tryParse(inclusivity) ??
      (throw ArgumentError.value(
        inclusivity,
        'inclusivity',
        'Must be one of "()", "[]", "[)", "(]".',
      ));

  static (bool includeStart, bool includeEnd) _resolveInclusivity(
    HoraInclusivity inclusivity,
  ) =>
      switch (inclusivity) {
        HoraInclusivity.exclusive => (false, false),
        HoraInclusivity.inclusive => (true, true),
        HoraInclusivity.includeStart => (true, false),
        HoraInclusivity.includeEnd => (false, true),
      };

  /// Whether this is between [start] and [end] with typed boundary control.
  bool isBetweenWith(
    Hora start,
    Hora end, {
    HoraInclusivity inclusivity = HoraInclusivity.exclusive,
  }) {
    final (includeStart, includeEnd) = _resolveInclusivity(inclusivity);
    if (!_isValid || !start._isValid || !end._isValid) return false;

    final afterStart = includeStart ? isSameOrAfter(start) : isAfter(start);
    final beforeEnd = includeEnd ? isSameOrBefore(end) : isBefore(end);

    return afterStart && beforeEnd;
  }

  /// Whether this is between [start] and [end].
  ///
  /// [inclusivity] controls boundary inclusion:
  /// - '()' excludes both (default)
  /// - '[]' includes both
  /// - '[)' includes start only
  /// - '(]' includes end only
  ///
  /// For type-safe usage, prefer [isBetweenWith] + [HoraInclusivity].
  bool isBetween(Hora start, Hora end, [String inclusivity = '()']) {
    final parsedInclusivity = _parseInclusivity(inclusivity);
    return isBetweenWith(start, end, inclusivity: parsedInclusivity);
  }

  /// Whether this is before [other].
  bool isBefore(Hora other) {
    if (!_canCompareWith(other)) return false;
    return _dt.isBefore(other._dt);
  }

  /// Whether this is after [other].
  bool isAfter(Hora other) {
    if (!_canCompareWith(other)) return false;
    return _dt.isAfter(other._dt);
  }

  /// Whether this is the same as [other] at the given granularity.
  bool isSame(Hora other, [TemporalUnit unit = TemporalUnit.millisecond]) {
    if (!_canCompareWith(other)) return false;
    return startOf(unit)._dt.isAtSameMomentAs(other.startOf(unit)._dt);
  }

  /// Whether this is the same or before [other].
  bool isSameOrBefore(Hora other, [TemporalUnit? unit]) {
    if (!_canCompareWith(other)) return false;
    if (unit != null) {
      return isSame(other, unit) || isBefore(other);
    }
    return !isAfter(other);
  }

  /// Whether this is the same or after [other].
  bool isSameOrAfter(Hora other, [TemporalUnit? unit]) {
    if (!_canCompareWith(other)) return false;
    if (unit != null) {
      return isSame(other, unit) || isAfter(other);
    }
    return !isBefore(other);
  }

  /// The difference between this and [other].
  Duration difference(Hora other) {
    _requireComparableWith(other, 'calculate difference');
    return _dt.difference(other._dt);
  }

  /// The difference in the specified unit.
  ///
  /// If [precise] is true, returns a fractional result.
  num diff(Hora other, TemporalUnit unit, {bool precise = false}) {
    _requireComparableWith(other, 'calculate diff');

    final diffUs = unixMicros - other.unixMicros;

    num result;
    switch (unit) {
      case TemporalUnit.year:
        result = _monthDiff(other) / 12;
      case TemporalUnit.quarter:
        result = _monthDiff(other) / 3;
      case TemporalUnit.month:
        result = _monthDiff(other);
      case TemporalUnit.week:
        result = diffUs / Duration.microsecondsPerDay / 7;
      case TemporalUnit.day:
        result = diffUs / Duration.microsecondsPerDay;
      case TemporalUnit.hour:
        result = diffUs / Duration.microsecondsPerHour;
      case TemporalUnit.minute:
        result = diffUs / Duration.microsecondsPerMinute;
      case TemporalUnit.second:
        result = diffUs / Duration.microsecondsPerSecond;
      case TemporalUnit.millisecond:
        result = diffUs / Duration.microsecondsPerMillisecond;
      case TemporalUnit.microsecond:
        result = diffUs.toDouble();
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
  int compareTo(Hora other) {
    _requireComparableWith(other, 'compare');
    return _dt.compareTo(other._dt);
  }

  // ============ Query ============

  /// Whether this is today.
  bool get isToday => isSame(Hora.now(), TemporalUnit.day);

  /// Whether this is yesterday.
  bool get isYesterday =>
      isSame(Hora.now().subtract(1, TemporalUnit.day), TemporalUnit.day);

  /// Whether this is tomorrow.
  bool get isTomorrow =>
      isSame(Hora.now().add(1, TemporalUnit.day), TemporalUnit.day);

  /// Whether this is in the current week.
  bool get isThisWeek => isSame(Hora.now(), TemporalUnit.week);

  /// Whether this is in the current month.
  bool get isThisMonth => isSame(Hora.now(), TemporalUnit.month);

  /// Whether this is in the current year.
  bool get isThisYear => isSame(Hora.now(), TemporalUnit.year);

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
  Hora toUtc() {
    if (!_isValid) return this;
    return _copyWith(dateTime: _dt.toUtc());
  }

  /// Converts to local timezone.
  Hora toLocal() {
    if (!_isValid) return this;
    return _copyWith(dateTime: _dt.toLocal());
  }

  /// Converts to a different locale.
  Hora withLocale(HoraLocale locale) {
    if (!_isValid) return Hora._invalid(locale);
    return _copyWith(locale: locale);
  }

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
    if (!_isValid) {
      return Hora._invalid(locale ?? _locale);
    }

    final y = year ?? this.year;
    final m = month ?? this.month;
    _requireRange('month', m, 1, 12);
    _validateTimeParts(
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
      microsecond: microsecond,
    );

    final maxDay = DateTime(y, m + 1, 0).day;
    final d = switch (day) {
      final explicitDay? => (() {
          _requireRange('day', explicitDay, 1, maxDay);
          return explicitDay;
        })(),
      null => this.day.clamp(1, maxDay),
    };

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

  Hora _copyWith({DateTime? dateTime, HoraLocale? locale}) {
    if (!_isValid) {
      return Hora._invalid(locale ?? _locale);
    }
    return Hora._clone(dateTime ?? _dt, locale ?? _locale, _isValid);
  }

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

  static DateTime _dateTimeFromUnixTimestamp(
    int value, {
    UnixTimestampUnit unit = UnixTimestampUnit.auto,
  }) {
    final resolvedUnit =
        unit == UnixTimestampUnit.auto ? _detectTimestampUnit(value) : unit;

    return switch (resolvedUnit) {
      UnixTimestampUnit.seconds =>
        DateTime.fromMillisecondsSinceEpoch(value * 1000),
      UnixTimestampUnit.milliseconds =>
        DateTime.fromMillisecondsSinceEpoch(value),
      UnixTimestampUnit.microseconds =>
        DateTime.fromMicrosecondsSinceEpoch(value),
      UnixTimestampUnit.auto =>
        throw StateError('Unexpected auto unit after resolution'),
    };
  }

  static UnixTimestampUnit _detectTimestampUnit(int value) {
    final abs = value.abs();
    if (abs < 100000000000) return UnixTimestampUnit.seconds;
    if (abs < 100000000000000) return UnixTimestampUnit.milliseconds;
    return UnixTimestampUnit.microseconds;
  }

  static const List<String> _mapUtcKeys = ['utc', 'isutc'];
  static const List<String> _mapUnixMicrosKeys = [
    'unixmicros',
    'unixus',
    'timestampus',
    'timestampmicroseconds',
  ];
  static const List<String> _mapUnixMillisKeys = [
    'unixmillis',
    'unixms',
    'timestampms',
    'timestampmilliseconds',
  ];
  static const List<String> _mapUnixSecondsKeys = ['unix', 'timestampseconds'];
  static const List<String> _mapTimestampKeys = ['timestamp'];
  static const List<String> _mapDateKeys = ['date', 'datetime', 'iso'];
  static const List<String> _mapYearKeys = ['year', 'years'];
  static const List<String> _mapMonthKeys = ['month', 'months'];
  static const List<String> _mapDayKeys = ['day', 'days'];
  static const List<String> _mapHourKeys = ['hour', 'hours'];
  static const List<String> _mapMinuteKeys = ['minute', 'minutes'];
  static const List<String> _mapSecondKeys = ['second', 'seconds'];
  static const List<String> _mapMillisecondKeys = [
    'millisecond',
    'milliseconds',
  ];
  static const List<String> _mapMicrosecondKeys = [
    'microsecond',
    'microseconds',
  ];
  static const List<String> _mapComponentKeys = [
    ..._mapYearKeys,
    ..._mapMonthKeys,
    ..._mapDayKeys,
    ..._mapHourKeys,
    ..._mapMinuteKeys,
    ..._mapSecondKeys,
    ..._mapMillisecondKeys,
    ..._mapMicrosecondKeys,
  ];
  static const Set<String> _supportedMapKeys = {
    ..._mapUtcKeys,
    ..._mapUnixMicrosKeys,
    ..._mapUnixMillisKeys,
    ..._mapUnixSecondsKeys,
    ..._mapTimestampKeys,
    ..._mapDateKeys,
    ..._mapComponentKeys,
  };

  // ignore: prefer_constructors_over_static_methods
  static Hora _fromNormalizedMap(
    Map<String, Object?> normalized, {
    HoraLocale? locale,
    bool utc = false,
    HoraParseMode parseMode = HoraParseMode.smart,
    UnixTimestampUnit timestampUnit = UnixTimestampUnit.auto,
  }) {
    _validateSupportedMapKeys(normalized);

    final shouldUseUtc = utc || (_mapBool(normalized, _mapUtcKeys) ?? false);
    final unixMicros = _mapInt(normalized, _mapUnixMicrosKeys);
    final unixMillis = _mapInt(normalized, _mapUnixMillisKeys);
    final unixSeconds = _mapInt(normalized, _mapUnixSecondsKeys);
    final genericTimestamp = _mapInt(normalized, _mapTimestampKeys);
    final rawDate = _mapRawValue(
      normalized,
      _mapDateKeys,
      valueType: 'date value',
    );

    final timestampSourceCount = [
      unixMicros,
      unixMillis,
      unixSeconds,
      genericTimestamp,
    ].whereType<int>().length;
    if (timestampSourceCount > 1) {
      throw ArgumentError.value(
        normalized,
        'source',
        'Map must use exactly one timestamp source: '
            'unixMicros/unixMillis/unix/timestamp.',
      );
    }

    final hasTimestampSource = timestampSourceCount == 1;
    final hasDateSource = rawDate != null;
    final hasComponentSource = _containsAny(normalized, _mapComponentKeys);
    if (hasTimestampSource && (hasDateSource || hasComponentSource)) {
      throw ArgumentError.value(
        normalized,
        'source',
        'Map cannot mix timestamp fields with date/component fields.',
      );
    }

    if (unixMicros != null) {
      return Hora.fromTimestamp(
        unixMicros,
        locale: locale,
        utc: shouldUseUtc,
        unit: UnixTimestampUnit.microseconds,
      );
    }

    if (unixMillis != null) {
      return Hora.fromTimestamp(
        unixMillis,
        locale: locale,
        utc: shouldUseUtc,
        unit: UnixTimestampUnit.milliseconds,
      );
    }

    if (unixSeconds != null) {
      return Hora.fromTimestamp(
        unixSeconds,
        locale: locale,
        utc: shouldUseUtc,
        unit: UnixTimestampUnit.seconds,
      );
    }

    if (genericTimestamp != null) {
      return Hora.fromTimestamp(
        genericTimestamp,
        locale: locale,
        utc: shouldUseUtc,
        unit: timestampUnit,
      );
    }

    if (rawDate != null) {
      final hasExplicitTimezone =
          rawDate is String && _hasExplicitTimezone(rawDate);
      final parsed = _parseDateSource(
        rawDate,
        locale: locale,
        parseMode: parseMode,
      );
      if (!parsed.isValid) {
        throw ArgumentError.value(
          rawDate,
          'date',
          'Expected a valid and parseable date value.',
        );
      }

      final yearOverride = _mapInt(normalized, _mapYearKeys);
      final monthOverride = _mapInt(normalized, _mapMonthKeys);
      final dayOverride = _mapInt(normalized, _mapDayKeys);
      final hourOverride = _mapInt(normalized, _mapHourKeys);
      final minuteOverride = _mapInt(normalized, _mapMinuteKeys);
      final secondOverride = _mapInt(normalized, _mapSecondKeys);
      final millisecondOverride = _mapInt(normalized, _mapMillisecondKeys);
      final microsecondOverride = _mapInt(normalized, _mapMicrosecondKeys);

      _validateTimeParts(
        hour: hourOverride,
        minute: minuteOverride,
        second: secondOverride,
        millisecond: millisecondOverride,
        microsecond: microsecondOverride,
      );
      _validateDateParts(
        year: yearOverride,
        month: monthOverride,
        day: dayOverride,
        defaultYear: parsed.year,
        defaultMonth: parsed.month,
      );

      final withDateOverrides = parsed.copyWith(
        year: yearOverride,
        month: monthOverride,
        day: dayOverride,
        hour: hourOverride,
        minute: minuteOverride,
        second: secondOverride,
        millisecond: millisecondOverride,
        microsecond: microsecondOverride,
        locale: locale,
      );
      if (!shouldUseUtc) return withDateOverrides;

      if (rawDate is DateTime || rawDate is Hora || hasExplicitTimezone) {
        // Preserve the original instant when source already has timezone context.
        return withDateOverrides.toUtc();
      }
      // Treat date-only or naive string inputs as UTC-local components.
      return withDateOverrides.copyWith(utc: true);
    }

    final now = shouldUseUtc ? DateTime.now().toUtc() : DateTime.now();
    final year = _mapInt(normalized, _mapYearKeys) ?? now.year;
    final month = _mapInt(normalized, _mapMonthKeys) ?? 1;
    final day = _mapInt(normalized, _mapDayKeys) ?? 1;
    final hour = _mapInt(normalized, _mapHourKeys) ?? 0;
    final minute = _mapInt(normalized, _mapMinuteKeys) ?? 0;
    final second = _mapInt(normalized, _mapSecondKeys) ?? 0;
    final millisecond = _mapInt(normalized, _mapMillisecondKeys) ?? 0;
    final microsecond = _mapInt(normalized, _mapMicrosecondKeys) ?? 0;

    _validateDateParts(
      year: year,
      month: month,
      day: day,
    );
    _validateTimeParts(
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
      microsecond: microsecond,
    );

    return Hora.of(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
      microsecond: microsecond,
      utc: shouldUseUtc,
      locale: locale,
    );
  }

  static Hora _parseDateSource(
    Object rawDate, {
    HoraLocale? locale,
    HoraParseMode parseMode = HoraParseMode.smart,
  }) =>
      switch (rawDate) {
        final Hora h => h,
        final DateTime dt => Hora.fromDateTime(dt, locale: locale),
        final String s => Hora.parse(s, locale: locale, mode: parseMode),
        _ => throw ArgumentError.value(
            rawDate,
            'date',
            'Expected a String, DateTime, or Hora value.',
          ),
      };

  static bool _containsAny(Map<String, Object?> source, List<String> keys) =>
      keys.any(source.containsKey);

  static Map<String, Object?> _normalizeMap(Map<Object?, Object?> source) {
    final normalized = <String, Object?>{};
    final firstOriginalKey = <String, String>{};
    for (final entry in source.entries) {
      final key = entry.key;
      if (key is! String) {
        throw ArgumentError.value(
          key,
          'source',
          'Map keys must be strings.',
        );
      }

      final canonical = _canonicalKey(key);
      if (!normalized.containsKey(canonical)) {
        normalized[canonical] = entry.value;
        firstOriginalKey[canonical] = key;
        continue;
      }

      final existing = normalized[canonical];
      if (!_canonicalValueEqual(canonical, existing, entry.value)) {
        throw ArgumentError.value(
          entry.value,
          key,
          'Conflicting values for key "$canonical" '
          'from "${firstOriginalKey[canonical]}" and "$key".',
        );
      }
    }
    return normalized;
  }

  static void _validateSupportedMapKeys(Map<String, Object?> normalized) {
    final unknownKeys = normalized.keys
        .where((key) => !_supportedMapKeys.contains(key))
        .toList()
      ..sort();
    if (unknownKeys.isEmpty) return;

    throw ArgumentError.value(
      normalized,
      'source',
      'Unsupported key(s): ${unknownKeys.join(', ')}.',
    );
  }

  static const Set<String> _canonicalBoolKeys = {..._mapUtcKeys};
  static const Set<String> _canonicalIntKeys = {
    ..._mapYearKeys,
    ..._mapMonthKeys,
    ..._mapDayKeys,
    ..._mapHourKeys,
    ..._mapMinuteKeys,
    ..._mapSecondKeys,
    ..._mapMillisecondKeys,
    ..._mapMicrosecondKeys,
    ..._mapUnixMicrosKeys,
    ..._mapUnixMillisKeys,
    ..._mapUnixSecondsKeys,
    ..._mapTimestampKeys,
  };
  static const Set<String> _canonicalDateKeys = {..._mapDateKeys};

  static bool _canonicalValueEqual(
    String canonicalKey,
    Object? left,
    Object? right,
  ) {
    if (identical(left, right)) return true;
    if (left == null || right == null) return false;

    if (_canonicalBoolKeys.contains(canonicalKey)) {
      final leftBool = _toBool(left);
      final rightBool = _toBool(right);
      return leftBool != null && rightBool != null && leftBool == rightBool;
    }

    if (_canonicalIntKeys.contains(canonicalKey)) {
      final leftInt = _toInt(left);
      final rightInt = _toInt(right);
      return leftInt != null && rightInt != null && leftInt == rightInt;
    }

    if (_canonicalDateKeys.contains(canonicalKey)) {
      return _rawAliasValuesEqual(left, right);
    }

    return left == right;
  }

  static bool? _mapBool(Map<String, Object?> source, List<String> keys) {
    var hasValue = false;
    bool? resolved;
    for (final key in keys) {
      if (!source.containsKey(key)) continue;
      final parsed = _toBool(source[key]);
      if (parsed == null) {
        throw ArgumentError.value(
          source[key],
          key,
          'Expected a boolean value.',
        );
      }
      if (hasValue && resolved != parsed) {
        throw ArgumentError.value(
          source[key],
          key,
          'Conflicting boolean values for alias keys ${keys.join(', ')}.',
        );
      }
      hasValue = true;
      resolved = parsed;
    }
    return hasValue ? resolved : null;
  }

  static int? _mapInt(Map<String, Object?> source, List<String> keys) {
    var hasValue = false;
    int? resolved;
    for (final key in keys) {
      if (!source.containsKey(key)) continue;
      final parsed = _toInt(source[key]);
      if (parsed == null) {
        throw ArgumentError.value(
          source[key],
          key,
          'Expected an integer value.',
        );
      }
      if (hasValue && resolved != parsed) {
        throw ArgumentError.value(
          source[key],
          key,
          'Conflicting integer values for alias keys ${keys.join(', ')}.',
        );
      }
      hasValue = true;
      resolved = parsed;
    }
    return hasValue ? resolved : null;
  }

  static Object? _mapRawValue(
    Map<String, Object?> source,
    List<String> keys, {
    required String valueType,
  }) {
    var hasValue = false;
    Object? resolved;
    for (final key in keys) {
      if (!source.containsKey(key)) continue;
      final value = source[key];
      if (value == null) {
        throw ArgumentError.value(
          value,
          key,
          'Expected a non-null $valueType.',
        );
      }
      if (hasValue && !_rawAliasValuesEqual(resolved!, value)) {
        throw ArgumentError.value(
          value,
          key,
          'Conflicting values for alias keys ${keys.join(', ')}.',
        );
      }
      hasValue = true;
      resolved = value;
    }
    return hasValue ? resolved : null;
  }

  static bool _rawAliasValuesEqual(Object left, Object right) {
    if (left is String && right is String) {
      if (left.trim() == right.trim()) return true;
    }

    if (left is Hora && right is Hora) {
      if (!left.isValid || !right.isValid) {
        return left.isValid == right.isValid;
      }
      return left.unixMicros == right.unixMicros;
    }

    final leftDateTime = _tryAsDateTime(left);
    final rightDateTime = _tryAsDateTime(right);
    if (leftDateTime != null && rightDateTime != null) {
      return leftDateTime.isAtSameMomentAs(rightDateTime);
    }

    return left == right;
  }

  static DateTime? _tryAsDateTime(Object value) {
    if (value is DateTime) return value;
    if (value is Hora) return value.isValid ? value.toDateTime() : null;
    if (value is String) {
      final normalized = value.trim();
      if (_hasInvalidIsoLikeComponents(normalized)) return null;
      return DateTime.tryParse(normalized) ?? _tryParseFormats(normalized);
    }
    return null;
  }

  static void _validateDateParts({
    int? year,
    int? month,
    int? day,
    int? defaultYear,
    int? defaultMonth,
  }) {
    if (month != null) _requireRange('month', month, 1, 12);

    if (day != null) {
      final resolvedYear = year ?? defaultYear ?? DateTime.now().year;
      final resolvedMonth = month ?? defaultMonth ?? 1;
      _requireRange('month', resolvedMonth, 1, 12);
      final maxDay = DateTime(resolvedYear, resolvedMonth + 1, 0).day;
      _requireRange('day', day, 1, maxDay);
    }
  }

  static void _validateTimeParts({
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    if (hour != null) _requireRange('hour', hour, 0, 23);
    if (minute != null) _requireRange('minute', minute, 0, 59);
    if (second != null) _requireRange('second', second, 0, 59);
    if (millisecond != null) {
      _requireRange('millisecond', millisecond, 0, 999);
    }
    if (microsecond != null) {
      _requireRange('microsecond', microsecond, 0, 999);
    }
  }

  static void _requireRange(String field, int value, int min, int max) {
    if (value < min || value > max) {
      throw ArgumentError.value(
        value,
        field,
        'Expected value in range $min..$max.',
      );
    }
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

  static bool? _toBool(Object? value) {
    if (value is bool) return value;
    if (value is num) {
      if (value is double && !value.isFinite) return null;
      if (value == 1) return true;
      if (value == 0) return false;
      return null;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return null;
  }

  static String _canonicalKey(String key) =>
      key.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');

  static bool _hasExplicitTimezone(String input) =>
      RegExp(r'(z|[+-]\d{2}:?\d{2})$', caseSensitive: false)
          .hasMatch(input.trim());

  static bool _hasInvalidIsoLikeComponents(String input) {
    final match = RegExp(
      r'^(\d{4})-(\d{1,2})-(\d{1,2})'
      r'(?:[Tt ](\d{1,2}):(\d{2})'
      r'(?::(\d{2})(?:\.(\d{1,9}))?)?'
      r'(?:([Zz])|([+-])(\d{2}):?(\d{2}))?'
      r')?$',
    ).firstMatch(input);

    if (match == null) return false;

    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);

    if (month < 1 || month > 12 || day < 1) return true;
    final maxDay = DateTime(year, month + 1, 0).day;
    if (day > maxDay) return true;

    final hourPart = match.group(4);
    if (hourPart == null) return false;

    final hour = int.parse(hourPart);
    final minute = int.parse(match.group(5)!);
    final secondPart = match.group(6);
    final second = secondPart == null ? null : int.parse(secondPart);

    if (hour < 0 || hour > 23) return true;
    if (minute < 0 || minute > 59) return true;
    if (second != null && (second < 0 || second > 59)) return true;

    final offsetSign = match.group(9);
    if (offsetSign == null) return false;

    final offsetHours = int.parse(match.group(10)!);
    final offsetMinutes = int.parse(match.group(11)!);
    if (offsetHours < 0 || offsetHours > 23) return true;
    if (offsetMinutes < 0 || offsetMinutes > 59) return true;
    return false;
  }

  static DateTime? _tryParseFormats(String input) {
    DateTime? buildValidatedDate(int year, int month, int day) {
      final date = DateTime(year, month, day);
      if (date.year != year || date.month != month || date.day != day) {
        return null;
      }
      return date;
    }

    // YYYY/MM/DD or YYYY.MM.DD (year-first: unambiguous)
    final yearFirst = RegExp(r'^(\d{4})[/.](\d{1,2})[/.](\d{1,2})$');
    final m1 = yearFirst.firstMatch(input);
    if (m1 != null) {
      final year = int.parse(m1.group(1)!);
      final month = int.parse(m1.group(2)!);
      final day = int.parse(m1.group(3)!);
      final parsed = buildValidatedDate(year, month, day);
      if (parsed != null) return parsed;
    }

    // DD/MM/YYYY (day-first: first group must be ≤ 31)
    final dayFirst = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$');
    final m2 = dayFirst.firstMatch(input);
    if (m2 != null) {
      final first = int.parse(m2.group(1)!);
      final second = int.parse(m2.group(2)!);
      final third = int.parse(m2.group(3)!);
      if (first >= 1 && first <= 31 && second >= 1 && second <= 12) {
        final parsed = buildValidatedDate(third, second, first);
        if (parsed != null) return parsed;
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
    final weekStart = h.locale.weekStart;
    final startOfYear = DateTime.utc(h.year, 1, yearStart);
    final startOfWeek = startOfYear.subtract(
      Duration(days: (startOfYear.weekday - weekStart + 7) % 7),
    );
    final currentDate = DateTime.utc(h.year, h.month, h.day);

    if (currentDate.isBefore(startOfWeek)) {
      // Belongs to previous year's last week — recurse with Dec 31.
      return _weekOfYear(
        Hora.of(
          year: h.year - 1,
          month: 12,
          day: 31,
          utc: true,
          locale: h.locale,
        ),
      );
    }

    final diff = currentDate.difference(startOfWeek).inDays;
    return (diff ~/ 7) + 1;
  }
}
