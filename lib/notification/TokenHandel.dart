import 'package:cloud_firestore/cloud_firestore.dart';

class TokenHandel {
  static Future<String> getUserToken(String uid) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("UserPermission")
        .doc(uid)
        .get();
    return snap['token'];
  }

  static Future<void> saveTokenToDatabase(String token, String uid) async {
    // Assume user is logged in for this example

    await FirebaseFirestore.instance.collection('UserPermission').doc(uid).set({
      'token': token,
      // FieldValue.arrayUnion([token])
    });
  }
}
