
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:namhal/Components/ComplaintTile.dart';
import '/model/complaint.dart';
import 'Components/searchData.dart';
import 'package:flutter/material.dart';
class AdvanceSearch extends StatefulWidget {
Stream<QuerySnapshot> passStream;

  AdvanceSearch({required this.passStream});
  @override
  _AdvanceSearchState createState() => _AdvanceSearchState();
}

class _AdvanceSearchState extends State<AdvanceSearch> {
  List<Complains> complains = [];

  late Stream<QuerySnapshot> rightnow;
  String? sorting;
  Map<String, dynamic>? data;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? user;
  String? username;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = auth.currentUser;
    username= user?.email.toString();
    // username= user?.email.toString().substring(0, user?.email!.indexOf('@'));


    rightnow = widget.passStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: (AppBar(
        title: const Text("Advance Search"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                final result =
                await showSearch(context: context,
                    delegate: DataSearch(email: username));
                print(result);
              },
              icon: const Icon(Icons.search))
        ],
      )),
      body: SafeArea(

        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
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
                                  rightnow =
                                      firestore.collection(
                                          'Complains')
                                          .where("manager",
                                          isEqualTo:username)
                                          .orderBy(
                                          "timestamp", descending: true)
                                          .snapshots();
                                });
                              },
                              child: const Text("All"),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.all(10.0),
                          ),
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  rightnow =
                                      firestore.collection(
                                          'Complains')
                                          .where("manager",
                                          isEqualTo: username)
                                          .where("status", isEqualTo: "Pending")
                                          .snapshots();
                                });
                              },
                              child: const Text("Pending"),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.all(10.0),
                          ),
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  rightnow =
                                      firestore.collection(
                                          'Complains')
                                          .where("manager",
                                          isEqualTo: username)
                                          .where(
                                          "status", isEqualTo: "InProgress")
                                          .snapshots();
                                });
                              },
                              child: const Text("Inprogress"),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.all(10.0),
                          ),
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  rightnow =
                                      firestore.collection(
                                          'Complains')
                                          .where("manager",
                                          isEqualTo: username)
                                          .where(
                                          "status", isEqualTo: "Completed")
                                          .snapshots();
                                });
                              },
                              child: const Text("Completed"),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.all(10.0),
                          ),
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  rightnow =
                                      firestore.collection(
                                          'Complains')
                                          .where("manager",
                                          isEqualTo: username)
                                          .where(
                                          "status", isEqualTo: "Rejected")
                                          .snapshots();
                                });
                              },
                              child: const Text("Rejected"),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.all(10.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data?.docs.isEmpty == true) {
                      return const Center(
                        child: Text("No Complaints to View"),
                      );
                    }
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

