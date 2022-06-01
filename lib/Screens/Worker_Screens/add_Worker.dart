import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namhal/Screens/Dashboard/dashboard.dart';
import 'package:namhal/Utlities/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:namhal/providers/providers.dart';
import 'package:provider/provider.dart';
class AddWorker extends StatefulWidget {
  @override
  _AddWorkerState createState() => _AddWorkerState();
}

TextEditingController email = TextEditingController();
TextEditingController pass = TextEditingController();

class _AddWorkerState extends State<AddWorker> {
  bool _showPassword = false;
  bool isLoading = false;
  final formkey = GlobalKey<FormState>();
  String? selectedService;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Worker'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: AutofillGroup(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add Worker",
                    style: TextStyle(
                        color: Colors.green.shade500,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      autofocus: true,
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'User Name',
                          hintText: 'abc@namal.edu.pk'),
                      validator: (value) {
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@namal.edu.pk")
                            .hasMatch(value!)) {
                          return ("Please Enter a valid email ");
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: pass,
                      autofocus: true,
                      autofillHints: const [AutofillHints.password],
                      textInputAction: TextInputAction.done,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.security),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: _showPassword ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () {
                            setState(
                                    () => _showPassword = !_showPassword);
                          },
                        ),
                      ),
                      validator: (value) => value != null && value.length < 6
                          ? "Enter atleast 6 characters"
                          : null,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('Service').where("manager",isEqualTo: context.read<Info>().user.email).snapshots(),
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(onPressed: signIn, child: Text("Add Worker")))
                ],
              ),
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: pass.text.trim(),
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
    FirebaseFirestore.instance.collection("Worker").doc(email.text.trim()).set(
        {
          "email": email.text.trim(),
          "pass":pass.text.trim(),
          "name":email.text.trim().substring(0, email.text.trim().indexOf('@')),
          "service":selectedService,
          "task_assigned":0,
          "is_available":true,
        }
    );
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        //add dashboard and pass user object
        builder: (context) => DashboardScreen(),
      ),
    );
    Utils.showSnackBar("Worker Added", Colors.green);
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
