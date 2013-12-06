part of tictactoegame;

class CellChangeEvent
{
	static const String CELL_CHANGED = "cellChanged";
	static const String ALL_CELLS_CHANGED = "allCellsChanged";
	
	String type;
	int row;
	int col;
	int value;
	bool match = false;
	
	CellChangeEvent(this.type);
}