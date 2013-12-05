part of tictactoegame;

abstract class BasePiece
{
  ImageElement image = new ImageElement();
  
  void draw(CanvasRenderingContext2D context, Point p)
  {
    context.drawImage(image, p.x, p.y);
  }
}