import 'package:hora/hora.dart';
import 'package:hora/plugins.dart';
import 'package:test/test.dart';

void main() {
  group('Timestamp parsing', () {
    test('fromTimestamp explicit units preserve exact unix values', () {
      final secUtc = Hora.fromTimestamp(
        -1,
        unit: UnixTimestampUnit.seconds,
        utc: true,
      );
      expect(secUtc.isUtc, isTrue);
      expect(secUtc.unix, -1);
      expect(secUtc.unixMillis, -1000);
      expect(secUtc.unixMicros, -1000000);

      final msUtc = Hora.fromTimestamp(
        1234567890,
        unit: UnixTimestampUnit.milliseconds,
        utc: true,
      );
      expect(msUtc.isUtc, isTrue);
      expect(msUtc.unixMillis, 1234567890);

      final usUtc = Hora.fromTimestamp(
        1234567890123,
        unit: UnixTimestampUnit.microseconds,
        utc: true,
      );
      expect(usUtc.isUtc, isTrue);
      expect(usUtc.unixMicros, 1234567890123);
    });

    test('from() timestampUnit overrides auto detection', () {
      const value = 1703462400;

      final auto = Hora.from(value).toUtc();
      final asMillis = Hora.from(
        value,
        timestampUnit: UnixTimestampUnit.milliseconds,
      ).toUtc();

      expect(auto.year, 2023);
      expect(auto.month, 12);
      expect(auto.day, 25);

      expect(asMillis.year, 1970);
      expect(asMillis.month, 1);
      expect(asMillis.day, 20);
      expect(asMillis.unixMillis, value);
    });

    test('fromMap timestamp uses provided timestampUnit for generic timestamp',
        () {
      final sec = Hora.fromMap(
        {'timestamp': 1703462400},
        timestampUnit: UnixTimestampUnit.seconds,
      ).toUtc();
      final ms = Hora.fromMap(
        {'timestamp': 1703462400000},
        timestampUnit: UnixTimestampUnit.milliseconds,
      ).toUtc();
      final us = Hora.fromMap(
        {'timestamp': 1703462400000000},
        timestampUnit: UnixTimestampUnit.microseconds,
      ).toUtc();

      expect(sec.unix, 1703462400);
      expect(ms.unix, 1703462400);
      expect(us.unix, 1703462400);
    });

    test('auto timestamp unit detection honors digit thresholds and sign', () {
      final secEdge = Hora.fromTimestamp(99999999999);
      final msEdge = Hora.fromTimestamp(100000000000);
      final msUpper = Hora.fromTimestamp(99999999999999);
      final usEdge = Hora.fromTimestamp(100000000000000);
      final negUsEdge = Hora.fromTimestamp(-100000000000000);

      expect(secEdge.unix, 99999999999);
      expect(msEdge.unixMillis, 100000000000);
      expect(msUpper.unixMillis, 99999999999999);
      expect(usEdge.unixMicros, 100000000000000);
      expect(negUsEdge.unixMicros, -100000000000000);
    });

    test('fromMap accepts string timestamp with explicit unit', () {
      final h = Hora.fromMap(
        {'timestamp': '1703462400000'},
        timestampUnit: UnixTimestampUnit.milliseconds,
      ).toUtc();

      expect(h.unixMillis, 1703462400000);
    });
  });

  group('Core string parsing', () {
    test('ISO variants parse correctly with expected components', () {
      final dateOnly = Hora.parse('2024-06-15');
      final dateTimeSpace = Hora.parse('2024-06-15 10:30:45');
      final isoUtc = Hora.parse('2024-06-15T10:30:45.123456Z');
      final isoOffset = Hora.parse('2024-06-15T10:30:45+08:00');

      expect(dateOnly.isValid, isTrue);
      expect(dateOnly.year, 2024);
      expect(dateOnly.month, 6);
      expect(dateOnly.day, 15);

      expect(dateTimeSpace.isValid, isTrue);
      expect(dateTimeSpace.hour, 10);
      expect(dateTimeSpace.minute, 30);
      expect(dateTimeSpace.second, 45);

      expect(isoUtc.isValid, isTrue);
      expect(isoUtc.isUtc, isTrue);
      expect(isoUtc.microsecond, 456);

      expect(isoOffset.isValid, isTrue);
      expect(isoOffset.toUtc().hour, 2);
      expect(isoOffset.toUtc().minute, 30);
      expect(isoOffset.toUtc().second, 45);
    });

    test('ISO parsing supports compact offsets and lowercase z suffix', () {
      final compactOffset = Hora.parse('2024-06-15T10:30:45+0800');
      final lowerZ = Hora.parse('2024-06-15T10:30:45z');

      expect(compactOffset.isValid, isTrue);
      expect(compactOffset.toUtc().hour, 2);
      expect(compactOffset.toUtc().minute, 30);
      expect(compactOffset.toUtc().second, 45);

      expect(lowerZ.isValid, isTrue);
      expect(lowerZ.isUtc, isTrue);
      expect(lowerZ.hour, 10);
      expect(lowerZ.minute, 30);
      expect(lowerZ.second, 45);
    });

    test('ISO fractional seconds with 1-2 digits normalize correctly', () {
      final oneDigit = Hora.parse('2024-06-15T10:30:45.1Z');
      final twoDigits = Hora.parse('2024-06-15T10:30:45.12Z');

      expect(oneDigit.isValid, isTrue);
      expect(oneDigit.millisecond, 100);
      expect(oneDigit.microsecond, 0);

      expect(twoDigits.isValid, isTrue);
      expect(twoDigits.millisecond, 120);
      expect(twoDigits.microsecond, 0);
    });

    test('ISO fractional seconds keep microsecond precision for 3-9 digits',
        () {
      final digits3 = Hora.parse('2024-06-15T10:30:45.123Z');
      final digits6 = Hora.parse('2024-06-15T10:30:45.123456Z');
      final digits9 = Hora.parse('2024-06-15T10:30:45.123456789Z');

      expect(digits3.isValid, isTrue);
      expect(digits3.millisecond, 123);
      expect(digits3.microsecond, 0);

      expect(digits6.isValid, isTrue);
      expect(digits6.millisecond, 123);
      expect(digits6.microsecond, 456);

      expect(digits9.isValid, isTrue);
      expect(digits9.millisecond, 123);
      expect(digits9.microsecond, 456);
    });

    test('ISO parsing rejects overflow that DateTime would normalize', () {
      const invalidInputs = <String>[
        '2024-06-15T24:00:00Z',
        '2024-06-15T10:30:45+24:00',
        '2024-06-15T10:30:45-24:00',
        '2024-04-31T10:30:45Z',
        '2024-06-15T10:60:00Z',
      ];

      for (final input in invalidInputs) {
        expect(Hora.parse(input).isValid, isFalse, reason: 'input=$input');
      }
    });

    test('ISO parsing handles leap-year validity boundaries', () {
      expect(Hora.parse('2024-02-29').isValid, isTrue);
      expect(Hora.parse('2023-02-29').isValid, isFalse);
    });

    test('ISO parsing accepts extreme valid timezone offsets', () {
      final plus = Hora.parse('2024-06-15T10:30:45+23:59');
      final minus = Hora.parse('2024-06-15T10:30:45-23:59');

      expect(plus.isValid, isTrue);
      expect(minus.isValid, isTrue);
      expect(plus.toUtc().unixMicros, lessThan(minus.toUtc().unixMicros));
    });

    test('smart mode parses common fallback date formats', () {
      final slash = Hora.parse('2024/06/15');
      final dot = Hora.parse('2024.06.15');
      final dayFirst = Hora.parse('15/06/2024');
      final trimmed = Hora.parse('  2024/06/15  ');

      for (final h in [slash, dot, dayFirst, trimmed]) {
        expect(h.isValid, isTrue);
        expect(h.year, 2024);
        expect(h.month, 6);
        expect(h.day, 15);
      }
    });

    test('strict mode rejects fallback non-ISO formats', () {
      expect(
        Hora.parse('2024/06/15', mode: HoraParseMode.strict).isValid,
        isFalse,
      );
      expect(
        Hora.parse('2024.06.15', mode: HoraParseMode.strict).isValid,
        isFalse,
      );
      expect(
        Hora.parse('15/06/2024', mode: HoraParseMode.strict).isValid,
        isFalse,
      );
    });

    test('smart mode rejects out-of-range fallback date formats', () {
      expect(Hora.parse('2024/13/15').isValid, isFalse);
      expect(Hora.parse('32/01/2024').isValid, isFalse);
    });

    test('tryParse returns null for invalid ISO timestamps', () {
      expect(Hora.tryParse('2024-06-15T10:30:45+25:00'), isNull);
      expect(Hora.tryParse('2024-06-15T24:00:00Z'), isNull);
      expect(Hora.tryParse('2024-02-30T10:30:45Z'), isNull);
    });

    test('fromMap parseMode respects strict vs smart parsing', () {
      final smart = Hora.fromMap({'date': '2024/06/15'});
      expect(smart.isValid, isTrue);
      expect(smart.year, 2024);
      expect(smart.month, 6);
      expect(smart.day, 15);

      expect(
        () => Hora.fromMap(
          {'date': '2024/06/15'},
          parseMode: HoraParseMode.strict,
        ),
        throwsArgumentError,
      );
    });

    test('fromMap keeps absolute instant for date with explicit timezone', () {
      final h = Hora.fromMap({'date': '2024-06-15T10:00:00+08:00'});

      expect(h.isValid, isTrue);
      expect(h.toUtc().year, 2024);
      expect(h.toUtc().month, 6);
      expect(h.toUtc().day, 15);
      expect(h.toUtc().hour, 2);
      expect(h.toUtc().minute, 0);
    });
  });

  group('String generation tokens', () {
    test('common date-time templates generate expected strings', () {
      final h = Hora.of(
        year: 2024,
        month: 6,
        day: 15,
        hour: 9,
        minute: 8,
        second: 7,
        utc: true,
      );

      expect(h.format('YYYY-MM-DD'), '2024-06-15');
      expect(h.format('YYYY/MM/DD HH:mm:ss'), '2024/06/15 09:08:07');
      expect(h.format('YYYY.MM.DD [at] HH:mm'), '2024.06.15 at 09:08');
      expect(h.format(), '2024-06-15T09:08:07+00:00');
    });

    test('format outputs timezone and unix tokens', () {
      final h = Hora.of(
        year: 2024,
        month: 6,
        day: 15,
        hour: 10,
        minute: 30,
        second: 45,
        utc: true,
      );

      expect(h.format('Z'), '+00:00');
      expect(h.format('ZZ'), '+0000');
      expect(h.format('X'), h.unix.toString());
      expect(h.format('x'), h.unixMillis.toString());
    });

    test('format outputs week and ISO weekday tokens consistently', () {
      final h = Hora.of(year: 2024, day: 4, utc: true); // Thursday

      expect(h.format('W'), h.isoWeek.toString());
      expect(h.format('WW'), h.isoWeek.toString().padLeft(2, '0'));
      expect(int.parse(h.format('E')), h.weekday);

      final localeWeek = int.parse(h.format('w'));
      expect(localeWeek, inInclusiveRange(1, 53));
      expect(h.format('ww'), localeWeek.toString().padLeft(2, '0'));
    });
  });

  group('Custom parse format', () {
    test('parseMultiple respects format order when input is ambiguous', () {
      final usFirst = HoraParser.parseMultiple(
        '03/04/2024',
        ['MM/DD/YYYY', 'DD/MM/YYYY'],
      );
      final euFirst = HoraParser.parseMultiple(
        '03/04/2024',
        ['DD/MM/YYYY', 'MM/DD/YYYY'],
      );

      expect(usFirst.month, 3);
      expect(usFirst.day, 4);

      expect(euFirst.month, 4);
      expect(euFirst.day, 3);
    });

    test('parses month name tokens MMM and MMMM', () {
      final shortMonth = HoraParser.parse('15 Mar 2024', 'DD MMM YYYY');
      final fullMonth = HoraParser.parse('15 March 2024', 'DD MMMM YYYY');

      expect(shortMonth.isValid, isTrue);
      expect(shortMonth.year, 2024);
      expect(shortMonth.month, 3);
      expect(shortMonth.day, 15);

      expect(fullMonth.isValid, isTrue);
      expect(fullMonth.year, 2024);
      expect(fullMonth.month, 3);
      expect(fullMonth.day, 15);
    });

    test('parses timezone token Z and normalizes to UTC instant', () {
      final h = HoraParser.parse(
        '2024-03-15T23:30:00+05:30',
        'YYYY-MM-DDTHH:mm:ssZ',
      );

      expect(h.isValid, isTrue);
      expect(h.isUtc, isTrue);
      expect(h.year, 2024);
      expect(h.month, 3);
      expect(h.day, 15);
      expect(h.hour, 18);
      expect(h.minute, 0);
      expect(h.second, 0);
    });

    test('parses UTC literal Z with timezone token', () {
      final h = HoraParser.parse(
        '2024-03-15T23:30:00Z',
        'YYYY-MM-DDTHH:mm:ssZ',
      );
      expect(h.isValid, isTrue);
      expect(h.isUtc, isTrue);
      expect(h.hour, 23);
      expect(h.minute, 30);
      expect(h.second, 0);
    });

    test('parses unix timestamp tokens X and x', () {
      const seconds = 1703462400;
      const millis = 1703462400123;

      final bySeconds = HoraParser.parse('$seconds', 'X');
      final byMillis = HoraParser.parse('$millis', 'x');

      expect(bySeconds.isValid, isTrue);
      expect(bySeconds.unix, seconds);

      expect(byMillis.isValid, isTrue);
      expect(byMillis.unixMillis, millis);
    });

    test('parses 12-hour edge cases for midnight and noon', () {
      final midnight = HoraParser.parse('12:00 AM', 'hh:mm A');
      final noon = HoraParser.parse('12:00 PM', 'hh:mm A');

      expect(midnight.isValid, isTrue);
      expect(midnight.hour, 0);
      expect(midnight.minute, 0);

      expect(noon.isValid, isTrue);
      expect(noon.hour, 12);
      expect(noon.minute, 0);
    });

    test('parses lowercase meridiem with token a', () {
      final pm = HoraParser.parse('11:45 pm', 'hh:mm a');
      final am = HoraParser.parse('11:45 am', 'hh:mm a');

      expect(pm.isValid, isTrue);
      expect(pm.hour, 23);
      expect(pm.minute, 45);

      expect(am.isValid, isTrue);
      expect(am.hour, 11);
      expect(am.minute, 45);
    });

    test('strict mode rejects trailing and mismatched literals', () {
      expect(
        HoraParser.tryParse('2024-03-15abc', 'YYYY-MM-DD', strict: true),
        isNull,
      );
      expect(
        HoraParser.tryParse('2024/03/15', 'YYYY-MM-DD', strict: true),
        isNull,
      );
      expect(
        HoraParser.tryParse('at 09:30', '[at] HH:mm', strict: true),
        isNotNull,
      );
    });

    test('format -> parse round-trip for common patterns', () {
      final source = Hora.of(
        year: 2024,
        month: 6,
        day: 15,
        hour: 9,
        minute: 8,
        second: 7,
        millisecond: 123,
      );

      final patterns = <String>[
        'YYYY-MM-DD',
        'YYYY/MM/DD',
        'YYYY.MM.DD',
        'DD/MM/YYYY',
        'YYYY-MM-DD HH:mm:ss',
      ];

      for (final pattern in patterns) {
        final encoded = source.format(pattern);
        final decoded = HoraParser.parse(encoded, pattern, strict: true);

        expect(decoded.isValid, isTrue, reason: 'pattern=$pattern');
        expect(decoded.year, source.year, reason: 'pattern=$pattern');
        expect(decoded.month, source.month, reason: 'pattern=$pattern');
        expect(decoded.day, source.day, reason: 'pattern=$pattern');

        if (pattern.contains('HH')) {
          expect(decoded.hour, source.hour, reason: 'pattern=$pattern');
          expect(decoded.minute, source.minute, reason: 'pattern=$pattern');
          expect(decoded.second, source.second, reason: 'pattern=$pattern');
        }
      }
    });

    test('format -> parse round-trip keeps instant for UTC timezone pattern',
        () {
      final source = Hora.of(
        year: 2024,
        month: 6,
        day: 15,
        hour: 9,
        minute: 8,
        second: 7,
        utc: true,
      );
      final encoded = source.format();
      final decoded = HoraParser.parse(
        encoded,
        'YYYY-MM-DDTHH:mm:ssZ',
        strict: true,
      );

      expect(decoded.isValid, isTrue);
      expect(decoded.isUtc, isTrue);
      expect(decoded.unixMicros, source.unixMicros);
    });
  });
}
