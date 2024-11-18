import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Pages/OnAppStart/welcome_page.dart';
import 'package:trashpick/Widgets/toast_messages.dart';

class SignOutAlertDialog {
  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Sign Out',
            style: TextStyle(
                color: Colors.lightBlueAccent.shade700), // Light aqua title
          ),
          content: Text(
            "Are you sure you want to sign out?",
            style:
                TextStyle(color: Colors.grey.shade800), // Subtle content color
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "NO",
                style: TextStyle(
                  color: Colors.cyan.shade700, // Aqua color for "NO" button
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                print("Cancel Sign Out");
              },
            ),
            TextButton(
              child: Text(
                "YES",
                style: TextStyle(
                  color: Colors.cyan.shade700, // Aqua color for "YES" button
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                ToastMessages().toastSuccess("Sign Out Success", context);
                print("Sign Out Success");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => WelcomePage(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(15.0)), // Softer rounded corners
          ),
          backgroundColor:
              Colors.lightBlueAccent.shade100, // Light aqua background
        );
      },
    );
  }
}
