import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Models/articles_model.dart';
import 'package:trashpick/Pages/BottomNavBar/BeAware/read_article.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import 'package:trashpick/Widgets/button_widgets.dart';
import '../../../Widgets/primary_app_bar_widget.dart';

class BeAware extends StatefulWidget {
  @override
  _BeAwareState createState() => _BeAwareState();
}

class _BeAwareState extends State<BeAware> {
  int documents;

  @override
  void initState() {
    getTotalArticles();
    super.initState();
  }

  getTotalArticles() async {
    final QuerySnapshot qSnap =
        await FirebaseFirestore.instance.collection('Articles').get();
    documents = qSnap.docs.length;
    print(
        "----------------------- TOTAL ARTICLES: $documents -----------------------");
  }

  Widget articleDetailsCard(
      AsyncSnapshot<QuerySnapshot> snapshot, ArticlesModel articlesModel) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.white, // Card color
          elevation: 3,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              print('Selected Article: ${articlesModel.articleID}');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ReadArticle(articlesModel.articleLink)),
              );
            },
            child: snapshot.data.docs.length == null
                ? Container()
                : Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          articlesModel.articleImage,
                          fit: BoxFit.cover,
                          height: 150,
                          width: 150,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                articlesModel.articleTitle,
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .fontSize,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Divider(
                                color: Theme.of(context).iconTheme.color,
                              ),
                              Text(
                                articlesModel.articleDescription,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppThemeData
                                        .lightTheme.iconTheme.color),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  _articlesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Articles")
          .orderBy('articlePostedDate', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Container()
            : snapshot.data.docs.length.toString() == "0"
                ? Container(
                    height: 250.0,
                    width: 200.0,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      ArticlesModel articlesModel =
                          ArticlesModel.fromDocument(snapshot.data.docs[index]);
                      return articleDetailsCard(snapshot, articlesModel);
                    },
                  );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Articles",
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "TrashPick Articles",
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline6.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue[900]), // Darker aqua for title
                ),
                SizedBox(
                  height: 20.0,
                ),
                _articlesList(),
                // Sample articles on waste management
                SizedBox(height: 20),
                Text(
                  "Recommended Articles on Waste Management",
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline6.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue[900]),
                ),
                SizedBox(height: 50),
                // Sample articles
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReadArticle(
                              'https://www.sciencedirect.com/topics/earth-and-planetary-sciences/waste-reduction')),
                    );
                  },
                  child: articleTile("5 Ways to Reduce Waste at Home"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReadArticle(
                              'https://www.sciencedirect.com/topics/earth-and-planetary-sciences/waste-reduction')),
                    );
                  },
                  child: articleTile("The Importance of Recycling"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReadArticle(
                              'https://www.epa.gov/recycle/recycling-basics-and-benefits')),
                    );
                  },
                  child: articleTile("Composting 101: How to Get Started"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget articleTile(String title) {
    return Container(
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
    );
  }
}
