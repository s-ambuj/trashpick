import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Pages/BottomNavBar/bottom_nav_bar.dart';
import 'package:trashpick/Pages/OnAppStart/sign_up_page.dart';
import 'package:trashpick/Pages/OnAppStart/welcome_page.dart';
import '../../Theme/theme_provider.dart';
import '../../Widgets/button_widgets.dart';
import '../../Widgets/toast_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'user_guide.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  ToastMessages _toastMessages = new ToastMessages();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isHidden = true;
  bool isUserSigned = false;
  bool isInValidaAccount = false;
  double circularProgressVal;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String accountType;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  showAlertDialog(BuildContext context) {
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: !isUserSigned
                  ? Center(child: Text("Sign In"))
                  : Center(child: Text("Welcome Back")),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isUserSigned)
                    !isInValidaAccount
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 30.0),
                              CircularProgressIndicator(
                                value: circularProgressVal,
                                strokeWidth: 6,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppThemeData().primaryColor),
                              ),
                              SizedBox(height: 30.0),
                              Text("Signing in to your account...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16.0)
                                      .copyWith(color: Colors.grey.shade900)),
                            ],
                          )
                        : Column(
                            children: [
                              Text("Error!",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(height: 50.0),
                              ButtonWidget(
                                  text: "Try Again",
                                  color: AppThemeData().redColor,
                                  textColor: AppThemeData().whiteColor,
                                  onClicked: () {
                                    setState(() {
                                      isUserSigned = false;
                                      isInValidaAccount = false;
                                      Navigator.pop(context);
                                    });
                                  }),
                            ],
                          )
                  else
                    Column(
                      children: [
                        Text("Welcome!",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(height: 50.0),
                        Image.asset(
                          'assets/images/welcome.png',
                          height: 100,
                          width: 100,
                        ),
                        SizedBox(height: 50.0),
                        ButtonWidget(
                            text: "Continue",
                            textColor: AppThemeData().whiteColor,
                            color: AppThemeData().primaryColor,
                            onClicked: () {
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
            );
          },
        );
      },
    );
  }

  void ifAnError() {
    Navigator.pop(context);
    setState(() {
      isUserSigned = false;
      isInValidaAccount = true;
      showAlertDialog(context);
    });
  }

  bool validateUser() {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (emailController.text.isEmpty && passwordController.text.isEmpty) {
      _toastMessages.toastInfo('Please fill in all fields', context);
    } else if (emailController.text.isEmpty) {
      _toastMessages.toastInfo('Email is empty', context);
    } else if (!regExp.hasMatch(emailController.text)) {
      _toastMessages.toastInfo('Email pattern is incorrect', context);
    } else if (passwordController.text.isEmpty) {
      _toastMessages.toastInfo('Password is empty', context);
    } else {
      return true;
    }

    return false;
  }

  geAccountType(String userID) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .get()
        .then((value) {
      accountType = value.data()["accountType"];
    });
  }

  void _signInWithEmailAndPassword() async {
    showAlertDialog(context);
    setState(() {
      isUserSigned = false;
      isInValidaAccount = false;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      await geAccountType(userCredential.user.uid.toString());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => BottomNavBar(accountType),
        ),
        (route) => false,
      );
      print('User is signed in!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ifAnError();
        _toastMessages.toastError("No user found for that email", context);
      } else if (e.code == 'wrong-password') {
        ifAnError();
        _toastMessages.toastError("Wrong password provided!", context);
      } else {
        _toastMessages.toastError("Something Went Wrong.", context);
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: Color(0xFFE0F7FA), // Light aqua background
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomePage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      'assets/logos/trashpick_logo_banner.png',
                      height: 200,
                      width: 200,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: _isHidden,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordView,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ButtonWidget(
                    textColor: AppThemeData().whiteColor,
                    color: AppThemeData().darkAqua,
                    text: "Sign In",
                    onClicked: () {
                      if (validateUser()) {
                        _signInWithEmailAndPassword();
                      } else {
                        _toastMessages.toastInfo(
                            'Try again with correct details!', context);
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New to TrashPick?",
                          style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.button.fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserGuidePage()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text("Sign Up"),
                        ),
                      ],
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
