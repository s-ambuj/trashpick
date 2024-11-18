import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Pages/BottomNavBar/PickMyTrash/new_trash_pick_up.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import 'package:trashpick/Widgets/button_widgets.dart';
import '../../../Widgets/primary_app_bar_widget.dart';
import '../../../Models/trash_pick_ups_model.dart';
import 'view_trash_details.dart';

class PickMyTrash extends StatefulWidget {
  final String accountType;

  PickMyTrash(this.accountType);

  @override
  _PickMyTrashState createState() => _PickMyTrashState();
}

class _PickMyTrashState extends State<PickMyTrash> {
  final String userProfileID = FirebaseAuth.instance.currentUser.uid.toString();
  final firestoreInstance = FirebaseFirestore.instance;

  Widget trashDetailsCard(AsyncSnapshot<QuerySnapshot> snapshot,
      TrashPickUpsModel trashPickUpsModel) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0), // Spacing between cards
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.lightBlue[300], // Light aqua color for the card
        elevation: 4.0,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewTrashDetails(userProfileID,
                      trashPickUpsModel.trashID, widget.accountType)),
            );
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  trashPickUpsModel.trashImage,
                  fit: BoxFit.cover,
                  height: 120,
                  width: 120,
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        trashPickUpsModel.trashName,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline6.fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text for contrast
                        ),
                      ),
                      Divider(color: Colors.white70),
                      Text(
                        trashPickUpsModel.trashDescription,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white70, // Slightly transparent text
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _scheduledTrashPicksList() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6, // Adjusted height
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(userProfileID)
            .collection('Trash Pick Ups')
            .orderBy('postedDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30.0),
                  Text(
                    "You have no scheduled trash pick ups yet",
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headline6.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87), // Dark text for visibility
                  ),
                  SizedBox(height: 20.0),
                  Image.asset(
                    'assets/icons/icon_broom.png',
                    height: 100.0,
                    width: 100.0,
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                TrashPickUpsModel trashPickUpsModel =
                    TrashPickUpsModel.fromDocument(snapshot.data.docs[index]);
                return trashDetailsCard(snapshot, trashPickUpsModel);
              },
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Collect My Trash",
        appBar: AppBar(),
        widgets: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Icon(
              Icons.recycling_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 35.0,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue[100],
                Colors.lightBlue[300],
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 8.0),
            child: Column(
              children: [
                SizedBox(height: 90.0),
                Text(
                  "My Scheduled Trash Pick Ups",
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline6.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white), // White text for visibility
                ),
                SizedBox(height: 20.0),
                _scheduledTrashPicksList(),
                SizedBox(height: 20.0),
                MinButtonWidget(
                  text: "Schedule a Trash Pick Up",
                  color: Color.fromARGB(
                      255, 49, 177, 224), // White button for visibility
                  onClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewTrashPickUp(widget.accountType)),
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
