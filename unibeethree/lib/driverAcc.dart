import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unibeethree/affilateAcc.dart';
import 'package:unibeethree/reports.dart';
import 'package:unibeethree/webwelcome.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


import 'AdminHP.dart';
import 'adminList.dart';
import 'orders.dart';
import 'commanFunctions.dart';

class driverAcc extends StatefulWidget {
  const driverAcc({super.key});

  @override
  State<driverAcc> createState() => _driverAccState();
}

class _driverAccState extends State<driverAcc> {
  final Stream<QuerySnapshot> readRequest =
      FirebaseFirestore.instance.collection("drivers").where('status', isEqualTo: true).snapshots();

        void deleted() async {
    AwesomeDialog(
      width: 550,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: 'This driver has been deleted successfully',
      titleTextStyle: TextStyle(
                                        fontSize: 23,
                                    ),
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: 1440,
            height: 832,
            color: Colors.white,
            child: Stack(
              children: [
                //left menu
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: 285,
                      height: 832,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                        color: Color(0xffdbeaef),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 0,
                  top: 100,
                  child: Container(
                    width: 318,
                    height: 3,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                //menu items
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 300,
                        height: 300,
                        child: Stack(
                          children: [
                            //dashboard
                            Positioned(
                              left: 12,
                              top: 0,
                              child: TextButton(
                                onPressed: () {
                                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminHP()));
                                },
                                child: Stack(children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    child: Image(
                                      image: AssetImage('assets/images/dashboard.png'),
                                      color: Color(0xff4b6d76),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 35),
                                    child: SizedBox(
                                      width: 200,
                                      height: 45,
                                      child: Text(
                                        "Dashboard",
                                        style: TextStyle(
                                          color: Color(0xff4b6d76),
                                          fontSize: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),

                            //drivers reqistration requests
                            Positioned(
                              left: 12,
                              top: 45,
                              child: TextButton(
                                onPressed: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => adminList()));
                                },
                                child: Stack(children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    child: Image(
                                      image: AssetImage('assets/images/request.png'),
                                      color: Color(0xff4b6d76),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 35),
                                    child: SizedBox(
                                      width: 250,
                                      height: 36,
                                      child: Text(
                                        "registration requests",
                                        style: TextStyle(
                                          color: Color(0xff4b6d76),
                                          fontSize: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),

                            //drivers

                            Positioned(
                              left: 0,
                              top: 95,
                              child: TextButton(
                                onPressed: () {},
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 22, horizontal: 135),
                                      decoration: BoxDecoration(
                                        color: Color(0xe5ffffff),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5),
                                      child: Text(
                                        "Drivers",
                                        style: TextStyle(
                                          color: Color(0xff4b6d76),
                                          fontSize: 23,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Positioned(
                              left: 12,
                              top: 155,
                              child: TextButton(
                                onPressed: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => affiliateAcc()));
                                },
                                child: Stack(children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    child: Image(
                                      image: AssetImage('assets/images/affiliate.png'),
                                      color: Color(0xff4b6d76),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 35),
                                    child: SizedBox(
                                      width: 250,
                                      height: 36,
                                      child: Text(
                                        "University Affiliate",
                                        style: TextStyle(
                                          color: Color(0xff4b6d76),
                                          fontSize: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),

                            //orders
                            Positioned(
                              left: 12,
                              top: 200,
                              child: TextButton(
                                onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => orders()));
                                },
                                child: Stack(children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    child: Image(
                                      image: AssetImage('assets/images/orders.png'),
                                      color: Color(0xff4b6d76),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 35),
                                    child: SizedBox(
                                      width: 124,
                                      height: 44,
                                      child: Text(
                                        "Orders",
                                        style: TextStyle(
                                          color: Color(0xff4b6d76),
                                          fontSize: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),

                Positioned(
                              left: 12,
                              top: 430,
                              child: TextButton(
                                onPressed: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => reports()));
                                },
                                child: Stack(children: [
                                  Container(
                                    width: 33,
                                    height: 33,
                                    child: Image(
                                      image: AssetImage('assets/images/report1.png'),
                                      color: Color(0xff4b6d76),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 37),
                                    child: SizedBox(
                                      width: 260,
                                      height: 36,
                                      child: Text(
                                        "Reports",
                                        style: TextStyle(
                                          color: Color(0xff4b6d76),
                                          fontSize: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),


                //logout
Positioned(
                  left: 12,
                  top: 520,
                  child: TextButton(
                    onPressed: () {
                        AwesomeDialog(
                          width: 550,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                                                                      'Are you sure you want to sign out?',
                                                                      titleTextStyle: TextStyle(
                                        fontSize: 23,
                                    ),
                                                                  btnCancelOnPress:
                                                                      () {},
                                                                  btnOkOnPress:
                                                                      () {
                                                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => webwelcome()));
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
                    child: Stack(children: [
                      Container(
                        width: 25,
                        height: 25,
                        child: Image(
                          image: AssetImage('assets/images/logout1.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: SizedBox(
                          width: 143,
                          height: 44,
                          child: Text(
                            "sign out",
                            style: TextStyle(
                              color: Color(0xff4b6d76),
                              fontSize: 23,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),


                //affiliate account
                Positioned.fill(
                  left: 320,
                  top: 45,
                  child: SizedBox(
                    width: 171,
                    height: 28,
                    child: Text(
                      "Driver accounts list",
                      style: TextStyle(
                        color: Color(0xffb9bc83),
                        fontSize: 35,
                      ),
                    ),
                  ),
                ),

                //driver name
                Positioned.fill(
                  left: 350,
                  top: 130,
                  child: SizedBox(
                    width: 171,
                    height: 28,
                    child: Text(
                      "Name",
                      style: TextStyle(
                        color: Color(0xffb9bc83),
                        fontSize: 23,
                      ),
                    ),
                  ),
                ),

                //phone number
                Positioned.fill(
                  left: 470,
                  top: 130,
                  child: SizedBox(
                    width: 171,
                    height: 28,
                    child: Text(
                      "Phone Number",
                      style: TextStyle(
                        color: Color(0xffb9bc83),
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),

                //email
                Positioned.fill(
                  left: 670,
                  top: 130,
                  child: SizedBox(
                    width: 171,
                    height: 28,
                    child: Text(
                      "E-mail",
                      style: TextStyle(
                        color: Color(0xffb9bc83),
                        fontSize: 23,
                      ),
                    ),
                  ),
                ),

                //golf car ID
                Positioned.fill(
                  left: 820,
                  top: 130,
                  child: SizedBox(
                    width: 171,
                    height: 28,
                    child: Text(
                      "Golf car ID",
                      style: TextStyle(
                        color: Color(0xffb9bc83),
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),

                Positioned.fill(
                  left: 960,
                  top: 130,
                  child: SizedBox(
                    width: 171,
                    height: 28,
                    child: Text(
                      "Rating",
                      style: TextStyle(
                        color: Color(0xffb9bc83),
                        fontSize: 23,
                      ),
                    ),
                  ),
                ),

                //bottom line
                Positioned(
                  left: 0,
                  top: 500,
                  child: Container(
                    width: 318,
                    height: 3,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                //logo
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Stack(
                              children: [
                                //unibeeWord
                                Positioned(
                                  left: 105,
                                  top: 45,
                                  child: Container(
                                    width: 133.38,
                                    height: 35,
                                    child: Image(
                                        image: AssetImage(
                                            'assets/images/UniBeeWORD.png')),
                                  ),
                                ),
                                //unibeeLogo
                                Positioned(
                                  left: 10,
                                  top: 5,
                                  child: Container(
                                    width: 120,
                                    height: 95,
                                    child: Image(
                                        image: AssetImage(
                                            'assets/images/UniBeeLOGO.png')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ), // end logo

                //yellow
                Positioned.fill(
                  left: 1050,
                  top: 0,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 230,
                      height: 134,
                      child: Image(image: AssetImage('assets/images/yellow1.png')),
                    ),
                  ),
                ),

                //pink
                Positioned.fill(
                  left: 410,
                  top: 0,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 855,
                      height: 70,
                      child: Image(image: AssetImage('assets/images/pink1.png')),
                    ),
                  ),
                ),

                //line of footer
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: 1440,
                      height: 30,
                      color: Color(0xff4b6d76),
                    ),
                  ),
                ),

                //copy right
                Positioned.fill(
                  bottom: 8,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      child: Text(
                        "©2022 UniBee. All rights reserved.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),

                //Driver account
                Positioned.fill(
                  left: 265,
                  top: 170,
                  right: 0,
                  bottom: 50,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: readRequest,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            final users = snapshot.data!;
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 50),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: users.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    width: 4000,

                                    ///
                                    height: 73,
                                    margin: new EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Color(0xff4b6d76),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x3f000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      color: Colors.white,
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 15,
                                          top: 23,
                                          child: SizedBox(
                                            width: 263,
                                            height: 28,
                                            child: Text(
                                              "${users.docs[index]['first name'] + " " + users.docs[index]['last name']} ",
                                              style: TextStyle(
                                                color: Color(0xff4b6d76),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          left: 180,
                                          top: 23,
                                          child: SizedBox(
                                            width: 163,
                                            height: 28,
                                            child: Text(
                                              "${users.docs[index]['phone']}",
                                              style: TextStyle(
                                                color: Color(0xff4b6d76),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          left: 320,
                                          top: 23,
                                          child: SizedBox(
                                            width: 263,
                                            height: 28,
                                            child: Text(
                                              "${users.docs[index]['email']}",
                                              style: TextStyle(
                                                color: Color(0xff4b6d76),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          left: 540,
                                          top: 23,
                                          child: SizedBox(
                                            width: 263,
                                            height: 28,
                                            child: Text(
                                              "${users.docs[index]['GolfCarId']}",
                                              style: TextStyle(
                                                color: Color(0xff4b6d76),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          left: 600,
                                          top: 3,
                                          child: SizedBox(
                                            width: 163,
                                            // height: 50,
                                            child: Column(
                                              children: [
                                                Text(
                                                  users.docs[index]['avgRate']
                                                      .toStringAsFixed(1),
                                                  style: TextStyle(
                                                    color: Color(0xff204854),
                                                    fontSize: 20,
                                                    fontFamily: 'Alice',
                                                    //fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 1,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .90,
                                                  // height: 20.0,
                                                  decoration: new BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color:
                                                        const Color(0xFFFFFF),
                                                    borderRadius:
                                                        new BorderRadius.all(
                                                            new Radius.circular(
                                                                32.0)),
                                                  ),
                                                  child: Center(
                                                    child: RatingBarIndicator(
                                                      rating: users.docs[index]
                                                          ['avgRate'],
                                                      itemSize: 20,
                                                      direction:
                                                          Axis.horizontal,
                                                      itemCount: 5,
                                                      itemPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0.0),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          left: 646,
                                          top: 47,
                                          child: SizedBox(
                                            width: 263,
                                            height: 28,
                                            child: Text(
                                              "(${users.docs[index]['numOfRates']} ratings)",
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 99, 115, 120),
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),


                                        //buttons

                                                                                StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection("Notifications")
                                                .where("email",
                                                    isEqualTo: users.docs[index]
                                                        ['email'])
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData)
                                                return Container();
                                              final not = snapshot.data!.docs;
                                              // if (not.isEmpty)
                                              //   return Container();
                                              return Positioned(
                                                left: 750,
                                                top: 15,
                                                child: TextButton(
                                                  onPressed: users.docs[index][
                                                                  'numOfRates'] !=
                                                              0 &&
                                                          users.docs[index]
                                                                  ['avgRate'] <
                                                              2 &&
                                                          (not.isEmpty ||
                                                              not.first['read'])
                                                      ? () => AwesomeDialog(
                                                            context: context,
                                                            width: 500,
                                                            animType: AnimType
                                                                .leftSlide,
                                                            headerAnimationLoop:
                                                                false,
                                                            dialogType:
                                                                DialogType
                                                                    .question,
                                                            title:
                                                                'Are you sure you want to warn this driver?',
                                                            btnOkOnPress: () {
                                                              AwesomeDialog(
                                                                context:
                                                                    context,
                                                                width: 500,
                                                                animType: AnimType
                                                                    .leftSlide,
                                                                headerAnimationLoop:
                                                                    false,
                                                                dialogType:
                                                                    DialogType
                                                                        .success,
                                                                title:
                                                                    'The warn sent successfully',
                                                                btnOkOnPress:
                                                                    () {},
                                                              ).show();

                                                              addNotification(
                                                                  users.docs[
                                                                          index]
                                                                      ['email'],
                                                                  context , 'rating');
                                                            },
                                                            btnCancelOnPress:
                                                                () {},
                                                            btnCancelText:
                                                                        "No",
                                                                    btnOkText:
                                                                        "Yes",
                                                                    btnCancelColor:
                                                                    Color(
                                                                            0xFF00CA71),
                                                                    btnOkColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            211,
                                                                            59,
                                                                            42),
                                                          ).show()
                                                      : null,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        width: 135,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 20,
                                                                horizontal: 50),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: users.docs[
                                                                              index]
                                                                          [
                                                                          'numOfRates'] !=
                                                                      0 &&
                                                                  users.docs[index]
                                                                          [
                                                                          'avgRate'] <
                                                                      2 &&
                                                                  (not.isEmpty ||
                                                                      not.first[
                                                                          'read'])
                                                              ? Color(
                                                                  0xccfd8087)
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 9,
                                                                top: 8),
                                                        child: Text(
                                                          "Send Warning",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 19,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),

                                        //reject
                                        Positioned(
                                          left: 895,
                                          top: 15,
                                          child: TextButton(
                                            onPressed: (){
                                              AwesomeDialog(
                                width: 550,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                                                                        'Are you sure you want to delete this driver?',
                                                                    titleTextStyle: TextStyle(
                                        fontSize: 23,
                                    ),
                                                                    btnCancelOnPress:
                                                                        () {},
                                                                    btnOkOnPress:
                                                                        () {
                                                                      FirebaseFirestore.instance.collection("drivers").doc(users.docs[index].id).delete();
                                                                      deleted();
                                                                    },
                                                                    btnCancelText:
                                                                        "No",
                                                                    btnOkText:
                                                                        "Yes",
                                                                    btnCancelColor:
                                                                    Color(
                                                                            0xFF00CA71),
                                                                    btnOkColor:
                                                                        Color.fromARGB(
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
                                                      vertical: 20,
                                                      horizontal: 42),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Color(0xccfd8087),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12, top: 8),
                                                  child: Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                              },
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ),
                ),
              ],
            )));
  }
}
