/**	This enum is used by the Controller class to bind general game actions to actual keyboard keys or gamepad buttons. **/


enum abstract GameAction(Int) to Int {
	var MoveLeft;
	var MoveRight;
	var MoveUp;
	var MoveDown;

	var TriggerLeft;
	var TriggerRight;
	
	var Rb;
	var Lb;
	
	var ActionX;
	var ActionY;
	var Jump;
	var Interaction;

	var Pause;
	var Restart;

	var DebugTurbo;
	var DebugSlowMo;
	var ScreenshotMode;

	var MenuCancel;
}

enum Affect {
	Stun;
}

enum AreaEquation {
	EqCurl;
	EqDiverge;
	EqConverge;
	EqRepel;
}

enum AreaInfluence {
	AiSmall;
	AiMedium;
	AiLarge;
}

enum abstract LevelMark(Int) to Int {
	var Coll_Wall;
}


enum abstract Launcher_State(String) to String {
	var Idle;
	var Recall;
	var Docked;
	var Loaded;
	var Expulse;
}


// Old version 
enum abstract GrappleState(String) to String {
	var Idle;
	var Charge;
	var Launch;
	var Rewind;
	var Autorewind;
}

// Old Version
enum abstract LauncherState(String) to String {
	var Idle;
	var Recall;
	var Load;
	var Docked;
	var Expulse;
}


	

enum abstract LevelSubMark(Int) to Int {
	var None; // 0
}