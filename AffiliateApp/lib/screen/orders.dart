import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class orders {
  final CollectionReference orderList =
      FirebaseFirestore.instance.collection('orders');

  Future getOrdersList(String e) async {
    List<QueryDocumentSnapshot<Object?>> itemsList = [];
    try {
      // Stream<QuerySnapshot> collectionStream =
      await orderList
          .where('email', isEqualTo: e)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element);
        });
      });
      return itemsList;
    } catch (err) {
      print(e.toString());
      return null;
    }
  }

  Future getSnapshota(String e) async {
    try {
      // Stream<QuerySnapshot> collectionStream =
      Stream<QuerySnapshot> readRequest =
          orderList.where('email', isEqualTo: e).snapshots();

      return readRequest;
    } catch (err) {
      print(e.toString());
      return null;
    }
  }
  // LatLng? start;
  // LatLng? end;
  // String? email;
  // String? status;

  // orders.fromMap(Map<String, dynamic> data) {
  //   email = data['email'];
  //   start = data['start'];
  //   end = data['end'];
  //   status = data['status'];
  // }
}
