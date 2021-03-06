part of tictactoeunittests;

class TestGame
{
  _tests()
  {
    group('StateMachine', ()
    {
		Game game;
		
		setUp(()
		{
			game = new Game();
		});
		
		tearDown(()
		{
			game = null;
		});
		
		test("Starts out blank.", ()
		{
			expect(game.isBlank, true);
		});
		
		test("No winners.", ()
		{
			expect(game.xIsWinner, false);
			expect(game.oIsWinner, false);
		});
		
		test("Simple X move still indicates no winner", ()
		{
			game.setXAt(0, 0);
			expect(game.xIsWinner, false);
			expect(game.oIsWinner, false);
		});
		
		test("Simple O move still indicates no winner", ()
		{
			game.setOAt(0, 0);
			expect(game.xIsWinner, false);
			expect(game.oIsWinner, false);
		});
		
		test("top x line makes x the winner", ()
		{
			game.setXAt(0, 0);
			game.setXAt(0, 1);
			game.setXAt(0, 2);
			expect(game.xIsWinner, true);
			expect(game.oIsWinner, false);
		});
		
//		test("no winning moves at beginning", ()
//		{
//			List<Map<String, int>> winningMoves = getWinningMoves(game);
//			expect(winningMoves.length, 0);
//		});
		
		
    });
  }

  run() {
    _tests();
  }
}