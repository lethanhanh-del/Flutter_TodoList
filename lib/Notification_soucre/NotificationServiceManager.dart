import 'dart:io';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationServiceManager
{
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static final NotificationServiceManager _instance = NotificationServiceManager._internal();
  bool _isNotificationReady = false;

  NotificationServiceManager._internal();

  factory NotificationServiceManager() {
    return _instance;
  }

  Future<void> init() async {
    if (_isNotificationReady) return;

    if (Platform.isAndroid) {
      // Request Permissions for Android 13+
      await _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
      await _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestExactAlarmsPermission();
    } else if (Platform.isIOS) {
      await _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    var androidSetting = AndroidInitializationSettings(
        '@mipmap/ic_launcher'
    );

    var iOSSetting = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initSettings = InitializationSettings(
      android: androidSetting,
      iOS: iOSSetting,
    );

    await _notifications.initialize(initSettings);

    // Cần thiết để chạy scheduled notification
    initializeTimeZones();

    _isNotificationReady = true;
  }

  NotificationDetails getNotificationDetail({required String channelId, required String channelName, String? channelDescription})
  {
    NotificationDetails notificationDetails = NotificationDetails(
      android: _getAndroidNotificationDetails(
          channelId: channelId,
          channelName: channelName,
          channelDescription: channelDescription
      ),
      iOS: _getIosNotificationDetails(
          channelId: channelId
      ),
    );

    return notificationDetails;
  }

  AndroidNotificationDetails _getAndroidNotificationDetails({required String channelId, required String channelName, String? channelDescription}) {
    return AndroidNotificationDetails(
      channelId,    // (**1)
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      playSound: true,
      enableVibration: true,
      showWhen: true,
    );
  }

  DarwinNotificationDetails _getIosNotificationDetails({required String channelId}) {
    return DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentBanner: true,
      presentList: true,
      presentSound: true,
      threadIdentifier: channelId,
    );
  }

  Future<void> show({
    required String title,
    required String body,
    required NotificationDetails notificationDetails,
  }) async
  {
    await _notifications.show(
        Random().nextInt(9999),     // (**2)
        title,
        body,
        notificationDetails
    );
  }

  Future<void> showDelay({
    required String title,
    required String body,
    required NotificationDetails notificationDetails,
    required Duration delayTime,
  }) async
  {
    tz.TZDateTime scheduledTime = tz.TZDateTime.now(tz.local).add(delayTime);
    await _notifications.zonedSchedule(
      Random().nextInt(9999),
      title,
      body,
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexact,
    );
  }
}