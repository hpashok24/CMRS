import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/icon_content.dart';
import 'package:flash_chat/screens/login_screen_hospital.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/constants.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flash_chat/components/round_icon_button.dart';
import 'package:flash_chat/components/reusable_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Hospital_Dashboard extends StatefulWidget {
  static const String id = 'hospital_dashboard';
  final String ambulances;
  Hospital_Dashboard({Key key, @required this.ambulances}) : super(key: key);

  @override
  _Hospital_DashboardState createState() => _Hospital_DashboardState();
}

class _Hospital_DashboardState extends State<Hospital_Dashboard> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  int ambulance = 0;
  int beds = 0;

  void initialise() async {
    ambulance = int.parse(widget.ambulances.split(",")[0]);
    beds = int.parse(widget.ambulances.split(",")[1]);
  }


  void initialise1() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    _firestore.collection('hospitals').document(uid)
        .get().then((DocumentSnapshot) =>
        ambulance = int.parse(DocumentSnapshot.data['ambulances']));

    _firestore.collection('hospitals').document(uid)
        .get().then((DocumentSnapshot) =>
        beds = int.parse(DocumentSnapshot.data['beds']));
  }


  void inputDataBeds() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    _firestore.collection('hospitals').document(uid).updateData({
      'beds': beds,
      });
  }

  void inputDataAmbulances() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    _firestore.collection('hospitals').document(uid).updateData({
      'ambulances': ambulance,
    });
  }


  _signOut() async {
    await auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    initialise1();
    initialise();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Name',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
        backgroundColor: Colors.teal,

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              SizedBox(
                width: 1,
              ),

              FlatButton(
                color: Colors.teal,
                textColor: Colors.black,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.teal,

                onPressed: () {
                  _signOut();
                  Navigator.popAndPushNamed(context, LoginScreen2.id);
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
          Expanded(
            child: ReusableCard(
              colour: kActiveCardColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Please Update the number of ambulances',
                    style: kLabelTextStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 30,
                      ),
                      IconContent(
                        icon: FontAwesomeIcons.ambulance,
                        label: 'Ambulances',
                      ),
                      SizedBox(
                        width: 90,
                      ),
                      Text(
                        ambulance.toString(),
                        style: kNumberTextStyle,
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          width: 100
                      ),

                      RoundIconButton(
                        icon: FontAwesomeIcons.minus,
                        onPressed: () {
                          setState(
                                () {
                              if(ambulance>0) {
                                ambulance--;
                              }
                             else{
                                EdgeAlert.show(context, title: 'invalid input', description: 'cannot be less than 0', gravity: EdgeAlert.BOTTOM);
                              }
                            },
                          );
                          inputDataAmbulances();
                        },
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      RoundIconButton(
                          icon: FontAwesomeIcons.plus,
                          onPressed: () {
                            setState(() {
                              ambulance++;
                            });
                            inputDataAmbulances();
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
                    'Please Update the number of beds',
                    style: kLabelTextStyle,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 30,
                      ),
                      IconContent(
                        icon: FontAwesomeIcons.bed,
                        label: 'ICU Beds',
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Text(
                        beds.toString(),
                        style: kNumberTextStyle,
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(
                        width: 100
                      ),

                      RoundIconButton(
                        icon: FontAwesomeIcons.minus,
                        onPressed: () {
                          setState(
                                () {
                                  if(beds>0)   {
                                    beds--;
                                  }
                                  else{
                                    EdgeAlert.show(context, title: 'invalid input', description: 'cannot be less than 0', gravity: EdgeAlert.BOTTOM);
                                  }
                            },
                          );
                          inputDataBeds();
                        },
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      RoundIconButton(
                          icon: FontAwesomeIcons.plus,
                          onPressed: () {
                            setState(() {
                              beds++;
                            });
                            inputDataBeds();
                          })
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
