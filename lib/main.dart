import 'package:flutter/material.dart';
import 'package:sensor_data/sensor_data_page.dart';
import 'location_page.dart'; // Import the location_page.dart file
import 'accelerometer_page.dart'; // Import the accelerometer_page.dart file
import 'gyroscope_page.dart';
import 'magnetometer_page.dart';
import 'sensor_data_page.dart';
import 'database_helper.dart';
import 'accelerometer_data_page.dart';
// import 'excel_export_page.dart' ;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Location App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define routes
      routes: {
        '/': (context) =>
            LocationPage(), // Set the initial page to LocationPage
        '/accelerometer': (context) =>
            AccelerometerPage(), // Add a route for AccelerometerPage
        '/gyroscope': (context) => GyroscopePage(),
        '/magnetometer': (context) => MagnetometerPage(),
        '/sensor_data': (context) => SensorDataPage(),
        '/accelerometer_data' :(context) => AccelerometerDataPage(),
        // '/excel_export_page' :(context) => ExcelExportPage(),
      },
    );
  }
}
