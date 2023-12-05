import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';

void main() {
  runApp(const MyApp());
}

class SensorDataPage extends StatefulWidget {
  @override
  _SensorDataPageState createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  double azimuth = 0.0;
  double pitch = 0.0;
  double roll = 0.0;
  double hacc = 0.0;

  bool isProcessing = false;

  void _updateSensorData(AccelerometerEvent accelerometerEvent, MagnetometerEvent magnetometerEvent) {
    if (isProcessing) return;

    isProcessing = true;

    double ax = accelerometerEvent.x;
    double ay = accelerometerEvent.y;
    double az = accelerometerEvent.z;

    double mx = magnetometerEvent.x;
    double my = magnetometerEvent.y;
    double mz = magnetometerEvent.z;

    double normA = sqrt(ax * ax + ay * ay + az * az);
    ax /= normA;
    ay /= normA;
    az /= normA;

    double normM = sqrt(mx * mx + my * my + mz * mz);
    mx /= normM;
    my /= normM;
    mz /= normM;

    double ex = my * az - mz * ay;
    double ey = mz * ax - mx * az;
    double ez = mx * ay - my * ax;
    double normE = sqrt(ex * ex + ey * ey + ez * ez);
    ex /= normE;
    ey /= normE;
    ez /= normE;

    double hx = my * ez - mz * ey;
    double hy = mz * ex - mx * ez;
    double hz = mx * ey - my * ex;

    double bx = sqrt((mx * mx) + (my * my));
    double bz = mz;

    double dotProduct = (ax * ex) + (ay * ey) + (az * ez);
    double heading = atan2(hy, hx);
    double attitude = atan2(az, dotProduct);
    double bank = atan2(ex * az - ey * ay, ey * ax - ex * ay);
    double hacc = sqrt(ax * ax + ay * ay);


    azimuth = degrees(heading);
    pitch = degrees(attitude);
    roll = degrees(bank);
    //  dbHelper.insertSensorData(azimuth, pitch, roll, hacc);
  //   DatabaseHelper dbHelper = DatabaseHelper();
  // late Timer dataInsertionTimer;

  // void startDataInsertion() {
  //   const Duration insertionInterval = Duration(seconds: 5);

  //   dataInsertionTimer = Timer.periodic(insertionInterval, (timer) {
  //     dbHelper.insertSensorData(azimuth, pitch, roll, hacc);
  //   });
  // }

  // void stopDataInsertion() {
  //   dataInsertionTimer.cancel();
  // }
  

  // @override
  // void initState() {
  //   super.initState();

  //   startDataInsertion();

  //   accelerometerEvents.listen((AccelerometerEvent event) {
  //     magnetometerEvents.first.then((MagnetometerEvent magEvent) {
  //       _updateSensorData(event, magEvent);
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   stopDataInsertion();
  //   super.dispose();
  // }
    setState(() {
      isProcessing = false;
    });
  }

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      magnetometerEvents.first.then((MagnetometerEvent magEvent) {
        _updateSensorData(event, magEvent);
      });
    });
  }
  
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Azimuth: $azimuth'),
            Text('Pitch: $pitch'),
            Text('Roll: $roll'),
            Text('Horizontal Acceleration: $hacc m/s²')
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Data App',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF2196F3, <int, Color>{
          50: Color(0xFFE3F2FD),
          100: Color(0xFFBBDEFB),
          200: Color(0xFF90CAF9),
          300: Color(0xFF64B5F6),
          400: Color(0xFF42A5F5),
          500: Color(0xFF2196F3),
          600: Color(0xFF1E88E5),
          700: Color(0xFF1976D2),
          800: Color(0xFF1565C0),
          900: Color(0xFF0D47A1),
        }),
      ),
      home: SensorDataPage(),
    );
  }
}
