class Cell{
  int row, col;
  
  int parentCol = 0;
  int parentRow = 0;
  
  Cell parentCell;
  
   int f = 0;
   int g = 0;
   int h = 0;
  
  //boolean invalid = false;
  
   Cell(int tCol, int tRow, int pCol, int pRow, int fVal, int gVal, int hVal){
     row = tRow;
     col = tCol;
     parentCol = pCol;
     parentRow = pRow;
     f = fVal;
     g = gVal;
     h = hVal;
   }
   
   Cell(int tCol, int tRow, int pCol, int pRow){
     row = tRow;
     col = tCol;
     parentCol = pCol;
     parentRow = pRow;
   }
   
   Cell(int tCol, int tRow){
     row = tRow;
     col = tCol;
   }
}
