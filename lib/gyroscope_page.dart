import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

class GyroscopePage extends StatefulWidget {
  @override
  _GyroscopePageState createState() => _GyroscopePageState();
}

class _GyroscopePageState extends State<GyroscopePage> {
  // Variables to hold gyroscope data
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  // Function to listen for gyroscope data
  void _listenToGyroscope() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
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
    _listenToGyroscope();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gyroscope Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('AVx: $x'),
            Text('AVy: $y'),
            Text('AVz: $z'),
          ],
        ),
      ),
    );
  }
}
