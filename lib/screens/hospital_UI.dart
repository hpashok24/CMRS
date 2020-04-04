import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/dashboard.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/prioritizer_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flash_chat/screens/prioritizer_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/bottom_button.dart';
import 'package:flash_chat/components/round_icon_button.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/components/bottom_button.dart';
import 'package:flash_chat/components/round_icon_button.dart';


class HospitalUI extends StatefulWidget {
  static const String id = 'hui_screen';
  @override
  _HospitalUIState createState() => _HospitalUIState();
}

class _HospitalUIState extends State<HospitalUI> {
  String gender;
  int bedInt;
  int ambInt;
  String beds ;
  String ambulance;
  String hospital_name='';
  String phone_number;
  Position position;
  GeoPoint myLocation;
  String finalLocation;

  final auth = FirebaseAuth.instance;

  void getLocation() async {
    try {
      position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
      myLocation = GeoPoint(position.latitude,position.longitude);
      print(position);
      String myLatitude = myLocation.latitude.toString();
      String myLongitude = myLocation.longitude.toString();
      finalLocation = myLatitude+","+myLongitude;
      print(finalLocation);
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

  void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    _firestore.collection('hospitals').document(uid).setData({
      'beds': bedInt,
      'ambulances': ambInt,
      'name': hospital_name,
      'location': finalLocation,
      'phone number': phone_number
    });
    _firestore.collection('hospitals');
  }

  final _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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

            Expanded(
              child: ReusableCard(
                colour: Colors.teal,
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      padding: EdgeInsets.all(20),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Welcome To Cmrs .',style: GoogleFonts.pacifico(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            )
                          ),

                          ),

                          SizedBox(
                            height: 50,
                          ),

                          Text('hospital_name', style: GoogleFonts.pacifico(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black

                            ),
                          )

                          ),
                        ],
                      )
                    ),









                  ],
                ),
              ),
            ),
            RoundedButton(
              title: 'Update my beds and ambulances',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, Hospital_Dashboard.id);
              },
            ),

            SizedBox(
              width:30,
            ),

            RoundedButton(
              title: 'Logout from CMRS',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.popAndPushNamed(context, LoginScreen1.id);
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



