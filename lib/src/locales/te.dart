// TE Locale for Hora
// Auto-generated from dayjs locale

import '../locale.dart';

/// Telugu locale.
class HoraLocaleTe extends HoraLocale {
  const HoraLocaleTe();

  @override
  String get code => 'te';

  @override
  List<String> get months => const [
        'జనవరి',
        'ఫిబ్రవరి',
        'మార్చి',
        'ఏప్రిల్',
        'మే',
        'జూన్',
        'జులై',
        'ఆగస్టు',
        'సెప్టెంబర్',
        'అక్టోబర్',
        'నవంబర్',
        'డిసెంబర్',
      ];

  @override
  List<String> get monthsShort => const [
        'జన.',
        'ఫిబ్ర.',
        'మార్చి',
        'ఏప్రి.',
        'మే',
        'జూన్',
        'జులై',
        'ఆగ.',
        'సెప్.',
        'అక్టో.',
        'నవ.',
        'డిసె.',
      ];

  @override
  List<String> get weekdays => const [
        'ఆదివారం',
        'సోమవారం',
        'మంగళవారం',
        'బుధవారం',
        'గురువారం',
        'శుక్రవారం',
        'శనివారం',
      ];

  @override
  List<String> get weekdaysShort => const [
        'ఆది',
        'సోమ',
        'మంగళ',
        'బుధ',
        'గురు',
        'శుక్ర',
        'శని',
      ];

  @override
  List<String> get weekdaysMin => const [
        'ఆ',
        'సో',
        'మం',
        'బు',
        'గు',
        'శు',
        'శ',
      ];

  @override
  int get weekStart => 7;

  @override
  int get yearStart => 1;

  @override
  HoraFormats get formats => const HoraFormats(
        lt: 'A h:mm',
        lts: 'A h:mm:ss',
        l: 'DD/MM/YYYY',
        ll: 'D MMMM YYYY',
        lll: 'D MMMM YYYY, A h:mm',
        llll: 'dddd, D MMMM YYYY, A h:mm',
      );

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
        future: '%s లో',
        past: '%s క్రితం',
        s: 'కొన్ని క్షణాలు',
        m: 'ఒక నిమిషం',
        mm: '%d నిమిషాలు',
        h: 'ఒక గంట',
        hh: '%d గంటలు',
        d: 'ఒక రోజు',
        dd: '%d రోజులు',
        mo: 'ఒక నెల',
        mos: '%d నెలలు',
        y: 'ఒక సంవత్సరం',
        yy: '%d సంవత్సరాలు',
      );

  @override
  String ordinal(int n, [String? unit]) => '$n';
}
