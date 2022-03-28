import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:namhal/Constants/constants.dart';
import 'package:namhal/Screens/Dashboard/dashboard.dart';
import 'package:provider/provider.dart';

import 'Screens/login.dart';
import 'Utlities/Utils.dart';
import '/Screens/Add_Complain_Screen/add_Complain.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print(message.data);
  print('Handling a background message ${message.messageId}');
}

Future<void> main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  runApp(const MyApp());

}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<add>(
      create: (context) => add(),

      child: MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        theme: ThemeData.light().copyWith(
          primaryColor: kPrimaryColor,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.hasError)
              return Center(child: Utils.showSnackBar("Something went wrong", Colors.red));
            else if (snapshot.hasData)
              return DashboardScreen();
            else
              return LoginScreen();
          },
        ),
      ),
    );
  }
}

