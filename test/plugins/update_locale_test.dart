import 'package:hora/hora.dart';
import 'package:hora/src/plugins/update_locale.dart';
import 'package:test/test.dart';

void main() {
  group('UpdateLocale', () {
    group('UpdatedLocale', () {
      test('uses base locale values by default', () {
        final base = const HoraLocaleEn();
        final updated = UpdatedLocale(base);

        expect(updated.code, equals(base.code));
        expect(updated.months, equals(base.months));
        expect(updated.weekdays, equals(base.weekdays));
        expect(updated.weekStart, equals(base.weekStart));
      });

      test('overrides specified values', () {
        final base = const HoraLocaleEn();
        final updated = UpdatedLocale(
          base,
          code: 'custom',
          weekStart: DateTime.monday,
        );

        expect(updated.code, equals('custom'));
        expect(updated.weekStart, equals(DateTime.monday));
        expect(updated.months, equals(base.months)); // Not overridden
      });

      test('overrides months', () {
        final base = const HoraLocaleEn();
        final customMonths = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
        ];
        final updated = UpdatedLocale(base, months: customMonths);

        expect(updated.months, equals(customMonths));
      });

      test('overrides meridiem function', () {
        final base = const HoraLocaleEn();
        final updated = UpdatedLocale(
          base,
          meridiem: (hour, minute, {lowercase = false}) =>
              hour < 12 ? 'before noon' : 'after noon',
        );

        expect(updated.meridiem(10, 0), equals('before noon'));
        expect(updated.meridiem(14, 0), equals('after noon'));
      });
    });

    group('UpdateLocaleExtension', () {
      test('update creates UpdatedLocale', () {
        final base = const HoraLocaleEn();
        final updated = base.update(weekStart: DateTime.monday);

        expect(updated, isA<UpdatedLocale>());
        expect(updated.weekStart, equals(DateTime.monday));
      });

      test('multiple updates chain correctly', () {
        final base = const HoraLocaleEn();
        final updated = base
            .update(weekStart: DateTime.monday)
            .update(code: 'en-custom');

        expect(updated.weekStart, equals(DateTime.monday));
        expect(updated.code, equals('en-custom'));
      });
    });

    group('updateRelativeTime', () {
      test('creates locale with updated relative time', () {
        final base = const HoraLocaleEn();
        final updated = base.updateRelativeTime(
          s: 'moments ago',
          m: 'a minute ago',
        );

        expect(updated.relativeTime.s, equals('moments ago'));
        expect(updated.relativeTime.m, equals('a minute ago'));
      });

      test('preserves non-overridden relative time values', () {
        final base = const HoraLocaleEn();
        final updated = base.updateRelativeTime(s: 'custom seconds');

        expect(updated.relativeTime.s, equals('custom seconds'));
        expect(updated.relativeTime.future, equals(base.relativeTime.future));
        expect(updated.relativeTime.past, equals(base.relativeTime.past));
      });
    });

    group('updateFormats', () {
      test('creates locale with updated formats', () {
        final base = const HoraLocaleEn();
        final updated = base.updateFormats(
          lt: 'HH:mm',
          ll: 'YYYY-MM-DD',
        );

        expect(updated.formats.lt, equals('HH:mm'));
        expect(updated.formats.ll, equals('YYYY-MM-DD'));
      });

      test('preserves non-overridden format values', () {
        final base = const HoraLocaleEn();
        final updated = base.updateFormats(lt: 'custom time');

        expect(updated.formats.lt, equals('custom time'));
        expect(updated.formats.lts, equals(base.formats.lts));
      });
    });

    group('Integration', () {
      test('updated locale works with Hora', () {
        final customLocale = const HoraLocaleEn().update(
          months: [
            'Month1', 'Month2', 'Month3', 'Month4', 'Month5', 'Month6',
            'Month7', 'Month8', 'Month9', 'Month10', 'Month11', 'Month12',
          ],
        );

        final h = Hora.of(year: 2023, day: 15, locale: customLocale);
        expect(h.format('MMMM'), equals('Month1'));
      });

      test('updated locale with custom weekStart affects startOfWeek', () {
        final sundayStart = const HoraLocaleEn().update(
          weekStart: DateTime.sunday,
        );
        final mondayStart = const HoraLocaleEn().update(
          weekStart: DateTime.monday,
        );

        // Wednesday, June 15, 2023
        final h = Hora.of(year: 2023, month: 6, day: 15);

        final hSunday = h.withLocale(sundayStart).startOf(TemporalUnit.week);
        final hMonday = h.withLocale(mondayStart).startOf(TemporalUnit.week);

        // Sunday start should give June 11 (Sunday)
        expect(hSunday.weekday, equals(DateTime.sunday));

        // Monday start should give June 12 (Monday)
        expect(hMonday.weekday, equals(DateTime.monday));
      });
    });
  });
}
