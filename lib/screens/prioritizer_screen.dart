import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/story_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';


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

//TODO: Step 9 - Create a new storyBrain object from the StoryBrain class.
StoryBrain storyBrain = StoryBrain();


class Prioritisation extends StatefulWidget {

  static const String id = 'story_screen';

  _PrioritisationState createState() => _PrioritisationState();
}

class _PrioritisationState extends State<Prioritisation> {

  Position position;
  GeoPoint myLocation = GeoPoint(56,-122);

  getHospitalLocations(int n) async {
    return await Firestore.instance.collection('hospitals').where('beds', isGreaterThan: n).getDocuments();
  }
  int number=108;
  int mnumber= 09844088147;

  void _launchCaller(int number) async{
    var url = "tel:${number.toString()}";
    if(await canLaunch(url)){
      await launch(url);
    }
    else{
      throw 'Could not place call';
    }
  }

  bool giveAlert(){
    return storyBrain.alert();
  }

  @override
  void initState() {
    super.initState();
    getHospitalLocations(0).then((results) {
      setState(() {
        querySnapshot = results;
      });
    });
  }


  QuerySnapshot querySnapshot;
  List<String> locations = [];
  List<double> distances = [];
  GeoPoint minDistanceLocation ;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/whitebackgroung.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 15.0),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 12,
                child: Center(
                  child: Text(
                    //TODO: Step 10 - use the storyBrain to get the first story title and display it in this Text Widget.
                    storyBrain.getStory(),
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Visibility(
                  visible: storyBrain.buttonShouldBeVisible1(),
                  child: FlatButton(
                    onPressed: () {
                      //Choice 1 made by user.
                      //TODO: Step 18 - Call the nextStory() method from storyBrain and pass the number 1 as the choice made by the user.
                      //TODO: Step 24 - Run the app and try to figure out what code you need to add to this file to make the story change when you press on the choice buttons.
                      if(giveAlert())
                      {
                        if(storyBrain.storynumber==9){
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Patient in Immediate danger",
                            desc: "Get CMRS the nearest hospital with ICU bed",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Click here!",

                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                width: 120,
                                onPressed: () {
                                  getLocationOfNearestHospital();
                                  storyBrain.restart();
                                  Navigator.pop(context);
                                },

                              )
                            ],
                          ).show();
                        }

                        if(storyBrain.storynumber==10){
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Patient is not critical call a regular ambulance",
                            desc: "Call 108",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Call",

                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                width: 120,
                                onPressed: () {
                                  _launchCaller(number);
                                  storyBrain.restart();
                                  Navigator.pop(context);
                                },


                              )
                            ],
                          ).show();
                        }

                        if(storyBrain.storynumber==8){
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Mortuary Van",
                            desc: "Call St Peters Undertaker service",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Call",

                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                width: 120,
                                onPressed: () {
                                  _launchCaller(mnumber);
                                  storyBrain.restart();
                                  Navigator.pop(context);
                                },

                              )
                            ],
                          ).show();
                        }

                      }

                      if(storyBrain.storynumber==7){
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "Patient is not critical call a regular ambulance",
                          desc: "Call ",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Call",

                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              width: 120,
                              onPressed: () {
                                _launchCaller(number);
                                storyBrain.restart();
                                Navigator.pop(context);
                              },

                            )
                          ],
                        ).show();
                      }


                      setState(() {
                        storyBrain.nextStory(1);
                      });
                    },
                    color: Colors.green,
                    child: Text(
                      //TODO: Step 13 - Use the storyBrain to get the text for choice 1.
                      storyBrain.getChoice1(),
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                flex: 2,
                //TODO: Step 26 - Use a Flutter Visibility Widget to wrap this FlatButton.
                //TODO: Step 28 - Set the "visible" property of the Visibility Widget to equal the output from the buttonShouldBeVisible() method in the storyBrain.
                child: Visibility(
                  visible: storyBrain.buttonShouldBeVisible(),
                  child: FlatButton(
                    onPressed: () {
                      //Choice 2 made by user.
                  if(giveAlert()) {
                    if (storyBrain.storynumber == 9) {
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: "Patient in Immediate danger",
                        desc: "Get CMRS the nearest hospital with ICU bed",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Call hospital",

                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            width: 120,
                            onPressed: () {
                              getLocationOfNearestHospital();
                              storyBrain.restart();
                              Navigator.pop(context);
                            },

                          ),
                          DialogButton(
                            child: Text(
                              " hospital route ",

                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            width: 120,
                            onPressed: () {
                              storyBrain.restart();
                              getLocationOfNearestHospital();
                              Navigator.pop(context);
                            },

                          )
                        ],
                      ).show();
                    }
                  }

                      setState(() {
                        storyBrain.nextStory(2);
                      });
                    },
                    color: Colors.redAccent,
                    child: Text(

                      storyBrain.getChoice2(),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

