import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trashpick/Models/user_model.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import 'package:trashpick/Widgets/button_widgets.dart';
import 'package:trashpick/Widgets/image_frames_widgets.dart';
import 'package:trashpick/Widgets/secondary_app_bar_widget.dart';
import 'package:trashpick/Widgets/toast_messages.dart';

class ProfileInfoPage extends StatefulWidget {
  @override
  _ProfileInfoPageState createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  var currentUserID = FirebaseAuth.instance.currentUser.uid;
  String firebaseStorageUploadedImageURL;
  String _userLatestProfileImage;
  File _userSelectedFileImage;

  // -------------------------------- UPLOADING PROCESS -------------------------------- \\

  void sendErrorCode(String error) {
    ToastMessages().toastError(error, context);
  }

  void sendSuccessCode() {
    print("Profile Update Success!");
    ToastMessages().toastSuccess("Profile updated successfully!", context);
  }

  void validateEdits() {
    if (_userSelectedFileImage == null) {
      ToastMessages().toastError("Please select an image", context);
    } else {
      uploadImagesToStorage();
    }
  }

  // -------------------------------- CHANGE IMAGE -------------------------------- \\

  Future<void> _imgFromCamera() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _userSelectedFileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _imgFromGallery() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _userSelectedFileImage = File(pickedFile.path);
      });
    }
  }

  void changeProfilePicture(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.lightBlueAccent.withOpacity(0.9),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Photo Library'),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> uploadImagesToStorage() async {
    if (_userSelectedFileImage != null) {
      try {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('User Profile Images/${currentUserID}/$currentUserID');
        await ref.putFile(_userSelectedFileImage);

        String downloadURL = await ref.getDownloadURL();
        firebaseStorageUploadedImageURL = downloadURL;
        saveEditProfileToFireStore(firebaseStorageUploadedImageURL);
      } catch (e) {
        sendErrorCode(e.toString());
      }
    } else {
      saveEditProfileToFireStore(_userLatestProfileImage);
    }
  }

  saveEditProfileToFireStore(String firebaseStorageUploadedImageURL) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserID)
        .update({
          'profileImage': firebaseStorageUploadedImageURL,
        })
        .then((value) => sendSuccessCode())
        .catchError((error) => sendErrorCode(error.toString()));
  }

  // -------------------------------- PROFILE DETAILS -------------------------------- \\

  Widget _profileDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .where('uuid', isEqualTo: currentUserID)
            .snapshots(),
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            UserModelClass userModelClass =
                UserModelClass.fromDocument(dataSnapshot.data.docs[0]);
            _userLatestProfileImage = userModelClass.profileImage;

            return ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(height: 10.0),
                Center(
                  child: _userSelectedFileImage != null
                      ? ImageFramesWidgets().userProfileFrame(
                          _userSelectedFileImage, 150.0, 150.0, false)
                      : ImageFramesWidgets().userProfileFrame(
                          _userLatestProfileImage, 150.0, 150.0, true),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: TextWithIconButtonWidget(
                    text: "Click to Change Image",
                    icon: Icons.camera_alt_rounded,
                    iconToLeft: true,
                    onClicked: () {
                      changeProfilePicture(context);
                    },
                  ),
                ),
                Divider(color: Colors.grey[400]),
                SizedBox(height: 10.0),
                _buildProfileDetail("Name", userModelClass.name),
                _buildProfileDetail("Account Type", userModelClass.accountType),
                _buildProfileDetail("Contact Number", userModelClass.contactNumber),
                _buildProfileDetail("Email", userModelClass.email),
                SizedBox(height: 20.0),
                MinButtonWidget(
                  text: "Update Profile",
                  color: AppThemeData().secondaryColor,
                  onClicked: () {
                    validateEdits();
                  },
                ),
                SizedBox(height: 20.0),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileDetail(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue[800],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            detail,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------- BUILD -------------------------------- \\

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        title: "Profile Info",
        appBar: AppBar(),
        widgets: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Icon(
              Icons.person_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 35.0,
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.lightBlue[50], // Light aqua background
        child: _profileDetails(),
      ),
    );
  }
}