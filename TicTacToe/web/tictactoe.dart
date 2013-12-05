import 'dart:html';
import 'dart:async';
import 'com/jessewarden/tictactoegame/tictactoegamelib.dart';

CanvasElement canvas;
List<PieceX> xPieces;
List<PieceO> oPieces;
TicTacToeBoard board;

void main()
{
  print("main");
  canvas = querySelector("#mainCanvas");
  board = new TicTacToeBoard();
//  Future future = board.loadImage();
//  future.then((value)
//      {
//        print("board load done.");
//      });
  xPieces = new List<PieceX>();
  oPieces = new List<PieceO>();
  List loaders = [];
  loaders.add(board.loadImage());
  for(var i=0; i<9; i++)
  {
    PieceX pieceX = new PieceX();
    xPieces.add(pieceX);
    loaders.add(pieceX.loadImage());
    PieceO pieceO = new PieceO();
    oPieces.add(pieceO);
    loaders.add(pieceO.loadImage());
  }
  
  Future.wait(loaders)
    .then((List values)
        {
          drawBoardAndPieces();
        });
 
}

void drawBoardAndPieces()
{
  print("drawBoardAndPieces");
  board.draw(canvas.context2D, new Point(0, 0));
}

