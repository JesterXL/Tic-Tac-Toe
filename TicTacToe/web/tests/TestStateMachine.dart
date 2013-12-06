part of tictactoeunittests;

class TestStateMachine
{
  _tests()
  {
    group('StateMachine', ()
    {
		StateMachine stateMachine;
		
		setUp(()
		{
			stateMachine = new StateMachine();
		});
		
		tearDown(()
		{
			stateMachine = null;
		});
		
		test("Initial State is null", ()
		{
			expect(stateMachine.state, isNull);
		});
		
		test("Initial state is null with a state added", ()
		{
			stateMachine.addState("stopped");
			expect(stateMachine.state, isNull);
		});
		
		test("Initial state is not null when initialState is set", ()
		{
			String initialState = "initial";
			stateMachine.addState(initialState);
			stateMachine.addState("stopped");
			stateMachine.initialState  = initialState;
			expect(stateMachine.state, initialState);
		});
		
		test("enterCallback works", ()
		{
			bool hitCallback = false;
			Function callback = (StateMachineEvent event)
			{
				expect(event.toState, "playing");
				expect(event.fromState, "idle");
				hitCallback = true;
			};
			stateMachine.addState("idle");
			stateMachine.addState("playing", enter: callback, from: "*");
			stateMachine.initialState = "idle";
			expect(stateMachine.canChangeStateTo("playing"), true);
			expect(stateMachine.changeState("playing"), true);
			expect(stateMachine.state, "playing");
			expect(hitCallback, true);
		});

		test("prevent initial enter event", ()
		{
			bool hitCallback = false;
			Function callback = (StateMachineEvent event)
			{
				hitCallback = true;
			};
			stateMachine.addState("idle");
			stateMachine.addState("playing", enter: callback, from: "*");
			stateMachine.initialState = "idle";
			expect(hitCallback, false);
		});
		
		test("exit callback works", ()
		{
			bool hitCallback = false;
			Function callback = (StateMachineEvent event)
			{
				hitCallback = true;
			};
			stateMachine.addState("idle", exit: callback);
			stateMachine.addState("playing", from: "*");
			stateMachine.initialState = "idle";
			stateMachine.changeState("playing");
			expect(hitCallback, true);
		});

//
//function test_ensurePathAcceptable()
//        machine:addState("prone")
//        machine:addState("standing", {from="*"})
//        machine:addState("running", {from={"standing"}})
//        machine:setInitialState("standing")
//        assert_true(machine:changeState("running"), "Failed to ensure correct path.")
//end
//
//function test_ensurePathUnacceptable()
//        machine:addState("prone")
//        machine:addState("standing", {from="*"})
//        machine:addState("running", {from={"standing"}})
//        machine:setInitialState("prone")
//        assert_false(machine:changeState("running"), "Failed to ensure correct path.")
//end
//
//function test_hierarchical()
//        local t = {}
//        local calledonAttack = false
//        local calledOnMeleeAttack = false
//        function t.onAttack(event)
//                calledonAttack = true
//        end
//
//        function t.onMeleeAttack(event)
//                calledOnMeleeAttack = true
//        end
//
//        machine:addState("idle", {from="*"})
//        machine:addState("attack",{from = "idle", enter = t.onAttack})
//        machine:addState("melee attack", {parent = "attack", from = "attack", enter = t.onMeleeAttack})
//        machine:addState("smash",{parent = "melee attack", enter = t.onSmash})
//        machine:addState("missle attack",{parent = "attack", enter = onMissle})
//
//        machine:setInitialState("idle")
//
//        assert_true(machine:canChangeStateTo("attack"), "Cannot change to state attack from idle!?")
//        assert_false(machine:canChangeStateTo("melee attack"), "Somehow we're allowed to change to melee attack even though we're not in the attack base state.")
//        assert_false(machine:changeState("melee attack"), "We're somehow allowed to bypass the attack state and go straigt into the melee attack state.")
//        assert_true(machine:changeState("attack"), "We're not allowed to go to the attack state from the idle state?")
//        assert_false(machine:canChangeStateTo("attack"), "We're allowed to change to a state we're already in?")
//        assert_true(machine:canChangeStateTo("melee attack"), "We're not allowed to go to our child state melee attack from attack?")
//        assert_true(machine:changeState("melee attack"), "I don't get it, we're in the parent attack state, why can't we change?")
//        assert_true(machine:canChangeStateTo("smash"), "We're not allowed to go to our smash child state from our parent melee attack state?")
//        
//        assert_true(machine:canChangeStateTo("attack"), "We're not allowed to go back to our parent attack state?")
//        assert_true(machine:changeState("smash"), "We're not allowed to actually change state to our smash child state.")
//        assert_false(machine:changeState("attack"))
//        assert_true(machine:changeState("melee attack"))
//        assert_true(machine:canChangeStateTo("attack"))
//        assert_true(machine:canChangeStateTo("smash"))
//        assert_true(machine:changeState("attack"))
//end

//      test('Constructor minimum args', () {
//        // Create a Notification with a name only
//        String name   = "Test";
//        mvc.INotification note = new mvc.Notification( name );
//
//        // Make sure the note was created
//        expect( note, isNotNull );
//      });
//
//      test('.name, getName()', () {
//        // Create a Notification with name only
//        String name   = "Test";
//        mvc.INotification note = new mvc.Notification( name );
//
//        // Make sure the name was set
//        expect( name, equals( note.getName() ) );
//        expect( name, equals( note.name ) );
//      });
//
//      test('.type, getType()', () {
//        // Create a Notification with name and type only
//        String name   = "Test";
//        String type   = "Type";
//        mvc.INotification note = new mvc.Notification( name, null, type );
//
//        // Make Sure the type was set
//        expect( type, equals( note.getType() ) );
//        expect( type, equals( note.type ) );
//      });
//
//      test('.body, getBody()', () {
//        // Create a Notification with a body
//        String name   = "Test";
//        List<String> body  = new List<String>();
//        mvc.INotification note = new mvc.Notification( name, body );
//
//        // Make sure the body was set
//        expect( body, equals( note.getBody() ) );
//        expect( body, equals( note.body ) );
//      });
		
		
    });
  }

  run() {
    _tests();
  }
}