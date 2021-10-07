/*
    Evan Williams - TUD Game Design Year 3 03/10/2021
    
    An example of A* pathfinding done inside of processing
*/

//States of the app
enum States{
   Planning,
   Running,
   End
}
States currentState;

enum PlanningStates{
   StartCell,
   DestCell,
   BlockedCell,
   Nothing
}
PlanningStates currentPlanningState;

Cell mouseCell = new Cell(0, 0);


boolean trackMouse = false;

//Grid variables
int cellWidth = 20;
int cellHeight = 20;

//Lists to store cell data
ArrayList<Cell> openList = new ArrayList<Cell>();
ArrayList<Cell> closedList = new ArrayList<Cell>();
ArrayList<Cell> finalPath = new ArrayList<Cell>();
ArrayList<Cell> blockedCells = new ArrayList<Cell>();

//Start and destination cells
Cell startCell = new Cell(0, 0);
Cell destCell = new Cell(0,0);

//If we have found the end of the game
boolean endFound = false;

//Used in the AStar method to track the current cell we are evaluating
Cell current;

//Colors for the cells
color backgroundColor = color(0, 18, 25); //Blackish
color startCellColor = color(255, 137, 202); //Pink
color destCellColor = color(202, 255, 137); //Green
color blockedCellColor = color(10, 147, 150); //Teal
color finalPathColor = color(155, 34, 38); //Red
color openListColor = color(155, 255, 10); //Lime
color closedListColor = color(233, 216, 166); //Cream

void setup(){
  size(600, 600);
    
  //Add our start cell as the base cell in the openList
  openList.add(startCell);
  
  currentState = States.Planning;
  currentPlanningState = PlanningStates.StartCell;
}

void draw(){
  clear(); //Clear the screen every frame
  background(backgroundColor); //Set background colour
  
  DrawGrid(); 
  DrawCells();
  
  
  if(currentState == States.Planning){
    mouseCell = MouseCell();
    
     if(currentPlanningState == PlanningStates.BlockedCell && trackMouse){
       boolean addCell = true;
        for(int i = 0; i < blockedCells.size(); i++){
           Cell blocked = blockedCells.get(i);
           if(blocked.row == mouseCell.row && blocked.col == mouseCell.col){
             addCell = false;
           }
        }
        if(addCell){
           blockedCells.add(new Cell(mouseCell.col, mouseCell.row)); 
        }
     }
    
  }else if(currentState == States.Running){
     AStar();
     
    fill(255);
    rect(current.col * cellWidth, current.row * cellHeight, cellWidth, cellHeight);
  }else{
    for(int i = 0; i < finalPath.size(); i++){
    Cell temp = finalPath.get(i);
    fill(finalPathColor);
    rect(temp.col * cellWidth, temp.row * cellHeight, cellWidth, cellHeight);
    }
  }
  
}

void keyReleased(){
  if(keyCode == ENTER){
    if(currentState == States.Planning){
      if(currentPlanningState == PlanningStates.StartCell){
        currentPlanningState = PlanningStates.DestCell;
      }else if(currentPlanningState == PlanningStates.DestCell){
        currentPlanningState = PlanningStates.BlockedCell;
      }else if(currentPlanningState == PlanningStates.BlockedCell){
        currentPlanningState = PlanningStates.StartCell;
        currentState = States.Running;
      }  
  }
  }
}

void mouseReleased(){
  if(currentState == States.Planning){
    if(currentPlanningState == PlanningStates.StartCell){
      startCell.col = mouseCell.col;
      startCell.row = mouseCell.row;
    }else if(currentPlanningState == PlanningStates.DestCell){
      destCell.col = mouseCell.col;
      destCell.row = mouseCell.row;
    }else if(currentPlanningState == PlanningStates.BlockedCell){
      trackMouse = false;
    }
  }
}

void mousePressed(){
  print("MOUSE");
   if(currentState == States.Planning){
      if(currentPlanningState == PlanningStates.BlockedCell){
        trackMouse = true;
        
      }
   }
}

void AStar(){
  current = openList.get(0);
  //Set current to be the cell with the lowest F value
    for(int i = 0; i < openList.size(); i++){
        if(openList.get(i).f < current.f){
           current = openList.get(i); 
        }
    }
    
    openList.remove(current);
    closedList.add(current);
    
    //Check if we have reached our destination
    if(IsDestination(current.col, current.row)){
        endFound = true;
        destCell.parentCell = current;
        print("\n END FOUND!");
        RetracePath();
        currentState = States.End;
    }
    
    //Process our neighboring cells
    ArrayList<Cell> neighbours = NeighbouringCells(current);
    for(int i = 0; i < neighbours.size(); i++){
      if(!ValidCell(neighbours.get(i)) || closedList.contains(neighbours.get(i)) || BlockedCell(neighbours.get(i))){
          //print("\n Invalid cell: " + neighbours.get(i).col + " " + neighbours.get(i).row);
          continue;
      }
      
      int newCost = abs(current.g + GetDistance(current, neighbours.get(i)));
      if(newCost < neighbours.get(i).g || !openList.contains(neighbours.get(i))){
        neighbours.get(i).g = newCost;
        neighbours.get(i).h = GetDistance(neighbours.get(i), destCell);
        neighbours.get(i).parentCell = current;
        neighbours.get(i).f = neighbours.get(i).g + neighbours.get(i).h;
        
        if(!openList.contains(neighbours.get(i))){
            openList.add(neighbours.get(i));
        }
      }
    }
    
}

Cell MouseCell(){
    int mouseCol = mouseX/cellWidth;
    int mouseRow = mouseY/cellHeight;
        
    return new Cell(mouseCol, mouseRow);
}

ArrayList<Cell> NeighbouringCells (Cell currentCell){
  ArrayList<Cell> toReturn = new ArrayList<Cell>();
  Cell neighbour0 = new Cell(currentCell.col - 1, currentCell.row - 1);
  toReturn.add(neighbour0);
  
  Cell neighbour1 = new Cell(currentCell.col, currentCell.row - 1);
  toReturn.add(neighbour1);
  
  Cell neighbour2 = new Cell(currentCell.col + 1, currentCell.row - 1);
  toReturn.add(neighbour2);
  
  Cell neighbour3 = new Cell(currentCell.col + 1, currentCell.row);
  toReturn.add(neighbour3);
  
  Cell neighbour4 = new Cell(currentCell.col + 1, currentCell.row + 1);
  toReturn.add(neighbour4);
  
  Cell neighbour5 = new Cell(currentCell.col, currentCell.row + 1);
  toReturn.add(neighbour5);
  
  Cell neighbour6 = new Cell(currentCell.col - 1, currentCell.row + 1);
  toReturn.add(neighbour6);
  
  Cell neighbour7 = new Cell(currentCell.col - 1, currentCell.row);
  toReturn.add(neighbour7);
  
  for(int i = 0; i < toReturn.size(); i++){
      toReturn.get(i).parentCell = currentCell;
  }
  
  return toReturn;
}

boolean IsDestination(int col, int row){
   if(col == destCell.col && row == destCell.row){
      return true; 
   }else{
     return false;
   }
}

int GetDistance(Cell cellA, Cell cellB){
  int xDist = cellB.col - cellA.col;
  int yDist = cellB.row - cellA.row;
  return abs(xDist + yDist);
}

boolean BlockedCell(Cell toCheck){
  boolean trueStatement = false;
   for(int i = 0; i < blockedCells.size(); i++){
       if(toCheck.row == blockedCells.get(i).row && toCheck.col == blockedCells.get(i).col){
           trueStatement = true;
       }
   }
   return trueStatement;
}

boolean ValidCell(Cell toCheck){
  if(((toCheck.col >= 0 && toCheck.col < width/cellWidth) && (toCheck.row >= 0 && toCheck.row < height/cellHeight)) || !toCheck.invalid){
    return true;
  }else{
     return false; 
  }
}

int CalculateG(Cell currentCell){
  int gCost = 0;
  while(currentCell.parentCell != null){
    gCost ++;
    currentCell = currentCell.parentCell;
  }
  print("G: " + gCost);
  return gCost;
}


int CalculateH(Cell currentCell){
  int hCost = 0;
  hCost = GetDistance(currentCell, destCell);
  return hCost;
}

void RetracePath(){
    Cell current = destCell;
    
    while(current != startCell){
      print(current.col + " " + current.row);
       finalPath.add(current);
       current = current.parentCell;
    }
   
}

void DrawGrid(){
  float rowCount = height/cellHeight;
  for(int i = 0; i < rowCount; i++){
      strokeWeight(0.5);
      stroke(255);
      line(0, i * cellHeight, width, i * cellHeight);
  }
  
  float columnCount = width/cellWidth;
  for(int i = 0; i < columnCount; i++){
      strokeWeight(0.5);
      stroke(255);
      line(i * cellWidth, 0, i * cellWidth, height);
  }
}

void DrawCells(){  
  for(int i = 0; i < openList.size(); i++){
    Cell temp = openList.get(i);
    fill(openListColor);
    rect(temp.col * cellWidth, temp.row * cellHeight, cellWidth, cellHeight);
  }
  
   for(int i = 0; i < closedList.size(); i++){
    Cell temp = closedList.get(i);
    fill(closedListColor);
    rect(temp.col * cellWidth, temp.row * cellHeight, cellWidth, cellHeight);
  }
  
  for(int i = 0; i < blockedCells.size(); i++){
    Cell temp = blockedCells.get(i);
    fill(blockedCellColor);
    rect(temp.col * cellWidth, temp.row * cellHeight, cellWidth, cellHeight);
  }
  
  
  //Draw in the start and dest cells
  fill(startCellColor);
  rect(startCell.col * cellWidth, startCell.row * cellHeight, cellWidth, cellHeight);
  fill(destCellColor);
  rect(destCell.col * cellWidth, destCell.row * cellHeight, cellWidth, cellHeight);
}
