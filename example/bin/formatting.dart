import 'package:hora/hora.dart';
import 'package:hora/src/locales/de.dart';
import 'package:hora/src/locales/es.dart';
import 'package:hora/src/locales/fr.dart';
import 'package:hora/src/locales/it.dart';
import 'package:hora/src/locales/pt.dart';

void main() {
  final date = Hora.of(
    year: 2023,
    month: 12,
    day: 25,
    hour: 14,
    minute: 30,
    second: 45,
    millisecond: 123,
    microsecond: 456,
  );
  print('Base date: $date\n');

  // Basic formatting
  print('Basic formatting:');
  print('ISO format: ${date.format()}');
  print('YYYY-MM-DD: ${date.format('YYYY-MM-DD')}');
  print('MM/DD/YYYY: ${date.format('MM/DD/YYYY')}');
  print('DD MMM YYYY: ${date.format('DD MMM YYYY')}');
  print('MMMM Do, YYYY: ${date.format('MMMM Do, YYYY')}');
  print('YYYY-MM-DD HH:mm:ss: ${date.format('YYYY-MM-DD HH:mm:ss')}');
  print('HH:mm:ss.SSS: ${date.format('HH:mm:ss.SSS')}');

  // Advanced formatting
  print('\nAdvanced formatting:');
  print('Day of year: ${date.format('DDDD')}');
  print('Week of year: ${date.format('w')}');
  print('Quarter: ${date.format('Q')}');
  print('Day name: ${date.format('dddd')}');
  print('Day name (short): ${date.format('ddd')}');
  print('Month name: ${date.format('MMMM')}');
  print('Month name (short): ${date.format('MMM')}');
  print('AM/PM: ${date.format('A')}');
  print('am/pm: ${date.format('a')}');
  print('12-hour format: ${date.format('h:mm A')}');
  print('24-hour format: ${date.format('HH:mm')}');

  // Localization
  print('\nLocalization:');
  final frenchLocale = HoraLocaleFr();
  final frenchDate = date.copyWith(locale: frenchLocale);
  print('French day name: ${frenchDate.format('dddd')}');
  print('French month name: ${frenchDate.format('MMMM')}');

  final spanishLocale = HoraLocaleEs();
  final spanishDate = date.copyWith(locale: spanishLocale);
  print('Spanish day name: ${spanishDate.format('dddd')}');
  print('Spanish month name: ${spanishDate.format('MMMM')}');

  // Predefined formats
  print('\nPredefined formats:');
  print('ISO date: ${date.format('YYYY-MM-DD')}');
  print('ISO time: ${date.format('HH:mm:ss')}');
  print('ISO datetime: ${date.format()}');
  print('Readable date: ${date.format('MMMM Do, YYYY')}');
  print('Readable datetime: ${date.format('MMMM Do, YYYY HH:mm')}');
  print('Time only: ${date.format('HH:mm:ss')}');
  print('Date only: ${date.format('YYYY-MM-DD')}');

  // Custom format patterns
  print('\nCustom patterns:');
  print('With ordinal: ${date.format('Do [of] MMMM YYYY')}');
  print('With timezone: ${date.format('YYYY-MM-DD HH:mm:ss Z')}');
  print('With week number: ${date.format('YYYY-[W]w')}');
  print('Unix timestamp: ${date.format('X')}');
  print('Unix timestamp (ms): ${date.format('x')}');

  // Escape characters in format
  print('\nEscape characters:');
  print('Literal text: ${date.format('[On] MMMM Do [at] HH:mm')}');
  print(
    'Multiple literals: ${date.format('[The date is] YYYY-MM-DD [and time is] HH:mm:ss')}',
  );

  // Format with different locales
  print('\nFormat with different locales:');
  final locales = [
    HoraLocaleEn(),
    HoraLocaleFr(),
    HoraLocaleEs(),
    HoraLocaleDe(),
    HoraLocaleIt(),
    HoraLocalePt(),
  ];

  for (final locale in locales) {
    final localizedDate = date.copyWith(locale: locale);
    print('Locale: ${localizedDate.format('dddd, MMMM Do, YYYY HH:mm')}');
  }
}
