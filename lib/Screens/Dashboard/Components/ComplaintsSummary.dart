import 'package:provider/provider.dart';

import '/Components/complaints_summary_card.dart';
import 'package:flutter/material.dart';

import '../../../Constants/constants.dart';
import 'chart.dart';
import '/providers/providers.dart';

class ComplaintsSummary extends StatelessWidget {


  const ComplaintsSummary({

    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        //linear gradient
        gradient: lg,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Complaints Summary",
            style: TextStyle(
              color: kSecondaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: kDefaultPadding),
          Chart(),
          ComplaintsSummaryCard(
            svgSrc: kSvg,
            title: "Total Complaints",
            color: kPrimaryColor,
            numOfFiles: context.read<Status>().total,
          ),
          ComplaintsSummaryCard(
            svgSrc: kSvg,
            title: "In progress Complaints",
            color: Colors.cyan,
            numOfFiles: context.read<Status>().InProgress,
          ),
          ComplaintsSummaryCard(
            svgSrc: kSvg,
            title: "Pending Complaints",
            color: Color(0xFFFFA113),
            numOfFiles: context.read<Status>().pending,
          ),
          ComplaintsSummaryCard(
            svgSrc: kSvg,
            title: "Completed Complaints",
            color: Colors.green,
            numOfFiles: context.read<Status>().completed,
          ),
          ComplaintsSummaryCard(
              title: "Rejected Complaints",
              svgSrc: kSvg,
              color: Colors.red,
              numOfFiles: context.read<Status>().rejected),
        ],
      ),
    );
  }
}
