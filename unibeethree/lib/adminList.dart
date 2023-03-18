import 'dart:collection';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unibeethree/affilateAcc.dart';
import 'package:unibeethree/driverAcc.dart';
import 'package:unibeethree/reports.dart';
import './AdminHP.dart';
import './webwelcome.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'orders.dart';




class adminList extends StatefulWidget {
  const adminList({super.key});

  @override
  State<adminList> createState() => _adminListState();
}

class _adminListState extends State<adminList> {
    
  final Stream<QuerySnapshot> readRequest = FirebaseFirestore.instance.collection("drivers").where('status', isEqualTo: false).snapshots();
  //final CollectionReference db = FirebaseFirestore.instance.collection("New Driver");
  
  
  void accepted() async {
    AwesomeDialog(
      width: 550,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: 'This driver has been accepted successfully',
      titleTextStyle: TextStyle(
                                        fontSize: 23,
                                    ),
      btnOkOnPress: () {},
    ).show();
  }


  void deleted() async {
    AwesomeDialog(
      width: 550,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: 'This driver has been rejected successfully',
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(40), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0), ),
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
                          border: Border.all(color: Colors.white, width: 2, ),
                      ),
                    ),
            ),

            //menu items
            Positioned.fill(
              child: Align (alignment: 
              Alignment.centerLeft,
              child: Container(
                width: 300,
                height: 300,
                child: Stack(
                    children:[
                    
                    //dashboard
                    Positioned(
                      left: 12,
                      top: 0,
                    child: TextButton( 
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminHP()));
                      },
                      child: Stack(
                    children:[
                      Container(
                      width: 25,
                      height: 25,
                      child: Image(
                      image: AssetImage('assets/images/dashboard.png'), color: Color(0xff4b6d76),),
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
                    ]
                  ),
                    ),
                    ),




                  //drivers reqistration requests
                  
                  Positioned(
                      left: 0,
                      top: 45,
                      child: TextButton(
                        onPressed: (){
                          //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => adminList()));
                        }, 
                        child: Stack( 
                        children:[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 135),
                        decoration:  BoxDecoration (
                        color:  Color(0xe5ffffff),
                        borderRadius:  BorderRadius.circular(10),
                      ),
                      ),
                        Padding(
                          padding: const EdgeInsets.only(left:10 , top: 5),
                          child: Text(
                                "registration requests",
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


                  //drivers
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

                  
                  //affiliate
                  Positioned(
                      left: 12,
                      top: 150,
                    child: TextButton( 
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => affiliateAcc()));
                      },
                      child: Stack(
                    children:[
                      Container(
                      width: 25,
                      height: 25,
                      child: Image(
                      image: AssetImage('assets/images/affiliate.png'), color: Color(0xff4b6d76),),
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
                    ]
                  ),
                    ),
                    ),

                  //orders
                  Positioned(
                      left: 12,
                      top: 200,
                    child: TextButton( 
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => orders()));
                      },
                      child: Stack(
                    children:[
                      Container(
                      width: 25,
                      height: 25,
                      child: Image(
                      image: AssetImage('assets/images/orders.png'), color: Color(0xff4b6d76),),
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
                    ]
                  ),
                    ),
                    ),
                  
                  
                ],
              ),
            )
          ),
                      
          ),


          /*my profile
          Positioned(
                      left: 12,
                      top: 515,
                    child: TextButton( 
                      onPressed: (){},
                      child: Stack(
                    children:[
                      Container(
                      width: 25,
                      height: 25,
                      child: Image(
                      image: AssetImage('assets/images/profile.png'),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: SizedBox(
                            width: 148,
                            height: 36,
                            child: Text(
                                "My Profile",
                                style: TextStyle(
                                    color: Color(0xff4b6d76),
                                    fontSize: 25,
                                ),
                            ),
                        ),
                      ),
                    ]
                  ),
                    ),
                    ),
*/

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
                      "New Drivers registration Requests",
                      style: TextStyle(
                        color: Color(0xffb9bc83),
                        fontSize: 35,
                      ),
                    ),
                  ),
                ),


            //driver name
            Positioned.fill(
              left: 410,
              top: 115,
              child: SizedBox(
              width: 171,
              height: 28,
              child: Text(
                  "Driver Name",
                  style: TextStyle(
                      color: Color(0xffb9bc83),
                      fontSize: 25,
                  ),
              ),
              ),
            ),

            //phone number
            Positioned.fill(
              left: 680,
              top: 115,
              child: SizedBox(
              width: 171,
              height: 28,
              child: Text(
                  "Phone Number",
                  style: TextStyle(
                      color: Color(0xffb9bc83),
                      fontSize: 25,
                  ),
              ),
              ),
            ),


          //golf car ID
            Positioned.fill(
              left: 900,
              top: 115,
              child: SizedBox(
              width: 171,
              height: 28,
              child: Text(
                  "Golf Car ID",
                  style: TextStyle(
                      color: Color(0xffb9bc83),
                      fontSize: 25,
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
                          border: Border.all(color: Colors.white, width: 2, ),
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
                                    image: AssetImage('assets/images/UniBeeWORD.png')),
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
                                    image: AssetImage('assets/images/UniBeeLOGO.png')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),// end logo

                        //new driver request
             Positioned.fill(
              left: 350,
              top: 140,
              right: 40,
              bottom: 50,
              child: Align(
                alignment: Alignment.topLeft,
                      child:
                      StreamBuilder<QuerySnapshot>(
                stream: readRequest,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasData){
                  final users = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: users.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                      width: 875,
                      height: 70,
                      margin: new EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0xff4b6d76), width: 1, ),
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
                            top: 15,
                            child: Container(
                                width: 35,
                                height: 35,
                                child: Image(
                                                image: AssetImage('assets/images/request.png'), color: Color(0xff4b6d76),),
                            ),
                          ),

                          Positioned(
                            left: 50,
                            top: 15,
                            child: SizedBox(
                              width: 163,
                              height: 28,
                              child: Text(
                                  "${users.docs[index]['first name']}",
                                  style: TextStyle(
                                      color: Color(0xff4b6d76),
                                      fontSize: 23,
                                  ),
                              ),
                                                  ),
                          ),

                          Positioned(
                            left: 135,
                            top: 15,
                            child: SizedBox(
                              width: 163,
                              height: 28,
                              child: Text(
                                  "${users.docs[index]['last name']}",
                                  style: TextStyle(
                                      color: Color(0xff4b6d76),
                                      fontSize: 23,
                                  ),
                              ),
                                                  ),
                          ),

                          Positioned(
                            left: 300,
                            top: 15,
                            child: SizedBox(
                              width: 163,
                              height: 28,
                              child: Text(
                                  "${users.docs[index]['phone']}",
                                  style: TextStyle(
                                      color: Color(0xff4b6d76),
                                      fontSize: 23,
                                  ),
                              ),
                                                  ),
                          ),

                          Positioned(
                            left: 530,
                            top: 15,
                            child: SizedBox(
                              width: 163,
                              height: 28,
                              child: Text(
                                  "${users.docs[index]['GolfCarId']}",
                                  style: TextStyle(
                                      color: Color(0xff4b6d76),
                                      fontSize: 23,
                                  ),
                              ),
                                                  ),
                          ),

                          //buttons
                          //accept
                          Positioned(
                            left: 640,
                            top: 15,
                            child:TextButton(
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
                                                                        'Are you sure you want to accept this driver?',
                                                                    titleTextStyle: TextStyle(
                                        fontSize: 23,
                                    ),
                                                                    btnCancelOnPress:
                                                                        () {},
                                                                    btnOkOnPress:
                                                                        () {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "drivers")
                                                                          .doc(users.docs[index]
                                                                              .id)
                                                                          .update({
                                                                        'status':
                                                                            true,
                                                                      });
                                                                      accepted();
                                                                    },
                                                                    btnCancelText:
                                                                        "No",
                                                                    btnOkText:
                                                                        "Yes",
                                                                    btnCancelColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            211,
                                                                            59,
                                                                            42),
                                                                    btnOkColor:
                                                                        Color(
                                                                            0xFF00CA71),
                                                                  ).show();}
                            //   showDialog<String>(
                            //   context: context,
                            //   builder: (BuildContext context) => AlertDialog(
                            //     title: const Text('Accept Driver'),
                            //     content: const Text('Are you sure you want to accept this driver?'),
                            //     actions: <Widget>[
                            //       TextButton(
                            //         onPressed: () async {
                            //           FirebaseFirestore.instance.collection("drivers").doc(users.docs[index].id).update({
                            //                             'status':true,
                            //                           });
                            //           Navigator.pop(context, 'YES');
                            //         },
                            //         child: const Text('YES'),
                            //       ),
                            //       TextButton(
                            //         onPressed: () async => Navigator.pop(context, 'NO'),
                            //         child: const Text('NO'),
                            //       ),
                            //     ],
                            //   ),
                            // )
                            ,
                              child: Stack(
                                children:[
                                   Container(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xffade194),
                          ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:15 , top: 5),
                                child: Text(
                                    "Accept",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 23,
                                    ),
                                ),
                              ),
                              ],),
                                                  ),
                          ),


                          //reject
                          Positioned(
                            left: 750,
                            top: 15,
                            child:TextButton(
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
                                                                      'Are you sure you want to reject this request?',
                                                                  titleTextStyle: TextStyle(
                                        fontSize: 23,
                                    ),
                                                                  btnCancelOnPress:
                                                                      () {},
                                                                  btnOkOnPress:
                                                                      () {
                                                                        FirebaseFirestore.instance.collection("drivers").doc(users.docs[index].id).delete();
                                                                        deleted();
                                      //Navigator.pop(context, 'YES');
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
                                                                ).show();}
                                                                ,
//
                              child: Stack(
                                children:[
                                   Container(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xccfd8087),
                          ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:19 , top: 5),
                                child: Text(
                                    "Reject",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 23,
                                    ),
                                ),
                              ),
                              ],),
                                                  ),
                          ),


                        ],
                      )
                    );
                       },
                    );
                } 
                else {
                  return Center(child: CircularProgressIndicator());
                }
            }
            ),
            ),
             ),


            //yellow
                        Positioned.fill(
              left: 1050,
              top: 0,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 230,
                  height: 134,
                  child: Image(
                                    image: AssetImage('assets/images/yellow1.png')),
                ),
              ),
            ),



            //pink
            Positioned.fill(
              left: 410,
              top: 0,
              child: Align(alignment: Alignment.topRight,
              child: Container(
              width: 855,
              height: 70,
              child: Image(
                   image: AssetImage('assets/images/pink1.png')),
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


          ],
        )
    )
    );
  }
}

