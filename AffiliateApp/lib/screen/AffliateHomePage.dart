import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unibeethree/appwelcome.dart';
import 'package:unibeethree/login_page.dart';
import 'package:unibeethree/main.dart';
import 'package:unibeethree/screen/Divider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;

class AffliateHomePage extends StatefulWidget {
  const AffliateHomePage({super.key});

  @override
  State<AffliateHomePage> createState() => _AffliateHomePageState();
}

class _AffliateHomePageState extends State<AffliateHomePage> {
  LatLng intialLocation = const LatLng(24.730745, 46.635952);
  bool isInSelectedArea = true;
  List<LatLng> polygonPoints = const [
    LatLng(24.730620, 46.633085),
    LatLng(24.730517, 46.635593),
    LatLng(24.729118, 46.638245),
    LatLng(24.726683, 46.639657),
    LatLng(24.725493, 46.639917),
    LatLng(24.723420, 46.639286),
    LatLng(24.722804, 46.637063),
    LatLng(24.723054, 46.635593),
    LatLng(24.723593, 46.634106),
    LatLng(24.724711, 46.632650),
    LatLng(24.726585, 46.631527),
    LatLng(24.728105, 46.631184),
    LatLng(24.729674, 46.631721),
  ];

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

/*late FirebaseAuth _auth;
final _user = Rxn<User> () ;
late Stream<User?> _authStateChanges;

void initAuth() async {Future.delayed(const Duration(seconds: 2)); // waiting in splash
_auth = FirebaseAuth. instance;
_authStateChanges = _auth.authStateChanges () ;
_authStateChanges. listen ( (User? user) {
_user.value = user;
print ("…..user id ${user?.uid} ...");
});
//navigateToIntroduction () ;
}*/

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

  int count = 1;
  // static final Marker _kGooglePlexMarker = Marker(
  //   markerId: MarkerId('_kGooglePlex'),
  //   infoWindow: InfoWindow(title: 'Google Plex'),
  //   icon: BitmapDescriptor.defaultMarker,
  //   position: LatLng(24.726173, 46.635952),
  // );
  /*late String uid;
   getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('user affiliate')
          .doc(user.uid)
          .get();

      }
    }
  }*/

  User? user = FirebaseAuth.instance.currentUser;

  // Future<String?> UserEmail() async {
  //   return user.email;
  // }

  /*CollectionReference user2 = FirebaseFirestore.instance
      .collection('user affiliate')
      .where('email', isEqualTo: user.email) as CollectionReference<Object?>;*/

/*  final userCollection =
      FirebaseFirestore.instance.collection("affiliate").doc(user?.uid).get();*/

  late Set<Marker> markers1;
  late Set<Marker> markers2;

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  // User user_ = User(userId: '1', username: '1', email: '1', avatar: '1', level: -1);
  // Future<void> _getInfoFromSession() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (mounted) {
  //     setState(() {
  //       String avatar = (prefs.getString('avatar') ?? "1");
  //       String username = (prefs.getString('username') ?? "1");
  //       String userId = (prefs.getString('userId') ?? "1");
  //       String email = (prefs.getString('email') ?? "1");
  //       int level = (prefs.getInt('level') ?? -1);
  //       user_ = User(
  //           userId: userId,
  //           username: username,
  //           email: email,
  //           avatar: avatar,
  //           level: level);
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    //_getUserName()
    //getUserData();
    markers1 = Set.from([]);
    markers2 = Set.from([]);
  }

  var first_name;
//Stream<List<User>> read() => FirebaseFirestore.instance.collection('user affiliate').snapshots.
  /*Future<void> getUserName() async {
        FirebaseFirestore.instance
            .collection('user affiliate')
            .get()
            .then((value) {
          setState(() {
            first_name = value.data['first name'].toString();
          });
        });
      }*/

  late GoogleMapController newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(24.727990, 46.635599), zoom: 15.9);

  late Position currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingOfMap = 0;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void locatePosition() async {
    // DartPluginRegistrant.ensureInitialized();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPosition = position;

      LatLng latLatPosition = LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition =
          new CameraPosition(target: latLatPosition, zoom: 16);

      newGoogleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      /*String address =
          await AssistantMethods.searchCoordinateAddress(position, context);*/
      //print("This is your Address :: " + address);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: 165.0,
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
                    ) /*Image.asset(
                      "images/person.png",
                      height: 50.0,
                      width: 50,
                    )*/
                        ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
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
                  /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const affiliate_view_profile()));*/
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
                onPressed: () {},
                child: ListTile(
                  leading: Icon(Icons.calendar_month_outlined,
                      color: Color(0xFFFDD051)),
                  title: Text(
                    "My Rides",
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
              /*SizedBox(
                height: 320,
              ),*/
              Padding(
                padding: EdgeInsets.only(
                  top: 280,
                ),
                child: TextButton(
                    onPressed: () {
                      _signOut();
                    },
                    child: ListTile(
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
                    )),

                /*ListTile(
                  leading: RotatedBox(
                    quarterTurns: 2,
                    child: Icon(Icons.logout, color: Color(0xFFBABC84)),
                  ),
                  title: Text(
                    "Log Out",
                    style: GoogleFonts.alice(fontSize: 15.0),
                  ),
                ),*/
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: markers1,
            // circles: {
            //   Circle(
            //     circleId: CircleId("1"),
            //     center: intialLocation,
            //     radius: 430,
            //     strokeWidth: 2,
            //     fillColor: Color(0xFFFDD051).withOpacity(0.2),
            //   )
            // },
            polygons: {
              Polygon(
                polygonId: PolygonId("1"),
                points: polygonPoints,
                strokeWidth: 2,
                fillColor: Color(0xFFFDD051).withOpacity(0.2),
              ),
            },

            onTap: (pos) {
              print(pos);

              Marker m = Marker(
                markerId: MarkerId('1'),
                infoWindow: InfoWindow(title: 'Your destination!'),
                icon: BitmapDescriptor.defaultMarker,
                position: pos,
              );
              Marker m2 = Marker(
                markerId: MarkerId('2'),
                infoWindow: InfoWindow(title: 'Your destination!'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueYellow),
                position: pos,
              );
              checkUpdatedLocation(pos);
              print(isInSelectedArea);

              setState(() {
                markers1.add(m);
                markers2.add(m2);
              });
            },
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            // markers: {_kGooglePlexMarker},
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 200.0;
              });

              //locatePosition();
            },
          ),
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
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: 200.0,
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
                        height: 6.0,
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
                        height: 10.0,
                      ),
                      Text(
                        "Select your destination on the map!",
                        style: GoogleFonts.alice(fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        color: Color(0xff204854),
                        textColor: Colors.white,
                        onPressed: () {},
                        child: Text(
                          'Send Request',
                          style: GoogleFonts.alice(fontSize: 25),
                        ),
                      ),
                      /*Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            /* BoxShadow(
                              color: Colors.black54,
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              offset: Offset(7.0, 7.0),
                            )*/
                          ],
                        ),
                        child: Row(children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.search,
                            color: Color(0xFFEB9880),
                            size: 30,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text("Search Drop Off")
                        ]),
                      ),*/
                      /*TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFD9D9D9),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFFEB9880),
                            size: 30,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Color(0xFFD9D9D9)), //<-- SEE HERE
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              )),
                          labelText: 'Search Drop Off',
                        ),
                      ),*/
                      /*SizedBox(
                        height: 24.0,
                      ),
                      DividerWidget(),
                      SizedBox(
                        height: 24.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*Text(Provider.of<AppData>(context)
                                          .pickUpLocation !=
                                      null
                                  ? Provider.of<AppData>(context)
                                      .pickUpLocation
                                      .placeName
                                  : "Current Location"),*/
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Your Favorite Location",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 12.0),
                              ),
                            ],
                          ), // Column
                        ],
                      ), */ /*
                      SizedBox(
                        height: 10.0,
                      ),
                      DividerWidget(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Recent Location"),
                            ],
                          ), // Column
                        ],
                      ),*/
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
