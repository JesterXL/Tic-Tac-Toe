part of tictactoegame;

class PieceO extends BasePiece
{
  Future loadImage()
  {
    image.src = "images/o.png";
    return image.onLoad.first;
  }
}