class Button{
  int w, h;
  int x, y;
  
  String label;

  int value = 0;
  boolean active = false;
  
  color buttonColor = color(220, 245, 255);
  color buttonStaticColor = color(220, 245, 255);
  color buttonActiveColor = color(0, 142, 199);
  color buttonHoverColor =  color(0, 117, 164);
  color fontColor = color(0);
  

  public Button( int xPos, int yPos, int wid, int hei, String text) {
    x = xPos;
    y = yPos;
    w = wid;
    h = hei;
    label = text;
  }
 
  void ButtonClicked(){
    if(active){
       value = value == 1 ? 0: 1;
    }
  }
  
  void ResetButton(){
     value = 0; 
  }

  void DrawButton() {
    
    if ((mouseX > x-w/2 && mouseX < x + w/2) && (mouseY > y && mouseY < y + h)) {
      buttonColor = buttonHoverColor;
      active = true;
    } else {
      buttonColor = value == 0? buttonStaticColor : buttonActiveColor;
      active = false;
    }
    
    if(value == 1){
      strokeWeight(2);
      stroke(buttonStaticColor); 
    }
    
    //Background
    fill (buttonColor);
    rect(x-w/2, y, w, h);
    
    noStroke();

    
    textAlign(CENTER, CENTER);
    fill(fontColor);
    textSize(17);
    text(label, x, y + h/2);
  }
}
