import 'package:hora/hora.dart';
import 'package:hora/plugins.dart';
import 'package:test/test.dart';

void main() {
  group('Complex scenarios (public API)', () {
    test(
        'parsing/object/timezone/precision/week/business-day pipeline stays consistent',
        () {
      final parsed = Hora.fromMap({
        'date': '2024-03-15T12:34:56.789Z',
        'microsecond': 321,
        'utc': true,
      });

      final normalized = parsed.addObject({
        'days': 1,
        'hours': 2,
        'minutes': 30,
      }).subtractObject({'hours': 2}).setObject({
        'second': 0,
        'millisecond': 0,
        'microsecond': 0,
      });

      expect(parsed.isUtc, isTrue);
      expect(parsed.microsecond, 321);
      expect(normalized.isUtc, isTrue);
      expect(normalized.second, 0);
      expect(normalized.millisecond, 0);
      expect(normalized.microsecond, 0);

      final jst = HoraTimezone.fromOffset(9);
      final est = HoraTimezone.fromOffset(-5);
      final jstView = normalized.inTimezone(jst);
      final estView = jstView.withTimezone(est);

      expect(jstView.unixMicros, normalized.toUtc().unixMicros);
      expect(estView.unixMicros, jstView.unixMicros);

      final reinterpretedUtc = jstView.reinterpretAs(HoraTimezone.utc);
      expect(
        reinterpretedUtc.unixMicros,
        normalized.toUtc().unixMicros + jst.offset.inMicroseconds,
      );

      final aligned = jstView.wallClock.alignTo(15, TimePrecision.minute);
      expect(aligned.minute % 15, 0);
      expect(aligned.second, 0);
      expect(aligned.millisecond, 0);
      expect(aligned.microsecond, 0);

      final usWeek = aligned.daysOfWeekWith(config: WeekConfig.us);
      expect(usWeek.length, 7);
      expect(usWeek.first.weekday, DateTime.sunday);
      expect(
        aligned.isWithin(usWeek.first, usWeek.last.endOf(TemporalUnit.day)),
        isTrue,
      );

      final holidays = HolidayCalendar(
        fixedHolidays: [DateTime(aligned.year, aligned.month, aligned.day)],
      );
      final bizConfig = BusinessDayConfig(holidays: holidays);

      expect(aligned.isHoliday(holidays), isTrue);
      expect(aligned.isBusinessDay(bizConfig), isFalse);

      final nextBiz = aligned.nextBusinessDay(bizConfig);
      expect(nextBiz.isBusinessDay(bizConfig), isTrue);

      final calendarText = aligned.calendar(
        referenceDate: aligned,
        config: const CalendarConfig(sameDay: '[same] LT'),
      );
      expect(calendarText, startsWith('same '));
    });

    test(
        'recurrence with business-day filters keeps ordering and range invariants',
        () {
      final start = Hora.of(year: 2024, month: 4); // Monday
      final recurrence = start.daily(
        count: 20,
        excludeWeekdays: {DateTime.saturday, DateTime.sunday},
      );
      final occurrences = recurrence.toList();

      expect(occurrences.length, 20);
      for (var i = 1; i < occurrences.length; i++) {
        expect(
          occurrences[i].isAfter(occurrences[i - 1]),
          isTrue,
          reason: 'index=$i must be strictly increasing',
        );
      }

      for (final occurrence in occurrences) {
        expect(
          occurrence.weekday,
          inInclusiveRange(DateTime.monday, DateTime.friday),
        );
        expect(recurrence.matches(occurrence), isTrue);
      }

      final holidays = HolidayCalendar(
        fixedHolidays: [
          DateTime(2024, 4, 5),
          DateTime(2024, 4, 12),
        ],
      );
      final config = BusinessDayConfig(holidays: holidays);
      final businessOnly =
          occurrences.where((h) => h.isBusinessDay(config)).toList();

      expect(businessOnly.length, 18);
      expect(businessOnly.every((h) => !h.isHoliday(holidays)), isTrue);

      final minMax = businessOnly.minMaxHora;
      expect(minMax.min.isAfter(minMax.max), isFalse);

      final within = businessOnly.withinRange(minMax.min, minMax.max).toList();
      expect(within.length, businessOnly.length);

      final groupedByMonth = businessOnly.groupByMonth();
      expect(groupedByMonth.keys, equals(<String>['2024-04']));

      final slice = recurrence.between(
        Hora.of(year: 2024, month: 4, day: 8),
        Hora.of(year: 2024, month: 4, day: 12),
      );
      expect(slice.length, 5);
      expect(slice.first.day, 8);
      expect(slice.last.day, 12);

      final saturday = Hora.of(year: 2024, month: 4, day: 13);
      final nextBiz =
          saturday.nextMatching((h) => h.isBusinessDay(config), maxDays: 10);
      final prevBiz = saturday.previousMatching(
        (h) => h.isBusinessDay(config),
        maxDays: 10,
      );

      expect(nextBiz?.day, 15);
      expect(prevBiz?.day, 11);
    });

    test(
        'fiscal-year, week and precision rules remain consistent around leap-sensitive boundaries',
        () {
      const fyConfig = FiscalYearConfig(
        startMonth: 2,
        startDay: 29,
        yearOffset: 1,
      );

      final samples = [
        Hora.of(
          year: 2023,
          month: 2,
          day: 28,
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
          utc: true,
        ),
        Hora.of(
          year: 2023,
          month: 3,
          hour: 12,
          minute: 1,
          second: 1,
          utc: true,
        ),
        Hora.of(
          year: 2024,
          month: 2,
          day: 29,
          hour: 8,
          minute: 30,
          utc: true,
        ),
        Hora.of(
          year: 2024,
          month: 3,
          utc: true,
        ),
      ];

      for (final sample in samples) {
        final fiscalStart = sample.startOfFiscalYearWithConfig(fyConfig);
        final fiscalEnd = sample.endOfFiscalYearWithConfig(fyConfig);

        expect(sample.isBefore(fiscalStart), isFalse);
        expect(sample.isAfter(fiscalEnd), isFalse);

        final period = sample.fiscalPeriod(config: fyConfig);
        expect(period.quarter, inInclusiveRange(1, 4));
        expect(period.periodInQuarter, inInclusiveRange(1, 3));

        final dayPrecision = sample.withPrecision(TimePrecision.day);
        expect(dayPrecision.hour, 0);
        expect(dayPrecision.minute, 0);
        expect(dayPrecision.second, 0);

        final weekStart = sample.startOfWeek();
        final weekEnd = sample.endOfWeek();
        expect(sample.isBefore(weekStart), isFalse);
        expect(sample.isAfter(weekEnd), isFalse);
      }

      final beforeBoundary = Hora.of(year: 2023, month: 2, day: 27, utc: true);
      final atBoundary = Hora.of(year: 2023, month: 2, day: 28, utc: true);

      expect(beforeBoundary.fiscalYearWithConfig(fyConfig), 2023);
      expect(atBoundary.fiscalYearWithConfig(fyConfig), 2024);
    });

    test(
        'updated locale drives localized format, calendar text and relative-time output',
        () {
      final customLocale = const HoraLocaleEn()
          .update(
            code: 'en-x-integration',
            months: List<String>.generate(12, (i) => 'M${i + 1}'),
            weekStart: DateTime.monday,
            yearStart: 4,
          )
          .updateFormats(
            l: 'YYYY.MM.DD',
            ll: 'MMMM D, YYYY',
            lll: 'MMMM D, YYYY HH:mm',
            llll: 'dddd, MMMM D, YYYY HH:mm',
            lt: 'HH:mm',
            lts: 'HH:mm:ss',
          )
          .updateRelativeTime(
            future: 'after %s',
            past: 'before %s',
            h: '1 hr',
            hh: '%d hr',
          );

      final h = Hora.of(
        year: 2024,
        month: 6,
        day: 15,
        hour: 9,
        minute: 5,
        locale: customLocale,
      );

      expect(h.localizedFormat('L'), '2024.06.15');
      expect(h.localizedFormat('LL'), 'M6 15, 2024');

      final calendarText = h.calendar(
        referenceDate: h,
        config: const CalendarConfig(sameDay: '[Today] LTS'),
      );
      expect(calendarText, 'Today 09:05:00');

      expect(h.localeData.monthName(6), 'M6');
      expect(
        h.weekOfYear(config: WeekConfig.fromLocale(customLocale)),
        h.isoWeek,
      );

      expect(h.advancedFormat('Qo'), '2nd');
      expect(h.formatBuddhistEra('BBBB-MM-DD'), '2567-06-15');

      final plusTwoHours = h.add(2, TemporalUnit.hour);
      expect(plusTwoHours.relativeFrom(h), 'after 2 hr');
      expect(h.relativeFrom(plusTwoHours), 'before 2 hr');
    });

    test('timezone ranges keep containment and duration across projections',
        () {
      final jst = HoraTimezone.fromOffset(9);
      final edt = HoraTimezone.fromOffset(-4);

      final startUtc = Hora.of(year: 2024, month: 5, utc: true);
      final endUtc = Hora.of(year: 2024, month: 5, hour: 8, utc: true);

      final jstRange = TimezoneRange(
        start: startUtc.inTimezone(jst),
        end: endUtc.inTimezone(jst),
        timezone: jst,
      );

      final inside =
          Hora.of(year: 2024, month: 5, hour: 3, minute: 30, utc: true);
      final outside =
          Hora.of(year: 2024, month: 5, hour: 8, minute: 1, utc: true);

      expect(jstRange.contains(inside), isTrue);
      expect(jstRange.contains(outside), isFalse);
      expect(jstRange.duration.inHours, 8);

      final edtRange = jstRange.inTimezone(edt);
      expect(edtRange.contains(inside), isTrue);
      expect(edtRange.contains(outside), isFalse);
      expect(edtRange.duration, jstRange.duration);

      expect(
        () => TimezoneRange(
          start: startUtc.inTimezone(jst),
          end: endUtc.inTimezone(edt),
          timezone: jst,
        ),
        throwsArgumentError,
      );
    });

    test('custom parse with duration operations round-trips on fixed units',
        () {
      final parsed = horaParseFormat(
        '2024-12-31 23:30 +05:30',
        'YYYY-MM-DD HH:mm Z',
      );

      expect(parsed.isUtc, isTrue);
      expect(parsed.year, 2024);
      expect(parsed.month, 12);
      expect(parsed.day, 31);
      expect(parsed.hour, 18);
      expect(parsed.minute, 0);

      expect(
        horaTryParseFormat('31/12/2024', 'YYYY-MM-DD', strict: true),
        isNull,
      );

      final delta = HoraDurationFactory.fromMinutes(90.5);
      final shifted = parsed.addHoraDuration(delta);
      final roundTrip = shifted.subtractHoraDuration(delta);

      expect(roundTrip.unixMicros, parsed.unixMicros);
      expect(delta.totalMinutes, closeTo(90.5, 1e-9));
      expect(delta.toDartDuration().inSeconds, 5430);
      expect(delta.format('HH:mm:ss'), '01:30:30');
      expect(
        HoraDurationExtUtils(delta).humanize(precise: true),
        contains('hour'),
      );

      final steps = parsed.every(30, TimePrecision.minute, count: 4).toList();
      expect(steps.length, 4);
      expect(steps.last.diff(steps.first, TemporalUnit.minute), 90);
    });

    test('buddhist-era and multi-era conversions remain coherent', () {
      final leapBe = horaBuddhistEra(year: 2567, month: 2, day: 29, utc: true);

      expect(leapBe.year, 2024);
      expect(leapBe.yearIn(CalendarEra.buddhist), 2567);
      expect(leapBe.yearIn(CalendarEra.minguo), 113);
      expect(leapBe.formatBuddhistEra('BB'), '67');

      final beNext = leapBe.withBuddhistYear(2568);
      expect(beNext.year, 2025);

      final reiwaStart = Hora.of(year: 2019, month: 5);
      expect(reiwaStart.yearIn(CalendarEra.japanese), 1);
      expect(reiwaStart.japaneseEraName.isNotEmpty, isTrue);
    });
  });
}
