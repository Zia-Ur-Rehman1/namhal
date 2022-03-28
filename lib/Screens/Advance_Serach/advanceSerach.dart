import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namhal/Constants/constants.dart';
import 'package:namhal/Screens/Report/report.dart';
import '/model/complaint.dart';
import 'Components/searchData.dart';
import 'package:flutter/material.dart';

class AdvanceSearch extends StatefulWidget {
  @override
  _AdvanceSearchState createState() => _AdvanceSearchState();
}

class _AdvanceSearchState extends State<AdvanceSearch> {
  List<Complains> complains = [];

  Stream<QuerySnapshot> rightnow=FirebaseFirestore.instance.collection('Complains').orderBy("timestamp", descending: true).snapshots();
  String? sorting;
  Map<String, dynamic>? data;
  final List<String> sortby = [ "Time", "Priority"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
                    await showSearch(context: context, delegate: DataSearch());
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
                height: MediaQuery.of(context).size.height / 8,
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
                                  rightnow=FirebaseFirestore.instance.collection('Complains').orderBy("startTime", descending: true).snapshots();
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
                                  rightnow=FirebaseFirestore.instance.collection('Complains').where("status",isEqualTo: "Pending").snapshots();

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
                                  rightnow=FirebaseFirestore.instance.collection('Complains').where("status",isEqualTo: "InProgress").snapshots();

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
                                  rightnow=FirebaseFirestore.instance.collection('Complains').where("status",isEqualTo: "Completed").snapshots();

                                });
                              },
                              child: Text("Completed"),
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
                height: MediaQuery.of(context).size.height,
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
                            snapshot.data!.docs[index].data() as Map<String, dynamic>);
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
                                          buildRichText("Name: ",
                                              complain.username.toString()),
                                          buildRichText("Address: ",
                                              complain.address.toString()),
                                        ]),
                                        TableRow(children: [
                                          buildRichText("Priority: ",
                                              complain.priority.toString()),
                                          buildRichText("Status: ",
                                              complain.status.toString()),
                                        ]),
                                        TableRow(children: [
                                          buildRichText("Worker: ",
                                              complain.worker.toString()),
                                          buildRichText("Service: ", complain.service.toString())
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
            ],
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
