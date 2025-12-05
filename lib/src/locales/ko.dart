// KO Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Korean locale.
class HoraLocaleKo extends HoraLocale {
  const HoraLocaleKo();

  @override
  String get code => 'ko';

  @override
  List<String> get months => const [
        '1월',
        '2월',
        '3월',
        '4월',
        '5월',
        '6월',
        '7월',
        '8월',
        '9월',
        '10월',
        '11월',
        '12월',
      ];

  @override
  List<String> get monthsShort => const [
        '1월',
        '2월',
        '3월',
        '4월',
        '5월',
        '6월',
        '7월',
        '8월',
        '9월',
        '10월',
        '11월',
        '12월',
      ];

  @override
  List<String> get weekdays => const [
        '일요일',
        '월요일',
        '화요일',
        '수요일',
        '목요일',
        '금요일',
        '토요일',
      ];

  @override
  List<String> get weekdaysShort => const [
        '일',
        '월',
        '화',
        '수',
        '목',
        '금',
        '토',
      ];

  @override
  List<String> get weekdaysMin => const [
        '일',
        '월',
        '화',
        '수',
        '목',
        '금',
        '토',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'A h:mm',
        lts: 'A h:mm:ss',
        l: 'YYYY.MM.DD.',
        ll: 'YYYY년 MMMM D일',
        lll: 'YYYY년 MMMM D일 A h:mm',
        llll: 'YYYY년 MMMM D일 dddd A h:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s 후',
        past: '%s 전',
        s: '몇 초',
        m: '1분',
        mm: '%d분',
        h: '한 시간',
        hh: '%d시간',
        d: '하루',
        dd: '%d일',
        mo: '한 달',
        mos: '%d달',
        y: '일 년',
        yy: '%d년',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n일';
  @override
  String meridiem(int hour, int minute, {bool lowercase = false}) =>
      hour < 12 ? '오전' : '오후';
}
