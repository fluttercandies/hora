# Contributing to Hora

Thank you for your interest in contributing to Hora! This document provides guidelines and instructions for contributing.

## Code of Conduct

Please be respectful and considerate in all interactions. We are committed to providing a welcoming and inclusive environment for everyone.

## Getting Started

### Prerequisites

- Dart SDK 3.0.0 or higher
- Git

### Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/hora.git
   cd hora
   ```
3. Install dependencies:
   ```bash
   dart pub get
   ```
4. Run tests to ensure everything works:
   ```bash
   dart test
   ```

## Development Workflow

### Branching

- Create a new branch for your feature or fix:
  ```bash
  git checkout -b feature/your-feature-name
  ```
- Use descriptive branch names:
  - `feature/add-japanese-locale`
  - `fix/timezone-offset-calculation`
  - `docs/update-readme`

### Code Style

We follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style). Key points:

- Use `dart format` to format your code
- Run `dart analyze --fatal-infos --fatal-warnings` and fix any issues
- Follow naming conventions:
  - `camelCase` for variables and functions
  - `PascalCase` for classes
  - `SCREAMING_CAPS` for constants

### Testing

- Write tests for all new features and bug fixes
- Ensure all tests pass before submitting:
  ```bash
  dart test
  ```
- Aim for high test coverage

### Quality Gate

Use the same quality gate locally and in CI:

```bash
./tool/quality_gate.sh
```

If you need to validate publishability before release:

```bash
./tool/quality_gate.sh --publish-dry-run
```

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

Examples:
```
feat(locale): add Japanese locale support
fix(duration): correct month overflow handling
docs(readme): add calendar formatting examples
```

## Pull Request Process

1. Ensure your code follows the style guidelines
2. Update documentation if needed
3. Add tests for your changes
4. Run the full test suite:
   ```bash
   ./tool/quality_gate.sh
   ```
5. Update CHANGELOG.md with your changes
6. Submit your pull request with a clear description

### PR Title Format

Use the same format as commit messages:
```
feat(locale): add Japanese locale support
```

### PR Description

Include:
- What changes were made
- Why the changes were necessary
- Any breaking changes
- Related issues (e.g., "Fixes #123")

## Adding a New Locale

1. Create a new file in `lib/src/locales/` (e.g., `ja.dart`)
2. Implement the `HoraLocale` class:

```dart
import '../locale.dart';

/// Japanese locale for Hora.
class HoraLocaleJa extends HoraLocale {
  const HoraLocaleJa();

  @override
  String get code => 'ja';

  @override
  List<String> get months => [
    '1月', '2月', '3月', '4月', '5月', '6月',
    '7月', '8月', '9月', '10月', '11月', '12月'
  ];

  @override
  List<String> get monthsShort => months;

  @override
  List<String> get weekdays => [
    '日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日'
  ];

  @override
  List<String> get weekdaysShort => ['日', '月', '火', '水', '木', '金', '土'];

  @override
  List<String> get weekdaysMin => weekdaysShort;

  @override
  int get weekStart => 7; // Sunday

  @override
  HoraRelativeTime get relativeTime => const HoraRelativeTime(
    future: '%s後',
    past: '%s前',
    s: '数秒',
    m: '1分',
    mm: '%d分',
    h: '1時間',
    hh: '%d時間',
    d: '1日',
    dd: '%d日',
    w: '1週間',
    ww: '%d週間',
    mo: '1ヶ月',
    mos: '%dヶ月',
    y: '1年',
    yy: '%d年',
  );

  @override
  String ordinal(int n, [String? unit]) => '$n';

  @override
  String get invalidDate => '無効な日付';
}
```

3. Export the locale in `lib/src/locales/locales.dart` (full-locale export set)
4. Optionally add convenience export in `lib/src/locale.dart` if intended as a default bundled locale
5. Add tests in `test/locale_test.dart` or a dedicated locale test file
6. Update documentation

## Reporting Issues

### Bug Reports

Include:
- Hora version
- Dart version
- Steps to reproduce
- Expected behavior
- Actual behavior
- Code samples

### Feature Requests

Include:
- Use case description
- Proposed API (if applicable)
- Examples

## Questions?

- Open a [GitHub Discussion](https://github.com/fluttercandies/hora/discussions)
- Join the [Flutter Candies Discord](https://discord.gg/fluttercandies)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to Hora! 🎉
