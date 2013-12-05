part of tictactoegame;

class PieceX extends BasePiece
{
  Future loadImage()
  {
    image.src = "images/x.png";
    return image.onLoad.first;
  }
}