/// Hora - A lightweight, immutable date time library for Dart.
///
/// Inspired by dayjs with comprehensive features, plugins, and i18n support.
///
/// ## Features
///
/// - 🪶 **Lightweight** - Minimal footprint with tree-shakable plugins
/// - 🔒 **Immutable** - All operations return new instances
/// - 🌍 **I18n** - Built-in internationalization with 100+ locales
/// - 🔌 **Plugins** - Extend functionality with optional plugins
/// - 🎯 **Type-safe** - Full Dart type system support
/// - ⚡ **Fast** - Optimized for performance
///
/// ## Quick Start
///
/// ```dart
/// import 'package:hora/hora.dart';
///
/// // Create a Hora instance
/// final now = Hora.now();
/// final specific = Hora.parse('2023-12-25');
///
/// // Format dates
/// print(now.format('YYYY-MM-DD')); // 2023-12-05
///
/// // Manipulate dates
/// final tomorrow = now.add(1, TemporalUnit.day);
/// final lastMonth = now.subtract(1, TemporalUnit.month);
///
/// // Compare dates
/// print(now.isBefore(tomorrow)); // true
/// print(now.isAfter(lastMonth)); // true
/// ```
library;

export 'src/duration.dart';
export 'src/extensions.dart';
export 'src/hora.dart';
export 'src/locale.dart';
export 'src/units.dart';
