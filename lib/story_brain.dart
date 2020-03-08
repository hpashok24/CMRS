//TODO: Step 6 - import the story.dart file into this file.



import 'story.dart';





//TODO: Step 5 - Create a new class called StoryBrain.
class StoryBrain {
//TODO: Step 7 - Uncomment the lines below to include storyData as a private property in StoryBrain. Hint: You might need to change something in story.dart to make this work.
  List<Story> _storyData = [
   //0
    Story(
        storyTitle:
            'Is the patient Walking ?',
        choice1: 'Walks ',
        choice2: 'Doesn\'t walk' ),
    //1
    Story(
        storyTitle: 'Patient\'s respiration ?',
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
        'You are not eligible for CMRS',
        choice1: '',
        choice2: ''),
    //8
    Story(
        storyTitle:
        'You are dead',
        choice1: '',
        choice2: ''),
    //9
    Story(
        storyTitle:
        'Immediate',
        choice1: '',
        choice2: ''),
    //10
    Story(
        storyTitle:
        'Delayed',
        choice1: '',
        choice2: '')
  ];

  void nextStory(int choiceNumber) {



    /*else if (_storyNumber == 3 || _storyNumber == 4 || _storyNumber == 5) {
      restart();
    }*/


    if (_storyNumber == 0){
      if (choiceNumber == 1){
        _storyNumber = 7;
      } else {
        _storyNumber = 1;
      }
    }
    else if (_storyNumber == 1){
      if (choiceNumber == 1){
        _storyNumber = 3;
      } else{
        _storyNumber = 2;
      }
    }
    else if (_storyNumber == 2){
      if(choiceNumber == 1){
        _storyNumber = 3;
      }else {
        _storyNumber = 8;
      }
    }
    else if (_storyNumber == 3){
      if (choiceNumber == 1){
        _storyNumber = 4;
      }else {
        _storyNumber = 9;
      }
    }
    else if (_storyNumber == 4){
      if (choiceNumber == 1){
        _storyNumber = 5;
      }else{
        _storyNumber = 9;
      }
    }
    else if (_storyNumber == 5){
      if(choiceNumber == 1){
        _storyNumber = 6;
      }else{
        _storyNumber = 9;
      }
    }
    else if (_storyNumber == 6){
      if(choiceNumber == 1) {
        _storyNumber = 10;
      }else {
        _storyNumber = 9;
      }
    }
  }

  void restart() {
    _storyNumber = 0;
  }


  bool alert(){
    if(_storyNumber ==9) {
      return true;
    }
    else{
      return false;
    }


  }
















  //TODO: Step 23 - Use the storyNumber property inside getStory(), getChoice1() and getChoice2() so that it gets the updated story and choices rather than always just the first (0th) one.

//TODO: Step 8 - Create a method called getStory() that returns the first storyTitle from _storyData.
  String getStory() {
    return _storyData[_storyNumber].storyTitle;
  }

//TODO: Step 11 - Create a method called getChoice1() that returns the text for the first choice1 from _storyData.
  String getChoice1() {
    return _storyData[_storyNumber].choice1;
  }

//TODO: Step 12 - Create a method called getChoice2() that returns the text for the first choice2 from _storyData.
  String getChoice2() {
    return _storyData[_storyNumber].choice2;
  }

//TODO: Step 16 - Create a property called storyNumber which starts with a value of 0. This will be used to track which story the user is currently viewing.

  //TODO: Step 25 - Change the storyNumber property into a private property so that only story_brain.dart has access to it. You can do this by right clicking on the name (storyNumber) and selecting Refactor -> Rename to make the change across all the places where it's used.
  int _storyNumber = 0;

//TODO: Step 17 - Create a method called nextStory(), it should not have any outputs but it should have 1 input called choiceNumber which will be the choice number (int) made by the user.

//TODO: Step 20 - Download the story plan here: https://drive.google.com/uc?export=download&id=1KU6EghkO9Hf2hRM0756xFHgNaZyGCou3

//TODO: Step 27 - Create a method called buttonShouldBeVisible() which checks to see if storyNumber is 0 or 1 or 2 (when both buttons should show choices) and return true if that is the case, else it should return false.
  bool buttonShouldBeVisible() {
    //You could also just check if (_storyNumber < 3)
    if (_storyNumber == 7 || _storyNumber == 8 || _storyNumber == 9 || _storyNumber == 10 ) {
      return false;
    } else {
      return true;
    }
  }
}
