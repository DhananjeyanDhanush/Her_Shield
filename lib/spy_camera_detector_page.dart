import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SpyCameraDetectorPage extends StatefulWidget {
  @override
  _SpyCameraDetectorPageState createState() => _SpyCameraDetectorPageState();
}

class _SpyCameraDetectorPageState extends State<SpyCameraDetectorPage> {
  double _magneticField = 0.0;
  static const double threshold = 50.0; // Detection threshold
  bool hasMagnetometer = true; // Assume true, check later

  @override
  void initState() {
    super.initState();
    _checkSensorAvailability();
  }

  void _checkSensorAvailability() async {
    try {
      magnetometerEvents.listen((event) {
        setState(() {
          _magneticField = event.x.abs() + event.y.abs() + event.z.abs();
          hasMagnetometer = true; // If data comes, sensor exists
        });
      });
    } catch (e) {
      setState(() {
        hasMagnetometer = false; // No sensor detected
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!hasMagnetometer) {
      return Scaffold(
        appBar: AppBar(title: Text("Spy Camera Detector")),
        body: Center(
          child: Text(
            "Your device does not have a magnetometer sensor.\nThis feature won't work.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Spy Camera Detector"), backgroundColor: Colors.purple),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _magneticField > threshold ? Icons.warning : Icons.check_circle,
              color: _magneticField > threshold ? Colors.red : Colors.green,
              size: 80,
            ),
            SizedBox(height: 20),
            Text(
              _magneticField > threshold ? "Potential Spy Camera Detected!" : "No Spy Camera Found",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("Magnetic Field Strength: ${_magneticField.toStringAsFixed(2)} µT"),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Move your phone near suspicious objects (mirrors, electronic devices, etc.) to detect hidden cameras.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
