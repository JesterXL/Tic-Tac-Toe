part of tictactoegame;

class TicTacToeBoard extends BasePiece
{
	// 759x704
  Future loadImage()
  {
    image.src = "images/board.png";
    return image.onLoad.first;
  }  
}