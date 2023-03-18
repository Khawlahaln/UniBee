import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unibeethree/affilateAcc.dart';
import 'package:unibeethree/webwelcome.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';

import 'AdminHP.dart';
import 'adminList.dart';
import 'commanFunctions.dart';
import 'driverAcc.dart';
import 'orders.dart';

class ExpantionReports{
  bool isExpanded;
  final String header;
  final String body;

  ExpantionReports({this.isExpanded = false , required this.header , required this.body});
}

class reports extends StatefulWidget {
  const reports({super.key});

  @override
  State<reports> createState() => reportsState();
}

class reportsState extends State<reports> {
  final Stream<QuerySnapshot> readRequest =
      FirebaseFirestore.instance.collection("orders").where('reported', isEqualTo: true).snapshots();

     List <ExpantionReports> reportsList = <ExpantionReports>[];
     bool expandedReverse =false;

  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd MMM, yyyy  hh:mm a').format(dateFromTimeStamp);
  }

  void deleted() async {
    AwesomeDialog(
      width: 550,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: 'This report has been deleted successfully',
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
                      width: 290,
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
 Positioned(
                      left: 12,
                      top: 100,
                    child: TextButton( 
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => driverAcc()));
                      },
                      child: Stack(
                    children:[
                      Container(
                      width: 25,
                      height: 25,
                      child: Image(
                      image: AssetImage('assets/images/driver.png'), color: Color(0xff4b6d76),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: SizedBox(
                            width: 194,
                            height: 37,
                            child: Text(
                                "Drivers",
                                style: TextStyle(
                                    color: Color(0xff4b6d76),
                                    fontSize: 23,
                                ),
                            ),
                        ),
                      ),
                    ]
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

                            //reports
                            Positioned(
                              left: 0,
                              top: 245,
                              child: TextButton(
                                onPressed: () {
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminHP()));
                                },
                                child: Stack(children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 22, horizontal: 138),
                                      decoration: BoxDecoration(
                                        color: Color(0xe5ffffff),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:10 , top: 5),
                                    child: SizedBox(
                                      width: 124,
                                      height: 44,
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
                          ],
                        ),
                      )),
                ),
              //reports
              
        
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
                                                                      'Are you sure you want to signout?',
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
                      "Reports list",
                      style: TextStyle(
                        color: Color(0xffb9bc83),
                        fontSize: 35,
                      ),
                    ),
                  ),
                ),

                // //affiliate email
                // Positioned.fill(
                //   left: 345,
                //   top: 130,
                //   child: SizedBox(
                //     width: 200,
                //     height: 28,
                //     child: Text(
                //       "Affiliate Email",
                //       style: TextStyle(
                //         color: Color(0xffb9bc83),
                //         fontSize: 23,
                //       ),
                //     ),
                //   ),
                // ),

                // //driver email
                // Positioned.fill(
                //   left: 625,
                //   top: 130,
                //   child: SizedBox(
                //     width: 200,
                //     height: 28,
                //     child: Text(
                //       "Driver Email",
                //       style: TextStyle(
                //         color: Color(0xffb9bc83),
                //         fontSize: 23,
                //       ),
                //     ),
                //   ),
                // ),

                // //date
                // Positioned.fill(
                //   left: 890,
                //   top: 130,
                //   child: SizedBox(
                //     width: 171,
                //     height: 28,
                //     child: Text(
                //       "Date",
                //       style: TextStyle(
                //         color: Color(0xffb9bc83),
                //         fontSize: 23,
                //       ),
                //     ),
                //   ),
                // ),

                // //status
                // Positioned.fill(
                //   left: 1075,
                //   top: 130,
                //   child: SizedBox(
                //     width: 171,
                //     height: 28,
                //     child: Text(
                //       "Status",
                //       style: TextStyle(
                //         color: Color(0xffb9bc83),
                //         fontSize: 23,
                //       ),
                //     ),
                //   ),
                // ),

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

                //orders list
                Positioned.fill(
                  left: 275,
                  top: 150,
                  right: 30,
                  bottom: 50,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: readRequest,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot){
                          if (snapshot.hasData) {
                            reportsList.clear();
                            final users = snapshot.data!.docs;
                                  //List <ExpantionReports> reportsList = <ExpantionReports>[];
                                  
                            for (int i = 0 ; i < users.length ; i++){
                              // if(users[i]["isExpanded"]==true)
                              // FirebaseFirestore
                              //                                             .instance
                              //                                             .collection(
                              //                                                 "reports")
                              //                                             .doc(users[i]
                              //                                                 .id)
                              //                                             .update({
                              //                                           'isExpanded':
                              //                                               expandedReverse,
                              //                                         });
                              reportsList.add(ExpantionReports(header:"${users[i]['email']} uploaded a report" , body:"${users[i]['report']}"));}
                            return ListView(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 50),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: [
                                ExpansionPanelList(
                                  expansionCallback: (int panelIndex,bool isExpanded) {
                                    setState(() {
                                     // print(expandedReverse);
                                      expandedReverse = !isExpanded;
                                     // print(expandedReverse);
                                      reportsList[panelIndex].isExpanded = expandedReverse;
                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "orders")
                                                                          .doc(users[panelIndex]
                                                                              .id)
                                                                          .update({
                                                                        'isExpanded':
                                                                            expandedReverse,
                                                                      });
                                    });
                                  },
                                  children:[
                                  for(int x = 0 ; x <users.length ; x++)
                                    ExpansionPanel(
                                      backgroundColor: Color.fromARGB(255, 236, 246, 250) ,
                                      isExpanded: users[x]["isExpanded"]??"",
                                     // canTapOnHeader: true,
                                      headerBuilder: (BuildContext context, bool isExpanded) {
                                        
                                        return Padding(
                                          padding: const EdgeInsets.only(top:15 , left: 10),
                                          child: Container(
                                            child: Text(reportsList[x].header ,
                                            style: TextStyle(
                                                color: Color.fromARGB(255, 132, 134, 82),
                                                fontSize: 18,
                                              ),),
                                          ),
                                        );
                                      }, 
                                      
                                      body: 
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30, bottom: 10),
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child:Stack( 
                                            children:[
                                            //Positioned(
                                              // left: 0,
                                              //   top: 0,
                                              //child:
                                   
                                                Container(
                                                  width: 1000,
                                                  child: Column(
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Affiliate Email: ",
                                                                                        style: TextStyle(
                                                    color: Color.fromARGB(255, 13, 43, 51),
                                                    fontSize: 18,
                                                  ),
                                                  ),
                                                  SizedBox(
                                                          height: 5
                                                        ),
                                                  Text(
                                                                                        "Driver Email:  "
                                                                                    ,
                                                                                        style: TextStyle(
                                                    color: Color.fromARGB(255, 13, 43, 51),
                                                    fontSize: 18,
                                                  ),
                                                  ),
                                                  SizedBox(
                                                          height: 5
                                                        ),
                                                  Text(
                                                                                        "Order date:  ",
                                                                                        style: TextStyle(
                                                    color: Color.fromARGB(255, 13, 43, 51),
                                                    fontSize: 18,
                                                  ),
                                                  ),
                                                  SizedBox(
                                                          height: 5
                                                        ),
                                                  Text(
                                                                                        "Description: \n ",
                                                                                        style: TextStyle(
                                                    color: Color.fromARGB(255, 13, 43, 51),
                                                    fontSize: 18,
                                                  ),
                                                  ),
                                                  SizedBox(
                                                          height: 5
                                                        ),
                                                    ],
                                                  )
                                                ),
                                       
                                            //),

                                                 Positioned(
                                                   left: 130,
                                                
                                                  child: 
                                                  Container(
                                                    width: 400,
                                                    child:
                                                     Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                       children:[ 
                                                        // Text( "${users[x]['email']}" +"\n"
                                                        //     "${users[x]['driverEmail']}" + "\n"
                                                        //     + formattedDate(
                                                        // users[x]['date']) + "\n"+
                                                        //   reportsList[x].body +"\n",
                                                        //   style: TextStyle(
                                                        //   color: Color.fromARGB(255, 88, 135, 148),
                                                        //   fontSize: 18,
                                                        // ),
                                                        // overflow: TextOverflow.visible,
                                                        // textWidthBasis: TextWidthBasis.parent,
                                                        // ),
                                                        Text( "${users[x]['email']}",
                                                          style: TextStyle(
                                                          color: Color.fromARGB(255, 88, 135, 148),
                                                          fontSize: 18,
                                                        ),
                                                        overflow: TextOverflow.visible,
                                                        textWidthBasis: TextWidthBasis.parent,
                                                        ),
                                                        SizedBox(
                                                          height: 5
                                                        ),
                                                        Text( "${users[x]['driverEmail']}",
                                                          style: TextStyle(
                                                          color: Color.fromARGB(255, 88, 135, 148),
                                                          fontSize: 18,
                                                        ),
                                                        overflow: TextOverflow.visible,
                                                        textWidthBasis: TextWidthBasis.parent,
                                                        ),
                                                        SizedBox(
                                                          height: 5
                                                        ),
                                                        Text( formattedDate(
                                                        users[x]['date']) ,
                                                          style: TextStyle(
                                                          color: Color.fromARGB(255, 88, 135, 148),
                                                          fontSize: 18,
                                                        ),
                                                        overflow: TextOverflow.visible,
                                                        textWidthBasis: TextWidthBasis.parent,
                                                        ),
                                                        SizedBox(
                                                          height: 5
                                                        ),
                                                        Text( reportsList[x].body ,
                                                          style: TextStyle(
                                                          color: Color.fromARGB(255, 88, 135, 148),
                                                          fontSize: 18,
                                                        ),
                                                        overflow: TextOverflow.visible,
                                                        textWidthBasis: TextWidthBasis.parent,
                                                        ),
                                                       ]
                                                     ),
                                                  ),
                                                
                                                 ),
                           
                                      
                                      
                                      StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                                .collection("drivers")
                                                .where("email",
                                                    isEqualTo: users[x]
                                                        ['driverEmail'])
                                                .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData)
                                            return Container();

                                            final drivers = snapshot.data!.docs;
                                          return Positioned(
                                              left: 750,
                                              top: 60,
                                              child: 
                                              
                                              TextButton(
                                                onPressed: () {
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
                                                                            'Are you sure you want to delete this report?',
                                                                        titleTextStyle: TextStyle(
                                            fontSize: 23,
                                                                          ),
                                                                        btnCancelOnPress:
                                                                            () {},
                                                                        btnOkOnPress:
                                                                            () {
                                                                              //final driverE = users[x]["driverEmail"];
                                                                              //print(driverE);
                                                                          FirebaseFirestore.instance.collection("orders").doc(users[x].id).update({'reported':false,});
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection(
                                                                                  "orders")
                                                                              .doc(users[x]
                                                                                  .id)
                                                                              .update({
                                                                            'isExpanded':
                                                                                false,
                                                                          });
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
                                                }
                                                
                                                ,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: 135,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 20,
                                                          horizontal: 50),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                        color: Color.fromARGB(204, 227, 47, 56),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 9, top: 8),
                                                      child: Text(
                                                        "Delete report",
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
                                        }
                                      ),
                                           StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection("Notifications")
                                                .where("email",
                                                    isEqualTo: users[x]
                                                        ['driverEmail'])
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData)
                                                return Container();
                                              final not = snapshot.data!.docs;
                                              // if (not.isEmpty)
                                              //   return Container();
                                              return Positioned(
                                                left: 600,
                                              top: 60,
                                                child: TextButton(
                                                  onPressed: () => AwesomeDialog(
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
                                                                  users[
                                                                          x]
                                                                      ['driverEmail'],
                                                                  context, 'report');
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
                                                     ,
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
                                                          color: Color(
                                                                  0xccfd8087),
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
                                            })
                                            ,
                                            ]
                                          ),
                                        ),
                                      )
                                      )
                                  
                                  ]
                                )
                              ],
                         //     ),
                              
                            //  );
                              
                              //    Container(
                              //       width: 4000,

                              //       ///affilate email
                              //       height: 65,
                              //       margin: new EdgeInsets.only(bottom: 15),
                              //       decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(5),
                              //         border: Border.all(
                              //           color: Color(0xff4b6d76),
                              //           width: 1,
                              //         ),
                              //         boxShadow: [
                              //           BoxShadow(
                              //             color: Color(0x3f000000),
                              //             blurRadius: 4,
                              //             offset: Offset(0, 4),
                              //           ),
                              //         ],
                              //         color: Colors.white,
                              //       ),
                              //       child: Stack(
                              //         children: [
                              //           Positioned(
                              //             left: 15,
                              //             top: 20,
                              //             child: SizedBox(
                              //               width: 263,
                              //               height: 28,
                              //               child: Text(
                              //                 "${users.docs[index]['email']} ",
                              //                 style: TextStyle(
                              //                   color: Color(0xff4b6d76),
                              //                   fontSize: 18,
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                                        
                              //           Positioned(
                              //             left: 290,
                              //             top: 20,
                              //             child: SizedBox(
                              //               //width: 180,
                              //               height: 28,
                              //               child: Text(
                              //                 " uploaded a report on ${users.docs[index]['driverEmail']}",
                              //                 style: TextStyle(
                              //                   color: Color(0xc44b6c76),
                              //                   fontSize: 19,
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //           //0xaa4b6c76 lightest
                              //           //0xc44b6c76 normal
                              //           // 0xff4b6d76 dark

                              //           // Positioned(
                              //           //   left: 700,
                              //           //   top: 20,
                              //           //   child: TextButton(
                              //           //     onPressed: () {
                                            
                              //           //   },
                              //           //     child: Text(
                              //           //       "View report details",
                              //           //       style: TextStyle(
                              //           //         color: Color(0xff4b6d76),
                              //           //         fontSize: 25,
                              //           //         decoration: TextDecoration.underline,
                              //           //       )
                              //           //     )
                              //           //   ),
                                        
                              //           // ),

                                        
                              // //           Positioned(
                              // //             left: 500,
                              // //             top: 20,
                              // //             child: SizedBox(
                              // //               width: 263,
                              // //               height: 28,
                              // //               child: Text(formattedDate(
                              // //                 users.docs[index]['date']),
                              // //                 style: TextStyle(
                              // //                   color: Color(0xff4b6d76),
                              // //                   fontSize: 19,
                              // //                 ),
                              // //               ),
                              // //             ),
                              // //           ),

                              // //           Positioned(
                              // //             left: 650,
                              // //             top: 20,
                              // //             child: SizedBox(
                              // //               width: 263,
                              // //               height: 28,
                              // //               child: Text(
                              // //                 "${users.docs[index]['status']}",
                              // //                 style: TextStyle(
                              // //                   color: (users.docs[index]['status']== "completed")
                              // // ? Color(0xff429FA5)
                              // // : (users.docs[index]['status']== "waiting") ?Color(0xff9d9d9d) : Color(0xff8DBA53) ,
                              // //                   //Color(0xff4b6d76),
                              // //                   fontSize: 20,
                              // //                   fontWeight: FontWeight.w400,
                              // //                 ),
                              // //                 textAlign: TextAlign.center,
                              // //               ),
                              // //             ),
                              // //           ),

                              // //           //buttons

                              // //           //reject
                              // //           Positioned(
                              // //             left: 870,
                              // //             top: 13,
                              // //             child: TextButton(
                              // //               onPressed: () {
                              // //                 AwesomeDialog(
                              // //   width: 550,
                              // //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              // //                                       context:
                              // //                                           context,
                              // //                                       animType:
                              // //                                           AnimType
                              // //                                               .leftSlide,
                              // //                                       headerAnimationLoop:
                              // //                                           false,
                              // //                                       dialogType:
                              // //                                           DialogType
                              // //                                               .question,
                              // //                                       title:
                              // //                                           'Are you sure you want to delete this order?',
                              // //                                       titleTextStyle: TextStyle(
                              // //           fontSize: 23,
                              // //       ),
                              // //                                       btnCancelOnPress:
                              // //                                           () {},
                              // //                                       btnOkOnPress:
                              // //                                           () {
                              // //                                         FirebaseFirestore.instance.collection("orders").doc(users.docs[index].id).delete();
                              // //                                       },
                              // //                                       btnCancelText:
                              // //                                           "No",
                              // //                                       btnOkText:
                              // //                                           "Yes",
                              // //                                       btnCancelColor:
                              // //                                           Color.fromARGB(
                              // //                                               255,
                              // //                                               211,
                              // //                                               59,
                              // //                                               42),
                              // //                                       btnOkColor:
                              // //                                           Color(
                              // //                                               0xFF00CA71),
                              // //                                     ).show();
                              // //               }
                                            
                              // //               ,
                              // //               child: Stack(
                              // //                 children: [
                              // //                   Container(
                              // //                     padding: const EdgeInsets
                              // //                             .symmetric(
                              // //                         vertical: 19,
                              // //                         horizontal: 47),
                              // //                     decoration: BoxDecoration(
                              // //                       borderRadius:
                              // //                           BorderRadius.circular(
                              // //                               10),
                              // //                       color: Color(0xccfd8087),
                              // //                     ),
                              // //                   ),
                              // //                   Padding(
                              // //                     padding:
                              // //                         const EdgeInsets.only(
                              // //                             left: 16, top: 7),
                              // //                     child: Text(
                              // //                       "Delete",
                              // //                       style: TextStyle(
                              // //                         color: Colors.white,
                              // //                         fontSize: 20,
                              // //                       ),
                              // //                     ),
                              // //                   ),
                              // //                 ],
                              // //               ),
                              // //             ),
                              // //           ),
                              //         ],
                                   // ));
                            
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
