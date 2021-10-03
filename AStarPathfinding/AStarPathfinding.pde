/*
    Evan Williams - TUD Game Design Year 3 03/10/2021
    
    An example of A* pathfinding done inside of processing
*/

//Grid variables
int cellWidth = 20;
int cellHeight = 20;

ArrayList<Cell> openList = new ArrayList<Cell>();
ArrayList<Cell> closedList = new ArrayList<Cell>();

Cell startCell = new Cell(2, 2);
Cell destCell = new Cell(15, 15);

boolean endFound = false;

void setup(){
  size(500, 500);
  
  openList.add(startCell);
}

void draw(){
  clear(); //Clear the screen every frame
  background(0); //Set background to be black
  DrawGrid(); 
  
  //Draw in the start and dest cells
  fill(255, 0, 0);
  rect(startCell.col * cellWidth, startCell.row * cellHeight, cellWidth, cellHeight);
  fill(0, 255, 0);
  rect(destCell.col * cellWidth, destCell.row * cellHeight, cellWidth, cellHeight);
  
  if(!endFound){
    AStar();
  }
}

void AStar(){
    //Set current to be the cell with the lowest F value
    Cell current = openList.get(0);
    for(int i = 0; i < openList.size(); i++){
        if(openList.get(i).f < current.f){
           current = openList.get(i); 
        }
    }
    print("Current: Row - " + current.row + " Col - " + current.col);
    openList.remove(current);
    closedList.add(current);
    
    //Check if we have reached our destination
    if(IsDestination(current.col, current.row)){
        endFound = true;
        print("\n END FOUND!");
    }
    
    //Process our neighboring cells
    ArrayList<Cell> neighbours = NeighbouringCells(current);
    for(int i = 0; i < neighbours.size(); i++){
      if(!ValidCell(neighbours.get(i)) || closedList.contains(neighbours.get(i))){
          print("Invalid cell: " + neighbours.get(i).col + " " + neighbours.get(i).row);
          continue;
      }else{
          
      }
    }
    
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
  
  return toReturn;
}

boolean IsDestination(int col, int row){
   if(col == destCell.col && row == destCell.row){
      return true; 
   }else{
     return false;
   }
}

boolean ValidCell(Cell toCheck){
  if((toCheck.col >= 0 && toCheck.col < width/cellWidth) && (toCheck.row >= 0 && toCheck.row < height/cellHeight)){
    return true;
  }else{
     return false; 
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
