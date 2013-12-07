part of tictactoegame;

class AIModel extends Stream
{
	StateMachine fsm;
	StreamController _controller;
	StreamSubscription _subscription;
	GameModel gameModel;
	List _memento;
	Timer waitTimer;
	
	AIModel(GameModel gameModel)
	{
		_controller = new StreamController.broadcast(onCancel: _onCancel);
		fsm = new StateMachine();
		fsm.addState("idle");
		fsm.addState("thinking");
		fsm.initialState = "idle";
		fsm.listen(onStateChange);
		
		this.gameModel = gameModel;
	}
	
	void onStateChange(StateMachineEvent event)
	{
		if(waitTimer != null)
		{
			waitTimer.cancel();
			waitTimer = null;
		}
		if(event.toState == "thinking")
		{
			const TIMEOUT = const Duration(seconds: 2);
			waitTimer = new Timer(TIMEOUT, onReadyToGo);
		}
	}
	
	void onReadyToGo()
	{
//			try
//			{
//				calculateNextMove();
//			}
//			catch(error)
//			{
//				print("AIModel failed to calculateNextMove, an error in the algorithm occured (imagine that...), error: $error");
//			}
		bool result = calculateNextMove();
		if(result == true)
		{
			print("AI successfully made a move.");
		}
		else
		{
			print("AI failed to make a move...");
		}
		_controller.add(new AIModelEvent(AIModelEvent.AI_MOVE_COMPLETED));
	}
	
	void onAITurn()
	{
		fsm.changeState("thinking");
	}
	
	void onAITurnOver()
	{
		fsm.changeState("idle");
	}
	
	bool calculateNextMove()
	{
		Game game = gameModel.game;
		if(game.isBlank)
		{
			// always start in middle
			print("AIModel taking correct first move.");
			game.setXAt(1, 1);
			return true;
		}
		else
		{
			// otherwise, gotta plan
			List d = game.mdarray;
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
			
			int r_1_c_1 = firstRow[0];
			int r_1_c_2 = firstRow[1];
			int r_1_c_3 = firstRow[2];
			int r_2_c_1 = secondRow[0];
			int r_2_c_2 = secondRow[1];
			int r_2_c_3 = secondRow[2];
			int r_3_c_1 = thirdRow[0];
			int r_3_c_2 = thirdRow[1];
			int r_3_c_3 = thirdRow[2];
			List<int> spots = [r_1_c_1, r_1_c_2, r_1_c_3,
								r_2_c_1, r_2_c_2, r_2_c_3,
								r_3_c_1, r_3_c_2, r_3_c_3];
			
			const int BLANK = Game.BLANK;
			const int X = Game.X;
			const int O = Game.O;
			
			// Can I make any winning moves?
			List<Map<String, int>> winningMoves = getWinningMoves(Game.X);
			if(winningMoves.length > 0)
			{
				// then take it
				Map<String, int> finishingMove = winningMoves[0];
				game.setXAt(finishingMove["row"], finishingMove["col"]);
				print("AIModel making a winning move.");
				return true;
			}
			
			// no winning moves, make sure we don't need to block...
			List<int> placeToBlock = needToBlock(potentialWins);
			if(placeToBlock != null)
			{
				// ghetto-lack-of-hash-map below
				if(placeToBlock == firstRow)
				{
					return setXInBlankSpot(row: 0);
				}
				else if(placeToBlock == secondRow)
				{
					return setXInBlankSpot(row: 1);
				}
				else if(placeToBlock == thirdRow)
				{
					return setXInBlankSpot(row: 2);
				}
				else if(placeToBlock == firstCol)
				{
					return setXInBlankSpot(col: 0);
				}
				else if(placeToBlock == secondCol)
				{
					return setXInBlankSpot(col: 1);	
				}
				else if(placeToBlock == thirdCol)
				{
					return setXInBlankSpot(col: 2);	
				}
				else if(placeToBlock == downRight)
				{
					return setXInBlankSpot(targets: [
														{"row": 0, "col": 0},
														{"row": 1, "col": 1},
														{"row": 2, "col": 2}
													]);	
				}
				else if(placeToBlock == downLeft)
				{
					return setXInBlankSpot(targets: [
														{"row": 0, "col": 2},
														{"row": 1, "col": 1},
														{"row": 2, "col": 0}
													]);
				}
			}
			
			
			
			// find next move instead. Let's check for edges...
			print("AIModel checking for edges...");
			if(r_2_c_1 == O)
			{
				if(game.getCell(2, 2) == BLANK)
				{
					game.setXAt(2, 2);
					return true;
				}
				else if(game.getCell(0, 2) == BLANK)
				{
					game.setXAt(0, 2);
					return true;
				}
			}
			else if(r_1_c_2 == O)
			{
				if(game.getCell(2, 0) == BLANK)
				{
					game.setXAt(2, 0);
					return true;
				}
				else if(game.getCell(2, 2) == BLANK)
				{
					game.setXAt(2, 2);
					return true;
				}
			}
			else if(r_2_c_3 == O)
			{
				if(game.getCell(0, 0) == BLANK)
				{
					game.setXAt(0, 0);
					return true;
				}
				else if(game.getCell(2, 0) == BLANK)
				{
					game.setXAt(2, 0);
					return true;
				}
			}
			else if(r_3_c_2 == O)
			{
				if(game.getCell(0, 2) == BLANK)
				{
					game.setXAt(0, 2);
					return true;
				}
				else if(game.getCell(0, 0) == BLANK)
				{
					game.setXAt(0, 0);
					return true;
				}
			}
			
			// no edges? Let's check for corners...
			print("AIModel checking for corners...");
			if(r_3_c_1 == O)
			{
				if(game.getCell(0, 2) == BLANK)
				{
					game.setXAt(0, 2);
					return true;
				}
				else if(game.getCell(2, 2) == BLANK)
				{
					game.setXAt(2, 2);
					return true;
				}
				else if(game.getCell(0, 0) == BLANK)
				{
					game.setXAt(0, 0);
					return true;
				}
			}
			else if(r_1_c_1 == O)
			{
				if(game.getCell(2, 2) == BLANK)
				{
					game.setXAt(2, 2);
					return true;
				}
				else if(game.getCell(0, 2) == BLANK)
				{
					game.setXAt(0, 2);
					return true;
				}
				else if(game.getCell(2, 0) == BLANK)
				{
					game.setXAt(2, 0);
					return true;
				}
			}
			else if(r_1_c_3 == O)
			{
				if(game.getCell(2, 0) == BLANK)
				{
					game.setXAt(2, 0);
					return true;
				}
				else if(game.getCell(0, 0) == BLANK)
				{
					game.setXAt(0, 0);
					return true;
				}
				else if(game.getCell(2, 2) == BLANK)
				{
					game.setXAt(2, 2);
					return true;
				}
			}
			else if(r_3_c_3 == O)
			{
				if(game.getCell(0, 0) == BLANK)
				{
					game.setXAt(0, 0);
					return true;
				}
				else if(game.getCell(0, 2) == BLANK)
				{
					game.setXAt(0, 2);
					return true;
				}
				else if(game.getCell(2, 0) == BLANK)
				{
					game.setXAt(2, 0);
					return true;
				}
			}
			
			// made it this far? oy vey, my algorithm needs work, find an open spot
			print("AIModel's strategy exhausted, picking a random spot...");
			List<int> openSpot = findOpenSpot(game);
			if(openSpot.length > 0)
			{
				game.setXAt(openSpot[0], openSpot[1]);
				return true;
			}
			
			print("AIModel couldn't even choose a random spot, fail.");
			return false;
			
		}
	}
	
	List<int> findOpenSpot(Game game)
	{
		for(var r=0; r<Game.ROWS; r++)
		{
			for(var c=0; c<Game.COLS; c++)
			{
				if(game.getCell(r, c) == Game.BLANK)
				{
					return [r, c];
				}
			}
		}
		return [];
	}
	
	List<Map<String, int>> getWinningMoves(int forType)
	{
		Game clonedGame = gameModel.game.clone();
		storeMemento(clonedGame);
		List<Map<String, int>> winningMoves = [];
		for(var r=0; r<Game.ROWS; r++)
		{
			for(var c=0; c<Game.COLS; c++)
			{
				if(clonedGame.getCell(r, c) == Game.BLANK)
				{
					clonedGame.setXAt(r, c);
					if(forType == Game.X)
					{
						if(clonedGame.xIsWinner)
						{
							winningMoves.add({"row": r, "col": c});
						}
					}
					else if(forType == Game.O)
					{
						if(clonedGame.oIsWinner)
						{
							winningMoves.add({"row": r, "col": c});
						}
					}
					
				
					resetToMemento(clonedGame);
					storeMemento(clonedGame);
				}
			}
		}
		return winningMoves;
	}
	
	bool listHasHole(List<int> list, int type)
	{
		int score = 0;
		list.forEach((int item)
		{
			if(item == type)
			{
				score++;
			}
			if(item != type && item != Game.BLANK)
			{
				score--;
			}
		});
		if(score == 2)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	List<int> needToBlock(List<List<int>> potentialWins)
	{
		List<int> listToBlock;
		potentialWins.forEach((List<int> potentialWin)
		{
			if(listHasHole(potentialWin, Game.O) == true)
			{
				listToBlock = potentialWin;
			}
		});
		return listToBlock;
	}
	
	bool setXInBlankSpot({int row:null, int col:null, List<Map<String, int>> targets:null})
	{
		print("AIModel found a blank spot and preventing a win.");
		print("row: $row, col: $col, targets: $targets");
		Game game = gameModel.game;
		if(row != null)
		{
			// find blank spot in row, set it
			if(game.getCell(row, 0) == Game.BLANK)
			{
				game.setXAt(row, 0);
				return true;
			}
			else if(game.getCell(row, 1) == Game.BLANK)
			{
				game.setXAt(row, 1);
				return true;
			}
			else if(game.getCell(row, 2) == Game.BLANK)
			{
				game.setXAt(row, 2);
				return true;
			}
			else
			{
				return false;
			}
		}
		else if(col != null)
		{
			// find blank spot in row, set it
			if(game.getCell(0, col) == Game.BLANK)
			{
				game.setXAt(0, col);
				return true;
			}
			else if(game.getCell(1, col) == Game.BLANK)
			{
				game.setXAt(1, col);
				return true;
			}
			else if(game.getCell(2, col) == Game.BLANK)
			{
				game.setXAt(2, col);
				return true;
			}
			else
			{
				return false;
			}
		}
		else if(targets != null)
		{
			Map<String, int> target1 = targets[0];
			Map<String, int> target2 = targets[1];
			Map<String, int> target3 = targets[2];
			if(game.getCell(target1["row"], target1["col"]) == Game.BLANK)
			{
				game.setXAt(target1["row"], target1["col"]);
				return true;
			}
			else if(game.getCell(target2["row"], target2["col"]) == Game.BLANK)
			{
				game.setXAt(target2["row"], target2["col"]);
				return true;
			}
			else if(game.getCell(target3["row"], target3["col"]) == Game.BLANK)
			{
				game.setXAt(target3["row"], target3["col"]);
				return true;
			}
		}
		return false;
	}
	
	void storeMemento(Game game)
	 { 
		 _memento = [
			 [0, 0, 0],
			 [0, 0, 0],
			 [0, 0, 0]
		 ];
	 
		 // [jwarden 12.6.2013] TODO: optimize later
		 for(var r=0; r<Game.ROWS; r++)
		 {
		 	for(var c=0; c<Game.COLS; c++)
		 	{
	 		_memento[r][c] = game.getCell(r, c);
		 	}
		 }
	 }
	 
	 void resetToMemento(Game game)
	 {
	 	game.mdarray = _memento;
	 	_memento = null;
	 }
	 
	
	
	// ------------------------------------------------------------------------
	// ------------------------------------------------------------------------
	// Stream Impl
	StreamSubscription listen(void onData(AIModelEvent event),
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
	
	void _onData(AIModelEvent event)
	{
		_controller.add(event);
	}
	
	void _onDone()
	{
		_controller.close();
	}
// ------------------------------------------------------------------------
// ------------------------------------------------------------------------
}