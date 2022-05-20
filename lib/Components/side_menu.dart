import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:namhal/Constants/constants.dart';
import 'package:namhal/Screens/AddUser.dart';
import 'package:namhal/Screens/Address/AddAddress.dart';
import 'package:namhal/Screens/Advance_Serach/advanceSerach.dart';
import 'package:namhal/Screens/Manager_Screens/add_manager.dart';
import 'package:namhal/Screens/Profile/profile.dart';
import 'package:namhal/Screens/Service_Screens/add_service.dart';
import 'package:namhal/Screens/Worker_Screens/add_Worker.dart';
import 'package:namhal/Screens/login.dart';
import 'package:namhal/providers/providers.dart';
import 'package:provider/provider.dart';
class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kPrimaryColor.withOpacity(0.7),
      child: ListView(
        children: [
          DrawerHeader(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png",
                  width: 64, height: 65, cacheHeight: 64, cacheWidth: 64),
              const Text(
                "Namhal",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          )),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Complaints",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdvanceSearch(passStream: FirebaseFirestore.instance.collection("Complains").where('manager',
                          isEqualTo: context.read<Info>().user.email).snapshots(),)));
            },
          ),
          DrawerListTile(
            title: "Workers",
            svgSrc: "assets/icons/worker.svg",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddWorker(),));
            },
          ),
          DrawerListTile(
            title: "Manager",
            svgSrc: "assets/icons/manager.svg",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddManager(),));
            },
          ),
          DrawerListTile(
            title: "Services",
            svgSrc: "assets/icons/service.svg",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddServiceScreen(),));
            },
          ),
          DrawerListTile(
            title: "Add User",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddUser(),));
            },
          ),
          DrawerListTile(
            title: "Address",
            svgSrc: "assets/icons/home.svg",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAddress(),));
            },
          ),

          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          // DrawerListTile(
          //   title: "Settings",
          //   svgSrc: "assets/icons/menu_setting.svg",
          //   press: () {},
          // ),
          DrawerListTile(
            title: "Logout",
            svgSrc: "assets/icons/logout.svg",
            press: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },

          ),
        ],
      ),
    );
  }

}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white,
        height: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
