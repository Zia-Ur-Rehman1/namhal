import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:namhal/Constants/constants.dart';
import 'package:namhal/Screens/Dashboard/dashboard.dart';
import 'package:namhal/Screens/Manager_Screens/add_manager.dart';
import 'package:namhal/Screens/Service_Screens/add_service.dart';
import 'package:namhal/Screens/Worker_Screens/add_Worker.dart';
import 'package:namhal/api/notifyUser.dart';
import 'package:provider/provider.dart';
import 'Screens/login.dart';
import 'Utlities/Utils.dart';
import 'providers/providers.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

}





Future<void> main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  NotifyUser().Notify();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //firebase User StreamProvider

        ChangeNotifierProvider<add>(create: (_) => add()),
        ChangeNotifierProvider<Info>(create: (_) => Info()),

        ChangeNotifierProvider<ComplaintObject>(create: (_) => ComplaintObject()),
        ChangeNotifierProvider<Status>(create: (_) => Status()),

      ],

      child: MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        debugShowCheckedModeBanner: false,

        theme: ThemeData.light().copyWith(
          appBarTheme: AppBarTheme(
            color: btnColor,

          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor:MaterialStateProperty.all(btnColor),
            ),
          ),
          primaryColor: kPrimaryColor,
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thickness: MaterialStateProperty.all(5),
          thumbColor: MaterialStateProperty.all(Colors.blueGrey),
        )
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Utils.showSnackBar("Something went wrong", Colors.red));
            } else if (snapshot.hasData) {
              return DashboardScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}

