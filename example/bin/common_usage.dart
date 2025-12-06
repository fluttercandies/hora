import 'package:hora/hora.dart';
import 'package:hora/plugins.dart';

void main() {
  // Current date and time
  final now = Hora.now();
  print('Current time: $now');

  // Creating dates
  print('\nCreating dates:');
  final christmas = Hora.of(year: 2023, month: 12, day: 25);
  print('Christmas: $christmas');

  final newYear = Hora.of(year: 2024);
  print('New Year: $newYear');

  // Date parsing
  print('\nDate parsing:');
  final parsed = Hora.parse('2023-12-25T14:30:00');
  print('Parsed: $parsed');

  final tryParsed = Hora.tryParse('invalid-date');
  print('Try parsed: $tryParsed');

  // Date components
  print('\nDate components:');
  print('Year: ${now.year}');
  print('Month: ${now.month}');
  print('Day: ${now.day}');
  print('Hour: ${now.hour}');
  print('Minute: ${now.minute}');
  print('Second: ${now.second}');
  print('Weekday: ${now.weekday}');
  print('Day of year: ${now.dayOfYear}');
  print('Week of year: ${now.weekOfYear()}');

  // Date manipulation
  print('\nDate manipulation:');
  print('Tomorrow: ${now.add(1, TemporalUnit.day)}');
  print('Next week: ${now.add(1, TemporalUnit.week)}');
  print('Next month: ${now.add(1, TemporalUnit.month)}');
  print('Next year: ${now.add(1, TemporalUnit.year)}');

  print('Yesterday: ${now.subtract(1, TemporalUnit.day)}');
  print('Last week: ${now.subtract(1, TemporalUnit.week)}');
  print('Last month: ${now.subtract(1, TemporalUnit.month)}');
  print('Last year: ${now.subtract(1, TemporalUnit.year)}');

  // Start and end of time units
  print('\nStart and end of time units:');
  print('Start of day: ${now.startOf(TemporalUnit.day)}');
  print('End of day: ${now.endOf(TemporalUnit.day)}');
  print('Start of week: ${now.startOf(TemporalUnit.week)}');
  print('End of week: ${now.endOf(TemporalUnit.week)}');
  print('Start of month: ${now.startOf(TemporalUnit.month)}');
  print('End of month: ${now.endOf(TemporalUnit.month)}');
  print('Start of year: ${now.startOf(TemporalUnit.year)}');
  print('End of year: ${now.endOf(TemporalUnit.year)}');

  // Copy with
  print('\nCopy with:');
  print('Change year: ${now.copyWith(year: 2024)}');
  print('Change month: ${now.copyWith(month: 6)}');
  print('Change day: ${now.copyWith(day: 15)}');
  print('Change hour: ${now.copyWith(hour: 10)}');
  print('Change minute: ${now.copyWith(minute: 45)}');

  // Comparison
  print('\nComparison:');
  final past = now.subtract(5, TemporalUnit.day);
  final future = now.add(5, TemporalUnit.day);

  print('Now: $now');
  print('Past: $past');
  print('Future: $future');

  print('Is before past: ${now.isBefore(past)}');
  print('Is after past: ${now.isAfter(past)}');
  print('Is same as past: ${now.isSame(past)}');

  print('Is before future: ${now.isBefore(future)}');
  print('Is after future: ${now.isAfter(future)}');
  print('Is same day as future: ${now.isSame(future, TemporalUnit.day)}');
  print('Is between past and future: ${now.isBetween(past, future)}');

  // Relative time
  print('\nRelative time:');
  print('1 hour ago: ${past.fromNow()}');
  print('In 5 days: ${future.fromNow()}');
  print('Without suffix: ${past.fromNow(withoutSuffix: true)}');

  // Formatting
  print('\nFormatting:');
  print('ISO: ${now.format()}');
  print('YYYY-MM-DD: ${now.format('YYYY-MM-DD')}');
  print('MM/DD/YYYY: ${now.format('MM/DD/YYYY')}');
  print('Readable: ${now.format('MMMM Do, YYYY')}');
  print('With time: ${now.format('MMMM Do, YYYY HH:mm')}');

  // Calendar formatting
  print('\nCalendar formatting:');
  print('Today: ${now.calendar()}');
  print('5 days ago: ${past.calendar()}');
  print('In 5 days: ${future.calendar()}');

  // Unix timestamps
  print('\nUnix timestamps:');
  print('Unix (seconds): ${now.unix}');
  print('Unix (milliseconds): ${now.unixMillis}');
  print('Unix (microseconds): ${now.unixMicros}');

  // Convert to DateTime
  print('\nConvert to DateTime:');
  final dateTime = now.toDateTime();
  print('To DateTime: $dateTime');

  // Extensions
  print('\nExtensions:');
  final timestamp = 1703506200;
  print('Unix timestamp: ${timestamp.asUnixSeconds}');

  final duration = 5;
  print('5 days: ${duration.days}');
  print('2 hours: ${2.hours}');

  final dateStr = '2023-12-25';
  print('String to Hora: ${dateStr.toHora()}');

  final dartDuration = Duration(days: 5, hours: 3);
  print('Duration to HoraDuration: ${dartDuration.toHoraDuration()}');

  // Date range
  print('\nDate range:');
  final start = now;
  final end = now.add(10, TemporalUnit.day);

  print('From $start to $end:');
  for (final date in start.rangeTo(end)) {
    print('  $date');
  }

  // Business day calculations
  print('\nBusiness day calculations:');
  print('Is weekend: ${now.isWeekend}');
  print('Is weekday: ${now.isWeekday}');
}
