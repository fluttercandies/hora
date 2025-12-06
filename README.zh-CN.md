<p align="center">
  <img src="hora.png" alt="Hora" width="180">
</p>

<h1 align="center">Hora</h1>

<p align="center">
  <a href="https://pub.dev/packages/hora"><img src="https://img.shields.io/pub/v/hora.svg" alt="pub package"></a>
  <a href="https://pub.dev/packages/hora/score"><img src="https://img.shields.io/pub/points/hora" alt="pub points"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
</p>

<p align="center">
  一个强大、不可变且类型安全的 Dart 日期时间库，灵感来自 <a href="https://day.js.org/">Day.js</a>。
</p>

<p align="center">
  <strong>Hora</strong>（拉丁语，意为“小时/时间”）提供现代化的日期时间操作 API，充分利用 Dart 的特性，包括密封类、模式匹配和完整的类型安全。
</p>

<p align="center">
  <a href="https://pub.dev/documentation/hora/latest/">📚 API 文档</a> ·
  <a href="README.md">English Documentation</a>
</p>

## 特性

- 🔒 **不可变设计**：所有操作返回新实例
- 🎯 **类型安全**：充分利用 Dart 的密封类和模式匹配
- 🌍 **国际化支持**：内置多语言支持，可扩展架构
- ⚡ **轻量级**：无外部依赖（仅使用 `meta` 包作为注解）
- 📅 **日历感知时长**：正确处理月份和年份
- 🔌 **插件系统**：无需修改核心即可扩展功能
- 🧪 **测试完善**：全面的测试覆盖

## 安装

在 `pubspec.yaml` 中添加 `hora`：

```yaml
dependencies:
  hora: any
```

然后运行：

```bash
dart pub get
```

## 快速开始

```dart
import 'package:hora/hora.dart';

void main() {
  // 创建 Hora 实例
  final now = Hora.now();
  final date = Hora.of(year: 2024, month: 6, day: 15);
  
  // 从字符串解析
  final parsed = Hora.parse('2024-06-15T10:30:00');
  
  // 操作日期
  final nextWeek = now.add(1, TemporalUnit.week);
  final lastMonth = now.subtract(1, TemporalUnit.month);
  
  // 格式化日期
  print(now.format('YYYY-MM-DD')); // 2024-06-15
  print(now.format('MMMM D, YYYY')); // June 15, 2024
  
  // 相对时间
  print(date.fromNow()); // "2 个月前"
}
```

## API 概览

### 创建 Hora 实例

```dart
// 当前时间
Hora.now()
Hora.nowUtc()

// 从组件创建
Hora.of(year: 2024, month: 6, day: 15)
Hora.of(year: 2024, month: 6, day: 15, hour: 10, minute: 30, second: 45)

// 从 DateTime 创建
Hora.fromDateTime(DateTime.now())

// 从时间戳创建
Hora.unix(1718409600)
Hora.unixMillis(1718409600000)

// 解析字符串
Hora.parse('2024-06-15')
Hora.parse('2024-06-15T10:30:00')
Hora.tryParse('invalid') // 返回 null 而非无效的 Hora
```

### 日期组件

```dart
final h = Hora.of(year: 2024, month: 6, day: 15, hour: 14, minute: 30);

h.year        // 2024
h.month       // 6
h.day         // 15
h.weekday     // 6（周六，ISO 8601）
h.hour        // 14
h.minute      // 30
h.second      // 0
h.millisecond // 0
h.microsecond // 0

// 派生属性
h.quarter     // 2（第二季度）
h.dayOfYear   // 167（一年中的第 167 天）
h.isoWeek     // 24（ISO 周数）
h.isLeapYear  // true（闰年）
h.daysInMonth // 30（当月天数）
```

### 操作

所有操作方法都返回新实例：

```dart
// 增加/减少时间
h.add(1, TemporalUnit.day)
h.subtract(2, TemporalUnit.week)
h.addDuration(Duration(hours: 5))

// 单位的开始/结束
h.startOf(TemporalUnit.month)  // 月初，00:00:00
h.endOf(TemporalUnit.day)      // 23:59:59.999999

// 复制并修改
h.copyWith(hour: 10, minute: 0)
```

### 时间单位

Hora 使用密封类 `TemporalUnit` 实现类型安全的单位指定：

```dart
// 固定时长单位
TemporalUnit.microsecond
TemporalUnit.millisecond
TemporalUnit.second
TemporalUnit.minute
TemporalUnit.hour
TemporalUnit.day
TemporalUnit.week

// 日历单位（可变时长）
TemporalUnit.month
TemporalUnit.quarter
TemporalUnit.year
```

### 比较

```dart
h1.isBefore(h2)
h1.isAfter(h2)
h1.isSame(h2, TemporalUnit.day)  // 是同一天吗？
h1.isSameOrBefore(h2)
h1.isSameOrAfter(h2)
h1.isBetween(start, end)

h1.difference(h2)  // 返回 Duration
h1.diff(h2, TemporalUnit.day)  // 返回 num
```

### 查询

```dart
h.isToday       // 是今天吗
h.isYesterday   // 是昨天吗
h.isTomorrow    // 是明天吗
h.isThisWeek    // 是本周吗
h.isThisMonth   // 是本月吗
h.isThisYear    // 是今年吗
h.isPast        // 是过去吗
h.isFuture      // 是未来吗
h.isWeekend     // 是周末吗
h.isWeekday     // 是工作日吗
```

### 格式化

```dart
h.format('YYYY-MM-DD')           // 2024-06-15
h.format('MMMM D, YYYY')         // June 15, 2024
h.format('dddd, MMM D')          // Saturday, Jun 15
h.format('h:mm A')               // 2:30 PM
h.toIso8601()                    // 2024-06-15T14:30:00.000
```

#### 格式化令牌

| 令牌 | 输出 | 描述 |
|------|------|------|
| `YYYY` | 2024 | 4位年份 |
| `YY` | 24 | 2位年份 |
| `MMMM` | June | 完整月份名 |
| `MMM` | Jun | 简短月份名 |
| `MM` | 06 | 月份（2位） |
| `M` | 6 | 月份 |
| `DD` | 15 | 日期（2位） |
| `D` | 15 | 日期 |
| `Do` | 15th | 带序数词的日期 |
| `dddd` | Saturday | 完整星期名 |
| `ddd` | Sat | 简短星期名 |
| `dd` | Sa | 最短星期名 |
| `d` | 6 | 星期几（0-6） |
| `HH` | 14 | 24小时制小时（2位） |
| `H` | 14 | 24小时制小时 |
| `hh` | 02 | 12小时制小时（2位） |
| `h` | 2 | 12小时制小时 |
| `mm` | 30 | 分钟（2位） |
| `m` | 30 | 分钟 |
| `ss` | 00 | 秒（2位） |
| `s` | 0 | 秒 |
| `A` | PM | AM/PM |
| `a` | pm | am/pm |
| `Q` | 2 | 季度 |
| `W` | 24 | ISO 周数 |
| `Z` | +00:00 | 时区偏移 |
| `X` | 1718409600 | Unix 时间戳（秒） |
| `x` | 1718409600000 | Unix 时间戳（毫秒） |

### 相对时间

```dart
// 相对于现在（通过扩展方法）
past.fromNow()    // "3天前"
future.fromNow()  // "2小时内"

// 相对于另一个日期
h1.from(h2)       // "5天前"
h1.to(h2)         // "5天内"

// 不带前缀/后缀
past.fromNow(withoutSuffix: true)  // "3天"

// 高级相对时间（通过 relative_time 插件）
import 'package:hora/src/plugins/relative_time.dart';

past.relativeFromNow()    // "3天前"（更多选项）
```

### 日历格式

```dart
h.calendar()
// 今天 下午 2:30
// 昨天 下午 3:00
// 明天 上午 10:00
// 上周一 上午 9:00
// 2023/12/25
```

## HoraDuration

`HoraDuration` 提供日历感知的时长，能正确处理月份和年份：

```dart
// 创建时长
final d1 = HoraDuration(years: 1, months: 6);
final d2 = HoraDuration(days: 30, hours: 12);
final d3 = HoraDuration.between(h1, h2);

// 解析 ISO 8601
final d4 = HoraDuration.parse('P1Y6M');
final d5 = HoraDuration.parse('P2DT12H30M');

// 算术运算
final sum = d1 + d2;
final diff = d1 - d2;
final scaled = d1 * 2;

// 格式化
d1.toIso8601()  // "P1Y6M"
d1.humanize()   // "一年"

// 规范化
HoraDuration(minutes: 90).normalize()  // 1小时30分钟
```

## 本地化

Hora 内置了 **143 个语言环境**，涵盖世界主要语言，均支持 tree-shaking。

### 快速开始

```dart
import 'package:hora/hora.dart';

// 英语和中文默认可用
final now = Hora.now(); // 使用 HoraLocaleEn
final chinese = Hora.now(locale: const HoraLocaleZhCn());

print(now.format('MMMM D, YYYY'));     // December 6, 2024
print(chinese.format('YYYY年M月D日'));  // 2024年12月6日
```

### 使用其他语言环境

只导入需要的语言环境以获得最佳 tree-shaking 效果：

```dart
import 'package:hora/hora.dart';
import 'package:hora/src/locales/ja.dart';
import 'package:hora/src/locales/ko.dart';
import 'package:hora/src/locales/de.dart';

void main() {
  final japanese = Hora.now(locale: const HoraLocaleJa());
  final korean = Hora.now(locale: const HoraLocaleKo());
  final german = Hora.now(locale: const HoraLocaleDe());

  print(japanese.format('YYYY年M月D日')); // 2024年12月6日
  print(korean.format('YYYY년 M월 D일')); // 2024년 12월 6일
  print(german.format('D. MMMM YYYY'));   // 6. Dezember 2024
}
```

### 可用语言环境

| 地区 | 语言环境 |
|------|---------|
| **默认** | `en`, `zh-cn`（从 hora.dart 导出） |
| **欧洲** | `de`, `fr`, `es`, `it`, `pt`, `nl`, `pl`, `ru`, `uk`, `cs`, `sk`, `hu`, `ro`, `bg`, `el`, `tr`, `sv`, `da`, `no`, `fi`, `et`, `lv`, `lt`, ... |
| **亚洲** | `zh`, `zh-tw`, `zh-hk`, `ja`, `ko`, `th`, `vi`, `id`, `ms`, `tl-ph`, `km`, `lo`, `my`, `bn`, `hi`, `ta`, `te`, `kn`, `ml`, `gu`, `mr`, `pa-in`, `ne`, ... |
| **中东** | `ar`, `ar-sa`, `ar-eg`, `fa`, `he`, `ur`, `ku`, ... |
| **其他** | `sw`, `yo`, `am`, `ti`, `eo`, `tlh`, ... |

完整列表：请查看 [lib/src/locales/](lib/src/locales/) 目录。

### 全局语言环境

为所有新的 Hora 实例设置默认语言环境：

```dart
// 设置全局语言环境
Hora.globalLocale = const HoraLocaleZhCn();

// 新实例使用全局语言环境
final h1 = Hora.now(); // 使用 HoraLocaleZhCn
final h2 = Hora.of(year: 2024, month: 12, day: 5); // 使用 HoraLocaleZhCn

// 使用显式语言环境覆盖
final h3 = Hora.now(locale: const HoraLocaleEn()); // 使用 HoraLocaleEn
```

### 更改现有实例的语言环境

```dart
final h = Hora.now(locale: const HoraLocaleEn());
print(h.format('MMMM')); // December

final h2 = h.withLocale(const HoraLocaleZhCn());
print(h2.format('MMMM')); // 十二月
```

### 动态语言环境注册

对于需要通过代码字符串切换语言环境的应用（例如从用户设置）：

```dart
import 'package:hora/hora.dart';
import 'package:hora/src/locales/ja.dart';
import 'package:hora/src/locales/ko.dart';

void main() {
  // 注册需要的语言环境
  HoraLocales.register(const HoraLocaleJa());
  HoraLocales.register(const HoraLocaleKo());

  // 按代码查找
  final userLocaleCode = getUserPreferredLocale(); // 例如 'ja'
  final locale = HoraLocales.get(userLocaleCode);
  
  if (locale != null) {
    final h = Hora.now(locale: locale);
    print(h.format('LLLL'));
  }
}
```

### 创建自定义语言环境

```dart
class HoraLocaleEs extends HoraLocale {
  const HoraLocaleEs();

  @override
  String get code => 'es';

  @override
  List<String> get months => const [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  @override
  List<String> get monthsShort => const [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
  ];

  @override
  List<String> get weekdays => const [
    'Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'
  ];

  @override
  List<String> get weekdaysShort => const ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];

  @override
  List<String> get weekdaysMin => const ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sá'];

  @override
  int get weekStart => DateTime.monday; // 周一开始

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
    future: 'en %s',
    past: 'hace %s',
    s: 'unos segundos',
    m: 'un minuto',
    mm: '%d minutos',
    h: 'una hora',
    hh: '%d horas',
    d: 'un día',
    dd: '%d días',
    mo: 'un mes',
    mos: '%d meses',
    y: 'un año',
    yy: '%d años',
  );

  @override
  String ordinal(int n, [String? unit]) => '${n}º';
}

## 扩展

Hora 提供便捷的扩展方法：

```dart
// DateTime 扩展
DateTime.now().toHora()

// Duration 扩展
Duration(days: 5).toHoraDuration()

// 字符串解析
'2024-06-15'.toHora()

// 整数时间戳
1718409600.asUnixSeconds
1718409600000.asUnixMillis

// 范围生成
start.rangeTo(end, step: TemporalUnit.day)  // Iterable<Hora>
start.take(10, step: TemporalUnit.day)      // 连续10天

// 最小/最大值
[h1, h2, h3].earliest  // Hora?
[h1, h2, h3].latest    // Hora?

// 构建器方法
Hora.now()
    .startOf(TemporalUnit.day)
    .copyWith(month: 6)
    .copyWith(year: 2024)
```

## 插件

Hora 带有丰富的插件来扩展其功能。所有插件都通过扩展方法提供，无需单独注册。

### LocalizedFormat（本地化格式）

使用特定于区域设置的格式字符串格式化日期：

```dart
import 'package:hora/hora.dart';
import 'package:hora/src/plugins/localized_format.dart';

final h = Hora.of(year: 2024, month: 6, day: 15, hour: 14, minute: 30);

// 使用预定义格式
h.localizedFormat('LT')    // "2:30 PM"
h.localizedFormat('LTS')   // "2:30:45 PM"
h.localizedFormat('L')     // "06/15/2024"
h.localizedFormat('LL')    // "June 15, 2024"
h.localizedFormat('LLL')   // "June 15, 2024 2:30 PM"
h.localizedFormat('LLLL')  // "Saturday, June 15, 2024 2:30 PM"

// 使用不同的语言环境
final zhLocale = const HoraLocaleZhCn();
h.withLocale(zhLocale).localizedFormat('LL')  // 使用中文格式
```

### WeekYear（周年）

计算财务/ISO 日历报告的周年值：

```dart
import 'package:hora/hora.dart';
import 'package:hora/src/plugins/week_year.dart';

final h = Hora.of(year: 2024, month: 1, day: 1);

// ISO 周年（默认）
h.weekYear()          // 2024
h.weekOfWeekYear()    // 1
h.weeksInWeekYear()   // 52

// 美国周配置（周日开始）
h.weekYear(WeekYearConfig.us)
h.weekOfWeekYear(WeekYearConfig.us)

// 设置周年
h.setWeekYear(2025)
```

### UpdateLocale（更新语言环境）

在运行时动态修改语言环境设置：

```dart
import 'package:hora/hora.dart';
import 'package:hora/src/plugins/update_locale.dart';

// 从基础语言环境创建更新的版本
final customLocale = const HoraLocaleEn().update(
  weekStart: DateTime.monday,
  months: ['Jan', 'Feb', 'Mar', ...],
);

// 更新相对时间设置
final rtLocale = const HoraLocaleEn().updateRelativeTime(
  s: '刚刚',
  m: '一分钟前',
);

// 更新格式字符串
final fmtLocale = const HoraLocaleEn().updateFormats(
  lt: 'HH:mm',
  ll: 'YYYY年M月D日',
);

// 使用更新的语言环境
final h = Hora.now(locale: customLocale);
```

### ObjectSupport（对象支持）

使用 Map 对象创建和操作 Hora 实例：

```dart
import 'package:hora/hora.dart';
import 'package:hora/src/plugins/object_support.dart';

// 从对象创建
final h = HoraObject.from({
  'year': 2024,
  'month': 6,
  'day': 15,
  'hour': 14,
  'minute': 30,
});

// 使用对象添加
h.addObject({'days': 5, 'hours': 3})

// 使用对象减去
h.subtractObject({'months': 1})

// 使用对象设置
h.setObject({'hour': 10, 'minute': 0})

// 按键获取/设置
h.getByKey('month')  // 6
h.setByKey('day', 20)
```

### 其他插件

Hora 还包含更多插件：

| 插件 | 描述 |
|------|------|
| `advancedFormat` | 扩展格式令牌（`Q`、`Do`、`k` 等） |
| `buddhistEra` | 佛历支持 |
| `businessDay` | 工作日计算 |
| `calendar` | 日历样式日期格式化 |
| `customParseFormat` | 使用自定义格式字符串解析日期 |
| `duration` | 高级时长处理 |
| `fiscalYear` | 财年计算 |
| `localeData` | 以编程方式访问语言环境数据 |
| `minMax` | 在日期集合中查找最小/最大值 |
| `precision` | 精度感知的日期比较 |
| `recurrence` | 重复日期模式 |
| `relativeTime` | 人类可读的相对时间 |
| `timezone` | 时区支持 |
| `weekOfYear` | 年周计算 |

## 与其他库的比较

| 特性 | Hora | Day.js | moment.js |
|------|------|--------|-----------|
| 不可变 | ✅ | ✅ | ❌ |
| 类型安全 | ✅（Dart） | ❌ | ❌ |
| 可摇树优化 | ✅ | ✅ | ❌ |
| 空安全 | ✅ | 不适用 | 不适用 |
| 插件系统 | ✅ | ✅ | ✅ |
| 本地化支持 | ✅ | ✅ | ✅ |
| 日历时长 | ✅ | 插件 | ✅ |

## 贡献

欢迎贡献！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解详情。

## 许可证

MIT 许可证 - 查看 [LICENSE](LICENSE) 了解详情。

---

由 [Flutter Candies](https://github.com/fluttercandies) 用 ❤️ 制作
