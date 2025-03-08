import 'package:flutter/material.dart';
import 'main_page.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/onboarding1.png",
      "title": "Track Anytime, Anywhere!",
      "description":
          "Share your route with trusted contacts and enable real-time tracking to ensure your safety."
    },
    {
      "image": "assets/onboarding2.png",
      "title": "Inform Emergency Contacts Instantly!",
      "description":
          "With just one press, send an emergency alert to pre-selected contacts with real-time location."
    },
    {
      "image": "assets/onboarding3.png",
      "title": "View Safe Locations While Travelling!",
      "description":
          "Find and navigate to nearby safe zones marked on the map for a secure journey."
    },
  ];

  void _goToMainPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) => OnboardingContent(
                image: onboardingData[index]["image"]!,
                title: onboardingData[index]["title"]!,
                description: onboardingData[index]["description"]!,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _goToMainPage,
                child: Text(
                  "Skip",
                  style: TextStyle(color: Colors.purple, fontSize: 16),
                ),
              ),
              Row(
                children: List.generate(
                  onboardingData.length,
                  (index) => buildDot(index: index),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (currentPage == onboardingData.length - 1) {
                    _goToMainPage();
                  } else {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
                child: Text(
                  currentPage == onboardingData.length - 1 ? "Done" : "Continue",
                  style: TextStyle(color: Colors.purple, fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildDot({required int index}) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      height: 8,
      width: currentPage == index ? 16 : 8,
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String image, title, description;

  const OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Image.asset('assets/logo.jpg', height: 80), // App Logo
              SizedBox(height: 8),
              Text(
                "Her Shield", // App Name
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Image.asset(image, height: 250),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
