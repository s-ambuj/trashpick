import 'package:flutter/material.dart';
import 'package:trashpick/Pages/OnAppStart/sign_in_page.dart';
import 'package:trashpick/Pages/OnAppStart/sign_up_page.dart';
import 'package:trashpick/Pages/OnAppStart/welcome_page.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import 'package:trashpick/Widgets/secondary_app_bar_widget.dart';

class UserGuidePage extends StatefulWidget {
  @override
  _UserGuidePageState createState() => _UserGuidePageState();
}

class _UserGuidePageState extends State<UserGuidePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("test");
        return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,
                color: Theme.of(context).iconTheme.color),
            onPressed: () {
              print("Go to Welcome Page");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => WelcomePage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          title: Text(
            "User Guide",
            style: Theme.of(context).textTheme.headline6,
          ),
          elevation: Theme.of(context).appBarTheme.elevation,
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: TextButton(
                child: Text(
                  "Continue to Sign Up",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                    (Route<dynamic> route) => false,
                  );
                  print("Switch to Sign Up");
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "User Guide Information",
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          color: AppThemeData()
                              .darkAqua, // Using dark aqua for the text color
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "This is where you can find all the information about how to use the app. Please refer to the user guide for detailed instructions.",
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text("Continue to Sign Up"),
                    style: ElevatedButton.styleFrom(
                      primary:
                          AppThemeData().primaryColor, // Set your desired color
                      onPrimary: Colors.white, // Text color
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
