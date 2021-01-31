import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors/sensors.dart';

class SensorPage extends StatefulWidget {
  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  int delayCount = 0;
  double _ax = 0, _ay = 0, _az = 0;
  StreamSubscription<dynamic> _accelerometerSubscription;

  void initState() {
    super.initState();
    // Subscribe for accelerator events
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      // We do not need evey event
      if (++delayCount < 20) return; delayCount = 0;

      // whenever we get new data, force redraw by calling setState()
      setState(() {
        // Copy values to local state
        _ax = event.x; _ay = event.y; _az = event.z;
      });
    });
  }

  void dispose() {
    super.dispose();
    _accelerometerSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child: Center(child: directionIcon(2.5))),
            Text('Accel: x: ${_d2s(_ax)}, y: ${_d2s(_ay)}, z: ${_d2s(_az)}', textScaleFactor: 1.5,),
          ],
        ),
    ));
  }

  Widget directionIcon(double threshold) {
    if (_ay < -threshold) return Icon(Icons.arrow_upward);
    if (_ay >  threshold) return Icon(Icons.arrow_downward);
    if (_ax < -threshold) return Icon(Icons.arrow_left_sharp);
    if (_ax >  threshold) return Icon(Icons.arrow_right_alt);
    return Icon(Icons.account_circle_outlined);
  }

  String _d2s(double d) => d.toStringAsFixed(2);
}