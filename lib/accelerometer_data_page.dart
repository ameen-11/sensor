import 'package:flutter/material.dart';
import 'package:sensor_data/database_helper.dart';

class AccelerometerDataPage extends StatefulWidget {
  @override
  _AccelerometerDataPageState createState() => _AccelerometerDataPageState();
}

class _AccelerometerDataPageState extends State<AccelerometerDataPage> {
  DatabaseHelper? _databaseHelper;
  List<AccelerometerData> _accelerometerData = [];

  @override
  void initState() {
    super.initState();

    _databaseHelper = DatabaseHelper();
    _queryDatabase();
  }

  void _queryDatabase() async {
    final accelerometerDataFromDatabase = await _databaseHelper?.getAccelerometerData();
    if (accelerometerDataFromDatabase != null) {
      setState(() {
        // Order the accelerometer data by timestamp, in descending order.
        _accelerometerData = accelerometerDataFromDatabase..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accelerometer Data'),
      ),
      body: Table(
        border: TableBorder.all(),
        children: [
          TableRow(
            children: [
              TableCell(child: Text('Timestamp')),
              TableCell(child: Text('X')),
              TableCell(child: Text('Y')),
              TableCell(child: Text('Z')),
            ],
          ),
          for (AccelerometerData accelerometerDatum in _accelerometerData)
            TableRow(
              children: [
                TableCell(child: Text(accelerometerDatum.timestamp.toString())),
                TableCell(child: Text(accelerometerDatum.x.toString())),
                TableCell(child: Text(accelerometerDatum.y.toString())),
                TableCell(child: Text(accelerometerDatum.z.toString())),
              ],
            ),
        ],
      ),
    );
  }
}

