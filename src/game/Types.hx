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


/* enum abstract Launcher_State(String) to String {
	var Idle;
	var Recall;
	var Docked;
	var Loaded;
	var Expulse;
}
 */
enum abstract Launcher_State(String) to String {
	var Free;
	var Loaded;
	var Charging;
	var Charged;
	var Expulse;
}

enum abstract Claw_State(String) to String {
	var Open;
	var Close;
	var Load;
}

enum abstract Digester_State(String) to String {
	var Free;
	var Digest;
	var Accept;
	var Reject;
	var Spit;
}

enum abstract Container_State(String) to String {
	var Empty;
	var Gilles;
	var John;
}



enum abstract LevelSubMark(Int) to Int {
	var None; // 0
}