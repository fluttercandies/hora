/// Localized format plugin for Hora.
///
/// This plugin adds support for localized date-time formats using
/// tokens like L, LL, LLL, LLLL, LT, LTS that adapt to the current locale.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/localized_format.dart';
///
/// final h = Hora.now();
/// print(h.localizedFormat('L'));     // 12/25/2023 (en) or 25/12/2023 (fr)
/// print(h.localizedFormat('LL'));    // December 25, 2023
/// print(h.localizedFormat('LLL'));   // December 25, 2023 10:30 AM
/// print(h.localizedFormat('LLLL'));  // Thursday, December 25, 2023 10:30 AM
/// print(h.localizedFormat('LT'));    // 10:30 AM
/// print(h.localizedFormat('LTS'));   // 10:30:45 AM
/// print(h.localizedFormat('l'));     // 12/25/2023 (compact)
/// print(h.localizedFormat('ll'));    // Dec 25, 2023
/// print(h.localizedFormat('lll'));   // Dec 25, 2023 10:30 AM
/// print(h.localizedFormat('llll'));  // Thu, Dec 25, 2023 10:30 AM
/// ```
library;

import '../hora.dart';
import '../locale.dart';

/// Common localized format presets for different locales.
class LocalizedFormatPresets {
  LocalizedFormatPresets._();

  /// English (US) formats
  static const en = HoraFormats();

  /// English (UK) formats
  static const enGB = HoraFormats(
    l: 'DD/MM/YYYY',
    ll: 'D MMMM YYYY',
    lll: 'D MMMM YYYY HH:mm',
    llll: 'dddd, D MMMM YYYY HH:mm',
    lt: 'HH:mm',
    lts: 'HH:mm:ss',
  );

  /// Chinese formats
  static const zhCN = HoraFormats(
    l: 'YYYY/MM/DD',
    ll: 'YYYY年M月D日',
    lll: 'YYYY年M月D日 HH:mm',
    llll: 'YYYY年M月D日dddd HH:mm',
    lt: 'HH:mm',
    lts: 'HH:mm:ss',
  );

  /// Japanese formats
  static const ja = HoraFormats(
    l: 'YYYY/MM/DD',
    ll: 'YYYY年M月D日',
    lll: 'YYYY年M月D日 HH:mm',
    llll: 'YYYY年M月D日(dddd) HH:mm',
    lt: 'HH:mm',
    lts: 'HH:mm:ss',
  );

  /// Korean formats
  static const ko = HoraFormats(
    l: 'YYYY.MM.DD',
    ll: 'YYYY년 M월 D일',
    lll: 'YYYY년 M월 D일 A h:mm',
    llll: 'YYYY년 M월 D일 dddd A h:mm',
    lt: 'A h:mm',
    lts: 'A h:mm:ss',
  );

  /// German formats
  static const de = HoraFormats(
    l: 'DD.MM.YYYY',
    ll: 'D. MMMM YYYY',
    lll: 'D. MMMM YYYY HH:mm',
    llll: 'dddd, D. MMMM YYYY HH:mm',
    lt: 'HH:mm',
    lts: 'HH:mm:ss',
  );

  /// French formats
  static const fr = HoraFormats(
    l: 'DD/MM/YYYY',
    ll: 'D MMMM YYYY',
    lll: 'D MMMM YYYY HH:mm',
    llll: 'dddd D MMMM YYYY HH:mm',
    lt: 'HH:mm',
    lts: 'HH:mm:ss',
  );

  /// Spanish formats
  static const es = HoraFormats(
    l: 'DD/MM/YYYY',
    ll: 'D [de] MMMM [de] YYYY',
    lll: 'D [de] MMMM [de] YYYY H:mm',
    llll: 'dddd, D [de] MMMM [de] YYYY H:mm',
    lt: 'H:mm',
    lts: 'H:mm:ss',
  );

  /// Russian formats
  static const ru = HoraFormats(
    l: 'DD.MM.YYYY',
    ll: 'D MMMM YYYY г.',
    lll: 'D MMMM YYYY г., HH:mm',
    llll: 'dddd, D MMMM YYYY г., HH:mm',
    lt: 'HH:mm',
    lts: 'HH:mm:ss',
  );

  /// Arabic formats
  static const ar = HoraFormats(
    l: 'DD/MM/YYYY',
    ll: 'D MMMM YYYY',
    lll: 'D MMMM YYYY HH:mm',
    llll: 'dddd D MMMM YYYY HH:mm',
    lt: 'HH:mm',
    lts: 'HH:mm:ss',
  );

  /// Portuguese (Brazil) formats
  static const ptBR = HoraFormats(
    l: 'DD/MM/YYYY',
    ll: 'D [de] MMMM [de] YYYY',
    lll: 'D [de] MMMM [de] YYYY [às] HH:mm',
    llll: 'dddd, D [de] MMMM [de] YYYY [às] HH:mm',
    lt: 'HH:mm',
    lts: 'HH:mm:ss',
  );

  /// Italian formats
  static const it = HoraFormats(
    l: 'DD/MM/YYYY',
    ll: 'D MMMM YYYY',
    lll: 'D MMMM YYYY HH:mm',
    llll: 'dddd D MMMM YYYY HH:mm',
    lt: 'HH:mm',
    lts: 'HH:mm:ss',
  );

  /// Gets the format for a locale code.
  static HoraFormats forLocale(String localeCode) {
    final code = localeCode.toLowerCase().replaceAll('-', '_');
    return switch (code) {
      'en' || 'en_us' => en,
      'en_gb' || 'en_au' || 'en_nz' => enGB,
      'zh' || 'zh_cn' || 'zh_hans' => zhCN,
      'ja' || 'ja_jp' => ja,
      'ko' || 'ko_kr' => ko,
      'de' || 'de_de' || 'de_at' || 'de_ch' => de,
      'fr' || 'fr_fr' || 'fr_ca' => fr,
      'es' || 'es_es' || 'es_mx' => es,
      'ru' || 'ru_ru' => ru,
      'ar' || 'ar_sa' => ar,
      'pt' || 'pt_br' => ptBR,
      'it' || 'it_it' => it,
      _ => en,
    };
  }
}

/// Extension on [Hora] for localized formatting.
extension LocalizedFormatExtension on Hora {
  /// Formats using a localized format token.
  ///
  /// Supported tokens:
  /// - `LT` - Time (e.g., "10:30 AM")
  /// - `LTS` - Time with seconds (e.g., "10:30:45 AM")
  /// - `L` - Short date (e.g., "12/25/2023")
  /// - `LL` - Long date (e.g., "December 25, 2023")
  /// - `LLL` - Long date with time (e.g., "December 25, 2023 10:30 AM")
  /// - `LLLL` - Full format (e.g., "Thursday, December 25, 2023 10:30 AM")
  /// - `l`, `ll`, `lll`, `llll` - Compact versions of above
  ///
  /// You can also use these tokens within a larger format string.
  String localizedFormat(String pattern, {HoraFormats? formats}) {
    final localeFormats = formats ?? locale.formats;
    final expanded = _expandLocalizedTokens(pattern, localeFormats);
    return format(expanded);
  }

  String _expandLocalizedTokens(String pattern, HoraFormats formats) {
    // Replace localized tokens with their format patterns
    var result = pattern;

    // Long forms first (to avoid partial matches)
    result = result.replaceAll('LLLL', formats.llll);
    result = result.replaceAll('LLL', formats.lll);
    result = result.replaceAll('LTS', formats.lts);
    result = result.replaceAll('LT', formats.lt);
    result = result.replaceAll('LL', formats.ll);
    result = result.replaceAll(RegExp(r'\bL\b'), formats.l);

    // Compact forms (use shortened month/weekday names)
    result = result.replaceAll('llll', _compactFormat(formats.llll));
    result = result.replaceAll('lll', _compactFormat(formats.lll));
    result = result.replaceAll('ll', _compactFormat(formats.ll));
    result = result.replaceAll(RegExp(r'\bl\b'), _compactFormat(formats.l));

    return result;
  }

  /// Returns a compact version of a format (short month/weekday names).
  String _compactFormat(String format) =>
      format.replaceAll('MMMM', 'MMM').replaceAll('dddd', 'ddd');
}
