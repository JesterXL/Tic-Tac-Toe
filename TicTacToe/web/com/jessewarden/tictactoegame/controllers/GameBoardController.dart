part of tictactoegame;

class GameBoardController
{
	static const num SIZE = 72;
	static const num MARGIN_LEFT = 125;
	static const num MARGIN_TOP = 147;

	CanvasElement canvas;
	CanvasElement textCanvas;
	CanvasRenderingContext2D context;
	
	PieceX xPiece;
	PieceO oPiece;
	TicTacToeBoard board;
	StatusText statusText;
	
	GameModel gameModel;
	AIModel aiModel;
	StateMachine fsm;
	StreamSubscription canvasClickSubscription;
	Timer waitTimer;
	
	GameBoardController(CanvasElement canvas, CanvasElement textCanvas)
	{
		this.canvas	= canvas;
		context	= canvas.context2D;
		this.textCanvas = textCanvas;
	}
	
	void init()
	{
		board = new	TicTacToeBoard();
		List loaders = [];
		loaders.add(board.loadImage());
		xPiece = new PieceX();
		loaders.add(xPiece.loadImage());
		oPiece = new PieceO();
		loaders.add(oPiece.loadImage());
		statusText = new StatusText(textCanvas);
		loaders.addAll(statusText.loadImages());
		
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
		fsm.addState("tie", enter: onEnterTie, exit: onExitTie, from: "*");
		fsm.initialState = "idle";
		
		statusText.showText(StatusText.AIS_TURN);
		resetBoard();
		
		gameModel = new	GameModel();
		gameModel.startGame();
		gameModel.listen(onGameModelChanged);
		
		aiModel = new AIModel(gameModel);
		aiModel.listen(onAIModelEvent);
		
		fsm.changeState("computerTurn");
	}
	
	void startGame()
	{
		gameModel.startGame();
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
		changeTurns("playerTurn");
	}
	
	void changeTurns(String who)
	{
		if(gameModel.game.xIsWinner)
		{
			fsm.changeState("youLose");
		}
		else if(gameModel.game.oIsWinner)
		{
			fsm.changeState("youWin");
		}
		else if(gameModel.game.isFull)
		{
			fsm.changeState("tie");
		}
		else
		{
			fsm.changeState(who);
		}
		
	}
	
	void updateBoard(CellChangeEvent event)
	{
		if(event.type == CellChangeEvent.CELL_CHANGED)
		{
			assert(event.col != null);
			assert(event.row != null);
			assert(event.value != null);
			num	XTarget	=	event.col * SIZE;
			num	YTarget	=	event.row * SIZE;
			XTarget += MARGIN_LEFT;
			YTarget += MARGIN_TOP;
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
		else
		{
			resetBoard();
		}
	}
	
	void onCanvasClicked(MouseEvent	event)
	{
		num	x = event.offset.x;
		num	y = event.offset.y;
//		num offsetX = event.offset.x;
//		num clientX = event.client.x;
//		num layerX = event.layer.x;
//		num pageX = event.page.x;
//		num screenX = event.screen.x;
//		print("offset: $offsetX, clientX: $clientX, layerX: $layerX, pageX: $pageX, screenX: $screenX");
		x -= MARGIN_LEFT;
		y -= MARGIN_TOP;
		num	col	= x	/ SIZE;
		col	= col.floor();
		num	row	= y	/ SIZE;
		row	= row.floor();
		row	= min(row,	2);
		col	= min(col,	2);
		
		print("x:	$x,	y:	$y,	row:	$row,	col:	$col");
		print(gameModel.game.mdarray[0]);
		if(gameModel.game.getCell(row, col) == Game.BLANK)
		{
			gameModel.game.setOAt(row, col);
			print("Player chose, setting state to computer turn.");
			changeTurns("computerTurn");
		}
	}
	
	void stopTimer()
	{
		if(waitTimer != null)
		{
			waitTimer.cancel();
			waitTimer = null;
		}
	}
	
	void startTimer(Function callback)
	{
		stopTimer();
		const TIMEOUT = const Duration(seconds: 4);
		waitTimer = new Timer(TIMEOUT, callback);
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
		statusText.showText(StatusText.AIS_TURN);
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
		statusText.showText(StatusText.YOUR_TURN);
		canvasClickSubscription = textCanvas.onClick.listen(onCanvasClicked);
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
		statusText.showText(StatusText.YOU_WIN);
		startTimer(startGame);
	}
	
	void onExitYouWin(StateMachineEvent event)
	{
		print("onExitYouWin");
	}
	
	void onEnterYouLose(StateMachineEvent event)
	{
		print("onEnterYouLose");
		statusText.showText(StatusText.YOU_LOSE);
		startTimer(startGame);
	}
	
	void onExitYouLose(StateMachineEvent event)
	{
		print("onExitYouLose");
	}
	
	void onEnterTie(StateMachineEvent event)
	{
		print("onEnterTie");
		statusText.showText(StatusText.TIE);
		startTimer(startGame);
	}
	
	void onExitTie(StateMachineEvent event)
	{
		print("onExitYouLose");
	}
	
	// --------------------------------------------------------------------------------------------------
	// --------------------------------------------------------------------------------------------------
		
}