import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:namhal/api/notifyUser.dart';

class Token{

static Future GetToken(String? email,String? token ) async{
  await FirebaseFirestore.instance.collection('User').doc(email).get().then((
      value) {
    token = value.get('token');
  });
  if(token?.isEmpty??true){
    token = await FirebaseMessaging.instance.getToken();
    NotifyUser.requestPermission();
    await FirebaseFirestore.instance.collection('User').doc(email).update({
      'token':'$token'
    });
  }
}
}
