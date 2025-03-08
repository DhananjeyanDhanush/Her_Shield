import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DefensiveTechniquesPage extends StatelessWidget {
  final List<Map<String, String>> techniques = [
    {
      "title": "Palm Strike",
      "description": "Use your palm to strike an attacker's nose or chin to disorient them.",
      "videoUrl": "https://youtu.be/Zwr9s1Sb_so?si=8oWTamgO0RqxpzP3"
    },
    {
      "title": "Elbow Strike",
      "description": "If close enough, use your elbow to hit the attacker's face or ribs.",
      "videoUrl": "https://youtu.be/7koJo7M_VDY?si=uOnBD1t3hk9iMcrJ"
    },
    {
      "title": "Knee Strike",
      "description": "Target the attacker's stomach or groin with your knee for a quick escape.",
      "videoUrl": "https://youtu.be/85PColepuNw?si=mC8cFn2GcPu6x05S"
    },
    {
      "title": "Escape from Wrist Grab",
      "description": "Pull your hand towards the attacker's thumb to break free.",
      "videoUrl": "https://youtu.be/rrtvBJNJAcw?si=L2jBsQEHHLOyNXRX"
    },{
    "title": "Hammer Fist Strike",
    "description": "Make a fist and strike with the bottom part, targeting the attacker's jaw or nose.",
    "videoUrl": "https://youtu.be/v1333hAytIY?si=uhlq-didTsoKN7Ao"
  },
  {
    "title": "Bear Hug Escape",
    "description": "If grabbed from behind, drop your weight and hit their feet or groin to escape.",
    "videoUrl": "https://youtu.be/CQTntSAngYw?si=XI2YZ1Xi5aSQRNk8"
  },
  {
    "title": "Eye Gouge",
    "description": "Use your fingers to press into the attacker’s eyes, giving you time to run.",
    "videoUrl": "https://youtu.be/81HLdSJsARw?si=U5sCy-3cjrXcjxju"
  },
  {
    "title": "Chokehold Escape",
    "description": "Turn your chin towards the attacker's elbow and push their arm down to breathe.",
    "videoUrl": "https://youtu.be/-V4vEyhWDZ0?si=mpVn-931Q9kqd-QS"
  },
  {
    "title": "Hair Grab Escape",
    "description": "Hold the attacker's hand to reduce pulling force, then strike their body.",
    "videoUrl": "https://youtu.be/CLcN_esKh20?si=TaVuFVrLilevSmCj"
  },
  {
    "title": "Ground Defense",
    "description": "Use your legs to kick away attackers if you're pushed to the ground.",
    "videoUrl": "https://youtu.be/jAh0cU1J5zk?si=x4zxrosmhC8Qrn4S"
  },
  ];

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Defensive Techniques"),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: techniques.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                techniques[index]["title"]!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(techniques[index]["description"]!),
              trailing: IconButton(
                icon: Icon(Icons.video_library, color: Colors.red),
                onPressed: () => _launchURL(techniques[index]["videoUrl"]!),
              ),
            ),
          );
        },
      ),
    );
  }
}
