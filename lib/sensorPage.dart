import 'dart:math';

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
            sensorView(_ax, _ay, _az),
            Text('Accel: x: ${_d2s(_ax)}, y: ${_d2s(_ay)}, z: ${_d2s(_az)}', textScaleFactor: 1.5,),
          ],
        ),
    ));
  }

  String _d2s(double d) => d.toStringAsFixed(2);

  Widget sensorView(double ax, double ay, double az) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            // A CustomPaint is widget which needs a paint strategy (a Painter)
            child:CustomPaint(
              size: Size.infinite,
              painter: SpiritLevelPainter(ax, ay),
            )
        )
    );
  }
}

/// SpiritLevelPainter serves as a Painter strategy for a CustomPaint widget
///
/// We have to override paint(..) as well as shouldRepaint(..)
class SpiritLevelPainter extends CustomPainter {
  double ax, ay;
  SpiritLevelPainter(this.ax, this.ay);

  @override
  void paint(Canvas canvas, Size size) {
    final bubbleRadius = 10.0;
    // Calculate the parameters from the actual size
    var radius = size.shortestSide/2-bubbleRadius;
    var center = Offset(size.width/2, size.height/2);

    // draw circumference of the spirit level
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius+bubbleRadius, paint);
    canvas.drawCircle(center, bubbleRadius+3.0, paint);

    // Get normalized sensor data
    var normalizedData = _normalizeData(scaleBy: 5.0);

    // Draw the bubble
    paint
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    var bubbleCenter = Offset(radius * normalizedData[0], radius * normalizedData[1]);
    bubbleCenter = bubbleCenter.translate(center.dx, center.dy);
    canvas.drawCircle(bubbleCenter, bubbleRadius, paint);
    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(bubbleCenter, bubbleRadius, paint);
  }

  /// The normalized data is in the range [-1..1]
  /// and not outside the unit circle
  List<double> _normalizeData({double scaleBy = 1.0}) {
    double x,y;
    // Compensate for gravitation
    x = (ax/9.8);
    y = (-ay/9.8);

    // scale values
    x *= scaleBy;
    y *= scaleBy;

    // Normalize to [-1..1]
    if (x > 1) x = 1; if (x < -1) x = -1;
    if (y > 1) y = 1; if (y < -1) y = -1;

    // Ensure circle restrictions
    var len = sqrt(x*x + y*y);
    if (len > 1.0) {
      x /= len;
      y /= len;
    }
    return [x, y];
  }

  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}