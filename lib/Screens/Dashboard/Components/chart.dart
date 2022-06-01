import 'package:namhal/providers/providers.dart';
import 'package:provider/provider.dart';

import '/Constants/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {


  const Chart({
    Key? key,

  }) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late int? touchedIndex;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections:getSection(Provider.of<Status>(context, listen: true).total.toDouble(), context.read<Status>().pending.toDouble(), context.read<Status>().completed.toDouble(), context.read<Status>().rejected.toDouble(), context.read<Status>().InProgress.toDouble()),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: kDefaultPadding),
                Text(
                  //parse as int
                  (context.read<Status>().completed).toStringAsFixed(0) + " Completed",
                  style: const TextStyle(
                    color: kSecondaryColor,
                    fontWeight: FontWeight.w600,
                    height: 0.5,
                  ),
                ),
                Text(
                  "out of "+ ( context.read<Status>().total).toStringAsFixed(0) + " Total",
                  style: const TextStyle(color: kSecondaryColor),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  getSection(double total, double pending, double completed, double rejected, double inprogress) {

    List<PieChartSectionData> sections = <PieChartSectionData>[];

    sections.add(
      PieChartSectionData(
        color: Colors.cyan,
        value: inprogress,
        radius: 20,
        showTitle: false,
      ),
    );
    sections.add(
      PieChartSectionData(
        color: Colors.orangeAccent,
        value: pending,
        radius: 15,
        showTitle: false,
      ),
    );
    sections.add(
      PieChartSectionData(

        color: Colors.green,
        value: completed,
        radius: 10,
        showTitle: false,
      ),
    );
    sections.add(
      PieChartSectionData(
        color: Colors.red,
        showTitle: false,
        value: rejected,
        radius: 8,
      ),
    );
    return sections;
  }
}


List<PieChartSectionData> paiChartSelectionDatas = [

  PieChartSectionData(
    color: Colors.cyan,
    value: 20,
    showTitle: false,
    radius: 22,
  ),
  PieChartSectionData(
    color: const Color(0xFFFFA113),
    value: 15,
    showTitle: false,
    radius: 19,
  ),
  PieChartSectionData(
    color: Colors.green,
    value: 10,
    showTitle: false,
    radius: 16,
  ),
  PieChartSectionData(color: Colors.red, value: 5, showTitle: false, radius: 8),
  PieChartSectionData(
    color: kPrimaryColor.withOpacity(0.1),
    value: 25,
    showTitle: false,
    radius: 10,
  ),

];
