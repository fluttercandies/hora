import 'package:hora/hora.dart';

void main() {
  // DateTime extensions
  print('DateTime extensions:');
  final dateTime = DateTime(2023, 12, 25, 14, 30);
  final hora = dateTime.toHora();
  print('DateTime: $dateTime');
  print('To Hora: $hora');

  // Int extensions for timestamps
  print('\nInt extensions for timestamps:');
  final timestamp = 1703506200;
  print('Unix timestamp: $timestamp');
  print('As Unix seconds: ${timestamp.asUnixSeconds}');

  final millis = 1703506200000;
  print('Unix millis: $millis');
  print('As Unix millis: ${millis.asUnixMillis}');

  // Int extensions for durations
  print('\nInt extensions for durations:');
  print('5 days: ${5.days}');
  print('2 weeks: ${2.weeks}');
  print('3 months: ${3.months}');
  print('1 year: ${1.years}');
  print('10 hours: ${10.hours}');
  print('30 minutes: ${30.minutes}');
  print('45 seconds: ${45.seconds}');

  // String extensions for parsing
  print('\nString extensions for parsing:');
  final dateStr = '2023-12-25T14:30:00';
  print('String: $dateStr');
  print('To Hora: ${dateStr.toHora()}');

  final invalidStr = 'invalid-date';
  print('Invalid string: $invalidStr');
  print('Try to Hora: ${invalidStr.tryToHora()}');

  // Duration extensions
  print('\nDuration extensions:');
  final duration = Duration(days: 5, hours: 3, minutes: 30);
  print('Duration: $duration');
  print('To HoraDuration: ${duration.toHoraDuration()}');

  // Relative time extensions
  print('\nRelative time extensions:');
  final now = Hora.now();
  final past = now.subtract(3, TemporalUnit.day);
  final future = now.add(2, TemporalUnit.week);

  print('Now: $now');
  print('Past (3 days ago): $past');
  print('Future (2 weeks): $future');

  print('Past from now: ${past.fromNow()}');
  print('Past to now: ${past.toNow()}');
  print('Future from now: ${future.fromNow()}');
  print('Future to now: ${future.toNow()}');

  print('Without suffix: ${past.fromNow(withoutSuffix: true)}');

  // Min/Max extensions
  print('\nMin/Max extensions:');
  final dates = [
    Hora.of(year: 2023, month: 12, day: 20),
    Hora.of(year: 2023, month: 12, day: 25),
    Hora.of(year: 2023, month: 12, day: 15),
    Hora.of(year: 2024, day: 5),
  ];

  print('Dates: $dates');
  print('Earliest: ${dates.earliest}');
  print('Latest: ${dates.latest}');
  print('Range: ${dates.range}');

  // Range extensions
  print('\nRange extensions:');
  final start = Hora.of(year: 2023, month: 12, day: 25);
  final end = Hora.of(year: 2023, month: 12, day: 30);

  print('From $start to $end:');
  for (final date in start.rangeTo(end)) {
    print('  $date');
  }

  print('\nFirst 5 days from $start:');
  for (final date in start.take(5)) {
    print('  $date');
  }

  print('\nEvery 2 days from $start:');
  for (final date in start.rangeTo(end, step: 2)) {
    print('  $date');
  }

  // Builder extensions
  print('\nBuilder extensions:');
  final base = Hora.of(
    year: 2023,
    month: 6,
    day: 15,
    hour: 10,
    minute: 30,
  );
  print('Base: $base');

  print('Set year: ${base.copyWith(year: 2024)}');
  print('Set month: ${base.copyWith(month: 12)}');
  print('Set day: ${base.copyWith(day: 25)}');
  print('Set hour: ${base.copyWith(hour: 14)}');
  print('Set minute: ${base.copyWith(minute: 45)}');

  print('Next year: ${base.nextYear}');
  print('Previous year: ${base.previousYear}');
  print('Next month: ${base.nextMonth}');
  print('Previous month: ${base.previousMonth}');
  print('Next week: ${base.nextWeek}');
  print('Previous week: ${base.previousWeek}');
  print('Next day: ${base.nextDay}');
  print('Previous day: ${base.previousDay}');

  print('First day of year: ${base.firstDayOfYear}');
  print('Last day of year: ${base.lastDayOfYear}');
  print('First day of month: ${base.firstDayOfMonth}');
  print('Last day of month: ${base.lastDayOfMonth}');
  print('First day of week: ${base.firstDayOfWeek}');
  print('Last day of week: ${base.lastDayOfWeek}');
}
