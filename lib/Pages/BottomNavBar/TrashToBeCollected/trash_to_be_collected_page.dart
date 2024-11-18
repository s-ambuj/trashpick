import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trashpick/Models/trash_pick_ups_model.dart';
import 'package:trashpick/Pages/BottomNavBar/TrashToBeCollected/trash_to_be_collected_list.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import 'package:trashpick/Widgets/toast_messages.dart';
import '../../../Widgets/primary_app_bar_widget.dart';

class TrashToBeCollected extends StatefulWidget {
  @override
  _TrashToBeCollectedState createState() => _TrashToBeCollectedState();
}

class _TrashToBeCollectedState extends State<TrashToBeCollected> {
  Widget _childMap;
  GoogleMapController _googleMapController;
  Position _currentPosition;
  String _currentAddress;
  BitmapDescriptor currentUserMarkerIcon, mapRecyclingCenterMarkerIcon;
  List eventLocations;
  Map<MarkerId, Marker> currentUserMarker = <MarkerId, Marker>{};
  Map<MarkerId, Marker> recyclingCentersMarkers = <MarkerId, Marker>{};
  Set<Marker> _displayMapMarkers = Set();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    _childMap = loadingMap("Loading Map...");
    _getCurrentUserLocation();
    setCurrentUserMarkerIcon();
    setMapRecyclingCentersMarkerIcon();
    getRecyclingCentersLocation();
    super.initState();
  }

  // ---------------------------------- CURRENT USER ---------------------------------- \\

  _getCurrentUserLocation() {
    try {
      Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              forceAndroidLocationManager: true)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
          _displayMapMarkers = Set<Marker>.of(currentUserMarker.values);
          _childMap = mapWidget();
        });
        _getCurrentUserAddressFromLatLng();
      }).catchError((e) {
        print(e);
      });
    } catch (error) {
      ToastMessages().toastError(error, context);
    }
  }

  _getCurrentUserAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        if (place != null) {
          _currentAddress = "${place.name}, "
              "${place.street}, "
              "${place.locality}, "
              "${place.country}";
        } else {
          _currentAddress = "No Address";
        }
        _childMap = mapWidget();
      });
    } catch (error) {
      ToastMessages().toastError(error, context);
    }
  }

  setCurrentUserMarkerIcon() async {
    currentUserMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 5.0),
        'assets/icons/icon_home.png');
  }

  _setCurrentUserMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('MyCurrentLocation'),
          position:
              LatLng(_currentPosition.latitude, _currentPosition.longitude),
          icon: currentUserMarkerIcon,
          onTap: () {
            print('My Location');
          },
          infoWindow:
              InfoWindow(title: 'My Location', snippet: _currentAddress))
    ].toSet();
  }

  // ---------------------------------- Recycling Centers ---------------------------------- \\

  setMapRecyclingCentersMarkerIcon() async {
    mapRecyclingCenterMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 50.0),
        'assets/icons/icon_bin.png');
  }

  getRecyclingCentersLocation() {
    FirebaseFirestore.instance.collection("Users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(result.id)
            .collection("Trash Pick Ups")
            .get()
            .then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            querySnapshot.docs.forEach((result) {
              TrashPickUpsModel trashPickUpsModel =
                  TrashPickUpsModel.fromDocument(result);
              setRecyclingCentersMarkers(
                trashPickUpsModel.trashID,
                trashPickUpsModel.trashName,
                trashPickUpsModel.trashLocationLocation.latitude,
                trashPickUpsModel.trashLocationLocation.longitude,
              );
            });
          }
        });
      });
    });
  }

  setRecyclingCentersMarkers(
    id,
    name,
    latitude,
    longitude,
  ) async {
    final MarkerId markerID = MarkerId(id);
    final Marker marker = Marker(
      markerId: markerID,
      icon: mapRecyclingCenterMarkerIcon,
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
          title: name,
          onTap: () {
            print("id: $id\n"
                "name:$name\n"
                "latitude: $latitude\n"
                "longitude: $longitude");
          }),
    );
    setState(() {
      recyclingCentersMarkers[markerID] = marker;
      _displayMapMarkers = Set<Marker>.of(recyclingCentersMarkers.values);
      _childMap = mapWidget();
    });
  }

  // ---------------------------------- COMMON MAP ---------------------------------- \\

  loadingMap(String m) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 100.0),
        child: Text(
          m,
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  checkLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
    } else {
      _getCurrentUserLocation();
    }
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: _displayMapMarkers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        zoom: 8.5,
      ),
      onMapCreated: (GoogleMapController controller) {
        _googleMapController = controller;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFB2EBF2), // Light aqua color
          automaticallyImplyLeading: false,
          title: Text(
            "Trash To Be Collected",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.black),
          ),
          elevation: 2.0,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: Icon(
                Icons.transfer_within_a_station_rounded,
                color: Color(0xFF00796B), // Darker aqua for icons
                size: 35.0,
              ),
            )
          ],
          bottom: TabBar(
            labelColor: Color(0xFF00796B), // Darker aqua for selected tab
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Trash List",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Icon(
                      Icons.list_alt_rounded,
                      color: Color(0xFF00796B),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Map View",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Icon(Icons.map_rounded, color: Color(0xFF00796B)),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            TrashToBeCollectedList(),
            Container(
              child: _childMap,
            ),
          ],
        ),
      ),
    );
  }
}
