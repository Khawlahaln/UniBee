import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:unibeethree/screen/globals.dart';

final _firestore = FirebaseFirestore.instance;

Future addRating(double rating, String id) async {
  await _firestore
      .collection('orders')
      .where('id', isEqualTo: id)
      .get()
      .then((value) => value.docs.first.reference.update({'rating': rating}));
}

showRateDialog(BuildContext context, String id) {
  double rating = 0;
  // Widget yesButton = ElevatedButton(
  //     child: const Text(
  //       "Submit",
  //       style: TextStyle(
  //           color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
  //     ),
  //     onPressed: () async {
  //       await addRating(rating, id);
  //       Navigator.pop(context);
  //     },
  //     style: ElevatedButton.styleFrom(
  //       primary: Color(0xFF00CA71),
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(32.0))),
  //     ));
  // Widget cancelButton = TextButton(
  //   child: Icon(
  //     Icons.close,
  //     color: Colors.grey,
  //     size: 25,
  //   ),
  //   onPressed: () async {
  //     Navigator.pop(context);
  //   },
  // );
  AwesomeDialog(
    context: context,
    animType: AnimType.leftSlide,
    // headerAnimationLoop: true,
    // dialogType: DialogType.warning,

    customHeader: Image.asset('assets/star-10.png'),
    //showCloseIcon: true,
    //title: 'Report an issue',
    body: //Text("Report an issue"),
        Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Rate Your Ride!",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
          ),
          // Text(
          //   "we apologize for any inconvenience",
          //   textAlign: TextAlign.center,
          //   style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          // ),

          SizedBox(
            height: 5,
          ),
          Container(
              width: MediaQuery.of(context).size.width * .90,
              height: 30.0,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                  child: RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) =>
                        Image.asset('assets/star-9.png'),
                    // Icon(
                    //   Icons.star,
                    //   color: Colors.amber,
                    // ),
                    onRatingUpdate: (value) {
                      rating = value;
                    },
                  ),
                ),
              )),
        ],
      ),
    ),
    showCloseIcon: true,
    btnOkText: "Submit",
    btnOkOnPress: () async {
      await addRating(rating, id);
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        title: 'Your rating has been submitted successfully',
        btnOkOnPress: () {},
      ).show();
    },
  ).show();
  // showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(32.0))),
  //         child: Container(
  //           height: 160,
  //           child: Stack(
  //             children: [
  //               Padding(
  //                 padding: EdgeInsets.symmetric(vertical: 20, horizontal: 87),
  //                 child: Text(
  //                   "Rate your ride:",
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 20,
  //                   ),
  //                 ),
  //               ),
  //               Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//                   child: Container(
//                       width: MediaQuery.of(context).size.width * .90,
//                       height: 85.0,
//                       decoration: new BoxDecoration(
//                         shape: BoxShape.rectangle,
//                         color: const Color(0xFFFFFF),
//                         borderRadius:
//                             new BorderRadius.all(new Radius.circular(32.0)),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Center(
//                           child: RatingBar.builder(
//                             initialRating: rating,
//                             minRating: 1,
//                             direction: Axis.horizontal,
//                             allowHalfRating: true,
//                             itemCount: 5,
//                             itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//                             itemBuilder: (context, _) => Icon(
//                               Icons.star,
//                               color: Colors.amber,
//                             ),
//                             onRatingUpdate: (value) {
//                               rating = value;
//                             },
//                           ),
//                         ),
//                       )),
//                 ),
//                 Positioned(top: 105, left: 108, child: yesButton),
//                 Positioned(top: 0, right: 0, child: cancelButton)
//               ],
//             ),
//           ),
//         );
//       });
}
