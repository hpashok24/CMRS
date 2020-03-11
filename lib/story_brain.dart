//TODO: Step 6 - import the story.dart file into this file.



import 'story.dart';





//TODO: Step 5 - Create a new class called StoryBrain.
class StoryBrain {
//TODO: Step 7 - Uncomment the lines below to include storyData as a private property in StoryBrain. Hint: You might need to change something in story.dart to make this work.
  List<Story> _storyData = [
    //0
    Story(
        storyTitle:
        'Is the patient Walking ?'
            ,
        choice1: 'Walks ',
        choice2: 'Doesn\'t walk' ),
    //1
    Story(
        storyTitle: 'Patient\'s respiration ?'
            ,
        choice1: 'Present ',
        choice2: 'Absent'),
    //2
    Story(
        storyTitle:
        'Is Position airway present ? ',
        choice1: 'Yes',
        choice2: 'No'),
    //3
    Story(
        storyTitle:
        'What is the Respiration Rpm ? ',
        choice1: 'less than 30 rpm',
        choice2: 'more than 30 rpm'),
    //4
    Story(
        storyTitle:'Radial pulse ',
        choice1: 'Present ',
        choice2: 'Absent '),
    //5
    Story(
        storyTitle:
        'Blanch test',
        choice1: 'less than 2 seconds',
        choice2: 'more than 2 seconds'),
    //6
    Story(
        storyTitle:
        'Does he follow instructions ',
        choice1: 'yes ',
        choice2: 'no'),
    //7
    Story(
        storyTitle:
        'Seems like it\'s not critical' ,
        choice1: 'What to do next?',
        choice2: ''),
    //8
    Story(
        storyTitle:
        'Patient is dead',
        choice1: 'Get mortuary service',
        choice2: ''),
    //9
    Story(
        storyTitle:
        'Immediate',
        choice1: 'Get ambulance Immedaiately',
        choice2: ''),
    //10
    Story(
        storyTitle:
        'Delayed',
        choice1: 'What to do next?',
        choice2: '')
  ];

  void nextStory(int choiceNumber) {



    /*else if (storynumber == 3 || storynumber == 4 || storynumber == 5) {
      restart();
    }*/


    if (storynumber == 0){
      if (choiceNumber == 1){
        storynumber = 7;
      } else {
        storynumber = 1;
      }
    }
    else if (storynumber == 1){
      if (choiceNumber == 1){
        storynumber = 3;
      } else{
        storynumber = 2;
      }
    }
    else if (storynumber == 2){
      if(choiceNumber == 1){
        storynumber = 3;
      }else {
        storynumber = 8;
      }
    }
    else if (storynumber == 3){
      if (choiceNumber == 1){
        storynumber = 4;
      }else {
        storynumber = 9;
      }
    }
    else if (storynumber == 4){
      if (choiceNumber == 1){
        storynumber = 5;
      }else{
        storynumber = 9;
      }
    }
    else if (storynumber == 5){
      if(choiceNumber == 1){
        storynumber = 6;
      }else{
        storynumber = 9;
      }
    }
    else if (storynumber == 6){
      if(choiceNumber == 1) {
        storynumber = 10;
      }else {
        storynumber = 9;
      }
    }
  }

  void restart() {
    storynumber = 0;
  }


  bool alert(){
    if(storynumber ==9) {
      return true;
    }
    if(storynumber ==10){
      return true;
    }
    if(storynumber == 8){
      return true;
    }
    else{
      return false;
    }


  }
















  //TODO: Step 23 - Use the storyNumber property inside getStory(), getChoice1() and getChoice2() so that it gets the updated story and choices rather than always just the first (0th) one.

//TODO: Step 8 - Create a method called getStory() that returns the first storyTitle from _storyData.
  String getStory() {
    return _storyData[storynumber].storyTitle;
  }

//TODO: Step 11 - Create a method called getChoice1() that returns the text for the first choice1 from _storyData.
  String getChoice1() {
    return _storyData[storynumber].choice1;
  }

//TODO: Step 12 - Create a method called getChoice2() that returns the text for the first choice2 from _storyData.
  String getChoice2() {
    return _storyData[storynumber].choice2;
  }

//TODO: Step 16 - Create a property called storyNumber which starts with a value of 0. This will be used to track which story the user is currently viewing.

  //TODO: Step 25 - Change the storyNumber property into a private property so that only story_brain.dart has access to it. You can do this by right clicking on the name (storyNumber) and selecting Refactor -> Rename to make the change across all the places where it's used.
  int storynumber = 0;

//TODO: Step 17 - Create a method called nextStory(), it should not have any outputs but it should have 1 input called choiceNumber which will be the choice number (int) made by the user.

//TODO: Step 20 - Download the story plan here: https://drive.google.com/uc?export=download&id=1KU6EghkO9Hf2hRM0756xFHgNaZyGCou3

//TODO: Step 27 - Create a method called buttonShouldBeVisible() which checks to see if storyNumber is 0 or 1 or 2 (when both buttons should show choices) and return true if that is the case, else it should return false.
  bool buttonShouldBeVisible() {
    //You could also just check if (storynumber < 3)
    if (storynumber == 7 || storynumber == 8 || storynumber == 9 || storynumber == 10 ) {
      return false;
    } else {
      return true;
    }
  }
}
