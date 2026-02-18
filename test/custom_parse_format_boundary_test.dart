import 'package:hora/plugins.dart';
import 'package:test/test.dart';

void main() {
  group('Custom parse format boundaries', () {
    test('YY token uses expected 69-year pivot', () {
      final year68 = HoraParser.parse('68-03-15', 'YY-MM-DD', strict: true);
      final year69 = HoraParser.parse('69-03-15', 'YY-MM-DD', strict: true);

      expect(year68.isValid, isTrue);
      expect(year68.year, 2068);

      expect(year69.isValid, isTrue);
      expect(year69.year, 1969);
    });

    test('month-name tokens are case-insensitive in strict mode', () {
      final shortMonth = HoraParser.parse(
        '15 mAr 2024',
        'DD MMM YYYY',
        strict: true,
      );
      final fullMonth = HoraParser.parse(
        '15 mArCh 2024',
        'DD MMMM YYYY',
        strict: true,
      );

      expect(shortMonth.isValid, isTrue);
      expect(shortMonth.year, 2024);
      expect(shortMonth.month, 3);
      expect(shortMonth.day, 15);

      expect(fullMonth.isValid, isTrue);
      expect(fullMonth.year, 2024);
      expect(fullMonth.month, 3);
      expect(fullMonth.day, 15);
    });

    test('rejects out-of-range date and time components in strict mode', () {
      expect(
        HoraParser.tryParse('2024-13-15', 'YYYY-MM-DD', strict: true),
        isNull,
      );
      expect(
        HoraParser.tryParse('2024-02-30', 'YYYY-MM-DD', strict: true),
        isNull,
      );
      expect(
        HoraParser.tryParse('25:00', 'HH:mm', strict: true),
        isNull,
      );
      expect(
        HoraParser.tryParse('12:60', 'HH:mm', strict: true),
        isNull,
      );
      expect(
        HoraParser.tryParse('12:30:61', 'HH:mm:ss', strict: true),
        isNull,
      );
      expect(
        HoraParser.tryParse('00:30 AM', 'hh:mm A', strict: true),
        isNull,
      );
      expect(
        HoraParser.tryParse('13:30 PM', 'hh:mm A', strict: true),
        isNull,
      );
    });

    test('rejects invalid timezone offsets in strict mode', () {
      expect(
        HoraParser.tryParse(
          '2024-03-15T10:30:45+25:00',
          'YYYY-MM-DDTHH:mm:ssZ',
          strict: true,
        ),
        isNull,
      );
      expect(
        HoraParser.tryParse(
          '2024-03-15T10:30:45+09:60',
          'YYYY-MM-DDTHH:mm:ssZ',
          strict: true,
        ),
        isNull,
      );
      expect(
        HoraParser.tryParse(
          '2024-03-15T10:30:45+05',
          'YYYY-MM-DDTHH:mm:ssZ',
          strict: true,
        ),
        isNull,
      );
    });

    test('parses UTC-equivalent offsets and marks result as UTC', () {
      final plusZero = HoraParser.parse(
        '2024-03-15T10:30:45+00:00',
        'YYYY-MM-DDTHH:mm:ssZ',
        strict: true,
      );
      final minusZero = HoraParser.parse(
        '2024-03-15T10:30:45-00:00',
        'YYYY-MM-DDTHH:mm:ssZ',
        strict: true,
      );
      final literalZ = HoraParser.parse(
        '2024-03-15T10:30:45Z',
        'YYYY-MM-DDTHH:mm:ssZ',
        strict: true,
      );

      expect(plusZero.isUtc, isTrue);
      expect(minusZero.isUtc, isTrue);
      expect(literalZ.isUtc, isTrue);
      expect(plusZero.unixMicros, minusZero.unixMicros);
      expect(plusZero.unixMicros, literalZ.unixMicros);
    });

    test('accepts boundary timezone offsets +23:59 and -23:59', () {
      final plus = HoraParser.parse(
        '2024-03-15T10:30:45+23:59',
        'YYYY-MM-DDTHH:mm:ssZ',
        strict: true,
      );
      final minus = HoraParser.parse(
        '2024-03-15T10:30:45-23:59',
        'YYYY-MM-DDTHH:mm:ssZ',
        strict: true,
      );

      expect(plus.isValid, isTrue);
      expect(minus.isValid, isTrue);
      expect(plus.isUtc, isTrue);
      expect(minus.isUtc, isTrue);
      expect(plus.unixMicros, lessThan(minus.unixMicros));
    });

    test('parses compact timezone offsets with Z token', () {
      final plus0530 = HoraParser.parse(
        '2024-03-15T23:30:00+0530',
        'YYYY-MM-DDTHH:mm:ssZ',
        strict: true,
      );
      final minus0330 = HoraParser.parse(
        '2024-03-15T23:30:00-0330',
        'YYYY-MM-DDTHH:mm:ssZ',
        strict: true,
      );

      expect(plus0530.isValid, isTrue);
      expect(plus0530.isUtc, isTrue);
      expect(plus0530.hour, 18);
      expect(plus0530.minute, 0);

      expect(minus0330.isValid, isTrue);
      expect(minus0330.isUtc, isTrue);
      expect(minus0330.toUtc().hour, 3);
      expect(minus0330.toUtc().minute, 0);
      expect(minus0330.toUtc().day, 16);
    });

    test('parses negative unix timestamp tokens X and x', () {
      final bySeconds = HoraParser.parse('-1', 'X', strict: true);
      final byMillis = HoraParser.parse('-1000', 'x', strict: true);

      expect(bySeconds.isValid, isTrue);
      expect(bySeconds.unix, -1);

      expect(byMillis.isValid, isTrue);
      expect(byMillis.unixMillis, -1000);
    });

    test('parses signed unix timestamp tokens with leading plus sign', () {
      final bySeconds = HoraParser.parse('+1703462400', 'X', strict: true);
      final byMillis = HoraParser.parse('+1703462400123', 'x', strict: true);

      expect(bySeconds.isValid, isTrue);
      expect(bySeconds.unix, 1703462400);

      expect(byMillis.isValid, isTrue);
      expect(byMillis.unixMillis, 1703462400123);
    });

    test('rejects formats that consume no parse tokens', () {
      expect(HoraParser.tryParse('at', '[at]'), isNull);
      expect(HoraParser.tryParse('at', '[at]', strict: true), isNull);
      expect(HoraParser.tryParse('---', '---', strict: true), isNull);
    });

    test('does not parse completely mismatched input in lenient mode', () {
      expect(
        HoraParser.tryParse('totally-invalid-date-format', 'YYYY-MM-DD'),
        isNull,
      );

      final multi = HoraParser.parseMultiple(
        'totally-invalid-date-format',
        ['YYYY-MM-DD', 'DD/MM/YYYY'],
      );
      expect(multi.isValid, isFalse);
    });
  });
}
