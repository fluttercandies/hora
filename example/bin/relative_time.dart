import 'package:hora/hora.dart';
import 'package:hora/src/locales/de.dart';
import 'package:hora/src/locales/es.dart';
import 'package:hora/src/locales/fr.dart';

void main() {
  final now = Hora.now();
  print('Current time: $now\n');

  // Relative time examples
  print('Relative time examples:');

  // Past times
  final pastTimes = {
    '30 seconds ago': now.subtract(30, TemporalUnit.second),
    '45 seconds ago': now.subtract(45, TemporalUnit.second),
    '2 minutes ago': now.subtract(2, TemporalUnit.minute),
    '30 minutes ago': now.subtract(30, TemporalUnit.minute),
    '1 hour ago': now.subtract(1, TemporalUnit.hour),
    '3 hours ago': now.subtract(3, TemporalUnit.hour),
    '12 hours ago': now.subtract(12, TemporalUnit.hour),
    '1 day ago': now.subtract(1, TemporalUnit.day),
    '3 days ago': now.subtract(3, TemporalUnit.day),
    '1 week ago': now.subtract(1, TemporalUnit.week),
    '3 weeks ago': now.subtract(3, TemporalUnit.week),
    '1 month ago': now.subtract(1, TemporalUnit.month),
    '3 months ago': now.subtract(3, TemporalUnit.month),
    '1 year ago': now.subtract(1, TemporalUnit.year),
    '3 years ago': now.subtract(3, TemporalUnit.year),
  };

  print('Past times (from now):');
  pastTimes.forEach((description, time) {
    print('$description: ${time.fromNow()}');
  });

  print('\nFuture times (from now):');
  // Future times
  final futureTimes = {
    'in 30 seconds': now.add(30, TemporalUnit.second),
    'in 45 seconds': now.add(45, TemporalUnit.second),
    'in 2 minutes': now.add(2, TemporalUnit.minute),
    'in 30 minutes': now.add(30, TemporalUnit.minute),
    'in 1 hour': now.add(1, TemporalUnit.hour),
    'in 3 hours': now.add(3, TemporalUnit.hour),
    'in 12 hours': now.add(12, TemporalUnit.hour),
    'in 1 day': now.add(1, TemporalUnit.day),
    'in 3 days': now.add(3, TemporalUnit.day),
    'in 1 week': now.add(1, TemporalUnit.week),
    'in 3 weeks': now.add(3, TemporalUnit.week),
    'in 1 month': now.add(1, TemporalUnit.month),
    'in 3 months': now.add(3, TemporalUnit.month),
    'in 1 year': now.add(1, TemporalUnit.year),
    'in 3 years': now.add(3, TemporalUnit.year),
  };

  futureTimes.forEach((description, time) => print('$description: ${time.fromNow()}'));

  // Relative to/from other dates
  print('\nRelative to other dates:');
  final base = Hora.of(
    year: 2023,
    month: 12,
    day: 25,
    hour: 14,
    minute: 30,
  );
  final other = Hora.of(
    year: 2024,
    day: 5,
    hour: 10,
    minute: 15,
  );

  print('Base: $base');
  print('Other: $other');

  print('Base from other: ${base.from(other)}');
  print('Base to other: ${base.to(other)}');
  print('Other from base: ${other.from(base)}');
  print('Other to base: ${other.to(base)}');

  // Without suffix
  print('\nWithout suffix:');
  print(
      '3 days ago (without suffix): ${now.subtract(3, TemporalUnit.day).fromNow(withoutSuffix: true)}',);
  print(
      'in 3 days (without suffix): ${now.add(3, TemporalUnit.day).fromNow(withoutSuffix: true)}',);

  // With different locales
  print('\nRelative time with different locales:');
  final locales = [
    HoraLocaleEn(),
    HoraLocaleFr(),
    HoraLocaleEs(),
    HoraLocaleDe(),
  ];

  final pastTime = now.subtract(3, TemporalUnit.day);
  final futureTime = now.add(2, TemporalUnit.week);

  for (final locale in locales) {
    final localizedPast = pastTime.copyWith(locale: locale);
    final localizedFuture = futureTime.copyWith(locale: locale);
    print('Locale:');
    print('  3 days ago: ${localizedPast.fromNow()}');
    print('  in 2 weeks: ${localizedFuture.fromNow()}');
  }

  // Edge cases
  print('\nEdge cases:');
  final sameTime = now;
  print('Same time: ${sameTime.fromNow()}');

  final veryClose = now.subtract(10, TemporalUnit.second);
  print('10 seconds ago: ${veryClose.fromNow()}');

  final veryFarFuture = now.add(5, TemporalUnit.year);
  print('5 years in future: ${veryFarFuture.fromNow()}');

  final veryFarPast = now.subtract(5, TemporalUnit.year);
  print('5 years in past: ${veryFarPast.fromNow()}');
}
