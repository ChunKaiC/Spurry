import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_permissions/notification_permissions.dart';
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
  static late PermissionStatus permission;

  static Future init({bool initScheduled = false}) async {
    permission =
        await NotificationPermissions.getNotificationPermissionStatus();
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

  static updatePermission() async {
    permission =
        await NotificationPermissions.getNotificationPermissionStatus();
  }

  // Show notification at specified time on specified days
  static weeklyNotifications(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduleTime}) async {
    // Fit time
    var fittedTime = _scheduleDaily(scheduleTime);

    // IMPORTANT! notification id must be unique!!!!!
    await _notificationsPlugin.zonedSchedule(
        id, title, body, fittedTime, _notificationDetails,
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
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

  static cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  static cancel(int id) async {
    await _notificationsPlugin.cancel(id);
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
