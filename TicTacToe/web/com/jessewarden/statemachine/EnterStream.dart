part of statemachine;

class EnterStream extends Stream
{
	StreamController _controller;
	StreamSubscription _subscription;
	
	StreamController get controller
	{
		return _controller;
	}
	
	EnterStream()
	{
		_controller = new StreamController.broadcast(onCancel: _onCancel);
	}
	
	StreamSubscription listen(void onData(dynamic stateChangeObject),
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
}