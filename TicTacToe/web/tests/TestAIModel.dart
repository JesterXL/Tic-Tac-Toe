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
				expect(gameModel.game.isBlank, true);
				bool result = aiModel.calculateNextMove();
				expect(result, true);
				expect(gameModel.game.getCell(1, 1), Game.X);
			});
			
			// FIXME: test is now async
//			test("First move center upon state change", ()
//			{
//				expect(gameModel.game.isBlank, true);
//				aiModel.fsm.changeState("thinking");
//				expect(gameModel.game.getCell(1, 1), Game.X);
//			});
			

			
			test("3 list types have 1 hole", ()
			{
				List<int> list1 = [1, 1, 0];
				List<int> list2 = [1, 0, 1];
				List<int> list3 = [0, 1, 1];
				expect(aiModel.listHasHole(list1, 1), true);
				expect(aiModel.listHasHole(list2, 1), true);
				expect(aiModel.listHasHole(list3, 1), true);
    		});
			
			test("3 list types have no holes", ()
			{
				List<int> list1 = [0, 0, 1];
				List<int> list2 = [0, 1, 0];
				List<int> list3 = [1, 0, 0];
				expect(aiModel.listHasHole(list1, 1), false);
				expect(aiModel.listHasHole(list2, 1), false);
				expect(aiModel.listHasHole(list3, 1), false);
    		});
			
		
		
    });
  }

  run() {
    _tests();
  }
}