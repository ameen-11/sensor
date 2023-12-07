import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
// import 'package:dio/dio.dart';
// import 'package:googleapis_auth/googleapis_auth.dart' as auth;
// import 'package:google_sign_in/google_sign_in.dart';


class AccelerometerData {
  double x;
  double y;
  double z;
  DateTime timestamp;

  AccelerometerData(this.x, this.y, this.z, this.timestamp);

  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      'z': z,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static AccelerometerData fromMap(Map<String, dynamic> map) {
    return AccelerometerData(
      map['x'] as double,
      map['y'] as double,
      map['z'] as double,
      DateTime.parse(map['timestamp']),
    );
  }
}

class DatabaseHelper {
  late Database? _database;

  Future<Database> initDatabase() async {
    String path = await getDatabasesPath() + '/accelerometer_data.db';

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE accelerometer_data(
            id INTEGER PRIMARY KEY,
            x REAL,
            y REAL,
            z REAL,
            timestamp DATETIME NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  Future<int> insertAccelerometerData(AccelerometerData accelerometerDatum) async {
    Database db = await initDatabase();
    return await db.insert(
      'accelerometer_data',
      accelerometerDatum.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AccelerometerData>?> getAccelerometerData() async {
    Database db = await initDatabase();
    List<Map<String, dynamic>> maps = await db.query('accelerometer_data');
    return maps.map((map) => AccelerometerData.fromMap(map)).toList();
  }

 Future<void> exportAccelerometerDataToGoogleSheet() async {
  // Fetch the accelerometer data from the database.
  List<AccelerometerData>? accelerometerData = await getAccelerometerData();

  // Prepare the data in a format suitable for sending to the Apps Script.
  List<Map<String, dynamic>> data = accelerometerData!.map((accelerometerDatum) {
    return {
      'x': accelerometerDatum.x,
      'y': accelerometerDatum.y,
      'z': accelerometerDatum.z,
      'timestamp': accelerometerDatum.timestamp.toIso8601String(),
    };
  }).toList();

  // Apps Script URL where the data will be sent.
  const String url = 'https://script.google.com/macros/s/AKfycbztM3bmAnzs_R4GJt2yX2Cu6y5Ak-xzKgGwSxUr7RLbiWMV6Nrw66heEwJ-0zxKznYC/exec';

  try {
    // Send the prepared data to the Apps Script using an HTTP POST request.
    await http.post(
      Uri.parse(url + '?data=' + jsonEncode(data)),
    ).then((response) async {
      if (response.statusCode == 200) {
        print('Data sent to Google Sheet successfully.');
      } else {
        print('Error sending data to Google Sheet: ${response.statusCode}');
      }
    });
  } catch (error) {
    print('Error sending data to Google Sheet: $error');
  }
}


  void dispose() {
    _database?.close();
  }

  static Future<void> clearDatabase() async {
    // Get the database path.
    String databasePath = await getDatabasesPath() + '/accelerometer_data.db';

    // Delete the database.
    await deleteDatabase(databasePath);
  }
}
