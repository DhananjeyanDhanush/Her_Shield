import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:location/location.dart';

class EmergencySOSPage extends StatefulWidget {
  final List<Map<String, String>> registeredContacts;

  EmergencySOSPage({required this.registeredContacts});

  @override
  _EmergencySOSPageState createState() => _EmergencySOSPageState();
}

class _EmergencySOSPageState extends State<EmergencySOSPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Location location = Location();
  List<String> selectedContacts = [];

  void _sendSOSMessage() async {
    if (selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one contact."))
      );
      return;
    }

    LocationData? userLocation = await location.getLocation();
    String message = "🚨 EMERGENCY! I need help. My location: https://maps.google.com/?q=${userLocation.latitude},${userLocation.longitude}";
    
    for (String contact in selectedContacts) {
      final Uri smsUri = Uri.parse("sms:$contact?body=${Uri.encodeComponent(message)}");
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send SMS")),
        );
      }
    }
  }

  void _playAlarm() async {
    await _audioPlayer.play(AssetSource('sound/alarm.mp3'));
    Vibration.vibrate(duration: 2000);
  }

  void _callEmergency() async {
    final Uri phoneUri = Uri(scheme: "tel", path: "100"); // Replace with local emergency number
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cannot make a call"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency SOS"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.registeredContacts.length,
              itemBuilder: (context, index) {
                String contactName = widget.registeredContacts[index]["name"] ?? "Unknown";
                String contactNumber = widget.registeredContacts[index]["phone"] ?? "";
                return CheckboxListTile(
                  title: Text(contactName),
                  subtitle: Text(contactNumber),
                  value: selectedContacts.contains(contactNumber),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedContacts.add(contactNumber);
                      } else {
                        selectedContacts.remove(contactNumber);
                      }
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    _sendSOSMessage();
                    _playAlarm();
                  },
                  child: Text("SEND SOS ALERT", style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: _callEmergency,
                  icon: Icon(Icons.phone, color: Colors.white),
                  label: Text("CALL EMERGENCY", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
