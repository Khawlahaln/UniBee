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
import 'package:unibeethree/screen/DriverHomePage.dart';
import 'package:unibeethree/screen/OrderRoute.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:unibeethree/screen/googleMap_Screen.dart';

import 'package:url_launcher/url_launcher.dart';

class password extends StatefulWidget {
  const password({Key? key}) : super(key: key);

  @override
  State<password> createState() => _passwordState();
}

class _passwordState extends State<password> {
  final formKey = GlobalKey<FormState>();
  final form2Key = GlobalKey<FormState>();
  final form3Key = GlobalKey<FormState>();
  final form4Key = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();
  TextEditingController c3 = TextEditingController();
  String errorMessage = '';
  bool _trueva = true;
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  bool _isObscure3 = true;

  final user = FirebaseAuth.instance.currentUser!.email;
  final Stream<QuerySnapshot> readRequest = FirebaseFirestore.instance
      .collection("user affiliate")
      .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  List<DocumentSnapshot> profile = [];
  int count = 0;
  String newPass = '';
  void updated() async {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: 'The profile updated successfully',
      btnOkOnPress: () {
        int count = 0;
        Navigator.popUntil(context, (route) => count++ == 4);
      },
    ).show();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  changePassword({email, oldPassword, newPassword}) async {
    var cred =
        EmailAuthProvider.credential(email: email, password: oldPassword);
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newPassword);
    }).catchError((error) {
      print(error.toString());
    });

    print("hiiii");
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
                left: 105,
                top: 190,
                child: Text(
                  "Edit password",
                  style:
                      GoogleFonts.alice(fontSize: 30, color: Color(0xff204854)),
                ),
              ),

              //old pass text
              Positioned(
                left: 55,
                top: 290,
                child: Text(
                  "Old Password",
                  style:
                      GoogleFonts.alice(fontSize: 20, color: Color(0xff204854)),
                ),
              ),
              //requierd
              Positioned(
                left: 185,
                top: 295,
                child: Text(
                  "*",
                  style: GoogleFonts.alice(
                      fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                ),
              ),

              //new pass text
              Positioned(
                left: 55,
                top: 380,
                child: Text(
                  "New password ",
                  style:
                      GoogleFonts.alice(fontSize: 20, color: Color(0xff204854)),
                ),
              ),
              //requierd
              Positioned(
                left: 190,
                top: 385,
                child: Text(
                  "*",
                  style: GoogleFonts.alice(
                      fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                ),
              ),

              //conf pass text
              Positioned(
                left: 55,
                top: 470,
                child: Text(
                  "Confirm New password",
                  style:
                      GoogleFonts.alice(fontSize: 20, color: Color(0xff204854)),
                ),
              ),
              //requierd
              Positioned(
                left: 270,
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
                          // String driverFname = "";
                          // String driverLname = "";
                          // String driverEmail = "";
                          // String drivePhone = "";
                          String driverpass = "";
                          String pass1 = "";
                          String pass2 = "";
                          // String phone0 = "";
                          String pass0 = "";

                          // bool fname = false;
                          // bool lname = false;
                          // bool phone = false;
                          bool pass = false;
                          bool cpass = false;
                          bool opass = false;

                          for (var n = 0; n < profile.length; n++) {
                            driverpass = profile[n]['password'].toString();
                            pass0 = profile[n]['password'].toString();
                            print(count);
                          }
                          return Container(
                              height: 850,
                              child: Stack(children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 50),
                                  child: TextButton(
                                      onPressed: () {
                                        if (pass0 != driverpass) {
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
                                              //           const driverProfile()),
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
                                          //           const driverProfile()),
                                          // );
                                        }
                                      },
                                      child: Image.asset('assets/back.png')),
                                ),
                                Center(
                                    // child: Form(
                                    child: Column(children: [
                                  SizedBox(
                                    height: 120,
                                  ),

                                  //old pass textfield
                                  Padding(
                                    padding: EdgeInsets.only(top: 200),
                                    child: Container(
                                      height: 50,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(161, 224, 224, 224),
                                        border: Border.all(
                                            color: Color.fromARGB(
                                                112, 158, 158, 158)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        key: form2Key,
                                        obscureText: _isObscure1,
                                        controller: c1,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 1),
                                          counterText: " ",
                                          hintText: 'old password',

                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 236, 231, 231))),
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
                                          // contentPadding: const EdgeInsets.only(
                                          //   left: 14.0,
                                          //   right: 12.0,
                                          //   bottom: 8.0,
                                          // ),
                                          //     top: 8.0),
                                          suffixIcon: IconButton(
                                              icon: Icon(_isObscure1
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                              onPressed: () {
                                                setState(() {
                                                  _isObscure1 = !_isObscure1;
                                                  //isAccepted();
                                                });
                                              }),
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
                                                new BorderRadius.circular(10),
                                          ),
                                        ),
                                        //controller: firstname,
                                        onChanged: (value) {
                                          driverpass = value;
                                        },
                                        validator: (value) {
                                          if (pass0 != driverpass) {
                                            opass = true;
                                            return " This is not your old password ";
                                          }
                                        },
                                      ),
                                    ),
                                  ),

                                  //new pass textfield

                                  Padding(
                                    padding: EdgeInsets.only(top: 40),
                                    child: Container(
                                      height: 50,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(161, 224, 224, 224),
                                        border: Border.all(
                                            color: Color.fromARGB(
                                                112, 158, 158, 158)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        key: form3Key, controller: c2,
                                        obscureText: _isObscure2,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 1),
                                          counterText: " ",
                                          hintText: 'new password',
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 236, 231, 231))),
                                          errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 236, 231, 231))),
                                          // contentPadding: const EdgeInsets.only(
                                          //     left: 14.0,
                                          //     right: 12.0,
                                          //     bottom: 8.0,
                                          //     top: 8.0),
                                          suffixIcon: IconButton(
                                              icon: Icon(_isObscure2
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                              onPressed: () {
                                                setState(() {
                                                  _isObscure2 = !_isObscure2;
                                                  //isAccepted();
                                                });
                                              }),
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
                                                new BorderRadius.circular(10),
                                          ),
                                        ),
                                        //controller: firstname,
                                        onChanged: (value) {
                                          pass1 = value;
                                          // print(pass1);
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty || value == null) {
                                            pass = false;
                                            return " Please Enter your Password ";
                                          } else if (value.length < 8) {
                                            pass = false;
                                            return "password lengt must be 8 or more";
                                          } else if (value.contains(' ')) {
                                            pass = false;
                                            return "spaces not allowed";
                                          } else if (value.length > 15) {
                                            pass = false;
                                            return "your password must be less than 15 ";
                                          } else if (!(value!.isEmpty ||
                                              value == null)) {
                                            pass = true;
                                          } else if (!(value.length < 8)) {
                                            pass = true;
                                          } else if (!(value.contains(' '))) {
                                            pass = true;
                                          } else if (!(value.length > 15)) {
                                            pass = true;
                                          }
                                        },
                                      ),
                                    ),
                                  ),

                                  //conf new pass

                                  Padding(
                                    padding: EdgeInsets.only(top: 35),
                                    child: Container(
                                      height: 50,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(161, 224, 224, 224),
                                        border: Border.all(
                                            color: Color.fromARGB(
                                                112, 158, 158, 158)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        key: form4Key, controller: c3,
                                        obscureText: _isObscure3,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 1),
                                          counterText: " ",
                                          hintText: 'Confirm New Password',
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 236, 231, 231))),
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
                                          // contentPadding: const EdgeInsets.only(
                                          //     left: 14.0,
                                          //     right: 12.0,
                                          //     bottom: 8.0,
                                          //     top: 8.0),
                                          suffixIcon: IconButton(
                                              icon: Icon(_isObscure3
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                              onPressed: () {
                                                setState(() {
                                                  _isObscure3 = !_isObscure3;
                                                  //isAccepted();
                                                });
                                              }),
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
                                                new BorderRadius.circular(10),
                                          ),
                                        ),
                                        //controller: firstname,
                                        onChanged: (value) {
                                          pass2 = value;
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty || value == null) {
                                            cpass = false;
                                            return " Please Enter your Password ";
                                          } else if (value.length < 8) {
                                            cpass = false;
                                            return "password lengt must be 8 or more";
                                          } else if (value.contains(' ')) {
                                            cpass = false;
                                            return "spaces not allowed";
                                          } else if (value.length > 15) {
                                            cpass = false;
                                            return "your password must be less than 15 ";
                                          } else if (pass2 != pass1) {
                                            return "password mismatch !";
                                          } else if (!(value!.isEmpty ||
                                              value == null)) {
                                            cpass = true;
                                          } else if (!(value.length < 8)) {
                                            cpass = true;
                                          } else if (!(value.contains(' '))) {
                                            cpass = true;
                                          } else if (!(value.length > 15)) {
                                            cpass = true;
                                          } else if (!(pass2 != pass1)) {
                                            cpass = true;
                                          }
                                        },
                                      ),
                                    ),
                                  ),

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
                                        if (!pass || !cpass) {
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
                                            title: 'Update Your Iformation ',
                                            desc:
                                                'Are you sure you want to update your information?',
                                            btnCancelOnPress: () {},
                                            btnOkOnPress: () async {
                                              setState(() {
                                                newPass = pass2;
                                              });
                                              await changePassword(
                                                  email: currentUser!.email,
                                                  oldPassword: c1.text,
                                                  newPassword: c3.text);
                                              print("password changed");
                                              FirebaseFirestore.instance
                                                  .collection("user affiliate")
                                                  .doc(profile[0].id)
                                                  .update({
                                                'password': pass2,
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
                                ])
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
