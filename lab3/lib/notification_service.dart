import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._private();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late AndroidInitializationSettings initializationSettingsAndroid;
  late IOSInitializationSettings initializationSettingsIOS;
  late MacOSInitializationSettings initializationSettingsMacOS;

  late InitializationSettings initializationSettings;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._private() {
    initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');
    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification:
                (int a, String? b, String? c, String? d) {});
    MacOSInitializationSettings initializationSettingsMacOS =
        const MacOSInitializationSettings();

    initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? s) async {});

    tz.initializeTimeZones();
  }

  void scheduleNotification(
      String userName, String body, DateTime dateTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'Upcoming exam for $userName',
        body,
        // replace with dateTime
        tz.TZDateTime.from(dateTime, tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails('0', 'default',
                channelDescription: 'app notifications')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void showNotification(String title, String body) {
    flutterLocalNotificationsPlugin.show(
      2,
      title,
      body,
      const NotificationDetails(
          android: AndroidNotificationDetails('0', 'default',
              channelDescription: 'app notifications')),
    );
  }
}
