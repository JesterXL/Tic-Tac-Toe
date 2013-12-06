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
		 _controller = new StreamController(
			onPause: _onPause,
			onResume: _onResume,
			onCancel: _onCancel);
		 _game = new Game();
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
  
  
  
}