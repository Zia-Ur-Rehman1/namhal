import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:namhal/Components/ComplaintTile.dart';
import '/model/complaint.dart';
import 'Components/searchData.dart';
import 'package:flutter/material.dart';

class AdvanceSearch extends StatefulWidget {
  @override
  _AdvanceSearchState createState() => _AdvanceSearchState();
}

class _AdvanceSearchState extends State<AdvanceSearch> {
  List<Complains> complains = [];

  late Stream<QuerySnapshot> rightnow;
  String? sorting;
  Map<String, dynamic>? data;
  final List<String> sortby = [ "Time", "Priority"];
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String? username;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = auth.currentUser;
    username= user?.email.toString().substring(0, user?.email!.indexOf('@'));


    // rightnow=FirebaseFirestore.instance.collection('Complains').where("manager",isEqualTo:user?.email).orderBy("timestamp", descending: true).snapshots();
    rightnow = FirebaseFirestore.instance.collection('Complains').where(
        "username", isEqualTo: username)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: (AppBar(
        title: Text("Advance Search"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                final result =
                await showSearch(context: context,
                    delegate: DataSearch(email: username));
                print(result);
              },
              icon: Icon(Icons.search))
        ],
      )),
      body: SafeArea(

        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 8,
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // rightnow=FirebaseFirestore.instance.collection('Complains').where("manager",isEqualTo:widget.email).orderBy("timestamp", descending: true).snapshots();
                                  rightnow =
                                      FirebaseFirestore.instance.collection(
                                          'Complains')
                                          .where("username",
                                          isEqualTo:username)
                                          .orderBy(
                                          "timestamp", descending: true)
                                          .snapshots();
                                });
                              },
                              child: Text("All"),
                            ),
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.all(10.0),
                          ),
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // rightnow=FirebaseFirestore.instance.collection('Complains').where("manager",isEqualTo:widget.email).where("status",isEqualTo: "Pending").snapshots();
                                  rightnow =
                                      FirebaseFirestore.instance.collection(
                                          'Complains')
                                          .where("username",
                                          isEqualTo: username)
                                          .where("status", isEqualTo: "Pending")
                                          .snapshots();
                                });
                              },
                              child: Text("Pending"),
                            ),
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.all(10.0),
                          ),
                          // Container(
                          //   margin: EdgeInsets.all(10.0),
                          //   height: 40,
                          //   decoration: BoxDecoration(
                          //       color: Colors.blue,
                          //       shape: BoxShape.rectangle,
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(5.0))),
                          //   padding: EdgeInsets.symmetric(horizontal: 5.0),
                          //   child: DropdownButton(
                          //     underline: SizedBox(),
                          //     dropdownColor: Colors.blue,
                          //     hint: Text(
                          //       "Sort By",
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //     value: sorting,
                          //     icon: Icon(
                          //       Icons.arrow_drop_down_circle_outlined,
                          //       color: Colors.white,
                          //     ),
                          //     onChanged: (String? newValue) {
                          //       setState(() {
                          //         sorting = newValue;
                          //       });
                          //     },
                          //     items: sortby.map((valueItem) {
                          //       return DropdownMenuItem(
                          //         value: valueItem,
                          //         child: Text(
                          //           valueItem,
                          //           style: TextStyle(color: Colors.white),
                          //         ),
                          //       );
                          //     }).toList(),
                          //   ),
                          // ),
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // rightnow=FirebaseFirestore.instance.collection('Complains').where("manager",isEqualTo:widget.email).where("status",isEqualTo: "InProgress").snapshots();
                                  rightnow =
                                      FirebaseFirestore.instance.collection(
                                          'Complains')
                                          .where("username",
                                          isEqualTo: username)
                                          .where(
                                          "status", isEqualTo: "InProgress")
                                          .snapshots();
                                });
                              },
                              child: Text("Inprogress"),
                            ),
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.all(10.0),
                          ),
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // rightnow=FirebaseFirestore.instance.collection('Complains').where("manager",isEqualTo:widget.email).where("status",isEqualTo: "Completed").snapshots();
                                  rightnow =
                                      FirebaseFirestore.instance.collection(
                                          'Complains')
                                          .where("username",
                                          isEqualTo: username)
                                          .where(
                                          "status", isEqualTo: "Completed")
                                          .snapshots();
                                });
                              },
                              child: Text("Completed"),
                            ),
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.all(10.0),
                          ),
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // rightnow=FirebaseFirestore.instance.collection('Complains').where("manager",isEqualTo:widget.email).where("status",isEqualTo: "Completed").snapshots();
                                  rightnow =
                                      FirebaseFirestore.instance.collection(
                                          'Complains')
                                          .where("username",
                                          isEqualTo: username)
                                          .where(
                                          "status", isEqualTo: "Rejected")
                                          .snapshots();
                                });
                              },
                              child: Text("Rejected"),
                            ),
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.all(10.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: StreamBuilder<QuerySnapshot>(
                  stream: rightnow,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data?.docs.length == 0)
                      return Center(
                        child: Text("No Complaints to View"),
                      );
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final Complains complain = Complains.fromMap(
                            snapshot.data!.docs[index].data() as Map<
                                String,
                                dynamic>);
                        return ComplaintTile(complain: complain,id: snapshot.data!.docs[index].id ,);

                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

