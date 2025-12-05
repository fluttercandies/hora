// Barrel file for plugin tests
// Run all tests with: dart test

import 'advanced_format_test.dart' as advanced_format;
import 'buddhist_era_test.dart' as buddhist_era;
import 'business_day_test.dart' as business_day;
import 'calendar_test.dart' as calendar;
import 'custom_parse_format_test.dart' as custom_parse_format;
import 'duration_ext_test.dart' as duration_ext;
import 'fiscal_year_test.dart' as fiscal_year;
import 'locale_data_test.dart' as locale_data;
import 'min_max_test.dart' as min_max;
import 'precision_test.dart' as precision;
import 'recurrence_test.dart' as recurrence;
import 'relative_time_test.dart' as relative_time;
import 'timezone_test.dart' as timezone;
import 'week_of_year_test.dart' as week_of_year;

void main() {
  advanced_format.main();
  buddhist_era.main();
  business_day.main();
  calendar.main();
  custom_parse_format.main();
  duration_ext.main();
  fiscal_year.main();
  locale_data.main();
  min_max.main();
  precision.main();
  recurrence.main();
  relative_time.main();
  timezone.main();
  week_of_year.main();
}
