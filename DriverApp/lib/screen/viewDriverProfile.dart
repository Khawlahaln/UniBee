import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
import 'package:unibeethree/screen/driverProfile.dart';
import 'package:unibeethree/screen/password.dart';
import 'package:url_launcher/url_launcher.dart';

import '../commonFunctions.dart';
import 'Notifications.dart';
import 'driverProfile.dart';

class viewDriverProfile extends StatefulWidget {
  const viewDriverProfile({Key? key}) : super(key: key);

  @override
  State<viewDriverProfile> createState() => _viewDriverProfileState();
}

class _viewDriverProfileState extends State<viewDriverProfile> {
  final user = FirebaseAuth.instance.currentUser!.email;

  final Stream<QuerySnapshot> readRequest = FirebaseFirestore.instance
      .collection("drivers")
      .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();
  final _firestore = FirebaseFirestore.instance
      .collection('Notifications')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  List<DocumentSnapshot> profile = [];
  int count = 0;
  String driverFname = "";
  String driverLname = "";
  String driverEmail = "";
  int drivePhone = 0;
  String driverCarId = "";
  double rate = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 850,
          child: Stack(
            children: [
              Container(
                height: 220,
                color: Color(0xFFFDD051),
              ),
              //back button
              Positioned(
                top: 58,
                left: 33,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DriverHomePage()),
                    );
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
                padding: const EdgeInsets.only(top: 90, bottom: 10),
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
              // StreamBuilder<QuerySnapshot>(
              //     stream: _firestore
              //         .collection('Notifications')
              //         .where('email', isEqualTo: driverEmail)
              //         .snapshots(),
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData) {
              //         final mes = snapshot.data!.docs;
              //         return

              StreamBuilder<QuerySnapshot>(
                  stream: _firestore,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final mes = snapshot.data!.docs;

                      return mes.isEmpty || mes[0]['read'] == true
                          ? Container()
                          : Positioned(
                              top: 58,
                              right: 33,
                              child: GestureDetector(
                                onTap: () {
                                  showNotificationDialog(context, driverEmail);

                                  print(driverEmail);
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
                                      Icons.notifications,
                                      color: Colors.red,
                                    ),
                                    radius: 20.0,
                                  ),
                                ),
                              ),
                            );
                    }
                    return Container();
                  }),
              // Positioned(
              //   top: 58,
              //   right: 33,
              //   child: GestureDetector(
              //     onTap: () {
              //       showNotificationDialog(context, driverEmail);
              //       print(driverEmail);
              //     },
              //     child: Container(
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(22.0),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black,
              //             blurRadius: 4.0,
              //             spreadRadius: 0.25,
              //             offset: Offset(0.7, 0.7),
              //           )
              //         ],
              //       ),
              //       child: StreamBuilder<QuerySnapshot>(
              //           stream: _firestore,
              //           // .collection('Notifications')
              //           // .where('email', isEqualTo: driverEmail)
              //           // .snapshots(),
              //           builder: (context, snapshot) {
              //             if (snapshot.hasData) {
              //               final mes = snapshot.data!.docs;

              //               return CircleAvatar(
              //                 backgroundColor: Colors.white,
              //                 child: Icon(
              //                   Icons.notifications,
              //                   color: mes.isEmpty || mes[0]['read'] == true
              //                       ? Colors.black
              //                       : Colors.red,
              //                 ),
              //                 radius: 20.0,
              //               );
              //             }
              //             return Container();
              //           }),
              //     ),
              //   ),
              // ),
              //     ;
              //   }
              //   return Container();
              // }),

              //icon
              Positioned(
                top: 155,
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
                      driverFname = profile[n]['first name'];
                      driverLname = profile[n]['last name'];
                      driverEmail = profile[n]['email'];
                      drivePhone = profile[n]['phone'];
                      driverCarId = profile[n]['GolfCarId'];
                    }
                    return Positioned(
                      child: Container(
                        height: 800,
                        child: Stack(
                          children: [
                            //name
                            Positioned(
                              left: 110,
                              top: 295,
                              child: SizedBox(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "${driverFname}" + " " + "${driverLname}",
                                  style: TextStyle(
                                    color: Color(0xff204854),
                                    fontSize: 24,
                                    fontFamily: 'Alice',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 310,
                              left: 20,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('orders')
                                      .where('driverEmail',
                                          isEqualTo: driverEmail)
                                      .where('status', isEqualTo: "completed")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Stack(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .90,
                                            height: 70.0,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: const Color(0xFFFFFF),
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(32.0)),
                                            ),
                                            child: Center(
                                              child: RatingBarIndicator(
                                                rating: 0,
                                                itemSize: 25,
                                                direction: Axis.horizontal,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 0.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 115,
                                            child: Text(
                                              "0",
                                              style: TextStyle(
                                                color: Color(0xff204854),
                                                fontSize: 22,
                                                fontFamily: 'Alice',
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 20,
                                            left: 195,
                                            child: Text(
                                              "(0)",
                                              style: TextStyle(
                                                color: Color(0xff204854),
                                                fontSize: 22,
                                                fontFamily: 'Alice',
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }

                                    final _data = snapshot.data?.docs;
                                    double total = 0, length = 0;
                                    for (var data in _data!) {
                                      if (data.get("rating") != 0) {
                                        length++;
                                        total += data.get("rating") as double;
                                      }
                                    }

                                    rate = length == 0 ? 0.0 : (total / length);
                                    return Stack(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .90,
                                          height: 120.0,
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: const Color(0xFFFFFF),
                                            borderRadius: new BorderRadius.all(
                                                new Radius.circular(32.0)),
                                          ),
                                          child: Center(
                                            child: RatingBarIndicator(
                                              rating: length == 0
                                                  ? 0.0
                                                  : (total / length),
                                              itemSize: 25,
                                              direction: Axis.horizontal,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 0.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 163,
                                          top: 20,
                                          child: Text(
                                            _data.isEmpty || length == 0
                                                ? "0"
                                                : (total / length)
                                                    .toStringAsFixed(1),
                                            style: TextStyle(
                                              color: Color(0xff204854),
                                              fontSize: 22,
                                              fontFamily: 'Alice',
                                              //fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 80,
                                          left: 142,
                                          child: Text(
                                            _data.isEmpty
                                                ? "0"
                                                : "(" +
                                                    length.toStringAsFixed(0) +
                                                    " Ratings)",
                                            style: TextStyle(
                                              color: Color(0xff3f698f),
                                              fontSize: 15,
                                              fontFamily: 'Alice',
                                              //fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                            ),

                            //golf car id
                            Positioned(
                              top: 449,
                              left: 25,
                              child: Text(
                                "Golf Car ID",
                                style: TextStyle(
                                    color: Color(0xff204854),
                                    fontSize: 20,
                                    fontFamily: 'Alice'),
                              ),
                            ),
                            // Positioned(
                            //   left: 285,
                            //   top: 389,
                            //   child: SizedBox(
                            //     width: 250,
                            //     height: 44,
                            //     child: Text(
                            //       "${driverCarId}",
                            //       style: TextStyle(
                            //         color: Color(0xff204854),
                            //         fontSize: 20,
                            //         fontFamily: 'Alice',
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Positioned(
                              top: 480,
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
                            Positioned(
                              left: 45,
                              top: 500,
                              child: SizedBox(
                                width: 250,
                                height: 44,
                                child: Text(
                                  "${driverCarId}",
                                  style: TextStyle(
                                    color: Color(0xff3f698f),
                                    fontSize: 20,
                                    fontFamily: 'Alice',
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              top: 570,
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
                              top: 600,
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
                              top: 620,
                              left: 30,
                              child: Icon(
                                Icons.email_outlined,
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
                                  "${driverEmail}",
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
                              top: 665,
                              left: 30,
                              child: Icon(
                                Icons.call_outlined,
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                            Positioned(
                              left: 65,
                              top: 665,
                              child: SizedBox(
                                width: 250,
                                height: 44,
                                child: Text(
                                  "0" + "${drivePhone}",
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
                              bottom: 0,
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
                                        left: 105,
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
