import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:namhal/Screens/Dashboard/dashboard.dart';
import 'package:namhal/Utlities/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

TextEditingController email = TextEditingController();
TextEditingController pass = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;
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
        title: Text('Login Page'),
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
                  "Namhal",
                  style: TextStyle(
                      color: Colors.green.shade500,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    autofocus: true,
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: [AutofillHints.username],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                        hintText: 'abc@namal.edu.pk'),
                    validator: (value) {
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@namal.edu.pk")
                          .hasMatch(value!)) {
                        return ("Please Enter a valid email ");
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: pass,
                    autofocus: true,
                    autofillHints: [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                    obscureText: !this._showPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.security),
                      suffixIcon: IconButton(
                        icon: Icon(
                          this._showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: this._showPassword ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          setState(
                              () => this._showPassword = !this._showPassword);
                        },
                      ),
                    ),
                    validator: (value) => value != null && value.length < 6
                        ? "Enter atleast 6 characters"
                        : null,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.95,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: signIn,
                    child: Text(
                      "Login",
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
        child: isLoading?  CircularProgressIndicator(): SizedBox(),
      ),
    );

    try {
      if(mounted) {
        setState(() {
          isLoading = true;
        });
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
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
    //if mounted then pop
    // Navigator.of(context).pop();
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        //add dashboard and pass user object
        builder: (context) => DashboardScreen(),
      ),
    );
    Utils.showSnackBar("User Authorized", Colors.green);
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
