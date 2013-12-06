library	tictactoeunittests;

import 'dart:html';

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import '../com/jessewarden/tictactoegame/tictactoegamelib.dart';
import '../com/jessewarden/statemachine/statemachinelib.dart';

part 'TestStateMachine.dart';
part 'TestGame.dart';
part 'TestAIModel.dart';

class UnitTests
{
	UnitTests()
	{
		useHtmlEnhancedConfiguration();
	}

	void onTestResult(TestCase testCase)
	{
		write("${testCase.result} ${testCase.currentGroup}");
	}

	void write(String message)
	{
		document.querySelector('#status').innerHtml	= message;
	}

	void run()
	{
		new	TestStateMachine().run();
		new TestGame().run();
		new TestAIModel().run();
	}
}

void main()
{
	// start this mug
	new	UnitTests().run();
}