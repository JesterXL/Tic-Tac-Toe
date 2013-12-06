part of statemachine;

class StateMachine extends Stream
{
	String id;
	String _state;
	Map _states;
	State parentState;
	List parentStates;
	List path;
	
	StreamController _controller;
  	StreamSubscription _subscription;
	
	StateMachine()
	{
		_states = new Map();
		_controller = new StreamController(
		    onPause: _onPause,
		    onResume: _onResume,
		    onCancel: _onCancel);
	}
	
	// ------------------------------------------------------------------------
	// ------------------------------------------------------------------------
	// Stream Impl
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
	
	void _onPause()
	{
		_subscription.pause();
	}
	
	void _onResume()
	{
		_subscription.resume();
	}
//	
//	void _onData(dynamic value)
//	{
//		_controller.add(value);
//	}
	
	void _onDone()
	{
		_controller.close();
	}
	// ------------------------------------------------------------------------
	// ------------------------------------------------------------------------

	void addState(String stateName, dynamic stateData)
	{
		if(stateData == null)
		{
			stateData = {};
		}
		_states[stateName] = new State(name: stateName,
										from: stateData.from,
										enter: stateData.enter,
										exit: stateData.exit,
										parent: _states[stateData.parent]);
		
	}
	
	void set initialState(String stateName)
	{
		if(_state == null && _states.containsKey(stateName))
		{
			_state = stateName;
//			var _callbackEvent:StateMachineEvent = new StateMachineEvent(StateMachineEvent.ENTER_CALLBACK);
//			_callbackEvent.toState = stateName;
			if(_states[_state].root)
			{
				parentStates = _states[_state].parents;
				for(var j=_states[_state].parents.length - 1; j>=0; j--)
				{
					if(parentStates[j].enter)
					{
						_callbackEvent.currentState = parentStates[j].name;
						//parentStates[j].enter.call(null, _callbackEvent);// TODO: figure out syntac
					}
				}
			}
			
			if(_states[_state].enter)
			{
				_callbackEvent.currentState = _state;
				_states[_state].enter.call(null, _callbackEvent); // TODO: figure out syntac
			}
			// TODO: handle event/stream
//			_outEvent = new StateMachineEvent(StateMachineEvent.TRANSITION_COMPLETE);
//			_outEvent.toState = stateName;
//			dispatchEvent(_outEvent);
		}
	}
	
	String get state
	{
		return _states[_state];
	}
	
	Map get states
	{
		return _states;
	}
	
	State getStateByName(String name)
	{
		State foundState = null;
		return _states.firstWhere((State s)
		{
			if(s.name == name)
			{
				foundState = s;
			}
		});
		return foundState;
	}
	
	bool canChangeStateTo(String stateName)
	{
		return (stateName != _state && _states[stateName].from.indexOf(_state) != -1 || _states[stateName].from == "*");
	}
	
	List findPath(String stateFrom, String stateTo)
	{
		// Verifies if the states are in the same "branch" or have a common parent
		State fromState = _states[stateFrom];
		int c = 0;
		int d = 0;
		while(fromState != null)
		{
			d=0;
			State toState = _states[stateTo];
			while(toState != null)
			{
				if(fromState == toState)
				{
					// They are in the same brach or have a common parent Common parent
					return [c,d];
				}
				d++;
				toState = toState.parent;
			}
			c++;
			fromState = fromState.parent;
		}
		// No direct path, no commom parent: exit until root then enter until element
		return [c,d];
	}
	
	void changeState(String stateTo)
	{
		// If there is no state that maches stateTo
		if(_states.containsKey(stateTo) == false)
		{
			print("[StateMachine] id $id Cannot make transition: State $stateTo is not defined");
			return;
		}
		
		// If current state is not allowed to make this transition
		if(!canChangeStateTo(stateTo))
		{
			trace("[StateMachine] id $id Transition to $stateTo denied");
			// TODO: figure out event/stream
//			_outEvent = new StateMachineEvent(StateMachineEvent.TRANSITION_DENIED);
//			_outEvent.fromState = _state;
//			_outEvent.toState = stateTo;
//			_outEvent.allowedStates = _states[stateTo].from;
//			dispatchEvent(_outEvent);
			return;
		}
		
		// call exit and enter callbacks (if they exits)
		path = findPath(_state, stateTo);
		if(path[0] > 0)
		{
			// TODO: figure out stream/event
//			var _exitCallbackEvent:StateMachineEvent = new StateMachineEvent(StateMachineEvent.EXIT_CALLBACK);
//			_exitCallbackEvent.toState = stateTo;
//			_exitCallbackEvent.fromState = _state;
			if(_states[_state].exit != null)
			{
//				_exitCallbackEvent.currentState = _state;
//				_states[_state].exit.call(null,_exitCallbackEvent);
			}
			parentState = _states[_state];
			for(var i=0; i<path[0]-1; i++)
			{
				parentState = parentState.parent;
				if(parentState.exit != null)
				{
//					_exitCallbackEvent.currentState = parentState.name;
//					parentState.exit.call(null,_exitCallbackEvent);
				}
			}
		}
		String oldState = _state;
		_state = stateTo;
		if(path[1] > 0)
		{
//			var _enterCallbackEvent:StateMachineEvent = new StateMachineEvent(StateMachineEvent.ENTER_CALLBACK);
//			_enterCallbackEvent.toState = stateTo;
//			_enterCallbackEvent.fromState = oldState;
			if(_states[stateTo].root)
			{
				parentStates = _states[stateTo].parents;
				for(var k = path[1]-2; k>=0; k--)
				{
					if(parentStates[k] && parentStates[k].enter)
					{
//						_enterCallbackEvent.currentState = parentStates[k].name;
//						parentStates[k].enter.call(null,_enterCallbackEvent);
					}
				}
			}
			
			if(_states[_state].enter)
			{
//				_enterCallbackEvent.currentState = _state;
//				_states[_state].enter.call(null,_enterCallbackEvent);
			}
			print("[StateMachine] id $id State Changed to $_state");
			
			// Transition is complete. dispatch TRANSITION_COMPLETE
//			_outEvent = new StateMachineEvent(StateMachineEvent.TRANSITION_COMPLETE);
//			_outEvent.fromState = oldState ;
//			_outEvent.toState = stateTo;
//			dispatchEvent(_outEvent);
		}
		
	}
	
	
}