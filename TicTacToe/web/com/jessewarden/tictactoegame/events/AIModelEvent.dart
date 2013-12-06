part of tictactoegame;

class AIModelEvent
{
	static const String AI_MOVE_COMPLETED = "aiMoveCompleted";
	
	String type;
	
	AIModelEvent(this.type);
}