import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VoiceActivationPage extends StatefulWidget {
  @override
  _VoiceActivationPageState createState() => _VoiceActivationPageState();
}

class _VoiceActivationPageState extends State<VoiceActivationPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isVoiceActivationEnabled = false;
  String _detectedWord = "";
  final AudioPlayer _audioPlayer = AudioPlayer();
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _toggleVoiceActivation(bool value) {
    setState(() {
      _isVoiceActivationEnabled = value;
    });
    if (value) {
      _startListening();
    } else {
      _stopListening();
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _detectedWord = result.recognizedWords.toLowerCase();
        });
        if (_detectedWord.contains("help") || _detectedWord.contains("scream")) {
          _triggerSOS();
        }
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _triggerSOS() async {
    _playAlarm();
    Vibration.vibrate(duration: 2000);
    LocationData? userLocation = await location.getLocation();
    String message = "🚨 EMERGENCY! I need help. My location: https://maps.google.com/?q=${userLocation.latitude},${userLocation.longitude}";
    _sendSMSToContacts(message);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SOS Triggered!")));
  }

  void _playAlarm() async {
    await _audioPlayer.play(AssetSource('sound/alarm.mp3'));
  }

  void _sendSMSToContacts(String message) async {
    final contactsSnapshot = await FirebaseFirestore.instance.collection('contacts').get();
    for (var contact in contactsSnapshot.docs) {
      String phone = contact['phone'];
      final Uri smsUri = Uri.parse("sms:$phone?body=$message");
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice Activation"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isListening ? Icons.mic : Icons.mic_off,
              color: _isListening ? Colors.red : Colors.grey,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              _isListening ? "Listening for 'help' or 'scream'..." : "Tap to Start Listening",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text("Enable Voice Activation"),
              value: _isVoiceActivationEnabled,
              onChanged: _toggleVoiceActivation,
            ),
          ],
        ),
      ),
    );
  }
}
