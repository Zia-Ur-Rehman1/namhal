//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// @override
// void initState() {
//   var initializationSettingsAndroid =
//   new AndroidInitializationSettings('@mipmap/ic_launcher');
//   var initializationSettingsIOS = new IOSInitializationSettings();
//   var initializationSettings = new InitializationSettings(
//       initializationSettingsAndroid, initializationSettingsIOS);
//   flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onSelectNotification: onSelectNotification);
//   _firebaseMessaging.configure(
//     onMessage: (Map<String, dynamic> message) async {
//       showNotification(
//           message['notification']['title'], message['notification']['body']);
//       print("onMessage: $message");
//     },
//     onLaunch: (Map<String, dynamic> message) async {
//       print("onLaunch: $message");
//       Navigator.pushNamed(context, '/notify');
//     },
//     onResume: (Map<String, dynamic> message) async {
//       print("onResume: $message");
//     },
//   );
// }
// Future onSelectNotification(String payload) async {
//   showDialog(
//     context: context,
//     builder: (_) {
//       return new AlertDialog(
//         title: Text("PayLoad"),
//         content: Text("Payload : $payload"),
//       );
//     },
//   );
// }
// void showNotification(String title, String body) async {
//   await _demoNotification(title, body);
// }
//
// Future<void> _demoNotification(String title, String body) async {
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'channel_ID', 'channel name', 'channel description',
//       importance: Importance.Max,
//       playSound: true,
//       sound: 'sound',
//       showProgress: true,
//       priority: Priority.High,
//       ticker: 'test ticker');
//
//   var iOSChannelSpecifics = IOSNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(
//       androidPlatformChannelSpecifics, iOSChannelSpecifics);
//   await flutterLocalNotificationsPlugin
//       .show(0, title, body, platformChannelSpecifics, payload: 'test');
// }