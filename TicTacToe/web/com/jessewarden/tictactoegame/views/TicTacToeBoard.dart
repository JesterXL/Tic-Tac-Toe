part of tictactoegame;

class TicTacToeBoard extends BasePiece
{
  Future loadImage()
  {
    image.src = "images/board.png";
    return image.onLoad.first;
  }  
}