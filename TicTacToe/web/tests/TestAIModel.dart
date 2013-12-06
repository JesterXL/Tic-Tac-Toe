part of tictactoeunittests;

class TestAIModel
{
  _tests()
  {
    group('AIModel', ()
    {
			AIModel aiModel;
			GameModel gameModel;
			
			setUp(()
			{
				gameModel = new GameModel();
				aiModel = new AIModel(gameModel);
				
			});
			
			tearDown(()
			{
				aiModel = null;
				gameModel = null;
			});
			
			test("First move center.", ()
			{
				bool result = aiModel.calculateNextMove();
				expect(result, true);
				expect(gameModel.game.getCell(1, 1), Game.X);
			});
			
			test("First move center upon state change", ()
			{
				aiModel.fsm.changeState("thinking");
				expect(gameModel.game.getCell(1, 1), Game.X);
			});
			
		
		
    });
  }

  run() {
    _tests();
  }
}