import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Models/user_model.dart';
import 'package:trashpick/Pages/BottomNavBar/PickMyTrash/pick_my_trash_page.dart';
import 'package:trashpick/Pages/BottomNavBar/TrashToBeCollected/trash_to_be_collected_page.dart';
import '../../Theme/theme_provider.dart';
import 'Home/home_page.dart';
import 'BeAware/be_aware.dart';
import 'RecyclingCenters/recycling_centers_page.dart';
import 'Settings/settings_page.dart';

class BottomNavBar extends StatefulWidget {
  final String accountType;

  BottomNavBar(this.accountType);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedPage = 0;
  List<Widget> pageList = [];

  String uuid = FirebaseAuth.instance.currentUser.uid.toString();

  @override
  void initState() {
    checkAccountType();
    super.initState();
  }

  List<BottomNavigationBarItem> appBottomNavBarItems =
      const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home_rounded, size: 30.0),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.recycling_sharp, size: 30.0),
      label: 'Trash to be collected',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications_rounded, size: 30.0),
      label: 'Articles',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.restore_from_trash, size: 30.0),
      label: 'Recycling Centers',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_rounded, size: 30.0),
      label: 'My Profile',
    ),
  ];

  appBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedPage,
      selectedItemColor:
          Colors.lightBlueAccent, // Light aqua color for selected
      unselectedItemColor: AppThemeData().greyColor,
      backgroundColor: Colors.white, // White background for the nav bar
      onTap: _onItemTapped,
      items: appBottomNavBarItems,
      showSelectedLabels: true, // Show labels for better accessibility
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.lightBlueAccent, // Light aqua color for selected labels
      ),
      unselectedLabelStyle: TextStyle(
        color: AppThemeData().greyColor,
      ),
    );
  }

  checkAccountType() async {
    pageList.add(HomePage(widget.accountType));
    print(
        "----------------------- SWITCH TAB FOR ACCOUNT TYPE: ${widget.accountType} -----------------------");
    if (widget.accountType == "Trash Picker") {
      print("Current User Account Type: Trash Picker");
      pageList.add(PickMyTrash(widget.accountType));
    } else {
      print("Current User Account Type: Trash Collector");
      pageList.add(TrashToBeCollected());
    }
    pageList.add(BeAware());
    pageList.add(RecyclingCenters());
    pageList.add(SettingsPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Exit from TrashPick'),
          content: Text('Do you really want to exit?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(12.0)), // Updated border radius
          ),
          actions: [
            TextButton(
              child: Text('Yes', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(c, true),
            ),
            TextButton(
              child: Text('No', style: TextStyle(color: Colors.green)),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: AppThemeData().whiteColor,
        body: IndexedStack(
          index: _selectedPage,
          children: pageList,
        ),
        bottomNavigationBar: appBottomNavBar(),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }
}
