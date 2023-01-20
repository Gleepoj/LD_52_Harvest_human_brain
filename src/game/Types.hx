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


enum abstract Grapple_State(String) to String {
	var Idle;
	var Recall;
	var Docked;
	var Loaded;
}

enum abstract GrappleFSM_Transition(String) to String {
	var Idle_to_Recall;
	var Recall_to_Idle;
	var Recall_to_Docked;
	var Docked_to_Load;
	var Load_to_Loaded;
	var Load_to_Launch;
	var Loaded_to_Launch;
	var Launch_to_Idle;
	var Launch_to_Recall;
	var Empty_Transition;
}

enum abstract GrappleState(String) to String {
	var Idle;
	var Charge;
	var Launch;
	var Rewind;
	var Autorewind;
}

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