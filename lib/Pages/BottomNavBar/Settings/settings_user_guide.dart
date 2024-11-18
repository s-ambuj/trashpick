import 'package:flutter/material.dart';
import 'package:trashpick/Pages/OnAppStart/welcome_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsUserGuide extends StatefulWidget {
  @override
  _SettingsUserGuideState createState() => _SettingsUserGuideState();
}

class _SettingsUserGuideState extends State<SettingsUserGuide> {
  final _key = UniqueKey();
  bool isLoading = true;
  String siteLink =
      "https://sites.google.com/view/trashpick--app-user-guide/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB2EBF2), // Light aqua color
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "User Guide",
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.black),
        ),
        elevation: 2.0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              key: _key,
              initialUrl: siteLink,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF00796B)), // Darker aqua
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFB2EBF2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "For more help, contact support@example.com",
            style: TextStyle(color: Colors.black, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
