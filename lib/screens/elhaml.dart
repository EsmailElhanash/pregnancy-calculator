import 'package:HamilGuide/utils/notification_manager.dart';
import 'package:HamilGuide/utils/rate_app.dart';
import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hijri/hijri_calendar.dart';

import '../constants.dart';
import '../utils/calculations.dart';
import '../utils/database.dart';
import '../utils/date_util.dart';
import '../utils/weeks_manager.dart';

enum MyState { LOADING, SHOW_DETAILS, SHOW_MAIN_SCREEN }

class Elhaml extends StatefulWidget {
  @override
  ElhamlState createState() => ElhamlState();
}

class ElhamlState extends State<Elhaml> {
  CalendarType calendarType = CalendarType.Gregorian;
  bool enterExpectedDate = false;
  MyState myState = MyState.SHOW_MAIN_SCREEN;

  String pickedYear;
  String pickedMonth;
  String pickedDay;
  String instructionText;

  Map<String, String> yearsList;
  List<String> monthsList;
  List<String> daysList;

  List<Map<String, dynamic>> existingDBEntry;
  int remainingDays;

  double screenWidth;
  double screenHeight;

  @override
  void initState() {
    super.initState();
    setCalendar();
    setInstructionText();
    checkDBForExistingData();
    print(calendarType);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    showRateMyApp(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/koky.jpg"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(Colors.pink.withOpacity(0.4), BlendMode.dstATop),
        ),
      ),
      width: screenWidth,
      child: myState == MyState.LOADING
          ? getLoadingIndicator()
          : myState == MyState.SHOW_DETAILS
              ? getDetailsScreen(remainingDays)
              : getMainScreen(),
    );
  }

  Widget getLoadingIndicator() {
    return Container(
        height: 10.0,
        width: 10.0,
        child: Center(child: CircularProgressIndicator()));
  }

  Widget getMainScreen() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: Colors.white.withOpacity(0.5),
            child: Image.asset(
              'assets/images/logo2.png',
            ),
            padding: EdgeInsets.all(16.0),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(7)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  instructionText,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: CalendarType.Gregorian,
                        groupValue: calendarType,
                        onChanged: (CalendarType value) {
                          setState(() {
                            calendarType =
                                value != null ? value : CalendarType.Gregorian;
                            setCalendar();
                            resetDatePicker();
                          });
                        },
                      ),
                      Text(
                        "ميلادي",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CalendarType.Hijri,
                        groupValue: calendarType,
                        onChanged: (CalendarType value) {
                          setState(() {
                            calendarType =
                                value != null ? value : CalendarType.Gregorian;
                            setCalendar();
                            resetDatePicker();
                          });
                        },
                      ),
                      Text(
                        "هجري",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  )
                ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(7)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Years DropDown Button
                    DropdownButton(
                      items:
                          yearsList.keys.map<DropdownMenuItem>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          var yrs = Map.of(yearsList);

                          pickedYear = value;
                          daysList = pickedMonth != null && pickedYear != null
                              ? getDaysInMonth(DateUtil().daysInMonth(
                                  monthsList.indexOf(pickedMonth) + 1,
                                  int.parse(yrs.remove(pickedYear))))
                              : null;
                        });
                      },
                      hint: Text(
                        "اختاري السنة",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      value: pickedYear,
                    ),
                    //Months DropDown Button
                    DropdownButton(
                      items: monthsList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          pickedMonth = value;
                          var yrs = Map.of(yearsList);
                          daysList = pickedMonth != null && pickedYear != null
                              ? getDaysInMonth(DateUtil().daysInMonth(
                                  monthsList.indexOf(pickedMonth) + 1,
                                  int.parse(yrs.remove(pickedYear))))
                              : null;
                        });
                      },
                      hint: Text(
                        "اختاري الشهر",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      value: pickedMonth,
                    ),
                    //Days DropDown Button
                    DropdownButton(
                      items: daysList != null
                          ? daysList
                              .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              );
                            }).toList()
                          : null,
                      onChanged: (value) {
                        setState(() {
                          pickedDay = value;
                        });
                      },
                      hint: Text(
                        "اختاري اليوم",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      value: pickedDay,
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: RaisedButton(
              color: Colors.white60,
              onPressed: () async {
                if (pickedYear != null &&
                    pickedMonth != null &&
                    pickedDay != null) {
                  var pickedDate;
                  var yrs = Map.of(yearsList);

                  int ms;
                  if (calendarType == CalendarType.Gregorian) {
                    pickedDate = DateTime(
                        int.parse(yrs.remove(pickedYear)),
                        monthsList.indexOf(pickedMonth) + 1,
                        daysList.indexOf(pickedDay) + 1);
                    ms = (pickedDate as DateTime).millisecondsSinceEpoch;
                  } else if (calendarType == CalendarType.Hijri) {
                    pickedDate = HijriCalendar();
                    pickedDate.hYear = int.parse(yrs.remove(pickedYear));
                    pickedDate.hMonth = monthsList.indexOf(pickedMonth) + 1;
                    pickedDate.hDay = daysList.indexOf(pickedDay) + 1;
                    ms = HijriCalendar()
                        .hijriToGregorian(pickedDate.hYear, pickedDate.hMonth,
                            pickedDate.hDay)
                        .millisecondsSinceEpoch;
                    print(pickedDate);
                  }
                  remainingDays = getRemainingDays(
                      enterExpectedDate, pickedDate, calendarType);
                  if (remainingDays <= 0 || remainingDays >= TOTAL_PERIOD) {
                    Fluttertoast.showToast(
                        msg: 'يرجى إدخال تاريخ صحيح',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return;
                  }
                  setState(() {
                    myState = MyState.LOADING;
                  });
                  scheduleNotification(remainingDays);
                  await saveData(ms, calendarType);
                  setState(() {
                    myState = MyState.SHOW_DETAILS;
                  });
                }
              },
              child: Text(
                "احسب",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDetailsScreen(int remainingDaysNum) {
    String remainingDays = arNum(remainingDaysNum).toString();
    String expectedDeliveryDate =
        getExpectedDeliveryDate(remainingDaysNum, calendarType);
    String sincePregnancyStarted = getCurrentProgress(remainingDaysNum);
    scheduleNotification(remainingDaysNum);

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Image.asset('assets/images/doctor.png', width: screenWidth * 0.3),
              Container(
                width: screenWidth * 0.6,
                child: Column(
                  children: [
                    ChatBubble(
                      margin: EdgeInsets.all(10.0),
                      clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                      backGroundColor: Colors.pink.shade500.withOpacity(0.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            EXPECTED_DELIVERY_DATE,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            expectedDeliveryDate,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ChatBubble(
                      clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                      backGroundColor: Colors.pink.shade500.withOpacity(0.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'أنتِ الآن في',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Card(
                                color: Colors.pink.shade50,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'الشهر',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Card(
                                        color: Colors.pink.shade500
                                            .withOpacity(0.8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Text(
                                            NUM_TO_TEXT(((TOTAL_PERIOD -
                                                            remainingDaysNum) /
                                                        30)
                                                    .ceil() -
                                                1),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                color: Colors.pink.shade50,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'الأسبوع',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Card(
                                        color: Colors.pink.shade500
                                            .withOpacity(0.8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Text(
                                            arNum(((TOTAL_PERIOD -
                                                        remainingDaysNum) /
                                                    7)
                                                .ceil()),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 26.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                color: Colors.pink.shade50,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'اليوم',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Card(
                                        color: Colors.pink.shade500
                                            .withOpacity(0.8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Text(
                                            arNum((TOTAL_PERIOD -
                                                    remainingDaysNum))
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Card(
            color: Colors.pink.shade50,
            child: Column(
              children: [
                Text(
                  PREGNANCY_TIME,
                  style: TextStyle(
                    color: Colors.pink.shade500.withOpacity(0.8),
                  ),
                ),
                Text(
                  sincePregnancyStarted,
                  style: TextStyle(
                      color: Colors.pink.shade500.withOpacity(0.8),
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FAProgressBar(
                    currentValue: TOTAL_PERIOD - remainingDaysNum,
                    maxValue: TOTAL_PERIOD,
                    progressColor: Colors.pink.shade500.withOpacity(0.8),
                    backgroundColor: Colors.grey.shade50,
                    size: 16.0,
                    direction: Axis.horizontal,
                    animatedDuration: Duration(
                      seconds: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'المتبقي',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    color: Colors.pink.shade500.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        remainingDays + "يوم",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'بالشهور',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    color: Colors.pink.shade500.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        arNum((remainingDaysNum / 30).floor()).toString() +
                            'شهر' +
                            ' و' +
                            arNum((remainingDaysNum % 30)).toString() +
                            'يوم',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'بالأسابيع',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    color: Colors.pink.shade500.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        arNum((remainingDaysNum / 7).floor()).toString() +
                            'أسبوع' +
                            ' و' +
                            arNum((remainingDaysNum % 7)).toString() +
                            'يوم',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Card(
            color: Colors.pink.shade500.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: () {
                      CurrentPageManager.pageNumber =
                          ((TOTAL_PERIOD - remainingDaysNum) / 7).ceil();
                    },
                    child: Text(
                      'المزيد عن الأسبوع الحالي ' +
                          getCurrentProgressInWeeks(remainingDaysNum),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    myState = MyState.SHOW_MAIN_SCREEN;
                  });
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.replay,
                      size: 16.0,
                      color: Colors.grey[500],
                    ),
                    Text(
                      "إعادة الحسبة",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setInstructionText() {
    instructionText = enterExpectedDate
        ? "الرجاء ادخال التاريخ المتوقع للولادة"
        : "الرجاء ادخال اول يوم لأخر دورة شهرية";
  }

  void setCalendar() {
    yearsList = calendarType == CalendarType.Hijri
        ? getHijriYearsNumbers()
        : getYearsNumbers();
    monthsList = calendarType == CalendarType.Hijri
        ? getHijriMonthsNames()
        : getMonthsNames();
  }

  void resetDatePicker() {
    pickedDay = null;
    pickedYear = null;
    pickedMonth = null;
    daysList = null;
  }

  void checkDBForExistingData() async {
    setState(() {
      myState = MyState.LOADING;
    });
    existingDBEntry = await getMyData();

    int startDateInMS = existingDBEntry != null && existingDBEntry.isNotEmpty
        ? Map.of(existingDBEntry.last).remove(START_DATE_IN_MS_COLUMN)
        : null;

    if (startDateInMS == null) {
      setState(() {
        myState = MyState.SHOW_MAIN_SCREEN;
      });
      return;
    }
    calendarType = existingDBEntry != null && existingDBEntry.isNotEmpty
        ? Map.of(existingDBEntry.last).remove(CALENDAR_TYPE) ==
                CalendarType.Gregorian.index
            ? CalendarType.Gregorian
            : CalendarType.Hijri
        : null;

    remainingDays = Duration(
            milliseconds: Duration(days: TOTAL_PERIOD).inMilliseconds -
                (DateTime.now().millisecondsSinceEpoch - startDateInMS))
        .inDays;

    calendarType = remainingDays != null
        ? calendarTypeFromInt(
            Map.of(existingDBEntry.last).remove(CALENDAR_TYPE))
        : null;
    setState(() {
      myState = remainingDays != null
          ? MyState.SHOW_DETAILS
          : MyState.SHOW_MAIN_SCREEN;
    });
  }

  void scheduleNotification(int remainingDaysNum) async {
    NotificationManager _notificationManager = NotificationManager();
    int nxtWeekNum = ((TOTAL_PERIOD - remainingDaysNum) / 7).ceil() + 1;
    int daysTillNewWeek = 7 - (TOTAL_PERIOD - remainingDaysNum) % 7;
    if (!await _notificationManager.checkIfPendingNotificationsExist() &&
        nxtWeekNum <= 40)
      _notificationManager.createScheduledNotification(
          daysTillNewWeek, nxtWeekNum);
  }
}
