import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'database_helper.dart';
import 'package:excel/excel.dart';
import 'dart:convert';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  // Variables to hold location data
  double latitude = 0.0;
  double longitude = 0.0;
  double altitude = 0.0;

  // Function to get location data
  void _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      altitude = position.altitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Latitude: $latitude'),
            Text('Longitude: $longitude'),
            Text('Altitude: $altitude'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text('Get Location'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/accelerometer');
              },
              child: Text('Go to Accelerometer Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/gyroscope');
              },
              child: Text('Go to Gyroscope Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/magnetometer');
              },
              child: Text('Go to Magnetometer Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sensor_data');
              },
              child: Text('Go to Sensor_Data Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/accelerometer_data');
              },
              child: Text('Go to Accelerometer_Data Page'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Get the database helper object.

                DatabaseHelper databaseHelper = DatabaseHelper();

                // Export the accelerometer data to Excel.
                await databaseHelper.exportAccelerometerDataToGoogleSheet();

                // Show a snackbar to the user to let them know that the Excel file has been exported.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Data exported successfully to google spreadsheet'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Export to google spreadsheet'),
            )
          ],
        ),
      ),
    );
  }
}
