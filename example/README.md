# Hora Examples

This directory contains examples demonstrating how to use the Hora date/time library.

## Setup

```bash
cd example
dart pub get
```

## Examples

| Example | Description |
|---------|-------------|
| [basic_usage.dart](bin/basic_usage.dart) | Basic Hora operations |
| [date_manipulation.dart](bin/date_manipulation.dart) | Date manipulation examples |
| [formatting.dart](bin/formatting.dart) | Date formatting and localization |
| [extensions.dart](bin/extensions.dart) | Extension methods and utilities |
| [relative_time.dart](bin/relative_time.dart) | Relative time calculations |
| [calendar_formatting.dart](bin/calendar_formatting.dart) | Calendar-style formatting |
| [common_usage.dart](bin/common_usage.dart) | Common usage patterns |
| [duration.dart](bin/duration.dart) | HoraDuration examples |

## Running Examples

Run any example with:

```bash
# From the example directory
dart run bin/basic_usage.dart

# Or from the project root
dart run example/bin/basic_usage.dart
```

## Example Highlights

### Basic Usage

```dart
import 'package:hora/hora.dart';

void main() {
  final now = Hora.now();
  final christmas = Hora.of(year: 2024, month: 12, day: 25);
  
  print(now.format('YYYY-MM-DD HH:mm:ss'));
  print(christmas.fromNow());
}
```

### With Plugins

```dart
import 'package:hora/hora.dart';
import 'package:hora/plugins.dart';

void main() {
  final h = Hora.now();
  
  // Calendar formatting
  print(h.calendar());
  
  // Business days
  print(h.addBusinessDays(5));
  
  // Relative time
  print(h.relativeFromNow());
}
```

### With Locales

```dart
import 'package:hora/hora.dart';
import 'package:hora/src/locales/ja.dart';
import 'package:hora/src/locales/de.dart';

void main() {
  final japanese = Hora.now(locale: const HoraLocaleJa());
  final german = Hora.now(locale: const HoraLocaleDe());
  
  print(japanese.format('YYYY年M月D日'));
  print(german.format('D. MMMM YYYY'));
}
```
