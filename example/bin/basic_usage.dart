import 'package:hora/hora.dart';
import 'package:hora/plugins.dart';

void main() {
  // Current date and time
  final now = Hora.now();
  print('Current time: $now');

  // Create from DateTime
  final fromDateTime = Hora.fromDateTime(DateTime(2023, 12, 25, 14, 30));
  print('From DateTime: $fromDateTime');

  // Create from components
  final fromComponents = Hora.of(
    year: 2023,
    month: 12,
    day: 25,
    hour: 14,
    minute: 30,
  );
  print('From components: $fromComponents');

  // Create from Unix timestamp
  final fromUnix = Hora.unix(1703506200);
  print('From Unix timestamp: $fromUnix');

  // Parse from string
  final parsed = Hora.parse('2023-12-25T14:30:00');
  print('Parsed from string: $parsed');

  // Try parse (returns null if invalid)
  final tryParsed = Hora.tryParse('2023-12-25T14:30:00');
  print('Try parsed: $tryParsed');
  final invalid = Hora.tryParse('invalid-date');
  print('Invalid parse result: $invalid');

  // Get components
  print('\nDate components:');
  print('Year: ${now.year}');
  print('Month: ${now.month}');
  print('Day: ${now.day}');
  print('Hour: ${now.hour}');
  print('Minute: ${now.minute}');
  print('Second: ${now.second}');
  print('Millisecond: ${now.millisecond}');
  print('Microsecond: ${now.microsecond}');

  // Get day of week
  print('\nDay of week: ${now.weekday}'); // 1-7 (Monday-Sunday)

  // Get day of year
  print('Day of year: ${now.dayOfYear}');

  // Get week of year
  print('Week of year: ${now.weekOfYear()}');

  // Check if valid
  print('\nIs valid: ${now.isValid}');

  // Convert to DateTime
  print('To DateTime: ${now.toDateTime()}');

  // Convert to Unix timestamp
  print('Unix timestamp: ${now.unix}');
  print('Unix milliseconds: ${now.unixMillis}');
  print('Unix microseconds: ${now.unixMicros}');
}
