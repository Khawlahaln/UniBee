import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unibeethree/forgetPassApp1.dart';
import 'package:unibeethree/main_page.dart';
import 'package:unibeethree/screen/chat.dart';

import 'package:unibeethree/screen/googleMap_Screen.dart';
import 'package:unibeethree/screen/drawerList.dart';
import 'package:unibeethree/screen/googleMap_Screen.dart';
import 'package:unibeethree/screen/previousList.dart';
import 'package:workmanager/workmanager.dart';

import 'appwelcome.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';
import 'screen/Notifications.dart';
import 'screen/viewAffProfile.dart';
import 'signupaffiliate.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'screen/globals.dart' as globals;

// //import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  /*WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);*/
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Notifications.init();
  // await initializeService();
  // FlutterBackgroundService.initialize(onStart);
  // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(const MyApp());
}

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   /// OPTIONAL, using custom notification channel id
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'my_foreground', // id
//     'MY FOREGROUND SERVICE', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.low, // importance must be at low or higher level
//   );

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   if (Platform.isIOS) {
//     await flutterLocalNotificationsPlugin.initialize(
//       const InitializationSettings(
//         iOS: DarwinInitializationSettings(),
//       ),
//     );
//   }

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will be executed when app is in foreground or background in separated isolate
//       onStart: onStart,

//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,

//       notificationChannelId: 'my_foreground',
//       initialNotificationTitle: 'AWESOME SERVICE',
//       initialNotificationContent: 'Initializing',
//       foregroundServiceNotificationId: 888,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: true,

//       // this will be executed when app is in foreground in separated isolate
//       onForeground: onStart,

//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );

//   service.startService();
// }

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();

//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.reload();
//   final log = preferences.getStringList('log') ?? <String>[];
//   log.add(DateTime.now().toIso8601String());
//   await preferences.setStringList('log', log);

//   return true;
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   // Only available for flutter 3.0.0 and later
//   DartPluginRegistrant.ensureInitialized();
//   Firebase.initializeApp();
//   // For flutter prior to version 3.0.0
//   // We have to register the plugin manually

//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.setString("hello", "world");

//   /// OPTIONAL when use custom notification
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });

//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }

//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

//   // bring to foreground
//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         /// OPTIONAL for use custom notification
//         /// the notification id must be equals with AndroidConfiguration when you call configure() method.
//         flutterLocalNotificationsPlugin.show(
//           888,
//           'COOL SERVICE',
//           'Awesome ${DateTime.now()}',
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'my_foreground',
//               'MY FOREGROUND SERVICE',
//               icon: 'ic_bg_service_small',
//               ongoing: true,
//             ),
//           ),
//         );

//         // if you don't using custom notification, uncomment this
//         // service.setForegroundNotificationInfo(
//         //   title: "My App Service",
//         //   content: "Updated at ${DateTime.now()}",
//         // );
//       }
//     }

//     /// you can see this log in logcat
//     print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     print(globals.id + "hhhhhhhhhhhh");

//     // try {
//     //   await FirebaseFirestore.instance
//     //       .collection('orders')
//     //       .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
//     //       .where('status', isEqualTo: "waiting")
//     //       .get()
//     //       .then((snapshot) async {
//     //     if (snapshot.docs.first['status'] == "waiting") {
//     //       if (globals.id != snapshot.docs.first['id']) {
//     //         globals.id = snapshot.docs.first['id'];
//     //       }
//     //     }
//     //   });
//     // } catch (e) {}
//     // try {
//     //   await FirebaseFirestore.instance
//     //       .collection('orders')
//     //       .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
//     //       .where('status', isEqualTo: "accepted")
//     //       .get()
//     //       .then((snapshot) async {
//     //     if (snapshot.docs.first['status'] == "accepted") {
//     //       if (globals.id != snapshot.docs.first['id']) {
//     //         globals.id = snapshot.docs.first['id'];
//     //       }
//     //     }
//     //   });
//     // } catch (e) {}
//     // try {
//     //   await FirebaseFirestore.instance
//     //       .collection('orders')
//     //       .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
//     //       .where('status', isEqualTo: "arrived")
//     //       .get()
//     //       .then((snapshot) async {
//     //     if (snapshot.docs.first['status'] == "arrived") {
//     //       if (globals.id != snapshot.docs.first['id']) {
//     //         globals.id = snapshot.docs.first['id'];
//     //       }
//     //     }
//     //   });
//     // } catch (e) {}
//     // try {
//     //   await FirebaseFirestore.instance
//     //       .collection('orders')
//     //       .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
//     //       .where('id', isEqualTo: globals.id)
//     //       .get()
//     //       .then((snapshot) async {
//     //     if (globals.id != null &&
//     //         snapshot.docs.first['status'] == "accepted" &&
//     //         snapshot.docs.first['notificationStatus'] == "waiting") {
//     //       Notifications.showNotification(
//     //         title: 'Order accepted',
//     //         body: 'Your order has been accepted',
//     //       );
//     //       preferences.setBool('notifiedAccepted', true);
//     //       snapshot.docs.first.reference.update({
//     //         'notificationStatus': "accepted",
//     //       });
//     //     } else if (globals.id != null &&
//     //         snapshot.docs.first['status'] == "arrived" &&
//     //         snapshot.docs.first['notificationStatus'] == "accepted") {
//     //       Notifications.showNotification(
//     //         title: 'Driver arrived',
//     //         body:
//     //             'Your driver has arrived at your location', //the driver has come to you
//     //         //payload: 'sarah.abs',
//     //       );
//     //       preferences.setBool('notifiedArrived', true);
//     //       snapshot.docs.first.reference.update({
//     //         'notificationStatus': "arrived",
//     //       });
//     //     } else if (globals.id != null &&
//     //         snapshot.docs.first['status'] == "completed" &&
//     //         snapshot.docs.first['notificationStatus'] == "arrived") {
//     //       print(snapshot.docs.first['notificationStatus'].toString());
//     //       Notifications.showNotification(
//     //         title: 'Order completed',
//     //         body: 'You have arrived to your destination',
//     //       );
//     //       preferences.setBool('notifiedCompleted', true);
//     //       snapshot.docs.first.reference.update({
//     //         'notificationStatus': "completed",
//     //       });
//     //     }
//     //   });
//     // } catch (e) {}

//     // String driverName = preferences.getBool('firstTime') == null ||
//     //         preferences.getBool('firstTime') == true
//     //     ? "No driver"
//     //     : preferences.getString('driverName').toString();
//     // if (FirebaseAuth.instance.currentUser != null) {
//     //   try {
//     //     await FirebaseFirestore.instance
//     //         .collection('messages')
//     //         .where('receiver',
//     //             isEqualTo: FirebaseAuth.instance.currentUser!.email)
//     //         .where('status', isEqualTo: "new")
//     //         .get()
//     //         .then((snapshot) async {
//     //       Notifications.showNotification(
//     //         title: driverName,
//     //         body: snapshot.docs.first['text'],
//     //       );

//     //       snapshot.docs.first.reference.update({
//     //         'status': "old",
//     //       });
//     //     });
//     //   } catch (e) {}
//     // }
//     // if (preferences.getString('orderStatus') == "arrived" &&
//     //     preferences.getBool('notifiedArrived') == false)
//     //   Notifications.showNotification(
//     //     title: 'Driver arrived',
//     //     body:
//     //         'Your driver has arrived at your location', //the driver has come to you
//     //     //payload: 'sarah.abs',
//     //   );
//     // test using external plugin
//     final deviceInfo = DeviceInfoPlugin();
//     String? device;
//     if (Platform.isAndroid) {
//       final androidInfo = await deviceInfo.androidInfo;
//       device = androidInfo.model;
//     }

//     if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       device = iosInfo.model;
//     }

//     service.invoke(
//       'update',
//       {
//         "current_date": DateTime.now().toIso8601String(),
//         "device": device,
//       },
//     );
//   });
// }

// Future<String> _getSharedValue() async {
//   const defaultText = "no driver";
//   String ret;
//   var prefs = await SharedPreferences.getInstance();
//   bool? isFirstTime = prefs.getBool('firstTime');
//   print(isFirstTime);

//   ret = ((isFirstTime == null || isFirstTime == true)
//       ? defaultText
//       : prefs.getString('driverName'))!;
//   print(ret);

//   return ret;
// }
// String changer = 'game_changer';
// void onStart() {
//   WidgetsFlutterBinding.ensureInitialized();
//   final service = FlutterBackgroundService();

//   service.onDataReceived.listen((event) {
//     if (event.containskey('action')) {
//       changer = 'game _changerd';
//       return;
//     }
//   });
// }

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
        'signup': (context) => SignupPage(),
        'signin': (context) => LoginPage(),
        'forget': (context) => forgetPassApp1(),
        'home': (context) => googleMap_Screen(),
        'rides': (context) => previousList(),
        'profile': (context) => viewAffProfile(),
        'chat': (context) => chatScreen(),
      },
    );
  }
}
