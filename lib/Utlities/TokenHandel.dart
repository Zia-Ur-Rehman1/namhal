import 'package:cloud_firestore/cloud_firestore.dart';

class TokenHandel {
  static Future<String> getUserToken(String email) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("UserPermission")
        .doc(email)
        .get();
    return snap['token'];
  }

  static Future<void> saveTokenToDatabase(String token, String email) async {
    await FirebaseFirestore.instance
        .collection('UserPermission')
        .doc(email)
        .set({
      'token': token,
      // FieldValue.arrayUnion([token])
    });
  }
}
