import 'package:flutter/material.dart';
import '../../Pages/BottomNavBar/bottom_nav_bar.dart';
import '../../Theme/theme_provider.dart';
import '../../Widgets/button_widgets.dart';

class WelcomeGuidePage extends StatefulWidget {
  final String userName, accountTypeName;

  WelcomeGuidePage(this.userName, this.accountTypeName);

  @override
  _WelcomeGuidePageState createState() => _WelcomeGuidePageState();
}

class _WelcomeGuidePageState extends State<WelcomeGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeData().whiteColor,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(16.0), // More padding for better spacing
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hi, ${widget.userName}!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: Theme.of(context).textTheme.headline5.fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
                SizedBox(height: 30.0), // Adjusted spacing
                ClipOval(
                  child: Image.asset(
                    'assets/logos/trashpick_logo_banner.png',
                    height: 150.0, // Slightly smaller logo
                    width: 150.0, // Slightly smaller logo
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Welcome to TrashPick",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20.0, // Increased font size for visibility
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                ),
                SizedBox(height: 60.0), // Adjusted spacing
                ButtonWidget(
                  color: Colors.lightBlueAccent, // Light aqua color
                  textColor: Colors.white,
                  text: "Continue to Home",
                  onClicked: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            BottomNavBar(widget.accountTypeName),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
