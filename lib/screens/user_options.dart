import 'package:flash_chat/screens/inputpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:url_launcher/url_launcher.dart';

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
  //final firebaseAdmin = require('firebase-admin');

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

  QuerySnapshot querySnapshot;
  List<String> locations = [];
  GeoPoint minDistanceLocation ;


  void getLocation() async {
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


  /*void calculateDistance() async {
     //print(querySnapshot.documents.length);
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      locations.add(querySnapshot.documents[i].data['location']);
    }
  //print(locations.length);
    double min = await Geolocator().distanceBetween(myLocation.latitude, myLocation.longitude, double.parse(locations[0].split(",")[0]), double.parse(locations[0].split(",")[1]));
    int minIndex = -1;
    for (int i = 1; i < locations.length; i++) {
      final double endLatitude = double.parse(locations[i].split(",")[0]);
      //print(endLatitude);

      final double endLongitude = double.parse(locations[i].split(",")[1]);
     // print(endLongitude);

      double myDistances = await Geolocator().distanceBetween(
          myLocation.latitude, myLocation.longitude, endLatitude,
          endLongitude);
      if(myDistances<min){
        min = myDistances;
        minIndex = i;
      }
      //print(myDistances);
    }
    //print("hello");
    //print(distances[0]);
    //print(distances.length);

    minDistanceLocation = GeoPoint(double.parse(locations[minIndex].split(",")[0]), double.parse(locations[minIndex].split(",")[1]));


    //return minDistanceLocation;
  }*/

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {

   // Future<GeoPoint> mylocation;
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
               getLocation();
                //calculateDistance();
                //Navigator.pushNamed(context, MainRegistration.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}



