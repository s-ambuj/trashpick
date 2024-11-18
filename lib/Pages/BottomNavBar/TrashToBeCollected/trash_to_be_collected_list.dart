import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Models/trash_pick_ups_model.dart';
import 'package:trashpick/Models/user_model.dart';
import 'package:trashpick/Pages/BottomNavBar/PickMyTrash/pick_my_trash_page.dart';
import 'package:trashpick/Pages/BottomNavBar/PickMyTrash/view_trash_details.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import 'package:trashpick/Widgets/button_widgets.dart';

class TrashToBeCollectedList extends StatefulWidget {
  @override
  _TrashToBeCollectedListState createState() => _TrashToBeCollectedListState();
}

class _TrashToBeCollectedListState extends State<TrashToBeCollectedList> {
  final firestoreInstance = FirebaseFirestore.instance;
  TrashPickUpsModel trashPickUpsModel;
  UserModelClass selectedTrashPickerModel;
  bool viewTrashPicker = false;

  @override
  void initState() {
    super.initState();
  }

  loadingProgress() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors
            .lightBlueAccent), // Light aqua color for the progress indicator
      ),
    );
  }

  Widget trashPickersDetailsCard(
      AsyncSnapshot<QuerySnapshot> snapshot, UserModelClass userModelClass) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white, // White background for cards
        elevation: 3, // Adding slight elevation for depth
        child: InkWell(
          splashColor: Colors.lightBlueAccent.withAlpha(30),
          onTap: () {
            setState(() {
              viewTrashPicker = true;
              selectedTrashPickerModel = userModelClass;
            });
          },
          child: snapshot.data.docs.isEmpty
              ? Container()
              : Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: Image.network(
                          userModelClass.profileImage,
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userModelClass.name,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors
                                  .lightBlueAccent, // Light aqua color for text
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            userModelClass.homeAddress,
                            style: TextStyle(
                              color: AppThemeData.lightTheme.iconTheme.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _trashPickersList() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .where('accountType', isEqualTo: "Trash Picker")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingProgress();
          }
          return !snapshot.hasData
              ? Container()
              : snapshot.data.docs.isEmpty
                  ? Container(
                      height: 250.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Trash Pickers registered yet",
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                          SizedBox(height: 10.0),
                          ClipOval(
                            child: Image.asset(
                              'assets/images/trashpick_user_avatar.png',
                              height: 60.0,
                              width: 60.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        UserModelClass userModelClass =
                            UserModelClass.fromDocument(
                                snapshot.data.docs[index]);
                        return trashPickersDetailsCard(
                            snapshot, userModelClass);
                      },
                    );
        },
      ),
    );
  }

  _selectedTrashPicker() {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                setState(() {
                  viewTrashPicker = false;
                });
              },
            ),
            Text(
              "${selectedTrashPickerModel.name}'s Trash Pick Ups",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        _scheduledTrashPicksList(
            selectedTrashPickerModel.name, selectedTrashPickerModel.uuid),
      ],
    );
  }

  Widget trashDetailsCard(AsyncSnapshot<QuerySnapshot> snapshot,
      TrashPickUpsModel trashPickUpsModel, String userID) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white, // White background for cards
        elevation: 3, // Adding slight elevation for depth
        child: InkWell(
          splashColor: Colors.lightBlueAccent.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewTrashDetails(
                      userID, trashPickUpsModel.trashID, "Trash Collector")),
            );
          },
          child: snapshot.data.docs.isEmpty
              ? Container()
              : Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        trashPickUpsModel.trashImage,
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trashPickUpsModel.trashName,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color:
                                    Colors.lightBlueAccent), // Light aqua color
                          ),
                          Divider(
                              color: AppThemeData.lightTheme.iconTheme.color),
                          Text(
                            trashPickUpsModel.trashDescription,
                            style: TextStyle(
                                color: AppThemeData.lightTheme.iconTheme.color),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _scheduledTrashPicksList(String userName, String userID) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .collection('Trash Pick Ups')
            .orderBy('postedDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Container()
              : snapshot.data.docs.isEmpty
                  ? Container(
                      height: 250.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$userName has no scheduled trash pick ups yet",
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                          SizedBox(height: 10.0),
                          Image.asset(
                            'assets/icons/icon_broom.png',
                            height: 100.0,
                            width: 100.0,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        TrashPickUpsModel trashPickUpsModel =
                            TrashPickUpsModel.fromDocument(
                                snapshot.data.docs[index]);
                        return trashDetailsCard(
                            snapshot, trashPickUpsModel, userID);
                      },
                    );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trash To Be Collected"),
        backgroundColor:
            Colors.lightBlueAccent, // Light aqua color for the AppBar
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: viewTrashPicker
              ? Container(
                  child: _selectedTrashPicker(),
                )
              : Column(
                  children: [
                    SizedBox(height: 10.0),
                    Text(
                      "Trash Pickers",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .lightBlueAccent, // Light aqua color for title
                      ),
                    ),
                    _trashPickersList(),
                  ],
                ),
        ),
      ),
    );
  }
}
