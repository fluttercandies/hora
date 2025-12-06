# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-12-06

### Fixed
- **Documentation consistency**: Updated README and example files to match actual implementation
- **API examples**: Fixed all documentation inconsistencies between README and source code
- **Plugin imports**: Clarified plugin import paths and usage examples
- **Extension methods**: Corrected extension method names and documentation throughout

### Improved
- **Documentation clarity**: Better distinction between core features and plugin features
- **Example accuracy**: All example code now matches actual implementation
- **Locale documentation**: Clarified locale loading mechanism and tree-shaking support
- **Simplified API**: Removed dynamic locale registry in favor of direct locale usage for better tree-shaking
- **Example enhancements**: Added comprehensive formatting examples with multiple locales
- **Code formatting**: Improved code formatting across test files for better readability

## [1.0.1] - 2025-12-06

### Fixed
- **Extension naming conflict**: Removed duplicate `calendar()` method from `HoraCalendarExt` in `extensions.dart`, using the richer version from `calendar.dart` plugin instead
- **Bug fix**: Fixed `IntToHora.microseconds` extension using wrong factory method (`ofMilliseconds` → `ofMicroseconds`)
- **Example files**: Fixed API usage errors in example files:
  - Fixed `difference()` usage to use standard `Duration` properties
  - Fixed `Hora` constructor calls (using `Hora.of()` instead of unnamed constructor)
  - Fixed duration extension usage (`1.years` instead of `1.year`)
  - Updated imports to avoid unnecessary duplicates
- **README documentation**: Updated API examples to match actual implementation:
  - Changed `Hora.now(utc: true)` to `Hora.nowUtc()`
  - Clarified `fromNow()` (extensions) vs `relativeFromNow()` (plugin) usage

### Added
- **HoraDuration.ofMicroseconds()**: Factory constructor for creating durations from microseconds

### Improved
- **Extension design**: Clearer separation between core extensions and plugin extensions
  - Core extensions (`extensions.dart`): Simple, intuitive methods (`fromNow()`, `earliest`, `latest`, `rangeTo()`)
  - Plugin extensions: Rich APIs with configuration options (`calendar()` with `CalendarConfig`)
- **Example structure**: Reorganized example directory as a complete Dart package
  - Added `pubspec.yaml` with proper dependency
  - Moved source files to `bin/` directory
  - Updated README with comprehensive documentation

## [1.0.0] - 2025-12-06

### Added

#### Core Features
- **Hora class**: Immutable date-time wrapper with comprehensive API
  - Multiple constructors: `now()`, `of()`, `fromDateTime()`, `fromUnix()`, `fromUnixMillis()`, `parse()`
  - Date component getters: `year`, `month`, `day`, `weekday`, `hour`, `minute`, `second`, `millisecond`, `microsecond`
  - Derived properties: `quarter`, `dayOfYear`, `isoWeek`, `isoWeekYear`, `isLeapYear`, `daysInMonth`, `daysInYear`
  - Manipulation: `add()`, `subtract()`, `startOf()`, `endOf()`, `copyWith()`
  - Comparison: `isBefore()`, `isAfter()`, `isSame()`, `isSameOrBefore()`, `isSameOrAfter()`, `isBetween()`, `difference()`, `diff()`
  - Query: `isToday`, `isYesterday`, `isTomorrow`, `isThisWeek`, `isThisMonth`, `isThisYear`, `isPast`, `isFuture`, `isWeekend`, `isWeekday`
  - Formatting: `format()`, `toIso8601()`, `toList()`, `toMap()`
  - Timezone support: `toUtc()`, `toLocal()`, `isUtc`, `isLocal`, `timeZoneOffset`, `timeZoneName`

#### Temporal Units
- **TemporalUnit sealed class**: Type-safe unit specifications
  - Fixed units: `microsecond`, `millisecond`, `second`, `minute`, `hour`, `day`, `week`
  - Calendar units: `month`, `quarter`, `year`
  - Pattern matching support via sealed class
  - Parse from string with `TemporalUnit.parse()` and `TemporalUnit.tryParse()`

#### Duration Support
- **HoraDuration class**: Calendar-aware duration handling
  - Proper month and year arithmetic (not approximated to days)
  - ISO 8601 duration parsing: `HoraDuration.parse('P1Y2M3DT4H5M6S')`
  - Factory constructors: `between()`, `fromDuration()`
  - Arithmetic: `+`, `-`, `*`, `~/`
  - Formatting: `toIso8601()`, `humanize()`
  - Normalization: `normalize()`
  - Comparison: `compareTo()`, `==`, `<`, `>`

#### Internationalization
- **HoraLocale abstract class**: Base for locale definitions
  - Month names (full and short)
  - Weekday names (full, short, min)
  - Week configuration (start day, year start)
  - Ordinal formatting
  - Meridiem (AM/PM) formatting
  - Relative time expressions

- **Built-in locales**:
  - `HoraLocaleEn`: English (default)
  - `HoraLocaleZhCn`: Simplified Chinese

- **HoraLocales registry**: Register and retrieve locales by code

#### Extensions
- **DateTimeToHora**: `DateTime.toHora()`
- **DurationToHoraDuration**: `Duration.toHoraDuration()`
- **StringToHora**: `String.toHora()`, `String.toHoraOrNull()`
- **IntToHora**: `int.toHoraFromUnix()`, `int.toHoraFromUnixMillis()`
- **HoraRelativeTimeExt**: `fromNow()`, `toNow()`, `from()`, `to()`
- **HoraCalendarExt**: `calendar()`
- **HoraMinMaxExt**: `earliest`, `latest` on `Iterable<Hora>`
- **HoraRangeExt**: `rangeTo()`, `take()`
- **HoraBuilderExt**: `atStartOfDay()`, `atEndOfDay()`, `atNoon()`, `atMidnight()`, `atYear()`, `atMonth()`, `atDay()`, `atHour()`, `atMinute()`, `atSecond()`

#### Formatting
- **HoraFormatter**: Comprehensive date formatting
  - Year: `YYYY`, `YY`
  - Month: `MMMM`, `MMM`, `MM`, `M`
  - Day: `DD`, `D`, `Do`
  - Weekday: `dddd`, `ddd`, `dd`, `d`
  - Hour: `HH`, `H`, `hh`, `h`
  - Minute: `mm`, `m`
  - Second: `ss`, `s`
  - Millisecond: `SSS`
  - Meridiem: `A`, `a`
  - Quarter: `Q`
  - Week: `W`
  - Timezone: `Z`, `ZZ`
  - Timestamp: `X`, `x`
  - Escape: `[...]`

### Technical Details
- Dart SDK: `^3.0.0`
- Dependencies: `meta: ^1.11.0` (for `@immutable` annotations)
- Full null-safety support
- Strict analysis with `lints: ^5.0.0`

### Testing
- Comprehensive test suite covering all features
- Unit tests for core classes, extensions, and utilities
- Edge case handling for date boundaries, leap years, timezone transitions

## [Unreleased]

### Added

#### Internationalization - 143 Built-in Locales

Hora now includes **143 locale definitions** converted from dayjs, covering major world languages:

- **European**: de, fr, es, it, pt, nl, pl, ru, uk, cs, sk, hu, ro, bg, el, tr, sv, da, nb, fi, et, lv, lt, be, hr, sl, sq, sr, mk, bs, me, is, ga, gd, cy, br, fy, lb, fo, nn, eo, and regional variants
- **Asian**: zh, zh-cn, zh-tw, zh-hk, ja, ko, th, vi, id, ms, ms-my, tl-ph, km, lo, my, bn, bn-bd, hi, ta, te, kn, ml, gu, mr, pa-in, ne, si, bo, ug-cn, and more
- **Middle Eastern**: ar (and regional variants: ar-sa, ar-eg, ar-dz, ar-iq, ar-kw, ar-ly, ar-ma, ar-tn), fa, he, ur, ku, az, kk, ky, tk, uz, uz-latn, tg
- **African**: sw, yo, am, rn, rw, ss
- **Others**: eo (Esperanto), tlh (Klingon), x-pseudo (pseudo-localization)

**Tree-Shaking Support**: Each locale is a separate file. Import only what you need:

```dart
import 'package:hora/hora.dart';                  // Includes en, zh-cn
import 'package:hora/src/locales/ja.dart';        // Japanese
import 'package:hora/src/locales/de.dart';        // German

final h = Hora.now(locale: const HoraLocaleJa());
```

#### New Plugins
- **LocalizedFormat plugin**: Format dates using locale-specific format strings
  - `localizedFormat()`: Format using tokens like `LT`, `LTS`, `L`, `LL`, `LLL`, `LLLL`
  - Predefined presets for common locales (en, en-GB, zh-CN, ja, ko, de, fr, es, ru, ar, pt-BR, it)
  - Automatic locale detection from Hora instance

- **WeekYear plugin**: Week-year calculations for ISO and US calendars
  - `weekYear()`: Get the week-year value
  - `weekOfWeekYear()`: Get the week number within the week-year
  - `weeksInWeekYear()`: Get total weeks in the week-year
  - `setWeekYear()`: Create new instance with specified week-year
  - Support for both ISO (Monday start) and US (Sunday start) week configurations

- **UpdateLocale plugin**: Runtime locale modification
  - `update()`: Create modified locale with overridden properties
  - `updateRelativeTime()`: Override relative time expressions
  - `updateFormats()`: Override format strings
  - `UpdatedLocale` class for wrapping base locales with modifications

- **ObjectSupport plugin**: Map-based date creation and manipulation
  - `HoraObject.from()`: Create Hora from Map
  - `addObject()`: Add time using Map values
  - `subtractObject()`: Subtract time using Map values  
  - `setObject()`: Set date components using Map
  - `getByKey()` / `setByKey()`: Access components by string key

### Improved

- **HoraFormats**: Added descriptive getter aliases (`timeShort`, `timeLong`, `dateShort`, `dateLong`, `dateTimeLong`, `dateTimeFull`)
- **HoraLocale**: Improved documentation with usage examples
- **HoraRelativeTime**: Better documentation explaining placeholders
