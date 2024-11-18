import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashpick/Pages/OnAppStart/sign_in_page.dart';
import 'package:trashpick/Pages/OnAppStart/user_guide.dart';
import 'package:trashpick/Pages/OnAppStart/welcome_guide_page.dart';
import 'package:trashpick/Pages/OnAppStart/welcome_page.dart';
import '../../Widgets/toast_messages.dart';
import '../../Theme/theme_provider.dart';
import '../../Widgets/button_widgets.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({this.app});
  final FirebaseApp app;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  ToastMessages _toastMessages = new ToastMessages();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String defaultUserAvatar =
      "https://firebasestorage.googleapis.com/v0/b/trashpick-db.appspot.com/o/Default%20User%20Avatar%2Ftrashpick_user_avatar.png?alt=media&token=734f7e74-2c98-4c27-b982-3ecd072ced79";

  bool _isHidden = true;
  bool _isHiddenC = true;

  bool isUserCreated = false;
  bool isAnError = false;

  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String formattedTime = DateFormat('kk:mm:a').format(DateTime.now());

  String accountTypeName = "Trash Picker";
  int accountTypeID;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      _isHiddenC = !_isHiddenC;
    });
  }

  bool validateUser() {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (nameController.text.isEmpty) {
      _toastMessages.toastInfo('Name is empty', context);
    } else if (emailController.text.isEmpty) {
      _toastMessages.toastInfo('Email is empty', context);
    } else if (!regExp.hasMatch(emailController.text)) {
      _toastMessages.toastInfo('Email pattern is wrong', context);
    } else if (phoneNumberController.text.isEmpty) {
      _toastMessages.toastInfo('Phone Number is empty', context);
    } else if (passwordController.text.length < 6) {
      _toastMessages.toastInfo(
          'Password Should Be At Least 6 Characters!', context);
    } else if (confirmPasswordController.text != passwordController.text) {
      _toastMessages.toastInfo('Confirm Password is wrong', context);
    } else {
      return true;
    }
    return false;
  }

  void authenticateUser() async {
    if (validateUser()) {
      try {
        await firebaseAuth.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        if (FirebaseAuth.instance.currentUser != null) {
          User user = FirebaseAuth.instance.currentUser;

          if (!user.emailVerified) {
            await user.sendEmailVerification();
          }

          await FirebaseFirestore.instance
              .collection("Users")
              .doc(user.uid)
              .set({
            "uuid": user.uid,
            "accountType": accountTypeName,
            "name": nameController.text,
            "email": emailController.text,
            "contactNumber": phoneNumberController.text,
            'accountCreated': "$formattedDate, $formattedTime",
            'profileImage': defaultUserAvatar,
          });
          // Handle successful user creation
          setState(() {
            isUserCreated = true;
            showAlertDialog(context);
          });
        }
      } catch (e) {
        if (e.code == 'email-already-in-use') {
          _toastMessages.toastError('Email is already in use', context);
        } else {
          _toastMessages.toastError(
              'Error occurred, please try again', context);
        }
      }
    }
  }

  showAlertDialog(BuildContext context) {
    // Implementation of alert dialog logic
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: isUserCreated
              ? Text("Account Created")
              : Text("Creating Account"),
          content: SizedBox(
            height: 100,
            child: Center(
              child: isUserCreated
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Welcome!",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                        Image.asset('assets/images/welcome.png',
                            height: 50, width: 50),
                        SizedBox(height: 20),
                        ButtonWidget(
                          text: "Continue",
                          textColor: AppThemeData().whiteColor,
                          color: AppThemeData().primaryColor,
                          onClicked: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WelcomeGuidePage(
                                        nameController.text, accountTypeName)),
                                ModalRoute.withName("/WelcomeScreen"));
                          },
                        ),
                      ],
                    )
                  : CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  radioButtonList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Select Account Type",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
              value: 1,
              groupValue: accountTypeID,
              onChanged: (val) {
                setState(() {
                  accountTypeName = 'Trash Picker';
                  accountTypeID = 1;
                });
              },
            ),
            Text('Trash Picker'),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UserGuidePage()),
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFE0F7FA), // Light Aqua Background
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserGuidePage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  Center(
                    child: Image.asset(
                      'assets/logos/trashpick_logo_banner.png',
                      height: 120,
                      width: 120,
                    ),
                  ),
                  SizedBox(height: 20),
                  radioButtonList(),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      prefixIcon: Icon(Icons.phone_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: _isHidden,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_isHidden
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: _togglePasswordView,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: _isHiddenC,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_isHiddenC
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: _toggleConfirmPasswordView,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ButtonWidget(
                      text: "Create Account",
                      textColor: AppThemeData().whiteColor,
                      color: AppThemeData().primaryColor,
                      onClicked: authenticateUser,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text(
                        'Already have an account? Sign In',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
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
