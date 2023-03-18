//import 'dart:js';

import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
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
import 'package:awesome_dialog/awesome_dialog.dart';
import 'AffliateHomePage.dart';
import 'googleMap_Screen.dart';

class previousList extends StatefulWidget {
  const previousList({Key? key}) : super(key: key);

  @override
  State<previousList> createState() => _previousListState();
}

// .where("status", isEqualTo: "completed")
//       .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
class _previousListState extends State<previousList> {
  final user = FirebaseAuth.instance.currentUser!.email;
  final Stream<QuerySnapshot> readRequest = FirebaseFirestore.instance
      .collection("orders")
      .orderBy('date', descending: true)
      .snapshots();

  var _textController = TextEditingController();
  String reportOrder = "";
  String idOfOrder = "";
  String oldReport = "";
  /*oldReport = completedOrders[i]
                                                    ["report"]
                                                .toString();*/

  //report methods

  addReport(String id, String report) async {
    // change status to ignore after the timer //better to delete
    /*for (var i = 0; i < userOrders.length; i++) {
        if (userOrders[i].data()['status'] == "waiting") {
          //userOrders[i].data()['status'].set("Ignored");
        }*/
    try {
      QuerySnapshot querySnap = await FirebaseFirestore.instance
          .collection('orders')
          .where('id', isEqualTo: id)
          .get();
      QueryDocumentSnapshot doc = querySnap.docs[
          0]; // Assumption: the query returns only one document, THE doc you of the order wanted.
      DocumentReference docRef = doc.reference;
      await docRef.set({
        'report': report,
        'reported': true,

        //'email': driveremail
      }, SetOptions(merge: true));
    } catch (err) {
      print(err);
    }
  }

  ValidatedDialog() {
    AwesomeDialog(
      context: context,
      animType: AnimType.topSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.error,
      width: 350,

      //showCloseIcon: true,

      title: "Please write the descreption as noted to submit",
      desc: "",

      body: Text(
        "Please write the descreption as noted to submit",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
      ),

      btnOkOnPress: () {},

      btnOkText: "Ok",
      btnOkColor: Color(0xFF00CA71),

      //btnOkIcon: Icons.check_circle,
      /*onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dissmiss from callback $type');
                                                  },*/
    ).show();
  }

  /*Future ReportDialog(){
    showDialog(context: context, builder: (context)=> AlertDialog(title: Text("Report an issue")) )

  }*/

  bool validated = true;
  bool pressed = true;
  color() {
    if (validated)
      return Color(0xFF00CA71);
    else
      return Color.fromARGB(255, 145, 148, 147);
  }

  ReportDialog() {
    //Future.delayed(const Duration(seconds: 60), () {

    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.warning,
      //showCloseIcon: true,
      //title: 'Report an issue',
      body: //Text("Report an issue"),
          Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Report an issue",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
            Text(
              "we apologize for any inconvenience",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
            ),
            SizedBox(
              height: 15,
            ),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                  maxLength: 100,
                  maxLines: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'^\s'))
                  ],
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      validated = false;
                      print(validated);

                      return "Description can not be empty";
                    } else if (value.length < 2) {
                      validated = false;
                      print(validated);

                      return "Minimum of two letters";
                    } else {
                      validated = true;

                      print(validated);
                    }
                  },
                  controller: _textController,
                  autofocus: true,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 247, 191, 49),
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),

                      //contentPadding: EdgeInsets.symmetric(vertical: 40.0),
                      hintText: "Enter a description about the problem here")),
            ),
          ],
        ),
      ),

      btnOk: ElevatedButton(
          child: Text("Submit"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00CA71),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),
          onPressed: () {
            if (validated && _textController.text.isNotEmpty) {
              print(validated);

              reportOrder = _textController.text;
              print(reportOrder);
              addReport(idOfOrder, reportOrder);
              Navigator.pop(context);
              ReportSent(reportOrder);
              _textController.clear();

              // ValidatedDialog();
            } else {
              print(validated);
              ValidatedDialog();
            }
          }),

      btnOkOnPress: () {},
      btnCancelOnPress: () {
        _textController.clear();
      },

      btnCancelText: "Cancel",
      btnCancelColor: Color.fromARGB(255, 202, 0, 0),

      //btnOkIcon: Icons.check_circle,
      /*onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dissmiss from callback $type');
                                                  },*/
    ).show();

    //});
  }

  ReportSent(String oldR) {
    //Future.delayed(const Duration(seconds: 60), () {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,

      //showCloseIcon: true,

      body: //Text("Report an issue"),
          Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "This order has been reported\n",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
            Text(
              "You Reported:\n",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
              ),
            ),
            Text(
              "\"$oldR\" \n",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Color.fromARGB(255, 32, 119, 162)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Thanks for letting us know",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                ),
                Center(
                  child: Icon(
                    Icons.favorite,
                    color: Color.fromARGB(255, 236, 206, 58),
                    size: 22,
                  ),
                ),
              ],
            ),
            /*SizedBox(
              height: 15,
            ),
            Text(
              "We take your words very seriously\n The appropriate actions will be taken in case of a problem",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
            ),*/
          ],
        ),
      ),

      btnOkOnPress: () {},

      btnOkText: "Ok",
      btnOkColor: Color(0xFF00CA71),

      //btnOkIcon: Icons.check_circle,
      /*onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dissmiss from callback $type');
                                                  },*/
    ).show();

    //});
  }

  _sendingSMS() async {
    var url = Uri.parse("sms: $driverPhone");
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
  String driverName = "";
  int driverPhone = 0;
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
      body: Container(
        width: 500,
        height: 900,
        color: Colors.white,
        child: Stack(
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
                  //       builder: (context) => const googleMap_Screen()),
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
                        "Previous Rides",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff4b6d76),
                          fontSize: 25,
                          fontFamily: 'Alice',
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      //1
                      stream: readRequest,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        completedOrders.clear();
                        if (snapshot.hasData) {
                          final orders = snapshot.data!.docs;
                          count = orders.length;
                          for (var j = 0; j < count; j++) {
                            if (orders[j]['status'] == "completed" &&
                                orders[j]['email'] ==
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
                                  Text("You have no rides yet...",
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
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              children: <Widget>[
                                for (int i = 0; i < completedOrders.length; i++)
                                  StreamBuilder(

                                      //3
                                      stream: FirebaseFirestore.instance
                                          .collection("drivers")
                                          .where("email",
                                              isEqualTo: completedOrders[i]
                                                  ["driverEmail"])
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!rejectList
                                            .contains(completedOrders[i].id)) {
                                          ordersList.add(completedOrders[i].id);

                                          if (snapshot.hasData) {
                                            final drivers = snapshot.data!.docs;
                                            for (var n = 0;
                                                n < drivers.length;
                                                n++) {
                                              //driver name
                                              driverName = drivers[n]
                                                      .data()['first name'] +
                                                  " " +
                                                  drivers[n]
                                                      .data()['last name'];
                                              driverPhone =
                                                  drivers[n].data()['phone'];
                                            }

                                            return Container(
                                              //insid card
                                              //width: 300,
                                              height: 184,
                                              margin: new EdgeInsets.only(
                                                  bottom: 10),
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
                                                  Positioned(
                                                    top: 20,
                                                    child: Padding(
                                                      //icon
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
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
                                                  ),
                                                  Positioned(
                                                    //aff name
                                                    left: 80,
                                                    top: 50,
                                                    child: SizedBox(
                                                      width: 250,
                                                      height: 44,
                                                      child: Text(
                                                        "${driverName}",
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
                                                    top: 75,
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
                                                                          i]
                                                                      ['date']),
                                                              // "${completedOrders[i]['date'].toDate().toString()}",
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

                                                  //Report This Trip
                                                  if (!completedOrders[i]
                                                      ["reported"])
                                                    Positioned(
                                                      left: -1,
                                                      top: -5,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          idOfOrder =
                                                              completedOrders[i]
                                                                      ["id"]
                                                                  .toString();
                                                          print(idOfOrder);
                                                          _textController
                                                              .clear();
                                                          ReportDialog();

                                                          //addReport(idOfOrder, _textController),
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              width: 110,
                                                              height: 25,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  width: 2,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          231,
                                                                          231,
                                                                          95,
                                                                          95),
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                color: Color
                                                                    .fromARGB(
                                                                        103,
                                                                        231,
                                                                        95,
                                                                        95),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 9,
                                                                      top: 2),
                                                              child: Icon(
                                                                Icons
                                                                    .assignment_late_outlined,
                                                                color: Colors
                                                                    .black,
                                                                size: 22,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 35,
                                                                      top: 3),
                                                              child: Text(
                                                                "Report",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
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

                                                  if (completedOrders[i]
                                                      ["reported"])
                                                    Positioned(
                                                      left: -1,
                                                      top: -5,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          idOfOrder =
                                                              completedOrders[i]
                                                                      ["id"]
                                                                  .toString();
                                                          print(idOfOrder);
                                                          oldReport =
                                                              completedOrders[i]
                                                                      ['report']
                                                                  .toString();
                                                          ReportSent(oldReport);
                                                          //addReport(idOfOrder, _textController),
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              width: 110,
                                                              height: 25,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  width: 2,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          238,
                                                                          122,
                                                                          119,
                                                                          119),
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                color: Color
                                                                    .fromARGB(
                                                                        122,
                                                                        122,
                                                                        119,
                                                                        119),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 9,
                                                                      top: 2),
                                                              child: Icon(
                                                                Icons
                                                                    .assignment_turned_in_outlined,
                                                                color: Colors
                                                                    .black,
                                                                size: 22,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 33,
                                                                      top: 3),
                                                              child: Text(
                                                                "Reported",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
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

                                                  //View trip route
                                                  Positioned(
                                                    left: 10,
                                                    top: 115,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        print(idOfOrder);
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
                                                                  offset:
                                                                      Offset(
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
                                                              Icons
                                                                  .location_pin,
                                                              color:
                                                                  Colors.black,
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
                                                                color: Colors
                                                                    .black,
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
                                                      onPressed: _sendingSMS,
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
                                                                  offset:
                                                                      Offset(
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
                                                              color:
                                                                  Colors.black,
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
                                                                color: Colors
                                                                    .black,
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
                                        }

                                        return Container();
                                      }),
                              ],
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
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
