import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:namhal/Components/ComplaintTile.dart';
import 'package:namhal/Components/side_menu.dart';
import 'package:namhal/Screens/Profile/profile.dart';
import 'package:namhal/model/UserObject.dart';

import 'package:namhal/Screens/Advance_Serach/advanceSerach.dart';
import 'package:namhal/Screens/Dashboard/Components/ComplaintDetails.dart';
import 'package:namhal/api/TokenHandling.dart';

import 'package:namhal/model/complaint.dart';
import 'package:provider/provider.dart';
import '/Constants/constants.dart';
import '/Responsive/responsive.dart';
import '/providers/providers.dart';
import 'package:flutter/material.dart';

import 'Components/ComplaintsSummary.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? token;
  int Pending = 0;
  int InProgress = 0;
  int Completed = 0;
  int Rejected = 0;
  int total = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getUser();
    });
  }
  Future<void> manageToken() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      Token.UpdateToken(user?.email);
    });
    token=await Token.CheckToken(user?.email);
    if(token=="false"){
      Token.UpdateToken(user?.email);
      Provider.of<Info>(context, listen: false).user.token=token;
    }

  }

 Future<void> getUser() async{
   await firestore.collection("User").doc(user!.email).get().then((value)  {
     if(mounted) {
       setState(() {
         UserObject userObject = UserObject.fromJson(value.data());
         Provider.of<Info>(context, listen: false).setUser(userObject);
       });
     StreamListener();
     manageToken();
     }
   });


  }
  void StreamListener()   {
    firestore.collection("Complains")
          .where('username',
            isEqualTo: context.read<Info>().user.name)
          .snapshots()
          .listen((event) {
            Pending = event.docs
                .where((element) => element.data()['status'] == 'Pending')
                .length;
            InProgress = event.docs
                .where((element) => element.data()['status'] == 'InProgress')
                .length;
            Completed = event.docs
                .where((element) => element.data()['status'] == 'Completed')
                .length;
            Rejected = event.docs
                .where((element) => element.data()['status'] == 'Rejected')
                .length;
            total = Pending + InProgress + Completed + Rejected;
            if(mounted){

              setState(() {
            Provider.of<Status>(context, listen: false).setTotal(total);
            Provider.of<Status>(context, listen: false).setPending(Pending);
            Provider.of<Status>(context, listen: false).setInProgress(InProgress);
            Provider.of<Status>(context, listen: false).setCompleted(Completed);
            Provider.of<Status>(context, listen: false).setRejected(Rejected);

        });
      }
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.blue,

        centerTitle: true,
        title: const Text("NAMHAL"),
      actions: [
      IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
      ),
      ],
      ),

      body: Center(

        child: Scrollbar(
          //hover thickness
          interactive: true,
          radius: Radius.circular(10),
          showTrackOnHover: true,
          trackVisibility: true,
          child: SingleChildScrollView(
            //show scrolls

            padding: EdgeInsets.all(kDefaultPadding),
            child: Column(
              children: [
                SizedBox(height: kDefaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ComplaintDetails(),
                          SizedBox(height: kDefaultPadding),
                          const Text(
                            "Complaints",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: kDefaultPadding),
                          Card(
                            elevation: 0,
                            color: Colors.white.withOpacity(0.9),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              child: StreamBuilder<QuerySnapshot?>(
                                stream: firestore
                                    .collection('Complains')
                                    .where('username',
                                        isEqualTo: user?.email!.substring(
                                            0, user?.email!.indexOf('@')))
                                    // .collection('Complains').where('manager',isEqualTo: user?.email)
                                    .orderBy("timestamp", descending: true)
                                    .limit(10)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    Text("Error");
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.data?.docs.length == 0)
                                    return Center(
                                      child: Text("No Complaints"),
                                    );

                                  return ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      final Complains complain =
                                          Complains.fromMap(
                                              snapshot.data!.docs[index].data()
                                                  as Map<String, dynamic>);
                                      return ComplaintTile(
                                        complain: complain,
                                        id: snapshot.data!.docs[index].id,
                                      );
                                      // return ComplainTTile(complain, snapshot.data!.docs[index].id,);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdvanceSearch(passStream: firestore.collection("Complains").where('username',
                                            isEqualTo: context.read<Info>().user.name).snapshots(),)));
                              },
                              child: Text("View Complaints")),
                          if (Responsive.isMobile(context))
                            SizedBox(height: kDefaultPadding),
                          if (Responsive.isMobile(context)) ComplaintsSummary(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(width: kDefaultPadding),
                    // On Mobile means if the screen is less than 850 we dont want to show it
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: ComplaintsSummary(),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}

//complaints details
