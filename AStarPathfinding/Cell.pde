class Cell{
  int row, col;
  
  int parentCol = 0;
  int parentRow = 0;
  
   float f = 0;
   float g = 0;
   float h = 0;
  
   Cell(int tCol, int tRow, int pCol, int pRow, float fVal, float gVal, float hVal){
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
