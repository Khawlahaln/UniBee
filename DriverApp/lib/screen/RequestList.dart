import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:collection';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unibeethree/screen/DriverHomePage.dart';
import 'package:unibeethree/screen/OrderRoute.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'BadgeIcon.dart';
import 'affiliateInfo.dart';
import 'chat.dart';
import 'globals.dart' as globals;

class RequestList extends StatefulWidget {
  const RequestList({Key? key}) : super(key: key);

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  List messages = [];
  String? messageText;

  String affiliateName = "";
  String affiliateEmail = "";
  final user = FirebaseAuth.instance.currentUser!.email;
  final Stream<QuerySnapshot> readRequest = FirebaseFirestore.instance
      .collection("orders")
      .where("status", isEqualTo: "waiting")
      .snapshots();

  final Stream<QuerySnapshot> readOngoing = FirebaseFirestore.instance
      .collection("orders")
      .orderBy("date", descending: true)
      // .where("status", isEqualTo: "accepted")
      // .where("driverEmail", isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  final Stream<QuerySnapshot> readArrived = FirebaseFirestore.instance
      .collection("orders")
      .orderBy("date", descending: true)
      // .where("status", isEqualTo: "arrived")
      // .where("driverEmail", isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  int onLimit = 0;

  //////////count ongoing//////////////
  // final user1 = FirebaseAuth.instance.currentUser!;

  // Future<int> countDocuments() async {
  //   QuerySnapshot _myDocarrived = await FirebaseFirestore.instance
  //       .collection('orders')
  //       .where('driverEmail', isEqualTo: user1.email)
  //       .where('status', isEqualTo: "arrived")
  //       .get();
  //   List<DocumentSnapshot> _myDocCountarrived = _myDocarrived.docs;
  //   print(_myDocCountarrived.length);
  //   // Count of Documents in Collection

  //   QuerySnapshot _myDocaccepted = await FirebaseFirestore.instance
  //       .collection('orders')
  //       .where('driverEmail', isEqualTo: user1.email)
  //       .where('status', isEqualTo: "accepted")
  //       .get();
  //   List<DocumentSnapshot> _myDocCountaccepted = _myDocaccepted.docs;
  //   print(_myDocCountaccepted.length);
  //   // Count of Documents in Collection

  //   return _myDocCountaccepted.length + _myDocCountarrived.length;
  // }
  // ///////////////////

  // void ongoingCount() async {
  //   final QuerySnapshot<Map<String, dynamic>> readdrivers =
  //       await FirebaseFirestore.instance
  //           .collection("orders")
  //           .where("driverEmail",
  //               isEqualTo: FirebaseAuth.instance.currentUser!.email)
  //           .get();
  //   limitNum = readdrivers.size;
  //   print(limitNum);
  // }

  @override
  void initState() {
    getcolors();
    //ongoingCount();
    // TODO: implement initState
    super.initState();
    if (globals.theme == false) {
      globals.ReqClicked = false;
    }
  }

  int count = 0;
  //int countR = 0;
  void ignored() {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: 'The request has been ignored successfully',
      btnOkOnPress: () {},
    ).show();
  }

  void limitReached() {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.warning,
      title: 'You have reached the maximum number of order accepting!',
      desc: 'only 4 orders at a time can be ongoing',
      btnOkOnPress: () {},
    ).show();
  }

  void faraway() {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.warning,
      title: 'You are not at the pick-up location yet',
      desc: 'please try again when you arrive',
      btnOkOnPress: () {},
    ).show();
  }

  void faraway2() {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.warning,
      title: 'You are not at the drop-off location yet',
      desc: 'please try again when you arrive',
      btnOkOnPress: () {},
    ).show();
  }

  void calculatedistance(orders) {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      distancemeter = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          orders["start"].latitude,
          orders["start"].longitude);
    });
  }

  void calculatedistance2(orders) {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      distancemeter2 = Geolocator.distanceBetween(position.latitude,
          position.longitude, orders["end"].latitude, orders["end"].longitude);
    });
  }

  void aceepted() async {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: 'Order accepted successfully',
      desc: 'you can now view this order at the ongoing order\'s list',
      btnOkOnPress: () {},
    ).show();
  }

  void arrived() async {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: 'Trip status updated successfully',
      btnOkOnPress: () {},
    ).show();
  }

  void Completed() async {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: 'Trip completed successfully',
      btnOkOnPress: () {},
    ).show();
  }

  _sendingSMS() async {
    var url = Uri.parse("sms: $affiliatephone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _Call() async {
    var url = Uri.parse("tel: $affiliatephone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void reqlist() {}
  //bool isRejected = false;
  bool isIgnored = false;

  bool PickClicked = false;
  bool dropClicked = false;

  int affiliatephone = 0;
  List<DocumentSnapshot> orders = [];
  List<String> rejectList = [];
  List<String> ordersList = [];
  List<QueryDocumentSnapshot<Object?>> rejected = [];
  int m = 0;
  List<Color> iconColors = [];
  double distancemeter = 0.0;
  double distancemeter2 = 0.0;

  isOrderIgnored() async {
    isIgnored = true;
  }

  void getcolors() {
    final color1 = Color(0xff204854);
    final color2 = Color(0xff5a6d24);
    final color3 = Color(0xffd35632);
    final color4 = Color(0xff8a5f8d);
    final color5 = Color(0xffa98319);
    final color6 = Color(0xffabb952);

    iconColors.add(color1);
    iconColors.add(color2);
    iconColors.add(color3);
    iconColors.add(color4);
    iconColors.add(color5);
    iconColors.add(color6);
  }

  void unavailable() async {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.warning,
      //showCloseIcon: true,
      title: 'You Are Unavailable ',

      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      clipBehavior: Clip.none,
      children: [
        Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              alignment: Alignment.topCenter,
              width: 60,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xccfdd051),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "Trips List",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff4b6d76),
                fontSize: 25,
                fontFamily: 'Alice',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 40),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    if (globals.theme == false) {
                      // print(globals.theme);
                      unavailable();
                      setState(() {});
                      globals.ReqClicked = false;
                    } else {
                      print(globals.theme);
                      setState(() {});
                      globals.ReqClicked = true;
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 21, horizontal: 70),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3f000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: Color(0xfffdd051),
                            width: 1,
                          ),
                          color: (globals.ReqClicked == true)
                              ? Color(0xfffad671)
                              : Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, top: 9),
                        child: Text(
                          "Requests",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontFamily: 'Alice',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {});
                    globals.ReqClicked = false;
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 21, horizontal: 70),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3f000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: Color(0xfffad671),
                            width: 1,
                          ),
                          color: (globals.ReqClicked == false)
                              ? Color(0xfffad671)
                              : Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, top: 9),
                        child: Text(
                          "Ongoing",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontFamily: 'Alice',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //),
              ],
            ),
          ),
          //Requests order
          if (globals.ReqClicked)
            StreamBuilder<QuerySnapshot>(
                stream: readRequest,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final orders = snapshot.data!.docs;
                    orders.sort((a, b) => b
                        .get('date')
                        .toString()
                        .compareTo(a.get('date').toString()));
                    count = orders.length;
                    if (snapshot.data!.docs.isEmpty) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 86, vertical: 100),
                        child: Text("There are no requests right now!",
                            style: GoogleFonts.alice(
                                fontSize: 15, color: Colors.black)),
                      );
                    }
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("orders")
                            .where("driverEmail", isEqualTo: user)
                            .snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            final ongoings = snapshot.data!.docs;
                            print("onLimit");
                            print(ongoings.length);
                            print(onLimit);
                            onLimit = 0;
                            for (var i = 0; i < ongoings.length; i++) {
                              if ((ongoings[i]["status"] == "arrived") ||
                                  ongoings[i]["status"] == "accepted")
                                onLimit++;
                              // print("onLimit");
                              // //print(onLimit);
                            }
                          }
                          return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("RejectedOrders")
                                  .where("driveremail", isEqualTo: user)
                                  .snapshots(),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.hasData) {
                                  final rejected = snapshot.data!.docs;

                                  for (int k = 0; k < rejected.length; k++) {
                                    rejectList.add(rejected[k]["orderID"]);
                                  }

                                  return ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30, horizontal: 20),
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      for (int i = 0; i < orders.length; i++)
                                        StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection("user affiliate")
                                                .where("email",
                                                    isEqualTo: orders[i]
                                                        ["email"])
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!rejectList
                                                  .contains(orders[i].id)) {
                                                isOrderIgnored();
                                                ordersList.add(orders[i].id);
                                                if (snapshot.hasData) {
                                                  final affiliates =
                                                      snapshot.data!.docs;
                                                  for (var n = 0;
                                                      n < affiliates.length;
                                                      n++) {
                                                    affiliateName =
                                                        affiliates[n].data()[
                                                                'first name'] +
                                                            " " +
                                                            affiliates[n]
                                                                    .data()[
                                                                'last name'];
                                                  }

                                                  return Container(
                                                      width: 300,
                                                      height: 184,
                                                      margin:
                                                          new EdgeInsets.only(
                                                              bottom: 10),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                          color:
                                                              Color(0x7fd9d9d9),
                                                          width: 1,
                                                        ),
                                                        color:
                                                            Color(0x7fd9d9d9),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(13),
                                                            child: Container(
                                                                child:
                                                                    CircleAvatar(
                                                              backgroundColor:
                                                                  Color(
                                                                      0xFFFDD051),
                                                              child: Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .black,
                                                                size: 45,
                                                              ),
                                                              radius: 27.0,
                                                            )),
                                                          ),
                                                          Positioned(
                                                            left: 80,
                                                            top: 30,
                                                            child: SizedBox(
                                                              width: 250,
                                                              height: 44,
                                                              child: Text(
                                                                "${affiliateName}",
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xff204854),
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Alice',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: 35,
                                                            top: 64,
                                                            child: TextButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return OrderRoute(
                                                                        order: orders[
                                                                            i]);
                                                                  },
                                                                );
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                    width: 270,
                                                                    height: 35,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50),
                                                                      color: Color(
                                                                          0xffb9d4d3),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color:
                                                                              Color(0x3f000000),
                                                                          blurRadius:
                                                                              4,
                                                                          offset: Offset(
                                                                              0,
                                                                              4),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            55,
                                                                        top: 4),
                                                                    child: Icon(
                                                                      Icons
                                                                          .location_pin,
                                                                      color: Colors
                                                                          .black,
                                                                      size: 25,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            85,
                                                                        top: 8),
                                                                    child: Text(
                                                                      "View trip route",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'Alice',
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          //buttons
                                                          //Ignore
                                                          Positioned(
                                                            left: 35,
                                                            top: 115,
                                                            child: TextButton(
                                                              onPressed: () {
                                                                AwesomeDialog(
                                                                  context:
                                                                      context,
                                                                  animType: AnimType
                                                                      .leftSlide,
                                                                  headerAnimationLoop:
                                                                      false,
                                                                  dialogType:
                                                                      DialogType
                                                                          .question,
                                                                  title:
                                                                      'Are you sure you want to ignore this request?',
                                                                  btnCancelOnPress:
                                                                      () {},
                                                                  btnOkOnPress:
                                                                      () {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "RejectedOrders")
                                                                        .add({
                                                                      'orderID':
                                                                          orders[i]
                                                                              .id,
                                                                      'driveremail': FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .email,
                                                                    });
                                                                    ignored();
                                                                  },
                                                                  btnOkText:
                                                                      "Yes",
                                                                  btnCancelText:
                                                                      "No",
                                                                  btnCancelColor:
                                                                      Color(
                                                                          0xFF00CA71),
                                                                  btnOkColor: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          211,
                                                                          59,
                                                                          42),
                                                                ).show();
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            21,
                                                                        horizontal:
                                                                            57),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50),
                                                                      color: Color(
                                                                          0xffb9d4d3),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color:
                                                                              Color(0x3f000000),
                                                                          blurRadius:
                                                                              4,
                                                                          offset: Offset(
                                                                              0,
                                                                              4),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            26,
                                                                        top: 7),
                                                                    child: Text(
                                                                      "Ignore",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xffe91717),
                                                                        fontSize:
                                                                            20,
                                                                        fontFamily:
                                                                            'Alice',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          //Accept
                                                          Positioned(
                                                            left: 190,
                                                            top: 115,
                                                            child: TextButton(
                                                              onPressed: () {
                                                                if (onLimit < 4)
                                                                  AwesomeDialog(
                                                                    context:
                                                                        context,
                                                                    animType:
                                                                        AnimType
                                                                            .leftSlide,
                                                                    headerAnimationLoop:
                                                                        false,
                                                                    dialogType:
                                                                        DialogType
                                                                            .question,
                                                                    title:
                                                                        'Are you sure you want to accept this request?',
                                                                    btnCancelOnPress:
                                                                        () {},
                                                                    btnOkOnPress:
                                                                        () {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "orders")
                                                                          .doc(orders[i]
                                                                              .id)
                                                                          .update({
                                                                        'status':
                                                                            "accepted",
                                                                      });
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "orders")
                                                                          .doc(orders[i]
                                                                              .id)
                                                                          .update({
                                                                        'driverEmail':
                                                                            user,
                                                                      });
                                                                      aceepted();
                                                                    },
                                                                    btnCancelText:
                                                                        "No",
                                                                    btnOkText:
                                                                        "Yes",
                                                                    btnCancelColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            211,
                                                                            59,
                                                                            42),
                                                                    btnOkColor:
                                                                        Color(
                                                                            0xFF00CA71),
                                                                  ).show();
                                                                else
                                                                  limitReached();
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            21,
                                                                        horizontal:
                                                                            57),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50),
                                                                      color: Color(
                                                                          0xffb9d4d3),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color:
                                                                              Color(0x3f000000),
                                                                          blurRadius:
                                                                              4,
                                                                          offset: Offset(
                                                                              0,
                                                                              4),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            25,
                                                                        top: 8),
                                                                    child: Text(
                                                                      "Accept",
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff0e9103),
                                                                          fontSize:
                                                                              20,
                                                                          fontFamily:
                                                                              'Alice'),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ));
                                                } else {
                                                  return Container();
                                                }
                                              }

                                              return Container();
                                            }),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              });
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          //////////////////// Ongoing List/////////////////
          //Pick Up List

          if (globals.ReqClicked == false)
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 0),
              //pick up button
              child: TextButton(
                onPressed: () => setState(() => PickClicked = !PickClicked),
                child: Stack(
                  children: [
                    Container(
                      height: 45,
                      width: 358,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3f000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Color(0xfffdd051),
                          width: 1,
                        ),
                        color: Color(0xfffad671),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 95, top: 9),
                      child: Text(
                        "Trips To Pick Up",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 22,
                          fontFamily: 'Alice',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (PickClicked == true && globals.ReqClicked == false)
            StreamBuilder<QuerySnapshot>(
                stream: readOngoing,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final orders1 = snapshot.data!.docs;
                    List orders = [];
                    for (int x = 0; x < orders1.length; x++) {
                      if (orders1[x]["status"] == "accepted" &&
                          (orders1[x]["driverEmail"] ==
                              FirebaseAuth.instance.currentUser!.email))
                        orders.add(orders1[x]);
                    }
                    print(orders.length);
                    if (orders.isEmpty) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 64, vertical: 10),
                        child: Text("There are no trips to pick up right now!",
                            style: GoogleFonts.alice(
                                fontSize: 15, color: Colors.black)),
                      );
                    }
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("orders")
                            .where("driverEmail", isEqualTo: user)
                            .snapshots(),
                        builder: (BuildContext context, snapshot) {
                          int onNum = 0;
                          int AcceptedNum = 0;
                          List<Color> acColors = [];
                          if (snapshot.hasData) {
                            final ongoings = snapshot.data!.docs;
                            // for (var i = 0; i < ongoings.length; i++) {
                            //   if ((ongoings[i]["status"] == "arrived") || ongoings[i]["status"] == "accepted")
                            //   onNum++;
                            // }
                            for (var w = 0; w < ongoings.length; w++) {
                              if ((ongoings[w]["status"] == "accepted")) {
                                acColors.add(iconColors[AcceptedNum]);
                                AcceptedNum++;
                              }
                            }
                          }
                          return ListView(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              SizedBox(height: 10),
                              for (int i = 0; i < orders.length; i++)
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("user affiliate")
                                        .where("email",
                                            isEqualTo: orders[i]["email"])
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final affiliates = snapshot.data!.docs;
                                        //distancemeter
                                        affiliateEmail = orders[i]["email"];

                                        calculatedistance(orders[i]);
                                        //calculatedistance2(orders[i]);

                                        for (var n = 0;
                                            n < affiliates.length;
                                            n++) {
                                          affiliateName = affiliates[n]
                                                  .data()['first name'] +
                                              " " +
                                              affiliates[n].data()['last name'];

                                          affiliatephone =
                                              affiliates[n].data()['phone'];
                                        }

                                        return Container(
                                            width: 280,
                                            height: 184,
                                            margin:
                                                new EdgeInsets.only(bottom: 15),
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
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(13),
                                                  child: Container(
                                                      child: CircleAvatar(
                                                    backgroundColor:
                                                        i < acColors.length
                                                            ? acColors[i]
                                                            : Colors.grey,
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Colors.black,
                                                      size: 45,
                                                    ),
                                                    radius: 27.0,
                                                  )),
                                                ),
                                                Positioned(
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
                                                //button call
                                                Positioned(
                                                  left: 285,
                                                  top: 115,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      affiliatephone =
                                                          affiliates[0]
                                                              ["phone"];
                                                      launch(
                                                          "tel://$affiliatephone");

                                                      // _Call();
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 21,
                                                                  horizontal:
                                                                      25),
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
                                                                  top: 9),
                                                          child: Icon(
                                                            Icons.call,
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
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                //Message call
                                                for (int i = 0;
                                                    i < affiliates.length;
                                                    i++)
                                                  StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('messages')
                                                        .where('receiver',
                                                            isEqualTo: user)
                                                        .where('sender',
                                                            isEqualTo:
                                                                affiliateEmail)
                                                        .where('unread',
                                                            isEqualTo: true)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        final mes =
                                                            snapshot.data!.docs;
                                                        int countNew =
                                                            mes.length;
                                                        return Stack(
                                                          children: [
                                                            Positioned(
                                                              left: 220,
                                                              top: 115,
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  for (int i =
                                                                          0;
                                                                      i < countNew;
                                                                      i++) {
                                                                    mes[i]
                                                                        .reference
                                                                        .update({
                                                                      'unread':
                                                                          false
                                                                    });
                                                                  }

                                                                  globals.affiliateEmail =
                                                                      affiliates[
                                                                              0]
                                                                          [
                                                                          "email"];
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => chatScreen(
                                                                                aEmail: affiliates[i]["email"],
                                                                                aName: affiliates[0].data()['first name'] + " " + affiliates[0].data()['last name'],
                                                                              )));
                                                                  // Navigator.pushNamed(
                                                                  //     context, 'chat');
                                                                  // _sendingSMS();
                                                                },
                                                                child:
                                                                    BadgeIcon(
                                                                  icon: Stack(
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                21,
                                                                            horizontal:
                                                                                25),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(50),
                                                                          color:
                                                                              Color(0xffb9d4d3),
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
                                                                            left:
                                                                                10,
                                                                            top:
                                                                                10),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .message,
                                                                          color:
                                                                              Colors.black,
                                                                          size:
                                                                              25,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  badgeCount:
                                                                      countNew,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      } else
                                                        return Container();
                                                    },
                                                  ),

                                                // Positioned(
                                                //   left: 35,
                                                //   top: 64,
                                                //   child: Row(
                                                //     children: [
                                                //       Image(
                                                //           width: 28,
                                                //           height: 30,
                                                //           image: AssetImage(
                                                //               'assets/pin.png')),
                                                //       TextButton(
                                                //         onPressed: () {
                                                //           showDialog(
                                                //               context: context,
                                                //               builder: (BuildContext
                                                //                   context) {
                                                //                 return OrderRoute(
                                                //                     order: orders[i]);
                                                //               });
                                                //         },
                                                //         child: SizedBox(
                                                //           width: 290,
                                                //           height: 44,
                                                //           child: Padding(
                                                //             padding:
                                                //                 const EdgeInsets.only(
                                                //                     top: 12, left: 5),
                                                //             child: Text(
                                                //               "Click here to view the route",
                                                //               style: TextStyle(
                                                //                 color:
                                                //                     Color(0xff3f698f),
                                                //                 fontSize: 18,
                                                //                 fontFamily: 'Alice',
                                                //                 decoration:
                                                //                     TextDecoration
                                                //                         .underline,
                                                //               ),
                                                //             ),
                                                //           ),
                                                //         ),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),

                                                Positioned(
                                                  left: 10,
                                                  top: 64,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return OrderRoute(
                                                              order: orders[i]);
                                                        },
                                                      );
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 320,
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
                                                                  left: 80,
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
                                                                  left: 110,
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

                                                //Arrived button
                                                Positioned(
                                                  left: 10,
                                                  top: 115,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      //double distancemeter =
                                                      // 0.0;
                                                      setState(() {
                                                        calculatedistance(
                                                            orders[i]);
                                                      });

                                                      if (distancemeter <=
                                                          300) {
                                                        print('distancemeter');

                                                        print(distancemeter);
                                                        AwesomeDialog(
                                                          context: context,
                                                          animType: AnimType
                                                              .leftSlide,
                                                          headerAnimationLoop:
                                                              false,
                                                          dialogType: DialogType
                                                              .question,
                                                          title:
                                                              'Are you sure you want to update this trip\'s status as arrived?',
                                                          btnCancelOnPress:
                                                              () {},
                                                          btnOkOnPress: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "orders")
                                                                .doc(orders[i]
                                                                    .id)
                                                                .update({
                                                              'status':
                                                                  "arrived",
                                                            });
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "orders")
                                                                .doc(orders[i]
                                                                    .id)
                                                                .update({
                                                              'driverEmail':
                                                                  user,
                                                            });
                                                            arrived();
                                                          },
                                                          btnCancelText: "No",
                                                          btnOkText: "Yes",
                                                          btnCancelColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  211,
                                                                  59,
                                                                  42),
                                                          btnOkColor:
                                                              Color(0xFF00CA71),
                                                        ).show();
                                                      } else {
                                                        print('distancemeter');
                                                        print(distancemeter);
                                                        faraway();
                                                      }
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 21,
                                                                  horizontal:
                                                                      80),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            color: Color(
                                                                0xff204854),
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
                                                                  left: 45,
                                                                  top: 8),
                                                          child: Text(
                                                            "Arrived",
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    'Alice'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ));
                                      } else {
                                        return Container();
                                      }
                                    }),
                            ],
                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),

          ////////////picked up list////////////

          if (globals.ReqClicked == false)
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 0),
              //pick up button
              child: TextButton(
                onPressed: () => setState(() => dropClicked = !dropClicked),
                child: Stack(
                  children: [
                    Container(
                      height: 45,
                      width: 358,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3f000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Color(0xfffdd051),
                          width: 1,
                        ),
                        color: Color(0xfffad671),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 95, top: 9),
                      child: Text(
                        "Trips To Drop Off",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 22,
                          fontFamily: 'Alice',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (globals.ReqClicked == false && dropClicked == true)
            (StreamBuilder<QuerySnapshot>(
                stream: readArrived,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final orders1 = snapshot.data!.docs;
                    List orders = [];
                    count = orders.length;
                    for (int x = 0; x < orders1.length; x++) {
                      if (orders1[x]["status"] == "arrived" &&
                          (orders1[x]["driverEmail"] ==
                              FirebaseAuth.instance.currentUser!.email))
                        orders.add(orders1[x]);
                    }
                    if (orders.isEmpty) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 62, vertical: 10),
                        child: Text("There are no trips to drop off right now!",
                            style: GoogleFonts.alice(
                                fontSize: 15, color: Colors.black)),
                      );
                    }
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("orders")
                            .where("driverEmail", isEqualTo: user)
                            .snapshots(),
                        builder: (BuildContext context, snapshot) {
                          int onNum = 0;
                          int AcceptedNum = 0;
                          int arrivedNum = 0;
                          List<Color> arColors = [];
                          if (snapshot.hasData) {
                            final ongoings = snapshot.data!.docs;
                            for (var w = 0; w < ongoings.length; w++) {
                              if ((ongoings[w]["status"] == "accepted")) {
                                AcceptedNum++;
                              }
                            }

                            arrivedNum = AcceptedNum;
                            for (var w = 0; w < ongoings.length; w++) {
                              if ((ongoings[w]["status"] == "arrived")) {
                                arColors.add(iconColors[arrivedNum]);
                                arrivedNum++;
                              }
                            }
                          }
                          return ListView(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 15),
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              SizedBox(height: 10),
                              for (int i = 0; i < orders.length; i++)
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("user affiliate")
                                        .where("email",
                                            isEqualTo: orders[i]["email"])
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        affiliateName = "";
                                        affiliatephone = 0;
                                        final affiliates = snapshot.data!.docs;
                                        affiliateEmail = orders[i]["email"];
                                        calculatedistance2(orders[i]);
                                        // for (var n = 0;
                                        //     n < affiliates.length;
                                        //     n++) {
                                        affiliateName = affiliates[0]
                                                .data()['first name'] +
                                            " " +
                                            affiliates[0].data()['last name'];

                                        affiliatephone =
                                            affiliates[0].data()['phone'];

                                        return Container(
                                            width: 300,
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
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(13),
                                                  child: Container(
                                                      child: CircleAvatar(
                                                    backgroundColor:
                                                        i < arColors.length
                                                            ? arColors[i]
                                                            : Colors.grey,
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Colors.black,
                                                      size: 45,
                                                    ),
                                                    radius: 27.0,
                                                  )),
                                                ),
                                                Positioned(
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
                                                Positioned(
                                                  left: 10,
                                                  top: 64,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return OrderRoute(
                                                              order: orders[i]);
                                                        },
                                                      );
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 320,
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
                                                                  left: 80,
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
                                                                  left: 110,
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

                                                //button call
                                                Positioned(
                                                  left: 285,
                                                  top: 115,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      print(orders[i]["email"]);
                                                      print(affiliateEmail);
                                                      print(affiliates[0]
                                                          ["phone"]);
                                                      affiliatephone =
                                                          affiliates[0]
                                                              ["phone"];
                                                      launch(
                                                          "tel://$affiliatephone");
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 21,
                                                                  horizontal:
                                                                      25),
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
                                                                  top: 9),
                                                          child: Icon(
                                                            Icons.call,
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
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                //Message call
                                                for (int i = 0;
                                                    i < affiliates.length;
                                                    i++)
                                                  StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('messages')
                                                        .where('receiver',
                                                            isEqualTo: user)
                                                        .where('sender',
                                                            isEqualTo:
                                                                affiliateEmail)
                                                        .where('unread',
                                                            isEqualTo: true)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        final mes =
                                                            snapshot.data!.docs;
                                                        int countNew =
                                                            mes.length;
                                                        return Stack(
                                                          children: [
                                                            //Message call
                                                            Positioned(
                                                              left: 220,
                                                              top: 115,
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  print(
                                                                      "hiiiiiiiiiii");
                                                                  print(affiliates[
                                                                          0][
                                                                      "email"]);
                                                                  for (int i =
                                                                          0;
                                                                      i < countNew;
                                                                      i++) {
                                                                    mes[i]
                                                                        .reference
                                                                        .update({
                                                                      'unread':
                                                                          false
                                                                    });
                                                                  }

                                                                  globals.affiliateEmail =
                                                                      affiliates[
                                                                              0]
                                                                          [
                                                                          "email"];

                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => chatScreen(
                                                                                aEmail: affiliates[0]["email"],
                                                                                aName: affiliates[0].data()['first name'] + " " + affiliates[0].data()['last name'],
                                                                              )));
                                                                  // Navigator.pushNamed(
                                                                  //     context, 'chat');
                                                                  // _sendingSMS();
                                                                },
                                                                child:
                                                                    BadgeIcon(
                                                                  icon: Stack(
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                21,
                                                                            horizontal:
                                                                                25),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(50),
                                                                          color:
                                                                              Color(0xffb9d4d3),
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
                                                                            left:
                                                                                10,
                                                                            top:
                                                                                10),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .message,
                                                                          color:
                                                                              Colors.black,
                                                                          size:
                                                                              25,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  badgeCount:
                                                                      countNew,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      } else
                                                        return Container();
                                                    },
                                                  ),

                                                //completed button
                                                Positioned(
                                                  left: 10,
                                                  top: 115,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        calculatedistance2(
                                                            orders[i]);
                                                      });

                                                      if (distancemeter2 <=
                                                          300) {
                                                        print('distancemeter2');

                                                        print(distancemeter2);
                                                        AwesomeDialog(
                                                          context: context,
                                                          animType: AnimType
                                                              .leftSlide,
                                                          headerAnimationLoop:
                                                              false,
                                                          dialogType: DialogType
                                                              .question,
                                                          title:
                                                              'Are you sure you want to update this trip\'s status as completed?',
                                                          btnCancelOnPress:
                                                              () {},
                                                          btnOkOnPress: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "orders")
                                                                .doc(orders[i]
                                                                    .id)
                                                                .update({
                                                              'status':
                                                                  "completed",
                                                            });
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "orders")
                                                                .doc(orders[i]
                                                                    .id)
                                                                .update({
                                                              'driverEmail':
                                                                  user,
                                                            });
                                                            Completed();
                                                          },
                                                          btnCancelText: "No",
                                                          btnOkText: "Yes",
                                                          btnCancelColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  211,
                                                                  59,
                                                                  42),
                                                          btnOkColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  55,
                                                                  167,
                                                                  118),
                                                        ).show();
                                                      } else {
                                                        print('distancemeter2');

                                                        print(distancemeter2);
                                                        faraway2();
                                                      }
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 21,
                                                                  horizontal:
                                                                      80),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    10,
                                                                    120,
                                                                    0),
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
                                                                  left: 30,
                                                                  top: 8),
                                                          child: Text(
                                                            "Completed",
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        242,
                                                                        255,
                                                                        241),
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    'Alice'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ));
                                      } else {
                                        return Container();
                                      }
                                    }),
                            ],
                          );
                        });
                  } else {
                    return Container();
                  }
                }))
        ]),
      ],
    );
  }
}
