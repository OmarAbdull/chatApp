// notification_helper.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? imagePath,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'chat_channel', // Channel ID
      'Chat Messages', // Channel name
      channelDescription: 'Incoming chat messages',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      ticker: 'New message received',
    );

    NotificationDetails notificationDetails = const NotificationDetails(
      android: androidNotificationDetails,
    );

    if (imagePath != null && File(imagePath).existsSync()) {
      // Create new AndroidNotificationDetails with big picture style
      final androidStyleNotification = AndroidNotificationDetails(
        'chat_channel', // Must match channel ID
        'Chat Messages', // Must match channel name
        channelDescription: 'Incoming chat messages with images',
        styleInformation: BigPictureStyleInformation(
          FilePathAndroidBitmap(imagePath),
          largeIcon: FilePathAndroidBitmap(imagePath),
          contentTitle: title,
          htmlFormatContentTitle: true,
          summaryText: body,
          htmlFormatSummaryText: true,
        ),
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        ticker: 'New image message',
      );

      notificationDetails = NotificationDetails(
        android: androidStyleNotification,
      );
    }

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
