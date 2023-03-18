import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:unibeethree/appwelcome.dart';
import 'package:unibeethree/login_page.dart';
import 'package:unibeethree/main.dart';
import 'package:unibeethree/screen/Divider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:dio/dio.dart';
import 'package:unibeethree/screen/previousList.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;
import 'package:location_geocoder/location_geocoder.dart';
import 'package:uuid/uuid.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:workmanager/workmanager.dart';
import 'BadgeIcon.dart';
import 'Notifications.dart';
import 'package:rxdart/subjects.dart';
import 'drawerList.dart';
import 'orders.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'globals.dart' as globals;
import 'commonFunctions.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin(); //Notifications

const maxseconds = 60;
int timeleft = maxseconds;
String str2 = "";
bool showLogout = true;
String affiliateName = "";

class googleMap_Screen extends StatefulWidget {
  const googleMap_Screen({super.key});

  @override
  State<googleMap_Screen> createState() => _googleMap_ScreenState();
}

class _googleMap_ScreenState extends State<googleMap_Screen> {
  bool NoOrder = false;

  CancelOrder() {
    //Future.delayed(const Duration(seconds: 60), () {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.question,
      //showCloseIcon: true,
      title: 'Are you sure you want to cancel this order?',
      //desc: 'All of our bees are busy at the momment, try again later',
      btnOkOnPress: () {
        DeleteOrder();
        OrderCanceled();
        print(NoOrder);
        NoOrder = true;
        showLogout = true;
        print(NoOrder);
        //str2 = "ignored";
        print(str2);
      },
      btnCancelOnPress: () {},
      btnCancelText: "No",
      btnOkText: "Yes",
      btnCancelColor: Color(0xFF00CA71),
      btnOkColor: Color.fromARGB(255, 211, 59, 42),

      //btnOkIcon: Icons.check_circle,
      /*onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dissmiss from callback $type');
                                                  },*/
    ).show();
    //});
  }

  OrderCanceled() {
    //Future.delayed(const Duration(seconds: 60), () {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      //showCloseIcon: true,
      title: 'Order canceled successfully',
      desc: 'You can now place a new order',

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

  //Notifications
  void listenNotifications() =>
      Notifications.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => googleMap_Screen(),
        ),
      );

  late BitmapDescriptor icon;
  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.0), "assets/Pickup.png");
    setState(() {
      this.icon = icon;
    });
  }

  late BitmapDescriptor icon2;
  getIcons2() async {
    var icon2 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.0), "assets/Drop.png");
    setState(() {
      this.icon2 = icon2;
    });
  }

  late BitmapDescriptor icon3 = BitmapDescriptor.defaultMarker;
  getIcons3() async {
    var icon3 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.0), "assets/mdi_golf-cart.png");
    try {
      setState(() {
        this.icon3 = icon3;
      });
    } catch (err) {}
  }

//////////timer countdown method///////////////
  late String id;

  bool OrderExists = true;
  bool timerended = false;
  //int timeleft = maxseconds;
  Timer? _timer;
  Future<void> _startCountDown() async {
    final prefs = await SharedPreferences.getInstance();
    timerended = false;
    timeleft = maxseconds;
    showLogout = false;
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (timeleft > 0) {
        try {
          setState(() {
            //decrese the time

            timeleft--;
          });
        } catch (err) {}
      }
      if (timerended == true) {
        timerended = false;
      }

      if (timeleft == 0) {
        print(timeleft);
        print(timerended);
        showLogout = true;
        timerended = true;
      }

      if (timeleft == 0 && timerended == true && str2 == "waiting") {
        print(timeleft);
        print(timerended);
        timer.cancel();
        // NoDriversDialog();
        if (NoOrder == false) {
          Notifications.showNotification(
            title: 'No driver was found',
            body: 'All drivers are currently busy, please try again later',
            //payload: 'sarah.abs',
          );
        }
      }
      if (NoOrder == true) {
        timer.cancel();
      }

      if (str2 == "accepted" && currentNotStatus == "waiting") {
        print(timeleft);
        print(timerended);
        timer.cancel();
        // NoDriversDialog();
        Notifications.showNotification(
          title: 'Order accepted',
          body: 'Your order has been accepted',
        );
        prefs.setBool('notifiedAccepted', true);
        currentOrder?.reference.update({'notificationStatus': "accepted"});
      }
    });
  }
  // Future<void> _startCountDown() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   timerended = false;
  //   timeleft = maxseconds;
  //   showLogout = false;
  //   Timer.periodic(Duration(seconds: 1), (Timer timer) {
  //     if (timeleft > 0) {
  //       try {
  //         setState(() {
  //           //decrese the time

  //           timeleft--;
  //         });
  //       } catch (err) {}
  //     }
  //     if (timerended == true) {
  //       timerended = false;
  //     }

  //     if (timeleft == 0) {
  //       print(timeleft);
  //       print(timerended);
  //       showLogout = true;
  //       timerended = true;
  //     }

  //     if (timeleft == 0 && timerended == true && str2 == "waiting") {
  //       print(timeleft);
  //       print(timerended);
  //       timer.cancel();
  //       //NoDriversDialog();
  //       Notifications.showNotification(
  //         title: 'No driver was found',
  //         body: 'All drivers are currently busy, please try again later',
  //         //payload: 'sarah.abs',
  //       );
  //     }

  //     if (str2 == "accepted" && currentNotStatus.toString() == "waiting") {
  //       print(timeleft);
  //       print(timerended);
  //       timer.cancel();
  //       //NoDriversDialog();
  //       Notifications.showNotification(
  //         title: 'Order accepted',
  //         body: 'Your order has been accepted',
  //       );
  //       prefs.setBool('notifiedAccepted', true);
  //       currentOrder?.reference.update({'notificationStatus': "accepted"});
  //     }

  //     prefs.setInt('timeleft', timeleft);
  //   });
  // }

  //////////////////////////////////////////

  LatLng intialLocation = const LatLng(24.730745, 46.635952);
  bool isInSelectedArea = true;
  List<LatLng> polygonPoints = const [
    LatLng(24.730620, 46.633085),
    LatLng(24.730726, 46.634433),
    LatLng(24.730517, 46.635593),
    LatLng(24.729118, 46.638245),
    LatLng(24.727753, 46.639332),
    LatLng(24.726683, 46.639657),
    LatLng(24.725493, 46.639917),
    LatLng(24.724578, 46.639799),
    LatLng(24.723420, 46.639286),
    LatLng(24.722858, 46.638052),
    LatLng(24.722804, 46.637063),
    LatLng(24.723054, 46.635593),
    LatLng(24.723593, 46.634106),
    LatLng(24.724711, 46.632650),
    LatLng(24.726585, 46.631527),
    LatLng(24.728105, 46.631184),
    LatLng(24.729674, 46.631721),
  ];

  LatLng? p1;
  LatLng? p2;
  LocationData? curL;
  void checkUpdatedLocation(LatLng pointLatLng) {
    List<map_tool.LatLng> convatedPolygonPoints = polygonPoints
        .map(
          (point) => map_tool.LatLng(point.latitude, point.longitude),
        )
        .toList();
    setState(() {
      isInSelectedArea = map_tool.PolygonUtil.containsLocation(
        map_tool.LatLng(pointLatLng.latitude, pointLatLng.longitude),
        convatedPolygonPoints,
        false,
      );
    });
  }

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late Set<Marker> _origin;
  late Set<Marker> _destination;
  // late Set<Marker> _driverLoc;
  // late Marker m3;
  late Marker m1;
  late Marker m2;
  LatLng driverLoc = new LatLng(0, 0);
  late LatLng prevDriverLoc = driverLoc;
  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();

    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
      return radiansToDegrees(atan(lng / lat));
    } else if (begin.latitude >= end.latitude &&
        begin.longitude < end.longitude) {
      return (90 - radiansToDegrees(atan(lng / lat))) + 90;
    } else if (begin.latitude >= end.latitude &&
        begin.longitude >= end.longitude) {
      return radiansToDegrees(atan(lng / lat)) + 180;
    } else if (begin.latitude < end.latitude &&
        begin.longitude >= end.longitude) {
      return (90 - radiansToDegrees(atan(lng / lat))) + 270;
    }

    return -1;
  }
  // double getBearingBetweenTwoPoints1(LatLng latLng1, LatLng latLng2) {
  //   double lat1 = degreesToRadians(latLng1.latitude);
  //   double long1 = degreesToRadians(latLng1.longitude);
  //   double lat2 = degreesToRadians(latLng2.latitude);
  //   double long2 = degreesToRadians(latLng2.longitude);

  //   double dLon = (long2 - long1);

  //   double y = sin(dLon) * cos(lat2);
  //   double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

  //   double radiansBearing = atan2(y, x);

  //   return radiansToDegrees(radiansBearing);
  // }

  // double degreesToRadians(double degrees) {
  //   return degrees * pi / 180.0;
  // }

  double radiansToDegrees(double radians) {
    return radians * 180.0 / pi;
  }

  void clear() {
    setState(() {
      if ((_origin.isNotEmpty || _destination.isNotEmpty)) {
        _origin.remove(
            _origin.firstWhere((marker) => marker.markerId.value == "origin"));

        if (_destination.isNotEmpty)
          _destination.remove(_destination
              .firstWhere((marker) => marker.markerId.value == "destination"));
      }
      requestRideContainerHeight = 0;
    });
  }

  void _addMarker(LatLng pos) {
    if (_origin.isEmpty || (_origin.isNotEmpty && _destination.isNotEmpty)) {
      setState(() {
        m1 = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Pickup'),
          position: pos,
          icon: icon,
        );
        _origin.add(m1);
        p1 = pos;
        if ((_origin.isNotEmpty && _destination.isNotEmpty)) {
          _destination.remove(_destination
              .firstWhere((marker) => marker.markerId.value == "destination"));
          _origin.remove(_origin
              .firstWhere((marker) => marker.markerId.value == "origin"));
        }
      });
    } else if (_destination.isEmpty) {
      setState(() {
        m2 = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Drop-off'),
          icon: icon2,
          position: pos,
        );
        _destination.add(m2);
        p2 = pos;
      });
    }
  }

  User? user = FirebaseAuth.instance.currentUser;
  List userOrders = [];
  List<QueryDocumentSnapshot<Object?>> userOrders2 = [];
  QueryDocumentSnapshot<Object?>? currentOrder;
  String? currentNotStatus;

  @override
  void initState() {
    super.initState();
    // setupWorkManager();

    user = FirebaseAuth.instance.currentUser;
    getIcons();
    getIcons2();
    getIcons3();
    _origin = Set.from([]);
    _destination = Set.from([]);

    if (user != null) {
      FirebaseFirestore.instance
          .collection("user affiliate")
          .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get()
          .then((snapshot) => snapshot.docs.forEach((document) {
                affiliateName =
                    document['first name'] + " " + document['last name'];
              }));

      // isDelivered();
      fetchDatabaseList();
    }
  }

  // bool orderArrived = ;
  bool deliveredStatus = true;
  bool hasWaitingOrder = false;
  bool hasOngoingOrder = false;
  String driverEmail = "";
  List driver = [];
  String driverName = "";
  String golfCarId = "";
  int? driverPhone;
  fetchDatabaseList() async {
    dynamic res = await orders()
        .getOrdersList(user!.email!); //get all this current user's orders

    if (res == null) {
      print('Unable to retrieve ');
    } else {
      if (user != null) {
        try {
          setState(() {
            userOrders = res;
            userOrders2 = res;
          });
        } catch (err) {
          print(err);
        }

        for (var i = 0; i < userOrders.length; i++) {
          if (userOrders[i].data()['status'] == "waiting" ||
              userOrders[i].data()['status'] == "accepted" ||
              userOrders[i].data()['status'] == "arrived") {
            currentOrder = userOrders2[i];
            currentNotStatus =
                userOrders[i].data()['notificationStatus'].toString();
            //without completed or ignored or canceled
            // _addMarker(new LatLng(userOrders[i].data()['start'].latitude,
            //     userOrders[i].data()['start'].longitude));
            // _addMarker(
            //   new LatLng(userOrders[i].data()['end'].latitude,
            //       userOrders[i].data()['end'].longitude),
            // );
            // userOrders[i].data()['end'].longitude));
            if ((_origin.isEmpty && _destination.isEmpty)) {
              _origin.add(Marker(
                  markerId: const MarkerId('origin'),
                  infoWindow: const InfoWindow(title: 'Pickup'),
                  position: new LatLng(userOrders[i].data()['start'].latitude,
                      userOrders[i].data()['start'].longitude),
                  icon: icon));

              _destination.add(Marker(
                markerId: const MarkerId('destination'),
                infoWindow: const InfoWindow(title: 'Drop-off'),
                icon: icon2,
                position: new LatLng(userOrders[i].data()['end'].latitude,
                    userOrders[i].data()['end'].longitude),
              ));

              // if (userOrders[i].data()['status'] == "accepted")
              //   driverLoc.add(Marker(
              //     markerId: const MarkerId('driverLoc'),
              //     infoWindow: const InfoWindow(title: 'Driver'),
              //     position: new LatLng(
              //         userOrders[i].data()['driverLoc'].latitude,
              //         userOrders[i].data()['driverLoc'].longitude),
              //   ));
            }

            str2 = userOrders[i].data()['status'];
            globals.orderStatus = str2;
            if (userOrders[i].data()['status'] == "accepted" ||
                userOrders[i].data()['status'] == "arrived") {
              if (userOrders[i].data()['status'] == "arrived" &&
                  userOrders[i].data()['notificationStatus'].toString() ==
                      "accepted") {
                Notifications.showNotification(
                  title: 'Driver arrived',
                  body:
                      'Your driver has arrived at your location', //the driver has come to you
                  //payload: 'sarah.abs',
                );
                globals.notifiedArrived = true;
                currentOrder?.reference.update({
                  'notificationStatus': "arrived",
                });
                currentNotStatus = "arrived";
              }
              driverEmail = userOrders[i].data()['driverEmail'];
              // dynamic d = await driversAcc.getOrdersList(user!.email!);
              getIcons3();
              try {
                await FirebaseFirestore.instance
                    .collection('drivers')
                    .where('email', isEqualTo: driverEmail)
                    .get()
                    .then((snapshot) {
                  print(driverEmail);

                  golfCarId = snapshot.docs.first.data()['GolfCarId'];
                  driverPhone = snapshot.docs.first.data()['phone'];
                  driverName = snapshot.docs.first.data()['first name'] +
                      " " +
                      snapshot.docs.first.data()['last name'];

                  globals.driverName = driverName;
                  globals.driverEmail = driverEmail;
                  if (driverLoc !=
                      new LatLng(snapshot.docs.first.data()['latitude'],
                          snapshot.docs.first.data()['longitude'])) {
                    prevDriverLoc = driverLoc;
                    print(prevDriverLoc.toString() + "hhhhhhh");
                    driverLoc = new LatLng(
                        snapshot.docs.first.data()['latitude'],
                        snapshot.docs.first.data()['longitude']);
                  }
                });

                // prevDriverLoc = driverLoc;

                print("driverLoc");
                print(driverLoc);
                print("prevDriverLoc");
                print(prevDriverLoc);

                // _driverLoc.add(Marker(
                //   markerId: MarkerId("driverLoc"),
                //   position: driverLoc,
                //   // icon: icon3,
                //   infoWindow: const InfoWindow(title: 'Driver'),
                // ));
              } catch (err) {
                print(err);
              }
            }

            break;
          } else if (isCompleted() == true &&
              userOrders[i].data()['status'] == "completed") {
            DeleteMessages();
            if ((userOrders[i].data()['status'] == "completed"
                    // await completedOrderNotification()
                    &&
                    currentNotStatus == "arrived"
                // &&
                //         prefs.getBool('notifiedCompleted') == false &&
                //         !globals.notifiedCompleted) ||
                //     (await completedOrderNotification() &&
                //         !globals.notifiedCompleted
                )) {
              globals.orderStatus = userOrders[i].data()['status'];
              // StatusNotification();
              Notifications.showNotification(
                title: 'Order completed',
                body: 'You have arrived to your destination',
              );

              globals.notifiedCompleted = true;
              currentOrder?.reference.update({
                'notificationStatus': "completed",
              });
              currentNotStatus = "completed";
              showRateDialog(context, id);
            }
            if ((status == "your order is completed" && !isCompleted()) ||
                str2 != "completed") {
              if ((_origin.isNotEmpty &&
                  _destination.isNotEmpty &&
                  str2 != "ignored")) {
                _origin.remove(_origin
                    .firstWhere((marker) => marker.markerId.value == "origin"));

                _destination.remove(_destination.firstWhere(
                    (marker) => marker.markerId.value == "destination"));

                status = "";
              }
            }
            str2 = userOrders[i].data()['status'];
            print(str2);
          }
        }
      }
    }
    print(str2);
  }

  Future<String> _getSharedValue() async {
    const defaultText = "no driver";
    String ret;
    var prefs = await SharedPreferences.getInstance();
    bool? isFirstTime = prefs.getBool('firstTime');
    print(isFirstTime);

    ret = ((isFirstTime == null || isFirstTime == true)
        ? defaultText
        : prefs.getString('driverName'))!;
    print(ret);

    return ret;
  }

  void setText() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('driverName', driverName);
    prefs.setBool('firstTime', false);
  }

  bool isCompleted2 = true;
  bool isCompleted() {
    for (var i = 0; i < userOrders.length; i++) {
      if (userOrders[i].data()['status'] == "waiting" ||
          userOrders[i].data()['status'] == "accepted" ||
          userOrders[i].data()['status'] == "arrived") {
        isCompleted2 = false;
        return isCompleted2;
      } else {
        // if (completedNot) {
        //   //NoDriversDialog();
        //   Notifications.showNotification(
        //     title: 'Hi thare,',
        //     body: 'You have arrived to your destination',
        //   );
        //   completedNot = false;
        // }
        isCompleted2 = true;
      }
    }
    // clear();
    // if (str2 == "waiting" || str2 == "accepted") isCompleted2 = false;

    print(_origin.length);
    return isCompleted2;
  }

  late GoogleMapController newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(24.727990, 46.635599), zoom: 15.9);

  late Position currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingOfMap = 0;

  void locatePosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          /*  desiredAccuracy: LocationAccuracy.high */);
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

  double requestRideContainerHeight = 0;
  bool isSent = false;
  void displayRequestRideContainer() {
    setState(() {
      requestRideContainerHeight = 230;
      isSent = true;
    });
  }

  bool buttonState() {
    if (_origin.isNotEmpty && _destination.isNotEmpty) return true;
    return false;
  }

  bool buttonState1() {
    bool _canShowButton = false;
    if (requestRideContainerHeight == 0 && _origin.isNotEmpty)
      _canShowButton = true;

    return _canShowButton;
  }

  String str = "";
  String status = "";

  String message() {
    if (_origin.isEmpty) str = "Select the Pickup location on the map!";
    if (_origin.isNotEmpty && _destination.isEmpty)
      str = "Select the Drop-off location on the map!";
    if (_origin.isNotEmpty && _destination.isNotEmpty) str = "Send your order!";

    return str;
  }

  DeleteOrder() async {
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
      await docRef.delete();
    } catch (err) {}
  }

  DeleteMessages() async {
    try {
      FirebaseFirestore.instance
          .collection('messages')
          .where('sender', isEqualTo: user!.email)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      FirebaseFirestore.instance
          .collection('messages')
          .where('receiver', isEqualTo: user!.email)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } catch (err) {
      print(err);
    }
  }

  Future<bool> completedOrderNotification() async {
    try {
      QuerySnapshot querySnap = await FirebaseFirestore.instance
          .collection('orders')
          .where('id', isEqualTo: globals.id)
          .where('status', isEqualTo: "completed")
          .get();
      QueryDocumentSnapshot doc = querySnap.docs[
          0]; // Assumption: the query returns only one document, THE doc you of the order wanted.
      DocumentReference docRef = doc.reference;
      if (doc != null) {
        // notifiedCompleted = false;
        return true;
      } else
        return false;
    } catch (err) {}
    return false;
  }

  Future<bool> arrivedOrderNotification() async {
    try {
      QuerySnapshot querySnap = await FirebaseFirestore.instance
          .collection('orders')
          .where('id', isEqualTo: globals.id)
          .where('status', isEqualTo: "arrived")
          .get();
      QueryDocumentSnapshot doc = querySnap.docs[
          0]; // Assumption: the query returns only one document, THE doc you of the order wanted.
      DocumentReference docRef = doc.reference;
      if (doc != null) {
        // notifiedCompleted = false;
        return true;
      } else
        return false;
    } catch (err) {}
    return false;
  }

  NoDriversDialog() {
    //Future.delayed(const Duration(seconds: 60), () {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.warning,
      //showCloseIcon: true,
      title: 'No driver was found',
      desc: 'All of our drivers are busy at the momment, try again later',
      btnOkOnPress: () {
        //Navigator.pop(context);
      },
      //btnOkIcon: Icons.check_circle,
      /*onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dissmiss from callback $type');
                                                  },*/
    ).show();
    //});
  }

  changeTimeStatus() {
    if (timerended == true) {
      timerended = false;
    }

    if (timeleft == 0) {
      print(timeleft);
      print(timerended);
      timerended = true;
      OrderExists = false;
      print(timeleft);
      print(timerended);
    }
  }

  // bool notifiedCompleted = false;
  // bool notifiedArrived = false;

  String orderStatus() {
    if (timerended == true) {
      timerended = false;
    }

    isCompleted();
    fetchDatabaseList();

    if (str2 == "waiting") status = "waiting for a driver...";
    if (str2 == "accepted") status = "your order has been accepted!";
    if (str2 == "arrived") {
      // notifiedArrived = false;
      status = "your driver has arrived!";
      // StatusNotification();
    }
    if (str2 == "completed") {
      // notifiedCompleted = false;
      status = "your order has been completed";
      // StatusNotification();
      // notifiedCompleted = true;
    }
    if (str2 == "canceled") status = "your order has been canceled";
    if ((timeleft == 0 && str2 == "waiting") || str2 == "ignored") {
      str2 = "ignored";

      print(_origin.length);
      print(_destination.length);
      DeleteOrder();
      //print(timeleft);
      // print(timerended);
      timerended = true;
      OrderExists = false;
      // print(timeleft);
      //print(timerended);
    }

    return "";
  }

  double ContainerSize() {
    if (str2 == "accepted" || str2 == "arrived")
      return 275;
    else if (str2 == "waiting")
      return 230;
    else
      return 0;
  }

/////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    Widget buildSeconds() {
      return Text(
        timeleft == 0 ? '' : timeleft.toString(),
        style: GoogleFonts.alice(fontSize: 25.0),
        textAlign: TextAlign.center,
      );
    }

    Widget buildTimer() => SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: timeleft / maxseconds,
                valueColor: AlwaysStoppedAnimation(Color(0xFFFDD051)),
                backgroundColor: Color.fromARGB(255, 193, 212, 218),
              ),
              buildSeconds(),
            ],
          ),
        );

    /////////////////////////////////////////////////////////////////////
    return Scaffold(
      drawer: new drawerList(),
      key: scaffoldkey,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            // markers: markers1,
            polygons: {
              Polygon(
                polygonId: PolygonId("1"),
                points: polygonPoints,
                strokeWidth: 3,
                strokeColor: Color(0xFFFDD051),
                fillColor: Color(0xFFFDD051).withOpacity(0.2),
              ),
            },

            markers: {
              if (_origin.isNotEmpty)
                _origin
                    .firstWhere((marker) => marker.markerId.value == "origin"),
              if (_destination.isNotEmpty)
                _destination.firstWhere(
                    (marker) => marker.markerId.value == "destination"),
              if ((str2 == "accepted" || str2 == "arrived"))
                Marker(
                  markerId: MarkerId("driverLoc"),
                  position: driverLoc,
                  rotation: getBearing(prevDriverLoc, driverLoc),
                  // getBearingBetweenTwoPoints1(prevDriverLoc, driverLoc),
                  icon: driverLoc.latitude == 0.0
                      ? BitmapDescriptor.defaultMarker
                      : icon3,
                  infoWindow: const InfoWindow(title: 'Driver'),
                ),
            },
            onTap: (pos) {
              print(pos);

              checkUpdatedLocation(pos);
              print(isInSelectedArea);

              setState(() {
                if ((isInSelectedArea == true && str2 == "") ||
                    (isInSelectedArea == true && str2 == "completed") ||
                    (isInSelectedArea == true && isCompleted()) ||

                    // (isInSelectedArea == true &&

                    //     // requestRideContainerHeight == 0 &&
                    //     (str2 != "waiting" && str2 != "accepted")) ||
                    (isInSelectedArea == true && str2 == "ignored")) {
                  _addMarker(pos);
                } else if (!isInSelectedArea &&
                    (str2 != "waiting" &&
                        str2 != "accepted" &&
                        str2 != "arrived")) {
                  // final snackBar2 = SnackBar(
                  //     content: Text(
                  //         'Deliveries are only avalabile inside campus',
                  //         style: TextStyle(fontSize: 19)),
                  //     backgroundColor: Color.fromARGB(255, 195, 44, 33));
                  // ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                  AwesomeDialog(
                    context: context,
                    animType: AnimType.leftSlide,
                    headerAnimationLoop: false,
                    dialogType: DialogType.warning,
                    //showCloseIcon: true,
                    title: 'Please select a valid location',
                    desc: 'Deliveries are only avalabile inside campus',
                    btnOkOnPress: () {
                      //Navigator.pop(context);
                    },

                    //btnOkIcon: Icons.check_circle,
                    /*onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dissmiss from callback $type');
                                                  },*/
                  ).show();
                }
              });
            },

            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 252.0;
              });
            },
          ),

          //menu button
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

          ////////////clear markers button
          ((!buttonState1() ||
                      (str2 == "waiting" ||
                          str2 == "accepted" ||
                          str2 == "arrived")) &&
                  ((str2 != "ignored" && !isCompleted()) ||
                      (_origin.isEmpty && _destination.isEmpty)))
              ? const SizedBox.shrink()
              : Positioned(
                  top: 45,
                  right: 22,
                  child: GestureDetector(
                    onTap: () {
                      clear();
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
                          Icons.close,
                          color: Colors.black,
                          size: 40,
                        ),
                        radius: 20.0,
                      ),
                    ),
                  ),
                ),

          //////////// Send Request page ///////////////
          ((isSent && !isCompleted()) &&
                      str2 != "ignored" &&
                      NoOrder == false) ||
                  (str2 == "arrived" || str2 == "accepted")
              // ((isSent && !isCompleted()) && str2 != "ignored") ||
              //         (str2 == "waiting" || str2 == "arrived" || str2 == "accepted")
              // && !OrderExists
              /*|| (str2 == "waiting" || str2 == "accepted")*/
              ? const SizedBox.shrink()
              : Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: Container(
                    height: 230.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 16.0,
                          spreadRadius: 0.5,
                          offset: Offset(7.0, 7.0),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Hi there,",
                            style: GoogleFonts.alice(fontSize: 14.0),
                          ),
                          Text(
                            "Where to?",
                            style: GoogleFonts.alice(
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            message(),
                            style: GoogleFonts.alice(fontSize: 18.0),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          ElevatedButton(
                            onPressed: buttonState()
                                ? () {
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.leftSlide,
                                      headerAnimationLoop: false,
                                      dialogType: DialogType.question,
                                      //showCloseIcon: true,
                                      title:
                                          'Are you sure you want to send this order?',
                                      //desc: 'All of our bees are busy at the momment, try again later',
                                      btnOkOnPress: () async {
                                        const uuid = Uuid();
                                        id = uuid.v4();

                                        _startCountDown();

                                        print("start");

                                        print(timeleft);
                                        print(timerended);
                                        print("done");

                                        if (str2 == "arrived" ||
                                            str2 == "completed") {
                                          print("bools");
                                          print(globals.notifiedArrived);

                                          globals.notifiedArrived = false;
                                          globals.notifiedCompleted = false;

                                          print("str2=");
                                          print(str2);
                                        }

                                        /*Future.delayed(
                                            const Duration(seconds: 60), () {
                                          changeTimeStatus();
                                          print("startin");

                                          print(timeleft);
                                          print(timerended);
                                          print("donein");

                                          /*if (timeleft == 0) {
                                            timerended = true;
                                            Notifications.showNotification(
                                              title: 'No driver was found',
                                              body:
                                                  'All drivers are currently busy, please try again later',
                                              //payload: 'sarah.abs',
                                            );
                                          }*/
                                          if (timeleft == 0 &&
                                              timerended == true) {
                                            NoDriversDialog();
                                          }
                                        });

                                        Future.delayed(
                                            const Duration(seconds: 61), () {
                                          if (timeleft == 0) {
                                            timerended = true;
                                            Notifications.showNotification(
                                              title: 'No driver was found',
                                              body:
                                                  'All drivers are currently busy, please try again later',
                                              //payload: 'sarah.abs',
                                            );
                                          }
                                        });*/

                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(snackBar);
                                        FirebaseFirestore.instance
                                            .collection('orders')
                                            .add({
                                          'start': new GeoPoint(
                                              p1!.latitude, p1!.longitude),
                                          'end': new GeoPoint(
                                              p2!.latitude, p2!.longitude),
                                          'status': "waiting",
                                          'email': user!.email,
                                          'driverEmail': "",
                                          //'driverName':  driverName,
                                          'id': id,
                                          'date': DateTime.now(),
                                          'notificationStatus': "waiting",
                                          'DriverNotified': false,
                                          'rating': 0.0,
                                          'reported': false,
                                          'report': "",
                                          'isExpanded': false,
                                          // 'isDelivered': false,
                                        });
                                        globals.id = id;
                                        displayRequestRideContainer();
                                        setState(() {
                                          if (user != null) fetchDatabaseList();
                                        });
                                        NoOrder = false;
                                        //Navigator.pop(context);

                                        AwesomeDialog(
                                          context: context,
                                          animType: AnimType.leftSlide,
                                          headerAnimationLoop: false,
                                          dialogType: DialogType.success,
                                          //showCloseIcon: true,
                                          title: 'Order Sent',
                                          desc:
                                              'Our Avalabile drivers can now see your Order',
                                          btnOkOnPress: () {
                                            //Navigator.pop(context);
                                          },
                                          //btnOkIcon: Icons.check_circle,
                                          /*onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dissmiss from callback $type');
                                                  },*/
                                        ).show();

                                        /*showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text(
                                                            'Your order sent successfully!',
                                                            style: TextStyle(
                                                                fontSize: 18.5),
                                                          ),
                                                        ),);*/
                                      },
                                      btnCancelOnPress: () {
                                        //Navigator.pop(context);
                                      },

                                      btnOkText: "Send order",
                                      btnCancelColor:
                                          Color.fromARGB(255, 98, 109, 105),

                                      //btnOkIcon: Icons.check_circle,
                                      /*onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dissmiss from callback $type');
                                                  },*/
                                    ).show();
                                    /*showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          'Are you sure you want to send a request?',
                                          style: TextStyle(fontSize: 18.5),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                const uuid = Uuid();
                                                id = uuid.v4();

                                                _startCountDown();

                                                print("start");

                                                print(timeleft);
                                                print(timerended);
                                                print("done");

                                                Future.delayed(
                                                    const Duration(seconds: 60),
                                                    () {
                                                  orderStatus();
                                                  print("start");

                                                  print(timeleft);
                                                  print(timerended);
                                                  print("done");
                                                  if (timeleft == 0 &&
                                                      timerended == true) {
                                                    NoDriversDialog();
                                                  }
                                                });

                                                // ScaffoldMessenger.of(context)
                                                //     .showSnackBar(snackBar);
                                                FirebaseFirestore.instance
                                                    .collection('orders')
                                                    .add({
                                                  'start': new GeoPoint(
                                                      p1!.latitude,
                                                      p1!.longitude),
                                                  'end': new GeoPoint(
                                                      p2!.latitude,
                                                      p2!.longitude),
                                                  'status': "waiting",
                                                  'email': user!.email,
                                                  'driverEmail': "",
                                                  //'driverName':  driverName,
                                                  'id': id,

                                                  // 'isDelivered': false,
                                                });
                                                displayRequestRideContainer();
                                                setState(() {
                                                  if (user != null)
                                                    fetchDatabaseList();
                                                });
                                                //Navigator.pop(context);

                                                AwesomeDialog(
                                                  context: context,
                                                  animType: AnimType.leftSlide,
                                                  headerAnimationLoop: false,
                                                  dialogType:
                                                      DialogType.success,
                                                  //showCloseIcon: true,
                                                  title: 'Order Sent',
                                                  desc:
                                                      'Our Avalabile Bees can now see your Order',
                                                  btnOkOnPress: () {
                                                    Navigator.pop(context);
                                                  },
                                                  //btnOkIcon: Icons.check_circle,
                                                  /*onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dissmiss from callback $type');
                                                  },*/
                                                ).show();

                                                /*showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text(
                                                            'Your order sent successfully!',
                                                            style: TextStyle(
                                                                fontSize: 18.5),
                                                          ),
                                                        ),);*/
                                              },
                                              child: Text(
                                                'Send',
                                                style: TextStyle(
                                                    fontSize: 18.5,
                                                    color: Color.fromARGB(
                                                        255, 23, 125, 27)),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    fontSize: 18.5,
                                                    color: Colors.grey),
                                              )),
                                        ],
                                      ),
                                    );*/
                                    // FirebaseFirestore.instance
                                    //     .collection('orders')
                                    //     .add({
                                    //   'start': new GeoPoint(
                                    //       p1!.latitude, p1!.longitude),
                                    //   'end': new GeoPoint(
                                    //       p2!.latitude, p2!.longitude),
                                    //   'status': "waiting",
                                    //   'email': user!.email,
                                    // });
                                    // displayRequestRideContainer();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff204854),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: Text(
                              'Send Order',
                              style: GoogleFonts.alice(fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

          //***************container appear after the button pressed************************
          // ((!isSent || isCompleted()) || str2 == "ignored") &&
          //         (str2 != "waiting" && str2 != "arrived" && str2 != "accepted")
          ((!isSent || isCompleted()) ||
                      str2 == "ignored" ||
                      NoOrder == true) &&
                  (str2 != "arrived" && str2 != "accepted")
              /*(str2 != "waiting" && str2 != "accepted")*/
              ? const SizedBox.shrink()
              : Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,

                  child: Container(
                    height: 252,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 16.0,
                          spreadRadius: 0.5,
                          offset: Offset(7.0, 7.0),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "Order status:",
                            style: GoogleFonts.alice(fontSize: 16.0),
                          ),

                          SizedBox(
                            height: 5.0,
                          ),

                          // Positioned(
                          //     child: StreamBuilder<QuerySnapshot>(
                          //         stream: orders,
                          //         builder: (BuildContext context,
                          //             AsyncSnapshot<QuerySnapshot> snapshot) {
                          //           if (snapshot.hasData) {
                          //             final users = snapshot.data!;
                          //             return ListView.builder(
                          //               itemCount: users.docs.length,
                          //               itemBuilder:
                          //                   (BuildContext context, int index) {
                          //                 return Text(
                          //                   "${users.docs[index]['status']} ",
                          //                 );
                          //               },
                          //             );
                          //           } else {
                          //             return Center(
                          //                 child: CircularProgressIndicator());
                          //           }
                          //         })),

                          Stack(children: [
                            SizedBox(
                              width: 10,
                            ),
                            Divider(
                              height: 15.0,
                              color: Colors.grey,
                              thickness: 5.0,
                            ),
                            CircleAvatar(
                              backgroundColor: Color(0xff204854),
                              radius: 8.0,
                            ),
                            str2 == "accepted" ||
                                    str2 == "arrived" ||
                                    str2 == "completed"
                                ? Container(
                                    width: 109,
                                    child: Divider(
                                      height: 15.0,
                                      color: Color(0xff204854),
                                      thickness: 5.0,
                                    ))
                                : SizedBox.shrink(),
                            Positioned(
                              left: 109,
                              child: CircleAvatar(
                                backgroundColor: str2 == "accepted" ||
                                        str2 == "arrived" ||
                                        str2 == "completed"
                                    ? Color(0xff204854)
                                    : Colors.grey,
                                radius: 8.0,
                              ),
                            ),
                            str2 == "arrived" || str2 == "completed"
                                ? Positioned(
                                    left: 109,
                                    child: Container(
                                        width: 108,
                                        child: Divider(
                                          height: 15.0,
                                          color: Color(0xff204854),
                                          thickness: 5.0,
                                        )),
                                  )
                                : SizedBox.shrink(),
                            Positioned(
                              left: 210,
                              child: CircleAvatar(
                                backgroundColor:
                                    str2 == "arrived" || str2 == "completed"
                                        ? Color(0xff204854)
                                        : Colors.grey,
                                radius: 8.0,
                              ),
                            ),
                            str2 == "completed"
                                ? Positioned(
                                    left: 217,
                                    child: Container(
                                        width: 109,
                                        child: Divider(
                                          height: 15.0,
                                          color: Color(0xff204854),
                                          thickness: 5.0,
                                        )),
                                  )
                                : SizedBox.shrink(),
                            Positioned(
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: str2 == "completed"
                                    ? Color(0xff204854)
                                    : Colors.grey,
                                radius: 8.0,
                              ),
                            ),
                            Text(
                              orderStatus(),
                              style: GoogleFonts.alice(fontSize: 20.0),
                            ),
                          ]),
                          Row(children: [
                            Text("waiting",
                                style: GoogleFonts.alice(fontSize: 15.0)),
                            SizedBox(
                              width: 40,
                            ),
                            Text("accepted",
                                style: GoogleFonts.alice(fontSize: 15.0)),
                            SizedBox(
                              width: 40,
                            ),
                            Column(children: [
                              Text("driver",
                                  style: GoogleFonts.alice(fontSize: 15.0)),
                              Text("arrived",
                                  style: GoogleFonts.alice(fontSize: 15.0)),
                            ]),
                            SizedBox(
                              width: 30,
                            ),
                            Text("completed",
                                style: GoogleFonts.alice(fontSize: 15.0)),
                          ]),
                          /////////////////////////////

                          /////////////////////////////
                          SizedBox(
                            height: 10.0,
                          ),

                          DividerWidget(),

                          SizedBox(
                            height: 10.0,
                          ),
                          str2 == "accepted" || str2 == "arrived"
                              ? Container(
                                  width: 400,
                                  height: 110,
                                  margin:
                                      new EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Color(0x7fd9d9d9),
                                      width: 1,
                                    ),
                                    color: Color(0x7fd9d9d9),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(13),
                                        child: Container(
                                            child: CircleAvatar(
                                          backgroundColor: Color(0xFFFDD051),
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
                                        top: 25,
                                        child: SizedBox(
                                          width: 250,
                                          height: 20,
                                          child: Text(
                                            "${driverName}",
                                            style: TextStyle(
                                              color: Color(0xff204854),
                                              fontSize: 20,
                                              fontFamily: 'Alice',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 60,
                                        top: 70,
                                        child: SizedBox(
                                          width: 250,
                                          height: 20,
                                          child: Text(
                                            "Golf Car ID: " + "${golfCarId}",
                                            style: TextStyle(
                                              color: Color(0xff3f698f),
                                              fontSize: 18,
                                              fontFamily: 'Alice',
                                            ),
                                          ),
                                        ),
                                      ),
                                      //button call
                                      Positioned(
                                        left: 256,
                                        top: 50,
                                        child: TextButton(
                                          onPressed: () {
                                            launch("tel://$driverPhone");
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 35,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 21,
                                                        horizontal: 25),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: Color(0xffb9d4d3),
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
                                                    left: 10, top: 9),
                                                child: Icon(
                                                  Icons.call,
                                                  color: Colors.black,
                                                  size: 20,
                                                ),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //       left: 33, top: 8),
                                              // )
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //       left: 40, top: 8),
                                              //   child: Text(
                                              //     "Make call",
                                              //     style: TextStyle(
                                              //       color: Colors.black,
                                              //       fontSize: 16,
                                              //       fontFamily: 'Alice',
                                              //     ),
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('messages')
                                              .where('receiver',
                                                  isEqualTo: user!.email)
                                              .where('status', isEqualTo: "new")
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final m = snapshot.data!.docs;
                                              int count = 0;
                                              if (m.isNotEmpty) {
                                                count++;
                                                print(count);
                                                String? messageText;
                                                String? sEmail;
                                                List messages = [];
                                                for (int i = 0;
                                                    i < m.length;
                                                    i++) {
                                                  sEmail = m[i]['sender'];
                                                  messages.add(m[i]);
                                                  messageText = m[i]['text'];
                                                  m[i].reference.update(
                                                      {'status': "old"});
                                                }
                                                if (m[0]['sender'] ==
                                                        driverEmail &&
                                                    !globals.inChat &&
                                                    count == 1) {
                                                  Notifications
                                                      .showNotification(
                                                    title: driverName,
                                                    body: messageText,
                                                  );
                                                }
                                              }
                                            }

                                            return Container();
                                          }),
                                      //Message call
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('messages')
                                              .where('receiver',
                                                  isEqualTo: user!.email)
                                              // .where('sender',
                                              //     isEqualTo:
                                              //         globals.driverEmail)
                                              .where('unread', isEqualTo: true)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final mes = snapshot.data!.docs;
                                              int countNew = mes.length;
                                              return Stack(
                                                children: [
                                                  Positioned(
                                                    left: 200,
                                                    top: 50,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        for (int i = 0;
                                                            i < countNew;
                                                            i++) {
                                                          mes[i]
                                                              .reference
                                                              .update({
                                                            'unread': false
                                                          });
                                                        }
                                                        globals.inChat = true;
                                                        Navigator.pushNamed(
                                                            context, 'chat');
                                                      },
                                                      child: BadgeIcon(
                                                        icon: Stack(
                                                          children: [
                                                            Container(
                                                              width: 40,
                                                              height: 35,
                                                              padding: const EdgeInsets
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
                                                                    blurRadius:
                                                                        4,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            4),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      top: 10),
                                                              child: Icon(
                                                                Icons.message,
                                                                color: Colors
                                                                    .black,
                                                                size: 20,
                                                              ),
                                                            ),
                                                            // Padding(
                                                            //   padding: const EdgeInsets.only(
                                                            //       left: 33, top: 8),
                                                            // )
                                                            // Padding(
                                                            //   padding: const EdgeInsets.only(
                                                            //       left: 40, top: 8),
                                                            //   child: Text(
                                                            //     "Send message",
                                                            //     style: TextStyle(
                                                            //       color: Colors.black,
                                                            //       fontSize: 16,
                                                            //       fontFamily: 'Alice',
                                                            //     ),
                                                            //   ),
                                                            // )
                                                          ],
                                                        ),
                                                        badgeCount: countNew,
                                                      ),
                                                    ),
                                                  ),
                                                  // StreamBuilder(
                                                  //     stream: FirebaseFirestore
                                                  //         .instance
                                                  //         .collection(
                                                  //             'messages')
                                                  //         .where('receiver',
                                                  //             isEqualTo:
                                                  //                 user!.email)
                                                  //         // .where('sender',
                                                  //         //     isEqualTo:
                                                  //         //         globals.driverEmail)
                                                  //         .where('status',
                                                  //             isEqualTo: "new")
                                                  //         .snapshots(),
                                                  //     builder:
                                                  //         (context, snapshot) {
                                                  //       if (snapshot.hasData) {
                                                  //         final m = snapshot
                                                  //             .data!.docs;
                                                  //         int count = 0;
                                                  //         if (m.isNotEmpty) {
                                                  //           count++;
                                                  //           print(count);
                                                  //           String? messageText;
                                                  //           String? sEmail;
                                                  //           List messages = [];
                                                  //           for (int i = 0;
                                                  //               i < m.length;
                                                  //               i++) {
                                                  //             sEmail = m[i]
                                                  //                 ['sender'];
                                                  //             messages
                                                  //                 .add(m[i]);
                                                  //             messageText =
                                                  //                 m[i]['text'];
                                                  //             m[i]
                                                  //                 .reference
                                                  //                 .update({
                                                  //               'status': "old"
                                                  //             });
                                                  //           }
                                                  //           if (m[0]['sender'] ==
                                                  //                   driverEmail &&
                                                  //               !globals
                                                  //                   .inChat &&
                                                  //               count == 1) {
                                                  //             Notifications
                                                  //                 .showNotification(
                                                  //               title:
                                                  //                   driverName,
                                                  //               body:
                                                  //                   messageText,
                                                  //             );
                                                  //           }
                                                  //         }
                                                  //         return Container();
                                                  //         // return Container(
                                                  //         //   child:
                                                  //         //       StreamBuilder(
                                                  //         //           stream: FirebaseFirestore
                                                  //         //               .instance
                                                  //         //               .collection(
                                                  //         //                   "drivers")
                                                  //         //               .where(
                                                  //         //                   'email',
                                                  //         //                   isEqualTo:
                                                  //         //                       sEmail)
                                                  //         //               .snapshots(),
                                                  //         //           builder:
                                                  //         //               (context,
                                                  //         //                   snapshot) {
                                                  //         //             if (snapshot
                                                  //         //                 .hasData) {
                                                  //         //               final sender = snapshot
                                                  //         //                   .data!
                                                  //         //                   .docs;
                                                  //         //               for (int j =
                                                  //         //                       0;
                                                  //         //                   j < sender.length;
                                                  //         //                   j++) {
                                                  //         //                 if (sender[j]['email'] == sEmail &&
                                                  //         //                     !globals.inChat) {
                                                  //         //                   Notifications.showNotification(
                                                  //         //                     title: sender[0]['first name'] + " " + sender[0]['last name'],
                                                  //         //                     body: messageText,
                                                  //         //                   );
                                                  //         //                 }
                                                  //         //               }
                                                  //         //               return Container();
                                                  //         //             } else
                                                  //         //               return Container();
                                                  //         //           }),
                                                  //         // );
                                                  //       } else
                                                  //         return Container();
                                                  //     }),
                                                ],
                                              );
                                            } else
                                              return Container();
                                          })
                                    ],
                                  ))

                              // Stack(
                              //     children: [
                              //       Text('Checkout your driver:',
                              //           style: GoogleFonts.alice(fontSize: 20)),
                              //       SizedBox(
                              //         height: 5,
                              //       ),
                              //       Padding(
                              //         padding: EdgeInsets.only(top: 30),
                              //         child: Row(children: [
                              //           Container(
                              //               child: CircleAvatar(
                              //             backgroundColor: Color(0xFFFDD051),
                              //             child: Icon(
                              //               Icons.person,
                              //               color: Colors.black,
                              //               size: 30,
                              //             ),
                              //             radius: 25.0,
                              //           )),
                              //           SizedBox(
                              //             width: 10,
                              //           ),
                              //           Column(
                              //             children: [
                              //               SizedBox(
                              //                 height: 5,
                              //               ),
                              //               Column(
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment.start,
                              //                 children: [
                              //                   SizedBox(
                              //                     width: 5,
                              //                   ),
                              //                   Text(driverName,
                              //                       style: GoogleFonts.alice(
                              //                           fontSize: 20)),
                              //                   Row(children: [
                              //                     Text(
                              //                         "Golf Car ID: " +
                              //                             golfCarId,
                              //                         style: GoogleFonts.alice(
                              //                             fontSize: 20)),
                              //                     SizedBox(
                              //                       width: 40,
                              //                     ),
                              //                     Container(
                              //                       alignment:
                              //                           Alignment.topCenter,
                              //                       child: SizedBox.fromSize(
                              //                         size: Size(40,
                              //                             40), // button width and height
                              //                         child: ClipOval(
                              //                           child: Material(
                              //                             color: Color(
                              //                                     0xff204854)
                              //                                 .withOpacity(
                              //                                     0.1), // button color
                              //                             child: InkWell(
                              //                               splashColor: Color(
                              //                                       0xff204854)
                              //                                   .withOpacity(
                              //                                       0.4), // splash color
                              //                               onTap:
                              //                                   () {}, // button pressed
                              //                               child: Column(
                              //                                 mainAxisAlignment:
                              //                                     MainAxisAlignment
                              //                                         .center,
                              //                                 children: <
                              //                                     Widget>[
                              //                                   Icon(Icons
                              //                                       .message), // icon
                              //                                 ],
                              //                               ),
                              //                             ),
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     SizedBox(
                              //                       width: 10,
                              //                     ),
                              //                     Container(
                              //                       alignment:
                              //                           Alignment.topCenter,
                              //                       child: SizedBox.fromSize(
                              //                         size: Size(40,
                              //                             40), // button width and height
                              //                         child: ClipOval(
                              //                           child: Material(
                              //                             color: Color(
                              //                                     0xff204854)
                              //                                 .withOpacity(
                              //                                     0.1), // button color
                              //                             child: InkWell(
                              //                               splashColor: Color(
                              //                                       0xff204854)
                              //                                   .withOpacity(
                              //                                       0.4), // splash color
                              //                               onTap: () {
                              //                                 launch(
                              //                                     "tel://$driverPhone");
                              //                                 // _launchCaller() async {
                              //                                 //   String url =
                              //                                 //       "tel:$driverPhone";
                              //                                 //   if (await canLaunch(
                              //                                 //       url)) {
                              //                                 //     await launch(
                              //                                 //         url);
                              //                                 //   } else {
                              //                                 //     print(
                              //                                 //         "Could not launch");
                              //                                 //     throw 'Could not launch $url';
                              //                                 //   }
                              //                                 // }
                              //                               }, // button pressed
                              //                               child: Column(
                              //                                 mainAxisAlignment:
                              //                                     MainAxisAlignment
                              //                                         .center,
                              //                                 children: <
                              //                                     Widget>[
                              //                                   Icon(Icons
                              //                                       .call), // icon
                              //                                 ],
                              //                               ),
                              //                             ),
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     )
                              //                   ])
                              //                   /*Row(children: [
                              //                       Text("Phone Number:",
                              //                           style: GoogleFonts.alice(
                              //                               fontSize: 20)),
                              //                       TextButton(
                              //                         onPressed: () {
                              //                           mailto:
                              //                           launch(
                              //                               "tel:$driverPhone");
                              //                         },
                              //                         child: Text(
                              //                             driverPhone.toString(),
                              //                             style:
                              //                                 GoogleFonts.alice(
                              //                                     fontSize: 20)),
                              //                       ),
                              //                     ])*/
                              //                 ],
                              //               ),
                              //             ],
                              //           ),
                              //         ]),
                              //       ),
                              //     ],
                              //   )

                              /////////waiting container////////////
                              : str2 == "waiting"
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        buildTimer(),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            //_startCountDown();
                                            CancelOrder();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Color(0xff204854),
                                            minimumSize:
                                                const Size.fromHeight(50),
                                          ),
                                          child: Text(
                                            'Cancel',
                                            style:
                                                GoogleFonts.alice(fontSize: 25),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ), //***********************
                ),
        ],
      ),
    );
  }
}

class drawerList extends StatelessWidget {
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

  User? user = FirebaseAuth.instance.currentUser;
  // int timeleft2 = googleMap_Screen.timeleft;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      width: 255.0,
      child: new ListView(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            height: 165.0,
            child: new DrawerHeader(
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // affiliateName,
                      user!.email!,
                      style: GoogleFonts.alice(
                          fontSize: 18.0, color: Color(0xFFEB9880)),
                    ),
                  ],
                ),
              ]),
            ),
          ),
          DividerWidget(),
          SizedBox(
            height: 12.0,
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'profile');
              /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const affiliate_view_profile()));*/
            },
            child: new ListTile(
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
              Navigator.pushNamed(context, 'rides');
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (context) => previousList()));
            },
            child: new ListTile(
              leading:
                  Icon(Icons.calendar_month_outlined, color: Color(0xFFFDD051)),
              title: Text(
                "Previous Rides",
                style: GoogleFonts.alice(fontSize: 18.0),
              ),
            ),
          ),
          TextButton(
            onPressed: _sendingSMS,
            child: new ListTile(
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
                top: 280,
              ),
              child: showLogout || str2 != "waiting"
                  ? TextButton(
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.leftSlide,
                          headerAnimationLoop: false,
                          dialogType: DialogType.question,
                          //showCloseIcon: true,
                          title: 'Are you sure you want to Log out?',
                          //desc: 'All of our bees are busy at the momment, try again later',
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

                          //btnOkIcon: Icons.check_circle,
                          /*onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dissmiss from callback $type');
                                                  },*/
                        ).show();

                        // _signOut();
                        /* showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(
                              'Are you sure you want to Log out?',
                              style: TextStyle(fontSize: 18.5),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);

                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    _signOut();
                                  },
                                  child: Text(
                                    'Log out',
                                    style: TextStyle(
                                        fontSize: 18.5,
                                        color:
                                            Color.fromARGB(255, 195, 44, 33)),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'cancel',
                                    style: TextStyle(
                                      fontSize: 18.5,
                                      color: Colors.grey,
                                    ),
                                  )),
                            ],
                          ));*/
                        // Navigator.of(context).popUntil((route) => route.isFirst);
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
                      ))
                  : SizedBox.shrink()),
        ],
      ),
    );
  }
}
