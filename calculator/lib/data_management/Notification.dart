import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationAPI {
  static late FlutterLocalNotificationsPlugin _notificationsPlugin;
  static late AndroidInitializationSettings _androidSettings;
  static late IOSInitializationSettings _iosSettings;
  static late InitializationSettings _initSettings;
  static late AndroidNotificationDetails _androidNotificationDetails;
  static late IOSNotificationDetails _iosNotificationDetails;
  static late NotificationDetails _notificationDetails;

  static Future init({bool initScheduled = false}) async {
    // Initialize time
    if (initScheduled) {
      tz.initializeTimeZones();
      final location = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(location));
    }

    // Initializing plugin and settings
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    _androidSettings = const AndroidInitializationSettings('app icon');
    _iosSettings = const IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    _initSettings =
        InitializationSettings(android: _androidSettings, iOS: _iosSettings);
    await _notificationsPlugin.initialize(_initSettings,
        onSelectNotification: selectNotification);

    // Configuring notification details
    _androidNotificationDetails = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    _iosNotificationDetails = const IOSNotificationDetails();
    _notificationDetails = NotificationDetails(
        android: _androidNotificationDetails, iOS: _iosNotificationDetails);
  }

  // Show notification when called
  static simpleNotifications(
      {int id = 0, String? title, String? body, String? payload}) async {
    _notificationsPlugin.show(id, title, body, _notificationDetails,
        payload: 'payload');
  }

  // Show notification at specific time
  static scheduledNotifications(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduleDate}) async {
    _notificationsPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(scheduleDate, tz.local), _notificationDetails,
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  // Show notification at specified time on specified days
  static weeklyNotifications(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required List<bool> scheduleDays,
      required DateTime scheduleTime}) async {
    // Cancel previous notifications
    _notificationsPlugin.cancelAll();

    // Fit time
    var fittedTime = _scheduleDaily(scheduleTime);

    // IMPORTANT! notification id must be unique!!!!!
    for (int id = 0; id < 7; id++) {
      if (scheduleDays[fittedTime.weekday - 1]) {
        await _notificationsPlugin.zonedSchedule(
            id, title, body, fittedTime, _notificationDetails,
            payload: payload,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
      }
      fittedTime = fittedTime.add(const Duration(days: 1));
    }
  }

  // Schedule for same day or the next!
  static tz.TZDateTime _scheduleDaily(DateTime time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    return scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;
  }

  // Wyen user taps the notification for IOS
  static void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) {
    return;
  }

  // When user taps the notification for ANDRIOD
  static void selectNotification(String? payload) {
    return;
  }
}
