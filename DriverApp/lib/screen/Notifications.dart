import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:unibeethree/screen/DriverHomePage.dart';
import 'package:timezone/timezone.dart';

class Notifications {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id 7',
        'channel name',
        //   'channel description',
        //importance: Importance.max,
        playSound: false,
      ),
      iOS: DarwinNotificationDetails(
        presentSound: true,
        //presentAlert: false,
        //presentBadge: false,
        //subtitle: 'UniBee',
        //categoryIdentifier: 'UniBee',
        //threadIdentifier: 'UniBee',
      ),
    );
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = DarwinInitializationSettings();
    final settings = InitializationSettings(
      android: android,
      iOS: iOS,
    );

    //when app closed
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      // onNotifications.add(details.payload);
    }

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) async {
        // onNotifications.add(payload);
      },
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );
}
