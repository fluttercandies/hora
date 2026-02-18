/// Update locale plugin for Hora.
///
/// This plugin allows runtime modification of locale data without creating
/// a new locale class. Useful for customizing locale behavior on the fly.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/update_locale.dart';
///
/// // Create a modified locale
/// final customLocale = const HoraLocaleEn().update(
///   months: ['January', 'February', ...],
///   weekStart: 1,
/// );
///
/// final h = Hora.now(locale: customLocale);
/// ```
library;

import '../hora.dart';
import '../locale.dart';

void _validateLocaleCode(String? code) {
  if (code == null) return;
  if (code.trim().isEmpty) {
    throw ArgumentError.value(code, 'code', 'Locale code must not be empty.');
  }
}

void _validateLocaleList(
  List<String>? values,
  String field,
  int expectedLength,
) {
  if (values == null) return;
  if (values.length != expectedLength) {
    throw ArgumentError.value(
      values,
      field,
      'Expected exactly $expectedLength entries.',
    );
  }
}

void _validateLocaleRange(int? value, String field, int min, int max) {
  if (value == null) return;
  if (value < min || value > max) {
    throw ArgumentError.value(
      value,
      field,
      'Expected value in range $min..$max.',
    );
  }
}

void _validateLocaleOverrides({
  String? code,
  List<String>? months,
  List<String>? monthsShort,
  List<String>? weekdays,
  List<String>? weekdaysShort,
  List<String>? weekdaysMin,
  int? weekStart,
  int? yearStart,
}) {
  _validateLocaleCode(code);
  _validateLocaleList(months, 'months', 12);
  _validateLocaleList(monthsShort, 'monthsShort', 12);
  _validateLocaleList(weekdays, 'weekdays', 7);
  _validateLocaleList(weekdaysShort, 'weekdaysShort', 7);
  _validateLocaleList(weekdaysMin, 'weekdaysMin', 7);
  _validateLocaleRange(
    weekStart,
    'weekStart',
    DateTime.monday,
    DateTime.sunday,
  );
  _validateLocaleRange(yearStart, 'yearStart', 1, 7);
}

List<String> _validatedLocaleList(
  List<String> values, {
  required String field,
  required int expectedLength,
}) {
  if (values.length != expectedLength) {
    throw StateError(
      'Locale field "$field" must contain exactly $expectedLength entries.',
    );
  }
  return values;
}

int _validatedLocaleInt(
  int value, {
  required String field,
  required int min,
  required int max,
}) {
  if (value < min || value > max) {
    throw StateError('Locale field "$field" must be in range $min..$max.');
  }
  return value;
}

/// A wrapper locale that overrides specific properties of a base locale.
class UpdatedLocale extends HoraLocale {
  const UpdatedLocale(
    this._base, {
    String? code,
    List<String>? months,
    List<String>? monthsShort,
    List<String>? weekdays,
    List<String>? weekdaysShort,
    List<String>? weekdaysMin,
    int? weekStart,
    int? yearStart,
    String? invalidDate,
    HoraFormats? formats,
    HoraRelativeTime? relativeTime,
    String Function(int n, String? unit)? ordinal,
    String Function(int hour, int minute, {bool lowercase})? meridiem,
  })  : _code = code,
        _months = months,
        _monthsShort = monthsShort,
        _weekdays = weekdays,
        _weekdaysShort = weekdaysShort,
        _weekdaysMin = weekdaysMin,
        _weekStart = weekStart,
        _yearStart = yearStart,
        _invalidDate = invalidDate,
        _formats = formats,
        _relativeTime = relativeTime,
        _ordinal = ordinal,
        _meridiem = meridiem;

  final HoraLocale _base;
  final String? _code;
  final List<String>? _months;
  final List<String>? _monthsShort;
  final List<String>? _weekdays;
  final List<String>? _weekdaysShort;
  final List<String>? _weekdaysMin;
  final int? _weekStart;
  final int? _yearStart;
  final String? _invalidDate;
  final HoraFormats? _formats;
  final HoraRelativeTime? _relativeTime;
  final String Function(int n, String? unit)? _ordinal;
  final String Function(int hour, int minute, {bool lowercase})? _meridiem;

  @override
  String get code => _code ?? _base.code;

  @override
  List<String> get months => _validatedLocaleList(
        _months ?? _base.months,
        field: 'months',
        expectedLength: 12,
      );

  @override
  List<String> get monthsShort => _validatedLocaleList(
        _monthsShort ?? _base.monthsShort,
        field: 'monthsShort',
        expectedLength: 12,
      );

  @override
  List<String> get weekdays => _validatedLocaleList(
        _weekdays ?? _base.weekdays,
        field: 'weekdays',
        expectedLength: 7,
      );

  @override
  List<String> get weekdaysShort => _validatedLocaleList(
        _weekdaysShort ?? _base.weekdaysShort,
        field: 'weekdaysShort',
        expectedLength: 7,
      );

  @override
  List<String> get weekdaysMin => _validatedLocaleList(
        _weekdaysMin ?? _base.weekdaysMin,
        field: 'weekdaysMin',
        expectedLength: 7,
      );

  @override
  int get weekStart => _validatedLocaleInt(
        _weekStart ?? _base.weekStart,
        field: 'weekStart',
        min: DateTime.monday,
        max: DateTime.sunday,
      );

  @override
  int get yearStart => _validatedLocaleInt(
        _yearStart ?? _base.yearStart,
        field: 'yearStart',
        min: 1,
        max: 7,
      );

  @override
  String get invalidDate => _invalidDate ?? _base.invalidDate;

  @override
  HoraFormats get formats => _formats ?? _base.formats;

  @override
  HoraRelativeTime get relativeTime => _relativeTime ?? _base.relativeTime;

  @override
  String ordinal(int n, [String? unit]) {
    if (_ordinal != null) {
      return _ordinal!(n, unit);
    }
    return _base.ordinal(n, unit);
  }

  @override
  String meridiem(int hour, int minute, {bool lowercase = false}) {
    if (_meridiem != null) {
      return _meridiem!(hour, minute, lowercase: lowercase);
    }
    return _base.meridiem(hour, minute, lowercase: lowercase);
  }
}

/// Extension on [HoraLocale] for updating locale data.
extension UpdateLocaleExtension on HoraLocale {
  /// Creates a new locale with updated properties.
  ///
  /// Any properties not specified will use the original locale's values.
  UpdatedLocale update({
    String? code,
    List<String>? months,
    List<String>? monthsShort,
    List<String>? weekdays,
    List<String>? weekdaysShort,
    List<String>? weekdaysMin,
    int? weekStart,
    int? yearStart,
    String? invalidDate,
    HoraFormats? formats,
    HoraRelativeTime? relativeTime,
    String Function(int n, String? unit)? ordinal,
    String Function(int hour, int minute, {bool lowercase})? meridiem,
  }) {
    _validateLocaleOverrides(
      code: code,
      months: months,
      monthsShort: monthsShort,
      weekdays: weekdays,
      weekdaysShort: weekdaysShort,
      weekdaysMin: weekdaysMin,
      weekStart: weekStart,
      yearStart: yearStart,
    );
    return UpdatedLocale(
      this,
      code: code,
      months: months,
      monthsShort: monthsShort,
      weekdays: weekdays,
      weekdaysShort: weekdaysShort,
      weekdaysMin: weekdaysMin,
      weekStart: weekStart,
      yearStart: yearStart,
      invalidDate: invalidDate,
      formats: formats,
      relativeTime: relativeTime,
      ordinal: ordinal,
      meridiem: meridiem,
    );
  }

  /// Creates a new locale with updated formats.
  UpdatedLocale updateFormats({
    String? lt,
    String? lts,
    String? l,
    String? ll,
    String? lll,
    String? llll,
  }) =>
      UpdatedLocale(
        this,
        formats: HoraFormats(
          lt: lt ?? formats.lt,
          lts: lts ?? formats.lts,
          l: l ?? formats.l,
          ll: ll ?? formats.ll,
          lll: lll ?? formats.lll,
          llll: llll ?? formats.llll,
        ),
      );

  /// Creates a new locale with updated relative time.
  UpdatedLocale updateRelativeTime({
    String? future,
    String? past,
    String? s,
    String? m,
    String? mm,
    String? h,
    String? hh,
    String? d,
    String? dd,
    String? w,
    String? ww,
    String? mo,
    String? mos,
    String? y,
    String? yy,
  }) =>
      UpdatedLocale(
        this,
        relativeTime: HoraRelativeTime(
          future: future ?? relativeTime.future,
          past: past ?? relativeTime.past,
          s: s ?? relativeTime.s,
          m: m ?? relativeTime.m,
          mm: mm ?? relativeTime.mm,
          h: h ?? relativeTime.h,
          hh: hh ?? relativeTime.hh,
          d: d ?? relativeTime.d,
          dd: dd ?? relativeTime.dd,
          w: w ?? relativeTime.w,
          ww: ww ?? relativeTime.ww,
          mo: mo ?? relativeTime.mo,
          mos: mos ?? relativeTime.mos,
          y: y ?? relativeTime.y,
          yy: yy ?? relativeTime.yy,
        ),
      );
}

/// Updates the global locale settings.
///
/// Any properties not specified will keep the current global locale's values.
void updateHoraGlobalLocale({
  String? code,
  List<String>? months,
  List<String>? monthsShort,
  List<String>? weekdays,
  List<String>? weekdaysShort,
  List<String>? weekdaysMin,
  int? weekStart,
  int? yearStart,
  String? invalidDate,
  HoraFormats? formats,
  HoraRelativeTime? relativeTime,
}) {
  _validateLocaleOverrides(
    code: code,
    months: months,
    monthsShort: monthsShort,
    weekdays: weekdays,
    weekdaysShort: weekdaysShort,
    weekdaysMin: weekdaysMin,
    weekStart: weekStart,
    yearStart: yearStart,
  );
  Hora.globalLocale = Hora.globalLocale.update(
    code: code,
    months: months,
    monthsShort: monthsShort,
    weekdays: weekdays,
    weekdaysShort: weekdaysShort,
    weekdaysMin: weekdaysMin,
    weekStart: weekStart,
    yearStart: yearStart,
    invalidDate: invalidDate,
    formats: formats,
    relativeTime: relativeTime,
  );
}
