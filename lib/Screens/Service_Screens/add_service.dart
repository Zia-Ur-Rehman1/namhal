import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:namhal/Utlities/Utils.dart';


class AddServiceScreen extends StatefulWidget {
  AddServiceScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<AddServiceScreen> {


  final formkey = GlobalKey<FormState>();
 TextEditingController service = TextEditingController();
  String? selectedStatus;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Service"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(10.0),

                    child: Image.asset(
                      'assets/images/logo.png',
                    scale: 0.7,)),
                Text(
                  "Namhal",
                  style: TextStyle(
                      color: Colors.green.shade500,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    autofocus: true,
                    controller: service,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Service Name',
                      ),
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return ("Please Enter a service name");
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('Manager').snapshots(),
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
                            child: Text(element.get('email')),
                            value: element.get('email'),

                          ),
                        );
                      }
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<dynamic>(
                            borderRadius: BorderRadius.circular(8.0),
                            icon: const Icon(Icons.arrow_drop_down_circle),
                            iconSize: 30,
                            elevation: 8,
                            hint: const Text("Manager"),
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
                ),
        ElevatedButton(onPressed: addService, child: Text("Add Service"),),



              ],
            ),
          ),
        ),
      ),
    );
  }
Future<void> addService() async {
   bool  isLoading = false;
  bool check= await connection();
  if(check == false) return;
  final isValid = formkey.currentState!.validate();
  if (!isValid) return;
  formkey.currentState?.save();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: isLoading?  const CircularProgressIndicator(): const SizedBox(),
    ),
  );

  try {
    if(mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await   FirebaseFirestore.instance.collection('Service').add({
      'name': service.text,
      'manager': selectedStatus,
    });
    Utils.showSnackBar("Service Added", Colors.green);
  } on FirebaseException catch (e) {
    Utils.showSnackBar(e.message.toString(), Colors.red);
    Navigator.of(context, rootNavigator: true).pop();
    if(mounted){
      setState(() {
        isLoading = false;
      });

    }
    return;
  }
  if(mounted){
    setState(() {
      isLoading = false;

    });

  }
  Navigator.of(context, rootNavigator: true).pop();

}
  Future<bool> connection() async{

    ConnectivityResult result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none)
    {
      Utils.showSnackBar("No Internet\n Kindly check your connection", Colors.orange);
      return false;
    }
    else{
      return true;
    }
  }
}
