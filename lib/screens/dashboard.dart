
import 'package:flash_chat/components/icon_content.dart';
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
import 'package:flash_chat/components/reusable_card.dart';

import 'package:flutter/material.dart';

class Hospital_Dashboard extends StatefulWidget {
  static const String id = 'hospital_dashboard';
  @override
  _Hospital_DashboardState createState() => _Hospital_DashboardState();
}

class _Hospital_DashboardState extends State<Hospital_Dashboard> {

  int ambulance =0;
  int beds=0;

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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconContent(
                        icon: FontAwesomeIcons.ambulance,
                      ),

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
          )
        ],
      ),
    );
  }
}
