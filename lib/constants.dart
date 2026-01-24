const REMAINING_DAYS_UNTIL_DELIVERY = "متبقي على الولادة";
const EXPECTED_DELIVERY_DATE = "يوم الولادة المتوقع";
const PREGNANCY_START_DATE = "منذ بداية الحمل";
const PREGNANCY_TIME = "مدة الحمل حتى الآن:";

const TOTAL_PERIOD = 280;
const ENRICHMENT_TO_DELIVERY = 280 - 14;

const DB_NAME = 'pregnant_data.db';
const TABLE_NAME = 'PregnantData';
const ENTRY_DATE_COLUMN = 'EntryDate';
const START_DATE_IN_MS_COLUMN = 'StartDate';
const CALENDAR_TYPE = 'CalendarType';

const DB_ITEM_ID = 1;

const APP_ID = 'com.hamilguide.pregnancycalc';
const SCHEDULED_NOTIFICATION_ID = 501;
const NOTIFICATION_CHANNEL_ID = '401';
const NOTIFICATION_CHANNEL_NAME = 'حالة الحمل الأسبوعية';
const NOTIFICATION_CHANNEL_DESCRIPTION =
    'إشعار اسبوعي لقراءة معلومات عن الأسبوع الحالي في الحمل';

String NUM_TO_TEXT(int n) {
  if (n < 0 || n > 9) return '';
  return arTxtFromNumber[n];
}

const arTxtFromNumber = [
  'الأول',
  'الثاني',
  'الثالث',
  'الرابع',
  'الخامس',
  'السادس',
  'السابع',
  'الثامن',
  'التاسع',
  'العاشر',
];

double getMargin(double height) {
  double margin;

  if (height <= 400) {
    margin = 37;
  } else if (height >= 400 && height < 720) {
    margin = 55;
  } else if (height >= 720) {
    margin = 95;
  }

  return margin;
}
