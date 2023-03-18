import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

readNotification(String id, BuildContext context) async {
  await _firestore
      .collection('Notifications')
      .where('email', isEqualTo: id)
      .get()
      .then((value) => value.docs.first.reference.update({
            'read': true,
          }));
}

showNotificationDialog(BuildContext context, String id) {
  _firestore
      .collection('Notifications')
      .where('email', isEqualTo: id)
      .get()
      .then((value) {
    if (value.docs.isNotEmpty && value.docs.first['read'] == false) {
      print(value.docs);
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.warning,
        //showCloseIcon: true,
        title: value.docs.first['warning'] == "rating"
            ? 'Your rating is too poor. Please increase it otherwise we will delete your account!'
            : 'You have been reported. Be careful or your account will be deleted!',

        btnOkOnPress: () {
          readNotification(id, context);
        },
      ).show();
    }
  });

  readNotification(id, context);
  Widget yesButton = TextButton(
      child: const Text(
        "Okay",
        style: TextStyle(
            color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      onPressed: () async {
        readNotification(id, context);
        Navigator.pop(context);
      });
}
