import 'package:hora/hora.dart';
import 'package:hora/src/plugins/localized_format.dart';
import 'package:test/test.dart';

void main() {
  group('LocalizedFormat', () {
    group('LT - Time format', () {
      test('formats time in 12-hour format for en', () {
        final h = Hora.of(year: 2023, month: 12, day: 25, hour: 14, minute: 30);
        expect(h.localizedFormat('LT'), equals('2:30 PM'));
      });

      test('formats morning time correctly', () {
        final h = Hora.of(year: 2023, month: 12, day: 25, hour: 9, minute: 15);
        expect(h.localizedFormat('LT'), equals('9:15 AM'));
      });

      test('formats noon correctly', () {
        final h = Hora.of(year: 2023, month: 12, day: 25, hour: 12);
        expect(h.localizedFormat('LT'), equals('12:00 PM'));
      });

      test('formats midnight correctly', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        expect(h.localizedFormat('LT'), equals('12:00 AM'));
      });
    });

    group('LTS - Time with seconds format', () {
      test('includes seconds', () {
        final h = Hora.of(
          year: 2023,
          month: 12,
          day: 25,
          hour: 14,
          minute: 30,
          second: 45,
        );
        expect(h.localizedFormat('LTS'), equals('2:30:45 PM'));
      });
    });

    group('L - Short date format', () {
      test('formats date in MM/DD/YYYY for en', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        expect(h.localizedFormat('L'), equals('12/25/2023'));
      });

      test('pads single digit month and day', () {
        final h = Hora.of(year: 2023, month: 3, day: 5);
        expect(h.localizedFormat('L'), equals('03/05/2023'));
      });
    });

    group('LL - Long date format', () {
      test('formats with full month name', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        expect(h.localizedFormat('LL'), equals('December 25, 2023'));
      });
    });

    group('LLL - Long date with time format', () {
      test('includes date and time', () {
        final h = Hora.of(year: 2023, month: 12, day: 25, hour: 14, minute: 30);
        expect(h.localizedFormat('LLL'), equals('December 25, 2023 2:30 PM'));
      });
    });

    group('LLLL - Full format', () {
      test('includes weekday, date, and time', () {
        final h = Hora.of(year: 2023, month: 12, day: 25, hour: 14, minute: 30);
        expect(
          h.localizedFormat('LLLL'),
          equals('Monday, December 25, 2023 2:30 PM'),
        );
      });
    });

    group('Compact formats (lowercase)', () {
      test('l - compact short date', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        // Compact version uses short month names
        expect(h.localizedFormat('l'), isNotEmpty);
      });

      test('ll - compact long date', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        expect(h.localizedFormat('ll'), equals('Dec 25, 2023'));
      });

      test('lll - compact long date with time', () {
        final h = Hora.of(year: 2023, month: 12, day: 25, hour: 14, minute: 30);
        expect(h.localizedFormat('lll'), equals('Dec 25, 2023 2:30 PM'));
      });

      test('llll - compact full format', () {
        final h = Hora.of(year: 2023, month: 12, day: 25, hour: 14, minute: 30);
        expect(h.localizedFormat('llll'), equals('Mon, Dec 25, 2023 2:30 PM'));
      });
    });

    group('Custom formats', () {
      test('uses provided formats', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        const customFormats = HoraFormats(
          l: 'YYYY-MM-DD',
          ll: 'D MMM YYYY',
        );
        expect(
          h.localizedFormat('L', formats: customFormats),
          equals('2023-12-25'),
        );
        expect(
          h.localizedFormat('LL', formats: customFormats),
          equals('25 Dec 2023'),
        );
      });
    });

    group('LocalizedFormatPresets', () {
      test('en-GB format has DD/MM/YYYY', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        expect(
          h.localizedFormat('L', formats: LocalizedFormatPresets.enGB),
          equals('25/12/2023'),
        );
      });

      test('zh-CN format has YYYY/MM/DD', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        expect(
          h.localizedFormat('L', formats: LocalizedFormatPresets.zhCN),
          equals('2023/12/25'),
        );
      });

      test('de format has DD.MM.YYYY', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        expect(
          h.localizedFormat('L', formats: LocalizedFormatPresets.de),
          equals('25.12.2023'),
        );
      });

      test('ja format has YYYY/MM/DD', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        expect(
          h.localizedFormat('L', formats: LocalizedFormatPresets.ja),
          equals('2023/12/25'),
        );
      });

      test('ko format has YYYY.MM.DD', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        expect(
          h.localizedFormat('L', formats: LocalizedFormatPresets.ko),
          equals('2023.12.25'),
        );
      });

      test('fr format has DD/MM/YYYY', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        expect(
          h.localizedFormat('L', formats: LocalizedFormatPresets.fr),
          equals('25/12/2023'),
        );
      });

      test('es format has DD/MM/YYYY', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        expect(
          h.localizedFormat('L', formats: LocalizedFormatPresets.es),
          equals('25/12/2023'),
        );
      });

      test('ru format has DD.MM.YYYY', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        expect(
          h.localizedFormat('L', formats: LocalizedFormatPresets.ru),
          equals('25.12.2023'),
        );
      });

      test('pt-BR format has DD/MM/YYYY', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        expect(
          h.localizedFormat('L', formats: LocalizedFormatPresets.ptBR),
          equals('25/12/2023'),
        );
      });

      test('it format has DD/MM/YYYY', () {
        final h = Hora.of(year: 2023, month: 12, day: 25);
        expect(
          h.localizedFormat('L', formats: LocalizedFormatPresets.it),
          equals('25/12/2023'),
        );
      });
    });

    group('forLocale', () {
      test('returns correct format for locale code', () {
        expect(
          LocalizedFormatPresets.forLocale('en'),
          equals(LocalizedFormatPresets.en),
        );
        expect(
          LocalizedFormatPresets.forLocale('en-GB'),
          equals(LocalizedFormatPresets.enGB),
        );
        expect(
          LocalizedFormatPresets.forLocale('zh-CN'),
          equals(LocalizedFormatPresets.zhCN),
        );
        expect(
          LocalizedFormatPresets.forLocale('de'),
          equals(LocalizedFormatPresets.de),
        );
      });

      test('returns en for unknown locale', () {
        expect(
          LocalizedFormatPresets.forLocale('unknown'),
          equals(LocalizedFormatPresets.en),
        );
      });
    });

    group('Mixed patterns', () {
      test('can mix localized tokens with other format tokens', () {
        final h = Hora.of(year: 2023, month: 12, day: 25, hour: 14, minute: 30);
        // This tests that L is expanded and other tokens work
        final result = h.localizedFormat('L - LT');
        expect(result, contains('/'));
        expect(result, contains(' - '));
      });

      test('does not expand localized tokens inside escaped literals', () {
        final h = Hora.of(year: 2023, month: 12, day: 25, hour: 14, minute: 30);
        final result = h.localizedFormat('[L] LT');
        expect(result, equals('L 2:30 PM'));
      });
    });
  });
}
