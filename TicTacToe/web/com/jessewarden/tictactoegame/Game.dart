part of tictactoegame;

class Game
{
	static const int ROWS = 3;
	static const int COLS = 3;
	static const int BLANK = 0;
	static const int X = 1;
	static const int O = 2;
	
	List _mdarray;
	List _memento;
	
	Game()
	{
		resetGame();
	}
	
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
		assert(_mdarray != null);
		_mdarray[row][col] = value;
//		dynamic matchResult = getMatchResults();
//		dynamic changeObject = {"row": row, 
//	                        "col": col, 
//	                        "value": value, 
//	                        "match": matchResult["match"]};
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
	 }
	 
	 Game clone()
	 {
	 	Game clonedGame = new Game();
	 	clonedGame._mdarray = _mdarray;
	 	return clonedGame;
	 }
	 
	 void storeMemento()
	 { 
		 _memento = [
			 [0, 0, 0],
			 [0, 0, 0],
			 [0, 0, 0]
		 ];
		 
		 // [jwarden 12.6.2013] TODO: optimize later
		 for(var r=0; r<ROWS; r++)
		 {
		 	for(var c=0; c<COLS; c++)
		 	{
		 		_memento[r][c] = _mdarray[r][c];
		 	}
		 }
	 }
	 
	 void resetToMemento()
	 {
	 	_mdarray = _memento;
	 	_memento = null;
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
	
	List<Map<String, int>> getWinningMoves(int forType)
	{
		storeMemento();
		List<Map<String, int>> winningMoves = [];
		for(var r=0; r<ROWS; r++)
		{
			for(var c=0; c<COLS; c++)
			{
				if(getCell(r, c) == BLANK)
				{
					setXAt(r, c);
					if(forType == X)
					{
						if(xIsWinner)
						{
							winningMoves.add({"row": r, "col": c});
						}
					}
					else if(forType == O)
					{
						if(oIsWinner)
						{
							winningMoves.add({"row": r, "col": c});
						}
					}
					
				
					resetToMemento();
					storeMemento();
				}
			}
		}
		return winningMoves;
	}
	
}