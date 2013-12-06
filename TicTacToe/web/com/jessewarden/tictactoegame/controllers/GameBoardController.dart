part of tictactoegame;

class GameBoardController
{
	static const num SIZE = 72;

	CanvasElement canvas;
	CanvasRenderingContext2D context;
	PieceX xPiece;
	PieceO oPiece;
	TicTacToeBoard board;
	GameModel gameModel;
	AIModel aiModel;
	StateMachine fsm;
	StreamSubscription canvasClickSubscription;
	
	GameBoardController(CanvasElement	canvas)
	{
		this.canvas	=	canvas;
		context	=	canvas.context2D;
	}
	
	void init()
	{
		board = new	TicTacToeBoard();
		List loaders	=	[];
		loaders.add(board.loadImage());
		xPiece = new	PieceX();
		loaders.add(xPiece.loadImage());
		oPiece = new	PieceO();
		loaders.add(oPiece.loadImage());
		
		Future.wait(loaders)
			.then((List	values)
			{
					onReady();
			});
	}
	
	void onReady()
	{
		fsm = new StateMachine();
		fsm.addState("idle", from: "*");
		fsm.addState("ready", enter: onEnterReady, exit: onExitReady, from: "*");
		fsm.addState("computerTurn", enter: onEnterComputerTurn, exit: onExitComputerTurn, from: "*");
		fsm.addState("playerTurn", enter: onEnterPlayerTurn, exit: onExitPlayerTurn, from: "*");
		fsm.addState("youWin", enter: onEnterYouWin, exit: onExitYouWin, from: "*");
		fsm.addState("youLose", enter: onEnterYouLose, exit: onExitYouLose, from: "*");
		fsm.initialState = "idle";
		
		resetBoard();
		
		gameModel = new	GameModel();
		gameModel.startGame();
		gameModel.listen(onGameModelChanged);
		
		aiModel = new AIModel(gameModel);
		aiModel.listen(onAIModelEvent);
		
		fsm.changeState("computerTurn");
	}
	
	void resetBoard()
	{
		context.clearRect(0, 0,	canvas.width, canvas.height);
		board.draw(context,	new	Point(0, 0));
	}
	
	void onGameModelChanged(CellChangeEvent event)
	{
		updateBoard(event);
	}
	
	void onAIModelEvent(AIModelEvent event)
	{
		fsm.changeState("playerTurn");
	}
	
	void updateBoard(CellChangeEvent event)
	{
		assert(event.col != null);
		assert(event.row != null);
		assert(event.value != null);
		num	XTarget	=	event.col * SIZE;
		num	YTarget	=	event.row * SIZE;
		Point	p	=	new	Point(XTarget,	YTarget);
		int	value	=	event.value;
		if(value ==	Game.X)
		{
			xPiece.draw(context, p);
		}
		else if(value == Game.O)
		{
			oPiece.draw(context, p);
		}
	}
	
	void onCanvasClicked(MouseEvent	event)
	{
		num	x = event.offset.x;
		num	y = event.offset.y;
		num	col	= x	/ SIZE;
		col	= col.floor();
		num	row	= y	/ SIZE;
		row	= row.floor();
		row	= min(row,	2);
		col	= min(col,	2);
//		print("x:	$x,	y:	$y,	row:	$row,	col:	$col");
		if(gameModel.game.getCell(row, col) == Game.BLANK)
		{
			gameModel.game.setOAt(row, col);
			print("Player chose, setting state to computer turn.");
			fsm.changeState("computerTurn");
		}
	}
	
	// --------------------------------------------------------------------------------------------------
	// --------------------------------------------------------------------------------------------------
	// State Changes
	void onEnterReady(StateMachineEvent event)
	{
		print("onEnterReady");
		resetBoard();
	}
	
	void onExitReady(StateMachineEvent event)
	{
		print("onExitReady");
	}
	
	void onEnterComputerTurn(StateMachineEvent event)
	{
		print("onEnterComputerTurn");
		aiModel.onAITurn();
	}
	
	void onExitComputerTurn(StateMachineEvent event)
	{
		print("onExitComputerTurn");
		aiModel.onAITurnOver();
	}
	
	void onEnterPlayerTurn(StateMachineEvent event)
	{
		print("onEnterPlayerTurn");
		canvasClickSubscription = canvas.onClick.listen(onCanvasClicked);
	}
	
	void onExitPlayerTurn(StateMachineEvent event)
	{
		print("onExitPlayerTurn");
		canvasClickSubscription.cancel();
		canvasClickSubscription = null;
	}
	
	void onEnterYouWin(StateMachineEvent event)
	{
		print("onEnterYouWin");
	}
	
	void onExitYouWin(StateMachineEvent event)
	{
		print("onExitYouWin");
	}
	
	void onEnterYouLose(StateMachineEvent event)
	{
		print("onEnterYouLose");
	}
	
	void onExitYouLose(StateMachineEvent event)
	{
		print("onExitYouLose");
	}
	// --------------------------------------------------------------------------------------------------
	// --------------------------------------------------------------------------------------------------
		
}