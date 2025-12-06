import 'package:hora/hora.dart';

void main() {
  final base = Hora.of(
    year: 2023,
    month: 12,
    day: 25,
    hour: 14,
    minute: 30,
  );
  print('Base date: $base\n');

  // Adding time units
  print('Adding time units:');
  print('Add 1 day: ${base.add(1, TemporalUnit.day)}');
  print('Add 2 weeks: ${base.add(2, TemporalUnit.week)}');
  print('Add 3 months: ${base.add(3, TemporalUnit.month)}');
  print('Add 1 year: ${base.add(1, TemporalUnit.year)}');
  print('Add 5 hours: ${base.add(5, TemporalUnit.hour)}');
  print('Add 30 minutes: ${base.add(30, TemporalUnit.minute)}');
  print('Add 45 seconds: ${base.add(45, TemporalUnit.second)}');

  // Subtracting time units
  print('\nSubtracting time units:');
  print('Subtract 1 day: ${base.subtract(1, TemporalUnit.day)}');
  print('Subtract 2 weeks: ${base.subtract(2, TemporalUnit.week)}');
  print('Subtract 3 months: ${base.subtract(3, TemporalUnit.month)}');
  print('Subtract 1 year: ${base.subtract(1, TemporalUnit.year)}');

  // Start and end of units
  print('\nStart and end of units:');
  print('Start of day: ${base.startOf(TemporalUnit.day)}');
  print('End of day: ${base.endOf(TemporalUnit.day)}');
  print('Start of week: ${base.startOf(TemporalUnit.week)}');
  print('End of week: ${base.endOf(TemporalUnit.week)}');
  print('Start of month: ${base.startOf(TemporalUnit.month)}');
  print('End of month: ${base.endOf(TemporalUnit.month)}');
  print('Start of year: ${base.startOf(TemporalUnit.year)}');
  print('End of year: ${base.endOf(TemporalUnit.year)}');

  // Difference between dates
  final other = Hora.of(
    year: 2024,
    month: 6,
    day: 15,
    hour: 10,
    minute: 45,
    second: 30,
  );
  // Difference between dates
  print('\nDifference between dates:');
  print('Base: $base');
  print('Other: $other');
  final diff = other.difference(base);
  print('Difference: $diff');
  print('Difference in days: ${diff.inDays}');
  print('Difference in hours: ${diff.inHours}');
  print('Difference in minutes: ${diff.inMinutes}');
  print('Difference in seconds: ${diff.inSeconds}');

  // Copy with
  print('\nCopy with:');
  print('Change year to 2024: ${base.copyWith(year: 2024)}');
  print('Change month to 6: ${base.copyWith(month: 6)}');
  print('Change day to 15: ${base.copyWith(day: 15)}');
  print('Change hour to 10: ${base.copyWith(hour: 10)}');
  print('Change minute to 45: ${base.copyWith(minute: 45)}');

  // Comparison
  final earlier = Hora.of(
    year: 2023,
    month: 12,
    day: 24,
  );
  final later = Hora.of(
    year: 2023,
    month: 12,
    day: 26,
  );
  print('\nComparison:');
  print('Base: $base');
  print('Earlier: $earlier');
  print('Later: $later');
  print('Is before earlier: ${base.isBefore(earlier)}');
  print('Is before later: ${base.isBefore(later)}');
  print('Is after earlier: ${base.isAfter(earlier)}');
  print('Is after later: ${base.isAfter(later)}');
  print('Is same as earlier: ${base.isSame(earlier)}');
  print('Is same day as later: ${base.isSame(later, TemporalUnit.day)}');
  print('Is between: ${base.isBetween(earlier, later)}');
}
