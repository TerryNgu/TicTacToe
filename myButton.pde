/**
* This class respresents a button that the user can press to select a spot on the board.
* The class also contains a marker object simply for displaying, this marker is not checked
* to verify rules, this is done in the Map class
*/

class Button {
  
  private String label;
  private float x,y; //pixel position
  private float w,h; // width & height
  private Marker m;
 
   /**
   * Button contructor to set up size, location and text of button
   * @param labelB the text to display
   * @param xpos the x where the button begins
   * @param ypos the y where the butotn begins
   * @param widthB the width of the button
   * @param heightB the height of the button
   * @param mark the marker for the button, given null if it is a standard button
   */
  public Button(String labelB, float xpos, float ypos, float widthB, float heightB, Marker mark) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
    m = mark;
  }//end Button constructor
  

  /**
   * Draw the button
   */
  public void display(){
      rect(x,y,w,h);
      fill(59,59,61);
      textSize(36); 
      text(label,x+w/4, y+h*.8);
      fill(185,185,189);  
  }//end display()
  
   /**
   * Overloaded display method to explicatly set the text size and button fill color
   * @param txtSize the size of the text for the button
   * @param c the color for the button 
   */ 
   public void display(int txtSize, color c){
      fill(c);  
      rect(x,y,w,h);
      textSize(txtSize);
      fill(0);
      text(label,x+w/4, y+h*.8);
      fill(185,185,189);
  }//end display(int txtSize, color c)
  
 /**
 * Draw the button to suggest a move to the user
 * @param sign the sign of the player
 */
  public void displayAdvice(String sign){
      label = sign;
      rect(x,y,w,h);
      fill(138, 255, 255);
      textSize(28); 
      text(label,x+w/4, y+h*.8);
      
      //displaying hint label  
      fill(235, 64, 52);
      rect(x+8,y+2,35,15);
      fill(0,0,0);
      textSize(10);
      text("HINT",x+13,y+14);
      textSize(36);
      
      fill(185,185,189);
  }//end displayAdvice(String sign)


   /**
   * Update the label in the button
   * @param s the new label for the button
   */ 
  public void updateLabel(String s){
    label = s;
  }//end updateLabel(String s)
  
   /**
   * check if the coordinates given are inside the button 
   * @param mx the x coordinate of the mouse
   * @param my the y coordinated of the mouse
   * @return true point is inside the button
   */
  public boolean isInside(float mx, float my){
    if ((mx > x && mx < x + w) && (my > y && my < y + h) ){
      return true;
    }//end checing if given cordinates are inside the button box
    return false;
  }//end isInside(float mx, float my)
  
   /**
   * retrieved the x coordinate of the marker in the button
   * @return the x coordinate
   */
  public int getX(){
     return m.getX(); 
  }//end getX()
  
    /**
   * retrieved the y coordinate of the marker in the button
   * @return the y coordinate
   */
  public int getY(){
     return m.getY(); 
  }//end getY()
 
   /**
   * retrieved the marker in the button 
   * @return marker
   */
 public Marker getMarker(){
  return m; 
 }//end getMarker()
 
  
 /**
  * sets the label X or O for the button to display
  * @param markerType int representation of X or O 
  */
 public void pressed(Sign markerType){
    m.setSign(markerType);
    if (m.getSign() == Sign.X)
      label = "X";
    else if (m.getSign() == Sign.O)
      label = "O";
  }//end pressed(Sign markerType)

  /**
  * resets the label to an empty string
  */
  public void resetLabel(){
    label = " ";
  }//end resetLabel()
 
  @ Override
  /**
   * Override the equals method to check the maker passed equals the marker in button
   * @param o the Object to be compared
   */
   public boolean equals(Object o){
    if(o instanceof Marker){
      Marker other = (Marker) o;
      if(this.getX() == other.getX()){
      if(this.getY() == other.getY()){
        return true;
      }//end checking if Y cord is equal
      }//end checking if X cord is equal
    }//end checking if object passed is type Marker
    return false;
  }//end equals(Object o)
  
}//end Button class
