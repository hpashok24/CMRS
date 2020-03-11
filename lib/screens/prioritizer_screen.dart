
import 'package:flutter/material.dart';
import 'package:flash_chat/story_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


//TODO: Step 9 - Create a new storyBrain object from the StoryBrain class.
StoryBrain storyBrain = StoryBrain();

class StoryPage extends StatefulWidget {

  static const String id = 'story_screen';

  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {

  bool giveAlert(){
    return storyBrain.alert();
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
                          desc: "Click the button to get the nearest hospital with ICU bed",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Click here!",

                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              width: 120,
                              onPressed: () {
                                storyBrain.restart();
                                Navigator.pop(context);
                              },

                            )
                          ],
                        ).show();
                      }

                      if(storyBrain.storynumber==10||storyBrain.storynumber==7){
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
                          desc: "Call 108",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Call",

                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              width: 120,
                              onPressed: () {
                                storyBrain.restart();
                                Navigator.pop(context);
                              },

                            )
                          ],
                        ).show();
                      }

                    }

                    if(storyBrain.storynumber==8){
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: "Call mortuary van service",
                        desc: "Call ",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Call",

                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            width: 120,
                            onPressed: () {
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
                  color: Colors.red,
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
                      //TODO: Step 19 - Call the nextStory() method from storyBrain and pass the number 2 as the choice made by the user.
                      setState(() {
                        storyBrain.nextStory(2);
                      });
                    },
                    color: Colors.blue,
                    child: Text(
                      //TODO: Step 14 - Use the storyBrain to get the text for choice 2.
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

//TODO: Step 29 - Run the app and test it against the Story Outline to make sure you've completed all the steps. The code for the completed app can be found here: https://github.com/londonappbrewery/destini-challenge-completed/
