import 'package:hora/hora.dart';

void main() {
  // Creating durations
  print('Creating durations:');
  final days = HoraDuration.ofDays(5);
  print('5 days: $days');

  final weeks = HoraDuration.ofWeeks(2);
  print('2 weeks: $weeks');

  final months = HoraDuration.ofMonths(3);
  print('3 months: $months');

  final hours = HoraDuration.ofHours(10);
  print('10 hours: $hours');

  final minutes = HoraDuration.ofMinutes(30);
  print('30 minutes: $minutes');

  final seconds = HoraDuration.ofSeconds(45);
  print('45 seconds: $seconds');

  final millis = HoraDuration.ofMilliseconds(5000);
  print('5000 milliseconds: $millis');

  // Parse durations
  print('\nParsing durations:');
  final parsed = HoraDuration.parse('P5DT3H30M');
  print('P5DT3H30M: $parsed');

  final tryParse = HoraDuration.tryParse('PT1H30M');
  print('PT1H30M: $tryParse');

  final invalid = HoraDuration.tryParse('invalid');
  print('Invalid duration: $invalid');

  // Duration operations
  print('\nDuration operations:');
  final baseDuration = HoraDuration.ofDays(10);
  print('Base: $baseDuration');

  print('Add 2 days: ${baseDuration + HoraDuration.ofDays(2)}');
  print('Subtract 3 hours: ${baseDuration - HoraDuration.ofHours(3)}');

  // Duration components
  print('\nDuration components:');
  final complex = HoraDuration.ofDays(365);
  print('365 days: $complex');

  print('In days: ${complex.inDays}');
  print('In hours: ${complex.inHours}');
  print('In minutes: ${complex.inMinutes}');
  print('In seconds: ${complex.inSeconds}');
  print('In milliseconds: ${complex.inMilliseconds}');

  // Duration comparison
  print('\nDuration comparison:');
  final short = HoraDuration.ofDays(5);
  final long = HoraDuration.ofDays(10);

  print('5 days: $short');
  print('10 days: $long');
  print('Is longer than: ${short.inDays < long.inDays}');
  print('Is shorter than: ${short.inDays < long.inDays}');

  // Absolute duration
  print('\nAbsolute duration:');
  final negative = HoraDuration.ofDays(-5);
  print('Negative 5 days: $negative');
  print('Absolute: ${negative.abs()}');

  // Duration to DateTime
  print('\nDuration to DateTime:');
  final date = Hora.now();
  final future = date.add(5, TemporalUnit.day);
  print('Now: $date');
  print('Future: $future');
  print('Duration between: ${date.difference(future)}');

  // From regular Duration
  print('\nFrom regular Duration:');
  final dartDuration = Duration(days: 5, hours: 3);
  final horaDuration = HoraDuration.fromDuration(dartDuration);
  print('Dart Duration: $dartDuration');
  print('Hora Duration: $horaDuration}');

  // Format duration
  print('\nFormat duration:');
  final format = HoraDuration(
    days: 5,
    hours: 3,
    minutes: 30,
  );
  print('5d 3h 30m: $format');
}
