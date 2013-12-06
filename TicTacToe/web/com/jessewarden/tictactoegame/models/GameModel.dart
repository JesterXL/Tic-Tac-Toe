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
  
	// ------------------------------------------------------------------------
  // ------------------------------------------------------------------------
  // Stream Impl
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
// ------------------------------------------------------------------------
// ------------------------------------------------------------------------
  
	List get mdarray
	{
		return _mdarray;
	}
	
	bool get isBlank
	{
		return _mdarray.every((List<int> row)
		{
			return row.every((int item)
			{
				return item == BLANK;
			});
		});
	}
	
  int _getCell(int row, int col)
  {
    return _mdarray[row][col];
  }
  
  Stream _setCell(int row, int col, int value)
  {
    _mdarray[row][col] = value;
    dynamic matchResult = _calculateWin();
    dynamic changeObject = {"row": row, 
                            "col": col, 
                            "value": value, 
                            "match": matchResult["match"]};
    _controller.add(changeObject);
  }
  
  Object _calculateWin()
  {
    List d = _mdarray;
    List firstRow       = d[0];
    List secondRow      = d[1];
    List thirdRow       = d[2];
    List firstCol       = [d[0][0], d[1][0], d[2][0]];
    List secondCol      = [d[0][1], d[1][1], d[2][1]];
    List thirdCol       = [d[0][2], d[1][2], d[2][2]];
    List downRight      = [d[0][0], d[1][1], d[2][2]];
    List downLeft       = [d[0][2], d[1][1], d[2][0]];
    List potentialWins  = [firstRow, secondRow, thirdRow,
                          firstCol, secondCol, thirdCol,
                          downRight, downLeft
                          ];
    
    Object matchResult = _matchAtLeastOneList(potentialWins);
    return matchResult;
  }
  
  bool _matchList(List<int> list)
  {
    int lastItem = null;
    bool match = list.every((int item)
        {
           if(lastItem != null)
           {
             if(item != BLANK && lastItem != BLANK)
             {
                return item == lastItem;
             }
             else
             {
               return false;
             }
           }
           else
           {
             
             lastItem = item;
             return true;
           }
        });
    return match;
  }
  
  Object _matchAtLeastOneList(List<List<int>> lists)
  {
    int matchIndex = null;
    bool match = lists.any((List<int> list)
        {
            bool aMatch = _matchList(list);
            if(aMatch == true)
            {
              matchIndex = lists.indexOf(list);
            }
            return aMatch;
        });
    return {"match": match, "index": matchIndex};
  }
  
  void resetGame()
  {
    _mdarray = [
       [0, 0, 0],
       [0, 0, 0],
       [0, 0, 0]
       ];
  }
  

  
  
}