import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppThemeData {
  final Color primaryColor = Color(0xFF00796B);
  final Color secondaryColor = Colors.grey.shade900;
  final Color accentColor = Color(0xFFB2EBF2);
  final Color redColor = Colors.red;
  final Color blueColor = Colors.blue;
  final Color deepBlueColor = Colors.blue.shade800;
  final Color yellowColor = Colors.yellow;
  final Color whiteColor = Colors.white;
  final Color greyColor = Colors.grey;
  final Color grey200Color = Colors.grey.shade200;

  // Light Aqua Colors
  final Color lightAqua = Color(0xFFB2EBF2); // Light aqua background
  final Color darkAqua = Color(0xFF00796B); // Darker aqua for text

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(),
    primaryColor: Color.fromRGBO(34, 111, 39, 1),
    backgroundColor: Colors.white,
    accentColor: Color.fromRGBO(50, 163, 57, 1),
    fontFamily: 'Open Sans',
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.grey.shade900,
    ),
    appBarTheme: AppBarTheme(color: Colors.white, elevation: 0.0),
    iconTheme: IconThemeData(color: Colors.grey.shade900),
    textTheme: TextTheme(
      headline1: TextStyle(
          fontSize: 96.0, fontWeight: FontWeight.bold, color: Colors.black),
      headline2: TextStyle(
          fontSize: 60.0, fontWeight: FontWeight.bold, color: Colors.black),
      headline3: TextStyle(
          fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.black),
      headline4: TextStyle(
          fontSize: 34.0, fontWeight: FontWeight.bold, color: Colors.black),
      headline5: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
      headline6: TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
      subtitle1: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
      subtitle2: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
      bodyText1: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black),
      bodyText2: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.black),
      caption: TextStyle(
          fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.black),
      overline: TextStyle(
          fontSize: 10.0, fontWeight: FontWeight.normal, color: Colors.black),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(),
    primaryColor: Color.fromRGBO(34, 111, 39, 1),
    backgroundColor: Colors.grey.shade900,
    accentColor: Color.fromRGBO(50, 163, 57, 1),
    fontFamily: 'Open Sans',
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.grey.shade900,
    ),
    appBarTheme: AppBarTheme(color: Colors.grey.shade900, elevation: 0.0),
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      headline1: TextStyle(
          fontSize: 96.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline2: TextStyle(
          fontSize: 60.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline3: TextStyle(
          fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline4: TextStyle(
          fontSize: 34.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline5: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline6: TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
      subtitle1: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
      subtitle2: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),
      bodyText1: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white),
      bodyText2: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
      caption: TextStyle(
          fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white),
      overline: TextStyle(
          fontSize: 10.0, fontWeight: FontWeight.normal, color: Colors.white),
    ),
  );
}
