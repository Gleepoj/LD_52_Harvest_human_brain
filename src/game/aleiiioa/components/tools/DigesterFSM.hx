package aleiiioa.components.tools;

import aleiiioa.components.core.rendering.DebugLabel;
import dn.Cooldown;

typedef Transition_Digest = {from:Digester_State,to:Array<Digester_State>};
typedef Order_Digest      = {from:Digester_State,to:Digester_State};

class DigesterFSM {
        
    var legal:String = "";
    var state:Digester_State;
   
    var allowed_transitions:Array<Transition_Digest>;
    var registered_transition:Null<Order_Digest>;
    
    public var currentState(get,never):Digester_State; inline function get_currentState() return state;    
    public var cd:Cooldown;
    
    public function new(){
        
        cd = new Cooldown(Const.FIXED_UPDATE_FPS);
        state = Free;
        
        allowed_transitions = [
            {from:Free,   to : [Digest]},
            {from:Digest, to : [Accept,Reject]},
            {from:Accept, to : [Spit]},
            {from:Reject, to : [Spit]},
            {from:Spit,   to : [Free]}
        ];
        
    }
    
    public function next(next_state:Digester_State){
       
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

