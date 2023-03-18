import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:unibeethree/appwelcome.dart';
import 'package:unibeethree/screen/DriverHomePage.dart';
import 'package:unibeethree/screen/previousList.dart';
import 'package:unibeethree/signupdriver.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'forgetPassApp1.dart';
import 'login_pageDriver.dart';
import 'main_page.dart';
import 'screen/Notifications.dart';
import 'screen/RequestList.dart';
import 'screen/chat.dart';
import 'screen/viewDriverProfile.dart';

//import 'package:flutter_native_splash/flutter_native_splash.dart';
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message ${message.messageId}');
//   print(message.data);
//   flutterLocalNotificationsPlugin.show(
//       message.data.hashCode,
//       message.data['title'],
//       message.data['body'],
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           // channel.description,
//         ),
//       ));
// }

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   // 'This channel is used for important notifications.', // description
//   importance: Importance.high,
// );

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
Future<void> main() async {
  /*WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);*/
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Notifications.init();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MainPage(),
      routes: {
        'welcome': (context) => appwelcome(),
        'signup': (context) => SignupPageDriver(),
        'signin': (context) => LoginPageDriver(),
        'forget': (context) => forgetPassApp1(),
        'home': (context) => DriverHomePage(),
        'profile': (context) => viewDriverProfile(),
        'trips': (context) => previousList(),
        // 'chat': (context) => chatScreen(),
      },
    );
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // String? token;
//   // List subscribed = [];
//   // List topics = [
//   //   'Samsung',
//   //   'Apple',
//   //   'Huawei',
//   //   'Nokia',
//   //   'Sony',
//   //   'HTC',
//   //   'Lenovo'
//   // ];
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   var initialzationSettingsAndroid =
//   //       AndroidInitializationSettings('@mipmap/ic_launcher');
//   //   var initializationSettings =
//   //       InitializationSettings(android: initialzationSettingsAndroid);

//   //   // flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   //     RemoteNotification? notification = message.notification;
//   //     AndroidNotification? android = message.notification?.android;
//   //     if (notification != null && android != null) {
//   //       flutterLocalNotificationsPlugin.show(
//   //           notification.hashCode,
//   //           notification.title,
//   //           notification.body,
//   //           NotificationDetails(
//   //             android: AndroidNotificationDetails(
//   //               channel.id,
//   //               channel.name,
//   //               // channel.description,
//   //               icon: android.smallIcon,
//   //             ),
//   //           ));
//   //     }
//   //   });
//   //   getToken();
//   //   getTopics();
//   // }

//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   getToken();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       home: MainPage(),
//       routes: {
//         'welcome': (context) => appwelcome(),
//         'signup': (context) => SignupPageDriver(),
//         'signin': (context) => LoginPageDriver(),
//         'forget': (context) => forgetPassApp1(),
//         'home': (context) => DriverHomePage(),
//         'trips': (context) => previousList(),
//         // 'chat': (context) => chatScreen(),
//       },
//     );
//   }

//   // getToken() async {
//   //   token = (await FirebaseMessaging.instance.getToken())!;
//   //   setState(() {
//   //     token = token;
//   //   });
//   //   print(token);
//   // }

//   // getTopics() async {
//   //   await FirebaseFirestore.instance
//   //       .collection('topics')
//   //       .get()
//   //       .then((value) => value.docs.forEach((element) {
//   //             if (token == element.id) {
//   //               subscribed = element.data().keys.toList();
//   //             }
//   //           }));

//   //   setState(() {
//   //     subscribed = subscribed;
//   //   });
//   // }
// }
