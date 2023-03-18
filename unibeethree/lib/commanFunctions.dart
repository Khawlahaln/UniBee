import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

detailsRow(String id, String name, BuildContext context, String warning) {
  return Row(
    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(width: MediaQuery.of(context).size.width * .22, child: Text(id)),
      SizedBox(
          width: MediaQuery.of(context).size.width * .22, child: Text(name)),
      SizedBox(
        width: MediaQuery.of(context).size.width * .16,
        child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('drivers')
                .where('email', isEqualTo: id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: Icon(
                  Icons.star,
                  color: Colors.black,
                  size: 25,
                ));
              }

              final _data = snapshot.data?.docs;
              double total = 0, length = 0;
              for (var data in _data!) {
                length++;
                total += data.get("rating") as double;
              }

              return Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.black,
                    size: 25,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(_data.isEmpty
                      ? "N/A"
                      : (total / length).toStringAsFixed(1))
                ],
              );
            }),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * .29,
        child: MaterialButton(
          child: Text("Send Warning"),
          onPressed: () {
            addNotification(id, context,warning);
          },
          color: Colors.red,
        ),
      )
    ],
  );
}

Future addNotification(String id, BuildContext context , String warning) async {
  await _firestore
      .collection('Notifications')
      .where('email', isEqualTo: id)
      .get()
      .then((value) {
    if (value.docs.isNotEmpty)
      value.docs.first.reference.update({'read': false, 'isNotified': false});
    else
      _firestore
          .collection('Notifications')
          .add({'email': id, 'read': false, 'isNotified': false , 'warning': warning});
  });
}
