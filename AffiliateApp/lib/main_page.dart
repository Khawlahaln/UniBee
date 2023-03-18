import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unibeethree/appwelcome.dart';
import 'package:unibeethree/screen/AffliateHomePage.dart';
import 'package:unibeethree/screen/googleMap_Screen.dart';

import 'login_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return googleMap_Screen();
          } else {
            return appwelcome();
          }
        },
      ),
    );
  }
}
//