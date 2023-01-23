package aleiiioa.components.tools;

import dn.Cooldown;

class GrappleFSM {
    
    public var synchronized_state(default,set):Launcher_State; 
        inline public function set_synchronized_state(s:Launcher_State){return synchronized_state = s;}
        
    
    public var state(get,never):Launcher_State; inline function get_state() return synchronized_state;
    
    public var claw_state:Claw_State = Open;
    public var maxLoad:Float = 1.;
    public var load:Float = 0;
    
    public var home:Bool = true;
    public var bonus:Float = 0.;

    public var cd:Cooldown;
    
    public function new(){
        cd = new Cooldown(Const.FIXED_UPDATE_FPS);
    }
    
   

}
