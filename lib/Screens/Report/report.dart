import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:namhal/Utlities/Utils.dart';
import 'package:namhal/api/TokenHandling.dart';
import 'package:namhal/api/notifyUser.dart';
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

  const Report({Key? key, required this.id}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool isVisible = false;
  bool isLoading = false;
  double rating = 0;
  bool isComplete = false;
  IconData iconData = Icons.add;
  IconData iconData2 = Icons.close;
  TextEditingController message = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  initState() {
    super.initState();
    if (context.read<ComplaintObject>().complaint.status == "Completed" || context.read<ComplaintObject>().complaint.status == "Rejected") {
      isComplete = true;
    }
    if(context.read<ComplaintObject>().complaint.reissue == 0){
      isVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  color: kSecondaryColor.withOpacity(0.5),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                        gradient: lg,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          buildRichText(
                              "Title: ",
                              context
                                  .read<ComplaintObject>()
                                  .complaint
                                  .title
                                  .toString()),
                          Table(
                            children: [
                              TableRow(children: [
                                buildRichText(
                                    "Name: ",
                                    context
                                        .read<ComplaintObject>()
                                        .complaint
                                        .username
                                        .toString()),
                                buildRichText(
                                    "Address: ",
                                    context
                                        .read<ComplaintObject>()
                                        .complaint
                                        .address
                                        .toString()),
                              ]),
                              TableRow(children: [
                                buildRichText(
                                    "Priority: ",
                                    context
                                        .read<ComplaintObject>()
                                        .complaint
                                        .priority
                                        .toString()),
                                buildRichText(
                                    "Status: ",
                                    context
                                        .read<ComplaintObject>()
                                        .complaint
                                        .status
                                        .toString()),
                              ]),
                              TableRow(children: [
                                buildRichText(
                                    "Worker: ",
                                    context
                                        .read<ComplaintObject>()
                                        .complaint
                                        .worker
                                        .toString()),
                                buildRichText(
                                    "Service: ",
                                    context
                                        .read<ComplaintObject>()
                                        .complaint
                                        .service
                                        .toString())
                              ]),
                              TableRow(children: [
                                buildRichText(
                                    "Date: ",
                                    context
                                        .read<ComplaintObject>()
                                        .complaint
                                        .startDate
                                        .toString()),
                                buildRichText(
                                    "Time: ",
                                    context
                                        .read<ComplaintObject>()
                                        .complaint
                                        .startTime
                                        .toString())
                              ]),
                            ],
                          ),
                        ],
                      )),
                ),

                const SizedBox(
                  height: 10,
                ),
                const Text("Description",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    )),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                      gradient: lg,
                    ),
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      context.read<ComplaintObject>().complaint.desc.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),

                ExpansionTile(
                  title: const Text(
                    "Image",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  children: [
                    context.read<ComplaintObject>().complaint.img !=
                            "No Image Attached"
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: CachedNetworkImage(
                              imageUrl: context
                                  .read<ComplaintObject>()
                                  .complaint
                                  .img
                                  .toString(),
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ))
                        : Image.asset(
                            "assets/images/noImg.png",
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width / 1.2,
                            fit: BoxFit.cover,
                          ),
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
                const SizedBox(
                  height: 10,
                ),

                Center(
                  child: isLoading ? const CircularProgressIndicator() : const SizedBox(),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    "Feedback",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor),
                  ),
                ),

                Container(
                  height: 150,
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          child: context
                                      .read<ComplaintObject>()
                                      .complaint
                                      .feedback !=
                                  null
                              ? Text(
                                  context
                                      .read<ComplaintObject>()
                                      .complaint
                                      .feedback
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                )
                              : const Text("No Feedback"),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.blue, width: 2)),
                  ),
                ),
                //Show Rating
                buildRating(true),
                //add rating here
                isComplete? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible:isVisible,
                      replacement: const SizedBox(),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                            ),
                        onPressed: () async {
                          await firestore.collection("Complains").doc(widget.id).update({
                            "reissue": -1,
                          });
                          setState(() {
                            isVisible = false;
                          });
                        }, child: const Text("Accept"),

                      ),

                    ),
                    Visibility(
                      visible:isVisible,
                      replacement: const SizedBox(),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: () async {
                            DateTime now = DateTime.now();
                            await firestore.collection("Complains").doc(widget.id).update({
                              "reissue": FieldValue.increment(1),
                              "priority":"High",
                              "endDate": null,
                              "endTime": null,
                              "startDate": DateFormat.yMMMd().format(now),
                              "startTime": DateFormat.jm().format(now),
                              "timestamp": Timestamp.now(),
                              "status": "Pending",
                            });
                            String token = await Token.CheckToken(context.read<ComplaintObject>().complaint.manager);
                            if(token!="false") {
                              NotifyUser.sendPushMessage(token,
                                "Complaind By: " + context.read<ComplaintObject>().complaint.username.toString() + "   Service: " +context.read<ComplaintObject>()
                                  .complaint.service.toString(),
                              "Title: "+context.read<ComplaintObject>().complaint.title.toString() +  "\nAlert : Complaint Re-Issued",
                              );
                            }
                            setState(() {
                              isVisible = false;
                            });
                          }, child: const Text("Reject")),
                    )
                  ],
                ):const SizedBox(),
              ], //children
            ),
          ),
        ),
      ),
      //add circular fab widget
      floatingActionButton: SpeedDial(
        icon: iconData,
        activeIcon: iconData2,
        backgroundColor: Colors.blue,
        activeBackgroundColor: Colors.redAccent,
        children: [
          Log(),
          Download(),
          isComplete ? FeedBack() : Empty(),
          isComplete ? RateIt() : Empty(),
           // Edit(),
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
            style: rcST,
          ),
        ],
        style: rcT,
      ),
    );
  }

  Widget buildLog(BuildContext context) => ExpansionTile(
        title: const Text(
          "Logs",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
                const Text("Error");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data?.docs.isEmpty == true) {
                return const Center(
                  child: Text("No Logs"),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                child: const Text("Submit"),
              ),
            ],
          ));
  @override
  void dispose() {
    super.dispose();
    message.dispose();
  }

  Widget buildRating(bool gesture) {
    return Center(
      child: RatingBar.builder(
        initialRating:
            context.read<ComplaintObject>().complaint.rating?.toDouble() ?? 0,
        itemCount: 5,
        ignoreGestures: gesture,
        updateOnDrag: true,
        allowHalfRating: true,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return const Icon(
                Icons.sentiment_very_dissatisfied,
                color: Colors.red,
              );
            case 1:
              return const Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.orange,
              );
            case 2:
              return const Icon(
                Icons.sentiment_neutral,
                color: Colors.amber,
              );
            case 3:
              return const Icon(
                Icons.sentiment_satisfied,
                color: Colors.lightGreen,
              );
            case 4:
              return const Icon(
                Icons.sentiment_very_satisfied,
                color: Colors.green,
              );
            default:
              return const Icon(
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

  void showRating() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Rate this Complain"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Please rate the quality of the service"),
                const SizedBox(
                  height: 10,
                ),
                buildRating(false),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: ()  async {
                    await firestore.collection('Complains').doc(widget.id).update({
                      'rating': context.read<ComplaintObject>().complaint.rating
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Submit")),
            ],
          ));

  SpeedDialChild FeedBack() => SpeedDialChild(
      child: SvgPicture.asset(
        "assets/icons/feedback.svg",
        color: Colors.white,
        height: 30,
      ),
      label: "Feedback",
      backgroundColor: Colors.blue,
      onTap: () async {
        await openDialog("Feedback");
        if (message.text.isNotEmpty &&
            message.text !=
                context.read<ComplaintObject>().complaint.feedback.toString()) {
        await  firestore
              .collection("Complains")
              .doc(widget.id)
              .update({
                "feedback": message.text,
              })
              .then((value) => Utils.showSnackBar("Updated", Colors.green))
              .catchError((error) =>
                  Utils.showSnackBar("Failed to update : $error", Colors.red));
          setState(() {
            context.read<ComplaintObject>().complaint.feedback = message.text;
          });
          message.clear();
        }
      });
  SpeedDialChild RateIt() => SpeedDialChild(
      child: const Icon(
        Icons.thumb_up_alt_outlined,
        color: Colors.white,
        size: 30,
      ),
      label: "Rate It",
      backgroundColor: Colors.blue,
      onTap: showRating);
  SpeedDialChild Log() => SpeedDialChild(
      child: SvgPicture.asset(
        "assets/icons/log.svg",
        color: Colors.white,
        height: 30,
      ),
      label: "Log",
      backgroundColor: Colors.blue,
      onTap: () async {
        await openDialog("Log");
        if (message.text.isNotEmpty) {
          AddLog(widget.id, message.text);
          message.clear();
        }
      });
//  SpeedDialChild edit
  SpeedDialChild Empty() => SpeedDialChild();
  SpeedDialChild Download() => SpeedDialChild(
        child: const Icon(
          Icons.file_download,
          color: Colors.white,
        ),
        label: "Download",
        backgroundColor: Colors.blue,
        onTap: () async {
          setState(() {
            isLoading = true;
          });
          final pdf = await PdfApi.generate(
              context.read<ComplaintObject>().complaint, widget.id);
          setState(() {
            isLoading = false;
          });
          PdfApi.openFile(pdf);
        },
      );
  SpeedDialChild Edit() => SpeedDialChild(
      child: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
      label: "Edit",
      backgroundColor: Colors.blue,
      onTap: () async {
        await showModalBottomSheet(
            context: context,
            builder: (context) => Sheet(
                  id: widget.id,
                ));
        setState(() {});
      });
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
