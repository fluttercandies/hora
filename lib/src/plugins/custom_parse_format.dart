/// Custom parse format plugin for Hora.
///
/// Allows parsing dates from strings using custom format patterns.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/custom_parse_format.dart';
///
/// // Parse with custom format
/// final h = HoraParser.parse('25/12/2023', 'DD/MM/YYYY');
/// print(h.year); // 2023
///
/// // Parse with multiple possible formats
/// final h2 = HoraParser.parseMultiple(
///   '12-25-2023',
///   ['DD/MM/YYYY', 'MM-DD-YYYY', 'YYYY-MM-DD'],
/// );
/// ```
///
/// ## Supported Tokens
///
/// | Token | Input | Description |
/// |-------|-------|-------------|
/// | `YYYY` | 2023 | 4-digit year |
/// | `YY` | 23 | 2-digit year |
/// | `M` | 1-12 | Month |
/// | `MM` | 01-12 | Month (2-digit) |
/// | `MMM` | Jan | Short month name |
/// | `MMMM` | January | Full month name |
/// | `D` | 1-31 | Day of month |
/// | `DD` | 01-31 | Day (2-digit) |
/// | `H` | 0-23 | Hour (24h) |
/// | `HH` | 00-23 | Hour (24h, 2-digit) |
/// | `h` | 1-12 | Hour (12h) |
/// | `hh` | 01-12 | Hour (12h, 2-digit) |
/// | `m` | 0-59 | Minute |
/// | `mm` | 00-59 | Minute (2-digit) |
/// | `s` | 0-59 | Second |
/// | `ss` | 00-59 | Second (2-digit) |
/// | `SSS` | 000-999 | Millisecond |
/// | `A` | AM/PM | Meridiem |
/// | `a` | am/pm | Meridiem (lowercase) |
/// | `Z` | +05:30 | Timezone offset |
/// | `X` | 1360013296 | Unix timestamp (seconds) |
/// | `x` | 1360013296123 | Unix timestamp (milliseconds) |
library;

import '../hora.dart';
import '../locale.dart';

/// Result of parsing a date string.
class ParseResult {
  const ParseResult._({
    required this.success,
    this.hora,
    this.error,
  });

  /// Creates a successful parse result.
  const ParseResult.success(Hora hora)
      : this._(success: true, hora: hora, error: null);

  /// Creates a failed parse result.
  const ParseResult.failure(String error)
      : this._(success: false, hora: null, error: error);

  /// Whether parsing was successful.
  final bool success;

  /// The parsed Hora (null if failed).
  final Hora? hora;

  /// Error message (null if successful).
  final String? error;
}

/// Custom format parser for Hora.
class HoraParser {
  HoraParser._();

  /// Parses a date string using the given format pattern.
  ///
  /// Returns an invalid Hora if parsing fails.
  static Hora parse(
    String input,
    String format, {
    HoraLocale? locale,
    bool strict = false,
  }) {
    final result = tryParse(input, format, locale: locale, strict: strict);
    return result ?? Hora.parse('invalid', locale: locale);
  }

  /// Tries to parse a date string, returns null if parsing fails.
  static Hora? tryParse(
    String input,
    String format, {
    HoraLocale? locale,
    bool strict = false,
  }) {
    locale ??= Hora.globalLocale;

    try {
      final result = _parseWithFormat(input, format, locale, strict);
      if (result == null) return null;

      // Handle 12-hour format
      var adjustedHour = result.hour ?? 0;
      if (result.is12Hour && result.hour != null) {
        if (result.isPM && adjustedHour < 12) {
          adjustedHour += 12;
        } else if (!result.isPM && adjustedHour == 12) {
          adjustedHour = 0;
        }
      }

      return Hora.of(
        year: result.year ?? DateTime.now().year,
        month: result.month ?? 1,
        day: result.day ?? 1,
        hour: adjustedHour,
        minute: result.minute ?? 0,
        second: result.second ?? 0,
        millisecond: result.millisecond ?? 0,
        utc: result.isUtc,
        locale: locale,
      );
    } catch (_) {
      return null;
    }
  }

  /// Parses a date string trying multiple formats.
  ///
  /// Returns the first successful parse, or an invalid Hora if all fail.
  static Hora parseMultiple(
    String input,
    List<String> formats, {
    HoraLocale? locale,
  }) {
    for (final format in formats) {
      final result = tryParse(input, format, locale: locale);
      if (result != null && result.isValid) {
        return result;
      }
    }
    return Hora.parse('invalid', locale: locale);
  }

  /// Tries to parse with multiple formats.
  static Hora? tryParseMultiple(
    String input,
    List<String> formats, {
    HoraLocale? locale,
  }) {
    for (final format in formats) {
      final result = tryParse(input, format, locale: locale);
      if (result != null && result.isValid) {
        return result;
      }
    }
    return null;
  }

  static _ParsedComponents? _parseWithFormat(
    String input,
    String format,
    HoraLocale locale,
    bool strict,
  ) {
    final components = _ParsedComponents();
    var inputIndex = 0;
    var formatIndex = 0;

    while (formatIndex < format.length && inputIndex < input.length) {
      // Handle escaped text [...]
      if (format[formatIndex] == '[') {
        final closeIndex = format.indexOf(']', formatIndex);
        if (closeIndex != -1) {
          final escaped = format.substring(formatIndex + 1, closeIndex);
          if (!input.substring(inputIndex).startsWith(escaped)) {
            if (strict) return null;
          } else {
            inputIndex += escaped.length;
          }
          formatIndex = closeIndex + 1;
          continue;
        }
      }

      // Try to match tokens
      final token = _matchToken(format.substring(formatIndex));
      if (token != null) {
        final consumed = _parseToken(
          input.substring(inputIndex),
          token,
          locale,
          components,
        );
        if (consumed == null) {
          if (strict) return null;
          formatIndex++;
          continue;
        }
        inputIndex += consumed;
        formatIndex += token.length;
      } else {
        // Match literal character
        if (format[formatIndex] == input[inputIndex]) {
          formatIndex++;
          inputIndex++;
        } else if (strict) {
          return null;
        } else {
          formatIndex++;
        }
      }
    }

    // Check if we consumed all input in strict mode
    if (strict && inputIndex < input.length) {
      return null;
    }

    return components;
  }

  static String? _matchToken(String input) {
    const tokens = [
      'MMMM',
      'YYYY',
      'MMM',
      'SSS',
      'MM',
      'DD',
      'YY',
      'HH',
      'hh',
      'mm',
      'ss',
      'M',
      'D',
      'H',
      'h',
      'm',
      's',
      'A',
      'a',
      'Z',
      'X',
      'x',
    ];

    for (final token in tokens) {
      if (input.startsWith(token)) {
        return token;
      }
    }
    return null;
  }

  static int? _parseToken(
    String input,
    String token,
    HoraLocale locale,
    _ParsedComponents components,
  ) {
    switch (token) {
      case 'YYYY':
        final match = RegExp(r'^\d{4}').firstMatch(input);
        if (match == null) return null;
        components.year = int.parse(match.group(0)!);
        return 4;

      case 'YY':
        final match = RegExp(r'^\d{2}').firstMatch(input);
        if (match == null) return null;
        final yy = int.parse(match.group(0)!);
        components.year = yy >= 69 ? 1900 + yy : 2000 + yy;
        return 2;

      case 'MMMM':
        for (var i = 0; i < locale.months.length; i++) {
          if (input.toLowerCase().startsWith(locale.months[i].toLowerCase())) {
            components.month = i + 1;
            return locale.months[i].length;
          }
        }
        return null;

      case 'MMM':
        for (var i = 0; i < locale.monthsShort.length; i++) {
          if (input.toLowerCase().startsWith(
                locale.monthsShort[i].toLowerCase(),
              )) {
            components.month = i + 1;
            return locale.monthsShort[i].length;
          }
        }
        return null;

      case 'MM':
        final match = RegExp(r'^\d{2}').firstMatch(input);
        if (match == null) return null;
        components.month = int.parse(match.group(0)!);
        return 2;

      case 'M':
        final match = RegExp(r'^\d{1,2}').firstMatch(input);
        if (match == null) return null;
        components.month = int.parse(match.group(0)!);
        return match.group(0)!.length;

      case 'DD':
        final match = RegExp(r'^\d{2}').firstMatch(input);
        if (match == null) return null;
        components.day = int.parse(match.group(0)!);
        return 2;

      case 'D':
        final match = RegExp(r'^\d{1,2}').firstMatch(input);
        if (match == null) return null;
        components.day = int.parse(match.group(0)!);
        return match.group(0)!.length;

      case 'HH':
        final match = RegExp(r'^\d{2}').firstMatch(input);
        if (match == null) return null;
        components.hour = int.parse(match.group(0)!);
        return 2;

      case 'H':
        final match = RegExp(r'^\d{1,2}').firstMatch(input);
        if (match == null) return null;
        components.hour = int.parse(match.group(0)!);
        return match.group(0)!.length;

      case 'hh':
        final match = RegExp(r'^\d{2}').firstMatch(input);
        if (match == null) return null;
        components.hour = int.parse(match.group(0)!);
        components.is12Hour = true;
        return 2;

      case 'h':
        final match = RegExp(r'^\d{1,2}').firstMatch(input);
        if (match == null) return null;
        components.hour = int.parse(match.group(0)!);
        components.is12Hour = true;
        return match.group(0)!.length;

      case 'mm':
        final match = RegExp(r'^\d{2}').firstMatch(input);
        if (match == null) return null;
        components.minute = int.parse(match.group(0)!);
        return 2;

      case 'm':
        final match = RegExp(r'^\d{1,2}').firstMatch(input);
        if (match == null) return null;
        components.minute = int.parse(match.group(0)!);
        return match.group(0)!.length;

      case 'ss':
        final match = RegExp(r'^\d{2}').firstMatch(input);
        if (match == null) return null;
        components.second = int.parse(match.group(0)!);
        return 2;

      case 's':
        final match = RegExp(r'^\d{1,2}').firstMatch(input);
        if (match == null) return null;
        components.second = int.parse(match.group(0)!);
        return match.group(0)!.length;

      case 'SSS':
        final match = RegExp(r'^\d{3}').firstMatch(input);
        if (match == null) return null;
        components.millisecond = int.parse(match.group(0)!);
        return 3;

      case 'A':
      case 'a':
        if (input.toLowerCase().startsWith('pm')) {
          components.isPM = true;
          return 2;
        } else if (input.toLowerCase().startsWith('am')) {
          components.isPM = false;
          return 2;
        }
        return null;

      case 'Z':
        final match = RegExp(r'^[+-]\d{2}:\d{2}').firstMatch(input);
        if (match == null) return null;
        components.isUtc = match.group(0) == '+00:00';
        return 6;

      case 'X':
        final match = RegExp(r'^\d+').firstMatch(input);
        if (match == null) return null;
        final unix = int.parse(match.group(0)!);
        final dt = DateTime.fromMillisecondsSinceEpoch(unix * 1000);
        components
          ..year = dt.year
          ..month = dt.month
          ..day = dt.day
          ..hour = dt.hour
          ..minute = dt.minute
          ..second = dt.second;
        return match.group(0)!.length;

      case 'x':
        final match = RegExp(r'^\d+').firstMatch(input);
        if (match == null) return null;
        final millis = int.parse(match.group(0)!);
        final dt = DateTime.fromMillisecondsSinceEpoch(millis);
        components
          ..year = dt.year
          ..month = dt.month
          ..day = dt.day
          ..hour = dt.hour
          ..minute = dt.minute
          ..second = dt.second
          ..millisecond = dt.millisecond;
        return match.group(0)!.length;

      default:
        return null;
    }
  }
}

class _ParsedComponents {
  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  int? second;
  int? millisecond;
  bool isUtc = false;
  bool is12Hour = false;
  bool isPM = false;
}

/// Extension for Hora providing custom format parsing.
extension HoraCustomParseExt on Hora {
  /// Creates a Hora from a string using a custom format.
  static Hora parseFormat(
    String input,
    String format, {
    HoraLocale? locale,
    bool strict = false,
  }) =>
      HoraParser.parse(input, format, locale: locale, strict: strict);

  /// Tries to parse a string using a custom format.
  static Hora? tryParseFormat(
    String input,
    String format, {
    HoraLocale? locale,
    bool strict = false,
  }) =>
      HoraParser.tryParse(input, format, locale: locale, strict: strict);
}
