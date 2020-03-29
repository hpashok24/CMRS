import 'package:flash_chat/screens/dashboard.dart';
import 'package:flash_chat/screens/prioritizer_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:edge_alert/edge_alert.dart';

import 'package:flash_chat/components/bottom_button.dart';
import 'package:flash_chat/components/round_icon_button.dart';


class HospitalDetails extends StatefulWidget {
  static const String id = 'hdetails_screen';
  @override
  _HospitalDetailsState createState() => _HospitalDetailsState();
}

class _HospitalDetailsState extends State<HospitalDetails> {
  String gender;

  String beds ;
  String ambulance;
  String hospital_name;
  String phone_number;
  Position position;
  GeoPoint myLocation;
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

  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Registration  details'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /*Expanded(
                child: Row(
                  children: <Widget>[

Expanded(

child: ReusableCard(
onPress: () {
getLocation();
},
colour: kActiveCardColour,
cardChild: IconContent(
icon: FontAwesomeIcons.locationArrow,
label: 'Location',
),
),
),
                    Expanded(
                      child: ReusableCard(
                        onPress: () {
                          setState(() {
                            gender = 'female';
                          });
                        },
                        colour: gender == 'female'
                            ? kActiveCardColour
                            : kInactiveCardColour,
                        cardChild: IconContent(
                          icon: FontAwesomeIcons.venus,
                          label: 'FEMALE',
                        ),
                      ),
                    ),
                  ],
                )),*/
            Expanded(
              child: ReusableCard(
                colour: kActiveCardColour,
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Hospital details ',
                      style: kLabelTextStyle,

                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: kTextFieldInputDecoration,
                        onChanged: (value) {
                          hospital_name = value;
                          print(value);
                        },
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: kTextFieldInputDecoration2,
                        onChanged: (value) {
                          phone_number = value;
                          print(value);
                        },
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: kTextFieldInputDecoration3,
                        onChanged: (value) {
                          beds = value;
                          print(value);
                        },
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: kTextFieldInputDecoration4,
                        onChanged: (value) {
                          ambulance = value;
                          print(value);
                        },
                      ),
                    ),

                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: <Widget>[



                        Text(
                          'press to enter location',
                          style: kLabelTextStyle,


                        ),


                        FloatingActionButton(
                          onPressed: getLocation,


                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
           /* Expanded(
              child: ReusableCard(
                colour: kActiveCardColour,
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Phone number ',
                      style: kLabelTextStyle,

                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: kTextFieldInputDecoration2,
                        onChanged: (value) {
                          phone_number = value;
                          print(value);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Container(


                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),*/



            //location and age
            /*Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      colour: kActiveCardColour,
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Ambulances',
                            style: kLabelTextStyle,
                          ),
                          Text(
                            ambulance.toString(),
                            style: kNumberTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RoundIconButton(
                                icon: FontAwesomeIcons.minus,
                                onPressed: () {
                                  setState(
                                        () {
                                      ambulance--;
                                    },
                                  );
                                },
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              RoundIconButton(
                                  icon: FontAwesomeIcons.plus,
                                  onPressed: () {
                                    setState(() {
                                      ambulance++;
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      colour: kActiveCardColour,
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'ICU beds',
                            style: kLabelTextStyle,
                          ),
                          Text(
                            beds.toString(),
                            style: kNumberTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RoundIconButton(
                                icon: FontAwesomeIcons.minus,
                                onPressed: () {
                                  setState(
                                        () {
                                      beds--;
                                    },
                                  );
                                },
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              RoundIconButton(
                                  icon: FontAwesomeIcons.plus,
                                  onPressed: () {
                                    setState(() {
                                      beds++;
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
            BottomButton(
              buttonTitle: 'Register Hospital for CMRS',
              onTap: () {
                //if(gender != null)
                /*_firestore.collection('user_details').add({
                  'age': age,
                  'gender': gender,
                  'name': patient,
                  'location': myLocation
                });*/
                _firestore.collection('user_details');

                var citiesRef = _firestore.collection('user_details');

                getLocation();
                Navigator.popAndPushNamed(context, Hospital_Dashboard.id);


              },
            ),
          ],
        ),
      ),
    );
  }
}




class ReusableCard extends StatelessWidget {
  ReusableCard({@required this.colour, this.cardChild, this.onPress});

  final Color colour;
  final Widget cardChild;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

class IconContent extends StatelessWidget {
  IconContent({this.icon, this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 80.0,
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          label,
          style: kLabelTextStyle,
        )
      ],
    );
  }
}



