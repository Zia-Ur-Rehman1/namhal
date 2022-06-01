//
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
//
// import '../model/Worker.dart';
//
// class WorkerDataGridSource extends DataGridSource<Worker> {
//   // CollectionReference collection;
//   //
//   // WorkerDataGridSource() {
//   //   collection = FirebaseFirestore.instance.collection('Worker');
//   // }
//   //
//   // Stream<QuerySnapshot> getStream() {
//   //   return collection.snapshots();
//   // }
//
//   Future<void> buildStream(AsyncSnapshot snapShot) async {
//     if (snapShot.hasError ||
//         snapShot.data == null ||
//         snapShot.data.docs.length == 0) {
//       return Future<Void>.value();
//     }
//
//     await Future.forEach(snapShot.data.docs, (element) {
//       final Employee data = Employee.fromSnapshot(element);
//       if (!employees.any((element) => element.employeeID == data.employeeID)) {
//         employees.add(data);
//       }
//     });
//
//     updateDataGridDataSource();
//
//     return Future<Void>.value();
//   }
//
//   void updateDataGridDataSource() {
//     notifyListeners();
//   }
//
//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     // TODO: implement buildRow
//     throw UnimplementedError();
//   }
// }
