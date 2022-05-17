import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namhal/Utlities/Utils.dart';
import 'package:namhal/providers/providers.dart';
import 'package:provider/provider.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool editPass=false;
  Color _color=Colors.black;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController=TextEditingController()..text = context.read<Info>().user.name??'No user found';
    _emailController=TextEditingController()..text = context.read<Info>().user.email??'No user found';
    _passwordController=TextEditingController()..text = context.read<Info>().user.pass??'No user found';


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AspectRatio(aspectRatio: 3/2, child: Image.asset('assets/images/user.png')),
                SizedBox(height: 20,),
                TextField(
                  enabled: false,
                  controller: _nameController,
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.blue),
                    labelText: 'User Name',

                  ),
                ),
                SizedBox(height: 20,),

                TextField(
                  enabled: false,
                  controller: _emailController,
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.blue),
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 20,),

                Row(children: [
                  Expanded(
                    flex: 9,
                    child: TextField(
                      enabled: editPass,
                      controller: _passwordController,

                      onChanged: (value){
                        context.read<Info>().user.pass=value;
                      //  update in firebase

                      },
                      obscureText: !editPass,
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        border: OutlineInputBorder(),

                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.blue),
                      ),
                    ),

                  ),
                  Expanded(
                    child: IconButton(onPressed: (){
                      setState(() {
                        if(editPass==false) {
                          editPass = true;
                          _color = Colors.blue;
                        }
                        else{
                          editPass = false;
                          _color = Colors.black;
                        }
                      });
                    }, icon: Icon(Icons.edit,color: _color,),),
                  ),
                ],),
              editPass? ElevatedButton(onPressed: (){
                String pass = _passwordController.text;

                FirebaseAuth.instance.currentUser?.updatePassword(pass).then((value){
                  print('password updated');
                  Utils.showSnackBar("Password Updated", Colors.green);
                }).catchError((e){
                  Utils.showSnackBar("Error: $e", Colors.red);
                });
                FirebaseFirestore.instance.collection("User").doc(context.read<Info>().user.email).update({
                  'pass': pass,
                });
                setState(() {
                  editPass=false;
                  _color=Colors.black;
                });
              }, child: Text("Update"),):SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
