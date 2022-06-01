import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:namhal/Constants/constants.dart';
import 'package:namhal/Screens/Report/report.dart';
import 'package:namhal/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';


class DataSearch extends SearchDelegate<String> {

String? email;
DataSearch({this.email});



  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
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
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, ""),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_city, size: 150),
            const SizedBox(height: 48),
            Text(
              query,
              style: const TextStyle(
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
      stream: FirebaseFirestore.instance.collection('Complains').where("username",isEqualTo:context.read<Info>().user.email).snapshots(),
        // stream: FirebaseFirestore.instance.collection('Complains').where("manager",isEqualTo: email).snapshots(),
        builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
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
      child: Container(
        margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
                Radius.circular(12.0)),
            gradient: lg,
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          const Text("Title: ",style: TextStyle(fontSize: 15,color: kSecondaryColor,fontWeight: FontWeight.bold),),
            SubstringHighlight(text: suggestions[index].get("title").toString(),textStyle: const TextStyle( fontSize: 15,
              color: Colors.white54, ),term: query,textStyleHighlight: const TextStyle(fontSize: 15,
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
            style: rcST,
          ),
        ],
        style: rcT,
      ),
    );
  }

}
