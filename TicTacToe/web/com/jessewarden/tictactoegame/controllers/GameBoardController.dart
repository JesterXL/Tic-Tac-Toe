part of tictactoegame;

class GameBoardController
{
  CanvasElement canvas;
  CanvasRenderingContext2D context;
  PieceX xPiece;
  PieceO oPiece;
  TicTacToeBoard board;
  GameModel gameModel;
  static const num SIZE = 72;
  
  GameBoardController(CanvasElement canvas)
  {
    this.canvas = canvas;
    context = canvas.context2D;
  }
  
  void init()
  {
    board = new TicTacToeBoard();
    List loaders = [];
    loaders.add(board.loadImage());
    xPiece = new PieceX();
    loaders.add(xPiece.loadImage());
    oPiece = new PieceO();
    loaders.add(oPiece.loadImage());
    
    Future.wait(loaders)
      .then((List values)
          {
            onReady();
          });
  }
  
  void onReady()
  {
    gameModel = new GameModel();
    gameModel.resetGame();
    gameModel.listen(onGameModelChanged);
    resetBoard();
    canvas.onClick.listen(onCanvasClicked);
  }
  
  void resetBoard()
  {
    context.clearRect(0, 0, canvas.width, canvas.height);
    board.draw(context, new Point(0, 0));
  }
  
  void onGameModelChanged(dynamic changeData)
  {
    resetBoard();
    updateBoard(changeData);
  }
  
  void updateBoard(dynamic changeData)
  {
    num XTarget = changeData["col"] * SIZE;
    num YTarget = changeData["row"] * SIZE;
    Point p = new Point(XTarget, YTarget);
    int value = changeData["value"] as int;
    if(value == GameModel.X)
    {
      xPiece.draw(context, p);
    }
    else if(value == GameModel.O)
    {
      oPiece.draw(context, p);
    }
  }
  
  void onCanvasClicked(MouseEvent event)
  {
    num x = event.offset.x;
    num y = event.offset.y;
    num col = x / SIZE;
    col = col.floor();
    num row = y / SIZE;
    row = row.floor();
//    print("x: $x, y: $y, row: $row, col: $col");
  }
  
}