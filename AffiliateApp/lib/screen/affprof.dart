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
import 'package:unibeethree/appwelcome.dart';
import 'package:unibeethree/screen/DriverHomePage.dart';
import 'package:unibeethree/screen/OrderRoute.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:url_launcher/url_launcher.dart';

import 'passwordaff.dart';

class driverProfile extends StatefulWidget {
  const driverProfile({Key? key}) : super(key: key);

  @override
  State<driverProfile> createState() => _driverProfileState();
}

class _driverProfileState extends State<driverProfile> {
  final formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  var newPassword = ""; //auth updates
  var newEmail = ""; //auth updates
  // static String fnameO = "";
  // static String lnameO = "";
  // static String emailO = "";
  // static String PassO = "";
  // static String MobileO = "";
  String errorMessage = '';
  bool _trueva = true;
  bool _isObscure3 = true;
  String fname0 = "";
  // final newPasswordController = TextEditingController();
  // final newEmailController = TextEditingController();
  //TextEditingController firstname = TextEditingController();
  // TextEditingController lastname = TextEditingController();
  // TextEditingController phoneNum = new TextEditingController();

  final user = FirebaseAuth.instance.currentUser!.email;
  final Stream<QuerySnapshot> readRequest = FirebaseFirestore.instance
      .collection("user affiliate")
      .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  List<DocumentSnapshot> profile = [];
  int count = 0;

  void updated() async {
    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: false,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: 'The profile updated successfully',
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    ).show();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  void deleted({email, pass, id}) async {
    // FirebaseFirestore.instance
    //     .collection("orders")
    //     .where("email", isEqualTo: currentUser!.email)
    //     .get()
    //     .then((snapshot) => snapshot.docs.isNotEmpty
    //         ? snapshot.docs.forEach((document) {
    //             document.reference.delete();
    //           })
    //         : "");

    FirebaseFirestore.instance.collection("user affiliate").doc(id).delete();

    var cred =
        EmailAuthProvider.credential(email: email, password: pass.toString());
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.delete();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => appwelcome(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
      // int count = 0;
      // Navigator.popUntil(context, (route) => count++ == 4);
    }).catchError((error) {
      print(error.toString());
    });

    // AwesomeDialog(
    //   context: context,
    //   dismissOnTouchOutside: false,
    //   animType: AnimType.leftSlide,
    //   headerAnimationLoop: false,
    //   dialogType: DialogType.success,
    //   title: 'The profile delete successfully',
    //   btnOkOnPress: () {
    //     int count = 0;
    //     Navigator.popUntil(context, (route) => count++ == 4);
    //   },
    // ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: 850,
        child: Form(
          key: formKey,
          child: Stack(
            children: [
              //2) yellow
              Positioned(
                  left: 0, bottom: 0, child: Image.asset('assets/yellow3.png')),

              //3) green
              Positioned(
                  left: 0, top: 0, child: Image.asset('assets/green2.png')),

              //4) bee
              Positioned(
                  right: 0, top: 0, child: Image.asset('assets/bee2.png')),

              //5) pink
              Positioned(
                  left: 0, bottom: 0, child: Image.asset('assets/pink2.png')),

              // sign up
              Positioned(
                left: 120,
                top: 120,
                child: Text(
                  "Edit Profile",
                  style:
                      GoogleFonts.alice(fontSize: 30, color: Color(0xff204854)),
                ),
              ),

              //Firstname text
              Positioned(
                left: 55,
                top: 210,
                child: Text(
                  "First Name",
                  style:
                      GoogleFonts.alice(fontSize: 20, color: Color(0xff204854)),
                ),
              ),
              //requierd
              Positioned(
                left: 160,
                top: 215,
                child: Text(
                  "*",
                  style: GoogleFonts.alice(
                      fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                ),
              ),

              //Lastname text
              Positioned(
                left: 55,
                top: 300,
                child: Text(
                  "Last Name ",
                  style:
                      GoogleFonts.alice(fontSize: 20, color: Color(0xff204854)),
                ),
              ),
              //requierd
              Positioned(
                left: 160,
                top: 305,
                child: Text(
                  "*",
                  style: GoogleFonts.alice(
                      fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                ),
              ),

              //phone text
              Positioned(
                left: 55,
                top: 385,
                child: Text(
                  "phone number",
                  style:
                      GoogleFonts.alice(fontSize: 20, color: Color(0xff204854)),
                ),
              ),
              //requierd
              Positioned(
                left: 190,
                top: 390,
                child: Text(
                  "*",
                  style: GoogleFonts.alice(
                      fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                ),
              ),

              //Password text
              Positioned(
                left: 55,
                top: 470,
                child: Text(
                  "Password",
                  style:
                      GoogleFonts.alice(fontSize: 20, color: Color(0xff204854)),
                ),
              ),
              //requierd
              Positioned(
                left: 150,
                top: 475,
                child: Text(
                  "*",
                  style: GoogleFonts.alice(
                      fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                ),
              ),

              Container(
                child: Stack(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      //1
                      stream: readRequest,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          final profile = snapshot.data!.docs;
                          count = profile.length;
                          TextEditingController firstname =
                              TextEditingController();
                          String driverFname = "";
                          String driverLname = "";
                          String driverEmail = "";
                          String drivePhone = "";
                          String driverpass = "";
                          String fname0 = "";
                          String lname0 = "";
                          String phone0 = "";

                          bool fname = false;
                          bool lname = false;
                          bool phone = false;

                          for (var n = 0; n < profile.length; n++) {
                            driverFname = profile[n]['first name'];
                            fname0 = profile[n]['first name'];
                            driverLname = profile[n]['last name'];
                            lname0 = profile[n]['last name'];
                            // driverEmail = profile[n]['email'];
                            drivePhone = profile[n]['phone'].toString();
                            phone0 = profile[n]['phone'].toString();
                            driverpass = profile[n]['password'].toString();
                            print(count);
                          }
                          return Container(
                              height: 850,
                              child: Stack(children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 50),
                                  child: TextButton(
                                      onPressed: () {
                                        if (fname0 != driverFname ||
                                            lname0 != driverLname ||
                                            phone0 != drivePhone) {
                                          AwesomeDialog(
                                            context: context,
                                            animType: AnimType.leftSlide,
                                            headerAnimationLoop: false,
                                            dialogType: DialogType.question,
                                            title:
                                                'Are you sure you want to ignore this changes?',
                                            btnCancelOnPress: () {},
                                            btnOkOnPress: () {
                                              Navigator.pop(context);
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           const viewDriverProfile()),
                                              // );
                                            },
                                            btnOkText: "Yes",
                                            btnCancelText: "No",
                                            btnCancelColor: Color(0xFF00CA71),
                                            btnOkColor: Color.fromARGB(
                                                255, 211, 59, 42),
                                          ).show();
                                        } else {
                                          Navigator.pop(context);
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           const viewDriverProfile()),
                                          // );
                                        }
                                      },
                                      child: Image.asset('assets/back.png')),
                                ),
                                Center(
                                  // child: Form(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 40,
                                      ),

                                      //Firstname textfield
                                      Padding(
                                        padding: EdgeInsets.only(top: 200),
                                        child: Container(
                                          height: 50,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                161, 224, 224, 224),
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    112, 158, 158, 158)),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextFormField(
                                            initialValue: driverFname,
                                            //autofocus: true,
                                            //textAlign: TextAlign.left,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            decoration: InputDecoration(
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              255,
                                                              236,
                                                              231,
                                                              231))),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 236, 231, 231))),
                                              //floatingLabelAlignment:
                                              //  FloatingLabelAlignment.start,
                                              //filled: true,
                                              // fillColor: Color.fromARGB(
                                              //     255, 239, 237, 237),
                                              //enabled: true,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 14.0,
                                                      right: 12.0,
                                                      bottom: 8.0,
                                                      top: 8.0),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 236, 231, 231),
                                                      width: 3)),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Color.fromARGB(
                                                        79, 255, 255, 255)),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10),
                                              ),
                                            ),
                                            //controller: firstname,
                                            onChanged: (value) {
                                              driverFname = value;
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty ||
                                                  value == null) {
                                                fname = true;
                                                return " Please Enter your First Name ";
                                              } else if (!RegExp(r'[a-z A-Z]+$')
                                                  .hasMatch(value!)) {
                                                fname = true;
                                                return "please use letters";
                                              } else if (value.contains(' ')) {
                                                fname = true;
                                                return "spaces not allowed";
                                              } else if (value.length > 10) {
                                                fname = true;
                                                return "your first name must be less than 10 Letters";
                                              } else if (!(!RegExp(
                                                      r'[a-z A-Z]+$')
                                                  .hasMatch(value!))) {
                                                fname = false;
                                              } else if (!(value
                                                  .contains(' '))) {
                                                fname = false;
                                              } else if (!(value.length > 10)) {
                                                fname = false;
                                              } else if (!(value!.isEmpty ||
                                                  value == null)) {
                                                fname = false;
                                              }
                                            },
                                          ),
                                        ),
                                      ),

                                      //Lastname textfield

                                      Padding(
                                        padding: EdgeInsets.only(top: 40),
                                        child: Container(
                                          height: 50,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                161, 224, 224, 224),
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    112, 158, 158, 158)),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextFormField(
                                            initialValue: driverLname,
                                            //autofocus: true,
                                            //textAlign: TextAlign.left,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            decoration: InputDecoration(
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              255,
                                                              236,
                                                              231,
                                                              231))),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 236, 231, 231))),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 14.0,
                                                      right: 12.0,
                                                      bottom: 8.0,
                                                      top: 8.0),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 236, 231, 231),
                                                      width: 3)),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Color.fromARGB(
                                                        79, 255, 255, 255)),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10),
                                              ),
                                            ),
                                            //controller: firstname,
                                            onChanged: (value) {
                                              driverLname = value;
                                              print(driverLname);
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty ||
                                                  value == null) {
                                                lname = true;
                                                return " Please Enter your Last Name ";
                                              } else if (!RegExp(r'[a-z A-Z]+$')
                                                  .hasMatch(value!)) {
                                                lname = true;
                                                return "please use letters";
                                              } else if (value.contains(' ')) {
                                                lname = true;
                                                return "spaces not allowed";
                                              } else if (value.length > 10) {
                                                lname = true;
                                                return "your last name must be less than 10 Letters";
                                              } else if (!(!RegExp(
                                                      r'[a-z A-Z]+$')
                                                  .hasMatch(value!))) {
                                                lname = false;
                                              } else if (!(value
                                                  .contains(' '))) {
                                                lname = false;
                                              } else if (!(value.length > 10)) {
                                                lname = false;
                                              } else if (!(value!.isEmpty ||
                                                  value == null)) {
                                                lname = false;
                                              }
                                            },
                                          ),
                                        ),
                                      ),

                                      //phone

                                      Padding(
                                        padding: EdgeInsets.only(top: 35),
                                        child: Container(
                                          height: 50,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                161, 224, 224, 224),
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    112, 158, 158, 158)),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextFormField(
                                            initialValue: drivePhone,
                                            //autofocus: true,
                                            //textAlign: TextAlign.left,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            decoration: InputDecoration(
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              255,
                                                              236,
                                                              231,
                                                              231))),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 236, 231, 231))),
                                              //floatingLabelAlignment:
                                              //  FloatingLabelAlignment.start,
                                              //filled: true,
                                              // fillColor: Color.fromARGB(
                                              //     255, 239, 237, 237),
                                              //enabled: true,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 14.0,
                                                      right: 12.0,
                                                      bottom: 8.0,
                                                      top: 8.0),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 236, 231, 231),
                                                      width: 3)),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Color.fromARGB(
                                                        79, 255, 255, 255)),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10),
                                              ),
                                            ),
                                            //controller: firstname,
                                            onChanged: (value) {
                                              drivePhone = value;
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty ||
                                                  value == null) {
                                                phone = true;
                                                return " Please Enter your Phone number ";
                                              } else if (!RegExp(
                                                      r'^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$')
                                                  .hasMatch(value!)) {
                                                phone = true;
                                                return "please enter correct Phone number";
                                              } else if (value.contains(' ')) {
                                                phone = true;
                                                return "spaces not allowed";
                                              } else if (!(value!.isEmpty ||
                                                  value == null)) {
                                                phone = false;
                                              } else if (!(!RegExp(
                                                      r'^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$')
                                                  .hasMatch(value!))) {
                                                phone = false;
                                              } else if (!(value
                                                  .contains(' '))) {
                                                phone = false;
                                              }
                                            },
                                          ),
                                        ),
                                      ),

                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 34, left: 45),
                                          child: Row(children: [
                                            Container(
                                                height: 50,
                                                width: 260,
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      161, 224, 224, 224),
                                                  border: Border.all(
                                                      color: Color.fromARGB(
                                                          112, 158, 158, 158)),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: TextFormField(
                                                  obscureText: _isObscure3,
                                                  initialValue: driverpass,
                                                  readOnly: true,
                                                  autofocus: false,
                                                  textAlign: TextAlign.left,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  decoration: InputDecoration(
                                                    floatingLabelAlignment:
                                                        FloatingLabelAlignment
                                                            .start,
                                                    filled: true,
                                                    fillColor: Color.fromARGB(
                                                        255, 239, 237, 237),
                                                    enabled: true,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 14.0,
                                                            right: 12.0,
                                                            bottom: 8.0,
                                                            top: 8.0),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        236,
                                                                        231,
                                                                        231),
                                                                width: 3)),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      79,
                                                                      255,
                                                                      255,
                                                                      255)),
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(10),
                                                    ),
                                                  ),
                                                )),
                                            Container(
                                                height: 50,
                                                width: 50,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const password()),
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.arrow_circle_right,
                                                      color: Color(0xff1e4845),
                                                      size: 35,
                                                    )))
                                          ])),

                                      //buttons
                                      //update
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Padding(
                                        // top: 645,
                                        // left: 45,
                                        padding: EdgeInsets.only(
                                            left: 12, right: 15, top: 4),
                                        child: TextButton(
                                          onPressed: () {
                                            if (fname || lname || phone) {
                                              AwesomeDialog(
                                                context: context,
                                                animType: AnimType.leftSlide,
                                                headerAnimationLoop: false,
                                                dialogType: DialogType.warning,
                                                title:
                                                    'incorrert information entered',
                                                btnOkOnPress: () {},
                                              ).show();
                                            } else
                                              AwesomeDialog(
                                                context: context,
                                                animType: AnimType.leftSlide,
                                                headerAnimationLoop: false,
                                                dialogType: DialogType.question,
                                                title:
                                                    'Update Your Iformation ',
                                                desc:
                                                    'Are you sure you want to update your information?',
                                                btnCancelOnPress: () {},
                                                btnOkOnPress: () {
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          "user affiliate")
                                                      .doc(profile[0].id)
                                                      .update({
                                                    'first name': driverFname,
                                                    'last name': driverLname,
                                                    'phone':
                                                        int.parse(drivePhone),
                                                    'password': driverpass,
                                                  });
                                                  updated();
                                                },
                                                btnOkText: "Yes",
                                                btnCancelText: "No",
                                                btnOkColor: Color(0xFF00CA71),
                                                btnCancelColor: Color.fromARGB(
                                                    255, 211, 59, 42),
                                              ).show();
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: 124,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: Color(0xff1e4845),
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
                                                padding: EdgeInsets.only(
                                                    left: 23, right: 7, top: 4),
                                                child: Text(
                                                  "Update",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25,
                                                      fontFamily: 'alice'),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      //Delete
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection("orders")
                                              .where("email",
                                                  isEqualTo: currentUser!.email)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return Container(
                                                child: Text("wronggg"),
                                              );
                                            bool has = false;
                                            if (snapshot.hasData) {
                                              final sn = snapshot.data!.docs;
                                              // if (sn.isEmpty)
                                              //   return Container(
                                              //     child: Text("isEmpty"),
                                              //   );
                                              for (int i = 0;
                                                  i < sn.length;
                                                  i++)
                                                if (sn[i]['status'] ==
                                                        "waiting" ||
                                                    sn[i]['status'] ==
                                                        "accepted" ||
                                                    sn[i]['status'] ==
                                                        "arrived") has = true;
                                            }
                                            if (!has)
                                              FirebaseFirestore.instance
                                                  .collection("orders")
                                                  .where("driverEmail",
                                                      isEqualTo:
                                                          currentUser!.email)
                                                  .get()
                                                  .then((snapshot) => snapshot
                                                          .docs.isNotEmpty
                                                      ? snapshot.docs
                                                          .forEach((document) {
                                                          document.reference
                                                              .delete();
                                                        })
                                                      : "");
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextButton(
                                                onPressed: !has
                                                    ? () {
                                                        AwesomeDialog(
                                                          context: context,
                                                          animType: AnimType
                                                              .leftSlide,
                                                          headerAnimationLoop:
                                                              false,
                                                          dialogType: DialogType
                                                              .question,
                                                          title:
                                                              'Are you sure you want to delete your profile',
                                                          btnCancelOnPress:
                                                              () {},
                                                          btnOkOnPress:
                                                              () async {
                                                            deleted(
                                                                email:
                                                                    currentUser!
                                                                        .email,
                                                                pass: profile[0]
                                                                    [
                                                                    'password'],
                                                                id: profile[0]
                                                                    .id);

                                                            // Navigator.popUntil(
                                                            //     context,
                                                            //     ModalRoute.withName(
                                                            //         'signin'));
                                                            // Navigator.pushNamed(
                                                            //     context, 'signin');
                                                            // Navigator.push(
                                                            //     context,
                                                            //     MaterialPageRoute(
                                                            //         builder: (context) =>
                                                            //             LoginPageDriver()));
                                                            print('deleted');
                                                          },
                                                          btnOkText: "Yes",
                                                          btnCancelText: "No",
                                                          btnCancelColor:
                                                              Color(0xFF00CA71),
                                                          btnOkColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  211,
                                                                  59,
                                                                  42),
                                                        ).show();
                                                      }
                                                    : null,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: 124,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: !has
                                                            ? Color.fromARGB(
                                                                255,
                                                                211,
                                                                59,
                                                                42)
                                                            : Colors.grey,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x3f000000),
                                                            blurRadius: 4,
                                                            offset:
                                                                Offset(0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 23,
                                                          right: 7,
                                                          top: 4),
                                                      child: Text(
                                                        "Delete",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25,
                                                            fontFamily:
                                                                'alice'),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                  // )
                                )
                              ]));
                        } else {}
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
