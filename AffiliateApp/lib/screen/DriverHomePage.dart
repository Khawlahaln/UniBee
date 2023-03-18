import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unibeethree/screen/Divider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
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
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  final user = FirebaseAuth.instance.currentUser!;

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
                          user.email!,
                          style: GoogleFonts.alice(
                              fontSize: 20.0, color: Color(0xFFEB9880)),
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
                onPressed: () {},
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
                  leading: Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xFFFDD051),
                    size: 30,
                  ),
                  title: Text(
                    "My Trips",
                    style: GoogleFonts.alice(fontSize: 18.0),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  String email = Uri.encodeComponent("UniBeeTeam@gmail.com");
                  String subject = Uri.encodeComponent("Hello UniBee Team!");
                  String body = Uri.encodeComponent("Hi! I need help");
                  // print(subject); //output: Hello%20Flutter
                  Uri mail =
                      Uri.parse("mailto:$email?subject=$subject&body=$body");
                  if (await launchUrl(mail)) {
                    //email app opened
                  } else {
                    //email app is not opened
                  }
                },
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
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
                  bottomPaddingOfMap = 210.0;
                });

                locatePosition();
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
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: 210.0,
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
                child: Container(
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
                          "You have no trips now!",
                          style: GoogleFonts.alice(
                            fontSize: 22.0,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Swipe up to see the requests.",
                          style: GoogleFonts.alice(
                            fontSize: 17.0,
                          ),
                        ),
                        SizedBox(
                          height: 22.0,
                        ),
                        DividerWidget(),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 125),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "0",
                                    style: GoogleFonts.alice(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Text(
                                    "Total Orders",
                                    style: GoogleFonts.alice(
                                      fontSize: 16.0,
                                    ),
                                  )
                                ])),
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
                          /*child: Row(children: [
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
                          ]),*/
                        ),*/

                        /*SizedBox(
                          height: 24.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 12.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Add Favorite Location"),
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
                        ),
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
                ),
              ))
        ],
      ),
    );
  }
}
