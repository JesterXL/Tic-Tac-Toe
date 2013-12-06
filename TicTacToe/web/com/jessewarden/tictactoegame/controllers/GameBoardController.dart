part of tictactoegame;

class GameBoardController
{
	static const num SIZE = 72;

	CanvasElement	canvas;
	CanvasRenderingContext2D	context;
	PieceX	xPiece;
	PieceO	oPiece;
	TicTacToeBoard	board;
	GameModel	gameModel;
	StateMachine fsm;
	
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
		fsm.addState("ready", enter: onEnterReady, exit: onExitReady, from: "*");
		fsm.addState("computerTurn", enter: onEnterComputerTurn, exit: onExitComputerTurn, from: "*");
		fsm.addState("playerTurn", enter: onEnterPlayerTurn, exit: onExitPlayerTurn, from: "*");
		fsm.addState("youWin", enter: onEnterYouWin, exit: onExitYouWin, from: "*");
		fsm.addState("youLose", enter: onEnterYouLose, exit: onExitYouLose, from: "*");
		fsm.initialState = "ready";
		
		gameModel = new	GameModel();
		gameModel.resetGame();
		gameModel.listen(onGameModelChanged);
		resetBoard();
//		canvas.onClick.listen(onCanvasClicked);
	}
	
	void resetBoard()
	{
		context.clearRect(0, 0,	canvas.width, canvas.height);
		board.draw(context,	new	Point(0, 0));
	}
	
	void onGameModelChanged(dynamic	changeData)
	{
		updateBoard(changeData);
	}
	
	void updateBoard(dynamic	changeData)
	{
		num	XTarget	=	changeData["col"] * SIZE;
		num	YTarget	=	changeData["row"] * SIZE;
		Point	p	=	new	Point(XTarget,	YTarget);
		int	value	=	changeData["value"]	as	int;
		if(value ==	GameModel.X)
		{
			xPiece.draw(context, p);
		}
		else if(value == GameModel.O)
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
		gameModel.setXAt(row, col);
	}
	
	// --------------------------------------------------------------------------------------------------
	// --------------------------------------------------------------------------------------------------
	// State Changes
	void onEnterReady()
	{
		resetBoard();
	}
	
	void onExitReady()
	{
	
	}
	
	void onEnterComputerTurn()
	{
	
	}
	
	void onExitComputerTurn()
	{
	
	}
	
	void onEnterPlayerTurn()
	{
	
	}
	
	void onExitPlayerTurn()
	{
	
	}
	
	void onEnterYouWin()
	{
	
	}
	
	void onExitYouWin()
	{
	
	}
	
	void onEnterYouLose()
	{
	
	}
	
	void onExitYouLose()
	{
	
	}
	// --------------------------------------------------------------------------------------------------
	// --------------------------------------------------------------------------------------------------
		
}