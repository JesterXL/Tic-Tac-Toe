part of tictactoegame;

class GameModel extends Stream
{
  static const int BLANK = 0;
  static const int X = 1;
  static const int O = 2;
  
  List _mdarray;
  StreamController _controller;
  StreamSubscription _subscription;
  
  GameModel()
  {
    _controller = new StreamController(
        onPause: _onPause,
        onResume: _onResume,
        onCancel: _onCancel);
  }
  
  StreamSubscription listen(void onData(dynamic cell),
      { void onError(Error error),
    void onDone(),
    bool cancelOnError }) {
    _subscription =  _controller.stream.listen(onData,
                                     onError: onError,
                                     onDone: onDone,
                                     cancelOnError: cancelOnError);
    return _subscription;
  }
  
  void _onCancel()
  {
    _subscription.cancel();
    _subscription = null;
  }

  void _onPause()
  {
    _subscription.pause();
  }

  void _onResume()
  {
    _subscription.resume();
  }
  
  void _onData(dynamic value)
  {
    _controller.add(value);
  }

  void _onDone()
  {
    _controller.close();
  }
  
  int _getCell(int row, int col)
  {
    return _mdarray[row][col];
  }
  
  Stream _setCell(int row, int col, int value)
  {
    _mdarray[row][col] = value;
    _controller.add({"row": row, "col": col, "value": value});
    _controller.close();
  }
  
  void resetGame()
  {
    _mdarray = [
       [0, 0, 0],
       [0, 0, 0],
       [0, 0, 0]
       ];
  }
  
  void setBlankAt(int row, int col)
  {
    _setCell(row, col, BLANK);
  }
  
  void setXAt(int row, int col)
  {
    _setCell(row, col, X);
  }
  
  void setOAt(int row, int col)
  {
    _setCell(row, col, O);
  }
  
}