import 'package:HamilGuide/utils/calculations.dart';
import 'package:hijri/hijri_calendar.dart';

enum CalendarType { Gregorian, Hijri }

CalendarType calendarTypeFromInt(int i) => i == 1
    ? CalendarType.Hijri
    : i == 0
        ? CalendarType.Gregorian
        : null;

List<String> monthsNamesInArabic = [
  "1-يناير",
  "2-فبراير",
  "3-مارس",
  "4-أبريل",
  "5-مايو",
  "6-يونيو",
  "7-يوليو",
  "8-أغسطس",
  "9-سبتمبر",
  "10-أكتوبر",
  "11-نوفمبر",
  "12-ديسمبر"
];
List<String> hijriMonthsNamesInArabic = [
  "1-المحرم",
  "2-صفر",
  "3-ربيع الأول",
  "4-ربيع الآخر",
  "5-جمادى الأولى",
  "6-جمادى الآخرة",
  "7-رجب",
  "8-شعبان",
  "9-رمضان",
  "10-شوال",
  "11-ذو القعدة",
  "12-ذو الحجة"
];

Map<String, String> getYearsNumbers() {
  int s = DateTime.now().year - 1;
  Map<String, String> years = {
    arNum(s): s.toString(),
    arNum(s + 1): (s + 1).toString()
  };

  return years;
}

List<String> getMonthsNames() {
  return monthsNamesInArabic;
}

List<String> getDaysInMonth(int daysNum) {
  List<String> days = [];
  for (int i = 1; i <= daysNum; i++) {
    days.add(arNum(i).toString());
  }

  return days;
}

Map<String, String> getHijriYearsNumbers() {
  int s = HijriCalendar.fromDate(DateTime.now()).hYear - 1;

  Map<String, String> years = {
    arNum(s): s.toString(),
    arNum(s + 1): (s + 1).toString()
  };

  return years;
}

List<String> getHijriMonthsNames() {
  return hijriMonthsNamesInArabic;
}

int getHijriDaysInMonth() {
  return HijriCalendar().lengthOfMonth;
}
