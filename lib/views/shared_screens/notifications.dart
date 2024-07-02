/* import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  void initializeNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_id', 'channel_name', 
        importance: Importance.max, priority: Priority.high);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        );
    await flutterLocalNotificationsPlugin.show(
        0, 'Notification Title', 'Notification Body', platformChannelSpecifics,
        payload: 'notification_payload');
  }

  @override
  Widget build(BuildContext context) {
    bool isSwitched = false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Page'),
      ),
      body: Center(
        child: Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
              if (isSwitched) {
                showNotification();
              }
            });
          },
        ),
      ),
    );
  }
} */