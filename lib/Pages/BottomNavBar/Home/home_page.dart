import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Models/user_model.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import '../../../Widgets/primary_app_bar_widget.dart';

class HomePage extends StatefulWidget {
  final String accountType;

  HomePage(this.accountType);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userReference = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  _statTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white),
    );
  }

  _statDetail(double numberValue, bool isDouble) {
    String detailString =
        isDouble ? numberValue.toString() : numberValue.toInt().toString();

    return Text(
      detailString,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white),
    );
  }

  welcomeHeader() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .where('uuid', isEqualTo: "${auth.currentUser.uid}")
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return Text(
            "Hi! ",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline6.fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          );
        } else {
          UserModelClass userModelClass =
              UserModelClass.fromDocument(dataSnapshot.data.docs[0]);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi! ${userModelClass.name}",
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline6.fontSize,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ],
          );
        }
      },
    );
  }

  _profileStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statTitle("Total Trash Pick Ups"),
                SizedBox(height: 10.0),
                _statTitle("Total Points"),
              ],
            ),
            SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statDetail(4, false),
                SizedBox(height: 10.0),
                _statDetail(52, false),
              ],
            )
          ],
        ),
      ],
    );
  }

  _subscriptionOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statTitle("Subscription Options"),
        SizedBox(height: 20.0),
        _subscriptionCard("Basic Plan", "Requires: 10000 Points",
            "Basic features of trash picking", () {
          // Handle subscription logic
        }),
        SizedBox(height: 20.0),
        _subscriptionCard("Pro Plan", "Requires: 15000 Points",
            "Advanced features and priority support", () {
          // Handle subscription logic
        }),
        SizedBox(height: 20.0),
        _subscriptionCard("Premium Plan", "Requires: 20000 Points",
            "All features with exclusive rewards", () {
          // Handle subscription logic
        }),
      ],
    );
  }

  _subscriptionCard(String title, String pointsRequirement, String features,
      Function onSubscribe) {
    return Card(
      color: Colors.lightBlue[300], // Aqua color for the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4.0,
      child: Container(
        width: double.infinity, // Set to fill available width
        height: 150, // Fixed height for uniformity
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10.0),
            Text(
              pointsRequirement,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
            SizedBox(height: 10.0),
            Text(
              features,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "TrashPick",
        appBar: AppBar(),
        widgets: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Icon(
              Icons.home_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 35.0,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue[100],
                Colors.lightBlue[300]
              ], // Light aqua gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logos/trashpick_logo_curved.png',
                  height: 75.0,
                  width: 75.0,
                ),
                SizedBox(height: 10.0),
                welcomeHeader(),
                Center(
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headline5.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(height: 20.0),
                _profileStats(),
                SizedBox(height: 30.0),
                _subscriptionOptions(), // Adding the subscription options here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
