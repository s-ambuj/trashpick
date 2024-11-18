import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Pages/OnAppStart/welcome_page.dart';
import '../../Theme/theme_provider.dart';
import '../../Widgets/button_widgets.dart';

class CheckAppPermissions extends StatefulWidget {
  @override
  _CheckAppPermissionsState createState() => _CheckAppPermissionsState();
}

class _CheckAppPermissionsState extends State<CheckAppPermissions> {
  bool locationPermission = false;
  bool cameraPermission = false;
  bool storagePermission = false;

  _requestLocationPermission() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      print('TURN ON LOCATION SERVICE BEFORE REQUESTING PERMISSION.');
      return;
    }

    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      setState(() {
        locationPermission = true;
      });
    } else if (status == PermissionStatus.denied) {
      displayPermissionAlert(context, "Location");
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
  }

  _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      setState(() {
        cameraPermission = true;
      });
    } else if (status == PermissionStatus.denied) {
      displayPermissionAlert(context, "Camera");
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
  }

  _requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      setState(() {
        storagePermission = true;
      });
    } else if (status == PermissionStatus.denied) {
      displayPermissionAlert(context, "Storage");
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
  }

  displayPermissionAlert(BuildContext context, String permissionName) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
        displayPermissionRequest(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Give Permission"),
      onPressed: () {
        if (permissionName == "Location") {
          _requestLocationPermission();
        } else if (permissionName == "Camera") {
          _requestCameraPermission();
        } else if (permissionName == "Storage") {
          _requestStoragePermission();
        }

        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("$permissionName Permission Required"),
      content: Text("You must grant the $permissionName to continue."),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: alert);
      },
    );
  }

  displayPermissionRequest(BuildContext context) {
    Widget denyButton = TextButton(
      child: Text("Quit From App"),
      onPressed: () {
        SystemNavigator.pop();
      },
    );
    Widget allowButton = TextButton(
      child: Text("Allow Permission"),
      onPressed: () {
        Navigator.pop(context);
        _requestLocationPermission();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Permission Required"),
      content: Text(
          "We request access to your location, camera, and storage space. "
          "The app will capture your location to give you access to the map. "
          "The camera will be used to capture photographs for postings and events. "
          "Storage access is needed for photos in your picker."),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      actions: [
        denyButton,
        allowButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: alert);
      },
    );
  }

  @override
  void initState() {
    super.initState();
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
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                actions: [
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () => Navigator.pop(c, true),
                  ),
                  TextButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              )),
      child: Scaffold(
        backgroundColor: Color(0xFFE0F7FA), // Light aqua background
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/logos/trashpick_logo_banner.png',
                    height: 150,
                    width: 150,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Permissions Required',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPermissionColumn(
                          'assets/images/location.png',
                          'Location',
                          locationPermission,
                          _requestLocationPermission),
                      _buildPermissionColumn('assets/images/camera.png',
                          'Camera', cameraPermission, _requestCameraPermission),
                      _buildPermissionColumn(
                          'assets/images/storage.png',
                          'Storage',
                          storagePermission,
                          _requestStoragePermission),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "We request access to your location, camera, and storage space. "
                      "The app will capture your location to give you access to the map. "
                      "The camera will be used to capture photographs for postings and events. "
                      "Storage access is needed for photos in your picker.",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  (locationPermission && cameraPermission && storagePermission)
                      ? ButtonWidget(
                          color: AppThemeData().secondaryColor,
                          onClicked: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    WelcomePage(),
                              ),
                              (route) => false,
                            );
                          },
                          text: "Continue to App",
                          textColor: AppThemeData().whiteColor,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionColumn(String iconPath, String permissionName,
      bool isGranted, VoidCallback onPressed) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          scale: 3.0,
        ),
        SizedBox(height: 10.0),
        Text(
          permissionName,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: isGranted ? Colors.green : Colors.red),
        ),
        SizedBox(height: 10.0),
        TextButton(
          child: Text(
            isGranted ? 'Permission Granted' : 'Click to Allow',
            style: TextStyle(
                color: AppThemeData().secondaryColor,
                fontWeight: FontWeight.bold),
          ),
          onPressed: isGranted ? null : onPressed,
        ),
      ],
    );
  }
}
