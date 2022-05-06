import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:namhal/Utlities/Utils.dart';
import 'package:namhal/api/pdf_api.dart';
import 'package:namhal/model/log.dart';
import 'package:namhal/providers/providers.dart';
import 'package:provider/provider.dart';
import '../../Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'Components/sheet.dart';

class Report extends StatefulWidget {

  final String id;

  const Report({Key? key, required this.id})
      : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool isLoading = false;
  double rating = 0;
  TextEditingController message = TextEditingController();
  final FirebaseFirestore firestore= FirebaseFirestore.instance;
@override

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
                              "Title: ", context.read<ComplaintObject>().complaint.title.toString()),
                          Table(
                            children: [
                              TableRow(children: [
                                buildRichText("Name: ",
                                    context.read<ComplaintObject>().complaint.username.toString()),
                                buildRichText("Address: ",
                                    context.read<ComplaintObject>().complaint.address.toString()),
                              ]),
                              TableRow(children: [
                                buildRichText("Priority: ",
                                    context.read<ComplaintObject>().complaint.priority.toString()),
                                buildRichText("Status: ",
                                    context.read<ComplaintObject>().complaint.status.toString()),
                              ]),
                              TableRow(children: [
                                buildRichText("Worker: ",
                                    context.read<ComplaintObject>().complaint.worker.toString()),
                                buildRichText("Service: ",
                                    context.read<ComplaintObject>().complaint.service.toString())
                              ]),
                              TableRow(children: [
                                buildRichText("Date: ",
                                    context.read<ComplaintObject>().complaint.startDate.toString()),
                                buildRichText("Time: ",
                                    context.read<ComplaintObject>().complaint.startTime.toString())
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
                        context.read<ComplaintObject>().complaint.desc.toString(),
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
                          imageUrl: context.read<ComplaintObject>().complaint.img != "No Image Attached"
                              ? context.read<ComplaintObject>().complaint.img.toString()
                              : "No Image Attached",
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

                Center(
                  child: isLoading ? CircularProgressIndicator() : SizedBox(),
                ),
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
                          child: context.read<ComplaintObject>().complaint.feedback != null
                              ? Text(
                            context.read<ComplaintObject>().complaint.feedback.toString(),
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
                buildRating(true),
                //add rating here
               OutlinedButton.icon(onPressed: showRating, icon:Text("Rate It!") , label: Icon(Icons.thumb_up_alt_outlined))
              ],
            ),
          ),
        ),
      ),
      //add circular fab widget
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue,
        activeBackgroundColor: Colors.redAccent,
        children: [
          Log(),
          FeedBack(),
          Download(),
          Edit(),
        ],
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
            stream: firestore
                .collection('Logs')
                .where("id", isEqualTo: widget.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                Text("Error");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
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
                  final Logs log = Logs.fromMap(snapshot.data!.docs[index]
                      .data() as Map<String, dynamic>);
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
  Future<String?> openDialog(String text) => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Add " + text),
            content: TextField(
              controller: message,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter " + text,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
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

  Widget buildRating(bool gesture){
    return     Center(
      child: RatingBar.builder(
        initialRating: context.read<ComplaintObject>().complaint.rating?.toDouble() ?? 0,
        itemCount: 5,
        ignoreGestures: gesture,
        updateOnDrag: true,
        allowHalfRating: true,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return Icon(
                Icons.sentiment_very_dissatisfied,
                color: Colors.red,
              );
            case 1:
              return Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.orange,
              );
            case 2:
              return Icon(
                Icons.sentiment_neutral,
                color: Colors.amber,
              );
            case 3:
              return Icon(
                Icons.sentiment_satisfied,
                color: Colors.lightGreen,
              );
            case 4:
              return Icon(
                Icons.sentiment_very_satisfied,
                color: Colors.green,
              );
            default:
              return Icon(
                Icons.sentiment_neutral,
                color: Colors.green,
              );
          }
        },
        glow: true,
        onRatingUpdate: (newRating) {
          setState(() {
            context.read<ComplaintObject>().complaint.rating = newRating;
          });
        },
      ),
    );
  }

  void showRating() => showDialog(context: context, builder: (context) => AlertDialog(
    title: Text("Rate this Complain"),
    content:  Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Please rate the quality of the service"),
        SizedBox(height: 10,),
        buildRating(false),
      ],),
    actions: [
      TextButton(onPressed: (){
        firestore.collection('Complains').doc(widget.id).update({'rating': context.read<ComplaintObject>().complaint.rating});
        Navigator.of(context).pop();
      }, child: Text("Submit")),
    ],
  ));

  SpeedDialChild FeedBack() => SpeedDialChild(
      child: SvgPicture.asset("assets/icons/feedback.svg", color: Colors.white,height: 30,),
      label: "Feedback",
      backgroundColor: Colors.blue,
      onTap: () async{
        await openDialog("Feedback");
        if (message.text.isNotEmpty) {
          firestore
              .collection("Complains")
              .doc(widget.id)
              .update({
            "feedback": message.text,
          })
              .then((value) => Utils.showSnackBar("Updated",Colors.green))
              .catchError((error) =>
              Utils.showSnackBar("Failed to update : $error",Colors.red));
          setState(() {
            context.read<ComplaintObject>().complaint.feedback = message.text;
          });
          message.clear();
        }
      }


  );
  SpeedDialChild Log() => SpeedDialChild(
      child: SvgPicture.asset("assets/icons/log.svg",color: Colors.white , height: 30,),

    label: "Log",
    backgroundColor: Colors.blue,
    onTap: () async{
      await openDialog("Log");
      if (message.text.isNotEmpty) {
        AddLog(widget.id, message.text);
        message.clear();
      }
    }
  );
//  SpeedDialChild edit

SpeedDialChild Download() => SpeedDialChild(
  child: Icon(Icons.file_download, color: Colors.white,),
  label: "Download",
  backgroundColor: Colors.blue,
  onTap: () async{
    setState(() {
            isLoading = true;
          });
          final pdf = await PdfApi.generate(context.read<ComplaintObject>().complaint, widget.id);
          setState(() {
            isLoading = false;
          });
          PdfApi.openFile(pdf);
        },
      );
  SpeedDialChild Edit()=> SpeedDialChild(
      child: Icon(Icons.edit,color: Colors.white,),
      label: "Edit",
      backgroundColor: Colors.blue,
      onTap: () async{
        await showModalBottomSheet(context: context, builder:(context) =>  Sheet(id: widget.id,) );
        setState(() {});
      }
  );

}

AddLog(String id, String message) {
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
