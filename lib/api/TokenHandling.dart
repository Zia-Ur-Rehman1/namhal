import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Token{
static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
static late String token;
static Future<String> CheckToken(String? email) async {
  await _firestore.collection('User').doc(email).get().then((value) {
       token = value.data()?['token'];
     });
  if(token.isNotEmpty){
    return token;
  }
  else{
    return "false";
  }
}

static Future UpdateToken(String? email) async{
    await _firebaseMessaging.getToken().then((value) {
      _firestore.collection('User').doc(email).update({'token': value});});
  }
}


