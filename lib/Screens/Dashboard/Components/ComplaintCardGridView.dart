import 'package:flutter/material.dart';
import 'package:namhal/Components/ComplaintsModel.dart';
import 'package:namhal/Components/Complaints_info_card.dart';
import 'package:namhal/Constants/constants.dart';
import 'package:namhal/providers/providers.dart';
import 'package:provider/provider.dart';
class ComplaintsCardGridView extends StatelessWidget  {
  const ComplaintsCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,

  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return Consumer<Status>(
      builder: (context,status,child){
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ComplaintsDetails.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: kDefaultPadding,
            mainAxisSpacing: kDefaultPadding,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            ComplaintsStorageInfo info = ComplaintsDetails[index];
            if(info.title=="Pending") {
              info.numOfFiles =  status.pending;
            } else if(info.title=="Inprogress" ) {
              info.numOfFiles =  status.InProgress;
            } else if(info.title=="Completed" ) {
              info.numOfFiles = status.completed;
            } else if(info.title=="Rejected" ) {
              info.numOfFiles = status.rejected;
            }
            return ComplaintsInfoCard(info: ComplaintsDetails[index]);
          },
        );
      }
    );
  }
}
