/**
* This class serves a a pop up window with a slider and a button
* The slider allows the user to select a value in a range and the button
* confirms the selection from the user
*/

import controlP5.*;
ControlP5 cp5;


class Frame {
  private float x,y; //pixel position
  private float w,h; // width & height
  private Button exit;
  private String title;
  private CustomSlider slider;
  
  
  /**
  * Frame constructor
  * @param xpos the x cord where the window begins
  * @param ypos the y cord where the window begins
  * @param widthB the width of the window
  * @param heightB the hieght of the window
  * @param name the name of the slider
  */
  public Frame (float xpos, float ypos, float widthB, float heightB, String name){
   x = xpos;
   y = ypos;
   w = widthB;
   h = heightB;
   exit = new Button("Start Game",115,230,250,50,null);
   title = name;
  
   // changing font and font size for slider
   PFont p = createFont("Georgia",17); 
   ControlFont font = new ControlFont(p);
   cp5.setFont(font);
   
   slider = new CustomSlider(cp5, title);
   slider.setPosition(140, 160)
           .setColorValue(color(255, 0, 0))
           .setSize(200, 40)
           .setRange(3, 30)
           .setValue(8)
           .setColorForeground(color(11, 164, 230))
           .setColorBackground(color(255, 30));
  }
  
  /**
  * Displays the window with the slider and the button
  */
  public void display(){
     rect(x,y,w,h);
     textSize(25);
     fill(40, 43, 45); 
     text("Set Your Timer",160,140);
     fill(161, 157, 157);
      textSize(15);
     text("Drag bar here",190,185);
     fill(185,185,189); 
      exit.display(30, color (255,255,255));
      //time(int(timerKnob.value()));
  }
  
  /**
  * Checks if the user clicked inside the button of the window
  * @return true of the user clicked inside the button
  */
  public boolean isConfirmed(int x, int y){
    if (exit.isInside(x, y)){
      cp5.remove("time");
      return true;
     
    }
    else 
      return false;
  }
  

  /**
  * Resets the frame be displayed again after it has be closed previously,
  * must be done in this manner since processing UI can not stop displaying
  * an object unless it is removed manually
  */
  public void resetFrame(){
     slider = new CustomSlider(cp5, title);
     slider.setPosition(140, 160)
           .setColorValue(color(255, 0, 0))
           .setSize(200, 40)
           .setRange(3, 30)
           .setValue(8)
           .setColorForeground(color(11, 164, 230))
           .setColorBackground(color(255, 30));
    }

  }
  
  /**
  * A class to extend from slider to allow the use of integers values in slider
  */
  public class CustomSlider extends Slider{
          public CustomSlider(ControlP5 cp5 , String name){
             super(cp5,name);
          }
          @Override public Slider setValue( float theValue ) {
      super.setValue(theValue);
      //this can be improved, follow the CP5 component lifecycle to determine when an instance initialised in the constructor is ready
      _myValueLabel.set(String.valueOf(int(getValue( ))));
      return this;
    }
};
 
