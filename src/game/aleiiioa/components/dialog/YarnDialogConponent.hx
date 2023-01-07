package aleiiioa.components.dialog;

import aleiiioa.systems.dialog.DialogEvent;
import aleiiioa.systems.dialog.DialogEvent.InstancedDialogEvent;

import hxyarn.program.VirtualMachine.ExecutionState;
import haxe.Exception;

import hxyarn.dialogue.Dialogue;
import hxyarn.dialogue.VariableStorage.MemoryVariableStore;
import hxyarn.dialogue.StringInfo;
import hxyarn.dialogue.Line;
import hxyarn.dialogue.Command;
import hxyarn.dialogue.Option;
import hxyarn.dialogue.OptionSet;
import hxyarn.compiler.Compiler;
import hxyarn.compiler.CompilationJob;


class YarnDialogConponent {
  
    var yarnFilePath:DialogReferenceComponent;
   
	var events :InstancedDialogEvent; 
	public var optionCount:Int;
	public var currentEvent:DialogEvent;
	public var currentText:String;
	public var currentOptions:Array<String>;
	
    
	public var dialogue:Dialogue;
    public var isComplete:Bool = false;

	var storage = new MemoryVariableStore();
	var stringTable:Map<String, StringInfo>;
	
    
    public function new(_yarnFilePath:DialogReferenceComponent) {

        yarnFilePath = _yarnFilePath;
		
		currentOptions = null;
		events = new InstancedDialogEvent();
        
        dialogue = new Dialogue(new MemoryVariableStore());
		dialogue.logDebugMessage = this.logDebugMessage;
		dialogue.logErrorMessage = this.logErrorMessage;
		dialogue.lineHandler = this.lineHandler;
		dialogue.optionsHandler = this.optionsHandler;
		dialogue.commandHandler = this.commandHandler;
		dialogue.nodeCompleteHandler = this.nodeCompleteHandler;
		dialogue.nodeStartHandler = this.nodeStartHandler;
		dialogue.dialogueCompleteHandler = this.dialogueCompleteHandler;

		var job = CompilationJob.createFromStrings([yarnFilePath.res.entry.getText()], [yarnFilePath.res.entry.name]);
		var compilerResults = Compiler.compile(job);
		stringTable = compilerResults.stringTable;

		dialogue.addProgram(compilerResults.program);
	
    }


	public function start() {
		dialogue.setNode("Start");
        dialogue.resume();
	}

	function setUp(fileName:String) {}

	public function lineHandler(line:Line):HandlerExecutionType {
		var text = getComposedTextForLine(line);
		currentText = text;
		currentEvent = events.speak;

		return HandlerExecutionType.ContinueExecution;
	}

	public function optionsHandler(options:OptionSet) {
		optionCount = options.options.length;
		currentOptions = new Array<String>();
		var count:Int = -1;

		for (option in options.options) {
			var text = getComposedTextForLine(option.line);
			currentOptions.push(text);
			count += 1;
			currentEvent = events.ask;
		}

	}

	public function getComposedTextForLine(line:Line):String {
		var substitutedText = Dialogue.expandSubstitutions(stringTable[line.id].text, line.substitutions);

		var markup = dialogue.parseMarkup(substitutedText);

		return markup.text;
	}

    
	public function logDebugMessage(message:String):Void {
		//trace('DEBUG: $message');
	}

	public function logErrorMessage(message:String):Void {
		//trace('Error: $message');
	}

	public function commandHandler(command:Command) {
		trace('Command: ${command.text}');
	}

	public function nodeCompleteHandler(nodeName:String) {}

	public function nodeStartHandler(nodeName:String) {}

	public function dialogueCompleteHandler() {
        isComplete = true; 
		currentEvent = events.end;
	}

	function assertString(expected:String, actual:String) {
		if (expected != actual)
			throw new Exception('Expected: "$expected", but got "$actual"');
	}

	function assertBool(expected:Bool, actual:Bool) {
		if (expected != actual)
			throw new Exception('Expected: "$expected", but got "$actual"');
	}

	function assertInt(expected:Int, actual:Int) {
		if (expected != actual)
			throw new Exception('Expected: "$expected", but got "$actual"');
	}
}

