import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:namhal/Screens/Advance_Serach/advanceSerach.dart';
import 'package:namhal/providers/providers.dart';
import 'package:provider/provider.dart';
import 'ComplaintsModel.dart';
import '../Constants/constants.dart';

class ComplaintsInfoCard extends StatelessWidget {
  const ComplaintsInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final ComplaintsStorageInfo info;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        onTap: () {
          if(info.title== "Pending"){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdvanceSearch(passStream: FirebaseFirestore.instance.collection("Complains").where('username',
                        isEqualTo: context.read<Info>().user.name).where("status", isEqualTo: "Pending").snapshots(),)));
          }
          else if(info.title== "Rejected"){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdvanceSearch(passStream: FirebaseFirestore.instance.collection("Complains").where('username',
                        isEqualTo: context.read<Info>().user.name).where("status", isEqualTo: "Rejected").snapshots(),)));
          }
          else if(info.title== "Inprogress"){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdvanceSearch(passStream: FirebaseFirestore.instance.collection("Complains").where('username',
                        isEqualTo: context.read<Info>().user.name).where("status", isEqualTo: "Inprogress").snapshots(),)));
          }
          else if(info.title== "Completed"){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdvanceSearch(passStream: FirebaseFirestore.instance.collection("Complains").where('username',
                        isEqualTo: context.read<Info>().user.name).where("status", isEqualTo: "Completed").snapshots(),)));
          }
          // Navigator.pushNamed(context, '/complaints_details', arguments: info);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(kDefaultPadding * 0.75),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: info.color!.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SvgPicture.asset(
                    info.svgSrc!,
                    color: info.color,
                  ),
                ),
                // Icon(Icons.more_vert, color: Colors.white54)
              ],
            ),
            Text(
              info.title!,
              maxLines: 1,
              style: TextStyle(color: Colors.white),

              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${info.numOfFiles} Files",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white70),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
