part of tictactoegame;

class Game
{
	static const int ROWS = 3;
	static const int COLS = 3;
	static const int BLANK = 0;
	static const int X = 1;
	static const int O = 2;
	
	List _mdarray;
	
	
	StreamController _controller;
 	StreamSubscription _subscription;
	
	Game()
	{
		_controller = new StreamController.broadcast(onCancel: _onCancel, sync: true);
		resetGame();
	}
	
	List get mdarray
	{
		return _mdarray;
	}
	
	void set mdarray(List value)
	{
		_mdarray = value;
		CellChangeEvent event = new CellChangeEvent(CellChangeEvent.ALL_CELLS_CHANGED);
		_controller.add(event);
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
	
	bool get isFull
	{
		return _mdarray.every((List<int> row)
		{
			return row.every((int item)
			{
				return item != BLANK;
			});
		});
	}
	
	bool get xIsWinner
	{
		dynamic matchResult = getMatchResults();
		return matchResult["type"] != null && matchResult["type"] == X;
	}
	
	bool get oIsWinner
	{
		dynamic matchResult = getMatchResults();
		return matchResult["type"] != null && matchResult["type"] == O;
	}
	
	int getCell(int row, int col)
	{
		return _mdarray[row][col];
	}
	
	Stream _setCell(int row, int col, int value)
	{
		assert(row != null);
		assert(col != null);
		assert(row <= ROWS);
		assert(col <= COLS);
		assert(value != null);
		assert(_mdarray != null);
		_mdarray[row][col] = value;
		CellChangeEvent event = new CellChangeEvent(CellChangeEvent.CELL_CHANGED);
		dynamic matchResult = getMatchResults();
		event.row = row;
		event.col = col;
		event.value = value;
		event.match = matchResult["match"];
		_controller.add(event);
	}
	
	dynamic getMatchResults()
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
		
		dynamic matchResult = _matchAtLeastOneList(potentialWins);
		return matchResult;
	}
	
	 void resetGame()
	 {
		 _mdarray = [
			 [0, 0, 0],
			 [0, 0, 0],
			 [0, 0, 0]
		 ];
		 CellChangeEvent event = new CellChangeEvent(CellChangeEvent.ALL_CELLS_CHANGED);
		_controller.add(event);
	 }
	 
	 Game clone()
	 {
	 	Game clonedGame = new Game();
	 	clonedGame._mdarray = [
			 [0, 0, 0],
			 [0, 0, 0],
			 [0, 0, 0]
		 ];
		for(var r=0; r<ROWS; r++)
		{
			for(var c=0; c<COLS; c++)
			{
				clonedGame._mdarray[r][c] = getCell(r, c);
			}
		}
	 	return clonedGame;
	 }
	 
	void setBlankAt(int row, int col)
	{
		_setCell(row, col, BLANK);
	}

	void setXAt(int row, int col)
	{
		print("X at row: $row, col: $col");
		_setCell(row, col, X);
	}

	void setOAt(int row, int col)
	{
		_setCell(row, col, O);
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
	
	dynamic _matchAtLeastOneList(List<List<int>> lists)
	{
		int matchIndex = null;
		int lastType;
		bool match = lists.any((List<int> list)
		{
			bool aMatch = _matchList(list);
			if(aMatch == true)
			{
				matchIndex = lists.indexOf(list);
				lastType = list[0];
			}
			return aMatch;
		});
		return {"match": match, "index": matchIndex, "type": lastType};
	}
	
	
	
// ------------------------------------------------------------------------
	// ------------------------------------------------------------------------
	// Stream Impl
	StreamSubscription listen(void onData(CellChangeEvent event),
							{ void onError(Error error),
							  void onDone(),
							  bool cancelOnError })
	{
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
	
}