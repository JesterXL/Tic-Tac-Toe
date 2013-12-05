import 'dart:html';
import 'dart:async';
import 'com/jessewarden/tictactoegame/tictactoegamelib.dart';

CanvasElement canvas;
List<PieceX> xPieces;
List<PieceO> oPieces;
TicTacToeBoard board;
GameModel model;

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
          print("all images loaded");
          drawBoardAndPieces();
        });
  
//  List test = [1, 2, 3, 4];
//  test.forEach((int index)
//      {
//        print(index);
//      });
//  List all = [1, 1, 1];
//  int lastItem = null;
//  bool firstRowMatch = all.every((int item)
//      {
//    if(lastItem != null)
//    {
//      return item == lastItem;
//    }
//    else
//    {
//      lastItem = item;
//      return true;
//    }
//      });
//  print("firstRowMatch: ");
//  print(firstRowMatch);
 
 model = new GameModel();
 model.resetGame();
// model.listen(print);
 model.listen((dynamic someData)
     {
       print("listen, someData:");
       print(someData);
    });
  model.setXAt(0, 0);
  model.setXAt(0, 1);
  model.setXAt(0, 2);
  
//  TestStream test = new TestStream();
//  test.listen(print);
//  test.doSomething();
  
}

//class TestStream extends Stream
//{
//  StreamSubscription _subscription;
//  StreamController _controller;
//
//  TestStream()
//  {
//    _controller = new StreamController(
//      onPause: _onPause,
//      onResume: _onResume,
//      onCancel: _onCancel);
//  }
//
//  StreamSubscription listen(void onData(_),
//                                    { void onError(Error error),
//                                      void onDone(),
//                                      bool cancelOnError })
//  {
//    return _controller.stream.listen(onData,
//                                     onError: onError,
//                                     onDone: onDone,
//                                     cancelOnError: cancelOnError);
//  }
//  
//  void doSomething()
//  {
//    _controller.add("cow");
//  }
////
////  void _onListen()
////  {
////    print("onListen");
//////    _subscription = _source.listen(_onData,
//////                                   onError: _controller.addError,
//////                                   onDone: _onDone);
////    _subscription = listen(_onData,
////                                   onError: _controller.addError,
////                                   onDone: _onDone);
////  }
//
//  void _onCancel() {
//    print("_onCancel");
////    _subscription.cancel();
////    _subscription = null;
//  }
//
//  void _onPause()
//  {
//    print("_onPause");
////    _subscription.pause();
//  }
//
//  void _onResume()
//  {
//    print("_onResume");
////    _subscription.resume();
//  }
//
//  void _onData(_)
//  {
//    print("onData man");
//  }
//
//  void _onDone()
//  {
//    print("_onDone");
//    _controller.close();
//  }
//}

void drawBoardAndPieces()
{
  print("drawBoardAndPieces");
  board.draw(canvas.context2D, new Point(0, 0));
}

