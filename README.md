<p align="center">
  <img src="hora.png" alt="Hora" width="180">
</p>

<h1 align="center">Hora</h1>

<p align="center">
  <a href="https://pub.dev/packages/hora"><img src="https://img.shields.io/pub/v/hora.svg" alt="pub package"></a>
  <a href="https://pub.dev/packages/hora/score"><img src="https://img.shields.io/pub/points/hora" alt="pub points"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
</p>

<p align="center">
  A powerful, immutable, and type-safe date-time library for Dart, inspired by <a href="https://day.js.org/">Day.js</a>.
</p>

<p align="center">
  <strong>Hora</strong> (from Latin, meaning "hour/time") provides a modern API for date-time manipulation with first-class Dart support, including sealed classes, pattern matching, and comprehensive type safety.
</p>

<p align="center">
  <a href="https://pub.dev/documentation/hora/latest/">📚 API Documentation</a> ·
  <a href="README.zh-CN.md">中文文档</a>
</p>

## Features

- 🔒 **Immutable by Design**: All operations return new instances
- 🎯 **Type-Safe**: Leverages Dart's sealed classes and pattern matching
- 🌍 **i18n Ready**: Built-in locale support with extensible architecture
- ⚡ **Lightweight**: No external dependencies (only `meta` for annotations)
- 📅 **Calendar-Aware Durations**: Proper handling of months and years
- 🔌 **Plugin System**: Extend functionality without modifying core
- 🧪 **Well Tested**: Comprehensive test coverage

## Installation

Add `hora` to your `pubspec.yaml`:

```yaml
dependencies:
  hora: any
```

Then run:

```bash
dart pub get
```

## Quick Start

```dart
import 'package:hora/hora.dart';

void main() {
  // Create a Hora instance
  final now = Hora.now();
  final date = Hora.of(year: 2024, month: 6, day: 15);
  
  // Parse from string
  final parsed = Hora.parse('2024-06-15T10:30:00');
  
  // Manipulate dates
  final nextWeek = now.add(1, TemporalUnit.week);
  final lastMonth = now.subtract(1, TemporalUnit.month);
  
  // Format dates
  print(now.format('YYYY-MM-DD')); // 2024-06-15
  print(now.format('MMMM D, YYYY')); // June 15, 2024
  
  // Relative time
  print(date.fromNow()); // "2 months ago"
}
```

## API Overview

### Creating Hora Instances

```dart
// Current time
Hora.now()
Hora.nowUtc()

// From components
Hora.of(year: 2024, month: 6, day: 15)
Hora.of(year: 2024, month: 6, day: 15, hour: 10, minute: 30, second: 45)

// From DateTime
Hora.fromDateTime(DateTime.now())

// Unified input (2.0-friendly)
Hora.from(DateTime.now())
Hora.from('2024-06-15')
Hora.from(1718409600000) // auto-detect unix precision
Hora.from({'year': 2024, 'month': 6, 'day': 15})
Hora.tryFrom(anyValue) // null on invalid/unsupported
Hora.fromTimestamp(1718409600, unit: UnixTimestampUnit.seconds)
Hora.fromMap({'date': '2024-06-15', 'hour': 9, 'minute': 30})

// From timestamp
Hora.unix(1718409600)
Hora.unixMillis(1718409600000)

// Parse string
Hora.parse('2024-06-15')
Hora.parse('2024-06-15T10:30:00')
Hora.parse('2024/06/15', mode: HoraParseMode.smart)
Hora.parse('2024/06/15', mode: HoraParseMode.strict) // Invalid Hora
Hora.tryParse('invalid') // returns null instead of invalid Hora
```

Map input in `Hora.fromMap` / `Hora.from({...})` is strict and fail-fast:
- Use exactly one timestamp source (`unixMicros`, `unixMillis`, `unix`, or `timestamp`)
- Do not mix timestamp fields with date/component fields
- Alias keys must not conflict (for example `year` and `years`)
- `date` must be a parseable `String`, `DateTime`, or valid `Hora`

### Date Components

```dart
final h = Hora.of(year: 2024, month: 6, day: 15, hour: 14, minute: 30);

h.year        // 2024
h.month       // 6
h.day         // 15
h.weekday     // 6 (Saturday, ISO 8601)
h.hour        // 14
h.minute      // 30
h.second      // 0
h.millisecond // 0
h.microsecond // 0

// Derived properties
h.quarter     // 2
h.dayOfYear   // 167
h.isoWeek     // 24
h.isLeapYear  // true
h.daysInMonth // 30
```

### Manipulation

All manipulation methods return new instances:

```dart
// Add/subtract time
h.add(1, TemporalUnit.day)
h.subtract(2, TemporalUnit.week)
h.addDuration(Duration(hours: 5))
h.plus(months: 1, days: 3, hours: 2)  // multi-unit add
h.minus(weeks: 1, minutes: 30)         // multi-unit subtract

// Start/end of units
h.startOf(TemporalUnit.month)  // First day of month, 00:00:00
h.endOf(TemporalUnit.day)      // 23:59:59.999999

// Copy with modifications
h.copyWith(hour: 10, minute: 0)
h.set(hour: 10, minute: 0) // alias of copyWith
```

### Temporal Units

Hora uses a sealed `TemporalUnit` class for type-safe unit specifications:

```dart
// Fixed-duration units
TemporalUnit.microsecond
TemporalUnit.millisecond
TemporalUnit.second
TemporalUnit.minute
TemporalUnit.hour
TemporalUnit.day
TemporalUnit.week

// Calendar-based units (variable duration)
TemporalUnit.month
TemporalUnit.quarter
TemporalUnit.year
```

### Comparison

```dart
h1.isBefore(h2)
h1.isAfter(h2)
h1.isSame(h2, TemporalUnit.day)  // Same day?
h1.isSameOrBefore(h2)
h1.isSameOrAfter(h2)
h1.isBetween(start, end)
h1.isBetweenWith(start, end, inclusivity: HoraInclusivity.includeStart)

h1.difference(h2)  // Returns Duration
h1.diff(h2, TemporalUnit.day)  // Returns num
```

### Query

```dart
h.isToday
h.isYesterday
h.isTomorrow
h.isThisWeek
h.isThisMonth
h.isThisYear
h.isPast
h.isFuture
h.isWeekend
h.isWeekday
```

### Formatting

```dart
h.format('YYYY-MM-DD')           // 2024-06-15
h.format('MMMM D, YYYY')         // June 15, 2024
h.format('dddd, MMM D')          // Saturday, Jun 15
h.format('h:mm A')               // 2:30 PM
h.toIso8601()                    // 2024-06-15T14:30:00.000
```

#### Format Tokens

| Token | Output | Description |
|-------|--------|-------------|
| `YYYY` | 2024 | 4-digit year |
| `YY` | 24 | 2-digit year |
| `MMMM` | June | Full month name |
| `MMM` | Jun | Short month name |
| `MM` | 06 | Month (2-digit) |
| `M` | 6 | Month |
| `DD` | 15 | Day (2-digit) |
| `D` | 15 | Day |
| `Do` | 15th | Day with ordinal |
| `dddd` | Saturday | Full weekday |
| `ddd` | Sat | Short weekday |
| `dd` | Sa | Min weekday |
| `d` | 6 | Weekday (0-6) |
| `HH` | 14 | Hour 24h (2-digit) |
| `H` | 14 | Hour 24h |
| `hh` | 02 | Hour 12h (2-digit) |
| `h` | 2 | Hour 12h |
| `mm` | 30 | Minute (2-digit) |
| `m` | 30 | Minute |
| `ss` | 00 | Second (2-digit) |
| `s` | 0 | Second |
| `A` | PM | AM/PM |
| `a` | pm | am/pm |
| `Q` | 2 | Quarter |
| `W` | 24 | ISO week |
| `Z` | +00:00 | Timezone offset |
| `X` | 1718409600 | Unix timestamp |
| `x` | 1718409600000 | Unix millis |

### Relative Time

```dart
// From now (via extensions)
past.fromNow()    // "3 days ago"
future.fromNow()  // "in 2 hours"

// From/to another date
h1.from(h2)       // "5 days ago"
h1.to(h2)         // "in 5 days"

// Without suffix
past.fromNow(withoutSuffix: true)  // "3 days"

// Advanced relative time (via relative_time plugin)
import 'package:hora/src/plugins/relative_time.dart';

past.relativeFromNow()    // "3 days ago" (with more options)
```

### Calendar Format

```dart
h.calendar()
// Today at 2:30 PM
// Yesterday at 3:00 PM
// Tomorrow at 10:00 AM
// Last Monday at 9:00 AM
// 12/25/2023
```

## HoraDuration

`HoraDuration` provides calendar-aware durations that properly handle months and years:

```dart
// Create durations
final d1 = HoraDuration(years: 1, months: 6);
final d2 = HoraDuration(days: 30, hours: 12);
final d3 = HoraDuration.between(h1, h2);

// Parse ISO 8601
final d4 = HoraDuration.parse('P1Y6M');
final d5 = HoraDuration.parse('P2DT12H30M');

// Arithmetic
final sum = d1 + d2;
final diff = d1 - d2;
final scaled = d1 * 2;

// Format
d1.toIso8601()  // "P1Y6M"
d1.humanize()   // "a year"

// Normalize
HoraDuration(minutes: 90).normalize()  // 1h 30m
```

## Localization

Hora includes **143 built-in locales** covering major world languages, all designed for tree-shaking.

### Quick Start

```dart
import 'package:hora/hora.dart';

// English and Chinese are included by default
final now = Hora.now(); // Uses HoraLocaleEn
final chinese = Hora.now(locale: const HoraLocaleZhCn());

print(now.format('MMMM D, YYYY'));     // December 6, 2024
print(chinese.format('YYYY年M月D日'));  // 2024年12月6日
```

### Using Additional Locales

Import only the locales you need for optimal tree-shaking:

```dart
import 'package:hora/hora.dart';
import 'package:hora/src/locales/ja.dart';
import 'package:hora/src/locales/ko.dart';
import 'package:hora/src/locales/de.dart';

void main() {
  final japanese = Hora.now(locale: const HoraLocaleJa());
  final korean = Hora.now(locale: const HoraLocaleKo());
  final german = Hora.now(locale: const HoraLocaleDe());

  print(japanese.format('YYYY年M月D日')); // 2024年12月6日
  print(korean.format('YYYY년 M월 D일')); // 2024년 12월 6일
  print(german.format('D. MMMM YYYY'));   // 6. Dezember 2024
}
```

### Available Locales

| Region | Locales |
|--------|---------|
| **Default** | `en`, `zh-cn` (exported from hora.dart) |
| **European** | `de`, `fr`, `es`, `it`, `pt`, `nl`, `pl`, `ru`, `uk`, `cs`, `sk`, `hu`, `ro`, `bg`, `el`, `tr`, `sv`, `da`, `no`, `fi`, `et`, `lv`, `lt`, ... |
| **Asian** | `zh`, `zh-tw`, `zh-hk`, `ja`, `ko`, `th`, `vi`, `id`, `ms`, `tl-ph`, `km`, `lo`, `my`, `bn`, `hi`, `ta`, `te`, `kn`, `ml`, `gu`, `mr`, `pa-in`, `ne`, ... |
| **Middle Eastern** | `ar`, `ar-sa`, `ar-eg`, `fa`, `he`, `ur`, `ku`, ... |
| **Other** | `sw`, `yo`, `am`, `ti`, `eo`, `tlh`, ... |

Full list: See [lib/src/locales/](lib/src/locales/) directory.

### Global Locale

Set a default locale for all new Hora instances:

```dart
// Set global locale
Hora.globalLocale = const HoraLocaleZhCn();

// New instances use global locale
final h1 = Hora.now(); // Uses HoraLocaleZhCn
final h2 = Hora.of(year: 2024, month: 12, day: 5); // Uses HoraLocaleZhCn

// Override with explicit locale
final h3 = Hora.now(locale: const HoraLocaleEn()); // Uses HoraLocaleEn
```

### Change Locale on Existing Instance

```dart
final h = Hora.now(locale: const HoraLocaleEn());
print(h.format('MMMM')); // December

final h2 = h.withLocale(const HoraLocaleZhCn());
print(h2.format('MMMM')); // 十二月
```

### Creating Custom Locales

```dart
class HoraLocaleEs extends HoraLocale {
  const HoraLocaleEs();

  @override
  String get code => 'es';

  @override
  List<String> get months => const [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  @override
  List<String> get monthsShort => const [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
  ];

  @override
  List<String> get weekdays => const [
    'Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'
  ];

  @override
  List<String> get weekdaysShort => const ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];

  @override
  List<String> get weekdaysMin => const ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sá'];

  @override
  int get weekStart => DateTime.monday; // Week starts on Monday

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
    future: 'en %s',
    past: 'hace %s',
    s: 'unos segundos',
    m: 'un minuto',
    mm: '%d minutos',
    h: 'una hora',
    hh: '%d horas',
    d: 'un día',
    dd: '%d días',
    mo: 'un mes',
    mos: '%d meses',
    y: 'un año',
    yy: '%d años',
  );

  @override
  String ordinal(int n, [String? unit]) => '${n}º';
}
```

## Extensions

Hora provides convenient extensions:

```dart
// DateTime extension
DateTime.now().toHora()

// Duration extension  
Duration(days: 5).toHoraDuration()

// String parsing
'2024-06-15'.toHora()

// Int timestamps
1718409600.asUnixSeconds
1718409600000.asUnixMillis
1718409600000000.asUnixMicros
1718409600.asUnix(unit: UnixTimestampUnit.seconds)

// Map parsing
{'year': 2024, 'month': 6, 'day': 15}.toHora()

// Range generation
start.rangeTo(end, step: TemporalUnit.day)  // Iterable<Hora>
start.take(10, step: TemporalUnit.day)      // 10 consecutive days

// Min/Max
[h1, h2, h3].earliest  // Hora?
[h1, h2, h3].latest    // Hora?

// Builder methods
Hora.now()
    .startOf(TemporalUnit.day)
    .copyWith(month: 6)
    .copyWith(year: 2024)
```

## Plugins

Hora comes with a rich set of plugins that extend its functionality. All plugins are available via extension methods, requiring no separate registration.

### LocalizedFormat

Format dates using locale-specific format strings:

```dart
import 'package:hora/hora.dart';
import 'package:hora/src/plugins/localized_format.dart';

final h = Hora.of(year: 2024, month: 6, day: 15, hour: 14, minute: 30);

// Using predefined presets
h.localizedFormat('LT')    // "2:30 PM"
h.localizedFormat('LTS')   // "2:30:45 PM"
h.localizedFormat('L')     // "06/15/2024"
h.localizedFormat('LL')    // "June 15, 2024"
h.localizedFormat('LLL')   // "June 15, 2024 2:30 PM"
h.localizedFormat('LLLL')  // "Saturday, June 15, 2024 2:30 PM"

// With different locales
final zhLocale = const HoraLocaleZhCn();
h.withLocale(zhLocale).localizedFormat('LL')  // Uses Chinese format
```

### Week

Calculate week numbers and week-years with ISO/US/locale/custom configurations:

```dart
import 'package:hora/hora.dart';
import 'package:hora/src/plugins/week.dart';

final h = Hora.of(year: 2024, month: 1, day: 1);

// ISO week system (default)
h.weekOfYear()   // 1
h.weekYear()     // 2024
h.weeksInYear()  // 52 (or 53)

// Locale-aware shortcuts
h.localeWeek
h.localeWeekYear

// US/custom week configuration
h.weekOfYear(config: WeekConfig.us)
h.startOfWeek(config: WeekConfig.us)
h.daysOfWeekWith(
  config: const WeekConfig(
    firstDayOfWeek: DateTime.saturday,
    minDaysInFirstWeek: 1,
  ),
)

// Set week position
h.setWeekOfYear(10)
h.setWeekYear(2025)
```

### UpdateLocale

Dynamically modify locale settings at runtime:

```dart
import 'package:hora/hora.dart';
import 'package:hora/src/plugins/update_locale.dart';

// Create updated locale from base
final customLocale = const HoraLocaleEn().update(
  weekStart: DateTime.monday,
  yearStart: 4,
);

// Update relative time settings
final rtLocale = const HoraLocaleEn().updateRelativeTime(
  s: 'just now',
  m: 'a minute ago',
);

// Update format strings
final fmtLocale = const HoraLocaleEn().updateFormats(
  lt: 'HH:mm',
  ll: 'YYYY年M月D日',
);

// Use updated locale
final h = Hora.now(locale: customLocale);
```

`update()` / `updateFormats()` / `updateRelativeTime()` now validate overrides strictly:
- `months` / `monthsShort` must contain exactly 12 entries
- `weekdays` / `weekdaysShort` / `weekdaysMin` must contain exactly 7 entries
- `weekStart` must be `1..7`, and `yearStart` must be `1..7`

### ObjectSupport

Create and manipulate Hora instances using Map objects:

```dart
import 'package:hora/hora.dart';
import 'package:hora/src/plugins/object_support.dart';

// Create from object
final h = HoraObject.from({
  'year': 2024,
  'month': 6,
  'day': 15,
  'hour': 14,
  'minute': 30,
});

// Add using object
h.addObject({'days': 5, 'hours': 3})

// Subtract using object
h.subtractObject({'months': 1})

// Set using object
h.setObject({'hour': 10, 'minute': 0})

// Get/set by key
h.getByKey('month')  // 6
h.setByKey('day', 20)

// Typed get/set fields
h.getByField(HoraGetField.isoWeek)
h.setByField(HoraSetField.day, 20)
```

`HoraObject` / object-support map APIs use `Map<String, Object?>` in 2.0, and
`getByKey()` / `setByKey()` now throw `ArgumentError` for unsupported keys.

### Other Plugins

Hora includes many more plugins:

| Plugin              | Description                                   |
|---------------------|-----------------------------------------------|
| `advancedFormat`    | Extended format tokens (`Q`, `Do`, `k`, etc.) |
| `buddhistEra`       | Buddhist Era calendar support                 |
| `businessDay`       | Business day calculations                     |
| `calendar`          | Calendar-style date formatting                |
| `customParseFormat` | Parse dates with custom format strings        |
| `durationExt`       | Advanced duration handling                    |
| `fiscalYear`        | Fiscal year calculations                      |
| `localeData`        | Access locale data programmatically           |
| `minMax`            | Find min/max in date collections              |
| `precision`         | Precision-aware date comparisons              |
| `recurrence`        | Recurring date patterns                       |
| `relativeTime`      | Human-readable relative time                  |
| `timezone`          | Timezone support                              |
| `week`              | Unified week calculations                     |

## Comparison with Other Libraries

| Feature            | Hora                | Day.js | moment.js |
|--------------------|---------------------|--------|-----------|
| Immutable          | ✅                   | ✅      | ❌         |
| Type-safe          | ✅ (Dart)            | ❌      | ❌         |
| Tree-shakable      | ✅                   | ✅      | ❌         |
| Null-safe          | ✅                   | N/A    | N/A       |
| Plugin system      | ✅ (dart extensions) | ✅      | ✅         |
| Locale support     | ✅                   | ✅      | ✅         |
| Calendar durations | ✅                   | Plugin | ✅         |

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

MIT License - see [LICENSE](LICENSE) for details.

---

Made with ❤️ by [Flutter Candies](https://github.com/fluttercandies)
