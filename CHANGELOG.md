# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-02-18

### Breaking Changes
- Replaced `week_of_year.dart` and `week_year.dart` exports with a unified `week.dart` plugin.
- Week API migration: `weekOfWeekYear()` -> `weekOfYear()`, `weeksInWeekYear()` -> `weeksInYear()`, and `WeekYearConfig` -> `WeekConfig`.
- `Hora.fromMap()` / `Hora.from({...})` now enforce strict, fail-fast map parsing (conflicting aliases, unsupported keys, and mixed timestamp/component inputs are rejected).
- Map-based public APIs now use `Map<String, Object?>` instead of `Map<String, dynamic>`.
- `getByKey()` / `setByKey()` in object-support now throw `ArgumentError` for unsupported keys (no silent null/no-op fallback).

### Added
- Unified input APIs: `Hora.from()`, `Hora.tryFrom()`, `Hora.fromMap()`, and `Hora.fromTimestamp()`.
- Input control enums: `HoraParseMode` (`strict`/`smart`) and `UnixTimestampUnit` (`auto`/`seconds`/`milliseconds`/`microseconds`).
- Multi-unit manipulation APIs: `plus()`, `minus()`, and `set()` alias.
- Typed interval API: `HoraInclusivity` + `isBetweenWith(...)`.
- Map extension APIs: `Map<String, Object?>.toHora()` and `.tryToHora()`.
- Unified week plugin (`week.dart`) with `WeekConfig` (ISO, US, locale-aware, and custom week rules).
- Typed object support fields (`HoraGetField`, `HoraSetField`) in object-support plugin.
- CI and local quality automation via `.github/workflows/ci.yml` and `tool/quality_gate.sh`.

### Changed
- Refactored object-support plugin to delegate map creation/parsing to core `Hora` APIs and unify object delta application.
- Improved recurrence plugin validation and matching logic for interval/count/weekday constraints and edge cases.
- Improved precision plugin rounding/truncation with UTC-preserving construction and boundary-based rounding.
- Improved timezone plugin with strict offset validation and microsecond-precision conversions.
- Improved calendar plugin token handling (`L`, `LT`, `LTS`, `LL`, `LLL`, `LLLL`) and weekday parameter validation.
- Improved range helpers (`rangeTo`, `take`) with stronger argument validation on invalid inputs.
- Updated `README.md` and `README.zh-CN.md` for 2.0 APIs, migration notes, and stricter locale-update constraints.
- Expanded 2.0 test suite with deterministic parameterized/property-style boundary checks for timestamp unit auto-detection, week invariants, timezone offset round-trips, precision idempotence, fiscal period bounds, and recurrence range slicing.

### Fixed
- Fixed UTC/local consistency in `dayOfYear`, ISO week calculations, and related week/year boundaries.
- Fixed `HoraDuration.parse()` accepting empty ISO duration payloads.
- Fixed `HoraDuration` arithmetic/compare semantics for stable ordering and finite-factor checks.
- Fixed duration extension totals/humanization behavior for negative and sub-second durations.
- Fixed Japanese era boundary handling to use exact era start dates (not month-only checks).
- Fixed fiscal-year end boundary computation for leap-sensitive configurations (for example `startMonth: 2, startDay: 29`).
- Fixed fiscal quarter boundary handling for pre-boundary dates in `startMonth` so they map to fiscal month 12 / quarter 4 (preventing invalid quarter 5 outcomes).
- Fixed `update_locale` runtime validation to reject invalid override lengths/ranges early.

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
