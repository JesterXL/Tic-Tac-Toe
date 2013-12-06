// ported from here https://github.com/cassiozen/AS3-State-Machine
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
		_controller = new StreamController.broadcast(onCancel: _onCancel, sync: true);
	}
	
	// ------------------------------------------------------------------------
	// ------------------------------------------------------------------------
	// Stream Impl
	StreamSubscription listen(void onData(StateMachineEvent event),
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
	
	void _onData(StateMachineEvent event)
	{
		_controller.add(event);
	}
	
	// ------------------------------------------------------------------------
	// ------------------------------------------------------------------------

	void addState(String stateName, {dynamic from:null, Function enter:null, Function exit:null, State parent:null})
	{
		try
		{
			_states[stateName] = new State(name: stateName,
											from: from,
											enter: enter,
											exit: exit,
											parent: _states[parent]);
		}
		catch(error)
		{
			print("StateMachine::addState error: $error");
		}
	}
	
	void set initialState(String stateName)
	{
		if(_state == null && _states.containsKey(stateName))
		{
			_state = stateName;
			StateMachineEvent callbackEvent = new StateMachineEvent(StateMachineEvent.ENTER_CALLBACK);
			callbackEvent.toState = stateName;
									
			if(_states[_state].root != null)
			{
				parentStates = _states[_state].parents;
				for(var j=_states[_state].parents.length - 1; j>=0; j--)
				{
					if(parentStates[j].enter)
					{
						callbackEvent.currentState = parentStates[j].name;
						parentStates[j].enter.call(null, callbackEvent);
						
					}
				}
			}
			
			if(_states[_state].enter != null)
			{
				callbackEvent.currentState = _state;
				_states[_state].enter.call(null, callbackEvent);
			}
			
			StateMachineEvent outEvent = new StateMachineEvent(StateMachineEvent.TRANSITION_COMPLETE);
			outEvent.toState = stateName;
			_controller.add(outEvent);
		}
	}
	
	String get state
	{
		if(_state != null)
		{
			return _states[_state].name;
		}
		else
		{
			return null;
		}
	}
	
	Map get states
	{
		return _states;
	}
	
	State getStateByName(String name)
	{
		return _states[name];
	}
	
	bool canChangeStateTo(String stateName)
	{
		bool notThereAlready = stateName != _state;
		bool haveNoFromState = true;
		State ourState = _states[stateName];
		if(ourState.from != null && ourState.from is String)
		{
			bool noNegativeOne = ourState.from.indexOf(_state) != -1;
			bool fromIsAny = ourState.from == "*";
			haveNoFromState = (noNegativeOne || fromIsAny);
		}
		return (notThereAlready && haveNoFromState);
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
	
	bool changeState(String stateTo)
	{
		// If there is no state that maches stateTo
		if(_states.containsKey(stateTo) == false)
		{
			print("[StateMachine] id $id Cannot make transition: State $stateTo is not defined");
			return false;
		}
		
		// If current state is not allowed to make this transition
		if(!canChangeStateTo(stateTo))
		{
			print("[StateMachine] id $id Transition to $stateTo denied");
			StateMachineEvent outEvent = new StateMachineEvent(StateMachineEvent.TRANSITION_DENIED);
			outEvent.fromState = _state;
			outEvent.toState = stateTo;
			outEvent.allowedStates = _states[stateTo].from;
			_controller.add(outEvent);
			return false;
		}
		
		// call exit and enter callbacks (if they exits)
		path = findPath(_state, stateTo);
		if(path[0] > 0)
		{
			StateMachineEvent exitCallbackEvent = new StateMachineEvent(StateMachineEvent.EXIT_CALLBACK);
			exitCallbackEvent.toState = stateTo;
			exitCallbackEvent.fromState = _state;
			if(_states[_state].exit != null)
			{
				exitCallbackEvent.currentState = _state;
				Function exitCallback = _states[_state].exit;
				exitCallback(exitCallbackEvent);
			}
			parentState = _states[_state];
			for(var i=0; i<path[0]-1; i++)
			{
				parentState = parentState.parent;
				if(parentState.exit != null)
				{
					exitCallbackEvent.currentState = parentState.name;
					Function parentExitCallback = parentState.exit;
					parentExitCallback(exitCallbackEvent);
				}
			}
		}
		String oldState = _state;
		_state = stateTo;
		if(path[1] > 0)
		{
			StateMachineEvent enterCallbackEvent = new StateMachineEvent(StateMachineEvent.ENTER_CALLBACK);
			enterCallbackEvent.toState = stateTo;
			enterCallbackEvent.fromState = oldState;
			if(_states[stateTo].root != null)
			{
				parentStates = _states[stateTo].parents;
				for(var k = path[1]-2; k>=0; k--)
				{
					if(parentStates[k] && parentStates[k].enter)
					{
						enterCallbackEvent.currentState = parentStates[k].name;
						Function parentEnterCallback = parentStates[k].enter;
						parentEnterCallback(enterCallbackEvent);
					}
				}
			}
			
			if(_states[_state].enter != null)
			{
				enterCallbackEvent.currentState = _state;
				Function enterCallback = _states[_state].enter;
				enterCallback(enterCallbackEvent);
			}
			//print("[StateMachine] id $id State Changed to $_state");
			
			// Transition is complete. dispatch TRANSITION_COMPLETE
			StateMachineEvent outEvent = new StateMachineEvent(StateMachineEvent.TRANSITION_COMPLETE);
			outEvent.fromState = oldState ;
			outEvent.toState = stateTo;
			_controller.add(outEvent);
		}
		return true;
	}
	
	
}