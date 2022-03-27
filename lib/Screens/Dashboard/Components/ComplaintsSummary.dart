import '/Components/complaints_summary_card.dart';
import 'package:flutter/material.dart';

import '../../../Constants/constants.dart';
import 'chart.dart';

class ComplaintsSummary extends StatelessWidget {
  final int total;
  final int pending;
  final int completed;
  final int rejected;
  final int inprogress;

  const ComplaintsSummary({

    Key? key,
    required this.total,
    required this.pending,
    required this.completed,
    required this.rejected,
    required this.inprogress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
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
          Chart(total: total.toDouble(),pending: pending.toDouble(),completed: completed.toDouble(),rejected: rejected.toDouble(),inprogress: inprogress.toDouble(),),
          ComplaintsSummaryCard(
            svgSrc: kSvg,
            title: "Total Complaints",
            color: kPrimaryColor,
            numOfFiles: total,
          ),
          ComplaintsSummaryCard(
            svgSrc: kSvg,
            title: "In progress Complaints",
            color: Colors.cyan,
            numOfFiles: inprogress,
          ),
          ComplaintsSummaryCard(
            svgSrc: kSvg,
            title: "Pending Complaints",
            color: Color(0xFFFFA113),
            numOfFiles: pending,
          ),
          ComplaintsSummaryCard(
            svgSrc: kSvg,
            title: "Completed Complaints",
            color: Colors.green,
            numOfFiles: completed,
          ),
          ComplaintsSummaryCard(
              title: "Rejected Complaints",
              svgSrc: kSvg,
              color: Colors.red,
              numOfFiles: rejected),
        ],
      ),
    );
  }
}
