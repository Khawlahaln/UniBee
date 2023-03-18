import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:unibeethree/screen/DriverHomePage.dart';
import 'package:unibeethree/screen/OrderRoute.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import 'affprof.dart';
import 'googleMap_Screen.dart';

class viewAffProfile extends StatefulWidget {
  const viewAffProfile({Key? key}) : super(key: key);

  @override
  State<viewAffProfile> createState() => _viewAffProfileState();
}

class _viewAffProfileState extends State<viewAffProfile> {
  final user = FirebaseAuth.instance.currentUser!.email;
  final Stream<QuerySnapshot> readRequest = FirebaseFirestore.instance
      .collection("user affiliate")
      .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  List<DocumentSnapshot> profile = [];
  int count = 0;
  String affiliateFname = "";
  String affiliateLname = "";
  String affiliateEmail = "";
  int affiliatePhone = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 850,
          child: Stack(
            children: [
              Container(
                height: 240,
                color: Color(0xFFFDD051),
              ),
              //back button
              Positioned(
                top: 58,
                left: 33,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 4.0,
                          spreadRadius: 0.25,
                          offset: Offset(0.7, 0.7),
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.black,
                      ),
                      radius: 20.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 110, bottom: 10),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "My Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff1e4845),
                      fontSize: 30,
                      fontFamily: 'Alice',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              //icon
              Positioned(
                top: 175,
                left: 133,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 4.0,
                        spreadRadius: 0.25,
                        offset: Offset(0.7, 0.7),
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 75,
                    ),
                    radius: 60.0,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                //1
                stream: readRequest,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final profile = snapshot.data!.docs;
                    count = profile.length;
                    for (var n = 0; n < profile.length; n++) {
                      affiliateFname = profile[n]['first name'];
                      affiliateLname = profile[n]['last name'];
                      affiliateEmail = profile[n]['email'];
                      affiliatePhone = profile[n]['phone'];
                    }
                    return Positioned(
                      child: Container(
                        child: Stack(
                          children: [
                            //name
                            Positioned(
                              //aff name
                              left: 125,
                              top: 315,
                              child: SizedBox(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "${affiliateFname}" +
                                      " " +
                                      "${affiliateLname}",
                                  style: TextStyle(
                                    color: Color(0xff204854),
                                    fontSize: 24,
                                    fontFamily: 'Alice',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            //contact
                            // Positioned(
                            //   top: 389,
                            //   left: 25,
                            //   child: Icon(
                            //     Icons.email_outlined,
                            //     color: Colors.black,
                            //     size: 25,
                            //   ),
                            // ),
                            Positioned(
                              top: 520,
                              left: 25,
                              child: Text(
                                "My Contact Info",
                                style: TextStyle(
                                    color: Color(0xff204854),
                                    fontSize: 20,
                                    fontFamily: 'Alice'),
                              ),
                            ),
                            Positioned(
                              top: 550,
                              left: 25,
                              right: 25,
                              child: Container(
                                width: 350,
                                height: 0,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 0.0, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            //email
                            Positioned(
                              top: 580,
                              left: 30,
                              child: Icon(
                                Icons.email_outlined,
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                            Positioned(
                              left: 65,
                              top: 580,
                              child: SizedBox(
                                width: 250,
                                height: 44,
                                child: Text(
                                  "${affiliateEmail}",
                                  style: TextStyle(
                                    color: Color(0xff3f698f),
                                    fontSize: 20,
                                    fontFamily: 'Alice',
                                  ),
                                ),
                              ),
                            ),
                            //phone
                            Positioned(
                              top: 620,
                              left: 30,
                              child: Icon(
                                Icons.call_outlined,
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                            Positioned(
                              left: 65,
                              top: 620,
                              child: SizedBox(
                                width: 250,
                                height: 44,
                                child: Text(
                                  "0" + "${affiliatePhone}",
                                  style: TextStyle(
                                    color: Color(0xff3f698f),
                                    fontSize: 20,
                                    fontFamily: 'Alice',
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 25,
                              bottom: 50,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const driverProfile()),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 27, horizontal: 160),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xff204854),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x3f000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 15,
                                        left: 110,
                                      ),
                                      child: Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 20,
                                            fontFamily: 'Alice'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    return Container();
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
