import 'dart:html';
import 'dart:async';
import 'com/jessewarden/tictactoegame/tictactoegamelib.dart';
import 'com/jessewarden/statemachine/statemachinelib.dart';

GameModel model;
GameBoardController boardController;

void main()
{
  print("main");
  boardController = new GameBoardController(querySelector("#mainCanvas"), querySelector("#textCanvas"));
  boardController.init();
	
	
//	EnterStream stateTest = new EnterStream();
//	stateTest.listen((dynamic object)
//	{
//		print(object);
//	});
//	stateTest.controller.add("cow");
  
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

