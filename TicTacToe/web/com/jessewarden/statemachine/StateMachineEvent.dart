// ported from here https://github.com/cassiozen/AS3-State-Machine
part of statemachine;

// [jwarden 12.5.2013] NOTE: Really disappoitned we can't extend a basic event class.
// The delegate method, while a working hack, seems like we developers are doing
// something wrong. I fail to see how we're supposed to pass encapsulated messages without making them a class.
// Making them a custom Object based class like below is fine, but merely provides strong-typing benefits,
// and completely ignores all the Event work the Dart team put into mirroring the Event API, 
// stream stuff non-withstanding. Either I don't get it, or they don't.
class StateMachineEvent
{
	static const String EXIT_CALLBACK = "exit";
	static const String ENTER_CALLBACK = "enter";
	static const String TRANSITION_COMPLETE = "transition complete";
	static const String TRANSITION_DENIED = "transition denied";
	
	String type;
	String fromState;
	String toState;
	String currentState;
	dynamic allowedStates;
	
	StateMachineEvent(this.type);
}