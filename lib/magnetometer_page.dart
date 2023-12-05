import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MagnetometerPage extends StatefulWidget {
  @override
  _MagnetometerPageState createState() => _MagnetometerPageState();
}

class _MagnetometerPageState extends State<MagnetometerPage> {
  // Variables to hold magnetometer data
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  // Function to listen for magnetometer data
  // void _listenToMagnetometer() {
  //   magnetometerEvents.listen((List<double> event) {
  //     setState(() {
  //       x = event[0];
  //       y = event[1];
  //       z = event[2];
  //     });
  //   });
    
  // }
 void _listenToMagnetometer() {
  magnetometerEvents.listen((MagnetometerEvent event) {
    setState(() {
      x = event.x;
      y = event.y;
      z = event.z;
    });
  });
}

  @override
  void initState() {
    super.initState();
    _listenToMagnetometer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magnetometer Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Mx: $x'),
            Text('My: $y'),
            Text('Mz: $z'),
          ],
        ),
      ),
    );
  }
}
