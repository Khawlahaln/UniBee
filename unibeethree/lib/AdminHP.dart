import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unibeethree/affilateAcc.dart';
import 'package:unibeethree/driverAcc.dart';
import './adminList.dart';
import './webwelcome.dart';
import 'orders.dart';
import 'reports.dart';


class AdminHP extends StatefulWidget {

   const AdminHP ({super.key});
    @override
  State<AdminHP> createState() => _AdminHPState();
}

class _AdminHPState extends State<AdminHP> {


  final Stream<QuerySnapshot> readRequest = FirebaseFirestore.instance.collection("drivers").where('status', isEqualTo: false).snapshots();
  final Stream<QuerySnapshot> readDrivers = FirebaseFirestore.instance.collection("drivers").where('status', isEqualTo: true).snapshots();
  final Stream<QuerySnapshot> readAffiliate = FirebaseFirestore.instance.collection("user affiliate").snapshots();
  final Stream<QuerySnapshot> readOrders = FirebaseFirestore.instance.collection("orders").snapshots();
  final Stream<QuerySnapshot> readReports = FirebaseFirestore.instance.collection("orders").where('reported', isEqualTo: true).snapshots();

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1440,
        height: 832,
        color: Colors.white,
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


            //here is a quick word
            Positioned(
              left: 100,
              top: 100,
              child: SizedBox(
                child: Text(
                  "here is a quick overview about the overall system progress: ",
                  style: TextStyle(
                    color: Color(0xaa4b6c76),
                    fontSize: 27,
                  ),
                ),
              ),
            ),

            
            //yellow topRight
            Positioned.fill(
              bottom: 37,
              left: 0,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  child: Image(image: AssetImage('assets/images/yellow1.png')),
                ),
              ),
            ),

            //pink topRight////
            Positioned.fill(
              bottom: 18,
              left: 40,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  child: Image(image: AssetImage('assets/images/pink1.png')),
                ),
              ),
            ),

////boxes
///1
Positioned(
  top:160,
  left:280,
  child:   Container(
  
      width: 200,
      height: 200,
  
      child: Row(
  
          mainAxisSize: MainAxisSize.min,
  
          mainAxisAlignment: MainAxisAlignment.center,
  
          crossAxisAlignment: CrossAxisAlignment.center,
  
          children:[
  
              Container(
  
                  width: 200,
  
                  height: 200,
  
                  decoration: BoxDecoration(
  
                      borderRadius: BorderRadius.circular(10),
  
                      color: Color(0x66f9bfb4),
  
                  ),
  
                  padding: const EdgeInsets.only( right: 6, top: 6 ),
  
                  child: Column(
  
                    //  mainAxisSize: MainAxisSize.min,
  
                     // mainAxisAlignment: MainAxisAlignment.start,
  
                      crossAxisAlignment: CrossAxisAlignment.end,
  
                      children:[
                      TextButton( 
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => adminList()));
                      },
                      child:Container(
                              width: 40,
                              height: 46.52,
                              child: Image(
                                    image: AssetImage('assets/images/back2.png')),
  
                          ), ),
  
                         // SizedBox(height: 1.24),
  
                          SizedBox(
  
                              width: 104,
  
                              height: 60,
  
                              child:  StreamBuilder<QuerySnapshot>(
              stream: readRequest,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasData){
                  final users = snapshot.data!;
                  int count = users.docs.length;
                      return Text(
                                  "$count",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xff4b6d76),
                                      fontSize: 60,
                                  ),
  
                              );
                    }
                  return Center(child: CircularProgressIndicator()); 
                },
 ),
  
  
                          ),
  
                          SizedBox(height: 15),
  
                          SizedBox(
  
                              width: 182,
  
                              height: 71,
  
                              child: Text(
  
                                  "registration requests",
  
                                  style: TextStyle(
  
                                      color: Color(0xff4b6d76),
  
                                      fontSize: 27,
  
                                  ),
  
                              ),
  
                          ),
  
                      ],
  
                  ),
  
              ),
  
          ],
  
      ),
  
  ),
),
///2
Positioned(
  top:160,
  left:550,
  child:   Container(
  
      width: 200,
  
      height: 200,
  
      child: Row(
  
          mainAxisSize: MainAxisSize.min,
  
          mainAxisAlignment: MainAxisAlignment.center,
  
          crossAxisAlignment: CrossAxisAlignment.center,
  
          children:[
  
              Container(
  
                  width: 200,
  
                  height: 200,
  
                  decoration: BoxDecoration(
  
                      borderRadius: BorderRadius.circular(10),
  
                      color: Color(0x77ffdf75),
  
                  ),
  
                  padding: const EdgeInsets.only(right: 8, top: 6 ),
  
                  child: Column(
  
                      mainAxisSize: MainAxisSize.min,
  
                      mainAxisAlignment: MainAxisAlignment.start,
  
                      crossAxisAlignment: CrossAxisAlignment.end,
  
                      children:[
                      TextButton( 
                      onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => driverAcc()));
                      },child:
                          Container(
  
                              width: 40,
  
                              height: 46.52,
  
                              child:  Image(
                                    image: AssetImage('assets/images/back2.png')
                                    ),
                                    
  
                          ),
                      ),
  
                         // SizedBox(height: 1.24),
  
                          SizedBox(
  
                              width: 104,
  
                              height: 75,
  
                              child:  StreamBuilder<QuerySnapshot>(
              stream: readDrivers,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasData){
                  final users = snapshot.data!;
                  int count = users.docs.length;
                      return Text(
                                  "$count",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xff4b6d76),
                                      fontSize: 64,
                                  ),
  
                              );
                    }
                  return Center(child: CircularProgressIndicator()); 
                },
 ),
  
                          ),
  
                          SizedBox(height: 1.24),
  
                          SizedBox(
  
                              width: 182,
  
                              height: 71,
  
                              child: Text(
  
                                  "Drivers",
  
                                  style: TextStyle(
  
                                      color: Color(0xff4b6d76),
  
                                      fontSize: 27,
  
                                  ),
  
                              ),
  
                          ),
  
                      ],
  
                  ),
  
              ),
  
          ],
  
      ),
  
  ),
),

///3
Positioned(
  top:160,
  left:830,
  child:   Container(
  
      width: 200,
  
      height: 200,
  
      child: Row(
  
          mainAxisSize: MainAxisSize.min,
  
          mainAxisAlignment: MainAxisAlignment.center,
  
          crossAxisAlignment: CrossAxisAlignment.center,
  
          children:[
  
              Container(
  
                  width: 200,
  
                  height: 200,
  
                  decoration: BoxDecoration(
  
                      borderRadius: BorderRadius.circular(10),
  
                      color: Color(0x72b9bc83),
  
                  ),
  
                  padding: const EdgeInsets.only( right: 8, top: 6 ),
  
                  child: Column(
  
                      mainAxisSize: MainAxisSize.min,
  
                      mainAxisAlignment: MainAxisAlignment.start,
  
                      crossAxisAlignment: CrossAxisAlignment.end,
  
                      children:[
                      TextButton( 
                      onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => affiliateAcc()));
                      },child:
                          Container(
  
                              width: 40,
  
                              height: 46.52,
  
                              child:  Image(
                                    image: AssetImage('assets/images/back2.png')),
  
                          ),
                      ),
  
                         // SizedBox(height: 1.24),
  
                          SizedBox(
  
                              width: 104,
  
                              height: 75,
  
                              child: StreamBuilder<QuerySnapshot>(
              stream: readAffiliate,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasData){
                  final users = snapshot.data!;
                  int count = users.docs.length;
                      return Text(
                                  "$count",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xff4b6d76),
                                      fontSize: 64,
                                  ),
  
                              );
                    }
                  return Center(child: CircularProgressIndicator()); 
                },
 ),
  
                          ),
  
                          //SizedBox(height: 1.24),
  
                          SizedBox(
  
                              width: 182,
  
                              height: 71,
  
                              child: Text(
  
                                  "University Affiliates",
  
                                  style: TextStyle(
  
                                      color: Color(0xff4b6d76),
  
                                      fontSize: 27,
  
                                  ),
  
                              ),
  
                          ),
  
                      ],
  
                  ),
  
              ),
  
          ],
  
      ),
  
  ),
),

///4
Positioned(
  top:380,
  left:280,
  child:   Container(
  
      width: 200,
  
      height: 200,
  
      child: Row(
  
          mainAxisSize: MainAxisSize.min,
  
          mainAxisAlignment: MainAxisAlignment.center,
  
          crossAxisAlignment: CrossAxisAlignment.center,
  
          children:[
  
              Container(
  
                  width: 200,
  
                  height: 200,
  
                  decoration: BoxDecoration(
  
                      borderRadius: BorderRadius.circular(10),
  
                      color: Color(0x72b9bc83),
  
                  ),
  
                  padding: const EdgeInsets.only( right: 8, top: 6 ),
  
                  child: Column(
  
                      mainAxisSize: MainAxisSize.min,
  
                      mainAxisAlignment: MainAxisAlignment.start,
  
                      crossAxisAlignment: CrossAxisAlignment.end,
  
                      children:[
                      TextButton( 
                      onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => orders()));
                      },
  
                          child: Container(
  
                              width: 40,
  
                              height: 46.52,
  
                              child:  Image(
                                    image: AssetImage('assets/images/back2.png')),
  
                          ),
                      ),
  
                          //SizedBox(height: 1.24),
  
                          SizedBox(
  
                              width: 104,
  
                              height: 75,
  
                              child: StreamBuilder<QuerySnapshot>(
              stream: readOrders,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasData){
                  final users = snapshot.data!;
                  int count = users.docs.length;
                      return Text(
                                  "$count",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xff4b6d76),
                                      fontSize: 64,
                                  ),
  
                              );
                    }
                  return Center(child: CircularProgressIndicator()); 
                },
 ),
  
  
                          ),
  
                        //  SizedBox(height: 1.24),
  
                          SizedBox(
  
                              width: 182,
  
                              height: 71,
  
                              child: Text(
  
                                  "Orders",
  
                                  style: TextStyle(
  
                                      color: Color(0xff4b6d76),
  
                                      fontSize: 27,
  
                                  ),
  
                              ),
  
                          ),
  
                      ],
  
                  ),
  
              ),
  
          ],
  
      ),
  
  ),
),

///5
Positioned(
  top:380,
  left:550,
  child:   Container(
  
      width: 200,
  
      height: 200,
  
      child: Row(
  
          mainAxisSize: MainAxisSize.min,
  
          mainAxisAlignment: MainAxisAlignment.center,
  
          crossAxisAlignment: CrossAxisAlignment.center,
  
          children:[
  
              Container(
  
                  width: 200,
  
                  height: 200,
  
                  decoration: BoxDecoration(
  
                      borderRadius: BorderRadius.circular(10),
  
                      color: Color(0x444b6c76),
  
                  ),
  
                  padding: const EdgeInsets.only( right: 8, top: 6 ),
  
                  child: Column(
  
                      mainAxisSize: MainAxisSize.min,
  
                      mainAxisAlignment: MainAxisAlignment.start,
  
                      crossAxisAlignment: CrossAxisAlignment.end,
  
                      children:[
                      TextButton( 
                      onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => reports()));
                      },
  
                          child: Container(
  
                              width: 40,
  
                              height: 46.52,
  
                              child:  Image(
                                    image: AssetImage('assets/images/back2.png')),
  
                          ),
                      ),
  
                          //SizedBox(height: 1.24),
  
                          SizedBox(
  
                              width: 104,
  
                              height: 75,
  
                              child: StreamBuilder<QuerySnapshot>(
              stream: readReports,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasData){
                  final users = snapshot.data!;
                  int count = users.docs.length;
                      return Text(
                                  "$count",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xff4b6d76),
                                      fontSize: 64,
                                  ),
  
                              );
                    }
                  return Center(child: CircularProgressIndicator()); 
                },
 ),
  
  
                          ),
  
                        //  SizedBox(height: 1.24),
  
                          SizedBox(
  
                              width: 182,
  
                              height: 71,
  
                              child: Text(
  
                                  "Reports",
  
                                  style: TextStyle(
  
                                      color: Color(0xff4b6d76),
  
                                      fontSize: 27,
  
                                  ),
  
                              ),
  
                          ),
  
                      ],
  
                  ),
  
              ),
  
          ],
  
      ),
  
  ),
),

//my profile
// Positioned(
//   top:250,
//   right:80,

//  child: Container(
//     width: 200,
//     height: 90,
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Color(0x77ffdf75),
//     ),
// ),
// ),
// Positioned(
//                 top: 250,
//                 right: 100,
//                 child: SizedBox(
//                   child: Text(
//                     "My profile",
//                     style: TextStyle(
//                       color: Color(0xff204854),
//                       fontSize: 25,
//                     ),
//                   ),
//                 ),
//               ),



//sign out new
/*Positioned(
  top:490,
  right:1120,

 child: Container(
    width: 180,
    height: 80,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0x66f9bfb4),
    ),
),
),*/
 Positioned(
 top: 380,
left: 820,
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
                      child:Container(
    width: 200,
    height: 90,
    padding: const EdgeInsets.only(left: 25, top: 25),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0x66f9bfb4),
    ),
    child: Stack(
                    children:[
                        SizedBox(
                            // width: 100,
                            // height: 44,
                            child: Text(
                                "sign out",
                                style: TextStyle(
                                    color: Color(0xff4b6d76),
                                    fontSize: 30,
                                ),
                            ),
                        ),

                      Padding(
                        padding: const EdgeInsets.only(left: 120),
                        child: Container(
                          //padding: const EdgeInsets.only(left: 20),
                        width: 35,
                        height: 35,
                        child: Image(
                        image: AssetImage('assets/images/logout1.png'),),
                        ),
                      ),

                    ]
                  ),),
                    ),
 ),


//sign out
/*Positioned(
  top:120,
  right:80,
child: Container(
    width: 200,
    height: 90,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0x66f9bfb4),
    ),
),
SizedBox(
    width: 163,
    height: 41,
    child: Text(
        "Sign out",
        style: TextStyle(
            color: Color(0xff4b6d76),
            fontSize: 30,
        ),
    ),
),
Container(
    width: 40,
    height: 40,
    child: FlutterLogo(size: 40),
),
),*/


///final
             ],
        ),
      ),
    );
      
      
      

  }}

