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

class previousList extends StatefulWidget {
  const previousList({Key? key}) : super(key: key);

  @override
  State<previousList> createState() => _previousListState();
}

// .where("status", isEqualTo: "completed")
// .where("driverEmail", isEqualTo: FirebaseAuth.instance.currentUser!.email)
class _previousListState extends State<previousList> {
  final user = FirebaseAuth.instance.currentUser!.email;
  final Stream<QuerySnapshot> readRequest = FirebaseFirestore.instance
      .collection("orders")
      .orderBy('date', descending: true)
      .snapshots();

  _sendingSMS() async {
    var url = Uri.parse("sms: $affiliatePhone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd MMM, yyyy  hh:mm a').format(dateFromTimeStamp);
  }

  int count = 0;
  String affiliateName = "";
  int affiliatePhone = 0;
  var orderDate;
  List<DocumentSnapshot> orders = [];
  List<String> rejectList = [];
  List<String> ordersList = [];
  List<QueryDocumentSnapshot<Object?>> rejected = [];
  List<DocumentSnapshot> completedOrders = [];
  int m = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // SingleChildScrollView(
          //   child:
          Container(
        //child: Container(//
        width: 500,
        height: 900,
        color: Colors.white,
        child: Stack(
          // alignment: AlignmentDirectional.topCenter,
          // clipBehavior: Clip.none,
          children: [
            //back button
            Positioned(
              top: 55,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const DriverHomePage()),
                  // );
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
                    backgroundColor: Color(0xFFFDD051),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.black,
                    ),
                    radius: 20.0,
                  ),
                ),
              ),
            ),

            Container(
              height: 900,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 130, bottom: 10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Previous Trips",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff4b6d76),
                          fontSize: 25,
                          fontFamily: 'Alice',
                        ),
                      ),
                    ),
                  ),
                  //Exmpanded(
                  // child:
                  StreamBuilder<QuerySnapshot>(
                      //1
                      stream: readRequest,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        //orders.sort(((a, b) => a.data()['date']);
                        completedOrders.clear();
                        if (snapshot.hasData) {
                          final orders = snapshot.data!.docs;
                          count = orders.length;
                          for (var j = 0; j < count; j++) {
                            if (orders[j]['status'] == "completed" &&
                                orders[j]['driverEmail'] ==
                                    FirebaseAuth.instance.currentUser!.email) {
                              completedOrders.add(orders[j]);
                            }
                          }
                          if (completedOrders.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/up page.png'),
                                  Text("You have no trips yet...",
                                      style: GoogleFonts.alice(
                                          fontSize: 15, color: Colors.black)),
                                ],
                              ),
                            );
                          }

                          return Expanded(
                            child: ListView(
                              //reverse: true,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 40, horizontal: 20), //card postion
                              scrollDirection: Axis.vertical,
                              //physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              children: <Widget>[
                                for (int i = 0; i < completedOrders.length; i++)
                                  StreamBuilder(
                                      //3
                                      stream: FirebaseFirestore.instance
                                          .collection("user affiliate")
                                          .where("email",
                                              isEqualTo: completedOrders[i]
                                                  ["email"])
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        // if (!rejectList
                                        //     .contains(completedOrders[i].id)) {
                                        //   ordersList.add(completedOrders[i].id);
                                        if (snapshot.hasData) {
                                          final affiliates =
                                              snapshot.data!.docs;

                                          //aff name
                                          final affiliateName = affiliates[0]
                                                  .data()['first name'] +
                                              " " +
                                              affiliates[0].data()['last name'];
                                          final affiliatePhone =
                                              affiliates[0].data()['phone'];

                                          return Container(
                                            //insid card
                                            //width: 300,
                                            height: 184,
                                            margin:
                                                new EdgeInsets.only(bottom: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Color(0x7fd9d9d9),
                                                width: 1,
                                              ),
                                              color: Color(0x7fd9d9d9),
                                            ),
                                            child: Stack(
                                              children: <Widget>[
                                                Padding(
                                                  //icon
                                                  padding:
                                                      const EdgeInsets.all(13),
                                                  child: Container(
                                                      child: CircleAvatar(
                                                    backgroundColor:
                                                        Color(0xFFFDD051),
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Colors.black,
                                                      size: 45,
                                                    ),
                                                    radius: 27.0,
                                                  )),
                                                ),
                                                Positioned(
                                                  //aff name
                                                  left: 80,
                                                  top: 30,
                                                  child: SizedBox(
                                                    width: 250,
                                                    height: 44,
                                                    child: Text(
                                                      "${affiliateName}",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff204854),
                                                        fontSize: 20,
                                                        fontFamily: 'Alice',
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                /////date postion
                                                Positioned(
                                                  left: 80,
                                                  top: 64,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .calendar_month_sharp,
                                                        color: Colors.black,
                                                        size: 23,
                                                      ),
                                                      SizedBox(
                                                        width: 290,
                                                        height: 44,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 12,
                                                                  left: 5),
                                                          child: Text(
                                                            formattedDate(
                                                                completedOrders[
                                                                    i]['date']),
                                                            //"${orders[i]['date']}",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff3f698f),
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'Alice',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                //buttons
                                                //View trip route
                                                Positioned(
                                                  left: 10,
                                                  top: 115,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return OrderRoute(
                                                              order:
                                                                  completedOrders[
                                                                      i]);
                                                        },
                                                      );
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 150,
                                                          height: 35,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            color: Color(
                                                                0xffb9d4d3),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0x3f000000),
                                                                blurRadius: 4,
                                                                offset: Offset(
                                                                    0, 4),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 4,
                                                                  top: 4),
                                                          child: Icon(
                                                            Icons.location_pin,
                                                            color: Colors.black,
                                                            size: 25,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 33,
                                                                  top: 8),
                                                          child: Text(
                                                            "View trip route",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Alice',
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                //Send message
                                                Positioned(
                                                  right: 10,
                                                  top: 115,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      launchUrl(Uri.parse(
                                                          "sms: $affiliatePhone"));
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 150,
                                                          height: 35,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            color: Color(
                                                                0xffb9d4d3),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0x3f000000),
                                                                blurRadius: 4,
                                                                offset: Offset(
                                                                    0, 4),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  top: 7),
                                                          child: Icon(
                                                            Icons.message,
                                                            color: Colors.black,
                                                            size: 25,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 40,
                                                                  top: 8),
                                                          child: Text(
                                                            "Send message",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Alice',
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }

                                        // return Container();
                                      }),
                              ],
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                  //),
                ],
              ),
            ),
            // ),
          ],
        ),
        // ),
        //),
      ),
      //),
    );
  }
}
