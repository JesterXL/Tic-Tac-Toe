part of tictactoegame;

class AIModel extends Stream
{
	StateMachine fsm;
	StreamController _controller;
	StreamSubscription _subscription;
	GameModel gameModel;
	
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
		if(event.toState == "thinking")
		{
			calculateNextMove();
		}
	}
	
	bool calculateNextMove()
	{
		Game game = gameModel.game;
		if(game.isBlank)
		{
			// always start in middle
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
//			List firstCol       = [d[0][0], d[1][0], d[2][0]];
//			List secondCol      = [d[0][1], d[1][1], d[2][1]];
//			List thirdCol       = [d[0][2], d[1][2], d[2][2]];
//			List downRight      = [d[0][0], d[1][1], d[2][2]];
//			List downLeft       = [d[0][2], d[1][1], d[2][0]];
//			List potentialWins  = [firstRow, secondRow, thirdRow,
//									firstCol, secondCol, thirdCol,
//									downRight, downLeft
//									];
//			
			int r_1_c_1 = firstRow[0];
			int r_1_c_2 = firstRow[1];
			int r_1_c_3 = firstRow[2];
			int r_2_c_1 = secondRow[1];
			int r_2_c_2 = secondRow[2];
			int r_2_c_3 = secondRow[3];
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
			List<Map<String, int>> winningMoves = game.getWinningMoves(X);
			if(winningMoves.length > 0)
			{
				// then take it
				Map<String, int> finishingMove = winningMoves[0];
				game.setXAt(finishingMove["row"], finishingMove["col"]);
				return true;
			}
			
			// no winning moves, find next move instead. Let's check for edges...
			if(r_2_c_1 == O && game.getCell(2, 2) == BLANK)
			{
				game.setXAt(2, 2);
				return true;
			}
			else if(r_1_c_2 == O && game.getCell(2, 0) == BLANK)
			{
				game.setXAt(2, 0);
				return true;
			}
			else if(r_2_c_3 == O && game.getCell(0, 0) == BLANK)
			{
				game.setXAt(0, 0);
				return true;
			}
			else if(r_3_c_2 == O && game.getCell(0, 2) == BLANK)
			{
				game.setXAt(0, 2);
				return true;
			}
			
			// no edges? Let's check for corners...
			if(r_3_c_1 == O && game.getCell(0, 2) == BLANK)
			{
				game.setXAt(0, 2);
				return true;
			}
			else if(r_1_c_1 == O && game.getCell(2, 2) == BLANK)
			{
				game.setXAt(2, 2);
				return true;
			}
			else if(r_1_c_3 == O && game.getCell(2, 0) == BLANK)
			{
				game.setXAt(2, 0);
				return true;
			}
			else if(r_3_c_3 == O && game.getCell(0, 0) == BLANK)
			{
				game.setXAt(0, 0);
				return true;
			}
			
			return false;
			
		}
		
		
	
		
	}
	
	
	// ------------------------------------------------------------------------
	// ------------------------------------------------------------------------
	// Stream Impl
	StreamSubscription listen(void onData(dynamic cell),
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
}