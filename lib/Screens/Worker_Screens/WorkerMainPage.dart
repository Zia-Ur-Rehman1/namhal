// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// class WorkerScreen extends StatefulWidget {
//   const WorkerScreen({Key? key}) : super(key: key);
//
//   @override
//   State<WorkerScreen> createState() => _WorkerScreenState();
// }
//
// class _WorkerScreenState extends State<WorkerScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: StreamBuilder<QuerySnapshot>(
//       builder: (context, snapshot) {
//     stream: FirebaseFirestore.instance.collection('Worker').snapshots(),
//
//     employeeDataGridSource.buildStream(snapshot);
//     return SfDataGrid(
//     source: employeeDataGridSource,
//     columnWidthMode: ColumnWidthMode.fill,
//     columns: [
//     GridNumericColumn(mappingName: 'employeeID', headerText: 'ID'),
//     GridTextColumn(mappingName: 'employeeName', headerText: 'Name'),
//     GridTextColumn(mappingName: 'designation', headerText: 'Role'),
//     GridNumericColumn(mappingName: 'salary', headerText: 'Salary'),
//     ],
//     );
//     }
//     ),
//     );
//
//   }
// }
