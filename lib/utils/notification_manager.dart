import 'package:HamilGuide/utils/weeks_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../constants.dart';
import '../main.dart';

class NotificationManager {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationManager() {
    initNotifications();
    tz.initializeTimeZones();
  }

  Future<void> initNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        runApp(HamilGuide());
        int week = int.parse(payload);
        CurrentPageManager.pageNumber = week;
        return;
      },
    );
  }

  Future<bool> checkIfPendingNotificationsExist() async {
    List<PendingNotificationRequest> pendingNotifications =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

    return pendingNotifications.isEmpty ? false : true;
  }

  Future<void> createScheduledNotification(int afterDays, int week) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(NOTIFICATION_CHANNEL_ID,
            NOTIFICATION_CHANNEL_NAME, NOTIFICATION_CHANNEL_DESCRIPTION,
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        SCHEDULED_NOTIFICATION_ID,
        'الأسبوع $week',
        'أنتِ الآن في الأسبوع $week من الحمل .. اقرأي معلومات ونصائح عن هذا الأسبوع',
        tz.TZDateTime.now(tz.local).add(Duration(days: afterDays)),
        const NotificationDetails(android: androidPlatformChannelSpecifics),
        androidAllowWhileIdle: true,
        payload: week.toString(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    final dynamic notification = message['notification'];
  }
}

void configureFireBaseMessaging() {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging.requestNotificationPermissions();
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    },
    onBackgroundMessage: myBackgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    },
  );
}
