import 'package:flash_chat/screens/inputpage.dart';
import 'package:flash_chat/screens/login_main.dart';
import 'package:flash_chat/screens/registration_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flash_chat/screens/prioritizer_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {

  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}

getHospitalLocations(int n) async {
  return await Firestore.instance.collection('hospitals').where('beds', isGreaterThan: n).getDocuments();
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
  GeoPoint myLocation = GeoPoint(0.1,0.2);
  //final firebaseAdmin = require('firebase-admin');
  void getLocation() async {
    try {
      position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
      myLocation = GeoPoint(position.latitude,position.longitude);
      print(position);
      EdgeAlert.show(context, title: 'Your location', description: '$position', gravity: EdgeAlert.BOTTOM);
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

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<String> locations = [];
  List<double> distances = [];
  GeoPoint minDistanceLocation ;

  void calculateDistance() async {
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      locations.add(querySnapshot.documents[i].data['location']);
    }

    for (int i = 0; i < locations.length; i++) {
      final double endLatitude = double.parse(locations[i].split(",")[0]);
      final double endLongitude = double.parse(locations[i].split(",")[1]);
      distances[i] = await Geolocator().distanceBetween(
          myLocation.latitude, myLocation.longitude, endLatitude,
          endLongitude);
    }

    int min = -1;
    double minDistance = 0.0;
    for (int i = 0; i < locations.length; i++) {
      if (distances[i] < minDistance) {
        minDistance = distances[i];
        min = i;
      }
    }

    minDistanceLocation = GeoPoint(double.parse(locations[min].split(",")[0]),
        double.parse(locations[min].split(",")[0]));
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
                getLocation();
                //calculateDistance();
                MapUtils.openMap(myLocation.latitude,myLocation.longitude);

                //Navigator.pushNamed(context, MainRegistration.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}



