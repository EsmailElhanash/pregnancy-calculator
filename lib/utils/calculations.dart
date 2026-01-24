import 'package:HamilGuide/utils/date_util.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

String getExpectedDeliveryDate(int remainingDays, CalendarType calendarType) {
  var now = DateTime.now();
  if (calendarType == CalendarType.Gregorian)
    return DateFormat('d-M-yyyy')
        .format(now.add(Duration(days: remainingDays + 1)))
        .toString();
  else {
    HijriCalendar.setLocal('ar');
    HijriCalendar d =
        HijriCalendar.fromDate(now.add(Duration(days: remainingDays + 1)));
    return d.dayWeName +
        " " +
        d.hDay.toString() +
        " " +
        d.longMonthName +
        " " +
        d.hYear.toString();
  }
}

int getRemainingDays(
    bool enterExpectedDate, dynamic selectedDate, CalendarType calendarType) {
  var now = DateTime.now();
  int remainingDays;
  if (calendarType == CalendarType.Gregorian) {
    if (!enterExpectedDate) {
      //آخر دورة شهرية
      remainingDays =
          selectedDate.add(Duration(days: TOTAL_PERIOD)).difference(now).inDays;
    } else {
      //موعد متوقع
      remainingDays = selectedDate.difference(now).inDays;
    }
  } else if (calendarType == CalendarType.Hijri) {
    if (!enterExpectedDate) {
      //آخر دورة شهرية
      remainingDays = HijriCalendar()
          .hijriToGregorian(
              (selectedDate as HijriCalendar).hYear,
              (selectedDate as HijriCalendar).hMonth,
              (selectedDate as HijriCalendar).hDay)
          .add(Duration(days: TOTAL_PERIOD))
          .difference(now)
          .inDays;
    } else {
      //موعد متوقع
      remainingDays = HijriCalendar()
          .hijriToGregorian(
              (selectedDate as HijriCalendar).hYear,
              (selectedDate as HijriCalendar).hMonth,
              (selectedDate as HijriCalendar).hDay)
          .difference(now)
          .inDays;
    }
  }
  return remainingDays;
}

String getPregnancyStartDate(int remainingDays) {
  return (TOTAL_PERIOD - remainingDays).toString();
}

String getCurrentProgressInWeeks(int remainingDays) {
  return arNum(((TOTAL_PERIOD - remainingDays) / 7).ceil()).toString();
}

String getCurrentProgress(int remainingDays) {
  int months = ((TOTAL_PERIOD - remainingDays) / 30).floor();
  int weeks = (((TOTAL_PERIOD - remainingDays) % 30) / 7).floor();
  int days = (((TOTAL_PERIOD - remainingDays) % 30) % 7).floor();

  String monthPeriod = arNum(months) + (months >= 3 ? ' أشهر ' : ' شهر ');
  String weekPeriod = arNum(weeks) + (weeks >= 3 ? ' أسابيع ' : ' إسبوع ');
  String dayPeriod =
      arNum(days) + (days >= 3 && days <= 9 ? ' أيام ' : ' يوم ');
  return monthPeriod + weekPeriod + dayPeriod;
}

String arNum(int s) {
  return s.toString();
}
/*

Map arToEnNumbers = {
  '٠': 0,
  '١': 1,
  '٢': 2,
  '٣': 3,
  '٤': 4,
  '٥': 5,
  '٦': 6,
  '٧': 7,
  '٨': 8,
  '٩': 9,
};
*/
