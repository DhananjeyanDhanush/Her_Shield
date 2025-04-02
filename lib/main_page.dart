import 'package:flutter/material.dart';
import 'profile_page.dart'; // Make sure this import is correct
import 'emergency_sos_page.dart';
import 'live_location_page.dart';
import 'fake_call_alert_page.dart';
import 'defensive_techniques_page.dart';
import 'voice_activation_page.dart';
import 'registered_contacts_page.dart';
import 'safety_awareness_page.dart';
import 'spy_camera_detector_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Fetches registered contacts from Firestore and navigates to Emergency SOS Page
  void _navigateToEmergencySOS(BuildContext context) async {
    try {
      final contactsSnapshot = await FirebaseFirestore.instance.collection('contacts').get();
      List<Map<String, String>> contacts = contactsSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?; 
        return {
          "name": data?["name"]?.toString() ?? "Unknown",
          "phone": data?["phone"]?.toString() ?? "",
        };
      }).toList();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmergencySOSPage(registeredContacts: contacts)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching contacts: $e")),
      );
    }
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: page,
        ),
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Logo as a button
            IconButton(
              icon: Hero(
                tag: 'appLogo',
                child: Image.asset(
                  'assets/logo.jpg',
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            SizedBox(width: 10),
            Text(
              "Her Shield",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            _buildAnimatedTile(Icons.warning, "Emergency SOS", () => _navigateToEmergencySOS(context)),
            _buildAnimatedTile(Icons.location_on, "Live Location", () => _navigateToPage(context, LiveLocationPage())),
            _buildAnimatedTile(Icons.phone, "Fake Call Alert", () => _navigateToPage(context, FakeCallAlertPage())),
            _buildAnimatedTile(Icons.safety_divider, "Defensive Techniques", () => _navigateToPage(context, DefensiveTechniquesPage())),
            _buildAnimatedTile(Icons.mic, "Voice Activation", () => _navigateToPage(context, VoiceActivationPage())),
            _buildAnimatedTile(Icons.contacts, "Registered Contacts", () => _navigateToPage(context, RegisteredContactsPage())),
            _buildAnimatedTile(Icons.security, "Safety Awareness", () => _navigateToPage(context, SafetyAwarenessPage())),
            _buildAnimatedTile(Icons.visibility, "Spy Camera Detector", () => _navigateToPage(context, SpyCameraDetectorPage())),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()), 
    );
        },
        child: Image.asset(
          'assets/logo.jpg',
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAnimatedTile(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.purple.withValues(alpha: 0.2),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
            ],
          ),
          child: ListTile(
            leading: Icon(icon, color: Colors.purple),
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
