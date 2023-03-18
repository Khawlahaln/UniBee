import 'package:flutter/material.dart';
import 'package:unibeethree/driverAcc.dart';
//import 'package:unibeethree/driverProfile.dart';
import 'package:unibeethree/reports.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './adminList.dart';
import './AdminHP.dart';
import './webwelcome.dart';
import './affilateAcc.dart';
import './webwelcome.dart';
import 'login_pageweb.dart';
import 'orders.dart';
import 'reports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root
  // of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniBee',
      theme: ThemeData(fontFamily: 'Alice'),
      debugShowCheckedModeBanner: false,
      home: webwelcome(),
    );
  }
}