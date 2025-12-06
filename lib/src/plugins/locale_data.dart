/// Locale data access plugin for Hora.
///
/// Provides access to locale-specific data like weekday names,
/// month names, and formatting preferences.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/locale_data.dart';
///
/// final h = Hora.now();
///
/// // Get locale data
/// final data = h.localeData;
/// print(data.months); // ['January', ...]
/// print(data.weekdays); // ['Sunday', ...]
///
/// // Get specific information
/// print(h.monthName); // 'July'
/// print(h.weekdayName); // 'Tuesday'
/// ```
library;

import '../hora.dart';
import '../locale.dart';

/// Provides access to locale-specific data.
class LocaleData {
  const LocaleData._(this._locale);

  final HoraLocale _locale;

  /// Gets the locale code.
  String get code => _locale.code;

  /// Gets the list of month names.
  List<String> get months => List.unmodifiable(_locale.months);

  /// Gets the list of short month names.
  List<String> get monthsShort => List.unmodifiable(_locale.monthsShort);

  /// Gets the list of weekday names.
  List<String> get weekdays => List.unmodifiable(_locale.weekdays);

  /// Gets the list of short weekday names.
  List<String> get weekdaysShort => List.unmodifiable(_locale.weekdaysShort);

  /// Gets the list of minimal weekday names.
  List<String> get weekdaysMin => List.unmodifiable(_locale.weekdaysMin);

  /// Gets the AM/PM designators.
  List<String> get meridiem => List.unmodifiable([
        _locale.meridiem(0, 0),
        _locale.meridiem(12, 0),
      ]);

  /// Gets the first day of week (0 = Sunday, 1 = Monday, etc.).
  int get firstDayOfWeek => _locale.weekStart;

  /// Gets the ordinal suffix for a number.
  String ordinal(int n) => _locale.ordinal(n);

  /// Gets the long date format.
  String get longDateFormat => _locale.formats.ll;

  /// Gets the short date format.
  String get shortDateFormat => _locale.formats.l;

  /// Gets the time format.
  String get timeFormat => _locale.formats.lt;

  /// Gets the month name for a given month number (1-12).
  String monthName(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'Must be between 1 and 12');
    }
    return _locale.months[month - 1];
  }

  /// Gets the short month name for a given month number (1-12).
  String monthNameShort(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'Must be between 1 and 12');
    }
    return _locale.monthsShort[month - 1];
  }

  /// Gets the weekday name for a given day number (0 = Sunday).
  String weekdayName(int weekday) {
    if (weekday < 0 || weekday > 6) {
      throw ArgumentError.value(weekday, 'weekday', 'Must be between 0 and 6');
    }
    return _locale.weekdays[weekday];
  }

  /// Gets the short weekday name for a given day number (0 = Sunday).
  String weekdayNameShort(int weekday) {
    if (weekday < 0 || weekday > 6) {
      throw ArgumentError.value(weekday, 'weekday', 'Must be between 0 and 6');
    }
    return _locale.weekdaysShort[weekday];
  }

  @override
  String toString() => 'LocaleData($code)';
}

/// Extension providing locale data access for Hora.
extension LocaleDataExt on Hora {
  /// Gets the locale data for this Hora instance.
  LocaleData get localeData => LocaleData._(locale);

  /// Gets the full name of the month.
  String get monthName => locale.months[month - 1];

  /// Gets the short name of the month.
  String get monthNameShort => locale.monthsShort[month - 1];

  /// Gets the full name of the weekday.
  ///
  /// Converts Dart's weekday (1=Monday to 7=Sunday) to locale's weekdays list
  /// which starts from Sunday (index 0).
  String get weekdayName => locale.weekdays[weekday % 7];

  /// Gets the short name of the weekday.
  String get weekdayNameShort => locale.weekdaysShort[weekday % 7];

  /// Gets the minimal name of the weekday.
  String get weekdayNameMin => locale.weekdaysMin[weekday % 7];

  /// Gets the ordinal suffix for the day.
  String get dayOrdinal => locale.ordinal(day);

  /// Gets the meridiem (AM/PM) for the current time.
  String get meridiemString => locale.meridiem(hour, minute);

  /// Gets the meridiem (AM/PM) for the current time in lowercase.
  String get meridiemLower => locale.meridiem(hour, minute, lowercase: true);

  /// Gets all registered locale codes (from HoraLocales registry).
  static Iterable<String> get registeredLocaleCodes => HoraLocales.codes;

  /// Gets the data for a specific locale (from HoraLocales registry).
  ///
  /// Note: The locale must be registered with [HoraLocales.register] first.
  static LocaleData? dataFor(String localeCode) {
    final locale = HoraLocales.get(localeCode);
    if (locale == null) return null;
    return LocaleData._(locale);
  }
}

/// Extension providing locale iteration utilities.
extension LocaleIterationExt on LocaleData {
  /// Iterates over all months with their names.
  Iterable<MapEntry<int, String>> get monthEntries sync* {
    for (var i = 1; i <= 12; i++) {
      yield MapEntry(i, monthName(i));
    }
  }

  /// Iterates over all months with their short names.
  Iterable<MapEntry<int, String>> get monthEntriesShort sync* {
    for (var i = 1; i <= 12; i++) {
      yield MapEntry(i, monthNameShort(i));
    }
  }

  /// Iterates over all weekdays with their names.
  Iterable<MapEntry<int, String>> get weekdayEntries sync* {
    for (var i = 0; i <= 6; i++) {
      yield MapEntry(i, weekdayName(i));
    }
  }

  /// Iterates over all weekdays with their short names.
  Iterable<MapEntry<int, String>> get weekdayEntriesShort sync* {
    for (var i = 0; i <= 6; i++) {
      yield MapEntry(i, weekdayNameShort(i));
    }
  }
}
