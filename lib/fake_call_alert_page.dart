import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class FakeCallAlertPage extends StatefulWidget {
  @override
  _FakeCallAlertPageState createState() => _FakeCallAlertPageState();
}

class _FakeCallAlertPageState extends State<FakeCallAlertPage> {
  late AudioPlayer _audioPlayer;
  
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playRingtone();
    _startVibration();
  }

  void _playRingtone() async {
    await _audioPlayer.play(AssetSource('ringtone.mp3'));
  }

  void _startVibration() async {
    if (await Vibration.hasVibrator() ) {
      Vibration.vibrate(duration: 5000);
    }
  }

  void _stopCall() {
    _audioPlayer.stop();
    Vibration.cancel();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Incoming Call",
            style: TextStyle(color: Colors.white70, fontSize: 20),
          ),
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/caller_image.jpg'),
          ),
          SizedBox(height: 10),
          Text(
            "Unknown Caller",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "+91 98765 43210",
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: _stopCall,
                child: Icon(Icons.call_end, color: Colors.white),
              ),
              FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: _stopCall,
                child: Icon(Icons.call, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
