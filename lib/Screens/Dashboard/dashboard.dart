import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:namhal/Components/side_menu.dart';

import 'package:namhal/Screens/Add_Complain_Screen/add_Complain.dart';
import 'package:namhal/Screens/Advance_Serach/advanceSerach.dart';
import 'package:namhal/Screens/Report/report.dart';

import 'package:namhal/model/complaint.dart';

import '/Components/ComplaintsModel.dart';
import '/Components/Complaints_info_card.dart';
import '/Constants/constants.dart';
import '/Responsive/responsive.dart';

import 'package:flutter/material.dart';

import 'Components/ComplaintsSummary.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  int pending=0;
  int Inprogress=0;
  int Completed=0;
  int Rejected=0;
  int total=0;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    loadData();


  }
  void loadData(){
    FirebaseFirestore.instance.collection("Complains").where('username',isEqualTo: user!.email!.substring(0, user!.email!.indexOf('@'))).get().then((value) {
      if(mounted){
        setState(() {
          total=value.docs.length;
          for(int i=0;i<value.docs.length;i++){
            if(value.docs[i].data()['status']=="Pending"){
              pending++;
            }
            else if(value.docs[i].data()['status']=="InProgress"){
              Inprogress++;
            }
            else if(value.docs[i].data()['status']=="Completed"){
              Completed++;
            }
            else if(value.docs[i].data()['status']=="Rejected"){
              Rejected++;
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: SideMenu(),

      backgroundColor: Color(0xFFE5E5E5),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text("NAMHAL"),
      ),
      body: Center(
        child: Scrollbar(
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
                          ComplaintDetails(total: total,pending: pending,completed: Completed,rejected: Rejected,inprogress: Inprogress,),
                          SizedBox(height: kDefaultPadding),
                          const Text(
                            "Recent Complaints",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: kDefaultPadding),
                          Card(
                            color: Colors.blueGrey[50],
                            elevation: 5,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              child: StreamBuilder<QuerySnapshot?>(
                                stream: FirebaseFirestore.instance
                                    .collection('Complains')
                                    .orderBy("startTime", descending: true)
                                    .limitToLast(10)
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
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Report(complains: complain,id: snapshot.data!.docs[index].id,)));

                                        },
                                        child: Card(

                                          elevation: 5,
                                          color: kSecondaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0))),
                                          child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  buildRichText("Title: ",
                                                      complain.title.toString()),
                                                  Table(
                                                    children: [
                                                      TableRow(children: [
                                                        buildRichText(
                                                            "Name: ",
                                                            complain.username
                                                                .toString()),
                                                        buildRichText(
                                                            "Address: ",
                                                            complain.address
                                                                .toString()),
                                                      ]),
                                                      TableRow(children: [
                                                        buildRichText(
                                                            "Priority: ",
                                                            complain.priority
                                                                .toString()),
                                                        buildRichText(
                                                            "Status: ",
                                                            complain.status
                                                                .toString()),
                                                      ]),
                                                      TableRow(children: [
                                                        buildRichText(
                                                            "Worker: ",
                                                            complain.worker
                                                                .toString()),
                                                        buildRichText(
                                                            "Service: ",
                                                            complain.worker
                                                                .toString())
                                                      ]),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                      );
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
                                        builder: (context) => AdvanceSearch()));
                              },
                              child: Text("All Complaints")),
                          if (Responsive.isMobile(context))
                            SizedBox(height: kDefaultPadding),
                          if (Responsive.isMobile(context)) ComplaintsSummary(total: total,pending: pending,completed: Completed,rejected: Rejected,inprogress: Inprogress,),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(width: kDefaultPadding),
                    // On Mobile means if the screen is less than 850 we dont want to show it
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: ComplaintsSummary(total: total,pending: pending,completed: Completed,rejected: Rejected,inprogress: Inprogress,),
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

  RichText buildRichText(String title, String subtitle) {
    return RichText(
      text: TextSpan(
        text: title,
        children: [
          TextSpan(
            text: subtitle,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white54,
            ),
          ),
        ],
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

//complaints details
class ComplaintDetails extends StatelessWidget {
  final int total;
  final int pending;
  final int completed;
  final int rejected;
  final int inprogress;
  const ComplaintDetails({
    Key? key,
    required this.total,
    required this.pending,
    required this.completed,
    required this.rejected,
    required this.inprogress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Complaints Detail",
              style: TextStyle(
                color: kSecondaryColor,
              ),
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                  vertical:
                      kDefaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddComplain()));
              },
              icon: Icon(Icons.add),
              label: Text("Add Complain"),
            ),
          ],
        ),
        SizedBox(height: kDefaultPadding),
        Responsive(
          mobile: ComplaintsCardGridView(
            total: total,pending: pending,completed: completed,rejected: rejected,inprogress: inprogress,
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
          ),
          tablet: ComplaintsCardGridView(total: total,pending: pending,completed: completed,rejected: rejected,inprogress: inprogress,),
          desktop: ComplaintsCardGridView(
            total: total,pending: pending,completed: completed,rejected: rejected,inprogress: inprogress,
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}
class ComplaintsCardGridView extends StatelessWidget {
  const ComplaintsCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.total,
    required this.pending,
    required this.completed,
    required this.rejected,
    required this.inprogress,
  }) : super(key: key);
  final int total;
  final int pending;
  final int completed;
  final int rejected;
  final int inprogress;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: ComplaintsDetails.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: kDefaultPadding,
        mainAxisSpacing: kDefaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        ComplaintsStorageInfo info = ComplaintsDetails[index];
      if(info.title=="Pending"  )
        info.numOfFiles=pending;
      else if(info.title=="Inprogress" )
        info.numOfFiles=inprogress;
      else if(info.title=="Completed" )
        info.numOfFiles=completed;
      else if(info.title=="Rejected" )
        info.numOfFiles=rejected;
        return ComplaintsInfoCard(info: ComplaintsDetails[index]);
      },
    );
  }
}
// class ComplaintsCardGridView extends StatefulWidget {
//   const ComplaintsCardGridView({
//     Key? key,
//     this.crossAxisCount = 4,
//     this.childAspectRatio = 1,
//   }) : super(key: key);
//
//   final int crossAxisCount;
//   final double childAspectRatio;
//
//   @override
//   State<ComplaintsCardGridView> createState() => _ComplaintsCardGridViewState();
// }
//
// class _ComplaintsCardGridViewState extends State<ComplaintsCardGridView> {
//   int pending=0;
//   int Inprogress=0;
//   int Completed=0;
//   int Rejected=0;
//   int total=0;
//   User? user;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     user=FirebaseAuth.instance.currentUser;
//     FirebaseFirestore.instance.collection("Complains").where('username',isEqualTo: user!.email).get().then((value) {
//       if(this.mounted){
//       setState(() {
//         total=value.docs.length;
//         for(int i=0;i<value.docs.length;i++){
//           if(value.docs[i].data()['status']=="Pending"){
//             pending++;
//           }
//           if(value.docs[i].data()['status']=="Inprogress"){
//             Inprogress++;
//           }
//           if(value.docs[i].data()['status']=="Completed"){
//             Completed++;
//           }
//           if(value.docs[i].data()['status']=="Rejected"){
//             Rejected++;
//           }
//         }
//       });}
//
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: ComplaintsDetails.length,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: widget.crossAxisCount,
//         crossAxisSpacing: kDefaultPadding,
//         mainAxisSpacing: kDefaultPadding,
//         childAspectRatio: widget.childAspectRatio,
//       ),
//       itemBuilder: (context, index) {
//         ComplaintsStorageInfo info = ComplaintsDetails[index];
//       if(info.title=="Pending"  )
//         info.numOfFiles=pending;
//       else if(info.title=="Inprogress" )
//         info.numOfFiles=Inprogress;
//       else if(info.title=="Completed" )
//         info.numOfFiles=Completed;
//       else if(info.title=="Rejected" )
//         info.numOfFiles=Rejected;
//
//         return ComplaintsInfoCard(info: ComplaintsDetails[index],);
//       },
//     );
//   }
// }
