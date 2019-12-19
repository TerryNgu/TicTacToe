/**
* This class is the sketch class in processing, it handles the inputs from the user. When the user clicks the mouse
* it finds the button that was pressed, the Marker in the button is updated with the sign of the player if it is not
* a taken spot. It also displays a hint to the use when the user hovers over a spot on the Tic Tac Toe board
* @version 2.0 the computer plays strategically and also offers hints to the player
*/

import java.time.LocalDateTime;

private PFont title;
private String mySign = "";
private ArrayList<Button> button;
private Game game = new Game();
private Button testButton;
private Button adviceButton = null;
private Frame timerPrompt;
private boolean timerSet;


CustomSlider timerSilder;
private int time = 0;

void setup(){

  size(500,450);
  title = createFont("Georgia",25);
  textFont(title);
  smooth();

   // controls
   cp5 = new ControlP5(this);
   game.setTimer(time);

  //each index in arraylist represented as follow:
  // 0 = top_right, 1 = top_middle, 2 = top_right, 3 = middle_left, 4 = middle_middle, 5= middle_right, 6 = bottom_left, 7 = bottom_middle, 8 = bottom_right
  button = new ArrayList<Button>();

  button.add( new Button("", 170,100,50,50, new Marker(0,0)));
  button.add( new Button("", 221,100,50,50, new Marker(1,0)));
  button.add(new Button("", 272, 100, 50, 50 , new Marker(2,0)));
  button.add(new Button("", 170, 151, 50, 50 , new Marker(0,1)));
  button.add(new Button("", 221, 151, 50, 50 , new Marker(1,1)));
  button.add(new Button("", 272, 151, 50, 50 , new Marker(2,1)));
  button.add(new Button("", 170,202,50,50, new Marker(0,2)));
  button.add(new Button("", 221,202,50,50, new Marker(1,2)));
  button.add(new Button("", 272,202,50,50, new Marker(2,2)));

  testButton = new Button("Test Mode", 30,380, 160,30, null);

  timerPrompt = new Frame(70,100, 370, 200,"Sec");
  timerSet = false;



} //end setup()

void draw(){
  game.isTimeUp();
  background(0);
  
  background(132,132,135);
  textSize(36);
  text("Tic-Tac-Toe",155,60);
  stroke(8,8,10);

  textSize(15);
  text("Your Sign",30,130);
  
  if(game.isHumanTurn()){
     textSize(20);
     text("Time",400,130);
     textSize(38);
     text(String.valueOf(game.getTime()),405,170);  
  }
  
  textSize(25);

  if(game.getHumanSign() == Sign.X)mySign = "X";
  else mySign = "O";
  text(mySign, 55, 160);


   //if computer is first
  if (!game.isHumanTurn() && game.isNewGame()){
    Marker botSelection = game.botSelection();
    updateButton(botSelection);

  }//end checking if computer needs to make selection

  //displaying every button
  for(int i = 0; i < 9; i++){
    button.get(i).display();
  }//end displaying buttons

  //display the test button, button is yellow when disengaged, red when engaged
  if(!game.isTestMode()){
    testButton.updateLabel("Test Mode: off");
    testButton.display(15, color(180,180,180));
  }//end dispaly test mode button with "off"
  else{
    testButton.updateLabel("Test Mode: on");
    testButton.display(15, color(148,232,136));
  }//end displaying test mode button with "on"

  //check if player is hovering over a button
  checkRollover();


  //Bot make a selection if it "IT's" turn and not in test mode. Also add a delay affect with framecount
  if((!game.isHumanTurn()) && ((frameCount%80) == 0) && (!game.isNewGame()) && (!game.isTestMode())){
       Marker botSelection = game.botSelection();
       updateButton(botSelection);
       game.setTimer(time);
  }// end bot selction
  
  if(timerSet && game.isHumanTurn () && game.getTime() == 0){
     Marker random = game.randomSelction();
     updateButton(random);
     //stall 1 sec prevent meathod executing twice during the same instance of a time expering
     delay(1000);
  }

  if(!timerSet)
    timerPrompt.display();


}// end draw()

void mousePressed(){
   boolean tl_pressed = button.get(0).isInside(mouseX, mouseY);
   boolean tm_pressed = button.get(1).isInside(mouseX, mouseY);
   boolean tr_pressed = button.get(2).isInside(mouseX, mouseY);
   boolean ml_pressed = button.get(3).isInside(mouseX, mouseY);
   boolean mm_pressed = button.get(4).isInside(mouseX, mouseY);
   boolean mr_pressed = button.get(5).isInside(mouseX, mouseY);
   boolean bl_pressed = button.get(6).isInside(mouseX, mouseY);
   boolean bm_pressed = button.get(7).isInside(mouseX, mouseY);
   boolean br_pressed = button.get(8).isInside(mouseX, mouseY);


   if( tl_pressed){ humanSelectionHandler(button.get(0)); }
   else if (tm_pressed){ humanSelectionHandler(button.get(1)); }
   else if (tr_pressed){ humanSelectionHandler(button.get(2)); }
   else if (ml_pressed){ humanSelectionHandler(button.get(3)); }
   else if (mm_pressed){ humanSelectionHandler(button.get(4)); }
   else if (mr_pressed){ humanSelectionHandler(button.get(5)); }
   else if (bl_pressed){ humanSelectionHandler(button.get(6)); }
   else if (bm_pressed){ humanSelectionHandler(button.get(7)); }
   else if (br_pressed){ humanSelectionHandler(button.get(8)); }
   else if (game.isQuit(mouseX,mouseY)){ exit(); }
   else if (testButton.isInside(mouseX, mouseY)) {game.toggleTestMode(); }
   else if (timerPrompt.isConfirmed(mouseX, mouseY) && !timerSet ){
     game.setTimer(time);
     cp5.remove("Sec");
     timerSet = true;
   }
   else if(game.isPlayAgain(mouseX,mouseY)){
     game.resetGame();
     timerSet = false;
     timerPrompt.resetFrame();
     //reset every label when game reset
     for(int i = 0; i < 9; i++){
        button.get(i).resetLabel();
     }//end resetting lables
     loop();
  }//end user selected play again button

}//end mousePressed()

/**
 * Updates the marker inside to button used to display status to the user
 * @param selection the specific button to be updated
 */
private void updateButton(Marker selection){
    //loop through every button to see if it is pressed, if yes then get X or O from status
    for(int i = 0; i < 9; i++){
      if(button.get(i).equals(selection)){
          button.get(i).pressed(selection.getSign());
      }//end matching marker with appropriate button
    }//end loop to find button
    if(game.isGameOver(selection.getSign())){
      draw();
      delay(500);
      game.displayWinner(selection.getSign());
      
      //check if player never hovered over the board the entirety of the game
      if(adviceButton != null)
        adviceButton.resetLabel();
      
      noLoop();
    }//end loop of ending game
    else if(game.isFull()){
      draw();
      delay(500);
      //Passing in EMPTY sign to notify display function that its a tie game.
      game.displayWinner(Sign.EMPTY);
            
      //check if player never hovered over the board the entirety of the game
      if(adviceButton != null)
        adviceButton.resetLabel();
      
      noLoop();
    }// end loop of tied game

}//end updateButton(Marker selection)
/**
 * updates the marker to be displayed when the user click on a button
 * @param b button that was pressed by the user
 * @return true when a open spot in the board was selected by the user
 */
private void humanSelectionHandler(Button b){
    //check if the frame to prompt for time is still up, if so ignore button selections on board
    if (!timerSet)
         return;
       Sign userSign = game.userSelection(b.getX(), b.getY());
       b.pressed(userSign);
       updateButton(b.getMarker());
}//end humanSelectionHandler(Button b)

/**
* Finds the button that matches to the location of given marker
* @param m the marker to be matched
* @return the button that was found
*/
private Button getAdviceButton(Marker m){
     for(int i = 0; i < button.size(); i++){
          if(button.get(i).equals(m)){
              return button.get(i);
          }//end if button found
      }//end button search
      return null;
}// end getAdviceButton(Marker m)

/**
* Checks if the play is hovering over a button and displays "blinking" hint
*/
private void checkRollover(){
      Marker advice = null;
      //change advice blink rate, don't display advice if game is over
      if(!((frameCount%30) < 15) && !(game.isGameOver(Sign.X) || game.isGameOver(Sign.O) || game.isFull())){
        //don't display if the bot is taking it's turn
        if(game.isHumanTurn()){
            for(int i = 0; i < 9; i++){
              if (button.get(i).isInside(mouseX, mouseY)){
                   advice = game.getAdvice();
                   if(advice != null){
                   adviceButton = getAdviceButton(advice);
                     adviceButton.displayAdvice(mySign);
                     adviceButton.resetLabel();
                   }// end displaying advice
              }//end checking if use is hovering over a button
           }//end button search
       }//end checking if its the humans turn
    }//end checking if hint should be displayed
}//end checkRolleover()

/**
*  When event is triggered time is set from the slider in frame object
*  @param theControlEvent the event that was triggered
*/
public void controlEvent(ControlEvent theControlEvent) {
    if (theControlEvent.isFrom("Sec")) {
        time = (int)theControlEvent.getController().getValue();
    }
}//end 


 
