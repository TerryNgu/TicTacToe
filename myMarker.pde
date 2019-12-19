public enum Sign {EMPTY, X , O;}

  
class Marker{
 
  int x;
  int y; 

  Sign sign;
  /**
 * Maker Constructor
 * @param newX x coordinate
 * @param newY y coordinate
 */
  public Marker(int newX, int newY){
    x = newX; 
    y = newY; 
    sign = Sign.EMPTY;
  }//end Marker constructor
  
  /**
 * Retrieves the attribute y
 * @return y
 */
  public int getY(){
  return y;
  }//end getY()
  
  /**
 * Retrieves the attribute x
 * @return x
 */
  public int getX(){
  return x;
  }//end getX()
  
  /**
 * Retrieves the attribute sign
 * @return sign
 */
  public Sign getSign(){
    return sign;
  }//end getSign()
  
  /**
 * Modify the sign
 *@param s the sign to be set
 */
  public void setSign(Sign s){
   sign = s ;
  }//end setSign()
  
}//end Marker class
