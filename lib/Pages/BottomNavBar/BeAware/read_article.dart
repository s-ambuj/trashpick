import 'package:flutter/material.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import 'package:trashpick/Widgets/primary_app_bar_widget.dart';
import 'package:trashpick/Widgets/secondary_app_bar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class ReadArticle extends StatefulWidget {
  final String articleLink;

  ReadArticle(this.articleLink);

  @override
  _ReadArticleState createState() => _ReadArticleState();
}

class _ReadArticleState extends State<ReadArticle> {
  final _key = UniqueKey();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        title: "Article from Website",
        appBar: AppBar(),
        widgets: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Icon(
              Icons.notifications_rounded,
              color: AppThemeData().secondaryColor,
              size: 35.0,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue[100], // Light aqua background
                Colors.lightBlue[300],
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              WebView(
                key: _key,
                initialUrl: widget.articleLink,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (finish) {
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10.0),
        color: Colors.lightBlue[200], // Aqua color for the bottom bar
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "More Articles on Waste Management",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            ArticleTile(
              title: "5 Ways to Reduce Waste at Home",
              onTap: () {
                // Link to the article
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReadArticle('https://example.com/article1'),
                  ),
                );
              },
            ),
            ArticleTile(
              title: "The Importance of Recycling",
              onTap: () {
                // Link to the article
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReadArticle('https://example.com/article2'),
                  ),
                );
              },
            ),
            ArticleTile(
              title: "Composting 101: How to Get Started",
              onTap: () {
                // Link to the article
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReadArticle('https://example.com/article3'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleTile extends StatelessWidget {
  final String title;
  final Function onTap;

  const ArticleTile({Key key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.lightBlue[900], // Darker aqua for text
          ),
        ),
      ),
    );
  }
}
