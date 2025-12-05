/// All plugins for Hora.
///
/// This library exports all available plugins that extend Hora's functionality.
/// Import individual plugins to keep your bundle size small, or import this
/// file to get all plugins at once.
///
/// ## Usage
///
/// ```dart
/// // Import all plugins at once
/// import 'package:hora/plugins.dart';
///
/// // Or import individual plugins for smaller bundle size
/// import 'package:hora/src/plugins/advanced_format.dart';
/// import 'package:hora/src/plugins/relative_time.dart';
/// ```
///
/// ## Available Plugins
///
/// - **advanced_format** - Extended format tokens (Do, Qo, k, X, etc.)
/// - **buddhist_era** - Buddhist Era calendar support
/// - **business_day** - Business day calculations with holidays
/// - **calendar** - Calendar-style formatting and iteration
/// - **custom_parse_format** - Parse dates with custom format patterns
/// - **duration_ext** - Enhanced duration manipulation
/// - **fiscal_year** - Fiscal year calculations
/// - **locale_data** - Access locale-specific data
/// - **min_max** - Find min/max dates, clamp ranges
/// - **precision** - Precision-aware comparisons and rounding
/// - **recurrence** - Generate recurring date patterns
/// - **relative_time** - Human-readable relative time
/// - **timezone** - Timezone conversions
/// - **week_of_year** - ISO and locale-aware week calculations
library;

export 'src/plugins/plugins.dart';
