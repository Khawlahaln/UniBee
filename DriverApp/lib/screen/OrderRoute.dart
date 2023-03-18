import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unibeethree/screen/Divider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'RequestList.dart';

class OrderRoute extends StatefulWidget {
  final order;
  const OrderRoute({super.key, required this.order});

  @override
  State<OrderRoute> createState() => _OrderRouteState(order);
}

class _OrderRouteState extends State<OrderRoute> {
  final order;
  _OrderRouteState(this.order);

  late BitmapDescriptor icon;

  late BitmapDescriptor icon2;

  final Set<Polyline> _polyline = {};

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(24.726173, 46.635952), zoom: 16);

  late Position currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingOfMap = 0;

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

  void startMarker() async {
    final MarkerId markerId = MarkerId("start");
    final Marker marker = Marker(
      markerId: markerId,
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 3.0), "assets/Pickup1.png"),
      position: LatLng(order["start"].latitude, order["start"].longitude),
      infoWindow: InfoWindow(title: "Pickup location"),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  void endMarker() async {
    final MarkerId markerId = MarkerId("end");
    final Marker marker = Marker(
      markerId: markerId,
      icon: await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.0),
        "assets/Drop1.png",
      ),
      position: LatLng(order["end"].latitude, order["end"].longitude),
      infoWindow: InfoWindow(title: "Dropoff location"),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  void initState() {
    List<LatLng> latLen = [
      LatLng(order["start"].latitude, order["start"].longitude),
      LatLng(order["end"].latitude, order["end"].longitude),
    ];
    startMarker();
    endMarker();
    _polyline.add(Polyline(
      polylineId: PolylineId('1'),
      points: latLen,
      width: 5,
      color: Colors.purple,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        key: scaffoldkey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
            width: 200,
            height: 560,
            color: Color.fromARGB(0, 255, 255, 255),
            padding: EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                Container(
                  child: GoogleMap(
                      padding: EdgeInsets.only(bottom: 10, left: 10),
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
                      }),
                ),
              ],
            )));
  }
}
