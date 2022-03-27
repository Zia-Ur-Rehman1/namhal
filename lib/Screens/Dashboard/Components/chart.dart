import '/Constants/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final double total;
  final double pending;
  final double completed;
  final double rejected;
  final double inprogress;

  const Chart({
    Key? key,
    required this.total,
    required this.pending,
    required this.completed,
    required this.rejected,
    required this.inprogress,
  }) : super(key: key);

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
              sections:getSection(total, pending, completed, rejected, inprogress),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: kDefaultPadding),
                Text(
                  //parse as int
                  '${(completed).toStringAsFixed(0)}'+ " Completed",
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontWeight: FontWeight.w600,
                    height: 0.5,
                  ),
                ),
                Text(
                  "out of "+'${(total).toStringAsFixed(0)}' + " Total",
                  style: TextStyle(color: kSecondaryColor),
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
        color: Colors.yellow,
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
    color: Color(0xFFFFA113),
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
