import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'database_helper.dart';

class AccelerometerPage extends StatefulWidget {
  @override
  _AccelerometerPageState createState() => _AccelerometerPageState();
}

class _AccelerometerPageState extends State<AccelerometerPage> {
  // Variables to hold accelerometer data
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  bool isStarted = false;
  StreamSubscription<AccelerometerEvent>? _streamSubscription;

  DatabaseHelper? _databaseHelper;

  @override
  void initState() {
    super.initState();

    _databaseHelper = DatabaseHelper();
    _databaseHelper?.initDatabase();
  }

  @override
  void dispose() {
    // Cancel the subscription to the accelerometer data stream and close the database connection
    _streamSubscription?.cancel();
    _databaseHelper?.dispose();

    super.dispose();
  }
  
  void _displayAccelerometerData() async {
    // Get the current timestamp
    final timestamp = DateTime.now();

    // Create a AccelerometerData object from the four arguments
    final accelerometerDatum = AccelerometerData(x, y, z, timestamp);

    // Insert the accelerometer data into the database
     await _databaseHelper?.insertAccelerometerData(accelerometerDatum);
  }

  // Function to listen for accelerometer data
  void _listenToAccelerometer() {
    if (isStarted) {
      _streamSubscription =
          accelerometerEvents.listen((AccelerometerEvent event) {
        setState(() {
          x = event.x;
          y = event.y;
          z = event.z;
        });

        // Display the accelerometer data after an interval of 5 seconds
        Timer(const Duration(seconds: 20), _displayAccelerometerData);
      });
    } else {
      _streamSubscription?.cancel();
      _streamSubscription = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accelerometer Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Accelerometer Data'),
            Text('X: $x'),
            Text('Y: $y'),
            Text('Z: $z'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isStarted = true;
                    });

                    // Start listening for accelerometer data
                    _listenToAccelerometer();
                  },
                  child: Text('Start'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isStarted = false;
                    });

                    // Stop listening for accelerometer data
                    _listenToAccelerometer();
                  },
                  child: Text('Stop'),
                ),
                ElevatedButton(
                  onPressed:DatabaseHelper.clearDatabase,
                  child: Text('Clear Database'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
