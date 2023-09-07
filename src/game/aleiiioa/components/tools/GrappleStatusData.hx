package aleiiioa.components.tools;

import dn.Cooldown;

class GrappleStatusData {
    
    public var synchronized_state(default,set):Launcher_State; 
        inline public function set_synchronized_state(s:Launcher_State){return synchronized_state = s;}
        
    
    public var state(get,never):Launcher_State; inline function get_state() return synchronized_state;

    public var claw_state:Claw_State = Open;
    public var grab_state:Bool = false;

    public var maxLoad:Float = 1.;
    public var load:Float = 0;
    
    public var home:Bool = true;
    public var bonus:Float = 0.;
    
    public var cd:Cooldown;    

    public var onDock(get,never):Bool ; inline function get_onDock() return synchronized_state == Loaded || synchronized_state == Charging || synchronized_state == Charged ;
    public var onGrab(get,never):Bool ; inline function get_onGrab() return grab_state == true;
    public var onLock(get,never):Bool ; inline function get_onLock() return onDock == true && onGrab == true;
    public var onRelease(get,never):Bool; inline function get_onRelease() return cd.has("On_release");

    
    public function new(){
        cd = new Cooldown(Const.FIXED_UPDATE_FPS);
    }
    
   
    public function lock(){
        if(claw_state != Close)
        claw_state = Close;
    }

    public function docked() {
        if(claw_state != Load )
        claw_state = Load;
    }

    public function released() {
        if(claw_state != Open ){
            claw_state = Open;
            cd.setS("On_release",0.005);
        }
    }

}