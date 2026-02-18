/// Buddhist Era calendar plugin for Hora.
///
/// The Buddhist Era (BE) is a calendar era used in several Southeast Asian
/// countries, particularly Thailand. The Buddhist Era starts in 543 BCE,
/// the year Buddha attained Nirvana.
///
/// BE Year = Gregorian Year + 543
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/buddhist_era.dart';
///
/// final h = Hora.of(year: 2023, month: 12, day: 25);
/// print(h.buddhistYear); // 2566
/// print(h.formatBuddhistEra('BBBB-MM-DD')); // 2566-12-25
/// ```
///
/// ## Format Tokens
///
/// | Token | Output | Description |
/// |-------|--------|-------------|
/// | `BBBB` | 2566 | Buddhist Era year (4 digits) |
/// | `BB` | 66 | Buddhist Era year (2 digits) |
library;

import '../hora.dart';

/// Extension providing Buddhist Era calendar support.
extension BuddhistEraExt on Hora {
  /// The Buddhist Era year.
  ///
  /// The Buddhist Era starts 543 years before the Common Era.
  /// For example, 2023 CE = 2566 BE.
  int get buddhistYear => year + 543;

  /// The Buddhist Era year (2 digits).
  int get buddhistYearShort => buddhistYear % 100;

  /// Formats the date using Buddhist Era year tokens.
  ///
  /// Supports `BBBB` for 4-digit BE year and `BB` for 2-digit BE year.
  /// All other tokens work the same as standard format().
  String formatBuddhistEra(String pattern) {
    if (!isValid) {
      return locale.invalidDate;
    }

    // Pre-process: replace Buddhist Era tokens with escaped literals
    // before passing to the standard formatter.
    final buffer = StringBuffer();
    var i = 0;
    while (i < pattern.length) {
      if (pattern[i] == '[') {
        final closeIndex = pattern.indexOf(']', i + 1);
        if (closeIndex == -1) {
          buffer.write(pattern.substring(i));
          break;
        }
        buffer.write(pattern.substring(i, closeIndex + 1));
        i = closeIndex + 1;
      } else if (pattern.startsWith('BBBB', i)) {
        buffer.write('[${buddhistYear.toString().padLeft(4, '0')}]');
        i += 4;
      } else if (pattern.startsWith('BB', i)) {
        buffer.write('[${buddhistYearShort.toString().padLeft(2, '0')}]');
        i += 2;
      } else {
        buffer.write(pattern[i]);
        i++;
      }
    }

    return format(buffer.toString());
  }

  /// Creates a new Hora with the specified Buddhist Era year.
  ///
  /// ```dart
  /// final h = Hora.now().withBuddhistYear(2566);
  /// print(h.year); // 2023
  /// ```
  Hora withBuddhistYear(int beYear) => copyWith(year: beYear - 543);
}

/// Creates a Hora from Buddhist Era components.
///
/// ```dart
/// final h = horaBuddhistEra(year: 2566, month: 12, day: 25);
/// print(h.year); // 2023
/// ```
Hora horaBuddhistEra({
  required int year,
  int month = 1,
  int day = 1,
  int hour = 0,
  int minute = 0,
  int second = 0,
  int millisecond = 0,
  int microsecond = 0,
  bool utc = false,
}) =>
    Hora.of(
      year: year - 543,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
      microsecond: microsecond,
      utc: utc,
    );

/// Alternative calendar era systems.
enum CalendarEra {
  /// Common Era (Gregorian calendar)
  common,

  /// Buddhist Era (BE = CE + 543)
  buddhist,

  /// Japanese Imperial Era
  japanese,

  /// Minguo/Republic of China calendar (ROC = CE - 1911)
  minguo,
}

/// Extension for multi-era calendar support.
extension MultiEraCalendarExt on Hora {
  /// Returns the year in the specified calendar era.
  int yearIn(CalendarEra era) => switch (era) {
        CalendarEra.common => year,
        CalendarEra.buddhist => year + 543,
        CalendarEra.japanese => _japaneseEraYear(),
        CalendarEra.minguo => year - 1911,
      };

  int _japaneseEraYear() {
    if (_isOnOrAfter(2019, 5, 1)) {
      // Reiwa
      return year - 2018;
    }
    if (_isOnOrAfter(1989, 1, 8)) {
      // Heisei
      return year - 1988;
    }
    if (_isOnOrAfter(1926, 12, 25)) {
      // Showa
      return year - 1925;
    }
    if (_isOnOrAfter(1912, 7, 30)) {
      // Taisho
      return year - 1911;
    }
    // Meiji (from 1868-09-08; dates before that are mapped to this branch)
    return year - 1867;
  }

  bool _isOnOrAfter(int y, int m, int d) {
    if (year != y) return year > y;
    if (month != m) return month > m;
    return day >= d;
  }

  /// Returns the name of the current Japanese era.
  String get japaneseEraName {
    if (_isOnOrAfter(2019, 5, 1)) {
      return '令和'; // Reiwa
    }
    if (_isOnOrAfter(1989, 1, 8)) {
      return '平成'; // Heisei
    }
    if (_isOnOrAfter(1926, 12, 25)) {
      return '昭和'; // Showa
    }
    if (_isOnOrAfter(1912, 7, 30)) {
      return '大正'; // Taisho
    }
    return '明治'; // Meiji
  }
}
