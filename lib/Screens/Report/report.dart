import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:namhal/api/pdf_api.dart';
import 'package:namhal/model/complaint.dart';
import 'package:namhal/model/log.dart';
import '../../Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
class Report extends StatefulWidget {
  final Complains complains;
  final String id;

  const Report({Key? key, required this.complains, required this.id}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool isLoading = false;
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  color: kSecondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          buildRichText(
                              "Title: ", widget.complains.title.toString()),
                          Table(
                            children: [
                              TableRow(children: [
                                buildRichText("Name: ",
                                    widget.complains.username.toString()),
                                buildRichText("Address: ",
                                    widget.complains.address.toString()),
                              ]),
                              TableRow(children: [
                                buildRichText("Priority: ",
                                    widget.complains.priority.toString()),
                                buildRichText("Status: ",
                                    widget.complains.status.toString()),
                              ]),
                              TableRow(children: [
                                buildRichText("Worker: ",
                                    widget.complains.worker.toString()),
                                buildRichText("Service: ",
                                    widget.complains.worker.toString())
                              ]),
                              TableRow(children: [
                                buildRichText("Date: ",
                                    widget.complains.startDate.toString()),
                                buildRichText("Time: ",
                                    widget.complains.startTime.toString())
                              ]),
                            ],
                          ),
                        ],
                      )),
                ),

                SizedBox(
                  height: 10,
                ),
                Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    color: kSecondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        widget.complains.desc.toString(),
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                ExpansionTile(
                  title: Text(
                    "Image",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: CachedNetworkImage(
                          imageUrl: widget.complains.img != null
                              ? widget.complains.img.toString()
                              : "",
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                  ],
                ),
                //make it on click to open menu
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildLog(context),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    OutlinedButton.icon(onPressed: () async {
                      await openDialog("Log");
                      if(message.text.isNotEmpty){
                        AddLog(widget.id, message.text);
                        message.clear();
                      }
                    }, icon: Icon(Icons.add), label: Text("Add Log")),
                    OutlinedButton.icon(onPressed: () async{
                      await openDialog("Feedback");
                      if(message.text.isNotEmpty){
                        FirebaseFirestore.instance.collection("Complains").doc(widget.id).update({
                          "feedback": message.text,
                        }).then((value) => print("User Updated"))
                            .catchError((error) => print("Failed to update user: $error"));
                        setState(() {
                          widget.complains.feedback = message.text;
                        });
                        message.clear();
                      }
                    },icon: Icon(Icons.add), label: Text("Give Feedback")),

                ],),

                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    "Feedback",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  height: 150,
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          child: widget.complains.feedback != null
                              ? Text(
                                  widget.complains.feedback.toString(),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                )
                              : Text("No Feedback"),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.blue, width: 2)),
                  ),
                ),
                Center(child:isLoading? CircularProgressIndicator():SizedBox() ,),

              ],
            ),
          ),

        ),
      ),

      floatingActionButton: FloatingActionButton(

        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          final pdf= await PdfApi.generate(widget.complains, widget.id);
          setState(() {
            isLoading = false;
          });
          PdfApi.openFile(pdf);
        },
        child: Icon(Icons.download),
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

  Widget buildLog(BuildContext context) => ExpansionTile(

        title: Text(
          "Logs",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),

        //add the listviewbuilder here of logs
        children: [
          StreamBuilder<QuerySnapshot?>(
            stream: FirebaseFirestore.instance
                .collection('Logs').where("id", isEqualTo: widget.id)
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
                  child: Text("No Logs"),
                );
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final Logs log =
                  Logs.fromMap(
                      snapshot.data!.docs[index].data()
                      as Map<String, dynamic>) ;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                           log.user.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(log.date.toString()),
                          Text(log.time.toString()),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          log.message.toString(),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),


        ],
      );
  Future<String?> openDialog(String text)=> showDialog<String>(context: context, builder: (context)=>AlertDialog(
  title: Text("Add "+ text),
    content: TextField(
      controller: message,
      autofocus: true,
    decoration: InputDecoration(
      hintText: "Enter "+text,
    ),
  ),
    actions: [
      TextButton(
        onPressed: (){
          Navigator.of(context).pop(message.text);
        },
        child: Text("Submit"),
      ),
    ],
  ));
  @override
  void dispose() {
    super.dispose();
    message.dispose();
  }
}
AddLog(String id,String message){
  User? user = FirebaseAuth.instance.currentUser;
  DateTime now = DateTime.now();
  Logs log = Logs(
    id: id,
    user: user!.email!.substring(0, user.email!.indexOf('@')),
    message: message,
    date: DateFormat.yMMMd().format(now),
    time: DateFormat().add_jm().format(now),
  );
  FirebaseFirestore.instance.collection('Logs').add(log.toJson());



}


DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      alignment: Alignment.center,
      child: Text(
        item,
      ),
    );
