/// Internationalization support for Hora.
library;

/// Provides locale-specific formatting, including month/weekday names,
/// date formats, and relative time expressions.

import 'package:meta/meta.dart';

// Re-export commonly used locales for convenience
export 'locales/en.dart';
export 'locales/zh_cn.dart';

/// Abstract base class for locale definitions.
///
/// Implement this class to add support for a new language. All locale
/// classes should be immutable with const constructors for optimal
/// performance and tree-shaking.
///
/// ## Built-in Locales
///
/// Hora includes 143 locale definitions. The most common are:
/// - `HoraLocaleEn` - English (default)
/// - `HoraLocaleZhCn` - Chinese (Simplified)
///
/// Import additional locales from `package:hora/src/locales/`:
/// ```dart
/// import 'package:hora/src/locales/ja.dart'; // Japanese
/// import 'package:hora/src/locales/ko.dart'; // Korean
/// import 'package:hora/src/locales/de.dart'; // German
/// ```
///
/// ## Usage
///
/// ```dart
/// // Per-instance locale
/// final h = Hora.now(locale: const HoraLocaleJa());
/// print(h.format('MMMM D日')); // 12月 5日
///
/// // Change locale on existing instance
/// final h2 = h.withLocale(const HoraLocaleEn());
///
/// // Global default locale
/// Hora.globalLocale = const HoraLocaleZhCn();
/// ```
///
/// ## Creating Custom Locales
///
/// ```dart
/// class HoraLocaleEs extends HoraLocale {
///   const HoraLocaleEs();
///
///   @override
///   String get code => 'es';
///
///   @override
///   List<String> get months => const [
///     'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
///     'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
///   ];
///
///   @override
///   List<String> get monthsShort => const [...];
///
///   @override
///   List<String> get weekdays => const [...];
///
///   @override
///   List<String> get weekdaysShort => const [...];
///
///   @override
///   List<String> get weekdaysMin => const [...];
///
///   // Optional overrides for formats, relativeTime, ordinal, meridiem
/// }
/// ```
@immutable
abstract class HoraLocale {
  const HoraLocale();

  /// The locale code (e.g., 'en', 'zh-cn', 'ja').
  String get code;

  /// Full month names (January, February, ...).
  List<String> get months;

  /// Abbreviated month names (Jan, Feb, ...).
  List<String> get monthsShort;

  /// Full weekday names starting from Sunday.
  List<String> get weekdays;

  /// Short weekday names (Sun, Mon, ...).
  List<String> get weekdaysShort;

  /// Minimum weekday names (Su, Mo, ...).
  List<String> get weekdaysMin;

  /// First day of week.
  ///
  /// Uses the same values as [DateTime.monday] through [DateTime.sunday]:
  /// - 1 = Monday ([DateTime.monday])
  /// - 2 = Tuesday
  /// - 3 = Wednesday
  /// - 4 = Thursday
  /// - 5 = Friday
  /// - 6 = Saturday
  /// - 7 = Sunday ([DateTime.sunday])
  ///
  /// Default is Sunday (7) for English locale. Many locales use Monday (1).
  int get weekStart => DateTime.sunday;

  /// Minimum days in the first week of year.
  ///
  /// This affects the calculation of the first week number:
  /// - ISO 8601 standard uses 4 (first week must contain at least 4 days)
  /// - US convention uses 1 (first week starts on January 1st)
  ///
  /// Default is 1.
  int get yearStart => 1;

  /// Localized date formats.
  HoraFormats get formats => const HoraFormats();

  /// Relative time expressions.
  HoraRelativeTime get relativeTime => const HoraRelativeTime();

  /// Returns the ordinal suffix for a number (1st, 2nd, 3rd, etc.).
  String ordinal(int n, [String? unit]) {
    // Handle special cases for 11, 12, 13
    final v = n % 100;
    if (v >= 11 && v <= 13) {
      return '${n}th';
    }
    final lastDigit = n % 10;
    final suffix = switch (lastDigit) {
      1 => 'st',
      2 => 'nd',
      3 => 'rd',
      _ => 'th',
    };
    return '$n$suffix';
  }

  /// Returns the meridiem indicator (AM/PM or locale equivalent).
  ///
  /// [hour] is 0-23, [minute] is 0-59.
  /// [lowercase] determines case of output.
  String meridiem(int hour, int minute, {bool lowercase = false}) {
    final m = hour < 12 ? 'AM' : 'PM';
    return lowercase ? m.toLowerCase() : m;
  }

  /// Invalid date string.
  String get invalidDate => 'Invalid Date';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HoraLocale && code == other.code;

  @override
  int get hashCode => code.hashCode;
}

/// Localized date format patterns.
///
/// These format patterns follow the dayjs convention for locale-specific
/// date formatting. Each pattern name corresponds to a standard format:
///
/// | Name | Description | Example (en) |
/// |------|-------------|--------------|
/// | `lt` | Short time | "8:02 PM" |
/// | `lts` | Long time | "8:02:18 PM" |
/// | `l` | Short date | "08/16/2018" |
/// | `ll` | Long date | "August 16, 2018" |
/// | `lll` | Long date + time | "August 16, 2018 8:02 PM" |
/// | `llll` | Full date + time | "Thursday, August 16, 2018 8:02 PM" |
///
/// These are used with the localized format tokens (L, LT, LTS, etc.)
/// in the `Hora.format` method.
@immutable
class HoraFormats {
  const HoraFormats({
    this.lt = 'h:mm A',
    this.lts = 'h:mm:ss A',
    this.l = 'MM/DD/YYYY',
    this.ll = 'MMMM D, YYYY',
    this.lll = 'MMMM D, YYYY h:mm A',
    this.llll = 'dddd, MMMM D, YYYY h:mm A',
  });

  /// Short time format: "8:02 PM"
  ///
  /// Used with format token `LT`.
  final String lt;

  /// Long time format with seconds: "8:02:18 PM"
  ///
  /// Used with format token `LTS`.
  final String lts;

  /// Short date format: "08/16/2018"
  ///
  /// Used with format token `L`.
  final String l;

  /// Long date format: "August 16, 2018"
  ///
  /// Used with format token `LL`.
  final String ll;

  /// Long date with time format: "August 16, 2018 8:02 PM"
  ///
  /// Used with format token `LLL`.
  final String lll;

  /// Full date with time format: "Thursday, August 16, 2018 8:02 PM"
  ///
  /// Used with format token `LLLL`.
  final String llll;

  // Getter aliases for better discoverability
  /// Alias for [lt] - short time format.
  String get timeShort => lt;

  /// Alias for [lts] - long time format with seconds.
  String get timeLong => lts;

  /// Alias for [l] - short date format.
  String get dateShort => l;

  /// Alias for [ll] - long date format.
  String get dateLong => ll;

  /// Alias for [lll] - long date with time.
  String get dateTimeLong => lll;

  /// Alias for [llll] - full date with weekday and time.
  String get dateTimeFull => llll;
}

/// Relative time expressions for a locale.
///
/// Defines the templates used for formatting relative time strings
/// like "3 days ago" or "in 2 hours".
///
/// The property names follow the dayjs convention:
/// - `s`: seconds (a few seconds)
/// - `m`: 1 minute
/// - `mm`: multiple minutes (uses %d placeholder)
/// - `h`: 1 hour
/// - `hh`: multiple hours (uses %d placeholder)
/// - `d`: 1 day
/// - `dd`: multiple days (uses %d placeholder)
/// - `w`: 1 week
/// - `ww`: multiple weeks (uses %d placeholder)
/// - `mo`: 1 month
/// - `mos`: multiple months (uses %d placeholder)
/// - `y`: 1 year
/// - `yy`: multiple years (uses %d placeholder)
///
/// The `future` and `past` templates wrap the time expression:
/// - `future`: "in %s" → "in 3 days"
/// - `past`: "%s ago" → "3 days ago"
@immutable
class HoraRelativeTime {
  const HoraRelativeTime({
    this.future = 'in %s',
    this.past = '%s ago',
    this.s = 'a few seconds',
    this.m = 'a minute',
    this.mm = '%d minutes',
    this.h = 'an hour',
    this.hh = '%d hours',
    this.d = 'a day',
    this.dd = '%d days',
    this.w = 'a week',
    this.ww = '%d weeks',
    this.mo = 'a month',
    this.mos = '%d months',
    this.y = 'a year',
    this.yy = '%d years',
  });

  /// Future template: "in %s" → "in 3 days"
  ///
  /// The `%s` placeholder is replaced with the time expression.
  final String future;

  /// Past template: "%s ago" → "3 days ago"
  ///
  /// The `%s` placeholder is replaced with the time expression.
  final String past;

  /// Seconds (singular/few): "a few seconds"
  final String s;

  /// One minute: "a minute"
  final String m;

  /// Multiple minutes: "%d minutes"
  ///
  /// The `%d` placeholder is replaced with the number.
  final String mm;

  /// One hour: "an hour"
  final String h;

  /// Multiple hours: "%d hours"
  ///
  /// The `%d` placeholder is replaced with the number.
  final String hh;

  /// One day: "a day"
  final String d;

  /// Multiple days: "%d days"
  ///
  /// The `%d` placeholder is replaced with the number.
  final String dd;

  /// One week: "a week"
  final String w;

  /// Multiple weeks: "%d weeks"
  ///
  /// The `%d` placeholder is replaced with the number.
  final String ww;

  /// One month: "a month"
  final String mo;

  /// Multiple months: "%d months"
  ///
  /// The `%d` placeholder is replaced with the number.
  final String mos;

  /// One year: "a year"
  final String y;

  /// Multiple years: "%d years"
  ///
  /// The `%d` placeholder is replaced with the number.
  final String yy;

  /// Formats a relative time string.
  String format(int value, String unit, {required bool isFuture}) {
    final template = switch (unit) {
      's' => s,
      'm' => m,
      'mm' => mm.replaceAll('%d', value.toString()),
      'h' => h,
      'hh' => hh.replaceAll('%d', value.toString()),
      'd' => d,
      'dd' => dd.replaceAll('%d', value.toString()),
      'w' => w,
      'ww' => ww.replaceAll('%d', value.toString()),
      'mo' => mo,
      'mos' => mos.replaceAll('%d', value.toString()),
      'y' => y,
      'yy' => yy.replaceAll('%d', value.toString()),
      _ => '',
    };

    final wrapper = isFuture ? future : past;
    return wrapper.replaceAll('%s', template);
  }
}
