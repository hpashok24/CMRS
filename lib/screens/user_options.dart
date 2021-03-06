import 'package:flash_chat/screens/inputpage.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GoogleMaps {

  GoogleMaps._();
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}

class UserOptions extends StatefulWidget {
  static const String id = 'user_options_screen';

  @override
  _UserOptionsState createState() => _UserOptionsState();
}

class _UserOptionsState extends State<UserOptions>
    with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation animation;
  Position position;
  GeoPoint myLocation = GeoPoint(56,-122);
  QuerySnapshot querySnapshot;
  List<String> locations = [];
  GeoPoint minDistanceLocation ;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  _signOut() async {
    await _firebaseAuth.signOut();
  }

  getHospitalLocations(int n) async {
    return await Firestore.instance.collection('hospitals').where('beds', isGreaterThan: n).getDocuments();
  }


  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });

    getHospitalLocations(0).then((results) {
      setState(() {
        querySnapshot = results;
      });
    });
  }

  void getLocationOfNearestHospital() async {
    try {
      position = await Geolocator().getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.high);
      myLocation = GeoPoint(position.latitude, position.longitude);
      print(position);
      EdgeAlert.show(context, title: 'Your location', description: '$position', gravity: EdgeAlert.BOTTOM);
      for (int i = 0; i < querySnapshot.documents.length; i++) {
        locations.add(querySnapshot.documents[i].data['location']);
      }
      print(locations.length);
      double min = await Geolocator().distanceBetween(myLocation.latitude, myLocation.longitude, double.parse(locations[0].split(",")[0]), double.parse(locations[0].split(",")[1]));
      int minIndex = 0;
      for (int i = 1; i < locations.length; i++) {
        final double endLatitude = double.parse(locations[i].split(",")[0]);
        final double endLongitude = double.parse(locations[i].split(",")[1]);
        double myDistances = await Geolocator().distanceBetween(
            myLocation.latitude, myLocation.longitude, endLatitude,
            endLongitude);
        if(myDistances<min){
          min = myDistances;
          minIndex = i;
        }
      }
     minDistanceLocation = GeoPoint(double.parse(locations[minIndex].split(",")[0]), double.parse(locations[minIndex].split(",")[1]));
     GoogleMaps.openMap(minDistanceLocation.latitude,minDistanceLocation.longitude);
    }
    on PlatformException catch(e){
      if(e.code == 'PERMISSION_DISABLED'){
        //error = 'Permission denied';
        EdgeAlert.show(context, title: 'Your location', description: 'Please Switch on your location in phone', gravity: EdgeAlert.BOTTOM);
      }
      else{
        print(position);
        EdgeAlert.show(context, title: 'Your location', description: '$position', gravity: EdgeAlert.BOTTOM);
      }
    }
  }

  String descr = "";
  void getNameOfNearestHospital() async {
      position = await Geolocator().getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.high);
      myLocation = GeoPoint(position.latitude, position.longitude);
      print(position);
      EdgeAlert.show(context, title: 'Your location', description: '$position', gravity: EdgeAlert.BOTTOM);
      for (int i = 0; i < querySnapshot.documents.length; i++) {
        locations.add(querySnapshot.documents[i].data['location']);
      }
      print(locations.length);
      double min = await Geolocator().distanceBetween(myLocation.latitude, myLocation.longitude, double.parse(locations[0].split(",")[0]), double.parse(locations[0].split(",")[1]));
      int minIndex = 0;
      for (int i = 1; i < locations.length; i++) {
        final double endLatitude = double.parse(locations[i].split(",")[0]);
        final double endLongitude = double.parse(locations[i].split(",")[1]);
        double myDistances = await Geolocator().distanceBetween(
            myLocation.latitude, myLocation.longitude, endLatitude,
            endLongitude);
        if(myDistances<min){
          min = myDistances;
          minIndex = i;
        }
      }
      minDistanceLocation = GeoPoint(double.parse(locations[minIndex].split(",")[0]), double.parse(locations[minIndex].split(",")[1]));
      String minDistance = minDistanceLocation.latitude.toString()+","+minDistanceLocation.longitude.toString();
      QuerySnapshot name = await Firestore.instance.collection('hospitals').where('location', isEqualTo: minDistance).getDocuments();
      descr = name.documents[0].data['name'];
      //return (name.documents[0].data['name']);
      Alert(
        context: context,
        type: AlertType.success,
        title: "The nearest hopital is $descr",
        buttons: [
          DialogButton(
            child: Text(
              "Hospital Route",

              style: TextStyle(
                  color: Colors.white, fontSize: 15),
            ),
            width: 120,
            onPressed: () {
              getLocationOfNearestHospital();
            },
          ),
        ],
      ).show();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/playstore.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['C M R S'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Request ambulance or report incident',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, InputPage.id);
              },
            ),
            RoundedButton(
              title: 'Get nearest hospital (self ambulance)',
              colour: Colors.blueAccent,
              onPressed: () {
                getNameOfNearestHospital();
              },
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 1,
                ),
               FlatButton(
                  color: Colors.teal,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () {
                    _signOut();
                    Navigator.popAndPushNamed(context, LoginScreen1.id);
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 10.0),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}



