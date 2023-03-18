import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
// import 'dart:html';
import 'dart:ui';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'BadgeIcon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unibeethree/screen/Divider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unibeethree/screen/OrderRoute.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;
import 'Notifications.dart';
import 'RequestList.dart';
import 'previousList.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:background_location/background_location.dart';
import 'globals.dart' as globals;
import 'package:get/get.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin(); //Notifications
String driverName = "";

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  StreamController<int> _countController = StreamController<int>();
  int _tabBarCount = 0;
  Widget _tabBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: StreamBuilder(
            initialData: _tabBarCount,
            stream: _countController.stream,
            builder: (_, snapshot) => BadgeIcon(
              icon: Icon(Icons.chat, size: 25),
              badgeCount: snapshot.data!,
            ),
          ),
        ),
      ],
    );
  }

  bool value = false; //switch button
  final _controller = ValueNotifier<bool>(false);
  bool theme = false; // switch button
  double distanceImMeter = 0.0;
  List newongoingLoc = [];
  final user = FirebaseAuth.instance.currentUser!;
  late BitmapDescriptor myIcon;

  final Stream<QuerySnapshot> acceptedList = FirebaseFirestore.instance
      .collection("orders")
      .orderBy("date", descending: true)
      //.where("driverEmail", isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();
  final Stream<QuerySnapshot> newOrders = FirebaseFirestore.instance
      .collection("orders")
      .where("status", isEqualTo: "waiting")
      .where("DriverNotified", isEqualTo: false)
      .snapshots();
  // final Stream<QuerySnapshot> arrivedList = FirebaseFirestore.instance
  //     .collection("orders")
  //     .where("status", isEqualTo: "arrived")
  //     .where("driverEmail", isEqualTo: FirebaseAuth.instance.currentUser!.email)
  //     .snapshots();

  //live tracking variables
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  void getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      QuerySnapshot querySnap = await FirebaseFirestore.instance
          .collection('drivers')
          .where('email', isEqualTo: user.email!)
          .get();
      QueryDocumentSnapshot doc = querySnap.docs[
          0]; // Assumption: the query returns only one document, THE doc you of the order wanted.
      DocumentReference docRef = doc.reference;
      await docRef.set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        //'email': driveremail
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      QuerySnapshot querySnap = await FirebaseFirestore.instance
          .collection('drivers')
          .where('email', isEqualTo: user.email!)
          .get();
      if (querySnap.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnap.docs[
            0]; // Assumption: the query returns only one document, THE doc you of the order wanted.
        DocumentReference docRef = doc.reference;
        await docRef.set({
          'latitude': currentlocation.latitude,
          'longitude': currentlocation.longitude,
          //'email': driveremail
        }, SetOptions(merge: true));
      }
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  ///////////
  double? latitude = 0;
  double? longitude = 0;

  //////////////// test /////////////

  void getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      print('This is current Location ' + location.toMap().toString());
    });
  }

  void updateLocation() async {
    await BackgroundLocation.startLocationService();
    await BackgroundLocation.getLocationUpdates((location) {
      setState(() {
        latitude = location.latitude;
        longitude = location.longitude;
      });
    });

    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('drivers')
        .where('email', isEqualTo: user.email!)
        .get();
    QueryDocumentSnapshot doc = querySnap.docs[
        0]; // Assumption: the query returns only one document, THE doc you of the order wanted.
    DocumentReference docRef = doc.reference;
    await docRef.set({
      'latitude': latitude,
      'longitude': longitude,
      //'email': driveremail
    }, SetOptions(merge: true));
  }

  //////////////// test /////////////

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

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.55,
          maxChildSize: 0.85,
          minChildSize: 0.32,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: const RequestList(),
            );
          }),
    );
  }

// available ,unavailable button
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("drivers")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              driverName = document['first name'] + " " + document['last name'];
            }));
    Notifications.init();

    getIcons(1);
    getIcons2(1);

    getIcons(2);
    getIcons2(2);

    getIcons(3);
    getIcons2(3);

    getIcons(4);
    getIcons2(4);

    getIcons(5);
    getIcons2(5);

    getIcons(6);
    getIcons2(6);

    // this method for switch button
    getLocation();
    getCurrentLocation();
    listenLocation();
    //BackgroundLocation.startLocationService();
    //updateLocation();
    _controller.addListener(() {
      setState(() {
        if (_controller.value) {
          globals.theme = true;
        } else {
          globals.theme = false;
        }
      });
    });
  }

  _sendingMails() async {
    var url = Uri.parse("mailto:feedback@geeksforgeeks.org");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _sendingSMS() async {
    var url = Uri.parse("sms:966738292");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(24.726173, 46.635952), zoom: 16);

  late Position currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingOfMap = 0;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //final user = FirebaseAuth.instance.currentUser!;

  void locatePosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPosition = position;

      LatLng latLatPosition = LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition =
          new CameraPosition(target: latLatPosition, zoom: 16);

      newGoogleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    } catch (err) {
      print(err);
    }
  }

  List icons = [];
  //late BitmapDescriptor icon0;
  getIcons(int i) async {
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.0), "assets/Pickup$i.png");
    print(i);
    setState(() {
      icons.add(icon);
      //this.icon = icon;
    });
  }

  //late BitmapDescriptor icon2;
  getIcons2(int i) async {
    var icon2 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.0), "assets/Drop$i.png");
    print(i);
    setState(() {
      icons.add(icon2);
      //this.icon2 = icon2;
    });
  }

  List<LatLng> polylineCoordinates = [];

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  final Set<Polyline> _polyline = {};

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<LatLng, double> latLen = <LatLng, double>{};
  List<LatLng> polylinePoints = [];

  List ongoingList = [];
  void clearList() {
    setState(() {
      markers.clear();
      latLen.clear();
      ongoingList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      key: scaffoldkey,
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                height: 155.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(children: [
                    Container(
                        child: CircleAvatar(
                      backgroundColor: Color(0xFFFDD051),
                      child: Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 55,
                      ),
                      radius: 40.0,
                    )),
                    SizedBox(
                      height: 16.0,
                    ),
                    // StreamBuilder(
                    //   stream: FirebaseFirestore.instance
                    //       .collection("drivers")
                    //       .where("driverEmail",
                    //           isEqualTo:
                    //               FirebaseAuth.instance.currentUser!.email)
                    //       .snapshots(),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasData) {
                    //       final driver = snapshot.data!.docs;
                    //       return Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             driver[0]["first name"] +
                    //                 " " +
                    //                 driver[0]["last name"],
                    //             style: GoogleFonts.alice(
                    //                 fontSize: 20.0, color: Color(0xFFEB9880)),
                    //           ),
                    //         ],
                    //       );
                    //     } else
                    //       return Container();
                    //   },
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          // driverName,
                          user.email!,
                          style: GoogleFonts.alice(
                              fontSize: 20.0, color: Color(0xFFEB9880)),
                        ),
                      ],
                    ),
                    // )
                  ]),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('driverEmail', isEqualTo: user.email)
                      .where('status', isEqualTo: "completed")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                      // return Stack(
                      //   children: [
                      //     Container(
                      //       width: MediaQuery.of(context).size.width * .90,
                      //       height: 70.0,
                      //       decoration: new BoxDecoration(
                      //         shape: BoxShape.rectangle,
                      //         color: const Color(0xFFFFFF),
                      //         borderRadius: new BorderRadius.all(
                      //             new Radius.circular(32.0)),
                      //       ),
                      //       child: Center(
                      //         child: RatingBarIndicator(
                      //           rating: 0,
                      //           itemSize: 25,
                      //           direction: Axis.horizontal,
                      //           itemCount: 5,
                      //           itemPadding:
                      //               EdgeInsets.symmetric(horizontal: 0.0),
                      //           itemBuilder: (context, _) => Icon(
                      //             Icons.star,
                      //             color: Colors.amber,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       left: 115,
                      //       child: Text(
                      //         "0",
                      //         style: TextStyle(
                      //           color: Color(0xff204854),
                      //           fontSize: 22,
                      //           fontFamily: 'Alice',
                      //           //fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       top: 20,
                      //       left: 195,
                      //       child: Text(
                      //         "(0)",
                      //         style: TextStyle(
                      //           color: Color(0xff204854),
                      //           fontSize: 22,
                      //           fontFamily: 'Alice',
                      //           //fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // );
                    }

                    final _data = snapshot.data?.docs;
                    double total = 0, length = 0;
                    if (_data!.isNotEmpty) {
                      for (var data in _data!) {
                        print(data.get("rating"));
                        if (data.get("rating") != 0 &&
                            data.get("rating") != null) {
                          length++;
                          total += data.get("rating") as double;
                        }
                      }
                    }
                    FirebaseFirestore.instance
                        .collection('drivers')
                        .where('email', isEqualTo: user.email)
                        .get()
                        .then((value) => value.docs.first.reference.update(
                            {'avgRate': length != 0 ? (total / length) : 0}));
                    FirebaseFirestore.instance
                        .collection('drivers')
                        .where('email', isEqualTo: user.email)
                        .get()
                        .then((value) => value.docs.first.reference
                            .update({'numOfRates': length}));
                    return Container();
                    // return Stack(
                    //   children: [
                    //     Container(
                    //       width: MediaQuery.of(context).size.width * .90,
                    //       height: 70.0,
                    //       decoration: new BoxDecoration(
                    //         shape: BoxShape.rectangle,
                    //         color: const Color(0xFFFFFF),
                    //         borderRadius:
                    //             new BorderRadius.all(new Radius.circular(32.0)),
                    //       ),
                    //       child: Center(
                    //         child: RatingBarIndicator(
                    //           rating: length == 0 ? 0.0 : (total / length),
                    //           itemSize: 25,
                    //           direction: Axis.horizontal,
                    //           itemCount: 5,
                    //           itemPadding:
                    //               EdgeInsets.symmetric(horizontal: 0.0),
                    //           itemBuilder: (context, _) => Icon(
                    //             Icons.star,
                    //             color: Colors.amber,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Positioned(
                    //       left: 115,
                    //       child: Text(
                    //         _data.isEmpty || length == 0
                    //             ? "0"
                    //             : (total / length).toStringAsFixed(1),
                    //         style: TextStyle(
                    //           color: Color(0xff204854),
                    //           fontSize: 22,
                    //           fontFamily: 'Alice',
                    //           //fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //     Positioned(
                    //       top: 50,
                    //       left: 90,
                    //       child: Text(
                    //         _data.isEmpty
                    //             ? "0"
                    //             : "(" + length.toStringAsFixed(0) + " Ratings)",
                    //         style: TextStyle(
                    //           color: Color(0xff3f698f),
                    //           fontSize: 15,
                    //           fontFamily: 'Alice',
                    //           //fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // );
                  }),
              SizedBox(
                height: 5.0,
              ),
              DividerWidget(),
              SizedBox(
                height: 12.0,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'profile');
                },
                child: ListTile(
                  leading: Icon(
                    Icons.person_outline,
                    color: Color(0xFFFDD051),
                    size: 30,
                  ),
                  title: Text(
                    "My Profile",
                    style: GoogleFonts.alice(fontSize: 18.0),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'trips');
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const previousList()));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xFFFDD051),
                    size: 30,
                  ),
                  title: Text(
                    "Previous Trips",
                    style: GoogleFonts.alice(fontSize: 18.0),
                  ),
                ),
              ),
              TextButton(
                onPressed: _sendingSMS,
                child: ListTile(
                  leading: Icon(
                    Icons.question_mark,
                    color: Color(0xFFFDD051),
                    size: 30,
                  ),
                  title: Text(
                    "Help",
                    style: GoogleFonts.alice(fontSize: 18.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top:
                      //220,
                      280,
                ),
                child: TextButton(
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.leftSlide,
                      headerAnimationLoop: false,
                      dialogType: DialogType.question,
                      title: 'Are you sure you want to Log out?',
                      btnOkOnPress: () {
                        Navigator.pop(context);
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        _signOut();
                      },
                      btnCancelOnPress: () {},
                      btnCancelText: "back",
                      btnOkText: "Log out",
                      btnCancelColor: Color(0xFF00CA71),
                      btnOkColor: Color.fromARGB(255, 211, 59, 42),
                    ).show();
                  },
                  child: new ListTile(
                    leading: RotatedBox(
                      quarterTurns: 2,
                      child: Icon(
                        Icons.logout,
                        color: Color(0xFFBABC84),
                        size: 30,
                      ),
                    ),
                    title: Text(
                      "Log Out",
                      style: GoogleFonts.alice(fontSize: 18.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Notifications')
                  .where('email', isEqualTo: user!.email)
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final mes = snapshot.data!.docs;
                  int count = 0;
                  if (mes.isNotEmpty &&
                      mes[0]['isNotified'] == false &&
                      count != 1) {
                    count++;
                    Notifications.showNotification(
                      title: 'The admin has sent you a warning',
                      body: 'check out your profile',
                    );
                    mes[0].reference.update({'isNotified': true});
                  }
                }
                return Container();
              })),
          StreamBuilder<QuerySnapshot>(
              stream: newOrders,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final neworderslist = snapshot.data!.docs;
                  print("stream of notifiy");

                  for (var i = 0; i < neworderslist.length; i++) {
                    print("stream of notifiy loop");
                    print(_controller.value);
                    if (_controller.value) {
                      Notifications.showNotification(
                        title: 'You have a new order',
                        body: 'a new order has came, check it now!',
                      );
                      //notifiedOfNewOrder = true;
                      neworderslist[i]
                          .reference
                          .update({"DriverNotified": true});
                    }
                  }
                }
                //return Center(child: CircularProgressIndicator());

                return StreamBuilder<QuerySnapshot>(
                    stream: acceptedList,
                    builder: (context, snapshot) {
                      //(str== "")?  {
                      markers.clear();
                      latLen.clear();
                      //}: SizedBox.shrink();
                      ongoingList.clear();
                      _polyline.clear();
                      if (snapshot.hasData) {
                        final list = snapshot.data!.docs;
                        ongoingList.clear();
                        for (var i = 0; i < list.length; i++) {
                          if (list[i]["status"] == "accepted" &&
                              (FirebaseAuth.instance.currentUser != null &&
                                  list[i]["driverEmail"] ==
                                      FirebaseAuth.instance.currentUser!.email))
                            ongoingList.add(list[i]);
                        }
                        for (var i = 0; i < list.length; i++) {
                          if (list[i]["status"] == "arrived" &&
                              (list[i]["driverEmail"] ==
                                  FirebaseAuth.instance.currentUser!.email))
                            ongoingList.add(list[i]);
                        }
                        ongoingList.isNotEmpty
                            //getMarkers(ongoingList);
                            ? latLen.addAll({
                                LatLng(ongoingList[0]["start"].latitude,
                                    ongoingList[0]["start"].longitude): 0
                              })
                            : SizedBox.shrink();
                        //   ongoingList.isNotEmpty
                        //       ? Geolocator.getCurrentPosition(
                        //               desiredAccuracy: LocationAccuracy.high,
                        //               forceAndroidLocationManager: true)
                        //           .then((Position position) {
                        //           latLen.addAll({
                        //             LatLng(position.latitude, position.longitude): 0
                        //           });
                        //         })
                        //       : SizedBox.shrink();
                        // }

                        //int e = 0;

                        //print("inside markers");
                        for (int i = 0, e = 0;
                            i < ongoingList.length;
                            i++, e++) {
                          final MarkerId markerId = MarkerId("$e");
                          final Marker marker = Marker(
                            markerId: markerId,
                            icon: icons[e],
                            position: LatLng(ongoingList[i]["start"].latitude,
                                ongoingList[i]["start"].longitude),
                            infoWindow: InfoWindow(title: "Pickup location"),
                          );
                          markers[markerId] = marker;
                          e++;

                          final MarkerId markerId1 = MarkerId("$e");
                          final Marker marker1 = Marker(
                            markerId: markerId1,
                            icon: icons[e],
                            position: LatLng(ongoingList[i]["end"].latitude,
                                ongoingList[i]["end"].longitude),
                            infoWindow: InfoWindow(title: "dropoff location"),
                          );
                          markers[markerId1] = marker1;
                          if (ongoingList.isNotEmpty) {
                            // double m = 0.0;
                            // double n = 0.0;
                            // Geolocator.getCurrentPosition(
                            //   desiredAccuracy: LocationAccuracy.high,
                            // ).then((Position position) {
                            //   m = Geolocator.distanceBetween(
                            //       position.latitude,
                            //       position.longitude,
                            //       ongoingList[i]["start"].latitude,
                            //       ongoingList[i]["start"].longitude);

                            //   print('icons');
                            //   print(m);
                            //   print(icons[e]);

                            //   n = Geolocator.distanceBetween(
                            //       position.latitude,
                            //       position.longitude,
                            //       ongoingList[i]["end"].latitude,
                            //       ongoingList[i]["end"].longitude);
                            // }).catchError((e) {
                            //   print(e);
                            // });
                            // latLen.addAll({
                            //   LatLng(ongoingList[i]["start"].latitude,
                            //       ongoingList[i]["start"].longitude): m
                            // });
                            // latLen.addAll({
                            //   LatLng(ongoingList[i]["end"].latitude,
                            //       ongoingList[i]["end"].longitude): n
                            // });
                            var m = Geolocator.distanceBetween(
                                ongoingList[0]["start"].latitude,
                                ongoingList[0]["start"].longitude,
                                ongoingList[i]["start"].latitude,
                                ongoingList[i]["start"].longitude);
                            latLen.addAll({
                              LatLng(ongoingList[i]["start"].latitude,
                                  ongoingList[i]["start"].longitude): m
                            });

                            m = Geolocator.distanceBetween(
                                ongoingList[0]["start"].latitude,
                                ongoingList[0]["start"].longitude,
                                ongoingList[i]["end"].latitude,
                                ongoingList[i]["end"].longitude);
                            latLen.addAll({
                              LatLng(ongoingList[i]["end"].latitude,
                                  ongoingList[i]["end"].longitude): m
                            });
                          }

                          latLen = Map.fromEntries(latLen.entries.toList()
                            ..sort((a, b) => a.value.compareTo(b.value)));
                          print(latLen);
                          polylinePoints.clear();

                          latLen.forEach((key, value) {
                            print('key');
                            print(key);
                            print(value);
                            polylinePoints.add(key);
                          });

                          _polyline.add(Polyline(
                            polylineId: PolylineId('1'),
                            points: polylinePoints,
                            width: 5,
                            color: Colors.purple,
                          ));
                          print("polylines");
                          print(icons.length);
                        }
                        return GoogleMap(
                            padding:
                                EdgeInsets.only(bottom: bottomPaddingOfMap),
                            mapType: MapType.normal,
                            markers: Set<Marker>.of(markers.values),
                            polylines: _polyline,
                            myLocationButtonEnabled: true,
                            initialCameraPosition: _kGooglePlex,
                            myLocationEnabled: true,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            onMapCreated: (GoogleMapController controller) {
                              _controllerGoogleMap.complete(controller);
                              newGoogleMapController = controller;

                              setState(() {
                                bottomPaddingOfMap = 210.0;
                              });
                              // locatePosition();
                            });
                      }
                      return Center(child: CircularProgressIndicator());
                    });
              }),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('receiver', isEqualTo: user.email)
                  .where('status', isEqualTo: "new")
                  .snapshots(),
              //fetchNewtMessages(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final m = snapshot.data!.docs;

                  String? messageText;
                  String? sEmail;
                  List messages = [];
                  for (int i = 0; i < m.length; i++) {
                    sEmail = m[i]['sender'];
                    messages.add(m[i]);
                    messageText = m[i]['text'];
                    m[i].reference.update({'status': "old"});
                  }
                  return Container(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("user affiliate")
                            .where('email', isEqualTo: sEmail)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final sender = snapshot.data!.docs;
                            for (int j = 0; j < sender.length; j++) {
                              if (sender[j]['email'] == sEmail &&
                                  globals.affiliateEmail != sEmail) {
                                Notifications.showNotification(
                                  title: sender[j]['first name'] +
                                      " " +
                                      sender[j]['last name'],
                                  body: messageText,
                                );
                              }
                            }
                            return Container();
                          } else
                            return Container();
                        }),
                  );
                } else
                  return Container();
              }),
          Positioned(
            top: 45,
            left: 22,
            child: GestureDetector(
              onTap: () {
                scaffoldkey.currentState?.openDrawer();
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
                    Icons.menu,
                    color: Colors.black,
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          Positioned(
              bottom: 0,
              child: Container(
                  width: 391,
                  height: 150,
                  padding: EdgeInsets.only(bottom: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(52),
                        topRight: Radius.circular(52)),
                    border: Border.all(
                      color: Color(0x19000000),
                      width: 1,
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextButton(
                      onPressed: () async {
                        globals.theme = _controller.value;
                        // if (theme) {
                        _showModalBottomSheet(context);
                        // } else if (theme == false) {
                        //   unavailable();
                        // }
                      },
                      child: Column(children: [
                        Container(
                          alignment: Alignment.topCenter,
                          width: 60,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xccfdd051),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
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
                      ]),
                    ),
                  ))),
          // available, unavailable button // switch button
          Positioned(
            top: 50,
            right: 22,
            child: Container(
              height: 35,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3f000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
                color: Color(0xfffad671),
              ),
              child: AdvancedSwitch(
                controller: _controller,
                enabled: true,
                height: 35,
                width: 140,
                borderRadius: BorderRadius.circular(50),
                inactiveChild: const Text(
                  "Unavailable",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Color(0xff231f20),
                      fontSize: 16,
                      fontFamily: 'Alice'),
                ),
                inactiveColor: Colors.white,
                activeColor: Color(0xfffad671),
                activeChild: const Text(
                  "Available",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff231f20),
                      fontSize: 16,
                      fontFamily: 'Alice'),
                ),
              ),
            ),
          ), // end switch button
        ], ////////////////////////////////////////////////////////////////
      ),
      // Requested list
    );
  }
}
