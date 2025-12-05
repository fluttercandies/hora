import 'package:hora/hora.dart';
import 'package:hora/src/plugins/buddhist_era.dart';
import 'package:test/test.dart';

void main() {
  group('BuddhistEraExt', () {
    test('buddhistYear adds 543 to Gregorian year', () {
      expect(Hora.of(year: 2024).buddhistYear, 2567);
      expect(Hora.of(year: 2000).buddhistYear, 2543);
      expect(Hora.of(year: 1).buddhistYear, 544);
    });

    test('formatBuddhistEra with BBBB token', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(h.formatBuddhistEra('BBBB'), '2567');
    });

    test('formatBuddhistEra with BB token', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(h.formatBuddhistEra('BB'), '67');
    });

    test('formatBuddhistEra combines with standard tokens', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(h.formatBuddhistEra('DD/MM/BBBB'), '15/03/2567');
    });

    test('formatBuddhistEra preserves text in brackets', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(h.formatBuddhistEra('[Year] BBBB [BE]'), 'Year 2567 BE');
    });
  });
}
