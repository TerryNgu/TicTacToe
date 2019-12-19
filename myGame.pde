import java.util.ArrayList;
import java.time.LocalDateTime;
import java.time.temporal.ChronoField;
/**
* This class is the controller for the game, it handles the turns, determines the hints to show, determines the 
* move for the bot, when the game has ended and the result. 
*/
class Game{

  private Map map;
  private boolean isHumanTurn;
  private Sign humanSign;
  private Sign botSign;
  private boolean isGameOver;
  private boolean newGame;
  private boolean isTestMode;
  private int countDownNumber;
  private LocalDateTime basedTime;
  private LocalDateTime timeNow;
  private int countDown;
  private int totalTime;

   
    /**
   * Constructor for game, initialized variables and calls randomSelect()
   */
  public Game(){
    newGame = true;
    isGameOver = false;
    map = new Map();
    //randomly assign X,O
    randomSelect();
    totalTime = 0;
  }//end game constructor
  
   /**
   * Randomly assigns X and O to bot and player
   */
  private void randomSelect(){
    int random = int(random(1,3));
    //if random = 1 human is X, and will play first
    if (random ==1){
      isHumanTurn = true;
      humanSign = Sign.X;
      botSign = Sign.O;
    }//end random case 1, player is X, bot is 0
    //if random = 2 bot is X, and will play first
    else{
      isHumanTurn = false;
      botSign = Sign.X;
      humanSign = Sign.O;
    }//end random case 2, player is 0, bot is x
  }//end randomSelect()
  
  /**
  * Finds the best spot on the board to suggest to the player
  * @return the Marker that should be played
  */
    public Marker getAdvice(){
    ArrayList<Marker> adviceList = new ArrayList<Marker>();
    Sign currentTurn;
    if(isHumanTurn())
      currentTurn = humanSign;
    else 
      currentTurn = botSign;
      

    //check if advice gives winning move
    adviceList = getAdviceAUX(adviceList, Line.ROW);
    adviceList= getAdviceAUX(adviceList, Line.COL);
    adviceList = getAdviceAUX(adviceList, Line.DIAGONAL_UP);
    adviceList = getAdviceAUX(adviceList, Line.DIAGONAL_DOWN);
    
    for (int i = 0; i < adviceList.size(); i++){
       if(adviceList.get(i).getSign() == currentTurn)
         return adviceList.get(i);
    }//end searching through list for advice matching sign of current turn (a winning move)
    if(adviceList.size() > 0)
      return adviceList.get(0);
    
    return null; 
  }//end getAdvice()
  
  /**
  * Helper meathod to getAdvice() that checks a specific line on the board
  * @ line the specific condition to be checked
  * @ return the suggested marker to be played
  */
  private ArrayList<Marker> getAdviceAUX(ArrayList<Marker> list, Line line){
      ArrayList<Marker> myLine = null;
      
      for(int i = 0; i < 3; i++){
         myLine = map.collectLine(i, line);
         Marker advice = null;
         int xCount = 0;
         int oCount = 0;
         int emptyCount = 0;
        
         for(int k = 0; k < 3; k++){
             Sign curSign = myLine.get(k).getSign();
             if(curSign == Sign.X){xCount++;}
             if(curSign == Sign.O){oCount++;}
             if(curSign == Sign.EMPTY){
               emptyCount++;
               advice = new Marker(myLine.get(k).getX(),myLine.get(k).getY());
             }//end if current marker was empty
         }//end traversing through line of markers
         if((xCount > 1 || oCount > 1) && emptyCount == 1){
          if (xCount == 2)
            advice.setSign(Sign.X);
          else
            advice.setSign(Sign.O);
            
          list.add(advice);
       }//end assigning Marker to complete a winning line
      }//end traversing though lines requested
      return list;
  }
  
    /**
   * Checks if the game board is full
   * @return true if not open spots remain
   */
  public boolean isFull(){
    return map.isFull();
  }//end is Full()
  
    /**
   * checks if the game is over
   * @param turn is the player who last went
   * @return true if the game is over
   */
  public boolean isGameOver(Sign turn){
    if (turn == Sign.EMPTY)
      return false;
    ArrayList<Marker> markerArray = new ArrayList<Marker>();
    
    //pulling all of the Marker that has sign of X or O and storing in arraylist
    for(int row = 0; row < 3; row++){
      for(int col = 0; col <3; col++){
          if(map.getMarkerSign(row, col) == turn ){
            markerArray.add(map.getMarker(row,col));
          }//end adding markers with matching sign
      }//end col traverse
    }// end row traverse

    //can't be over cause less than 3 marker exist
    if(markerArray.size() < 3){
      return false;  
    }//end checking size < 3
    else{
      //checking for same type X/O. If three of same type exist then game over
      for(int i = 0; i < 3; i++){
        int row= 0;
        int col = 0;
        //looping through arraylist of marker to check if same type occurred
        for(int j = 0; j < markerArray.size(); j++){
            if(markerArray.get(j).getX() == i){
              row++; 
              if(row == 3){
              return true;
              }//end finding 3 of a kind in same row
            }//end comparing array of markers to current row 
            if(markerArray.get(j).getY() == i){
              col++;
              if(col == 3){
              return true;
              }//end finding 3 of a kind in same col
            }//end comparing array of markers to current col
        }//end traversing arraylist
      }//end for loop checking wins in col and rows
    }// end else body when size is > 3
    //Checking special cases for the two diagonal
    //0,0
    boolean topLeftCorner = false;
    //2,0
    boolean topRightCorner = false;
    //0,2
    boolean bottomLeftCorner = false;
    //2,2
    boolean bottomRightCorner = false;
    
    for(int i = 0; i < markerArray.size();i++){
      if(markerArray.get(i).getX() == 1 && markerArray.get(i).getY() == 1){
        for(int j = 0; j < markerArray.size(); j++){
            Marker currTemp = markerArray.get(j);
            int row = currTemp.getX();
            int col = currTemp.getY();
            
            if(row == 0 && col == 0){topLeftCorner = true;} // top left corner matches
            if(row == 2 && col == 0){topRightCorner = true;} // top right corner matches
            if(row == 0 && col == 2) {bottomLeftCorner = true;} // bottom left corner matches
            if(row == 2 && col == 2) {bottomRightCorner = true;} //bottom right corner matches
        }//end traversing through markerArray 
        if(topLeftCorner && bottomRightCorner){ return true;} // special case matches
        if(topRightCorner && bottomLeftCorner){return true;} // special case matches
       }//end checking win thats not a row or col
    }//end traverse through markerArray
    return false;
  }//end isGameOver(Sign turn)
  
 
    /**
   * switches human players turn
   * @param turn boolean value for isHumanTurn 
   */
  public void rotateTurn(boolean turn){
    isHumanTurn = turn;
    //game is in session
    newGame = false;
  }//end rotateTurn(boolean turn)
 
  
   /**
   * Sets the marker of the button the the appropiate sign
   * @param x the x coordinate of the marker
   * @param y the y coordinate of the marker
   * @return the sign of the update
   */
  public Sign userSelection(int x, int y){
    Marker temp = new Marker(x,y);
    if(isHumanTurn()){
      temp.setSign(humanSign);
      //player took turn, computer turn now
      if (map.setMarkerStatus(temp)){
        rotateTurn(false);
        totalTime = totalTime + (time - getTime());
        return humanSign;   
       }//end saving marker in map
    }//end checking if its players turn
    else 
      if(isTestMode()){
          temp.setSign(botSign);
          if (map.setMarkerStatus(temp)){
            rotateTurn(true);
            return botSign;
          }//end saving marker in map
      }//end checking if it is test mode
    return Sign.EMPTY;
  }//end userSelection(int x, int y)
  
   /**
   * allows robot to make selection and return a Marker object that contains X,Y and its Sign
   * @return the chosen marker
   */
  public Marker botSelection(){
      ArrayList<Marker> forkPossibility = null;
      int xCount = 0;
      int oCount = 0;
 
      //if player can win block or if bot can win then take win
      Marker botMarker = getAdvice();
     
      //if situation above does not exist
      if(botMarker == null){
        //take center if players goes first
        if(!map.isNewMap() && map.isEmpty(1,1) && humanSign == Sign.X){
            botMarker = new Marker(1,1);
        }//end selecting center 
        else if(map.getMarker(1,1).getSign() == botSign) {
            //if bot played center then play and side
            botMarker = map.findSide();
        }//end playing a edge
        else
          botMarker = map.findCorner();
      }//end checking if botMarker is null, which results from no good advice generated
      
      
      //Preventing Player from forking bot
      if((map.turnsTaken(humanSign) < 3) && botSign == Sign.O && botMarker == null){
          //checking if player is trying to create a fork
          forkPossibility = map.collectLine(1,Line.DIAGONAL_UP);
           xCount = countSignIn(forkPossibility, Sign.X);
           oCount = countSignIn(forkPossibility,Sign.O);
           if((xCount == 2 && oCount ==1) || (xCount == 1 && oCount ==2)){
                botMarker =  map.findSide();
           }//end blocking fork 
      
          forkPossibility = map.collectLine(1,Line.DIAGONAL_DOWN);
          xCount = countSignIn(forkPossibility, Sign.X);
          oCount = countSignIn(forkPossibility,Sign.O);
          if((xCount == 2 && oCount ==1) || (xCount == 1 && oCount ==2)){
             botMarker = map.findSide();
         }//end blocking fork
      }//end blocking fork cases
      
      //Attempting to fork Player
      if(map.turnsTaken(humanSign) == 1 && !map.isEmpty(1,1) && botSign == Sign.X){
           //checking diagonal up for forking possibility 
           forkPossibility = map.collectLine(1,Line.DIAGONAL_UP);
           xCount = countSignIn(forkPossibility, Sign.X);
           oCount = countSignIn(forkPossibility,Sign.O);
           if((xCount == 1 && oCount ==1) || (xCount == 1 && oCount ==1)){
              for(int i = 0; i < forkPossibility.size(); i++){
                  if(forkPossibility.get(i).getSign() == Sign.EMPTY)
                      botMarker = forkPossibility.get(i);
              }// end traverse through forkPossibility
           }//end comparing x and o counts
              
           //checking diagonal down for forking possibility 
           forkPossibility = map.collectLine(1,Line.DIAGONAL_DOWN);
           xCount = countSignIn(forkPossibility, Sign.X);
           oCount = countSignIn(forkPossibility,Sign.O);
           if((xCount == 1 && oCount ==1) || (xCount == 1 && oCount ==1)){
              for(int i = 0; i < forkPossibility.size(); i++){
                  if(forkPossibility.get(i).getSign() == Sign.EMPTY)
                      botMarker = forkPossibility.get(i);
              }//end traverse through forkPossibility
           }//end comparing x and o count
      }//end fork attempt
     
      //if no advice was given, fork was not blocked and corners are taken then just pick empty slot
      if(botMarker == null){
          botMarker = map.findEmpty();
      }// end picking an open spot if botMarker is still null
      
      botMarker.setSign(botSign);
      map.setMarkerStatus(botMarker);
      rotateTurn(true);

      return botMarker;
     
    }//end botSelection()

    /**
   * check if it is currently the human player's turn
   * @return true if it is the human player's turn
   */
  public boolean isHumanTurn(){
     return isHumanTurn; 
  }//end isHumanTurn()
  
    /**
   * retrieve the sign assigned to the human player
   * @return the sign of the human player
   */
    public Sign getHumanSign(){
      return humanSign;
  }//end getHumanSign()
  
    /**
   * displays the results of the game
   * @param player the play who last completed a turn
   */
  public void displayWinner(Sign player){
     String message;
     if (humanSign == player)
       message = "Impressive! You won! \nTurns Taken: " + map.turnsTaken(humanSign);
     else if (botSign == player)
       message = "The computer is better than you ! ";
     else 
       message = "                      Tied game!";
       
     String average = String.format("%.02f", (double)totalTime / map.turnsTaken(humanSign));
     message = message + "\n    Average turn time: " + average + " sec";
      
    
      noStroke();
      fill(153,14,14);
      textSize(20);
      text(message, 100, 280 );
      fill(225,225,225);
      
      fill(87,87,87);
      stroke(0,0,0);
      rect(163,346,79,30);
      rect(250,346,79,30);
      
      
      fill(145,144,144);
      textSize(15);
      text("Play Again",165,365);
      text("Quit?",270,365);
      fill(225,225,225);
      
      isGameOver = true;
  }//end displayWinner(Sign player)
  
     /**
    * checks if the player clicked quit
    * @param mx the x coordinate of the mouse
    * @param my the y coordinate of the mouse
    * @return true if quit was selected
    */
  public boolean isQuit(int mx, int my){
    if(isGameOver){ 
        if ((mx > 250 && mx < 250 + 79) && (my > 346 && my < 346 + 30) )
          return true;
        return false;
    }//end checking if quit selected
    return false;
  }//end isQuit(int mx, int my)
  
     /**
    * checks if the player clicked play again
    * @param mx the x coordinate of the mouse
    * @param my the y coordinate of the mouse
    * @return true if play again was selected
    */
   public boolean isPlayAgain(int mx, int my){
    if(isGameOver){ 
        if ((mx > 163 && mx < 163 + 79) && (my > 346 && my < 346 + 30)){
          map.reset();
          randomSelect();
          return true; 
        }//end checking if mouse in box
        return false;
    }//end checking if game is over
    return false;
  }//end isPlayAgain(int mx, int my)
  
  /**
  * checks if it is a new game
  * @return true if it is a new game
  */
  public boolean isNewGame(){
      return newGame;
  }//end isNewGame()
  
    /**
  * checks if it is in test mode
  * @return true if it is in test mode
  */
  public boolean isTestMode(){
    return isTestMode;
  }//end isTestMode()
  
  /**
  * switches the test mode into the opposite current state
  */
  public void toggleTestMode(){
    if(isTestMode()) 
      isTestMode = false;
    else
      isTestMode = true;
  }//end toggleTestMode()
  
  /**
  * Finds the count of markers  in specific line
  * @param line the arraylist of markers to be checked
  * @param sign the sign to be checked
  * @return the count calculated
  */
  private int countSignIn(ArrayList<Marker> line, Sign sign){
    int count = 0; 
    
    for(int i = 0; i < line.size(); i++){
      if(line.get(i).getSign() == sign){
      count++;
      }//end checking if marker matches sign
    }//end traverse through line
    return count;
  }//end countSignIn(ArrayList<Marker> line, Sign sign)
  
  /**
  * Setting the based time, meaning if current second in time is 10 and timer is every 5 seconds then 
  * based time will be set to 15 seconds
  * @param time is second desire for the time limit 
  **/
  public boolean setTimer(int time){
    countDownNumber = time;
    basedTime = LocalDateTime.now();
    basedTime = basedTime.plusSeconds(time);
    return true;
  }
  /**
  * Calcualates the time being counted down
  */
  public int getTime(){
    //setting the timeNow, which will be used in isTimeUp()
    timeNow = LocalDateTime.now();
    
    int secBased = basedTime.get(ChronoField.SECOND_OF_MINUTE);
    int secNow = timeNow.get(ChronoField.SECOND_OF_MINUTE);
    int minBased = basedTime.get(ChronoField.MINUTE_OF_HOUR);
    int minNow = timeNow.get(ChronoField.MINUTE_OF_HOUR);
  
   //this mean the second reset, and adding one min to based. 
   //SecBased is now less than second now because it reached 60 and reset to 0 
   if(minBased > minNow){
      countDown = (secBased + 60) - secNow;
   }else{
       countDown = secBased - secNow;
   }//end if minBase > minNow
   
   return countDown;
    
  }//end getTime()
  
  /**
  * Checks if the time has expired
  * return true if time is up
  */
  public boolean isTimeUp(){
    //calling getTime so that timeNow can be reset
    getTime();
    
    if(basedTime.compareTo(timeNow) < 0){
      setTimer(countDownNumber);
      return true;
    }else{
      return false;
    }//end comparing if current time is less than 0
  
  }
  
  /**
  * Make a random selection on the board
  * @return the random marker
  */
  public Marker randomSelction(){
     Marker random = map.findEmpty();
     random.setSign(humanSign);
     rotateTurn(false);
     totalTime = totalTime + (time - getTime());
     return random;
  }
  
  /**
  * Resets all the values of the game, this was needed because it caused a null pointer
  * if a game object was reassigned to a new instantiation of game
  */
  public void resetGame(){
       newGame = true;
    isGameOver = false;
    map = new Map();
    //randomly assign X,O
    randomSelect();
    totalTime = 0; 
  }//end resetGame()
  
}//end Game class
