import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:namhal/Utlities/Utils.dart';
import 'package:namhal/api/TokenHandling.dart';
import 'package:namhal/api/notifyUser.dart';
import 'package:namhal/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
class Sheet extends StatefulWidget {
  final String id;
  const Sheet({Key? key,required this.id}) : super(key: key);

  @override
  State<Sheet> createState() => _SheetState();
}

class _SheetState extends State<Sheet> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? selectedService;
  String? selectedWorker;
  String? selectedStatus;
  String? selectedPriority;

  Map<String,String> workerMap = Map();
  @override
  initState() {
    super.initState();


    selectedService = context.read<ComplaintObject>().complaint.service;
    selectedStatus = context.read<ComplaintObject>().complaint.status;
    if( context.read<ComplaintObject>().complaint.worker != "---" ){
      selectedWorker = context.read<ComplaintObject>().complaint.worker;}

    if(context.read<ComplaintObject>().complaint.priority != "---"){
      selectedPriority = context.read<ComplaintObject>().complaint.priority;}

  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: const Color(0xff757575),
      child: Container
        (
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center
        (
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              const Text("Update Complaint" ,textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('Service').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(snapshot.data?.docs.isEmpty == true){
                      return const Center(
                        child: Text("No Complaints"),
                      );
                    }

                    List<DropdownMenuItem> serviceItem = [];
                    for (var element in snapshot.data!.docs) {

                      serviceItem.add(
                        DropdownMenuItem(
                          child: Text(element.get('service')),
                          value: element.get('service'),
                        ),
                      );
                    }
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                          icon: const Icon(Icons.arrow_drop_down_circle),
                          iconSize: 30,
                          elevation: 8,
                          isExpanded: false,
                          isDense: true,

                          hint: const Text("Select Service"),
                          value: selectedService,
                          items: serviceItem,
                          onChanged: (newValue) {
                            setState(() {
                              selectedService = newValue;
                            });
                          }),
                    );
                  },
                ),
                  StreamBuilder<QuerySnapshot>(
                    stream: firestore.collection('Priority').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if(snapshot.data?.docs.isEmpty == true) {
                        return const Center(
                          child: Text("No Data"),
                        );
                      }

                      List<DropdownMenuItem> serviceItem = [];
                      for (var element in snapshot.data!.docs) {
                        serviceItem.add(
                          DropdownMenuItem(
                            child: Text(element.get('priority')),
                            value: element.get('priority'),

                          ),
                        );
                      }
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<dynamic>(
                            borderRadius: BorderRadius.circular(8.0),
                            icon: const Icon(Icons.arrow_drop_down_circle),
                            iconSize: 30,
                            elevation: 8,
                            hint: const Text("Priority"),
                            value: selectedPriority,
                            items: serviceItem,
                            onChanged: (newValue) {
                              setState(() {
                                selectedPriority = newValue;
                              });
                            }),
                      );
                    },
                  ),

              ],),
              const SizedBox(height: 10,),

      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Status').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(snapshot.data?.docs.isEmpty == true) {
                return const Center(
                  child: Text("No Data"),
                );
              }

              List<DropdownMenuItem> serviceItem = [];
              for (var element in snapshot.data!.docs) {
                serviceItem.add(
                  DropdownMenuItem(
                    child: Text(element.get('status')),
                    value: element.get('status'),

                  ),
                );
              }
              return DropdownButtonHideUnderline(
                child: DropdownButton<dynamic>(
                    borderRadius: BorderRadius.circular(8.0),
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    iconSize: 30,
                    elevation: 8,
                    hint: const Text("Status"),
                    value: selectedStatus,
                    items: serviceItem,
                    onChanged: (newValue) {
                      setState(() {
                        selectedStatus = newValue;
                      });
                    }),
              );
            },
          ),
            StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('Worker').where("service",isEqualTo: "Electrical").where("is_available",isEqualTo: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(snapshot.data?.docs.isEmpty == true) {
                  return const Center(
                    child: Text("No Data"),
                  );
                }

                List<DropdownMenuItem> serviceItem = [];


                for (var element in snapshot.data!.docs) {
                  workerMap[element.get('name')] = element.id;
                  serviceItem.add(
                    DropdownMenuItem(
                      child: Text(element.get('name')),
                      value: element.get('name'),

                    ),
                  );
                }
                return DropdownButtonHideUnderline(
                  child: DropdownButton<dynamic>(
                      borderRadius: BorderRadius.circular(8.0),
                      icon: const Icon(Icons.arrow_drop_down_circle),
                      iconSize: 30,
                      elevation: 8,
                      hint: const Text("Worker"),
                      value: selectedWorker,
                      items: serviceItem,
                      onChanged: (newValue) {
                        setState(() {
                          selectedWorker = newValue;

                        });
                      }),
                );
              },
            ),
      ],),
            Container(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(onPressed: UpdateReport, child: const Text("Update") )),
            ],),
        ),
      ),),
    );
  }
UpdateReport() async {
  selectedWorker??="---";
  selectedPriority ??= "---";
if(selectedWorker!="---" && selectedStatus == "Pending" ){
  selectedStatus="InProgress";
}
if(selectedStatus == "Completed"){
  DateTime now = DateTime.now();
  final endDate =DateFormat.yMMMd().format(now);
  final endTime = DateFormat.jm().format(now);
  firestore.collection("Complains").doc(widget.id).update({
  "endDate": endDate,
    "endTime":endTime,
  });

  Provider.of<ComplaintObject>(context, listen: false).setEndDate(endDate);
  Provider.of<ComplaintObject>(context, listen: false).setEndTime(endTime);
}
firestore.collection("Complains").doc(widget.id).update({
  "status":selectedStatus,
  "worker":selectedWorker,
  "priority":selectedPriority,
  "service":selectedService,
}).then((value) => Utils.showSnackBar( "Updated Successfully",Colors.green)).catchError((onError) => Utils.showSnackBar("Failed to update user: $onError",Colors.red));

Provider.of<ComplaintObject>(context, listen: false).setService(selectedService.toString());
Provider.of<ComplaintObject>(context, listen: false).setWorker(selectedWorker.toString());
Provider.of<ComplaintObject>(context, listen: false).setStatus(selectedStatus.toString());
Provider.of<ComplaintObject>(context, listen: false).setPriority(selectedPriority.toString());

String token = await Token.CheckToken(context.read<ComplaintObject>().complaint.username.toString()+"@namal.edu.pk");
if(token!="false") {
  NotifyUser.sendPushMessage(token,
    "Title: " +context.read<ComplaintObject>().complaint.title.toString()+ "   Service: " +selectedService.toString(),
    "StatusUpdated: " + selectedStatus.toString() +  "\tAssigned To: " + selectedWorker.toString() +
        "\nPriority: " +selectedPriority.toString() ,
  );
}

Navigator.pop(context);
  }
  AssignWorker() {
    if (selectedWorker != "---") {
      firestore.collection("Worker").doc(workerMap[selectedWorker]).update({
        "task_assigned": FieldValue.increment(1),
      });
    }
  }
}



