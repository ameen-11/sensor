// import 'dart:io';
// import 'package:excel/excel.dart';
// import 'package:path_provider/path_provider.dart';
// import 'accelerometer_page.dart';
// import 'database_helper.dart';

// class ExcelExportPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Excel Export'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: printAccelerometerDataToExcel,
//           child: Text('Print Accelerometer Data to Excel'),
//         ),
//       ),
//     );
//   }

//   Future<void> printAccelerometerDataToExcel() async {
//     // Get the accelerometer page data.
//     final accelerometerPageData = await DatabaseHelper().getAccelerometerPageData();

//     // Create a new Excel sheet.
//     Excel? excel = Excel.createExcel();

//     // Check if the Excel sheet was created successfully.
//     if (excel != null) {
//       // Add the column headers to the Excel sheet.
//       excel.sheets['Sheet1']?.cell(row: 1, column: 1).value = 'timestamp';
//       excel.sheets['Sheet1']?.cell(row: 1, column: 2).value = 'x';
//       excel.sheets['Sheet1']?.cell(row: 1, column: 3).value = 'y';
//       excel.sheets['Sheet1']?.cell(row: 1, column: 4).value = 'z';

//       // Add the accelerometer data to the Excel sheet.
//       int row = 2;
//       for (final accelerometerDatum in accelerometerPageData) {
//         excel.sheets['Sheet1']?.cell(row: i + 2, column: 1).value = accelerometerDatum.timestamp;
//         excel.sheets['Sheet1']?.cell(row: i + 2, column: 2).value = accelerometerDatum.x;
//         excel.sheets['Sheet1']?.cell(row: i + 2, column: 3).value = accelerometerDatum.y;
//         excel.sheets['Sheet1']?.cell(row: i + 2, column: 4).value = accelerometerDatum.z;
//       }

//       // Save the Excel sheet.
//       File excelFile = File.fromBytes(await excel.encode());

//       // Open the Excel sheet.
//       await excelFile.open();
//     }
//   }
// }