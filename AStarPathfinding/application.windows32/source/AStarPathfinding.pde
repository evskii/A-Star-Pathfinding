/*
    Evan Williams - TUD Game Design Year 3 03/10/2021
    
    This is an example of how A* Pathfinding works. I used
    some online resources to figure out how the algorithim
    works and then translated the knowledge over to Processing.
    I wanted to challenge myself with the programming and chose
    to use Processing as it is a tool I haven't used in a long time.
    
    A* Resrouces I found extremely helpful:
      https://medium.com/@nicholas.w.swift/easy-a-star-pathfinding-7e6689c7f7b2
      https://www.youtube.com/watch?v=-L-WgKMFuhE&ab_channel=SebastianLague    
 */

//States of the app
enum States {
  Planning, //Where the player can use the tools to set up the algorithim
  Running, //The algorithim is actually running and finding the path
  End //The path has been found and we are displaying it now
}
States currentState;

enum PlanningStates {
  StartCell, //Placing the start cell
  DestCell, //Placing the end cell
  BlockedCell, //Drawing in the walls
  Nothing //Default state
}
PlanningStates currentPlanningState;

Cell mouseCell = new Cell(0, 0); //Used to store the mouse information for the Planning scene

boolean trackMouse = false;
boolean erase = false;

//Grid variables
int toolboxWidth = 200; //Width of the tool panel
int gridWidth;
int gridHeight;
int cellWidth = 20; //How wide to make the cells
int cellHeight = 20; //How tall to make the cells

//Lists to store cell data
ArrayList<Cell> openList = new ArrayList<Cell>();
ArrayList<Cell> closedList = new ArrayList<Cell>();
ArrayList<Cell> finalPath = new ArrayList<Cell>();
ArrayList<Cell> blockedCells = new ArrayList<Cell>();

//Start and destination cells
Cell startCell = new Cell(0, 0);
Cell destCell = new Cell(0, 0);

boolean endFound = false;//If we have found the end of the game

//Used in the AStar method to track the current cell we are evaluating
Cell current = new Cell(0, 0);
Cell last;


//Toolbox bits and bobs
Slider penSlider;
Button startCellButton;
Button destCellButton;
Button wallsButton;
Button clearWallsButton;
Button startButton;
Button restartButton;

//Colors for the cells
color backgroundColor = color(0, 18, 25); //Blackish
color startCellColor = color(255, 137, 202); //Pink
color destCellColor = color(202, 255, 137); //Green
color blockedCellColor = color(10, 147, 150); //Teal
color finalPathColor = color(155, 34, 38); //Red
color openListColor = color(155, 255, 10); //Lime
color closedListColor = color(233, 216, 166); //Cream
color toolboxColor = color(10, 18, 30);

void setup() {
  size(800, 600);
  gridWidth = width - toolboxWidth;
  gridHeight = height;

  //Add our start cell as the base cell in the openList
  openList.add(startCell);

  //Set our starting states
  currentState = States.Planning;
  currentPlanningState = PlanningStates.StartCell;
  
  InitToolbox();  
}

void draw() {
  clear(); //Clear the screen every frame
  background(backgroundColor); //Set background colour

  //Drawing items
  DrawGrid(); 
  DrawCells();
  Toolbox();

  //Code shit
  ManageStates();
}

void InitToolbox(){
  //Init some toolbox stuff
  startCellButton = new Button(width-toolboxWidth /2, 50, 125, 40, "Pick Start");
  startCellButton.value = 1;
  destCellButton = new Button(width-toolboxWidth /2, 120, 125, 40, "Pick End");
  wallsButton = new Button(width-toolboxWidth /2, 190, 125, 40, "Draw Walls");
  clearWallsButton = new Button(width-toolboxWidth /2, 300, 125, 40, "Clear Walls");
  penSlider  = new Slider(width-toolboxWidth /2, 250, 75, 25, "Draw", "Erase");
  startButton = new Button(width-toolboxWidth/2, 430, 125, 40, "Start");
  restartButton = new Button(width-toolboxWidth/2, 500, 125, 40, "Restart");
}

void Toolbox(){
  //Background
  fill(toolboxColor);
  rect(width-toolboxWidth, 0, toolboxWidth, height);
  
  fill(255);
  textAlign(CENTER, CENTER);
  text("Setup Tools" ,width-toolboxWidth/2, 20);
  
  //Planning Buttons
  penSlider.DrawSlider();
  startCellButton.DrawButton();
  destCellButton.DrawButton();
  wallsButton.DrawButton();
  clearWallsButton.DrawButton();
  
  
  //Line break
  fill(255);
  rect(width-toolboxWidth + 12.5f, 380, 175, 2);
  
  fill(255);
  textAlign(CENTER, CENTER);
  text("Simulation Controls" , width-toolboxWidth/2, height/2 + 100);
  
  //Simulation control buttons
  startButton.DrawButton();
  restartButton.DrawButton();
}

void ClearWalls(){
    blockedCells.clear();
}

void Start(){
    currentPlanningState = PlanningStates.StartCell;
    currentState = States.Running;
}

void Restart(){
  
    restartButton.active = true;
    restartButton.ButtonClicked();
    
    openList.clear();
    closedList.clear();
    finalPath.clear();    
    
    currentPlanningState = PlanningStates.StartCell;
    currentState = States.Planning;
    
    openList.add(startCell);
    restartButton.ResetButton();
}

void ManageStates(){
  //----------------------Planning States---------------------------------
  if (currentState == States.Planning) {
    mouseCell = MouseCell();
    erase = penSlider.value == 0 ? false: true; //Checks the pen slider to see if we be drawing
    
    if(ValidCell(mouseCell)){
        //Put a rect on our mouse to show the cell we are placing
      if(currentPlanningState == PlanningStates.BlockedCell){
        fill(blockedCellColor);
      }else if(currentPlanningState == PlanningStates.StartCell){
        fill(startCellColor);
      }else{
        fill(destCellColor);
      }    
      rect(cellWidth * mouseCell.col, cellHeight * mouseCell.row, cellWidth, cellHeight);
    }
    
    
    //Adding in walls
    if (currentPlanningState == PlanningStates.BlockedCell && trackMouse) { //If we are drawing and our mouse is down
      if(!erase){ //If we are drawing
        boolean addCell = true;
        //Loop through blocked cells and if the cell is already blocked then dont add
        for (int i = 0; i < blockedCells.size(); i++) {
          Cell blocked = blockedCells.get(i);
          if (blocked.row == mouseCell.row && blocked.col == mouseCell.col) {
            addCell = false;
          }
        }
        //If the cell is either the start or end, then dont add also
        if((startCell.row == mouseCell.row && startCell.col == mouseCell.col) || (destCell.row == mouseCell.row && destCell.col == mouseCell.col) ){
          addCell = false;
        }
        //If we pass all of these conditions then add cell
        if (addCell) {
            blockedCells.add(new Cell(mouseCell.col, mouseCell.row));
        }
      }else{//If we are erasing
        for(int i = 0; i < blockedCells.size(); i++){
          Cell temp = blockedCells.get(i);
          if(temp.col == mouseCell.col && temp.row == mouseCell.row){
             blockedCells.remove(temp); 
          }
        }        
      }      
    }
  }
  //----------------------Running State---------------------------------
  else if (currentState == States.Running) {
    AStar();

    fill(255);
    rect(current.col * cellWidth, current.row * cellHeight, cellWidth, cellHeight);
  }
  //----------------------End State---------------------------------
  else{
    
  }
}

void keyReleased() {
  if (keyCode == ENTER) {
    
  }
}

void mouseReleased() {  
  if(restartButton.active){
      Restart();
  }
  
  if (currentState == States.Planning) {
    if(clearWallsButton.active){
      ClearWalls();
    }
    
    //Button controls
    if(penSlider.active){
       penSlider.SliderClicked(); 
    }
    if(startCellButton.active){
      currentPlanningState = PlanningStates.StartCell;
      startCellButton.ButtonClicked();
      wallsButton.ResetButton();
      destCellButton.ResetButton();
    }
    if(destCellButton.active){
      currentPlanningState = PlanningStates.DestCell;
      destCellButton.ButtonClicked();
      wallsButton.ResetButton();
      startCellButton.ResetButton();
    }
    if(wallsButton.active){
      currentPlanningState = PlanningStates.BlockedCell;
      wallsButton.ButtonClicked();
      startCellButton.ResetButton();
      destCellButton.ResetButton();
    }
    
    if(startButton.active){
      wallsButton.ResetButton();
      startCellButton.ResetButton();
      destCellButton.ResetButton();
      Start(); 
    }
    
   
    
    
    if (currentPlanningState == PlanningStates.StartCell) {
      if(ValidCell(mouseCell)){
        //print("\n" + mouseCell.col);
        startCell.col = mouseCell.col;
        startCell.row = mouseCell.row;
      }
      
    } else if (currentPlanningState == PlanningStates.DestCell) {
      destCell.col = mouseCell.col;
      destCell.row = mouseCell.row;
    } else if (currentPlanningState == PlanningStates.BlockedCell) {
      trackMouse = false;
    }
  }
}

void mousePressed() {
  //print("MOUSE");
  if (currentState == States.Planning) {
    if (currentPlanningState == PlanningStates.BlockedCell) {
      trackMouse = true;
    }
  }
}

void AStar() {
  last = current;
  current = openList.get(0);
  //Set current to be the cell with the lowest F value
  for (int i = 0; i < openList.size(); i++) {
    if (openList.get(i).f < current.f) {
      current = openList.get(i);
    }
  }

  openList.remove(current);
  closedList.add(current);

  //Check if we have reached our destination
  if (IsDestination(current.col, current.row)) {
    endFound = true;
    destCell.parentCell = current.parentCell;
    print("\n END FOUND!");
    //print("\n Current: " + current.col + " " + current.row);
    //print("\n Current PArent: " + current.parentCell.col + " " + current.parentCell.row);
    //print("\n Start: " + startCell.col + " " + startCell.row);
    //print("\n End: " + destCell.col + " " + destCell.row);
    RetracePath();
    currentState = States.End;
  }

  //Process our neighboring cells
  ArrayList<Cell> neighbours = NeighbouringCells(current);
  for (int i = 0; i < neighbours.size(); i++) {
    if (!ValidCell(neighbours.get(i)) || closedList.contains(neighbours.get(i)) || BlockedCell(neighbours.get(i))) {
      //print("\n Invalid cell: " + neighbours.get(i).col + " " + neighbours.get(i).row);
      continue;
    }

    int newCost = abs(current.g + GetDistance(current, neighbours.get(i)));
    if (newCost < neighbours.get(i).g || !openList.contains(neighbours.get(i))) {
      neighbours.get(i).g = newCost;
      neighbours.get(i).h = GetDistance(neighbours.get(i), destCell);
      neighbours.get(i).parentCell = current;
      neighbours.get(i).f = neighbours.get(i).g + neighbours.get(i).h;

      if (!openList.contains(neighbours.get(i))) {
        openList.add(neighbours.get(i));
      }
    }
  }
}


ArrayList<Cell> NeighbouringCells (Cell currentCell) {

  ArrayList<Cell> toReturn = new ArrayList<Cell>();
  
  //8 Neighbours
  for (int x = -1; x < 2; x++) {
    for (int y = -1; y < 2; y++) {
      //Cell newCell = new Cell(currentCell.col + x, currentCell.row + y);
      //newCell.parentCell = currentCell;

      toReturn.add(GetCell(currentCell.col + x, currentCell.row + y));
      //print("\nNew Cell X: " + x + " Y:" + y);
    }
  }
  

  return toReturn;
}

Cell MouseCell() {
  int mouseCol = mouseX/cellWidth;
  int mouseRow = mouseY/cellHeight;

  return new Cell(mouseCol, mouseRow);
}

Cell GetCell(int x, int y) {
  int listSize = openList.size() > closedList.size() ? openList.size() : closedList.size();
  for (int i = 0; i < listSize; i++) {
    if (i < openList.size()) {
      Cell toCheckOpen = openList.get(i);
      if ((x == toCheckOpen.col) && (y == toCheckOpen.row)) {
        return toCheckOpen;
      }
    }
    if (i < closedList.size()) {
      Cell toCheckClosed = closedList.get(i);
      if ((x == toCheckClosed.col) && (y == toCheckClosed.row)) {
        return toCheckClosed;
      }
    }
  }
  Cell newCell = new Cell(x, y);
  //newCell.parentCell = current;
  newCell.g = CalculateG(newCell);
  newCell.h = CalculateH(newCell);
  newCell.f = newCell.g + newCell.h;

  //print("New Cell G:" + newCell.g + " H:" + newCell.h + "\n");

  return new Cell(x, y);
}

boolean IsDestination(int col, int row) {
  if (col == destCell.col && row == destCell.row) {
    return true;
  } else {
    return false;
  }
}

int GetDistance(Cell cellA, Cell cellB) {
  int xDist = cellB.col - cellA.col;
  int yDist = cellB.row - cellA.row;
  return (int)abs(pow(xDist, 2) + pow(yDist, 2));
}

boolean BlockedCell(Cell toCheck) {
  boolean trueStatement = false;
  for (int i = 0; i < blockedCells.size(); i++) {
    if (toCheck.row == blockedCells.get(i).row && toCheck.col == blockedCells.get(i).col) {
      trueStatement = true;
    }
  }
  return trueStatement;
}

boolean ValidCell(Cell toCheck) {
  //print("\n To Check:" + toCheck.col);
  //print("\n Grid Width:" + gridWidth);
  //print("\n Cells:" + gridWidth/cellWidth);
  if (((toCheck.col >= 0 && toCheck.col < gridWidth/cellWidth) && (toCheck.row >= 0 && toCheck.row < gridHeight/cellHeight)) ) {
    return true;
  } else {
    return false;
  }
}

int CalculateG(Cell currentCell) {
  int gCost = 0;
  gCost = GetDistance(currentCell, startCell);
  return gCost;
}


int CalculateH(Cell currentCell) {
  int hCost = 0;
  hCost = GetDistance(currentCell, destCell);
  return hCost;
}

void RetracePath() {
  Cell current = destCell;

  while (current != startCell) {
    //print(current.col + " " + current.row);
    finalPath.add(current);
    current = current.parentCell;
  }

  print(destCell.parentCell.parentCell.col + " " + destCell.parentCell.parentCell.row);
}

void DrawGrid() {
  float rowCount = gridHeight/cellHeight;
  for (int i = 0; i < rowCount; i++) {
    strokeWeight(0.5);
    stroke(255);
    line(0, i * cellHeight, gridWidth, i * cellHeight);
  }

  float columnCount = gridWidth/cellWidth;
  for (int i = 0; i < columnCount + 1; i++) {
    strokeWeight(0.5);
    stroke(255);
    line(i * cellWidth, 0, i * cellWidth, gridHeight);
  }
}

void DrawCells() {
  //Draw the open list cells
  for (int i = 0; i < openList.size(); i++) {
    Cell temp = openList.get(i);
    fill(openListColor);
    rect(temp.col * cellWidth, temp.row * cellHeight, cellWidth, cellHeight);
  }

  //Draw the closed list cells
  for (int i = 0; i < closedList.size(); i++) {
    Cell temp = closedList.get(i);
    fill(closedListColor);
    rect(temp.col * cellWidth, temp.row * cellHeight, cellWidth, cellHeight);
  }
  
  //Draw the blocked cells
  for (int i = 0; i < blockedCells.size(); i++) {
    Cell temp = blockedCells.get(i);
    fill(blockedCellColor);
    rect(temp.col * cellWidth, temp.row * cellHeight, cellWidth, cellHeight);
  }

  //If we found the end, draw the final path
  if (endFound) {
    for (int i = 0; i < finalPath.size(); i++) {
      Cell temp = finalPath.get(i);
      fill(finalPathColor);
      rect(temp.col * cellWidth, temp.row * cellHeight, cellWidth, cellHeight);
    }
  }

  //Draw in the start and dest cells
  fill(startCellColor);
  rect(startCell.col * cellWidth, startCell.row * cellHeight, cellWidth, cellHeight);
  fill(destCellColor);
  rect(destCell.col * cellWidth, destCell.row * cellHeight, cellWidth, cellHeight);
}
