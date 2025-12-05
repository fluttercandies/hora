/// Advanced format plugin for Hora.
///
/// Provides additional formatting tokens beyond the standard format() method.
///
/// ## Additional Tokens
///
/// | Token | Output | Description |
/// |-------|--------|-------------|
/// | `Do` | 1st, 2nd, ... 31st | Day of month with ordinal |
/// | `Qo` | 1st, 2nd, 3rd, 4th | Quarter with ordinal |
/// | `Mo` | 1st, 2nd, ... 12th | Month with ordinal |
/// | `DDDo` | 1st, 2nd, ... 365th | Day of year with ordinal |
/// | `Wo` | 1st, 2nd, ... 53rd | Week of year with ordinal |
/// | `wo` | 1st, 2nd, ... 53rd | Week of year with ordinal (same as Wo) |
/// | `k` | 1-24 | Hour (1-indexed, 24 at midnight) |
/// | `kk` | 01-24 | Hour with leading zero |
/// | `X` | 1360013296 | Unix timestamp in seconds |
/// | `x` | 1360013296123 | Unix timestamp in milliseconds |
/// | `GGGG` | 2023 | ISO week year (4 digits) |
/// | `GG` | 23 | ISO week year (2 digits) |
/// | `gggg` | 2023 | Locale week year (4 digits) |
/// | `gg` | 23 | Locale week year (2 digits) |
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/advanced_format.dart';
///
/// final h = Hora.of(year: 2023, month: 12, day: 25);
/// print(h.advancedFormat('Do [of] MMMM')); // 25th of December
/// print(h.advancedFormat('Qo [quarter]')); // 4th quarter
/// ```
library;

import '../hora.dart';

/// Extension providing advanced formatting capabilities.
extension AdvancedFormatExt on Hora {
  /// Formats the date with advanced format tokens.
  ///
  /// Supports all standard tokens plus additional ones like `Do`, `Qo`, `Mo`,
  /// `DDDo`, `Wo`, `k`, `kk`, `X`, `x`, `GGGG`, `GG`.
  String advancedFormat(String pattern) {
    if (!isValid) {
      return locale.invalidDate;
    }

    final buffer = StringBuffer();
    var i = 0;

    while (i < pattern.length) {
      // Handle escaped text [...]
      if (pattern[i] == '[') {
        final closeIndex = pattern.indexOf(']', i);
        if (closeIndex != -1) {
          buffer.write(pattern.substring(i + 1, closeIndex));
          i = closeIndex + 1;
          continue;
        }
      }

      // Try to match tokens (longest first)
      final remaining = pattern.substring(i);
      final token = _matchAdvancedToken(remaining);

      if (token != null) {
        buffer.write(_formatAdvancedToken(token));
        i += token.length;
      } else {
        buffer.write(pattern[i]);
        i++;
      }
    }

    return buffer.toString();
  }

  String? _matchAdvancedToken(String input) {
    // Ordered by length (longest first) for proper matching
    const tokens = [
      'GGGG',
      'gggg',
      'DDDo',
      'MMMM',
      'dddd',
      'YYYY',
      'GG',
      'gg',
      'Do',
      'Qo',
      'Mo',
      'Wo',
      'wo',
      'kk',
      'MMM',
      'ddd',
      'DDD',
      'SSS',
      'ZZZ',
      'YY',
      'MM',
      'DD',
      'HH',
      'hh',
      'mm',
      'ss',
      'dd',
      'M',
      'D',
      'H',
      'h',
      'm',
      's',
      'd',
      'k',
      'Q',
      'W',
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

  String _formatAdvancedToken(String token) {
    switch (token) {
      // Ordinal tokens
      case 'Do':
        return locale.ordinal(day);
      case 'Qo':
        return locale.ordinal(quarter);
      case 'Mo':
        return locale.ordinal(month);
      case 'DDDo':
        return locale.ordinal(dayOfYear);
      case 'Wo':
      case 'wo':
        return locale.ordinal(isoWeek);

      // Hour 1-24
      case 'k':
        return (hour == 0 ? 24 : hour).toString();
      case 'kk':
        return (hour == 0 ? 24 : hour).toString().padLeft(2, '0');

      // Unix timestamps
      case 'X':
        return unix.toString();
      case 'x':
        return unixMillis.toString();

      // ISO week year
      case 'GGGG':
        return isoWeekYear.toString().padLeft(4, '0');
      case 'GG':
        return (isoWeekYear % 100).toString().padLeft(2, '0');

      // Locale week year (same as ISO for now)
      case 'gggg':
        return isoWeekYear.toString().padLeft(4, '0');
      case 'gg':
        return (isoWeekYear % 100).toString().padLeft(2, '0');

      // Standard tokens (fallback to standard format)
      case 'YYYY':
        return year.toString().padLeft(4, '0');
      case 'YY':
        return (year % 100).toString().padLeft(2, '0');
      case 'MMMM':
        return locale.months[month - 1];
      case 'MMM':
        return locale.monthsShort[month - 1];
      case 'MM':
        return month.toString().padLeft(2, '0');
      case 'M':
        return month.toString();
      case 'DD':
        return day.toString().padLeft(2, '0');
      case 'D':
        return day.toString();
      case 'DDD':
        return dayOfYear.toString();
      case 'dddd':
        return locale.weekdays[weekday % 7];
      case 'ddd':
        return locale.weekdaysShort[weekday % 7];
      case 'dd':
        return locale.weekdaysMin[weekday % 7];
      case 'd':
        return (weekday % 7).toString();
      case 'HH':
        return hour.toString().padLeft(2, '0');
      case 'H':
        return hour.toString();
      case 'hh':
        return ((hour % 12) == 0 ? 12 : hour % 12).toString().padLeft(2, '0');
      case 'h':
        return ((hour % 12) == 0 ? 12 : hour % 12).toString();
      case 'mm':
        return minute.toString().padLeft(2, '0');
      case 'm':
        return minute.toString();
      case 'ss':
        return second.toString().padLeft(2, '0');
      case 's':
        return second.toString();
      case 'SSS':
        return millisecond.toString().padLeft(3, '0');
      case 'A':
        return locale.meridiem(hour, minute);
      case 'a':
        return locale.meridiem(hour, minute, lowercase: true);
      case 'Q':
        return quarter.toString();
      case 'W':
        return isoWeek.toString();
      case 'Z':
        return _formatTimezone();
      case 'ZZZ':
        return _formatTimezone(colonSeparator: false);
      default:
        return token;
    }
  }

  String _formatTimezone({bool colonSeparator = true}) {
    final offset = timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final absOffset = offset.abs();
    final hours = absOffset.inHours.toString().padLeft(2, '0');
    final minutes = (absOffset.inMinutes % 60).toString().padLeft(2, '0');
    return colonSeparator ? '$sign$hours:$minutes' : '$sign$hours$minutes';
  }
}
