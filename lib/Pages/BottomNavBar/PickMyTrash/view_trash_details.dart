import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Models/trash_pick_ups_model.dart';
import 'package:trashpick/Widgets/button_widgets.dart';
import 'package:trashpick/Widgets/secondary_app_bar_widget.dart';

class ViewTrashDetails extends StatefulWidget {
  final String userID, trashID, accountType;

  ViewTrashDetails(this.userID, this.trashID, this.accountType);

  @override
  _ViewTrashDetailsState createState() => _ViewTrashDetailsState();
}

class _ViewTrashDetailsState extends State<ViewTrashDetails> {
  final userReference = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  
  // Light aqua color palette
  final Color lightAqua = Color(0xFFB2EBF2);
  final Color aqua = Color(0xFF80DEEA);
  final Color darkAqua = Color(0xFF26C6DA);

  List trashTypesList;

  // Map to hold icons for each trash type
  final Map<String, IconData> trashTypeIcons = {
    "Plastic & Polythene": Icons.recycling,
    "Glass": Icons.local_drink,
    "Paper": Icons.description,
    "Metal Waste": Icons.build,
    "Medical Waste": Icons.medical_services,
    "E-Waste": Icons.computer,
    "Other": Icons.miscellaneous_services,
  };

  Widget trashTypesFilter(TrashPickUpsModel trashPickUpsModel) {
    return Container(
      height: (trashPickUpsModel.trashTypes.length.toDouble() * 45),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: trashPickUpsModel.trashTypes.length,
        itemBuilder: (BuildContext context, int index) {
          String trashType = trashPickUpsModel.trashTypes[index];
          IconData trashTypeIcon = trashTypeIcons[trashType] ?? Icons.help; // Default icon if not found

          return Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: Row(
              children: [
                Icon(
                  trashTypeIcon,
                  size: 20.0,
                  color: darkAqua, // You can adjust icon color here
                ),
                SizedBox(width: 10.0),
                Text(trashType, style: TextStyle(color: Colors.black)),
              ],
            ),
          );
        }
      ),
    );
  }

  TextStyle titleStyle() {
    return TextStyle(
      fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
      fontWeight: FontWeight.bold,
      color: darkAqua,
    );
  }

  TextStyle detailStyle() {
    return TextStyle(
      fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );
  }

  Widget trashDetails() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.userID)
          .collection('Trash Pick Ups')
          .where('trashID', isEqualTo: widget.trashID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(
            "Data Unavailable",
            style: titleStyle().copyWith(fontSize: 24),
          );
        } else {
          TrashPickUpsModel trashPickUpsModel =
              TrashPickUpsModel.fromDocument(snapshot.data.docs[0]);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${trashPickUpsModel.trashName}",
                style: titleStyle().copyWith(fontSize: 26),
              ),
              SizedBox(height: 20.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  trashPickUpsModel.trashImage,
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Text("Trash Description", style: titleStyle()),
                  Text(trashPickUpsModel.trashDescription, style: detailStyle()),
                  SizedBox(height: 20.0),
                  Text("Trash Types", style: titleStyle()),
                  trashTypesFilter(trashPickUpsModel),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Start Date", style: titleStyle()),
                          Text(trashPickUpsModel.startDate, style: detailStyle()),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Return Date", style: titleStyle()),
                          Text(trashPickUpsModel.returnDate, style: detailStyle()),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Start Time", style: titleStyle()),
                          Text(trashPickUpsModel.startTime, style: detailStyle()),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Return Time", style: titleStyle()),
                          Text(trashPickUpsModel.returnTime, style: detailStyle()),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text("Posted Date", style: titleStyle()),
                  Text(trashPickUpsModel.postedDate, style: detailStyle()),
                  SizedBox(height: 20.0),
                  Center(
                    child: widget.accountType == "Trash Picker"
                        ? MinButtonWidget(
                            text: "Edit Trash Pick Up",
                            color: aqua,
                            onClicked: () => {print("Edit Trash Pick Ups Pressed!")},
                          )
                        : Container(),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        title: "About Trash",
        appBar: AppBar(),
        widgets: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Image.asset(
              "assets/icons/icon_trash_sort.png",
              height: 35.0,
              width: 35.0,
            ),
          )
        ],
      ),
      body: Container(
        color: lightAqua,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: trashDetails(),
          ),
        ),
      ),
    );
  }
}
