// Calendar formatting example for Hora.
//
// This example demonstrates calendar-style date formatting.

import 'package:hora/hora.dart';
import 'package:hora/src/locales/de.dart';
import 'package:hora/src/locales/es.dart';
import 'package:hora/src/locales/fr.dart';
import 'package:hora/src/plugins/calendar.dart';

void main() {
  final now = Hora.now();
  print('Current time: $now');

  // Basic calendar formatting
  print('\n=== Basic Calendar Formatting ===');
  print('Today: ${now.calendar()}');

  // Different times relative to now
  print('\n=== Different Times Relative to Now ===');

  // Today
  final today = now.copyWith(hour: 14, minute: 30);
  print('Today at 2:30 PM: ${today.calendar()}');

  // Yesterday
  final yesterday =
      now.subtract(1, TemporalUnit.day).copyWith(hour: 9, minute: 15);
  print('Yesterday at 9:15 AM: ${yesterday.calendar()}');

  // Tomorrow
  final tomorrow = now.add(1, TemporalUnit.day).copyWith(hour: 18, minute: 45);
  print('Tomorrow at 6:45 PM: ${tomorrow.calendar()}');

  // This week
  final thisWeek = now.add(3, TemporalUnit.day).copyWith(hour: 11, minute: 0);
  print('3 days from now: ${thisWeek.calendar()}');

  // Last week
  final lastWeek =
      now.subtract(5, TemporalUnit.day).copyWith(hour: 16, minute: 20);
  print('5 days ago: ${lastWeek.calendar()}');

  // Further in past/future
  final furtherPast =
      now.subtract(20, TemporalUnit.day).copyWith(hour: 12, minute: 0);
  print('20 days ago: ${furtherPast.calendar()}');

  final furtherFuture =
      now.add(20, TemporalUnit.day).copyWith(hour: 15, minute: 30);
  print('20 days from now: ${furtherFuture.calendar()}');

  // Custom calendar config
  print('\n=== Custom Calendar Config ===');
  const customConfig = CalendarConfig(
    sameDay: 'Today h:mm A',
    nextDay: 'Tomorrow h:mm A',
    nextWeek: 'dddd at h:mm A',
    lastDay: 'Yesterday h:mm A',
    lastWeek: 'Last dddd at h:mm A',
    sameElse: 'MM/DD/YYYY',
  );

  print('With custom config:');
  print('Today: ${today.calendar(config: customConfig)}');
  print('Yesterday: ${yesterday.calendar(config: customConfig)}');
  print('Tomorrow: ${tomorrow.calendar(config: customConfig)}');
  print('Last week: ${lastWeek.calendar(config: customConfig)}');
  print('Further past: ${furtherPast.calendar(config: customConfig)}');

  // With different reference date
  print('\n=== With Different Reference Date ===');
  final reference = Hora.of(year: 2024, month: 12, day: 25);
  final dates = [
    Hora.of(year: 2024, month: 12, day: 24),
    Hora.of(year: 2024, month: 12, day: 25),
    Hora.of(year: 2024, month: 12, day: 26),
    Hora.of(year: 2024, month: 12, day: 20),
    Hora.of(year: 2024, month: 12, day: 31),
    Hora.of(year: 2025, day: 15),
  ];

  for (final date in dates) {
    print(
      '$date relative to Christmas: '
      '${date.calendar(referenceDate: reference)}',
    );
  }

  // Calendar formatting with locales
  print('\n=== Calendar with Different Locales ===');
  final testDate = now.subtract(2, TemporalUnit.day);

  final locales = [
    (const HoraLocaleEn(), 'English'),
    (const HoraLocaleFr(), 'French'),
    (const HoraLocaleEs(), 'Spanish'),
    (const HoraLocaleDe(), 'German'),
  ];

  for (final (locale, name) in locales) {
    final localizedDate = testDate.withLocale(locale);
    print('$name: ${localizedDate.calendar()}');
  }

  // Month calendar generation
  print('\n=== Month Calendar ===');
  final monthCal = now.monthCalendar();
  print('${monthCal.year}-${monthCal.month} has ${monthCal.weekCount} weeks:');
  print('Sun Mon Tue Wed Thu Fri Sat');
  for (final week in monthCal.weeks) {
    final days = week.map((d) => d?.day.toString().padLeft(3) ?? '   ').join();
    print(days);
  }

  // Year calendar
  print('\n=== Year Calendar ===');
  final yearCal = now.yearCalendar();
  print('${yearCal.year} has 12 months:');
  for (var m = 1; m <= 12; m++) {
    final month = yearCal.month(m);
    print('  Month $m: ${month.days.length} days, ${month.weekCount} weeks');
  }

  // Calendar iteration
  print('\n=== Calendar Iteration ===');

  // Days of month
  print('Days in current month: ${now.daysOfMonth.length}');

  // Days until a future date
  final futureDate = now.add(5, TemporalUnit.day);
  print('Days until ${futureDate.format("YYYY-MM-DD")}:');
  for (final day in now.daysUntil(futureDate)) {
    print('  ${day.format("YYYY-MM-DD dddd")}');
  }

  // Months in year
  print('Months in ${now.year}:');
  for (final month in now.monthsInYear) {
    print('  ${month.format("MMMM")}');
  }

  // Weekday occurrences
  print('\n=== Weekday Occurrences ===');
  print('Sundays in this month:');
  for (final sunday in now.sundaysInMonth) {
    print('  ${sunday.format("YYYY-MM-DD")}');
  }

  // First/last weekday
  print(
    'First Monday: ${now.firstWeekdayInMonth(DateTime.monday).format("YYYY-MM-DD")}',
  );
  print(
    'Last Friday: ${now.lastWeekdayInMonth(DateTime.friday).format("YYYY-MM-DD")}',
  );

  // Nth weekday
  final secondTuesday = now.nthWeekdayInMonth(DateTime.tuesday, 2);
  if (secondTuesday != null) {
    print('2nd Tuesday: ${secondTuesday.format("YYYY-MM-DD")}');
  }

  final lastWednesday = now.nthWeekdayInMonth(DateTime.wednesday, -1);
  if (lastWednesday != null) {
    print('Last Wednesday: ${lastWednesday.format("YYYY-MM-DD")}');
  }
}
