import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unibeethree/screen/Divider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'googleMap_Screen.dart';

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
  //int hide = googleMap_Screen.hide;

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
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (context) => myRides()));
            },
            child: new ListTile(
              leading:
                  Icon(Icons.calendar_month_outlined, color: Color(0xFFFDD051)),
              title: Text(
                "My Rides",
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
            child: TextButton(
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

                      Navigator.of(context).popUntil((route) => route.isFirst);
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
                )),
          ),
        ],
      ),
    );
  }
}
