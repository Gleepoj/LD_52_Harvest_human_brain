package aleiiioa.components.tools;

import aleiiioa.components.core.rendering.DebugLabel;
import dn.Cooldown;


private typedef Transition = {from:Launcher_State,to:Array<Launcher_State>};
private typedef Order      = {from:Launcher_State,to:Launcher_State};

class LauncherFSM {
        
    var legal:String = "";
    var state:Launcher_State = Recall;
   
    var allowed_transitions:Array<Transition>;
    var registered_transition:Null<Order>;
    
    public var xSpeed:Float = 0;
    public var angle:Float = 0 - Math.PI/4;
    public var velocity:Float = 0;
    public var acceleration:Float =0;
    public var damping:Float = 0.995;
        
    public var direction:Int = 0;
    public var currentState(get,never):Launcher_State; inline function get_currentState() return state;
    
    public var cd:Cooldown;
    
    public function new(){
        cd = new Cooldown(Const.FIXED_UPDATE_FPS);
        state = Recall;
        
        allowed_transitions = [
            {from:Idle,   to : [Recall]},
            {from:Recall, to : [Docked]},// remove idle
            {from:Docked, to : [Loaded]},// remove expulse
            {from:Loaded, to : [Expulse]},
            {from:Expulse,to : [Recall]}
        ];
        
    }
    
    public function next(next_state:Launcher_State){
       
        if(currentState == next_state){
            return;
        }
        
        for(transition in allowed_transitions){
            if(transition.from == state){
                for(to in transition.to){
                    if(next_state == to){
                        registered_transition = {from:state,to:next_state};
                    }
                }
            }
        }
        switchToRegisteredTransition();
    }

    function switchToRegisteredTransition() {
        if(registered_transition != null){
            state = registered_transition.to;
            registered_transition = null;            
        }  
    }
    
    public function debugLabelUpdate(label:DebugLabel){
            label.v = "";
            var state = currentState;
            var trans = registered_transition;
            var leg   = legal;
            label.v = 'cur:$state t:$trans leg:$leg';
    }

}
