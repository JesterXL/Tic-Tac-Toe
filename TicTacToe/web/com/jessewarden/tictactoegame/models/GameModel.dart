part of tictactoegame;

class GameModel extends Stream
{
  
  StreamController _controller;
  StreamSubscription _subscription;
	
	Game _game;
	
	Game get game
	{
		return _game;
	}
  
	GameModel()
	{
		 _controller = new StreamController.broadcast(onCancel: _onCancel, sync: true);
		 _game = new Game();
		 // [jwarden 12.5.2013] Proxy for now.
		 _game.listen((CellChangeEvent event)
		 {
			 _controller.add(event);
		 });
	}
	
	void startGame()
	{
		_game.resetGame();
	}
  
	// ------------------------------------------------------------------------
	// ------------------------------------------------------------------------
	// Stream Impl
	StreamSubscription listen(void onData(CellChangeEvent event),
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
  
  
  
}