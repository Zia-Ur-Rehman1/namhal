import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namhal/Screens/Dashboard/dashboard.dart';
import 'package:namhal/api/notifyUser.dart';
import '/providers/providers.dart';
import '../../Utlities/Utils.dart';
import '../../model/complaint.dart';
import 'package:provider/provider.dart';

import 'Components/AddressOverlay.dart';
class AddComplain extends StatefulWidget {
  const AddComplain({Key? key}) : super(key: key);

  @override
  _AddComplainState createState() => _AddComplainState();
}

class _AddComplainState extends State<AddComplain> {

  final formKey = GlobalKey<FormState>();
@override
final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, String> serviceManager = {};
  var selectedService;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  File? image;
  String url = '';
  String? uservalue;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      Utils.showSnackBar("Failed to pick image: $e", Colors.red);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Complain"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  maxLength: 50,
                  controller: _titleController,
                  validator: (value) => value != null && value.length < 6
                      ? "Enter atleast 6 characters"
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    //show errors here
                    // errorText: 'Error message',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title_outlined),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  maxLength: 200,
                  controller: _descriptionController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  validator: (value) => value != null && value.length < 6
                      ? "Enter atleast 6 characters"
                      : null,
                  minLines: 1,
                  //Normal textInputField will be displayed
                  maxLines: 3,
                  // when user presses enter it will adapt to it
                  decoration: InputDecoration(
                    labelText: 'Description',
                    //show errors here
                    // errorText: 'Error message',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.insert_comment_outlined),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Address(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(5)),
      child:   StreamBuilder<QuerySnapshot>(
                    stream: firestore.collection('Service').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if(snapshot.data?.docs.length==0)
                        return Center(
                          child: Text("No Complaints"),
                        );

                      List<DropdownMenuItem> serviceItem = [];
                      for (var element in snapshot.data!.docs) {
                        serviceManager[element.get('service')] =
                            element.get('manager');
                        serviceItem.add(
                          DropdownMenuItem(
                            child: Text(element.get('service')),
                            value: element.get('service'),
                          ),
                        );
                      }
                      return DropdownButtonFormField<dynamic>(

                          menuMaxHeight: 300.0,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.engineering_outlined),
                          ),
                          iconSize: 50,
                          elevation: 5,
                          isExpanded: false,

                          hint: Text("Select Service"),
                          isDense: true,
                          value: selectedService,
                          items: serviceItem,
                          onChanged: (newValue) {
                            setState(() {
                              selectedService = newValue;
                            });
                          });
                    },
                  ),
                ),

                if (image != null)
                  Card(
                    elevation: 5,
                    child: Image.file(
                      image!,
                      width: MediaQuery.of(context).size.width / 2,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Text(
                    "No Image Selected Yet!",
                    style: TextStyle(fontSize: 20),
                  ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          pickImage(ImageSource.camera);
                        },
                        child: Icon(Icons.camera_alt_outlined)),
                    ElevatedButton(
                        onPressed: () {
                          pickImage(ImageSource.gallery);
                        },
                        child: Icon(Icons.collections_bookmark_outlined)),
                  ],
                ),

                ElevatedButton(
                    onPressed: setComplaint,
                    child: Text("Confirm")),
                //TODO Add image picker
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future setComplaint()  async {
    //check connectivity

    final isValid = formKey.currentState?.validate();
    if (!isValid!) return;
    if (selectedService== null) {
      Utils.showSnackBar("Kindly add service ",Colors.red);
      return;
    }
    if(Provider.of<add>(context,listen: false).address=="Not Set"){
      Utils.showSnackBar("Kindly set address",Colors.red);
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    DateTime now = DateTime.now();

      if(image!=null){
        final refe =  FirebaseStorage.instance
            .ref()
            .child('complains/$now');
        await refe.putFile(image!);
        url = await refe.getDownloadURL();
      }

    CollectionReference complaint =
    firestore.collection('Complains');
    User user =  FirebaseAuth.instance.currentUser!;
    Complains complains = Complains(
      username: user.email!.substring(0, user.email!.indexOf('@')),
      title: _titleController.text,
      desc: _descriptionController.text,
      status: "Pending",
      worker: "Not Assign",
      timestamp: Timestamp.now(),
      manager: serviceManager[selectedService],
      startDate: DateFormat.yMMMd().format(now),
      startTime: DateFormat().add_jm().format(now),
      service: selectedService,
      address: context.read<add>().getAddress(),

      img: image!=null?url:"No Image Attached",);

    await complaint.add(complains.toJson()).then((value) async {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      String? token;
      await firestore.collection('User').doc(serviceManager[selectedService]).get().then((
          value) {
        token = value.get('token');
        print("Token exits $token");
      });
      if(token!.length>2) {
        print("Token exits");

        NotifyUser().Notify();
        NotifyUser.sendPushMessage(token!,
            complains.title.toString() + "   " +
                complains.service.toString(), complains.username.toString());
      }
      Utils.showSnackBar("Complaint Added Successfully",Colors.green);
    }).catchError((e) {
      Navigator.pop(context);
      Utils.showSnackBar("Error Occured",Colors.red);
    });
  }

}



