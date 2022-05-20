import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namhal/Screens/Dashboard/dashboard.dart';
import 'package:namhal/Utlities/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

TextEditingController address = TextEditingController();
TextEditingController location = TextEditingController();

class _AddAddressState extends State<AddAddress> {

  bool isLoading = false;
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: AutofillGroup(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    child: Image.asset(
                      'assets/images/logo.png',
                    )),
                Text(
                  "Add Address",
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
                    controller: address,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Address',
                        hintText: 'Dorm-G-01/Block-A-01'),
                    validator: (value) {
                      if (!RegExp("^[a-zA-Z]+-[a-zA-Z]+-[0-9-]")
                          .hasMatch(value!)) {
                        return ("Enter Correct Format ");
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    autofocus: true,
                    controller: location,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Location',
                        hintText: 'Hostel/University'),
                    validator: (value) => value != null && value.length < 6
                        ? "Enter atleast 6 characters"
                        : null,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.95,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: signIn,
                    child: const Text(
                      "Add User",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shadowColor: Colors.blueAccent,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),

                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    bool check= await connection();
    if(check == false) return;
    final isValid = formkey.currentState!.validate();
    if (!isValid) return;
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
      FirebaseFirestore.instance.collection("Address").add(
          {
            "address": address.text.trim(),
            "location": location.text.trim(),
          }
      );

    } on FirebaseAuthException catch (e) {
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
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        //add dashboard and pass user object
        builder: (context) => DashboardScreen(),
      ),
    );
    Utils.showSnackBar("Address Added", Colors.green);
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
