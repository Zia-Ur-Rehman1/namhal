import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:namhal/Constants/constants.dart';
import 'package:namhal/Screens/Dashboard/dashboard.dart';
import 'package:provider/provider.dart';

import 'Screens/login.dart';
import 'Utlities/Utils.dart';
import '/Screens/Add_Complain_Screen/add_Complain.dart';
Future<void> main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
              return Center(child: Text("Something went wrong!"));
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

