import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/change_theme_button_widget.dart';
import '../Theme/theme_provider.dart';

class TestTheme extends StatefulWidget {
  TestTheme({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TestThemeState createState() => _TestThemeState();
}

class _TestThemeState extends State<TestTheme> {
  @override
  Widget build(BuildContext context) {
    final themeText =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.light
            ? 'Light Theme'
            : 'Dark Theme';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.cyan.shade700, // Light aqua app bar
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                color: Colors.cyan.shade50, // Light aqua background for text
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Text with a background color',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.cyan.shade900, // Darker aqua text color
                      ),
                ),
              ),
              SizedBox(height: 20.0),
              ChangeThemeButtonWidget(),
              Text(
                "App Theme $themeText",
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.cyan.shade900, // Aqua colored text
                    ),
              ),
              SizedBox(height: 20.0),
              // Headline texts
              ...List.generate(6, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "headline${index + 1}",
                    style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: 32.0 - index * 4.0,
                        color: Colors.cyan.shade900), // Adjust sizes
                  ),
                );
              }),
              Text(
                "bodyText1",
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.cyan.shade800, // Body text in darker aqua
                    ),
              ),
              SizedBox(height: 10.0),
              Text(
                "bodyText2",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.cyan.shade800,
                    ),
              ),
              SizedBox(height: 50.0),
              // Images with logo and spacing
              _buildLogoImage('assets/logos/trashpick_logo_curved.png'),
              _buildLogoImage('assets/logos/trashpick_logo_round.png'),
              _buildLogoImage('assets/logos/trashpick_logo_square.png'),
              SizedBox(height: 50.0),
              _buildColorBlock(
                  "PrimaryColor - Green", Theme.of(context).primaryColor),
              _buildColorBlock(
                  "SecondaryColor", Theme.of(context).backgroundColor),
              _buildColorBlock("AccentColor", Theme.of(context).accentColor),
              _buildColorBlock("RedColor", AppThemeData().redColor),
              _buildColorBlock("BlueColor", AppThemeData().blueColor),
              _buildColorBlock("YellowColor", AppThemeData().yellowColor),
              _buildColorBlock("WhiteColor", AppThemeData().whiteColor),
              _buildColorBlock("GreyColor", AppThemeData().greyColor),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build images with padding
  Widget _buildLogoImage(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Image.asset(
        assetPath,
        scale: 5.0,
      ),
    );
  }

  // Function to build color blocks with labels
  Widget _buildColorBlock(String label, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.cyan.shade800,
              ),
        ),
        Container(
          height: 50.0,
          width: MediaQuery.of(context).size.width,
          color: color,
          margin: EdgeInsets.symmetric(vertical: 8.0),
        ),
      ],
    );
  }
}
