class Slider {
  int w, h;
  int x, y;
  
  String leftLabel, rightLabel;


  int value = 0;
  
  boolean active = false;
  
  color backgroundColor = color(220, 245, 255);
  color radioColor = color(0, 142, 199);
  color radioStaticColor =  color(0, 142, 199);
  color radioHoverColor = color(0, 117, 164);
  color fontColor = color(255);
  

  public Slider( int xPos, int yPos, int wid, int hei, String left, String right) {
    x = xPos;
    y = yPos;
    w = wid;
    h = hei;
    leftLabel = left;
    rightLabel = right;
  }
 
  void SliderClicked(){
    if(active){
       value = value == 1 ? 0: 1;
       print("\n New Value: " + value);
    }
  }

  void DrawSlider() {
    if ((mouseX > x-w/2 && mouseX < x + w/2) && (mouseY > y && mouseY < y + h)) {
      radioColor = radioHoverColor;
      active = true;
    } else {
      radioColor = radioStaticColor;
      active = false;
    }
    
    //Background
    fill (backgroundColor);
    rect(x-w/2, y, w, h);

    //Radio button
    fill(radioColor);
    if(value == 0){
      rect(x - w/2, y, w/2 , h);
      
      noStroke();
      fill(backgroundColor);
      rect(x - w/4 - 1, y + (h*.45/2), 2, h*.55);
    }else{
      rect(x, y, w/2, h);
      
      noStroke();
      fill(backgroundColor);
      rect(x + w/4 + 1, y + (h*.45/2), 2, h*.55);
    }
    
    textAlign(CENTER, CENTER);
    fill(fontColor);
    textSize(17);
    text(leftLabel, x - w*.85, y + h/2);
    text(rightLabel, x + w*.85, y + h/2);
  }
}
