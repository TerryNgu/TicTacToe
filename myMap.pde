public enum Line {ROW, COL, DIAGONAL_UP, DIAGONAL_DOWN;}

class Map{
  
  private Marker [][]grid;
    /**
   * Constructor for map, initializes all markers in the board
   */
  public Map(){
    grid = new Marker[3][3];
    for(int row = 0; row < 3; row++){
      for(int col = 0; col <3; col++){
          Marker temp = new Marker(row,col);
          grid[row][col] = temp;
      }//end col traverse
    }//end row traverse
  }//end map constructor
  
    /**
   * updates the status of the Marker
   * @param m the marker that needs to be set
   * @return true if update was valid (spot was not occupied) 
   */
  public boolean setMarkerStatus(Marker m){
      int row = m.getX();
      int col = m.getY();
      
      if(isEmpty(row,col)){
         grid[row][col].setSign(m.getSign());
         return true;
      }//end checking if location is empty
        return false;
  }//end setMarkerStatus(Marker m)
  
  /**
  * returns all the markers to of a requested line
  * @param index the specific row or colum to be collected
  * @param line the type of line to be collected
  * @return the arraylist of the collected markers
  */
   public ArrayList collectLine(int index, Line line){
    ArrayList<Marker> collection = new ArrayList();
    
    if(line == Line.ROW ){
      for(int i = 0; i < 3; i++){
          collection.add(grid[i][index]);
      }//end traversing row
    }//end if line requested was row
    else if(line == Line.COL){
       for(int i = 0; i < 3; i++){
          collection.add(grid[index][i]);
      }//end traversing col
    }//end if line requested was col
    else if (line == Line.DIAGONAL_UP){
       collection.add(grid[2][0]);
       collection.add(grid[1][1]);
       collection.add(grid[0][2]);
    }//end if line requested was diaganol up
    else if(line == Line.DIAGONAL_DOWN){
       collection.add(grid[0][0]);
       collection.add(grid[1][1]);
       collection.add(grid[2][2]);
    }//end if line requested was diagonal down
  
    return collection;
  }//end collectLine(int index, Line line)
  
  /**
  * retrieves the marker a specified location
  * @param r the row of the marker
  * @param c the col of the marker
  * @return the marker at (r, c)
  */
  public Marker getMarker(int r, int c){
    return grid[r][c];
  }//end getMarker(int r, int c)
  
    /**
   * retrieves the marker a specified location
   * @param r the row of the marker
   * @param c the col of the marker
   * @return the sign of the marker at (r,c)
   */
  public Sign getMarkerSign(int r, int c){
    Marker temp = grid[r][c];
    return temp.getSign();
  }//end getMarkerSign(int r, int c)
  
    /**
   * checks if the marker a specified location is empty
   * @param r the row of the marker
   * @param c the col of the marker
   * @return true if the marker is empty
   */
  public boolean isEmpty(int r, int c){
    if(grid[r][c].getSign() != Sign.EMPTY){
      return false;
    }//end checking if location was empty
    return true;
  }//end isEmpty(int r, int c)
  
    /**
   * checks all the makers int the board are full
   * @return true no open markers remain
   */
  public boolean isFull(){
     for(int row = 0; row < 3; row++){
      for(int col = 0; col <3; col++){
        Sign currStatus =  grid[row][col].getSign();
        //loop through every marker on map and if there is empty marker then false
        if(currStatus == Sign.EMPTY)
            return false;
         
      }//end travrse through col
    }//end traverse through row
    return true;
     
  }//end isFull()
  
   /**
   * resets all the marker status to 0
   */
  public void reset(){
    for(int row = 0; row < 3; row++){
      for(int col = 0; col <3; col++){
          grid[row][col].setSign(Sign.EMPTY);
      }//end traverse through col
    }//end traverse through row
  }//end reset()
  
   /**
   * finds an avaibale corner and returns the marker
   * @return return an empty corner
   */
  public Marker findCorner(){
    ArrayList<Marker> emptyCorners = new ArrayList<Marker>();
    if(grid[0][0].getSign() == Sign.EMPTY)
      emptyCorners.add(getMarker(0,0));
    if(grid[0][2].getSign() == Sign.EMPTY)
      emptyCorners.add(getMarker(0,2));
    if(grid[2][0].getSign() == Sign.EMPTY)
      emptyCorners.add(getMarker(2,0));
    if(grid[2][2].getSign() == Sign.EMPTY)
      emptyCorners.add(getMarker(2,2));
      
    //create arbritary marker
      Marker cornerMarker = null;
      int random = int(random(0,emptyCorners.size()));
      if (emptyCorners.size() !=0){
      cornerMarker = emptyCorners.get(random);
      }//end checking if array is not empty
      return cornerMarker;
    
  }//end findCorner()
  
    /**
   * finds an avaibale edge and returns the marker
   * @return return an edge marker
   */
  public Marker findSide(){
    ArrayList<Marker> emptySides = new ArrayList<Marker>();
    if(grid[0][1].getSign() == Sign.EMPTY)
      emptySides.add(getMarker(0,1));
    if(grid[1][0].getSign() == Sign.EMPTY)
      emptySides.add(getMarker(1,0));
    if(grid[1][2].getSign() == Sign.EMPTY)
      emptySides.add(getMarker(1,2));
    if(grid[2][1].getSign() == Sign.EMPTY)
      emptySides.add(getMarker(2,1));
      
      //create arbritary marker
      Marker sideMarker = null;
      int random = int(random(0,emptySides.size()));
      if (emptySides.size() !=0){
          sideMarker = emptySides.get(random);
      }//end checking if array is not empty
      return sideMarker;
 
  }//end findSide()
  
     /**
   * finds an avaiable spot and returns random marker
   * @return return an open spot marker
   */
  public Marker findEmpty(){
    ArrayList<Marker> emptySlots = new ArrayList<Marker>();
     for(int row = 0; row < 3; row++){
        for(int col = 0; col < 3; col++){
              if(grid[row][col].getSign() == Sign.EMPTY)
                  emptySlots.add(grid[row][col]);
        }//end col traverse
      }//end row traverse
      //create arbritary marker
      Marker emptyMarker = null;
      int random = int(random(0,emptySlots.size()));
      if (emptySlots.size() !=0){
          emptyMarker = emptySlots.get(random);
      }//end checking if array is empty
      return emptyMarker;
      
  }//end findEmpty()
  
  /**
  * Finds how many turns were taken by requested sign
  * @param the sign to be checked
  * @return the count of markers
  */
  public int turnsTaken(Sign s){
    int count = 0;
     for(int row = 0; row < 3; row++){
      for(int col = 0; col <3; col++){
        if( s ==   grid[row][col].getSign() )
          count ++;
      }//end col traverse
    }//end row traverse
    return count;
  }//end turnsTaken(Sign s)
  
  /**
  * Check if the map has been marked with X or O
  *@return true if no X or O exist in map
  **/
  public boolean isNewMap(){
      for(int row = 0; row < 3; row++){
        for(int col = 0; col < 3; col++){
              if(grid[row][col].getSign() != Sign.EMPTY)
                  return false;
        }//end col traverse
      }//end row traverse
      return true;
  }//end isNewMap()
  
}//end Map class
