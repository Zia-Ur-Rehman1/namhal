import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:namhal/Screens/Report/report.dart';
import 'package:substring_highlight/substring_highlight.dart';


class DataSearch extends SearchDelegate<String> {

String? email;
DataSearch({this.email});



  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, "");
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, ""),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_city, size: 150),
            const SizedBox(height: 48),
            Text(
              query,
              style: TextStyle(
                color: Colors.black,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
  // stream builder
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Complains').where("username",isEqualTo: email.toString().substring(0, email!.indexOf('@'))).snapshots(),
        // stream: FirebaseFirestore.instance.collection('Complains').where("manager",isEqualTo: email).snapshots(),
        builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final suggestions = snapshot.data!.docs
            .where((doc) => doc.get("title").toString().toLowerCase().contains(query.toLowerCase()))
            .toList();

        //highlight matching text
        return ListView.builder(
    itemCount: suggestions.length,
    itemBuilder: (context, index) {
    return  GestureDetector(
      onTap: (){

        Navigator.push(context, MaterialPageRoute(builder: (context)=> Report(id: suggestions[index].id,)));

      },
      child: Card(
        elevation: 5,
        color: Colors.blueGrey,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(12.0))),
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text("Title: ",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),),
              SubstringHighlight(text: suggestions[index].get("title").toString(),textStyle: TextStyle( fontSize: 15,
                color: Colors.white54, ),term: query,textStyleHighlight: TextStyle(fontSize: 15,
                color: Colors.black,),),
          ],),

                Table(
                  children: [
                    TableRow(children: [
                      buildRichText("Name: ",
                          suggestions[index].get("username").toString()),
                      buildRichText("Address: ",
                          suggestions[index].get("address").toString()),
                    ]),
                    TableRow(children: [
                      buildRichText("Priority: ",
                          suggestions[index].get("priority").toString()),
                      buildRichText("Status: ",
                          suggestions[index].get("status").toString()),
                    ]),
                    TableRow(children: [
                      buildRichText("Worker: ",
                          suggestions[index].get("worker").toString()),
                      buildRichText("Service: ", suggestions[index].get("service").toString())
                    ]),
                  ],
                ),
              ],
            )),
      ),
    );
      },
    );
  });
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

}
