import 'package:flutter/material.dart';
import 'package:trashpick/Pages/OnAppStart/sign_in_page.dart';
import 'package:trashpick/Pages/OnAppStart/sign_up_page.dart';
import '../../Theme/theme_provider.dart';
import '../../Widgets/button_widgets.dart';
import 'user_guide.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeData().lightAqua, // Changed to light aqua
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Increased padding
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Image.asset(
                    'assets/logos/trashpick_logo_banner_2.png',
                    height: 200,
                    width: 200,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Welcome to TrashPick!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppThemeData().darkAqua, // Changed text color
                    ),
                  ),
                  SizedBox(height: 20),
                  ButtonWithImageWidget(
                    onClicked: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                        (Route<dynamic> route) => false,
                      );
                      print("Switch to Login");
                    },
                    text: "Login to TrashPick",
                    textColor: Colors.white,
                    image: 'assets/icons/icon_email.png',
                    color: AppThemeData().darkAqua, // Changed button color
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create an account",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600, // Slightly lighter
                          color: AppThemeData().darkAqua, // Changed text color
                        ),
                      ),
                      SizedBox(width: 10),
                      RadiusFlatButtonWidget(
                        text: "Sign Up",
                        onClicked: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserGuidePage()),
                            (Route<dynamic> route) => false,
                          );
                          print("Switch to Sign Up");
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 40), // Extra space at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
